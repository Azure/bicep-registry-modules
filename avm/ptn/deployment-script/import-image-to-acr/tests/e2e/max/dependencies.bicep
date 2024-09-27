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

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

var ipRange = '10.0.0.0'

module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: managedIdentityName
  params: {
    name: managedIdentityName
    location: location
  }
}

// networking related resources
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [cidrSubnet(ipRange, 16, 0)]
    }
  }
  resource subnet_privateendpoints 'subnets@2023-11-01' = {
    name: 'privateendpoints-subnet'
    properties: {
      addressPrefix: cidrSubnet(ipRange, 24, 0)
    }
  }
  resource subnet_deploymentscript 'subnets@2023-11-01' = {
    name: 'deploymentscript-subnet'
    dependsOn: [subnet_privateendpoints]
    properties: {
      addressPrefix: cidrSubnet(ipRange, 24, 1)
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
        roleDefinitionIdOrName: '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Privileged Contributor
      }
    ]
  }
}

// KeyVault stores the password to login to the source container registry
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: null
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }
  dependsOn: [identity]

  resource containerRegistrySecret 'secrets@2023-07-01' = {
    name: 'ContainerRegistryPassword'
    properties: {
      // put the password of the source container registry here
      value: '<password>'
    }
  }

  resource rbac 'accessPolicies@2023-07-01' = {
    name: 'add'
    properties: {
      accessPolicies: [
        {
          tenantId: tenant().tenantId
          objectId: identity.outputs.principalId
          permissions: {
            keys: []
            secrets: ['get', 'list', 'set']
            certificates: []
            storage: []
          }
        }
      ]
    }
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
    // roleAssisgnments are done in the main module
    networkRuleBypassOptions: 'AzureServices'
    publicNetworkAccess: 'Disabled'
    networkRuleSetDefaultAction: 'Deny'
    privateEndpoints: [
      {
        name: '${uniqueString(resourceGroup().name, location)}-pe-ContainerRegistry'
        subnetResourceId: vnet::subnet_privateendpoints.id
        customNetworkInterfaceName: '${uniqueString(resourceGroup().name, location)}-pe-ContainerRegistry-nic'
        location: location
        privateDnsZoneGroupName: 'default'
        privateDnsZoneResourceIds: [
          dnsZoneContainerRegistry.outputs.resourceId
        ]
        isManualConnection: false
        service: 'registry'
      }
    ]
  }
}

@description('The resource id of the created managed identity.')
output managedIdentityResourceId string = identity.outputs.resourceId

@description('The name of the created Azure Container Registry.')
output acrName string = acr.outputs.name

@description('The resource id of the created Storage Account.')
output storageAccountResourceId string = storage.outputs.resourceId

@description('The resource ID of the created subnet designated for the Deployment Script.')
output deploymentScriptSubnetResourceId string = vnet::subnet_deploymentscript.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the created Key Vault secret.')
output keyVaultSecretName string = keyVault::containerRegistrySecret.name
