@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Azure Container Registry to create.')
param acrName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

var registryRbacRoles = ['7f951dda-4ed3-4680-a7ca-43fe172d538d', '8311e382-0749-4cb8-b61a-304f252e45ec'] // ArcPull, AcrPush
var storageAccountRbacRole = '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Privileged Contributor

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: managedIdentityName
  params: {
    name: managedIdentityName
    location: location
    enableTelemetry: false
  }
}

// networking related resources
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
  }
  resource subnet_privateendpoints 'subnets@2023-11-01' = {
    name: 'privateendpoints-subnet'
    properties: {
      addressPrefix: '10.0.0.0/24'
    }
  }
  resource subnet_deploymentscript 'subnets@2023-11-01' = {
    name: 'deploymentscript-subnet'
    dependsOn: [subnet_privateendpoints]
    properties: {
      addressPrefix: '10.0.1.0/24'
      serviceEndpoints: [
        {
          service: 'Microsoft.Storage'
        }
      ]
      delegations: [
        {
          name: 'Microsoft.ContainerInstance.containerGroups'
          properties: {
            serviceName: 'Microsoft.ContainerInstance/containerGroups'
          }
        }
      ]
    }
  }
}

module dnsZoneContainerRegistry 'br/public:avm/res/network/private-dns-zone:0.2.5' = {
  name: '${uniqueString(deployment().name, location)}-dnsZone-ACR'
  params: {
    name: 'privatelink.azurecr.io'
    virtualNetworkLinks: [
      {
        name: '${vnet.name}-ContainerRegistry-link'
        virtualNetworkResourceId: vnet.id
        registrationEnabled: false
      }
    ]
  }
}

module privateEndpointContainerRegistry 'br/public:avm/res/network/private-endpoint:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-pe-ACR'
  params: {
    name: '${uniqueString(resourceGroup().name, location)}-pe-ContainerRegistry'
    subnetResourceId: vnet::subnet_privateendpoints.id
    customNetworkInterfaceName: '${uniqueString(resourceGroup().name, location)}-pe-ContainerRegistry-nic'
    location: location
    privateDnsZoneGroupName: 'default'
    privateDnsZoneResourceIds: [
      dnsZoneContainerRegistry.outputs.resourceId
    ]
    privateLinkServiceConnections: [
      {
        name: 'pe-ContainerRegistry-connection'
        properties: {
          privateLinkServiceId: acr.outputs.resourceId
          groupIds: [
            'registry'
          ]
        }
      }
    ]
  }
}

module storage 'br/public:avm/res/storage/storage-account:0.9.0' = {
  name: '${uniqueString(resourceGroup().name, location)}-storage'
  params: {
    name: storageAccountName
    location: location
    kind: 'StorageV2'
    minimumTlsVersion: 'TLS1_2'
    skuName: 'Standard_LRS'
    accessTier: 'Hot'
    allowSharedKeyAccess: true
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: vnet::subnet_deploymentscript.id
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    roleAssignments: [
      {
        principalId: identity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: storageAccountRbacRole
      }
    ]
    enableTelemetry: false
  }
}

// the container registry to upload the image into
module acr 'br/public:avm/res/container-registry/registry:0.2.0' = {
  name: '${uniqueString(resourceGroup().name, location)}-acr'
  params: {
    name: acrName
    location: location
    acrSku: 'Premium'
    acrAdminUserEnabled: false
    roleAssignments: [
      for registryRole in registryRbacRoles: {
        principalId: identity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: registryRole
      }
    ]
    networkRuleBypassOptions: 'AzureServices'
    publicNetworkAccess: 'Disabled'
    networkRuleSetDefaultAction: 'Deny'
  }
}

output managedIdentityName string = identity.outputs.name
output acrName string = acr.outputs.name
output storageAccountName string = storage.outputs.name
output deploymentscriptSubnetResourceId string = vnet::subnet_deploymentscript.id
