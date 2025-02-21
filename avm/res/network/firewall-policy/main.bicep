metadata name = 'Firewall Policies'
metadata description = 'This module deploys a Firewall Policy.'

@description('Required. Name of the Firewall Policy.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Firewall policy resource.')
param tags object?

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityOnlyUserAssignedType?

@description('Optional. Resource ID of the base policy.')
param basePolicyResourceId string?

@description('Optional. Enable DNS Proxy on Firewalls attached to the Firewall Policy.')
param enableProxy bool = false

@description('Optional. List of Custom DNS Servers.')
param servers array?

@description('Optional. A flag to indicate if the insights are enabled on the policy.')
param insightsIsEnabled bool = false

@description('Optional. Default Log Analytics Resource ID for Firewall Policy Insights.')
param defaultWorkspaceResourceId string?

@description('Optional. List of workspaces for Firewall Policy Insights.')
param workspaces array?

@description('Optional. Number of days the insights should be enabled on the policy.')
param retentionDays int = 365

@description('Optional. The configuration for Intrusion detection.')
param intrusionDetection intrusionDetectionType?

@description('Optional. The private IP addresses/IP ranges to which traffic will not be SNAT.')
param snat snatType?

@description('Optional. Tier of Firewall Policy.')
@allowed([
  'Premium'
  'Standard'
  'Basic'
])
param tier string = 'Standard'

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

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

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

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2024-05-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    basePolicy: !empty(basePolicyResourceId)
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
              id: defaultWorkspaceResourceId
            }
            workspaces: workspaces
          }
          retentionDays: retentionDays
        }
      : null
    intrusionDetection: intrusionDetection
    sku: {
      tier: tier
    }
    snat: snat
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

@export()
@description('The type for SNAT settings.')
type snatType = {
  @description('Optional. The operation mode for automatically learning private ranges to not be SNAT.')
  autoLearnPrivateRanges: 'Disabled' | 'Enabled'

  @description('Optional. List of private IP addresses/IP address ranges to not be SNAT.')
  privateRanges: string[]?
}

@export()
@description('The type for intrusion detection settings.')
type intrusionDetectionType = {
  @description('Optional. Intrusion detection general state. When attached to a parent policy, the firewall\'s effective IDPS mode is the stricter mode of the two.')
  mode: ('Alert' | 'Deny' | 'Off')?

  @description('Optional. IDPS profile name. When attached to a parent policy, the firewall\'s effective profile is the profile name of the parent policy.')
  profile: ('Advanced' | 'Basic' | 'Extended' | 'Standard')?

  @description('Optional. Intrusion detection configuration properties.')
  configuration: {
    @description('Optional. List of rules for traffic to bypass.')
    bypassTrafficSettings: {
      @description('Optional. Description of the bypass traffic rule.')
      description: string?

      @description('Optional. List of destination IP addresses or ranges for this rule.')
      destinationAddresses: string[]?

      @description('Optional. List of destination IpGroups for this rule.')
      destinationIpGroups: string[]?

      @description('Optional. List of destination ports or ranges.')
      destinationPorts: string[]?

      @description('Required. Name of the bypass traffic rule.')
      name: string

      @description('Optional. The rule bypass protocol.')
      protocol: 'ANY' | 'ICMP' | 'TCP' | 'UDP'?

      @description('Optional. List of source IP addresses or ranges for this rule.')
      sourceAddresses: string[]?

      @description('Optional. List of source IpGroups for this rule.')
      sourceIpGroups: string[]?
    }[]?

    @description('Optional. IDPS Private IP address ranges are used to identify traffic direction (i.e. inbound, outbound, etc.). By default, only ranges defined by IANA RFC 1918 are considered private IP addresses. To modify default ranges, specify your Private IP address ranges with this property.')
    privateRanges: string[]?

    @description('Optional. List of specific signatures states.')
    signatureOverrides: {
      @description('Required. The signature id.')
      id: string

      @description('Required. The signature state.')
      mode: ('Alert' | 'Deny' | 'Off')
    }[]?
  }?
}
