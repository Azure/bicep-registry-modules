metadata name = 'Data Factories'
metadata description = 'This module deploys a Data Factory.'

@description('Required. The name of the Azure Factory to create.')
param name string

@description('Optional. The name of the Managed Virtual Network.')
param managedVirtualNetworkName string = ''

@description('Optional. An array of managed private endpoints objects created in the Data Factory managed virtual network.')
param managedPrivateEndpoints managedPrivateEndpointType[] = []

@description('Optional. An array of objects for the configuration of an Integration Runtime.')
param integrationRuntimes integrationRuntimesType[] = []

@description('Optional. An array of objects for the configuration of Linked Services.')
param linkedServices linkedServicesType[] = []

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. Boolean to define whether or not to configure git during template deployment.')
param gitConfigureLater bool = true

@description('Optional. Repository type - can be \'FactoryVSTSConfiguration\' or \'FactoryGitHubConfiguration\'. Default is \'FactoryVSTSConfiguration\'.')
param gitRepoType string = 'FactoryVSTSConfiguration'

@description('Optional. The account name.')
param gitAccountName string = ''

@description('Optional. The project name. Only relevant for \'FactoryVSTSConfiguration\'.')
param gitProjectName string = ''

@description('Optional. The repository name.')
param gitRepositoryName string = ''

@description('Optional. The collaboration branch name. Default is \'main\'.')
param gitCollaborationBranch string = 'main'

@description('Optional. Disable manual publish operation in ADF studio to favor automated publish.')
param gitDisablePublish bool = false

@description('Optional. The root folder path name. Default is \'/\'.')
param gitRootFolder string = '/'

@description('Optional. The GitHub Enterprise Server host (prefixed with \'https://\'). Only relevant for \'FactoryGitHubConfiguration\'.')
param gitHostName string = ''

@description('Optional. Add the last commit id from your git repo.')
param gitLastCommitId string = ''

@description('Optional. Add the tenantId of your Azure subscription.')
param gitTenantId string = ''

@description('Optional. List of Global Parameters for the factory.')
param globalParameters object = {}

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings for all Resources in the solution.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Factory Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '673868aa-7521-48a0-acc6-0f60742d39f5'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.datafactory-factory.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    repoConfiguration: bool(gitConfigureLater)
      ? null
      : union(
          {
            type: gitRepoType
            hostName: gitHostName
            accountName: gitAccountName
            repositoryName: gitRepositoryName
            collaborationBranch: gitCollaborationBranch
            rootFolder: gitRootFolder
            disablePublish: gitDisablePublish
            lastCommitId: gitLastCommitId
            tenantId: gitTenantId
          },
          (gitRepoType == 'FactoryVSTSConfiguration'
            ? {
                projectName: gitProjectName
              }
            : {}),
          {}
        )
    globalParameters: !empty(globalParameters) ? globalParameters : null
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) ? 'Disabled' : null)
    encryption: !empty(customerManagedKey)
      ? {
          identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
            ? {
                userAssignedIdentity: cMKUserAssignedIdentity.id
              }
            : null
          keyName: customerManagedKey!.keyName
          keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
            ? customerManagedKey!.keyVersion
            : (customerManagedKey.?autoRotationEnabled ?? true)
                ? null
                : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
          vaultBaseUrl: cMKKeyVault.properties.vaultUri
        }
      : null
  }
}

module dataFactory_managedVirtualNetwork 'managed-virtual-network/main.bicep' = if (!empty(managedVirtualNetworkName)) {
  name: '${uniqueString(deployment().name, location)}-DataFactory-ManagedVNet'
  params: {
    name: managedVirtualNetworkName
    dataFactoryName: dataFactory.name
    managedPrivateEndpoints: managedPrivateEndpoints
  }
}

module dataFactory_integrationRuntimes 'integration-runtime/main.bicep' = [
  for (integrationRuntime, index) in integrationRuntimes: {
    name: '${uniqueString(deployment().name, location)}-DataFactory-IntegrationRuntime-${index}'
    params: {
      dataFactoryName: dataFactory.name
      name: integrationRuntime.name
      type: integrationRuntime.type
      integrationRuntimeCustomDescription: integrationRuntime.?integrationRuntimeCustomDescription
      managedVirtualNetworkName: integrationRuntime.?managedVirtualNetworkName
      typeProperties: integrationRuntime.?typeProperties
    }
    dependsOn: [
      dataFactory_managedVirtualNetwork
    ]
  }
]

module dataFactory_linkedServices 'linked-service/main.bicep' = [
  for (linkedService, index) in linkedServices: {
    name: '${uniqueString(deployment().name, location)}-DataFactory-LinkedServices-${index}'
    params: {
      dataFactoryName: dataFactory.name
      name: linkedService.name
      type: linkedService.type
      typeProperties: linkedService.?typeProperties
      integrationRuntimeName: linkedService.?integrationRuntimeName
      parameters: linkedService.?parameters
      description: linkedService.?description
    }
    dependsOn: [
      dataFactory_integrationRuntimes
    ]
  }
]

resource dataFactory_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: dataFactory
}

resource dataFactory_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: dataFactory
  }
]

resource dataFactory_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(dataFactory.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: dataFactory
  }
]

module dataFactory_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.9.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-dataFactory-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(dataFactory.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(dataFactory.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: dataFactory.id
                groupIds: [
                  privateEndpoint.service
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(dataFactory.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: dataFactory.id
                groupIds: [
                  privateEndpoint.service
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

@description('The Name of the Azure Data Factory instance.')
output name string = dataFactory.name

@description('The Resource ID of the Data Factory.')
output resourceId string = dataFactory.id

@description('The name of the Resource Group with the Data factory.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = dataFactory.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = dataFactory.location

@description('The private endpoints of the Data Factory.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: dataFactory_privateEndpoints[i].outputs.name
    resourceId: dataFactory_privateEndpoints[i].outputs.resourceId
    groupId: dataFactory_privateEndpoints[i].outputs.groupId
    customDnsConfig: dataFactory_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceResourceIds: dataFactory_privateEndpoints[i].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type managedPrivateEndpointType = {
  @description('Required. Specify the name of managed private endpoint.')
  name: string

  @description('Required. Specify the sub-resource of the managed private endpoint.')
  groupId: string

  @description('Required. Specify the resource ID to create the managed private endpoint for.')
  privateLinkResourceId: string

  @description('Optional. Specify the FQDNS of the linked resources to create private endpoints for, depending on the type of linked resource this is required.')
  fqdns: string[]?
}

@export()
type integrationRuntimesType = {
  @description('Required. Specify the name of integration runtime.')
  name: string

  @description('Required. Specify the type of the integration runtime.')
  type: ('Managed' | 'SelfHosted')

  @description('Optional. Specify custom description for the integration runtime.')
  integrationRuntimeCustomDescription: string?

  @description('Optional. Specify managed vritual network name for the integration runtime to link to.')
  managedVirtualNetworkName: string?

  @description('Optional. Integration Runtime type properties. Required if type is "Managed".')
  typeProperties: object?
}

@export()
type linkedServicesType = {
  @description('Required. The name of the Linked Service.')
  name: string

  @description('Required. The type of Linked Service. See https://learn.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories/linkedservices?pivots=deployment-language-bicep#linkedservice-objects for more information.')
  type: string

  @description('Optional. Used to add connection properties for your linked services.')
  typeProperties: object?

  @description('Optional. The name of the Integration Runtime to use.')
  integrationRuntimeName: string?

  @description('Optional. Use this to add parameters for a linked service connection string.')
  parameters: object?

  @description('Optional. The description of the Integration Runtime.')
  description: string?
}
