metadata name = 'CDN Profiles'
metadata description = 'This module deploys a CDN Profile.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the CDN profile.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@allowed([
  'Custom_Verizon'
  'Premium_AzureFrontDoor'
  'Premium_Verizon'
  'StandardPlus_955BandWidth_ChinaCdn'
  'StandardPlus_AvgBandWidth_ChinaCdn'
  'StandardPlus_ChinaCdn'
  'Standard_955BandWidth_ChinaCdn'
  'Standard_AvgBandWidth_ChinaCdn'
  'Standard_AzureFrontDoor'
  'Standard_ChinaCdn'
  'Standard_Microsoft'
  'Standard_Verizon'
])
@description('Required. The pricing tier (defines a CDN provider, feature list and rate) of the CDN profile.')
param sku string

@description('Optional. Send and receive timeout on forwarding request to the origin.')
param originResponseTimeoutSeconds int = 60

@description('Optional. Name of the endpoint under the profile which is unique globally.')
param endpointName string?

@description('Optional. Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).')
param endpointProperties object?

@description('Optional. Array of secret objects.')
param secrets array = []

@description('Optional. Array of custom domain objects.')
param customDomains array = []

@description('Conditional. Array of origin group objects. Required if the afdEndpoints is specified.')
param originGroups array = []

@description('Optional. Array of rule set objects.')
param ruleSets array = []

@description('Optional. Array of AFD endpoint objects.')
param afdEndpoints array = []

@description('Optional. Endpoint tags.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
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

resource profile 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: name
  location: location
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
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
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

module profile_endpoint 'endpoint/main.bicep' = if (!empty(endpointProperties)) {
  name: '${uniqueString(deployment().name, location)}-Profile-Endpoint'
  params: {
    name: endpointName ?? '${profile.name}-endpoint'
    properties: endpointProperties ?? {}
    location: location
    profileName: profile.name
  }
}

module profile_secrets 'secret/main.bicep' = [
  for (secret, index) in secrets: {
    name: '${uniqueString(deployment().name)}-Profile-Secret-${index}'
    params: {
      name: secret.name
      profileName: profile.name
      type: secret.type
      secretSourceResourceId: secret.secretSourceResourceId
      subjectAlternativeNames: secret.?subjectAlternativeNames
      useLatestVersion: secret.?useLatestVersion
      secretVersion: secret.secretVersion
    }
  }
]

module profile_customDomains 'customdomain/main.bicep' = [
  for (customDomain, index) in customDomains: {
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
    }
  }
]

module profile_originGroups 'origingroup/main.bicep' = [
  for (origingroup, index) in originGroups: {
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

module profile_ruleSets 'ruleset/main.bicep' = [
  for (ruleSet, index) in ruleSets: {
    name: '${uniqueString(deployment().name)}-Profile-RuleSet-${index}'
    params: {
      name: ruleSet.name
      profileName: profile.name
      rules: ruleSet.rules
    }
  }
]

module profile_afdEndpoints 'afdEndpoint/main.bicep' = [
  for (afdEndpoint, index) in afdEndpoints: {
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
output endpointName string = !empty(endpointProperties) ? profile_endpoint.outputs.name : ''

@description('The resource ID of the CDN profile endpoint.')
output endpointId string = !empty(endpointProperties) ? profile_endpoint.outputs.resourceId : ''

@description('The uri of the CDN profile endpoint.')
output uri string = !empty(endpointProperties) ? profile_endpoint.outputs.uri : ''

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
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
