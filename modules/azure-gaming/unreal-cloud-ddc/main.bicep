@description('Deployment Location')
param location string = resourceGroup().location

@description('Secondary Deployment Locations')
param secondaryLocations array = []

@description('Create new or use existing Kubernetes resource')
@allowed([
  'new'
  'existing'
])
param newOrExistingKubernetes string = 'new'

@description('Kubernetes cluster name')
param name string = 'horde-storage-${uniqueString(resourceGroup().id)}'

@description('Agent Pool Count')
param agentPoolCount int = 3

@description('Agent Pool Name')
param agentPoolName string = 'k8agent'

@description('Agent Pool VM Size')
param vmSize string = 'Standard_L16s_v3'

@description('Horde Storage Endpoint')
param hostname string = 'deploy1.horde-storage.gaming.azure.com'

@description('Enable Zone Redundancy in available regions (when true, unsupported regions are automatically set to false)')
param isZoneRedundant bool = false

@description('Create new or use existing Storage Account')
@allowed([
  'new'
  'existing'
])
param newOrExistingStorageAccount string = 'new'
@description('Storage Account name')
param storageAccountName string = 'hordestore${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Create new or use existing Key Vault')
@allowed([
  'new'
  'existing'
])
param newOrExistingKeyVault string = 'new'
@description('Key Vault name')
param keyVaultName string = take('hordeKeyVault${uniqueString(resourceGroup().id, subscription().subscriptionId, publishers[publisher].version, location)}', 24)

@description('Create new or use existing Public IP Address')
@allowed([
  'new'
  'existing'
])
param newOrExistingPublicIp string = 'new'

@description('Public IP Address name')
param publicIpName string = 'hordePublicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Create new or use existing Traffic Manager Profile')
@allowed([
  'new'
  'existing'
])
param newOrExistingTrafficManager string = 'new'

@description('Traffic Manager Profile name')
param trafficManagerName string = 'hordePublicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@description('Create new or use existing Cosmos DB Resource')
@allowed([
  'new'
  'existing'
])
param newOrExistingCosmosDB string = 'new'

@description('Cosmos DB Resource name')
param cosmosDBName string = 'hordeDB-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Service Principal Object ID')
param servicePrincipalObjectID string = ''

@description('Service Principal Client ID')
param servicePrincipalClientID string = ''

@description('Name of Certificate (Default certificate is self-signed)')
param certificateName string = 'horde-storage-cert'

@description('Set to true to agree to the terms and conditions of the Epic Games EULA found here: https://store.epicgames.com/en-US/eula')
param unityEULA bool = false

@description('Managed Resource Group Name')
param managedResourceGroupSuffix string = 'mrg'

@description('Publisher Environment')
@allowed([
  'dev'
  'prod'
])
param publisher string = 'dev'

@description('Publisher Listings')
param publishers object = {
  dev: {
    name: 'preview'
    product: 'horde-storage-preview'
    publisher: 'microsoftcorporation1590077852919'
    version: '1.0.413'
  }
  preview: {
    name: 'preview'
    product: 'horde-storage-preview'
    publisher: 'microsoft-azure-gaming'
    version: '0.0.22'
  }
  prod: {
    name: 'aks'
    product: 'horde-storage'
    publisher: 'microsoft-azure-gaming'
    version: '0.0.22'
  }
}

@description('Certificate Issuer (Default certificate is self-signed, and value is Self)')
param certificateIssuer string = 'Self'

@description('Issuer Provider (Required when creating a new signed certificate)')
param issuerProvider string = ''

var managedResourceGroupId = '${subscription().id}/resourceGroups/${resourceGroup().name}-${managedResourceGroupSuffix}${replace(publishers[publisher].version, '.', '-')}'

module prepareResources 'modules/DeployResources.bicep' = {
  name: 'prepareResources'
  params: {
    location: location
    secondaryLocations: secondaryLocations
    newOrExistingKubernetes: newOrExistingKubernetes
    name: name
    agentPoolCount: agentPoolCount
    agentPoolName: agentPoolName
    vmSize: vmSize
    isZoneRedundant: isZoneRedundant
    newOrExistingStorageAccount: newOrExistingStorageAccount
    storageAccountName: storageAccountName
    newOrExistingKeyVault: newOrExistingKeyVault
    keyVaultName: keyVaultName
    newOrExistingPublicIp: newOrExistingPublicIp
    publicIpName: publicIpName
    newOrExistingTrafficManager: newOrExistingTrafficManager
    trafficManagerName: trafficManagerName
    trafficManagerDnsName: trafficManagerDnsName
    newOrExistingCosmosDB: newOrExistingCosmosDB
    cosmosDBName: cosmosDBName
  }
}

resource hordeStorage 'Microsoft.Solutions/applications@2017-09-01' = {
  location: location
  kind: 'MarketPlace'
  name: '${name}${replace(publishers[publisher].version, '.', '-')}'
  plan: publishers[publisher]
  properties: {
    managedResourceGroupId: managedResourceGroupId
    parameters: {
      location: {
        value: location
      }
      secondaryLocations: {
        value: secondaryLocations
      }
      newOrExistingKubernetes: {
        value: 'existing'
      }
      name: {
        value: name
      }
      agentPoolCount: {
        value: agentPoolCount
      }
      agentPoolName: {
        value: agentPoolName
      }
      vmSize: {
        value: vmSize
      }
      hostname: {
        value: hostname
      }
      certificateIssuer: {
        value: certificateIssuer
      }
      issuerProvider: {
        value: issuerProvider
      }
      assignRole: {
        value: true
      }
      newOrExistingStorageAccount: {
        value: 'existing'
      }
      storageAccountName: {
        value: storageAccountName
      }
      newOrExistingKeyVault: {
        value: 'existing'
      }
      keyVaultName: {
        value: keyVaultName
      }
      newOrExistingPublicIp: {
        value: 'existing'
      }
      publicIpName: {
        value: publicIpName
      }
      newOrExistingTrafficManager: {
        value: 'existing'
      }
      trafficManagerName: {
        value: trafficManagerName
      }
      trafficManagerDnsName: {
        value: trafficManagerDnsName
      }
      newOrExistingCosmosDB: {
        value: 'existing'
      }
      cosmosDBName: {
        value: cosmosDBName
      }
      servicePrincipalObjectID: {
        value: servicePrincipalObjectID
      }
      servicePrincipalClientID: {
        value: servicePrincipalClientID
      }
      certificateName: {
        value: certificateName
      }
      unityEULA: {
        value: unityEULA
      }
      isZoneRedundant: {
        value: isZoneRedundant
      }
    }
    jitAccessPolicy: null
  }
}
