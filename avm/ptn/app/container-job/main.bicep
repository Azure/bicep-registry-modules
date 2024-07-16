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
param managedIdentityName string?

@sys.description('Optional. The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.')
@metadata({
  example: '/subscriptions/<00000000-0000-0000-0000-000000000000>/resourceGroups/<rg-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>'
})
param logAnalyticsWorkspaceResourceId string

@sys.description('Optional. The connection string for the Application Insights instance that will be added to Key Vault as `applicationinsights-connection-string` and can be used by the Job.')
@metadata({
  example: 'InstrumentationKey=<00000000-0000-0000-0000-000000000000>;IngestionEndpoint=https://germanywestcentral-1.in.applicationinsights.azure.com/;LiveEndpoint=https://germanywestcentral.livediagnostics.monitor.azure.com/;ApplicationId=<00000000-0000-0000-0000-000000000000>'
})
param appInsightsConnectionString string?

@description('Required. The name of the Key Vault that will be created to store the Application Insights connection string and be used for your secrets.')
@metadata({ example: '''kv${uniqueString(nameSuffix, location, resourceGroup().name)''' })
param keyVaultName string

// network related parameters
// -------------------------
@description('Optional. Deploy resources in a virtual network and use it for private endpoints.')
param deployInVnet bool = false

@description('Conditional. The address prefix for the virtual network needs to be at least a /16. Required if `deployInVnet` is `true`.')
@metadata({ default: '10.50.0.0/16' })
param addressPrefix string?

@description('Conditional. A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.vaultcore.azure.net`. Required if `deployInVnet` is `true`.')
param deployDnsZoneKeyVault bool = true

@description('Conditional. A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.azurecr.io`. Required if `deployInVnet` is `true`.')
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

@description('Optional. The CPU resources that will be allocated to the Container Apps Job.')
param cpu string = '1'

@description('Optional. The memory resources that will be allocated to the Container Apps Job.')
param memory string = '2Gi'

@sys.description('Optional. The environment variables that will be added to the Container Apps Job.')
@metadata({
  example: '''[
  {
    name: 'ENV_VAR_NAME'
    value: 'ENV_VAR_VALUE'
  }
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    secretRef: 'applicationinsights-connection-string'
  }
]'''
})
param environmentVariables environmentVariablesType[]?

@description('Optional. The secrets of the Container App. The application insights connection string will be added automatically as `applicationinsightsconnectionstring`, if `appInsightsConnectionString` is set.')
@metadata({
  example: '''
  [
    {
      name: 'mysecret'
      identity: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
      keyVaultUrl: 'https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret'
    }
    {
      name: 'mysecret'
      identity: 'system'
      keyVaultUrl: 'https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret'
    }
    {
      // You can do this, but you shouldn't. Use a secret reference instead.
      name: 'mysecret'
      value: 'mysecretvalue'
    }
    {
      name: 'connection-string'
      value: listKeys('/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount', '2023-04-01').keys[0].value
    }
  ]
  '''
})
#disable-next-line secure-secrets-in-params // @secure() is specified in UDT
param secrets secretType[]?

@description('Optional. Workload profiles for the managed environment.')
@metadata({
  example: '''[
    {
      workloadProfileType: 'D4'
      name: 'CAW01'
      minimumCount: 0
      maximumCount: 1
    }
  ]'''
})
param workloadProfiles array?

@description('Optional.  The name of the workload profile to use. Leave empty to use a consumption based profile.')
@metadata({ example: 'CAW01' })
param workloadProfileName string?

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

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

// provision required services
module services 'modules/deploy_services.bicep' = {
  name: '${name}-services'
  params: {
    nameSuffix: nameSuffix
    resourceLocation: location
    resourceGroupName: resourceGroup().name
    managedIdentityName: managedIdentityName
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    appInsightsConnectionString: appInsightsConnectionString
    keyVaultName: keyVaultName
    keyVaultSecrets: secrets
    deployInVnet: deployInVnet
    addressPrefix: addressPrefix
    deployDnsZoneKeyVault: deployDnsZoneKeyVault
    deployDnsZoneContainerRegistry: deployDnsZoneContainerRegistry
    workloadProfiles: length(workloadProfiles ?? []) > 0 ? workloadProfiles : null
    tags: tags
  }
}

// import the image to the ACR that will be used to run the job
module import_image 'br/public:avm/ptn/deployment-script/import-image-to-acr:0.1.0' = {
  name: '${name}-import-image'
  params: {
    name: '${name}-import-image-${nameSuffix}'
    location: location
    acrName: services.outputs.registryName
    image: containerImageSource
    managedIdentities: { userAssignedResourcesIds: [services.outputs.userManagedIdentityResourceId] }
    overwriteExistingImage: overwriteExistingImage
    initialScriptDelay: 1
    retryMax: 1
    runOnce: false
    storageAccountResourceId: (deployInVnet) ? services.outputs.storageAccountResourceId : null
    subnetResourceIds: (deployInVnet) ? [services.outputs.subnetResourceId_deploymentScript] : []
    tags: tags
  }
}

module job 'br/public:avm/res/app/job:0.3.0' = {
  name: '${uniqueString(deployment().name, location)}-${resourceGroup().name}-appjob'
  params: {
    name: 'container-job-${nameSuffix}'
    tags: tags
    environmentResourceId: services.outputs.managedEnvironmentId
    workloadProfileName: workloadProfileName
    location: location
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [services.outputs.userManagedIdentityResourceId]
    }
    secrets: union(
      !empty(services.outputs.keyVaultAppInsightsConnectionStringUrl)
        ? [
            {
              name: 'applicationinsightsconnectionstring'
              identity: services.outputs.userManagedIdentityResourceId
              keyVaultUrl: 'https://${services.outputs.vaultName}${environment().suffixes.keyvaultDns}/secrets/applicationinsights-connection-string'
            }
          ]
        : [],
      secrets ?? []
    )
    triggerType: 'Schedule'
    scheduleTriggerConfig: {
      cronExpression: cronExpression
    }
    registries: [
      {
        identity: services.outputs.userManagedIdentityResourceId
        server: services.outputs.registryLoginServer
      }
    ]
    containers: [
      {
        name: 'job-${nameSuffix}'
        image: import_image.outputs.importedImage.acrHostedImage
        env: environmentVariables
        resources: {
          cpu: cpu
          memory: memory
        }
      }
    ]
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the container job.')
output resourceId string = job.outputs.resourceId

@description('The name of the container job.')
output name string = job.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

@description('The name of the Resource Group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('Conditional. The virtual network resourceId, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty.')
output vnetResourceId string = services.outputs.vnetResourceId

// ================ //
// Definitions      //
// ================ //

type environmentVariablesType = {
  @description('Required. The environment variable name.')
  name: string

  @description('Conditional. The name of the Container App secret from which to pull the envrionment variable value. Required if `value` is null.')
  secretRef: string?

  @description('Conditional. The environment variable value. Required if `secretRef` is null.')
  value: string?
}

import { secretType } from 'modules/deploy_services.bicep'
