// ========== container-instance.bicep ========== //
// Azure Container Instance module for backend API deployment

@description('Required. Name of the container group.')
param name string

@description('Required. Location for the container instance.')
param location string

@description('Optional. Tags for all resources.')
param tags object?

@description('Required. Container image to deploy.')
param containerImage string

@description('Optional. CPU cores for the container.')
param cpu int = 2

@description('Optional. Memory in GB for the container.')
param memoryInGB int = 4

@description('Optional. Port to expose.')
param port int = 8000

@description('Optional. Subnet resource ID for VNet integration. If empty, public IP will be used.')
param subnetResourceId string = ''

@description('Required. Environment variables for the container.')
param environmentVariables array

@description('Optional. Enable telemetry.')
param enableTelemetry bool = true

@description('Optional. User-assigned managed identity resource ID for ACR pull.')
param userAssignedIdentityResourceId string = ''

var isPrivateNetworking = !empty(subnetResourceId)

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerinstance.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2025-09-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityResourceId}': {}
    }
  }
  properties: {
    containers: [
      {
        name: name
        properties: {
          image: containerImage
          resources: {
            requests: {
              cpu: cpu
              memoryInGB: memoryInGB
            }
          }
          ports: [
            {
              port: port
              protocol: 'TCP'
            }
          ]
          environmentVariables: environmentVariables
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: 'Always'
    subnetIds: isPrivateNetworking
      ? [
          {
            id: subnetResourceId
          }
        ]
      : null
    ipAddress: {
      type: isPrivateNetworking ? 'Private' : 'Public'
      ports: [
        {
          port: port
          protocol: 'TCP'
        }
      ]
      dnsNameLabel: isPrivateNetworking ? null : name
    }
    // Removed imageRegistryCredentials - ACR is public with anonymous pull enabled
    // If you need managed identity auth, add AcrPull role to the managed identity on the ACR
  }
}

// ============== //
// Outputs        //
// ============== //

@description('The name of the container group.')
output name string = containerGroup.name

@description('The resource ID of the container group.')
output resourceId string = containerGroup.id

@description('The IP address of the container (private or public depending on mode).')
output ipAddress string = containerGroup.properties.ipAddress.ip

@description('The FQDN of the container (only available for public mode).')
output fqdn string = isPrivateNetworking ? '' : containerGroup.properties.ipAddress.fqdn
