metadata name = 'Container Registry Module'
// AVM-compliant Azure Container Registry deployment

@description('Required. The name of the Azure Container Registry.')
param acrName string

@description('Required. The location of the Azure Container Registry.')
param location string

@description('Optional. SKU for the Azure Container Registry.')
param acrSku string = 'Premium'

@description('Optional. Public network access setting for the Azure Container Registry.')
param publicNetworkAccess string = 'Enabled'

@description('Optional. Zone redundancy setting for the Azure Container Registry.')
param zoneRedundancy string = 'Disabled'

@description('Optional. Tags to be applied to the Container Registry.')
param tags object = {}

@description('Required. Enable telemetry for the AVM deployment.')
param enableTelemetry bool

@description('Required. Enable Redundancy for the AVM deployment.')
param enableRedundancy bool

@description('Required. The secondary location for the Azure Container Registry replication, if redundancy is enabled.')
param secondaryLocation string

module avmContainerRegistry 'br/public:avm/res/container-registry/registry:0.9.3' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: acrSku
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
    tags: tags
    enableTelemetry: enableTelemetry
    replications: enableRedundancy
      ? [
          {
            location: secondaryLocation
            name: 'acrrepl${replace(secondaryLocation, '-', '')}'
          }
        ]
      : null
  }
}

output resourceId string = avmContainerRegistry.outputs.resourceId
output loginServer string = avmContainerRegistry.outputs.loginServer
