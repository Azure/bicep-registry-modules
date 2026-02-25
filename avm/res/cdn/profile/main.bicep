metadata name = 'CDN Profiles'
metadata description = 'This module deploys a CDN Profile.'

@description('Required. Name of the CDN profile.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  'Premium_AzureFrontDoor'
  'StandardPlus_955BandWidth_ChinaCdn'
  'StandardPlus_AvgBandWidth_ChinaCdn'
  'StandardPlus_ChinaCdn'
  'Standard_955BandWidth_ChinaCdn'
  'Standard_AvgBandWidth_ChinaCdn'
  'Standard_AzureFrontDoor'
  'Standard_ChinaCdn'
  'Standard_Microsoft'
])
@description('Required. The pricing tier (defines a CDN provider, feature list and rate) of the CDN profile.')
param sku string

@description('Optional. Send and receive timeout on forwarding request to the origin.')
param originResponseTimeoutSeconds int = 60

@description('Optional. Endpoint properties (see [ref](https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties) for details).')
param endpoint endpointType?

@description('Optional. Array of secret objects.')
param secrets secretType[]?

@description('Optional. Array of custom domain objects.')
param customDomains customDomainType[]?

@description('Conditional. Array of origin group objects. Required if the afdEndpoints is specified.')
param originGroups originGroupType[]?

@description('Optional. Array of rule set objects.')
param ruleSets ruleSetType[]?

@description('Optional. Array of AFD endpoint objects.')
param afdEndpoints afdEndpointType[]?

@description('Optional. Array of Security Policy objects (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/securitypolicies for details).')
param securityPolicies securityPolicyType[]?

@description('Optional. Endpoint tags.')
param tags resourceInput<'Microsoft.Cdn/profiles@2025-06-01'>.tags?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

var builtInRoleNames = {
  'CDN Endpoint Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '426e0c7f-0c7e-4658-b36f-ff54d6c29b45'
  )
  'CDN Endpoint Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '871e35f6-b5c1-49cc-a043-bde969a0f2cd'
  )
  'CDN Profile Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ec156ff8-a8d1-4d15-830c-5b80698ca432'
  )
  'CDN Profile Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '8f96442b-4075-438f-813d-ad51ab4019af'
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

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(formattedUserAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(formattedUserAssignedIdentities) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cdn-profile.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource profile 'Microsoft.Cdn/profiles@2025-06-01' = {
  name: name
  location: location
  identity: identity
  sku: {
    name: sku
  }
  properties: {
    originResponseTimeoutSeconds: originResponseTimeoutSeconds
  }
  tags: tags
}

resource profile_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: profile
}

resource profile_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(profile.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: profile
  }
]

resource profile_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: profile
  }
]

module profile_endpoint 'endpoint/main.bicep' = if (!empty(endpoint)) {
  name: '${uniqueString(deployment().name, location)}-Profile-Endpoint'
  params: {
    profileName: profile.name
    name: endpoint.?name ?? '${profile.name}-endpoint'
    properties: endpoint!.properties
    location: location
    tags: endpoint.?tags ?? tags
  }
}

module profile_secrets 'secret/main.bicep' = [
  for (secret, index) in (secrets ?? []): {
    name: '${uniqueString(deployment().name)}-Profile-Secret-${index}'
    params: {
      name: secret.name
      profileName: profile.name
      type: secret.type
      secretSourceResourceId: secret.secretSourceResourceId
      subjectAlternativeNames: secret.?subjectAlternativeNames
      useLatestVersion: secret.?useLatestVersion
      secretVersion: secret.?secretVersion
    }
  }
]

module profile_customDomains 'custom-domain/main.bicep' = [
  for (customDomain, index) in (customDomains ?? []): {
    name: '${uniqueString(deployment().name)}-CustomDomain-${index}'
    dependsOn: [
      profile_secrets
    ]
    params: {
      name: customDomain.name
      profileName: profile.name
      hostName: customDomain.hostName
      azureDnsZoneResourceId: customDomain.?azureDnsZoneResourceId
      extendedProperties: customDomain.?extendedProperties
      certificateType: customDomain.certificateType
      minimumTlsVersion: customDomain.?minimumTlsVersion
      preValidatedCustomDomainResourceId: customDomain.?preValidatedCustomDomainResourceId
      secretName: customDomain.?secretName
      cipherSuiteSetType: customDomain.?cipherSuiteSetType
      customizedCipherSuiteSet: customDomain.?customizedCipherSuiteSet
    }
  }
]

module profile_originGroups 'origin-group/main.bicep' = [
  for (origingroup, index) in (originGroups ?? []): {
    name: '${uniqueString(deployment().name)}-Profile-OriginGroup-${index}'
    params: {
      name: origingroup.name
      profileName: profile.name
      loadBalancingSettings: origingroup.loadBalancingSettings
      healthProbeSettings: origingroup.?healthProbeSettings
      sessionAffinityState: origingroup.?sessionAffinityState
      trafficRestorationTimeToHealedOrNewEndpointsInMinutes: origingroup.?trafficRestorationTimeToHealedOrNewEndpointsInMinutes
      origins: origingroup.origins
    }
  }
]

module profile_ruleSets 'rule-set/main.bicep' = [
  for (ruleSet, index) in (ruleSets ?? []): {
    name: '${uniqueString(deployment().name)}-Profile-RuleSet-${index}'
    dependsOn: [
      profile_originGroups
    ]
    params: {
      name: ruleSet.name
      profileName: profile.name
      rules: ruleSet.?rules
    }
  }
]

module profile_afdEndpoints 'afd-endpoint/main.bicep' = [
  for (afdEndpoint, index) in (afdEndpoints ?? []): {
    name: '${uniqueString(deployment().name)}-Profile-AfdEndpoint-${index}'
    dependsOn: [
      profile_originGroups
      profile_customDomains
      profile_ruleSets
    ]
    params: {
      name: afdEndpoint.name
      location: location
      profileName: profile.name
      autoGeneratedDomainNameLabelScope: afdEndpoint.?autoGeneratedDomainNameLabelScope
      enabledState: afdEndpoint.?enabledState
      routes: afdEndpoint.?routes
      tags: afdEndpoint.?tags ?? tags
    }
  }
]

module profile_securityPolicies 'security-policy/main.bicep' = [
  for (securityPolicy, index) in (securityPolicies ?? []): {
    name: '${uniqueString(deployment().name)}-Profile-SecurityPolicy-${index}'
    dependsOn: [
      profile_afdEndpoints
      profile_customDomains
    ]
    params: {
      name: securityPolicy.name
      profileName: profile.name
      associations: securityPolicy.associations
      wafPolicyResourceId: securityPolicy.wafPolicyResourceId
    }
  }
]

@description('The name of the CDN profile.')
output name string = profile.name

@description('The resource ID of the CDN profile.')
output resourceId string = profile.id

@description('The resource group where the CDN profile is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The type of the CDN profile.')
output profileType string = profile.type

@description('The location the resource was deployed into.')
output location string = profile.location

@description('The name of the CDN profile endpoint.')
output endpointName string? = profile_endpoint.?outputs.?name

@description('The resource ID of the CDN profile endpoint.')
output endpointId string? = profile_endpoint.?outputs.?resourceId

@description('The uri of the CDN profile endpoint.')
output uri string? = profile_endpoint.?outputs.?uri

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = profile.?identity.?principalId

@description('The list of records required for custom domains validation.')
output dnsValidation dnsValidationOutputType[] = [
  for (customDomain, index) in (customDomains ?? []): profile_customDomains[index].outputs.dnsValidation
]

@description('The list of AFD endpoint host names.')
output frontDoorEndpointHostNames string[] = [
  for (afdEndpoint, index) in (afdEndpoints ?? []): profile_afdEndpoints[index].outputs.frontDoorEndpointHostName
]

// =============== //
//   Definitions   //
// =============== //

import { routeType } from 'afd-endpoint/main.bicep'
import { dnsValidationOutputType } from 'custom-domain/main.bicep'
import { originType } from 'origin-group/main.bicep'
import { associationsType } from 'security-policy/main.bicep'
import { ruleType } from 'rule-set/main.bicep'

@export()
type securityPolicyType = {
  @description('Required. Name of the security policy.')
  name: string

  @description('Required. Domain names and URL patterns to match with this association.')
  associations: associationsType[]

  @description('Required. Resource ID of WAF policy.')
  wafPolicyResourceId: string
}

@export()
@description('The type of the origin group.')
type originGroupType = {
  @description('Required. The name of the origin group.')
  name: string

  @description('Optional. Health probe settings to the origin that is used to determine the health of the origin.')
  healthProbeSettings: resourceInput<'Microsoft.Cdn/profiles/originGroups@2025-04-15'>.properties.healthProbeSettings?

  @description('Required. Load balancing settings for a backend pool.')
  loadBalancingSettings: resourceInput<'Microsoft.Cdn/profiles/originGroups@2025-04-15'>.properties.loadBalancingSettings

  @description('Optional. Whether to allow session affinity on this host.')
  sessionAffinityState: 'Enabled' | 'Disabled' | null

  @description('Optional. Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins.')
  trafficRestorationTimeToHealedOrNewEndpointsInMinutes: int?

  @description('Required. The list of origins within the origin group.')
  origins: originType[]
}

@export()
@description('The type of the rule set.')
type ruleSetType = {
  @description('Required. Name of the rule set.')
  name: string

  @description('Optional. Array of rules.')
  rules: ruleType[]?
}

@export()
@description('The type of the AFD Endpoint.')
type afdEndpointType = {
  @description('Required. The name of the AFD Endpoint.')
  name: string

  @description('Optional. The list of routes for this AFD Endpoint.')
  routes: routeType[]?

  @description('Optional. The tags for the AFD Endpoint.')
  tags: resourceInput<'Microsoft.Cdn/profiles/endpoints@2025-06-01'>.tags?

  @description('Optional. The scope of the auto-generated domain name label.')
  autoGeneratedDomainNameLabelScope: 'NoReuse' | 'ResourceGroupReuse' | 'SubscriptionReuse' | 'TenantReuse' | null

  @description('Optional. The state of the AFD Endpoint.')
  enabledState: 'Enabled' | 'Disabled' | null
}

@export()
@description('The type of the custom domain.')
type customDomainType = {
  @description('Required. The name of the custom domain.')
  name: string

  @description('Required. The host name of the custom domain.')
  hostName: string

  @description('Required. The type of the certificate.')
  certificateType: 'AzureFirstPartyManagedCertificate' | 'CustomerCertificate' | 'ManagedCertificate'

  @description('Optional. The resource ID of the Azure DNS zone.')
  azureDnsZoneResourceId: string?

  @description('Optional. The resource ID of the pre-validated custom domain.')
  preValidatedCustomDomainResourceId: string?

  @description('Optional. The name of the secret.')
  secretName: string?

  @description('Optional. The minimum TLS version.')
  minimumTlsVersion: 'TLS10' | 'TLS12' | 'TLS13' | null

  @description('Optional. Extended properties.')
  extendedProperties: resourceInput<'Microsoft.Cdn/profiles/customDomains@2025-06-01'>.properties.extendedProperties?

  @description('Optional. The cipher suite set type that will be used for Https.')
  cipherSuiteSetType: string?

  @description('Optional. The customized cipher suite set that will be used for Https.')
  customizedCipherSuiteSet: resourceInput<'Microsoft.Cdn/profiles/customDomains@2025-06-01'>.properties.tlsSettings.customizedCipherSuiteSet?
}

@export()
@description('The type of and endpoint.')
type endpointType = {
  @description('Required. Name of the endpoint under the profile which is unique globally.')
  name: string

  @description('Required. Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).')
  properties: resourceInput<'microsoft.cdn/profiles/endpoints@2025-04-15'>.properties

  @description('Optional. Endpoint tags.')
  tags: resourceInput<'microsoft.cdn/profiles/endpoints@2025-04-15'>.tags?
}

@export()
@description('The type of a secret.')
type secretType = {
  @description('Required. The name of the secret.')
  name: string

  @description('Optional. The type of the secret.')
  type: ('AzureFirstPartyManagedCertificate' | 'CustomerCertificate' | 'ManagedCertificate' | 'UrlSigningKey')?

  @description('Conditional. The resource ID of the secret source. Required if the `type` is "CustomerCertificate".')
  #disable-next-line secure-secrets-in-params
  secretSourceResourceId: string?

  @description('Optional. The version of the secret.')
  secretVersion: string?

  @description('Optional. The subject alternative names of the secret.')
  subjectAlternativeNames: string[]?

  @description('Optional. Indicates whether to use the latest version of the secret.')
  useLatestVersion: bool?
}
