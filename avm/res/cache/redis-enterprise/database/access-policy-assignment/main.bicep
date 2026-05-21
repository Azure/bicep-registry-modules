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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cache-redisenterprise-databaseaccess.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource redisCluster 'Microsoft.Cache/redisEnterprise@2025-07-01' existing = {
  name: clusterName

  resource database 'databases@2025-07-01' existing = {
    name: databaseName
  }
}

resource accessPolicyAssignment 'Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments@2025-07-01' = {
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
