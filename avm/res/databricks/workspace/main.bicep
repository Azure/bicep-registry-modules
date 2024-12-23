metadata name = 'Azure Databricks Workspaces'
metadata description = 'This module deploys an Azure Databricks Workspace.'

@description('Required. The name of the Azure Databricks workspace to create.')
param name string

@description('Optional. The managed resource group ID. It is created by the module as per the to-be resource ID you provide.')
param managedResourceGroupResourceId string = ''

@description('Optional. The pricing tier of workspace.')
@allowed([
  'trial'
  'standard'
  'premium'
])
param skuName string = 'premium'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The resource ID of a Virtual Network where this Databricks Cluster should be created.')
param customVirtualNetworkResourceId string = ''

@description('Optional. The resource ID of a Azure Machine Learning workspace to link with Databricks workspace.')
param amlWorkspaceResourceId string = ''

@description('Optional. The name of the Private Subnet within the Virtual Network.')
param customPrivateSubnetName string = ''

@description('Optional. The name of a Public Subnet within the Virtual Network.')
param customPublicSubnetName string = ''

@description('Optional. Disable Public IP.')
param disablePublicIp bool = false

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition to use for the managed service.')
param customerManagedKey customerManagedKeyType?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition to use for the managed disk.')
param customerManagedKeyManagedDisk customerManagedKeyWithAutoRotateType?

@description('Optional. Name of the outbound Load Balancer Backend Pool for Secure Cluster Connectivity (No Public IP).')
param loadBalancerBackendPoolName string = ''

@description('Optional. Resource URI of Outbound Load balancer for Secure Cluster Connectivity (No Public IP) workspace.')
param loadBalancerResourceId string = ''

@description('Optional. Name of the NAT gateway for Secure Cluster Connectivity (No Public IP) workspace subnets.')
param natGatewayName string = ''

@description('Optional. Prepare the workspace for encryption. Enables the Managed Identity for managed storage account.')
param prepareEncryption bool = false

@description('Optional. Name of the Public IP for No Public IP workspace with managed vNet.')
param publicIpName string = ''

@description('Optional. A boolean indicating whether or not the DBFS root file system will be enabled with secondary layer of encryption with platform managed keys for data at rest.')
param requireInfrastructureEncryption bool = false

@description('Optional. Default DBFS storage account name.')
param storageAccountName string = ''

@description('Optional. Storage account SKU name.')
param storageAccountSkuName string = 'Standard_GRS'

@description('Optional. Address prefix for Managed virtual network.')
param vnetAddressPrefix string = '10.139'

@description('Optional. The network access type for accessing workspace. Set value to disabled to access workspace only via private link.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Gets or sets a value indicating whether data plane (clusters) to control plane communication happen over private endpoint.')
@allowed([
  'AllRules'
  'NoAzureDatabricksRules'
])
param requiredNsgRules string = 'AllRules'

@description('Optional. Determines whether the managed storage account should be private or public. For best security practices, it is recommended to set it to Enabled.')
@allowed([
  'Enabled'
  'Disabled'
  ''
])
param privateStorageAccount string = ''

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

@description('Optional. Configuration details for private endpoints for the managed workspace storage account, required when privateStorageAccount is set to Enabled. For security reasons, it is recommended to use private endpoints whenever possible.')
param storageAccountPrivateEndpoints privateEndpointMultiServiceType[]?

@description('Conditional. The resource ID of the associated access connector for private access to the managed workspace storage account. Required if privateStorageAccount is enabled.')
param accessConnectorResourceId string = ''

@description('Optional. The default catalog configuration for the Databricks workspace.')
param defaultCatalog defaultCatalogType?

@description('Optional. The value for enabling automatic cluster updates in enhanced security compliance.')
@allowed([
  'Enabled'
  'Disabled'
  ''
])
param automaticClusterUpdate string = ''

@description('Optional. The compliance standards array for the security profile. Should be a list of compliance standards like "HIPAA", "NONE" or "PCI_DSS".')
param complianceStandards array = []

@description('Optional. The value to Enable or Disable for the compliance security profile.')
@allowed([
  'Enabled'
  'Disabled'
  ''
])
param complianceSecurityProfileValue string = ''

@description('Optional. The value for enabling or configuring enhanced security monitoring.')
@allowed([
  'Enabled'
  'Disabled'
  ''
])
param enhancedSecurityMonitoring string = ''

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.databricks-workspace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKManagedDiskKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(customerManagedKeyManagedDisk.?keyVaultResourceId)) {
  name: last(split((customerManagedKeyManagedDisk.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKeyManagedDisk.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKeyManagedDisk.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKeyManagedDisk.?keyVaultResourceId) && !empty(customerManagedKeyManagedDisk.?keyName)) {
    name: customerManagedKeyManagedDisk.?keyName ?? 'dummyKey'
  }
}

resource workspace 'Microsoft.Databricks/workspaces@2024-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    managedResourceGroupId: !empty(managedResourceGroupResourceId)
      ? managedResourceGroupResourceId
      : '${subscription().id}/resourceGroups/rg-${name}-managed'
    parameters: {
      enableNoPublicIp: {
        value: disablePublicIp
      }
      prepareEncryption: {
        value: prepareEncryption
      }
      vnetAddressPrefix: {
        value: vnetAddressPrefix
      }
      requireInfrastructureEncryption: {
        value: requireInfrastructureEncryption
      }
      ...(!empty(customVirtualNetworkResourceId)
        ? {
            customVirtualNetworkId: {
              value: customVirtualNetworkResourceId
            }
          }
        : {})
      ...(!empty(amlWorkspaceResourceId)
        ? {
            amlWorkspaceId: {
              value: amlWorkspaceResourceId
            }
          }
        : {})
      ...(!empty(customPrivateSubnetName)
        ? {
            customPrivateSubnetName: {
              value: customPrivateSubnetName
            }
          }
        : {})
      ...(!empty(customPublicSubnetName)
        ? {
            customPublicSubnetName: {
              value: customPublicSubnetName
            }
          }
        : {})
      ...(!empty(loadBalancerBackendPoolName)
        ? {
            loadBalancerBackendPoolName: {
              value: loadBalancerBackendPoolName
            }
          }
        : {})
      ...(!empty(loadBalancerResourceId)
        ? {
            loadBalancerId: {
              value: loadBalancerResourceId
            }
          }
        : {})
      ...(!empty(natGatewayName)
        ? {
            natGatewayName: {
              value: natGatewayName
            }
          }
        : {})
      ...(!empty(publicIpName)
        ? {
            publicIpName: {
              value: publicIpName
            }
          }
        : {})
      ...(!empty(storageAccountName)
        ? {
            storageAccountName: {
              value: storageAccountName
            }
          }
        : {})
      ...(!empty(storageAccountSkuName)
        ? {
            storageAccountSkuName: {
              value: storageAccountSkuName
            }
          }
        : {})
    }
    // createdBy: {} // This is a read-only property
    // managedDiskIdentity: {} // This is a read-only property
    // storageAccountIdentity: {} // This is a read-only property
    // updatedBy: {} // This is a read-only property
    publicNetworkAccess: publicNetworkAccess
    requiredNsgRules: requiredNsgRules
    encryption: !empty(customerManagedKey) || !empty(customerManagedKeyManagedDisk)
      ? {
          entities: {
            managedServices: !empty(customerManagedKey)
              ? {
                  keySource: 'Microsoft.Keyvault'
                  keyVaultProperties: {
                    keyVaultUri: cMKKeyVault.properties.vaultUri
                    keyName: customerManagedKey!.keyName
                    keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
                      ? customerManagedKey!.keyVersion!
                      : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
                  }
                }
              : null
            managedDisk: !empty(customerManagedKeyManagedDisk)
              ? {
                  keySource: 'Microsoft.Keyvault'
                  keyVaultProperties: {
                    keyVaultUri: cMKManagedDiskKeyVault.properties.vaultUri
                    keyName: customerManagedKeyManagedDisk!.keyName
                    keyVersion: !empty(customerManagedKeyManagedDisk.?keyVersion ?? '')
                      ? customerManagedKeyManagedDisk!.keyVersion!
                      : last(split(cMKManagedDiskKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
                  }
                  rotationToLatestKeyVersionEnabled: (customerManagedKeyManagedDisk.?autoRotationEnabled ?? true == true) ?? false
                }
              : null
          }
        }
      : null
    ...(!empty(privateStorageAccount)
      ? {
          defaultStorageFirewall: privateStorageAccount
          accessConnector: {
            id: accessConnectorResourceId
            identityType: 'SystemAssigned'
          }
        }
      : {})
    ...(!empty(defaultCatalog)
      ? {
          defaultCatalog: {
            initialName: ''
            initialType: defaultCatalog.?initialType
          }
        }
      : {})
    ...(!empty(automaticClusterUpdate) || !empty(complianceStandards) || !empty(enhancedSecurityMonitoring)
      ? {
          enhancedSecurityCompliance: {
            automaticClusterUpdate: {
              value: automaticClusterUpdate
            }
            complianceSecurityProfile: {
              complianceStandards: complianceStandards
              value: complianceSecurityProfileValue
            }
            enhancedSecurityMonitoring: {
              value: enhancedSecurityMonitoring
            }
          }
        }
      : {})
  }
}

resource workspace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: workspace
}

// Note: Diagnostic Settings are only supported by the premium tier
resource workspace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
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
    scope: workspace
  }
]

resource workspace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(workspace.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: workspace
  }
]

@batchSize(1)
module workspace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-workspace-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: workspace.id
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
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(workspace.id, '/'))}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: workspace.id
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

// To reuse at multiple places instead to repeat the same code
var _storageAccountName = workspace.properties.parameters.storageAccountName.value
var _storageAccountId = resourceId(
  last(split(workspace.properties.managedResourceGroupId, '/')),
  'microsoft.storage/storageAccounts',
  workspace.properties.parameters.storageAccountName.value
)

@batchSize(1)
module storageAccount_storageAccountPrivateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (storageAccountPrivateEndpoints ?? []): if (privateStorageAccount == 'Enabled') {
    name: '${uniqueString(deployment().name, location)}-workspacestorage-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${_storageAccountName}-${privateEndpoint.service}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${_storageAccountName}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: _storageAccountId
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
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${_storageAccountName}-${privateEndpoint.service}-${index}'
              properties: {
                privateLinkServiceId: _storageAccountId
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

@description('The name of the deployed databricks workspace.')
output name string = workspace.name

@description('The resource ID of the deployed databricks workspace.')
output resourceId string = workspace.id

@description('The resource group of the deployed databricks workspace.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = workspace.location

@description('The resource ID of the managed resource group.')
output managedResourceGroupResourceId string = workspace.properties.managedResourceGroupId

@description('The name of the managed resource group.')
output managedResourceGroupName string = last(split(workspace.properties.managedResourceGroupId, '/'))

@description('The name of the DBFS storage account.')
output storageAccountName string = _storageAccountName

@description('The resource ID of the DBFS storage account.')
output storageAccountResourceId string = _storageAccountId

@description('The workspace URL which is of the format \'adb-{workspaceId}.{random}.azuredatabricks.net\'.')
output workspaceUrl string = workspace.properties.workspaceUrl

@description('The unique identifier of the databricks workspace in databricks control plane.')
output workspaceResourceId string = workspace.properties.workspaceId

@description('The private endpoints of the Databricks Workspace.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: workspace_privateEndpoints[i].outputs.name
    resourceId: workspace_privateEndpoints[i].outputs.resourceId
    groupId: workspace_privateEndpoints[i].outputs.groupId
    customDnsConfig: workspace_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: workspace_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

@description('The private endpoints of the Databricks Workspace Storage.')
output storagePrivateEndpoints array = [
  for (pe, i) in ((!empty(storageAccountPrivateEndpoints) && privateStorageAccount == 'Enabled')
    ? array(storageAccountPrivateEndpoints)
    : []): {
    name: storageAccount_storageAccountPrivateEndpoints[i].outputs.name
    resourceId: storageAccount_storageAccountPrivateEndpoints[i].outputs.resourceId
    groupId: storageAccount_storageAccountPrivateEndpoints[i].outputs.groupId
    customDnsConfig: storageAccount_storageAccountPrivateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: storageAccount_storageAccountPrivateEndpoints[i].outputs.networkInterfaceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type defaultCatalogType = {
  //This value cannot be set to a custom value. Reason --> 'InvalidInitialCatalogName' message: 'Currently custom initial catalog name is not supported. This capability will be added in future.'
  //@description('Optional. Set the name of the Catalog.')
  //initialName: ''

  @description('Required. Choose between HiveMetastore or UnityCatalog.')
  initialType: 'HiveMetastore' | 'UnityCatalog'
}
