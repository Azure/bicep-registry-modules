metadata name = 'Azure Managed Redis Database Access Policy Assignment'
metadata description = 'This module deploys an access policy assignment for an Azure Managed Redis database.'

@description('Optional. Name of the access policy assignment.')
param name string?

@description('Required. Object ID to which the access policy will be assigned.')
param userObjectId string

@description('Conditional. The name of the grandparent Azure Managed Redis cluster. Required if the template is used in a standalone deployment.')
param clusterName string

@description('Conditional. The name of the parent Azure Managed Redis database. Required if the template is used in a standalone deployment.')
param databaseName string

@allowed([
  'default'
])
@description('Optional. Name of the access policy to be assigned.')
param accessPolicyName string = 'default'

resource redisCluster 'Microsoft.Cache/redisEnterprise@2025-05-01-preview' existing = {
  name: clusterName

  resource database 'databases@2025-05-01-preview' existing = {
    name: databaseName
  }
}

resource accessPolicyAssignment 'Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments@2025-05-01-preview' = {
  name: name ?? userObjectId
  parent: redisCluster::database
  properties: {
    accessPolicyName: accessPolicyName
    user: {
      objectId: userObjectId
    }
  }
}

@description('The name of the access policy assignment.')
output name string = accessPolicyAssignment.name

@description('The resource ID of the access policy assignment.')
output resourceId string = accessPolicyAssignment.id

@description('The resource group the access policy assignment was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The object ID of the user associated with the access policy.')
output userObjectId string = accessPolicyAssignment.properties.user.objectId
