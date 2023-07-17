param description string = ''
param principalIds array
param principalType string = ''
param roleDefinitionIdOrName string
param serverName string

var builtInRoleNames = {
  Owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'SQL DB Contributor': '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  'SQL Managed Instance Contributor': '4939a1f6-9ae0-4e48-a1e0-f2cbe897382d'
  'SQL Server Contributor': '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437'
  'SQL Security Manager': '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
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

resource postgresServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' existing = {
  name: serverName
}

var roleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
  name: guid(postgresServer.name, principalId, roleDefinitionIdOrName)
  properties: {
    description: description
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: !empty(principalType) ? principalType : null
  }
  scope: postgresServer
}]
