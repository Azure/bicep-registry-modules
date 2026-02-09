// ============================================================================
// Trigger Management Module - Enables Idempotent ADF Deployments
// ============================================================================
// This module provides PRE and POST deployment scripts that handle ADF triggers.
// ARM/Bicep cannot update triggers while they're running. This module:
//   1. STOPS all running triggers BEFORE the main deployment
//   2. STARTS all triggers AFTER deployment completes
//
// This solves the fundamental IaC problem where customers cannot redeploy
// their infrastructure without manual intervention.
//
// IMPORTANT: The managed identity needs "Data Factory Contributor" role on the
// ADF resource to manage triggers. On first deployment, this module gracefully
// handles the case where ADF doesn't exist yet.
// ============================================================================

@description('Required. Name of the Data Factory.')
param dataFactoryName string

@description('Required. Resource group name where Data Factory is located.')
param resourceGroupName string = resourceGroup().name

@description('Required. Location for the deployment script resources.')
param location string = resourceGroup().location

@description('Required. Managed identity resource ID for running the scripts.')
param managedIdentityResourceId string

@description('Optional. Existing storage account resource ID for deployment scripts. Uses the FinOps Hub storage account to avoid creating additional resources.')
param storageAccountResourceId string = ''

@description('Optional. Operation to perform: "stop" before deployment, "start" after deployment.')
@allowed(['stop', 'start'])
param operation string = 'start'

@description('Optional. Trigger names to manage. Empty means all triggers.')
param triggerNames array = []

@description('Optional. Force script to run even if nothing changed (use timestamp).')
param forceRun string = utcNow()

@description('Optional. Timeout for the script execution.')
param timeout string = 'PT10M'

// Script to stop triggers - runs BEFORE deployment
// Uses REST API directly to avoid dependency on az datafactory extension
// Note: The PowerShell scripts contain Azure management URLs which are necessary for REST API calls
#disable-next-line no-hardcoded-env-urls
var stopScript = '''
$ErrorActionPreference = 'Continue'
$factory = $env:ADF_NAME
$rg = $env:RESOURCE_GROUP
$subId = $env:SUBSCRIPTION_ID
$specificTriggers = $env:TRIGGER_NAMES

Write-Output "=== Stop Triggers Script ==="
Write-Output "Data Factory: $factory"
Write-Output "Resource Group: $rg"
Write-Output "Subscription: $subId"

try {
    # Get access token using managed identity
    $token = (Get-AzAccessToken -ResourceUrl 'https://management.azure.com').Token
    $headers = @{ 
        'Authorization' = "Bearer $token"
        'Content-Type' = 'application/json'
    }
    
    # Check if ADF exists
    $adfUri = "https://management.azure.com/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DataFactory/factories/$factory?api-version=2018-06-01"
    try {
        $adfCheck = Invoke-RestMethod -Uri $adfUri -Method Get -Headers $headers -ErrorAction Stop
        Write-Output "Data Factory exists: $($adfCheck.name)"
    } catch {
        if ($_.Exception.Response.StatusCode -eq 'NotFound') {
            Write-Output "Data Factory does not exist yet (first deployment). Skipping trigger stop."
            $DeploymentScriptOutputs = @{ stoppedTriggers = @(); status = "skipped-not-found"; triggersCount = 0 }
            exit 0
        }
        throw
    }
    
    # List all triggers
    $listUri = "https://management.azure.com/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DataFactory/factories/$factory/triggers?api-version=2018-06-01"
    $triggersResponse = Invoke-RestMethod -Uri $listUri -Method Get -Headers $headers
    
    $stoppedList = @()
    foreach ($trigger in $triggersResponse.value) {
        $triggerName = $trigger.name
        $state = $trigger.properties.runtimeState
        
        # Skip if not started or if specific triggers specified and this isn't one of them
        if ($state -ne 'Started') {
            Write-Output "Trigger $triggerName is already $state - skipping"
            continue
        }
        
        if (-not [string]::IsNullOrEmpty($specificTriggers) -and $specificTriggers -notcontains $triggerName) {
            continue
        }
        
        Write-Output "Stopping trigger: $triggerName (currently $state)"
        $stopUri = "https://management.azure.com/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DataFactory/factories/$factory/triggers/$triggerName/stop?api-version=2018-06-01"
        try {
            Invoke-RestMethod -Uri $stopUri -Method Post -Headers $headers
            $stoppedList += $triggerName
            Write-Output "  Successfully stopped: $triggerName"
        } catch {
            Write-Output "  Warning: Failed to stop $triggerName - $($_.Exception.Message)"
        }
    }

    Write-Output "=== Summary ==="
    Write-Output "Stopped $($stoppedList.Count) triggers"
    $DeploymentScriptOutputs = @{ 
        stoppedTriggers = $stoppedList
        status = "completed"
        triggersCount = $stoppedList.Count
    }
} catch {
    Write-Output "Error: $_"
    # Don't fail the deployment if we can't stop triggers
    $DeploymentScriptOutputs = @{ stoppedTriggers = @(); status = "error"; error = $_.ToString(); triggersCount = 0 }
}
'''

// Script to start triggers - runs AFTER deployment
#disable-next-line no-hardcoded-env-urls
var startScript = '''
$ErrorActionPreference = 'Stop'
$factory = $env:ADF_NAME
$rg = $env:RESOURCE_GROUP
$subId = $env:SUBSCRIPTION_ID
$specificTriggers = $env:TRIGGER_NAMES

Write-Output "=== Start Triggers Script ==="
Write-Output "Data Factory: $factory"
Write-Output "Resource Group: $rg"
Write-Output "Subscription: $subId"

try {
    # Get access token using managed identity
    $token = (Get-AzAccessToken -ResourceUrl 'https://management.azure.com').Token
    $headers = @{ 
        'Authorization' = "Bearer $token"
        'Content-Type' = 'application/json'
    }
    
    # List all triggers
    $listUri = "https://management.azure.com/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DataFactory/factories/$factory/triggers?api-version=2018-06-01"
    $triggersResponse = Invoke-RestMethod -Uri $listUri -Method Get -Headers $headers
    
    $startedList = @()
    $failedList = @()
    
    foreach ($trigger in $triggersResponse.value) {
        $triggerName = $trigger.name
        $state = $trigger.properties.runtimeState
        
        # Skip if already started
        if ($state -eq 'Started') {
            Write-Output "Trigger $triggerName is already Started - skipping"
            continue
        }
        
        # Skip if specific triggers specified and this isn't one of them
        if (-not [string]::IsNullOrEmpty($specificTriggers) -and $specificTriggers -notcontains $triggerName) {
            continue
        }
        
        Write-Output "Starting trigger: $triggerName (currently $state)"
        $startUri = "https://management.azure.com/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DataFactory/factories/$factory/triggers/$triggerName/start?api-version=2018-06-01"
        try {
            Invoke-RestMethod -Uri $startUri -Method Post -Headers $headers
            $startedList += $triggerName
            Write-Output "  Successfully started: $triggerName"
        } catch {
            $failedList += $triggerName
            Write-Output "  Warning: Failed to start $triggerName - $($_.Exception.Message)"
        }
    }

    Write-Output "=== Summary ==="
    Write-Output "Started: $($startedList.Count) triggers"
    Write-Output "Failed: $($failedList.Count) triggers"
    
    if ($failedList.Count -gt 0) {
        Write-Warning "Some triggers failed to start. Check EventGrid subscription registration."
    }
    
    $DeploymentScriptOutputs = @{ 
        startedTriggers = $startedList
        failedTriggers = $failedList
        status = if ($failedList.Count -eq 0) { "completed" } else { "partial" }
        triggersCount = $startedList.Count
    }
} catch {
    Write-Output "Error: $_"
    throw
}
'''

// Deployment script resource
// The name includes forceRun (defaulting to utcNow()) intentionally to ensure script runs on each deployment
#disable-next-line use-stable-resource-identifiers
resource triggerScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'ds-${operation}-triggers-${take(uniqueString(dataFactoryName, forceRun), 8)}'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  }
  properties: {
    azPowerShellVersion: '12.0'
    timeout: timeout
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
    forceUpdateTag: forceRun
    // Use existing storage account if provided (reuses FinOps Hub storage)
    storageAccountSettings: !empty(storageAccountResourceId) ? {
      storageAccountKey: null  // Use managed identity auth
      storageAccountName: last(split(storageAccountResourceId, '/'))
    } : null
    environmentVariables: [
      {
        name: 'ADF_NAME'
        value: dataFactoryName
      }
      {
        name: 'RESOURCE_GROUP'
        value: resourceGroupName
      }
      {
        name: 'SUBSCRIPTION_ID'
        value: subscription().subscriptionId
      }
      {
        name: 'TRIGGER_NAMES'
        value: join(triggerNames, ',')
      }
    ]
    scriptContent: operation == 'stop' ? stopScript : startScript
  }
}

// Outputs - these are safe non-secret values (trigger names and status strings)
@description('List of triggers that were managed.')
#disable-next-line outputs-should-not-contain-secrets
output managedTriggers array = contains(triggerScript.properties, 'outputs') && triggerScript.properties.outputs != null
  ? (operation == 'stop' 
      ? (contains(triggerScript.properties.outputs, 'stoppedTriggers') ? triggerScript.properties.outputs.stoppedTriggers : [])
      : (contains(triggerScript.properties.outputs, 'startedTriggers') ? triggerScript.properties.outputs.startedTriggers : []))
  : []

@description('Script execution status.')
#disable-next-line outputs-should-not-contain-secrets
output status string = contains(triggerScript.properties, 'outputs') && triggerScript.properties.outputs != null && contains(triggerScript.properties.outputs, 'status')
  ? triggerScript.properties.outputs.status 
  : 'unknown'

@description('Number of triggers managed.')
#disable-next-line outputs-should-not-contain-secrets
output triggerCount int = contains(triggerScript.properties, 'outputs') && triggerScript.properties.outputs != null && contains(triggerScript.properties.outputs, 'triggersCount')
  ? triggerScript.properties.outputs.triggersCount 
  : 0

@description('Deployment script resource ID.')
output scriptResourceId string = triggerScript.id
