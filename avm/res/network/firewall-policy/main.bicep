metadata name = 'Firewall Policies'
metadata description = 'This module deploys a Firewall Policy.'

@description('Required. Name of the Firewall Policy.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Firewall policy resource.')
param tags object?

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Resource ID of the base policy.')
param basePolicyResourceId string?

@description('Optional. Enable DNS Proxy on Firewalls attached to the Firewall Policy.')
param enableProxy bool = false

@description('Optional. List of Custom DNS Servers.')
param servers array?

@description('Optional. A flag to indicate if the insights are enabled on the policy.')
param insightsIsEnabled bool = false

@description('Optional. Default Log Analytics Resource ID for Firewall Policy Insights.')
param defaultWorkspaceId string?

@description('Optional. List of workspaces for Firewall Policy Insights.')
param workspaces array?

@description('Optional. Number of days the insights should be enabled on the policy.')
param retentionDays int = 365

@description('Optional. List of rules for traffic to bypass.')
param bypassTrafficSettings array?

@description('Optional. List of specific signatures states.')
param signatureOverrides array?

@description('Optional. The configuring of intrusion detection.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param mode string = 'Off'

@description('Optional. Tier of Firewall Policy.')
@allowed([
  'Premium'
  'Standard'
  'Basic'
])
param tier string = 'Standard'

@description('Optional. List of private IP addresses/IP address ranges to not be SNAT.')
param privateRanges array = []

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. The operation mode for automatically learning private ranges to not be SNAT.')
param autoLearnPrivateRanges string = 'Disabled'

@description('Optional. The operation mode for Threat Intel.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param threatIntelMode string = 'Off'

@description('Optional. A flag to indicate if SQL Redirect traffic filtering is enabled. Turning on the flag requires no rule using port 11000-11999.')
param allowSqlRedirect bool = false

@description('Optional. List of FQDNs for the ThreatIntel Allowlist.')
param fqdns array?

@description('Optional. List of IP addresses for the ThreatIntel Allowlist.')
param ipAddresses array?

@description('Optional. Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault.')
#disable-next-line secure-secrets-in-params // Not a secret
param keyVaultSecretId string?

@description('Optional. Name of the CA certificate.')
param certificateName string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Rule collection groups.')
param ruleCollectionGroups array?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: 'UserAssigned'
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

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
  name: '46d3xbcp.res.network-firewallpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2023-04-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    basePolicy: !empty(basePolicyResourceId ?? '')
      ? {
          id: basePolicyResourceId
        }
      : null
    dnsSettings: enableProxy
      ? {
          enableProxy: enableProxy
          servers: servers ?? []
        }
      : null
    insights: insightsIsEnabled
      ? {
          isEnabled: insightsIsEnabled
          logAnalyticsResources: {
            defaultWorkspaceId: {
              id: defaultWorkspaceId
            }
            workspaces: workspaces
          }
          retentionDays: retentionDays
        }
      : null
    intrusionDetection: (mode != 'Off')
      ? {
          configuration: {
            bypassTrafficSettings: bypassTrafficSettings
            signatureOverrides: signatureOverrides
          }
          mode: mode
        }
      : null
    sku: {
      tier: tier
    }
    snat: !empty(privateRanges)
      ? {
          autoLearnPrivateRanges: autoLearnPrivateRanges
          privateRanges: privateRanges
        }
      : null
    sql: {
      allowSqlRedirect: allowSqlRedirect
    }
    threatIntelMode: threatIntelMode
    threatIntelWhitelist: {
      fqdns: fqdns ?? []
      ipAddresses: ipAddresses ?? []
    }
    transportSecurity: (!empty(keyVaultSecretId ?? []) || !empty(certificateName ?? ''))
      ? {
          certificateAuthority: {
            keyVaultSecretId: keyVaultSecretId
            name: certificateName
          }
        }
      : null
  }
}

// When a FW policy uses a base policy and have more rule collection groups,
// they need to be deployed sequentially, otherwise the deployment would fail
// because of concurrent access to the base policy.
// The next line forces ARM to deploy them one after the other, so no race concition on the base policy will happen.
@batchSize(1)
module firewallPolicy_ruleCollectionGroups 'rule-collection-group/main.bicep' = [
  for (ruleCollectionGroup, index) in (ruleCollectionGroups ?? []): {
    name: '${uniqueString(deployment().name, location)}-firewallPolicy_ruleCollectionGroups-${index}'
    params: {
      firewallPolicyName: firewallPolicy.name
      name: ruleCollectionGroup.name
      priority: ruleCollectionGroup.priority
      ruleCollections: ruleCollectionGroup.ruleCollections
    }
  }
]

resource firewallPolicy_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(firewallPolicy.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: firewallPolicy
  }
]

resource firewallPolicy_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: firewallPolicy
}

@description('The name of the deployed firewall policy.')
output name string = firewallPolicy.name

@description('The resource ID of the deployed firewall policy.')
output resourceId string = firewallPolicy.id

@description('The resource group of the deployed firewall policy.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = firewallPolicy.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
