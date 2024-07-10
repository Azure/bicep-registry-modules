@description('Optional. The location for the resources.')
param resourceLocation string = resourceGroup().location

@description('Optional. The name of the resource group for the resources.')
param resourceGroupName string = resourceGroup().name

@description('Optional. The suffix will be used for newly created resources.')
param nameSuffix string

// network related parameters
// -------------------------
@description('Optional. Deploy resources in a virtual network and use it for private endpoints.')
param deployInVnet bool = true

@description('Conditional. The address prefix for the virtual network needs to be at least a /16. Required, if `deployInVnet` is `true`.')
param addressPrefix string = '10.50.0.0/16' // set a default value for the cidrSubnet calculation, even if not used

@description('Conditional. A new private DNS Zone will be created. Optional, if `deployInVnet` is `true`.')
param deployDnsZoneKeyVault bool = true

@description('Conditional. A new private DNS Zone will be created. Optional, if `deployInVnet` is `true`.')
param deployDnsZoneContainerRegistry bool = true

@description('Optional. Pass the name to use an existing managed identity for importing the container image and run the job. If not provided, a new managed identity will be created.')
param managedIdentityName string?

// infrastructure parameters
// -------------------------
@description('Optional. Tags of the resource.')
param tags object = {}

@sys.description('Optional. The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.')
param logAnalyticsWorkspaceResourceId string

@sys.description('Optional. The connection string for the Application Insights instance that will be used by the Job.')
param appInsightsConnectionString string?

// Rbac roles that will be granted to the user-assigned identity
var vaultRbacRoles = ['4633458b-17de-408a-b874-0445c86b69e6'] // Key Vault Secrets User
var registryRbacRoles = ['7f951dda-4ed3-4680-a7ca-43fe172d538d', '8311e382-0749-4cb8-b61a-304f252e45ec'] // ArcPull, AcrPush
var storageAccountRbacRoles = [
  '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Privileged Contributor
]
var workloadprofileName = 'CAW01'
// network related variables
var privateEndpointSubnetAddressPrefix = cidrSubnet(addressPrefix, 24, 0) // the first /24 subnet in the address space
var serviceEndpointSubnetAddressPrefix = cidrSubnet(addressPrefix, 24, 1) // the second /24 subnet in the address space
var workloadSubnetAddressPrefix = cidrSubnet(addressPrefix, 23, 1) // the second /23 subnet in the address space, as the first /24 subnet is used for private endpoints

// Networking resources
// -----------------
module nsg 'br/public:avm/res/network/network-security-group:0.3.1' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation)}-nsg'
  params: {
    name: 'nsg-${nameSuffix}'
    location: resourceLocation
    tags: tags
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.1.8' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation)}-vnet'
  params: {
    name: 'vnet-${nameSuffix}'
    addressPrefixes: [
      addressPrefix
    ]
    subnets: [
      {
        name: 'private-endpoints-subnet'
        addressPrefix: privateEndpointSubnetAddressPrefix
        networkSecurityGroupResourceId: nsg.outputs.resourceId
      }
      {
        name: 'deploymentscript-subnet'
        addressPrefix: serviceEndpointSubnetAddressPrefix
        networkSecurityGroupResourceId: nsg.outputs.resourceId
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
      {
        name: 'workload-subnet'
        addressPrefix: workloadSubnetAddressPrefix
        networkSecurityGroupResourceId: nsg.outputs.resourceId
        delegations: [
          {
            name: 'Microsoft.App.environements'
            properties: {
              serviceName: 'Microsoft.App/environments'
            }
          }
        ]
      }
    ]
    location: resourceLocation
    tags: tags
  }
}

module dnsZoneKeyVault_new 'br/public:avm/res/network/private-dns-zone:0.3.1' = if (deployInVnet && deployDnsZoneKeyVault) {
  name: '${uniqueString(deployment().name, resourceLocation)}-dnsZoneKeyVault'
  params: {
    name: 'privatelink.vaultcore.azure.net'
    tags: tags
    virtualNetworkLinks: [
      {
        name: '${vnet.outputs.name}-KeyVault-link-${nameSuffix}'
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}
resource dnsZoneKeyVault_existing 'Microsoft.Network/privateDnsZones@2020-06-01' = if (deployInVnet && !deployDnsZoneKeyVault) {
  name: 'privatelink.vaultcore.azure.net'
  location: resourceLocation
}
resource dnsZoneKeyVault_vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (deployInVnet && !deployDnsZoneKeyVault) {
  name: 'KeyVault-link-${nameSuffix}'
  parent: dnsZoneKeyVault_existing
  location: resourceLocation
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.outputs.resourceId
    }
  }
}

module dnsZoneContainerRegistry_new 'br/public:avm/res/network/private-dns-zone:0.3.1' = if (deployInVnet && deployDnsZoneContainerRegistry) {
  name: '${uniqueString(deployment().name, resourceLocation)}-dnsZoneContainerRegistry'
  params: {
    name: 'privatelink.azurecr.io'
    tags: tags
    virtualNetworkLinks: [
      {
        name: '${vnet.outputs.name}-ContainerRegistry-link-${nameSuffix}'
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}
resource dnsZoneContainerRegistry_existing 'Microsoft.Network/privateDnsZones@2020-06-01' = if (deployInVnet && !deployDnsZoneContainerRegistry) {
  name: 'privatelink.azurecr.io'
  location: resourceLocation
}
resource dnsZoneContainerRegistry_vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (deployInVnet && !deployDnsZoneContainerRegistry) {
  name: 'ContainerRegistry-link-${nameSuffix}'
  parent: dnsZoneContainerRegistry_existing
  location: resourceLocation
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.outputs.resourceId
    }
  }
}

module privateEndpoint_KeyVault 'br/public:avm/res/network/private-endpoint:0.4.2' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation)}-privateEndpoint_KeyVault'
  params: {
    name: 'pe-KeyVault-${nameSuffix}'
    subnetResourceId: vnet.outputs.subnetResourceIds[0] // first subnet is the private endpoint subnet
    customNetworkInterfaceName: 'pe-KeyVault-nic-${nameSuffix}'
    location: resourceLocation
    tags: tags
    privateDnsZoneGroupName: 'default'
    privateDnsZoneResourceIds: [
      deployDnsZoneKeyVault ? dnsZoneKeyVault_new.outputs.resourceId : dnsZoneKeyVault_existing.id
    ]
    privateLinkServiceConnections: [
      {
        name: 'pe-KeyVault-connection-${nameSuffix}'
        properties: {
          privateLinkServiceId: vault.outputs.resourceId
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}
module privateEndpoint_ContainerRegistry 'br/public:avm/res/network/private-endpoint:0.4.2' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation)}-privateEndpoint_ContainerRegistry'
  params: {
    name: 'pe-ContainerRegistry-${nameSuffix}'
    subnetResourceId: vnet.outputs.subnetResourceIds[0] // first subnet is the private endpoint subnet
    customNetworkInterfaceName: 'pe-ContainerRegistry-nic-${nameSuffix}'
    location: resourceLocation
    privateDnsZoneGroupName: 'default'
    privateDnsZoneResourceIds: [
      deployDnsZoneContainerRegistry
        ? dnsZoneContainerRegistry_new.outputs.resourceId
        : dnsZoneContainerRegistry_existing.id
    ]
    privateLinkServiceConnections: [
      {
        name: 'pe-ContainerRegistry-connection-${nameSuffix}'
        properties: {
          privateLinkServiceId: registry.outputs.resourceId
          groupIds: [
            'registry'
          ]
        }
      }
    ]
  }
}

// Identity resources
// -----------------
module userIdentity_new 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.2' = if (managedIdentityName == null) {
  name: '${uniqueString(deployment().name, resourceLocation)}-userIdentity'
  params: {
    name: 'jobsUserIdentity-${nameSuffix}'
    location: resourceLocation
    tags: union(tags, { 'used-by': 'container-job, deployment-script, container-registry, storage-account' })
  }
}
resource userIdentity_existing 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (managedIdentityName != null) {
  name: managedIdentityName ?? 'dummy'
  location: resourceLocation
}

// supporting resources
// -----------------
module vault 'br/public:avm/res/key-vault/vault:0.6.2' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-vault'
  params: {
    name: 'kv${uniqueString(nameSuffix, resourceLocation)}' // with 'kv' in the uniqueString the name can start with a number, which is an invalid name for Key Vault
    enablePurgeProtection: false
    enableRbacAuthorization: true
    location: resourceLocation
    sku: 'standard'
    tags: union(tags, { 'used-by': 'container-job' })
    secrets: !empty(appInsightsConnectionString ?? '')
      ? [
          {
            name: 'applicationinsights-connection-string'
            value: appInsightsConnectionString!
          }
        ]
      : null
    roleAssignments: [
      for vaultRole in vaultRbacRoles: {
        principalId: managedIdentityName != null
          ? userIdentity_existing.properties.principalId
          : userIdentity_new.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: vaultRole
      }
    ]
    publicNetworkAccess: deployInVnet ? 'Disabled' : 'Enabled'
  }
}

module registry 'br/public:avm/res/container-registry/registry:0.3.1' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-registry'
  params: {
    #disable-next-line BCP334
    name: uniqueString('cr', nameSuffix, resourceLocation)
    location: resourceLocation
    acrSku: deployInVnet ? 'Premium' : 'Standard' // Private Endpoint needs Premium tier
    retentionPolicyDays: 30
    retentionPolicyStatus: 'enabled'
    softDeletePolicyDays: 7
    softDeletePolicyStatus: 'disabled'
    tags: union(tags, { 'used-by': 'container-apps-job' })
    acrAdminUserEnabled: false
    roleAssignments: [
      for registryRole in registryRbacRoles: {
        principalId: managedIdentityName != null
          ? userIdentity_existing.properties.principalId
          : userIdentity_new.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: registryRole
      }
    ]
    networkRuleBypassOptions: 'AzureServices'
    publicNetworkAccess: 'Disabled'
  }
}

module storage 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-storage'
  params: {
    name: uniqueString('sa', nameSuffix, resourceLocation)
    location: resourceLocation
    tags: union(tags, { 'used-by': 'deployment-script' })
    kind: 'StorageV2'
    minimumTlsVersion: 'TLS1_2'
    skuName: 'Standard_LRS'
    accessTier: 'Hot'
    // publicNetworkAccess: 'Enabled'
    allowSharedKeyAccess: true
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: vnet.outputs.subnetResourceIds[1] // second subnet is the service endpoint subnet
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    roleAssignments: [
      for storageRole in storageAccountRbacRoles: {
        principalId: managedIdentityName != null
          ? userIdentity_existing.properties.principalId
          : userIdentity_new.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: storageRole
      }
    ]
  }
}

// Managed Environment
// -------------------
module managedEnvironment 'br/public:avm/res/app/managed-environment:0.5.2' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-managedEnvironment'
  params: {
    name: 'container-apps-environment-${nameSuffix}'
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    location: resourceLocation
    tags: tags
    internal: true
    dockerBridgeCidr: '172.16.0.1/28'
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    infrastructureResourceGroupName: resourceGroupName
    infrastructureSubnetId: vnet.outputs.subnetResourceIds[2] // third subnet is the workload subnet
    workloadProfiles: [
      {
        workloadProfileType: 'D4'
        name: workloadprofileName
        minimumCount: 0
        maximumCount: 1
      }
    ]
  }
}

output vaultName string = vault.outputs.name
output vaultResourceId string = vault.outputs.resourceId
output registryName string = registry.outputs.name
output registryLoginServer string = registry.outputs.loginServer
output managedEnvironmentId string = managedEnvironment.outputs.resourceId
output workloadProfileName string = workloadprofileName
output userManagedIdentityResourceId string = managedIdentityName == null
  ? userIdentity_new.outputs.resourceId
  : userIdentity_existing.id
output userManagedIdentityName string = managedIdentityName == null ? userIdentity_new.name : userIdentity_existing.name
output vnetResourceId string = vnet.outputs.resourceId
// output subnetResourceId_privateLink string = vnet.outputs.subnetResourceIds[0]
output subnetResourceId_deploymentScript string = vnet.outputs.subnetResourceIds[1]
output storageAccountResourceId string = storage.outputs.resourceId
