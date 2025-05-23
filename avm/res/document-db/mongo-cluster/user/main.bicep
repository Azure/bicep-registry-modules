metadata name = 'Azure Cosmos DB for MongoDB (vCore) cluster user'
metadata description = 'This module creates a user within an Azure Cosmos DB for MongoDB (vCore) cluster. These users are used to connect to the cluster and perform operations using Microsoft Entra authentication.'

@description('Conditional. The name of the parent Azure Cosmos DB for MongoDB (vCore) cluster. Required if the template is used in a standalone deployment.')
param mongoClusterName string

@description('Optional. Default to current resource group scope location. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The principal/identity to create as a user on the cluster.')
param targetIdentity targetPrincipalPropertiesType

@description('Optional. The roles to assign to the user per database. Defaults to the "dbOwner" role on the "admin" database.')
param targetRoles rolePropertiesType[] = [
  {
    database: 'admin'
    role: 'dbOwner'
  }
]

resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2025-04-01-preview' existing = {
  name: mongoClusterName
}

resource user 'Microsoft.DocumentDB/mongoClusters/users@2025-04-01-preview' = {
  name: targetIdentity.principalId
  parent: mongoCluster
  location: location
  properties: {
    identityProvider: {
      type: 'MicrosoftEntraID'
      properties: {
        principalType: targetIdentity.?principalType
      }
    }
    roles: [
      for targetRole in targetRoles: {
        db: targetRole.database
        role: targetRole.role
      }
    ]
  }
}

@description('The name of the resource group the Azure Cosmos DB for MongoDB (vCore) cluster was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the user.')
output name string = user.name

@description('The resource ID of the user.')
output resourceId string = user.id

@export()
@description('Properties for the identity associated with the user.')
type targetPrincipalPropertiesType = {
  @description('Required. The principal (object) ID of the identity to create as a user on the cluster.')
  principalId: string

  @description('Required. The type of principal to be used for the identity provider.')
  principalType: 'ServicePrincipal' | 'User'
}

@export()
@description('Properties for the role[s] assigned to the user.')
type rolePropertiesType = {
  @description('Required. The database to assign the role to.')
  database: 'admin'

  @description('Required. The role to assign to the user.')
  role: 'dbOwner'
}
