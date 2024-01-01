@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Shared Image Gallery to create.')
param galleryName string

@description('Required. The name of the Image Definition to create in the Shared Image Gallery.')
param sigImageDefinitionName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. The name of the Virtual Network to create.')
param virtualNetworkName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

var addressPrefix = '10.0.0.0/16'

resource gallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: galleryName
  location: location
  properties: {}
}

resource galleryImageDefinition 'Microsoft.Compute/galleries/images@2022-03-03' = {
  name: sigImageDefinitionName
  location: location
  parent: gallery
  properties: {
    architecture: 'x64'
    hyperVGeneration: 'V2'
    identifier: {
      offer: 'Windows-11'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'Win11-AVD-g2'
    }
    osState: 'Generalized'
    osType: 'Windows'
    recommended: {
      memory: {
        max: 16
        min: 4
      }
      vCPUs: {
        max: 8
        min: 2
      }
    }
  }
}

resource msi_contibutorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'Contributor', '[[namePrefix]]')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
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
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name

@description('The resource ID of the created Image Definition.')
output sigImageDefinitionId string = galleryImageDefinition.id

@description('The subnet resource id of the defaultSubnet of the created Virtual Network.')
output subnetId string = '${virtualNetwork.id}/subnets/defaultSubnet'
