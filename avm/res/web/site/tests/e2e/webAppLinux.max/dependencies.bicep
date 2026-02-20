@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Relay Namespace to create.')
param relayNamespaceName string

@description('Required. The name of the Hybrid Connection to create.')
param hybridConnectionName string

@description('Required. The name of the Application Insights instance to create.')
param applicationInsightsName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: ''
  #disable-next-line BCP035 // works with empty properties block
  properties: {}
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.azurewebsites.net'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2024-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource serverFarm 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

resource relayNamespace 'Microsoft.Relay/namespaces@2024-01-01' = {
  name: relayNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}

  resource hybridConnection 'hybridConnections@2024-01-01' = {
    name: hybridConnectionName
    properties: {
      requiresClientAuthorization: true
      userMetadata: '[{"key":"endpoint","value":"db-server.constoso.com:1433"}]'
    }

    resource authorizationRule 'authorizationRules@2024-01-01' = {
      name: 'defaultSender'
      properties: {
        rights: [
          'Send'
        ]
      }
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowSharedKeyAccess: false
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The resource ID of the created Hybrid Connection.')
output hybridConnectionResourceId string = relayNamespace::hybridConnection.id

@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Application Insights instance.')
output applicationInsightsResourceId string = applicationInsights.id
