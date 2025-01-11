metadata name = 'Azure Managed Redis (Preview) Database Access Policy Assignment'
metadata description = 'This module deploys an access policy assignment for an Azure Managed Redis (Preview) database.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Name of the access policy assignment.')
param name string?

@description('Required. Object ID to which the access policy will be assigned.')
param objectId string

@description('Conditional. The name of the grandparent Azure Managed Redis (Preview) cluster. Required if the template is used in a standalone deployment.')
param clusterName string

@description('Conditional. The name of the parent Azure Managed Redis (Preview) database. Required if the template is used in a standalone deployment.')
param databaseName string

@allowed([
  'default'
])
@description('Optional. Name of the access policy to be assigned.')
param accessPolicyName string = 'default'

resource redisCluster 'Microsoft.Cache/redisEnterprise@2023-08-01-preview' existing = {
  name: clusterName

  resource database 'databases@2023-08-01-preview' existing = {
    name: databaseName
  }
}

resource accessPolicyAssignment 'Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments@2024-09-01-preview' = {
  name: name ?? objectId
  parent: redisCluster::database
  properties: {
    accessPolicyName: accessPolicyName
    user: {
      objectId: objectId
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
