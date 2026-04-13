metadata name = 'Logic App Integration Account'
metadata description = 'This module deploys a Logic App Integration Account.'

@description('Required. Name of the integration account to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. All partners to create.')
param partners integrationAccountPartnerType[]?

@description('Optional. All schemas to create.')
param schemas integrationAccountSchemaType[]?

@description('Optional. All maps to create.')
param maps integrationAccountMapType[]?

@description('Optional. All assemblies to create.')
param assemblies integrationAccountAssemblyType[]?

@description('Optional. All certificates to create.')
param certificates integrationAccountCertificateType[]?

@description('Optional. All agreements to create.')
param agreements integrationAccountAgreementType[]?

@description('Optional. The state. Allowed values are Completed, Deleted, Disabled, Enabled, NotSpecified, Suspended.')
@allowed([
  'Completed'
  'Deleted'
  'Disabled'
  'Enabled'
  'NotSpecified'
  'Suspended'
])
param state string = 'Enabled'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Integration account sku name.')
@allowed([
  'Basic'
  'Free'
  'NotSpecified'
  'Standard'
])
param sku string = 'Standard'

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts@2019-05-01'>.tags?

var builtInRoleNames = {
  'App Compliance Automation Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f37683f-2463-46b6-9ce7-9b788b988ba2'
  )
  'App Compliance Automation Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0f37683f-2463-46b6-9ce7-9b788b988ba2'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Log Analytics Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  )
  'Log Analytics Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '73c42c96-874c-492b-b04d-ab87d138a893'
  )
  'Logic App Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '87a39d53-fc1b-424a-814c-f7e04687dc9e'
  )
  'Logic App Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '515c2055-d9d4-4321-b1b9-bd0c9a0f79fe'
  )
  'Managed Application Contributor Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '641177b8-a67a-45b9-a033-47bc880bb21e'
  )
  'Managed Application Operator Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'c7393b34-138c-406f-901b-d8cf2b17e6ae'
  )
  'Managed Application Publisher Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b9331d33-8a36-4f8c-b097-4f54124fdb44'
  )
  'Monitoring Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  )
  'Monitoring Metrics Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3913510d-42f4-4e42-8a64-420c390055eb'
  )
  'Monitoring Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  )
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
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

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.logic-integrationaccount.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    state: state
  }
}

resource integrationAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: integrationAccount
}

resource integrationAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: integrationAccount
  }
]

module integrationAccount_partners 'partner/main.bicep' = [
  for (partner, index) in (partners ?? []): {
    name: '${uniqueString(deployment().name, location)}-integrationAccount-Partner-${index}'
    params: {
      name: partner.name
      location: location
      integrationAccountName: integrationAccount.name
      b2b: partner.?b2b
      metadata: partner.?metadata
      tags: partner.?tags ?? tags
    }
  }
]

module integrationAccount_schemas 'schema/main.bicep' = [
  for (schema, index) in (schemas ?? []): {
    name: '${uniqueString(deployment().name, location)}-integrationAccount-Schema-${index}'
    params: {
      name: schema.name
      location: location
      integrationAccountName: integrationAccount.name
      content: schema.content
      contentType: schema.?contentType
      documentName: schema.?documentName
      metadata: schema.?metadata
      schemaType: schema.?schemaType
      targetNamespace: schema.?targetNamespace
      tags: schema.?tags ?? tags
    }
  }
]

module integrationAccount_maps 'map/main.bicep' = [
  for (map, index) in (maps ?? []): {
    name: '${uniqueString(deployment().name, location)}-integrationAccount-Map-${index}'
    params: {
      name: map.name
      location: location
      integrationAccountName: integrationAccount.name
      content: map.content
      contentType: map.?contentType
      mapType: map.?mapType
      metadata: map.?metadata
      parametersSchema: map.?parametersSchema
      tags: map.?tags ?? tags
    }
  }
]

module integrationAccount_assemblies 'assembly/main.bicep' = [
  for (assembly, index) in (assemblies ?? []): {
    name: '${uniqueString(deployment().name, location)}-integrationAccount-Assembly-${index}'
    params: {
      name: assembly.name
      location: location
      integrationAccountName: integrationAccount.name
      assemblyName: assembly.assemblyName
      content: assembly.content
      contentType: assembly.?contentType
      metadata: assembly.?metadata
      tags: assembly.?tags ?? tags
    }
  }
]

module integrationAccount_certificates 'certificate/main.bicep' = [
  for (certificate, index) in (certificates ?? []): {
    name: '${uniqueString(deployment().name, location)}-integrationAccount-Certificate-${index}'
    params: {
      name: certificate.name
      location: location
      integrationAccountName: integrationAccount.name
      key: certificate.?key
      metadata: certificate.?metadata
      publicCertificate: certificate.?publicCertificate
      tags: certificate.?tags ?? tags
    }
  }
]

module integrationAccount_agreements 'agreement/main.bicep' = [
  for (agreement, index) in (agreements ?? []): {
    name: '${uniqueString(deployment().name, location)}-integrationAccount-Agreement-${index}'
    params: {
      name: agreement.name
      location: location
      integrationAccountName: integrationAccount.name
      agreementType: agreement.agreementType
      guestIdentity: agreement.guestIdentity
      guestPartner: agreement.guestPartner
      hostIdentity: agreement.hostIdentity
      hostPartner: agreement.hostPartner
      content: agreement.content
      metadata: agreement.?metadata
      tags: agreement.?tags ?? tags
    }
    dependsOn: [
      integrationAccount_partners
    ]
  }
]

resource integrationAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      integrationAccount.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: integrationAccount
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account.')
output resourceId string = integrationAccount.id

@description('The name of the integration account.')
output name string = integrationAccount.name

@description('The location the resource was deployed into.')
output location string = integrationAccount.location

@description('The resource group the integration account was deployed into.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@description('The type for an integration account partner.')
type integrationAccountPartnerType = {
  @description('Required. The Name of the partner resource.')
  name: string

  @description('Optional. The B2B partner content settings.')
  b2b: resourceInput<'Microsoft.Logic/integrationAccounts/partners@2019-05-01'>.properties.content.b2b?

  @description('Optional. The metadata.')
  metadata: {
    @description('Optional. A metadata key-value pair.')
    *: string?
  }? // Resource-derived type fails PSRule

  @description('Optional. Resource tags.')
  tags: resourceInput<'Microsoft.Logic/integrationAccounts/partners@2019-05-01'>.tags?
}

@description('The type for an integration account certificate.')
type integrationAccountCertificateType = {
  @description('Required. The Name of the certificate resource.')
  name: string

  @description('Optional. Resource location.')
  location: string?

  @description('Optional. The key details in the key vault.')
  key: resourceInput<'Microsoft.Logic/integrationAccounts/certificates@2019-05-01'>.properties.key?

  @description('Optional. The certificate metadata.')
  metadata: resourceInput<'Microsoft.Logic/integrationAccounts/certificates@2019-05-01'>.properties.metadata?

  @description('Optional. The public certificate.')
  publicCertificate: string?

  @description('Optional. Resource tags.')
  tags: resourceInput<'Microsoft.Logic/integrationAccounts/certificates@2019-05-01'>.tags?
}

@description('The type for an integration account schema.')
type integrationAccountSchemaType = {
  @description('Required. The Name of the schema resource.')
  name: string

  @description('Optional. Resource location.')
  location: string?

  @description('Required. The schema content.')
  content: string

  @description('Optional. The schema content type.')
  contentType: string?

  @description('Optional. The document name.')
  documentName: string?

  @description('Optional. The metadata.')
  metadata: {
    @description('Optional. A metadata key-value pair.')
    *: string?
  }? // Resource-derived type fails PSRule

  @description('Optional. The schema type.')
  schemaType: string?

  @description('Optional. The target namespace of the schema.')
  targetNamespace: string?

  @description('Optional. Resource tags.')
  tags: resourceInput<'Microsoft.Logic/integrationAccounts/schemas@2019-05-01'>.tags?
}

@description('The type for an integration account map.')
type integrationAccountMapType = {
  @description('Required. The name of the map resource.')
  name: string

  @description('Optional. Resource location.')
  location: string?

  @description('Required. The content of the map.')
  content: string

  @description('Optional. The content type of the map.')
  contentType: string?

  @description('Optional. The map type. Default is "Xslt".')
  mapType: ('Liquid' | 'NotSpecified' | 'Xslt' | 'Xslt20' | 'Xslt30')?

  @description('Optional. The parameters schema of integration account map.')
  parametersSchema: resourceInput<'Microsoft.Logic/integrationAccounts/maps@2019-05-01'>.properties.parametersSchema?

  @description('Optional. The metadata.')
  metadata: {
    @description('Optional. A metadata key-value pair.')
    *: string?
  }? // Resource-derived type fails PSRule

  @description('Optional. Resource tags.')
  tags: resourceInput<'Microsoft.Logic/integrationAccounts/maps@2019-05-01'>.tags?
}

@description('The type for an integration account assembly.')
type integrationAccountAssemblyType = {
  @description('Required. The Name of the assembly resource.')
  name: string

  @description('Optional. Resource location.')
  location: string?

  @description('Required. The assembly name.')
  assemblyName: string

  @description('Required. The assembly content.')
  content: string

  @description('Optional. The assembly content type.')
  contentType: string?

  @description('Optional. The assembly metadata.')
  metadata: resourceInput<'Microsoft.Logic/integrationAccounts/assemblies@2019-05-01'>.properties.metadata?

  @description('Optional. Resource tags.')
  tags: resourceInput<'Microsoft.Logic/integrationAccounts/assemblies@2019-05-01'>.tags?
}

@description('The type for an integration account agreement.')
type integrationAccountAgreementType = {
  @description('Required. The name of the agreement resource.')
  name: string

  @description('Optional. Resource location.')
  location: string?

  @description('Required. The agreement type.')
  agreementType: ('AS2' | 'Edifact' | 'NotSpecified' | 'X12')

  @description('Required. The guest identity for the agreement.')
  guestIdentity: resourceInput<'Microsoft.Logic/integrationAccounts/agreements@2019-05-01'>.properties.guestIdentity

  @description('Required. The guest partner name for the agreement.')
  guestPartner: string

  @description('Required. The host identity for the agreement.')
  hostIdentity: resourceInput<'Microsoft.Logic/integrationAccounts/agreements@2019-05-01'>.properties.hostIdentity

  @description('Required. The host partner name for the agreement.')
  hostPartner: string

  @description('Required. The agreement content settings.')
  content: resourceInput<'Microsoft.Logic/integrationAccounts/agreements@2019-05-01'>.properties.content

  @description('Optional. The agreement metadata.')
  metadata: resourceInput<'Microsoft.Logic/integrationAccounts/agreements@2019-05-01'>.properties.metadata?

  @description('Optional. Resource tags.')
  tags: resourceInput<'Microsoft.Logic/integrationAccounts/agreements@2019-05-01'>.tags?
}
