@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the log analytics workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the container group profile to create.')
param containerGroupProfileName string

@description('Required. The name of the standby container group pool to create.')
param standbyContainerGroupPoolName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: logAnalyticsWorkspaceName
  location: location
}

resource profile 'Microsoft.ContainerInstance/containerGroupProfiles@2025-09-01' = {
  name: containerGroupProfileName
  location: location
  properties: {
    containers: [
      {
        name: 'Privileged'
        properties: {
          command: []
          environmentVariables: []
          image: 'confiimage'
          ports: [
            {
              port: 8000
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: json('1.5')
            }
          }
          securityContext: {
            privileged: false
            capabilities: {
              add: [
                'CAP_NET_ADMIN'
              ]
            }
          }
        }
      }
    ]
    osType: 'Linux'
  }
}

resource standbyContainerGroupPool 'Microsoft.StandbyPool/standbyContainerGroupPools@2025-03-01' = {
  name: standbyContainerGroupPoolName
  location: location
  properties: {
    containerGroupProperties: {
      containerGroupProfile: {
        id: profile.id
      }
    }
    elasticityProfile: {
      maxReadyCapacity: 3
    }
  }
}

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The resource ID of the created Container Group Profile.')
output containerGroupProfileResourceId string = profile.id

@description('The resource ID of the created Standby Container Group Pool.')
output standbyContainerGroupPoolResourceId string = standbyContainerGroupPool.id

@description('The resource ID of the created managed identity.')
output managedIdentityResourceId string = managedIdentity.id
