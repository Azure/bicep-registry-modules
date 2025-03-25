metadata name = 'Azure Maps Account'
metadata description = 'This module deploys an Azure Maps Account.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@allowed(['G2'])
@description('Optional. The SKU of the Maps Account. Default is G2.')
param sku string = 'G2'

@description('Optional. The kind of the Maps Account. Default is Gen2.')
param kind string = 'Gen2'

@description('Optional. List of additional data processing regions for the Maps Account, which may result in requests being processed in another geography. Some features or results may be restricted to specific regions. By default, Maps REST APIs process requests according to the account location or the geographic scope.')
param locations string[]?

@description('Optional. Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service.')
param corsRules corsRuleType[]?

@description('Optional. The array of associated resources to the Maps account. Linked resource in the array cannot individually update, you must update all linked resources in the array together. These resources may be used on operations on the Azure Maps REST API. Access is controlled by the Maps Account Managed Identity(s) permissions to those resource(s).')
param linkedResources linkedResourceType[]?

@description('Optional. Allows toggle functionality on Azure Policy to disable Azure Maps local authentication support. This will disable Shared Keys and Shared Access Signature Token authentication from any usage. Default is true.')
param disableLocalAuth bool = true

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
@allowed(['enabled', 'disabled'])
param requireInfrastructureEncryption string = 'disabled'

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  'Azure Maps Search and Render Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '6be48352-4f82-47c9-ad5e-0acacefdb005'
  )
  'Azure Maps Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '423170ca-a8f6-4b0f-8487-9e4eb8f49bfa'
  )
  'Azure Maps Data Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '8f5e0ce6-4f7b-4dcf-bddf-e6f48634a204'
  )
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

// ============== //
// Resources      //
// ============== //
#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.maps-account.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId, '/')[4]
  )
}

var encryptionProperties = !empty(customerManagedKey)
  ? {
      encryption: {
        customerManagedKeyEncryption: {
          keyEncryptionKeyIdentity: {
            userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? cMKUserAssignedIdentity.id
              : null
            identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? 'userAssignedIdentity'
              : 'systemAssignedIdentity'
          }
          keyEncryptionKeyUrl: customerManagedKey.?keyEncryptionKeyUrl
        }
      }
      requireInfrastructureEncryption: requireInfrastructureEncryption
    }
  : {}

var corsRulesProperty = [
  for rule in corsRules ?? []: {
    allowedOrigins: rule.allowedOrigins
  }
]

var locationProperty = [
  for dataLocation in locations ?? []: {
    locationName: dataLocation
  }
]

var properties = {
  linkedResources: map(linkedResources ?? [], resource => {
    id: resource.resourceId
    uniqueName: resource.uniqueName
  })
  cors: {
    corsRules: corsRulesProperty
  }
  disableLocalAuth: disableLocalAuth
  locations: locationProperty
}

resource mapsAccount 'Microsoft.Maps/accounts@2024-07-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  identity: identity
  kind: kind
  tags: tags
  properties: {
    linkedResources: map(linkedResources ?? [], resource => {
      id: resource.resourceId
      uniqueName: resource.uniqueName
    })
    cors: {
      corsRules: corsRulesProperty
    }
    disableLocalAuth: disableLocalAuth
    locations: locationProperty
    ...(!empty(customerManagedKey)
      ? {
          encryption: {
            customerManagedKeyEncryption: {
              keyEncryptionKeyIdentity: {
                userAssignedIdentityResourceId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
                  ? cMKUserAssignedIdentity.id
                  : null
                identityType: !empty(customerManagedKey.?userAssignedIdentityResourceId)
                  ? 'userAssignedIdentity'
                  : 'systemAssignedIdentity'
              }
              keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
                ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
                : (customerManagedKey.?autoRotationEnabled ?? true)
                    ? cMKKeyVault::cMKKey.properties.keyUri
                    : cMKKeyVault::cMKKey.properties.keyUriWithVersion
            }
            infrastructureEncryption: requireInfrastructureEncryption // Property renamed
          }
        }
      : {})
  }
}

resource mapsAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(mapsAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: mapsAccount
  }
]

// ============ //
// Outputs      //
// ============ //
@description('The resource ID of the Maps Account.')
output resourceId string = mapsAccount.id

@description('The name of the resource group the Maps Account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Maps Account.')
output name string = mapsAccount.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = mapsAccount.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = mapsAccount.location

// ================ //
// Definitions      //
// ================ //
@export()
@description('The type of the CORS rule.')
type corsRuleType = {
  @description('Required. The allowed origins for the CORS rule.')
  allowedOrigins: string[]
}

@export()
@description('The type of the linked resource.')
type linkedResourceType = {
  @description('Required. ARM resource id in the form: \'/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/accounts/{storageName}\'.')
  resourceId: string
  @description('Required. A provided name which uniquely identifies the linked resource.')
  uniqueName: string
}

@export()
@description('The type of the customer managed key encryption.')
type customerManagedKeyType = {
  @description('Required. The resource ID of the Key Vault.')
  keyVaultResourceId: string
  #disable-next-line no-hardcoded-env-urls
  @description('Required. key encryption key Url, versioned or unversioned. Ex: https://contosovault.vault.azure.net/keys/contosokek/562a4bb76b524a1493a6afe8e536ee78 or https://contosovault.vault.azure.net/keys/contosokek.')
  keyEncryptionKeyUrl: string
  @description('Optional. The resource ID of the user assigned identity to use for encryption.')
  userAssignedIdentityResourceId: string?
}
