metadata name = 'container-job'
metadata description = 'This module deploys a container to run as a job.'
metadata owner = 'Azure/module-maintainers'

// ============== //
// Parameters     //
// ============== //

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The suffix will be used for newly created resources.')
param nameSuffix string = 'cjob'

@description('Optional. Use an existing managed identity to import the container image and run the job. If not provided, a new managed identity will be created.')
param managedIdentityPrincipalId string?

@sys.description('Optional. The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.')
@metadata({
  example: '/subscriptions/<00000000-0000-0000-0000-000000000000>/resourceGroups/<rg-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>'
})
param logAnalyticsWorkspaceResourceId string

@sys.description('Optional. The connection string for the Application Insights instance that will be used by the Job.')
@metadata({
  example: 'InstrumentationKey=<00000000-0000-0000-0000-000000000000>;IngestionEndpoint=https://germanywestcentral-1.in.applicationinsights.azure.com/;LiveEndpoint=https://germanywestcentral.livediagnostics.monitor.azure.com/;ApplicationId=<00000000-0000-0000-0000-000000000000>'
})
param appInsightsConnectionString string?

// network related parameters
// -------------------------
@description('Optional. Deploy resources in a virtual network and use it for private endpoints.')
param deployInVnet bool = true

@description('Conditional. The address prefix for the virtual network needs to be at least a /16. Required, if `deployInVnet` is `true`.')
@metadata({ default: '10.50.0.0/16' })
param addressPrefix string?

@description('Conditional. A new private DNS Zone will be created. Optional, if `deployInVnet` is `true`.')
param deployDnsZoneKeyVault bool = true

@description('Conditional. A new private DNS Zone will be created. Optional, if `deployInVnet` is `true`.')
param deployDnsZoneContainerRegistry bool = true

// container related parameters
// -------------------------
@sys.description('Required. The container image source that will be copied to the Container Registry and used to provision the job.')
@metadata({ example: 'mcr.microsoft.com/k8se/quickstart-jobs:latest' })
param containerImageSource string

@sys.description('Optional. The flag that indicates whether the existing image in the Container Registry should be overwritten.')
param overwriteExistingImage bool = false

@sys.description('Optional. The cron expression that will be used to schedule the job.')
@metadata({ default: '0 0 * * * // every day at midnight' })
param cronExpression string = '0 0 * * *'

@sys.description('Optional. The environment variables that will be added to the Container Apps Job.')
param jobEnvironmentVariables array = []

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.app-containerjob.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module services 'modules/deploy_services.bicep' = {
  name: '${name}-services'
  params: {
    nameSuffix: nameSuffix
    resourceLocation: location
    resourceGroupName: resourceGroup().name
    managedIdentityPrincipalId: managedIdentityPrincipalId
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    appInsightsConnectionString: appInsightsConnectionString
    deployInVnet: deployInVnet
    addressPrefix: addressPrefix
    deployDnsZoneKeyVault: deployDnsZoneKeyVault
    deployDnsZoneContainerRegistry: deployDnsZoneContainerRegistry
  }
}

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

// @description('The resource ID of the resource.')
// output resourceId string = <Resource>.id

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
