// ============================================================================
// ADX Managed Identity Policy Module - Enables Native Ingestion from ADF
// ============================================================================
// This module configures the ADX cluster's managed identity policy to allow
// native ingestion using the cluster's system-assigned managed identity.
//
// BACKGROUND:
// Azure Data Explorer requires explicit policy configuration to allow managed
// identity-based ingestion. The ingestion command uses 'managed_identity=system'
// which refers to the ADX cluster's own system-assigned identity. This policy
// must be set at the cluster level before any ingestion can occur.
//
// WHY A DEPLOYMENT SCRIPT?
// Cluster-level KQL commands (like .alter-merge cluster policy) cannot be
// executed via the Microsoft.Kusto/clusters/databases/scripts resource.
// Database scripts are limited to database-scoped commands only.
// Therefore, we use a deployment script with REST API calls.
//
// REQUIREMENTS:
// - The managed identity running this script needs "Cluster Admin" or
//   "AllDatabasesAdmin" role on the ADX cluster
// - Storage account with allowSharedKeyAccess: true for deployment script execution
//   (ACI mounts storage via access key - this is a platform limitation)
//
// REFERENCE:
// https://learn.microsoft.com/en-us/azure/data-explorer/ingest-data-managed-identity
// ============================================================================

@description('Required. Name of the Azure Data Explorer cluster.')
param clusterName string

@description('Required. Location for the deployment script resources.')
param location string = resourceGroup().location

@description('Required. Managed identity resource ID for running the script.')
param managedIdentityResourceId string

@description('Optional. Force script to run even if nothing changed. Use utcNow() when calling.')
param forceUpdateTag string = utcNow()

@description('Optional. Timeout for the script execution. Allows 3 min initial wait + 30 retries × 20s = 13 min.')
param timeout string = 'PT20M'

@description('Optional. Tags to apply to resources.')
param tags object = {}

// ============================================================================
// VARIABLES
// ============================================================================

// Generate a unique storage account name for deployment scripts
// Name starts with 'dep' to match PSRule suppression rules for dependencies
// Include forceUpdateTag for uniqueness across CI runs that reuse the same RG
var deploymentScriptStorageName = 'dep${take(uniqueString(resourceGroup().id, clusterName, forceUpdateTag), 21)}'

// Reference the ADX cluster to get its URI
resource cluster 'Microsoft.Kusto/clusters@2023-08-15' existing = {
  name: clusterName
}

// ============================================================================
// DEPLOYMENT SCRIPT STORAGE ACCOUNT
// ============================================================================
// Deployment scripts require a storage account with allowSharedKeyAccess: true
// because Azure Container Instance (ACI) can only mount storage via access keys.
// This is a platform limitation documented at:
// https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep
//
// The SecurityControl: 'Ignore' tag exempts this storage account from policies
// that enforce disabling shared key access.
resource deploymentScriptStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: deploymentScriptStorageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: union(tags, {
    'ms-resource-usage': 'azure-deployment-script'
    SecurityControl: 'Ignore'  // Exempt from policies disabling shared key access
  })
  properties: {
    // REQUIRED: ACI can only mount storage via access keys
    allowSharedKeyAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Enabled'  // Required for deployment script container access
    networkAcls: {
      defaultAction: 'Allow'  // Required for ACI access during deployment
      bypass: 'AzureServices'
    }
  }
}

// PowerShell script to configure the managed identity policy
// Uses REST API to execute KQL admin command against the cluster
// Includes retry logic to handle permission propagation delays (ADX principal assignments
// can take 1-2 minutes to become effective after the cluster is created)
// Note: The script contains Azure management URLs which are necessary for REST API calls
#disable-next-line no-hardcoded-env-urls
var policyScript = '''
$ErrorActionPreference = 'Stop'
$clusterUri = $env:CLUSTER_URI
$subId = $env:SUBSCRIPTION_ID

# Retry configuration - ADX principal assignments can take 5-10 minutes to propagate
# Increased from 20×15s to 30×20s for better handling of slow AAD propagation in CI
$maxRetries = 30
$retryDelaySeconds = 20
$initialWaitSeconds = 180  # Wait 3 minutes before first attempt for permission propagation

Write-Output "=== Configure ADX Managed Identity Policy ==="
Write-Output "Cluster URI: $clusterUri"
Write-Output "Subscription: $subId"
Write-Output "Max retries: $maxRetries (waiting ${retryDelaySeconds}s between attempts)"

# Initial wait for permission propagation - ADX role assignments can take 2-5 minutes
Write-Output "Waiting ${initialWaitSeconds} seconds for ADX role assignment propagation..."
Start-Sleep -Seconds $initialWaitSeconds
Write-Output "Initial wait complete. Starting policy configuration attempts..."

function Invoke-KqlCommandWithRetry {
    param(
        [string]$Uri,
        [hashtable]$Headers,
        [string]$Body,
        [string]$CommandDescription
    )
    
    $attempt = 0
    $lastError = $null
    
    while ($attempt -lt $maxRetries) {
        $attempt++
        try {
            Write-Output "[$CommandDescription] Attempt $attempt of $maxRetries..."
            $response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body $Body
            Write-Output "[$CommandDescription] Success on attempt $attempt"
            return $response
        }
        catch {
            $lastError = $_
            $statusCode = $_.Exception.Response.StatusCode.value__
            
            # Only retry on 401 (Unauthorized) or 403 (Forbidden) - permission propagation issues
            if ($statusCode -eq 401 -or $statusCode -eq 403) {
                if ($attempt -lt $maxRetries) {
                    Write-Output "[$CommandDescription] Got HTTP $statusCode - permission not yet propagated. Waiting ${retryDelaySeconds}s before retry..."
                    Start-Sleep -Seconds $retryDelaySeconds
                }
                else {
                    Write-Output "[$CommandDescription] Max retries reached. Permission propagation timeout."
                }
            }
            else {
                # Non-permission error, don't retry
                Write-Output "[$CommandDescription] Got HTTP $statusCode - not a permission error, failing immediately."
                throw
            }
        }
    }
    
    # If we exhausted retries, throw the last error
    throw $lastError
}

try {
    # Get access token for Kusto - use the global Kusto resource for proper audience
    # The audience must be https://kusto.kusto.windows.net (NOT the cluster-specific URI)
    # See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/authentication
    $kustoResource = 'https://kusto.kusto.windows.net'
    Write-Output "Acquiring access token for Kusto..."
    Write-Output "Target resource: $kustoResource"
    Write-Output "Cluster URI: $clusterUri"
    $kustoToken = (Get-AzAccessToken -ResourceUrl $kustoResource).Token
    Write-Output "Token acquired successfully"
    
    $headers = @{ 
        'Authorization' = "Bearer $kustoToken"
        'Content-Type' = 'application/json; charset=utf-8'
    }
    
    # The policy command allows the cluster's system-assigned managed identity for NativeIngestion
    # Using "system" as ObjectId refers to the cluster's own managed identity
    # This is required for ADF to use managed_identity=system in ingestion commands
    $kqlCommand = '.alter-merge cluster policy managed_identity ```[{"ObjectId":"system","AllowedUsages":"NativeIngestion"}]```'
    
    $body = @{
        db = "Ingestion"  # Any database works for cluster-level commands
        csl = $kqlCommand
    } | ConvertTo-Json -Compress
    
    Write-Output "Executing KQL command: $kqlCommand"
    
    $mgmtUri = "$clusterUri/v1/rest/mgmt"
    $response = Invoke-KqlCommandWithRetry -Uri $mgmtUri -Headers $headers -Body $body -CommandDescription "Set MI Policy"
    
    Write-Output "Policy configured successfully"
    Write-Output "Response: $($response | ConvertTo-Json -Depth 5)"
    
    # Verify the policy was applied
    $verifyCommand = '.show cluster policy managed_identity'
    $verifyBody = @{
        db = "Ingestion"
        csl = $verifyCommand
    } | ConvertTo-Json -Compress
    
    $verifyResponse = Invoke-KqlCommandWithRetry -Uri $mgmtUri -Headers $headers -Body $verifyBody -CommandDescription "Verify Policy"
    Write-Output "Current policy: $($verifyResponse | ConvertTo-Json -Depth 5)"
    
    $DeploymentScriptOutputs = @{ 
        status = "success"
        message = "Managed identity policy configured for NativeIngestion"
    }
    
} catch {
    Write-Error "Failed to configure managed identity policy: $_"
    Write-Error $_.Exception.Message
    if ($_.Exception.Response) {
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            Write-Error $reader.ReadToEnd()
        } catch {
            Write-Error "Could not read response body"
        }
    }
    $DeploymentScriptOutputs = @{ 
        status = "error"
        error = $_.ToString()
    }
    throw
}
'''

// ============================================================================
// RESOURCES
// ============================================================================

// Deployment script to configure the managed identity policy
// Include forceUpdateTag in name to ensure uniqueness across CI runs that reuse the same RG
resource policySetupScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'adx-mi-policy-${uniqueString(resourceGroup().id, clusterName, forceUpdateTag)}'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.0'
    retentionInterval: 'PT1H'
    timeout: timeout
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: forceUpdateTag
    environmentVariables: [
      {
        name: 'CLUSTER_URI'
        value: cluster.properties.uri
      }
      {
        name: 'SUBSCRIPTION_ID'
        value: subscription().subscriptionId
      }
    ]
    scriptContent: policyScript
    // Use our dedicated storage account with allowSharedKeyAccess: true
    // ACI requires access key authentication - this is a platform limitation
    storageAccountSettings: {
      storageAccountName: deploymentScriptStorage.name
      storageAccountKey: deploymentScriptStorage.listKeys().keys[0].value
    }
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('Status of the managed identity policy configuration.')
output status string = policySetupScript.properties.outputs.status

@description('Deployment script resource ID.')
output scriptResourceId string = policySetupScript.id

@description('Deployment script storage account name.')
output storageAccountName string = deploymentScriptStorage.name
