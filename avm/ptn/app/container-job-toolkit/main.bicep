metadata name = 'Container job toolkit'
metadata description = 'This module deploys a container to run as a job.'

// ============== //
// Parameters     //
// ============== //

@description('Required. Name of the resource to create. Will be used for naming the job and other resources.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Use an existing managed identity to import the container image and run the job. If not provided, a new managed identity will be created.')
@metadata({
  example: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
})
param managedIdentityResourceId string?

@description('Optional. The name of the managed identity to create. If not provided, a name will be generated automatically as `jobsUserIdentity-$\\{name\\}`.')
@minLength(3)
@maxLength(128)
param managedIdentityName string?

@description('Optional. The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.')
@metadata({
  example: '/subscriptions/<00000000-0000-0000-0000-000000000000>/resourceGroups/<rg-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>'
})
param logAnalyticsWorkspaceResourceId string?

@description('Optional. The connection string for the Application Insights instance that will be added to Key Vault as `applicationinsights-connection-string` and can be used by the Job.')
@metadata({
  example: 'InstrumentationKey=<00000000-0000-0000-0000-000000000000>;IngestionEndpoint=https://germanywestcentral-1.in.applicationinsights.azure.com/;LiveEndpoint=https://germanywestcentral.livediagnostics.monitor.azure.com/;ApplicationId=<00000000-0000-0000-0000-000000000000>'
})
param appInsightsConnectionString string?

@description('Optional. The name of the Key Vault that will be created to store the Application Insights connection string and be used for your secrets.')
@metadata({ example: '''kv${uniqueString(name, location, resourceGroup().name)})''' })
@minLength(3)
@maxLength(24)
param keyVaultName string = 'kv${uniqueString(name, location, resourceGroup().name)}'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The permissions that will be assigned to the Key Vault. The managed Identity will be assigned the permissions to get and list secrets.')
param keyVaultRoleAssignments roleAssignmentType[]?

@description('Optional. The permissions that will be assigned to the Container Registry. The managed Identity will be assigned the permissions to get and list images.')
param registryRoleAssignments roleAssignmentType[]?

// network related parameters
// -------------------------
@description('Optional. Deploy resources in a virtual network and use it for private endpoints.')
param deployInVnet bool = false

@description('Conditional. A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.vaultcore.azure.net`. Required if `deployInVnet` is `true`.')
param deployDnsZoneKeyVault bool = true

@description('Conditional. A new private DNS Zone will be created. Setting to `false` requires an existing private DNS zone `privatelink.azurecr.io`. Required if `deployInVnet` is `true`.')
param deployDnsZoneContainerRegistry bool = true

@description('Conditional. The address prefix for the virtual network needs to be at least a /16. Three subnets will be created (the first /24 will be used for private endpoints, the second /24 for service endpoints and the second /23 is used for the workload). Required if `zoneRedundant` for consumption plan is desired or `deployInVnet` is `true`.')
param addressPrefix string = '10.50.0.0/16' // set a default value for the cidrSubnet calculation, even if not used

import { securityRuleType } from 'modules/deploy_services.bicep'
@description('Optional. Network security group, that will be added to the workload subnet.')
param customNetworkSecurityGroups securityRuleType[]?

// container related parameters
// -------------------------
@description('Required. The container image source that will be copied to the Container Registry and used to provision the job.')
@metadata({ example: 'mcr.microsoft.com/k8se/quickstart-jobs:latest' })
param containerImageSource string

@description('Optional. The new image name in the ACR. You can use this to import a publically available image with a custom name for later updating from e.g., your build pipeline. You should skip the registry name when specifying a custom value, as it is added automatically. If you leave this empty, the original name will be used (with the new registry name).')
@metadata({ example: 'application/frontend:latest' })
param newContainerImageName string?

@description('Optional. The flag that indicates whether the existing image in the Container Registry should be overwritten.')
param overwriteExistingImage bool = false

@description('Optional. The cron expression that will be used to schedule the job.')
@metadata({ default: '0 0 * * * // every day at midnight' })
param cronExpression string = '0 0 * * *'

@description('Optional. The CPU resources that will be allocated to the Container Apps Job.')
param cpu string = '1'

@description('Optional. The memory resources that will be allocated to the Container Apps Job.')
param memory string = '2Gi'

@description('Optional. The environment variables that will be added to the Container Apps Job.')
param environmentVariables environmentVariableType[]?

import { secretType } from 'modules/deploy_services.bicep'
@description('Optional. The secrets of the Container App. They will be added to Key Vault and configured as secrets in the Container App Job. The application insights connection string will be added automatically as `applicationinsightsconnectionstring`, if `appInsightsConnectionString` is set.')
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

@description('Optional. Workload profiles for the managed environment. Leave empty to use a consumption based profile.')
param workloadProfiles workloadProfileType[]?

@description('Optional. The name of the workload profile to use. Leave empty to use a consumption based profile.')
@metadata({ example: 'CAW01' })
param workloadProfileName string?

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      key1: 'value1'
      key2: 'value2'
  }
  '''
})
param tags object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.app-containerjobtoolkit.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  name: '${uniqueString(deployment().name, location)}-services'
  params: {
    name: name
    location: location
    enableTelemetry: enableTelemetry
    resourceGroupName: resourceGroup().name
    managedIdentityResourceId: managedIdentityResourceId
    managedIdentityName: managedIdentityName
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    appInsightsConnectionString: appInsightsConnectionString
    keyVaultName: keyVaultName
    keyVaultSecrets: secrets
    keyVaultRoleAssignments: keyVaultRoleAssignments
    registryRoleAssignments: registryRoleAssignments
    deployInVnet: deployInVnet
    addressPrefix: addressPrefix
    deployDnsZoneKeyVault: deployDnsZoneKeyVault
    deployDnsZoneContainerRegistry: deployDnsZoneContainerRegistry
    customNetworkSecurityGroups: customNetworkSecurityGroups
    workloadProfiles: length(workloadProfiles ?? []) > 0 ? workloadProfiles : null
    tags: tags
    lock: lock
  }
}

// import the image to the ACR that will be used to run the job
module import_image 'br/public:avm/ptn/deployment-script/import-image-to-acr:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-import-image'
  params: {
    name: '${name}-import-image'
    location: location
    enableTelemetry: enableTelemetry
    acrName: services.outputs.registryName
    image: containerImageSource
    newImageName: newContainerImageName
    managedIdentities: { userAssignedResourceIds: [services.outputs.userManagedIdentityResourceId] }
    overwriteExistingImage: overwriteExistingImage
    initialScriptDelay: 10
    retryMax: 3
    runOnce: false
    cleanupPreference: 'OnExpiration'
    storageAccountResourceId: (deployInVnet) ? services.outputs.storageAccountResourceId : null
    subnetResourceIds: (deployInVnet) ? [services.outputs.subnetResourceId_deploymentScript] : []
    tags: tags
  }
}

module job 'br/public:avm/res/app/job:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-${resourceGroup().name}-appjob'
  params: {
    name: '${name}-container-job'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    lock: lock
    environmentResourceId: services.outputs.managedEnvironmentResourceId
    workloadProfileName: workloadProfileName
    managedIdentities: {
      userAssignedResourceIds: [services.outputs.userManagedIdentityResourceId]
    }
    secrets: union(
      // add Application Insights connection string as secret if provided
      !empty(services.outputs.keyVaultAppInsightsConnectionStringUrl)
        ? [
            {
              name: 'applicationinsightsconnectionstring'
              identity: services.outputs.userManagedIdentityResourceId
              keyVaultUrl: 'https://${services.outputs.vaultName}${environment().suffixes.keyvaultDns}/secrets/applicationinsights-connection-string'
            }
          ]
        : [],
      // add passed secrets to the job. It uses the Managed Identity to access the secrets.
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
        name: '${name}-scheduled-job'
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

@description('The name of the Resource Group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resouce ID of the Log Analytics Workspace (passed as parameter value or from the newly created Log Analytics Workspace).')
output logAnalyticsResourceId string = services.outputs.logAnalyticsResourceId

@description('The principal ID of the user assigned managed identity.')
output systemAssignedMIPrincipalId string = services.outputs.userManagedIdentityPrincipalId

@description('Conditional. The virtual network resourceId, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty.')
output vnetResourceId string = services.outputs.vnetResourceId

@description('Conditional. The address prefix for the private endpoint subnet, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty.')
output privateEndpointSubnetAddressPrefix string = services.outputs.privateEndpointSubnetAddressPrefix

@description('Conditional. The address prefix for the service endpoint subnet, if a virtual network was deployed. If `deployInVnet` is `false`, this output will be empty.')
output deploymentscriptSubnetAddressPrefix string = services.outputs.deploymentscriptSubnetAddressPrefix

@description('Conditional. The address prefix for the workload subnet, if a virtual network was deployed. If `addressPrefix` is empty, this output will be empty.')
output workloadSubnetAddressPrefix string = services.outputs.workloadSubnetAddressPrefix

// ================ //
// Definitions      //
// ================ //

@export()
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
@description('Environment variables with name and value or a reference to a Key Vault secret.')
type environmentVariableType = {
  @description('Required. The environment variable name.')
  name: string

  @description('Conditional. The name of the Container App secret from which to pull the environment variable value. Required if `value` is null.')
  secretRef: string?

  @description('Conditional. The environment variable value. Required if `secretRef` is null.')
  value: string?
}

@export()
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
@description('Workload profiles for the managed environment. Leave empty to use a consumption based profile.')
type workloadProfileType = {
  @description('Required. The type of the workload profile.')
  workloadProfileType: string

  @description('Required. The name of the workload profile.')
  name: string

  @description('Required. The minimum number of instances for the workload profile.')
  minimumCount: int

  @description('Required. The maximum number of instances for the workload profile.')
  maximumCount: int
}
