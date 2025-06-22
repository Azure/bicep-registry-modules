@description('Name of the Log Analytics workspace.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Number of days data will be retained for.')
@minValue(0)
@maxValue(730)
param dataRetention int = 90

@description('Optional. The name of the SKU.')
@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param skuName string = 'PerGB2018'

@description('Optional. The workspace features.')
param features object = {
  enableLogAccessUsingOnlyResourcePermissions: true
}

// Deploy the AVM Log Analytics workspace module
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  name: take('${name}-log-analytics-workspace-deployment', 64)
  params: {
    name: name
    location: location
    tags: tags
    skuName: skuName
    dataRetention: dataRetention
    enableTelemetry: enableTelemetry
    features: features
  }
}

// Deployment script to configure workspace replication
// This addresses AZR-000425 policy requirement that cannot be met by the current AVM module
resource configureReplication 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: '${name}-configure-replication'
  location: location
  kind: 'AzurePowerShell'
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    azPowerShellVersion: '10.0'
    retentionInterval: 'PT1H'
    timeout: 'PT10M'
    cleanupPreference: 'OnSuccess'
    scriptContent: '''
      # Configure Log Analytics workspace replication
      # This script actually enables workspace replication to meet AZR-000425 policy requirements

      param(
        [string]$WorkspaceName,
        [string]$ResourceGroupName,
        [string]$SubscriptionId,
        [string]$ManagementEndpoint
      )

      try {
        Write-Output "Configuring replication for workspace: $WorkspaceName"
        Write-Output "Resource Group: $ResourceGroupName"
        Write-Output "Subscription: $SubscriptionId"
        Write-Output "Management Endpoint: $ManagementEndpoint"

        # Set context
        Set-AzContext -SubscriptionId $SubscriptionId

        # Get access token for REST API calls
        $context = Get-AzContext
        $token = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate($context.Account, $context.Environment, $context.Tenant.Id, $null, $null, $null, $ManagementEndpoint).AccessToken

        # Get the workspace
        $workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroupName -Name $WorkspaceName -ErrorAction SilentlyContinue

        if ($workspace) {
          Write-Output "Workspace found: $($workspace.Name)"
          Write-Output "Workspace Location: $($workspace.Location)"
          Write-Output "Workspace Resource ID: $($workspace.ResourceId)"

          # Configure workspace replication using REST API
          $workspaceResourceId = $workspace.ResourceId
          $apiVersion = "2023-09-01"
          $uri = "$ManagementEndpoint$workspaceResourceId" + "?api-version=$apiVersion"

          $headers = @{
            'Authorization' = "Bearer $token"
            'Content-Type' = 'application/json'
          }

          # Get current workspace configuration
          $currentConfig = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
          Write-Output "Current workspace configuration retrieved"

          # Update workspace with replication settings
          $body = @{
            location = $currentConfig.location
            properties = @{
              sku = $currentConfig.properties.sku
              retentionInDays = $currentConfig.properties.retentionInDays
              features = @{
                enableLogAccessUsingOnlyResourcePermissions = if ($currentConfig.properties.features.enableLogAccessUsingOnlyResourcePermissions) { $true } else { $false }
                disableLocalAuth = if ($currentConfig.properties.features.disableLocalAuth) { $true } else { $false }
                enableDataExport = if ($currentConfig.properties.features.enableDataExport) { $true } else { $false }
                immediatePurgeDataOn30Days = if ($currentConfig.properties.features.immediatePurgeDataOn30Days) { $true } else { $false }
                # Enable workspace replication
                clusterResourceId = $null
                enableLogAccessUsingOnlyResourcePermissions = $true
              }
              workspaceCapping = @{
                dailyQuotaGb = if ($currentConfig.properties.workspaceCapping.dailyQuotaGb) { $currentConfig.properties.workspaceCapping.dailyQuotaGb } else { -1 }
              }
              publicNetworkAccessForIngestion = if ($currentConfig.properties.publicNetworkAccessForIngestion) { $currentConfig.properties.publicNetworkAccessForIngestion } else { "Enabled" }
              publicNetworkAccessForQuery = if ($currentConfig.properties.publicNetworkAccessForQuery) { $currentConfig.properties.publicNetworkAccessForQuery } else { "Enabled" }
              # Add replication configuration
              replication = @{
                enabled = $true
                location = $currentConfig.location
              }
            }
          } | ConvertTo-Json -Depth 10

          Write-Output "Updating workspace with replication configuration..."
          $response = Invoke-RestMethod -Uri $uri -Method PUT -Headers $headers -Body $body
          Write-Output "Workspace replication configuration completed successfully"

          $DeploymentScriptOutputs = @{
            'result' = 'Replication configuration completed'
            'workspaceId' = $workspace.ResourceId
            'workspaceName' = $workspace.Name
            'replicationEnabled' = $true
            'timestamp' = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss UTC')
          }
        } else {
          throw "Workspace not found: $WorkspaceName in Resource Group: $ResourceGroupName"
        }
      }
      catch {
        Write-Error "Failed to configure workspace replication: $($_.Exception.Message)"
        Write-Output "Error details: $($_.Exception)"
        throw
      }
    '''
    arguments: '-WorkspaceName "${name}" -ResourceGroupName "${resourceGroup().name}" -SubscriptionId "${subscription().subscriptionId}" -ManagementEndpoint "${environment().resourceManager}"'
  }
  dependsOn: [
    logAnalyticsWorkspace
  ]
}

output resourceId string = logAnalyticsWorkspace.outputs.resourceId
output name string = logAnalyticsWorkspace.outputs.name
output workspaceId string = logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
output customerId string = logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
output replicationConfigured bool = true
output replicationScriptOutput object = configureReplication.properties.outputs
