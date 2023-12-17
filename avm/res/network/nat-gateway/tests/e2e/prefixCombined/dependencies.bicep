@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Public IP Prefix to create.')
param publicIPPrefixName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource publicIpPrefix 'Microsoft.Network/publicIPPrefixes@2023-05-01' = {
    name: publicIPPrefixName
    location: location
    sku: {
        name: 'Standard'
    }
    properties: {
        prefixLength: 30
    }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Public IP Prefix.')
output publicIpPrefixResourceId string = publicIpPrefix.id
