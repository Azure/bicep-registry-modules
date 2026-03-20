@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the container group profile to create.')
param containerGroupProfileName string

@description('Required. The name of the standby container group pool to create.')
param standbyContainerGroupPoolName string

@description('Required. The object id of the \'Standby Pool Resource Provider\' Enterprise Application.')
@secure()
param standbyPoolResourceProviderEnterpriseApplicationObjectId string

resource profile 'Microsoft.ContainerInstance/containerGroupProfiles@2025-09-01' = {
  name: containerGroupProfileName
  location: location
  properties: {
    containers: [
      {
        name: 'a-container'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld:latest'
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
          }
        }
      }
    ]
    imageRegistryCredentials: []
    ipAddress: {
      ports: [
        {
          port: 8000
          protocol: 'TCP'
        }
      ]
      type: 'Public'
    }
    osType: 'Linux'
    sku: 'Standard'
  }
}

// Ref: https://learn.microsoft.com/en-us/azure/container-instances/container-instances-standby-pool-create?tabs=rest#prerequisites
resource profilePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (role, index) in [
    '39fcb0de-8844-4706-b050-c28ddbe3ff83' // Standby Container Group Pool Contributor
    '5d977122-f97e-4b4d-a52f-6b43003ddb4d' // Azure Container Instances Contributor
    '4d97b98b-1d4f-4787-a291-c67834d212e7' // Network Contributor
  ]: {
    name: guid('msi-${resourceGroup().id}-${location}-Standby-Pool-Resource-Provider-${role}-RoleAssignment')
    properties: {
      principalId: standbyPoolResourceProviderEnterpriseApplicationObjectId
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role)
      principalType: 'ServicePrincipal'
    }
  }
]
resource standbyContainerGroupPool 'Microsoft.StandbyPool/standbyContainerGroupPools@2025-03-01' = {
  name: standbyContainerGroupPoolName
  location: location
  properties: {
    containerGroupProperties: {
      containerGroupProfile: {
        id: profile.id
        revision: 1
      }
    }
    elasticityProfile: {
      maxReadyCapacity: 3
      refillPolicy: 'always'
    }
  }
  dependsOn: [
    profilePermissions
  ]
}

@description('The resource ID of the created Container Group Profile.')
output containerGroupProfileResourceId string = profile.id

@description('The resource ID of the created Standby Container Group Pool.')
output standbyContainerGroupPoolResourceId string = standbyContainerGroupPool.id
