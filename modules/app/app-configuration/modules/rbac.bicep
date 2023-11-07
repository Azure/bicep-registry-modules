param description string = ''
param principalIds array
param principalType string = ''
param roleDefinitionIdOrName string
param resourceId string

var builtInRoleNames = {
  Owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'App Configuration Data Owner': '5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b'
  'App Configuration Data Reader': '516239f1-63e1-4d78-a4de-a74fb236a071'
  'Log Analytics Contributor': '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  'Log Analytics Reader': '73c42c96-874c-492b-b04d-ab87d138a893'
  'Managed Application Contributor Role': '641177b8-a67a-45b9-a033-47bc880bb21e'
  'Managed Application Operator Role': 'c7393b34-138c-406f-901b-d8cf2b17e6ae'
  'Managed Applications Reader': 'b9331d33-8a36-4f8c-b097-4f54124fdb44'
  'Monitoring Contributor': '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  'Monitoring Metrics Publisher': '3913510d-42f4-4e42-8a64-420c390055eb'
  'Monitoring Reader': '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  'Resource Policy Contributor': '36243c78-bf99-498c-9df9-86d9f8d28608'
}

var roleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName)

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = {
  name: last(split(resourceId, '/'))
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
  name: guid(appConfiguration.name, principalId, roleDefinitionIdOrName, uniqueString(resourceGroup().id))
  properties: {
    description: description
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: principalType ?? null
  }
  scope: appConfiguration
}]
