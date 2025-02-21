@description('Optional. The location for the resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The name of the resource group for the resources.')
param resourceGroupName string = resourceGroup().name

@description('Required. The name will be used as suffix for newly created resources.')
param name string

// network related parameters
// -------------------------
@description('Optional. Deploy resources in a virtual network and use it for private endpoints.')
param deployInVnet bool = true

@description('Conditional. A new private DNS Zone will be created. Optional, if `deployInVnet` is `true`.')
param deployDnsZoneKeyVault bool = true

@description('Conditional. A new private DNS Zone will be created. Optional, if `deployInVnet` is `true`.')
param deployDnsZoneContainerRegistry bool = true

@description('Conditional. The address prefix for the virtual network needs to be at least a /16. Three subnets will be created (the first /24 will be used for private endpoints, the second /24 for service endpoints and the second /23 is used for the workload). Required, if `deployInVnet` is `true`.')
param addressPrefix string

@description('Conditional. CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if `zoneRedundant` for consumption plan is desired or `deployInVnet` is `true`.')
param dockerBridgeCidr string = '172.16.0.1/28'

@description('Conditional. IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if `zoneRedundant` for consumption plan is desired or `deployInVnet` is `true`.')
param platformReservedCidr string = '172.17.17.0/24'

@description('Conditional. An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if `zoneRedundant` for consumption plan is desired or `deployInVnet` is `true`.')
param platformReservedDnsIP string = '172.17.17.17'

@description('Optional. Network security group, that will be added to the workload subnet.')
param customNetworkSecurityGroups securityRuleType[]?

@description('Optional. Pass the name to use an existing managed identity for importing the container image and run the job. If not provided, a new managed identity will be created.')
param managedIdentityResourceId string?

@description('Optional. The name of the managed identity to create. If not provided, a name will be generated automatically as `jobsUserIdentity-$\\{name\\}`.')
param managedIdentityName string?

// infrastructure parameters
// -------------------------
@sys.description('Optional. The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.')
param logAnalyticsWorkspaceResourceId string?

@sys.description('Optional. The connection string for the Application Insights instance that will be used by the Job.')
param appInsightsConnectionString string?

@description('Optional. The name of the Key Vault that will be created to store the Application Insights connection string and be used for your secrets.')
param keyVaultName string

@description('Optional. Secrets that will be added to Key Vault for later reference in the Container App Job.')
param keyVaultSecrets secretType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Role assignments that will be added to the Key Vault. The managed Identity will be assigned the `Key Vault Secrets User` role by default.')
param keyVaultRoleAssignments roleAssignmentType[]?

@description('Optional. The permissions that will be assigned to the Container Registry. The managed Identity will be assigned the permissions to get and list images.')
param registryRoleAssignments roleAssignmentType[]?

// workload parameters
// -------------------------

@description('Required. Workload profiles for the managed environment.')
param workloadProfiles array?

@description('Optional. Tags of the resource.')
param tags object = {}

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

// ============= //
//   Variables   //
// ============= //

// Rbac roles that will be granted to the user-assigned identity
var vaultBuiltInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Key Vault Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '00482a5a-887f-4fb3-b363-3b7fe8e74483'
  )
  'Key Vault Certificates Officer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a4417e6f-fecd-4de8-b567-7b0420556985'
  )
  'Key Vault Certificate User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'db79e9a7-68ee-4b58-9aeb-b90e7c24fcba'
  )
  'Key Vault Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f25e0fa2-a7c8-4377-a976-54943a77a395'
  )
  'Key Vault Crypto Officer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
  )
  'Key Vault Crypto Service Encryption User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e147488a-f6f5-4113-8e2d-b22465e65bf6'
  )
  'Key Vault Crypto User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '12338af0-0e69-4776-bea7-57ae8d297424'
  )
  'Key Vault Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '21090545-7ca7-4776-b22c-e363652d74d2'
  )
  'Key Vault Secrets Officer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b86a8fe4-44ce-4948-aee5-eccb2c155cd7'
  )
  'Key Vault Secrets User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4633458b-17de-408a-b874-0445c86b69e6'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var registryRbacRoles = ['7f951dda-4ed3-4680-a7ca-43fe172d538d', '8311e382-0749-4cb8-b61a-304f252e45ec'] // ArcPull, AcrPush

var storageAccountRbacRoles = ['69566ab7-960f-475b-8e7c-b3118f30c6bd'] // Storage File Data Privileged Contributor

var formattedVaultRoleAssignments = [
  for (roleAssignment, index) in (keyVaultRoleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: vaultBuiltInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

var formattedRegistryRoleAssignments = [
  for (roleAssignment, index) in (registryRoleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: vaultBuiltInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// network related variables
var privateEndpointSubnetAddressPrefix = cidrSubnet(addressPrefix, 24, 0) // the first /24 subnet in the address space

var deploymentscriptSubnetAddressPrefix = cidrSubnet(addressPrefix, 24, 1) // the second /24 subnet in the address space

var workloadSubnetAddressPrefix = cidrSubnet(addressPrefix, 23, 1) // the second /23 subnet in the address space, as the first /24 subnet is used for private endpoints

var zoneRedundant = deployInVnet || (!empty(addressPrefix) && empty(workloadProfiles)) // zoneRedundant is only needed if the environment is deployed in a vnet or for consumption plan if an addressPrefix has been provided

// filter and prepare secrets that need to be added to Key Vault in order to reference them later
var secrets = [
  for secret in keyVaultSecrets ?? []: (secret.keyVaultUrl != null)
    ? {
        name: last(split(secret.keyVaultUrl ?? 'dummy-for-deployment-validation', '/'))
        identity: secret.identity
        value: 'dummy' // dummy needed to pass the validation
      }
    : null
]

// https://learn.microsoft.com/en-us/azure/virtual-network/service-tags-overview#discover-service-tags-by-using-downloadable-json-files
var regionSpecificServiceTags = {
  francecentral: 'centralfrance'
  francesouth: 'southfrance'
  germanywestcentral: 'germanywc'
  germanynorth: 'germanyn'
  norwayeast: 'norwaye'
  norwaywest: 'norwayw'
  switzerlandnorth: 'switzerlandn'
  switzerlandwest: 'switzerlandw'
  eastusstg: 'usstagee'
  southcentralusstg: 'usstagec'
  brazilsoutheast: 'brazilse'
}

var locationLowered = toLower(location)

var regionServiceTag = regionSpecificServiceTags[?locationLowered] ?? locationLowered

// Networking resources
// -----------------
module nsg 'br/public:avm/res/network/network-security-group:0.5.0' = if (zoneRedundant) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-nsg'
  params: {
    name: 'nsg-${name}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    lock: lock
  }
}

module nsg_workload_plan 'br/public:avm/res/network/network-security-group:0.5.0' = if (zoneRedundant && !empty(workloadProfiles)) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-nsg-workload'
  params: {
    name: 'nsg-workload-${name}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    lock: lock
    securityRules: union(
      [
        // https://learn.microsoft.com/en-us/azure/container-apps/networking
        // no inbound rules required, as the job does not expose any ports
        {
          name: 'Allow-MCR-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 200
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'MicrosoftContainerRegistry'
          }
        }
        {
          name: 'Allow-FrontDoor-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 201
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureFrontDoor.FirstParty'
          }
        }
        {
          name: 'Allow-Entra-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 202
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureActiveDirectory'
          }
        }
        {
          name: 'Allow-AzureMonitor-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 203
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureMonitor'
          }
        }
        {
          name: 'Allow-Storage-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 204
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'Storage.${location}'
          }
        }
        {
          name: 'Allow-ACR-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 205
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureContainerRegistry'
          }
        }
        {
          name: 'Allow-Subnet'
          properties: {
            access: 'Allow'
            direction: 'Inbound'
            priority: 100
            protocol: '*'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '*'
            destinationAddressPrefix: workloadSubnetAddressPrefix
          }
        }
        {
          name: 'Allow-DNS'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 101
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '53'
            destinationAddressPrefix: '168.63.129.16'
          }
        }
      ],
      customNetworkSecurityGroups ?? []
    )
  }
}

module nsg_consumption_plan 'br/public:avm/res/network/network-security-group:0.5.0' = if (zoneRedundant && empty(workloadProfiles)) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-nsg-workload'
  params: {
    name: 'nsg-consumption-${name}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    lock: lock
    securityRules: union(
      [
        // https://learn.microsoft.com/en-us/azure/container-apps/networking
        // no inbound rules required, as the job does not expose any ports
        {
          name: 'Allow-MCR-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 200
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'MicrosoftContainerRegistry'
          }
        }
        {
          name: 'Allow-Frontdoor-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 201
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureFrontDoor.FirstParty'
          }
        }
        {
          name: 'Allow-Subnet-AKS-Udp-1194'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 205
            protocol: 'Udp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '1194'
            destinationAddressPrefix: 'AzureCloud.${regionServiceTag}'
          }
        }
        {
          name: 'Allow-Subnet-AKS-Tcp-9000'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 206
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '9000'
            destinationAddressPrefix: 'AzureCloud.${regionServiceTag}'
          }
        }
        {
          name: 'Allow-Azure-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 207
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureCloud'
          }
        }
        {
          name: 'Allow-Udp-Ntp'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 208
            protocol: 'Udp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '123'
            destinationAddressPrefix: '*'
          }
        }
        {
          name: 'Allow-Subnet-All'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 209
            protocol: '*'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '*'
            destinationAddressPrefix: workloadSubnetAddressPrefix
          }
        }
        {
          name: 'Allow-DNS'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 210
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '53'
            destinationAddressPrefix: '168.63.129.16'
          }
        }
        {
          // You don't need to add an NSG rule for ACR when configured with private endpoints
          name: 'Allow-ACR-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 211
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureContainerRegistry'
          }
        }
        {
          name: 'Allow-Entra-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 212
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureActiveDirectory'
          }
        }
        {
          name: 'Allow-Storage-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 213
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'Storage.${location}'
          }
        }
        {
          name: 'Allow-AzureMonitor-Tcp-Https'
          properties: {
            access: 'Allow'
            direction: 'Outbound'
            priority: 214
            protocol: 'Tcp'
            sourcePortRange: '*'
            sourceAddressPrefix: workloadSubnetAddressPrefix
            destinationPortRange: '443'
            destinationAddressPrefix: 'AzureMonitor'
          }
        }
      ],
      customNetworkSecurityGroups ?? []
    )
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.5.1' = if (zoneRedundant) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-vnet'
  params: {
    name: 'vnet-${name}'
    enableTelemetry: enableTelemetry
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
        addressPrefix: deploymentscriptSubnetAddressPrefix
        networkSecurityGroupResourceId: nsg.outputs.resourceId
        serviceEndpoints: ['Microsoft.Storage']
        delegation: 'Microsoft.ContainerInstance/containerGroups'
      }
      {
        name: 'workload-subnet'
        addressPrefix: workloadSubnetAddressPrefix
        networkSecurityGroupResourceId: !empty(workloadProfiles)
          ? nsg_workload_plan.outputs.resourceId
          : nsg_consumption_plan.outputs.resourceId
        delegation: deployInVnet ? 'Microsoft.App/environments' : null // don't delegate if used for zoneRedundant consumption plan
      }
    ]
    location: location
    tags: tags
    lock: lock
  }
}

module dnsZoneKeyVault_new 'br/public:avm/res/network/private-dns-zone:0.7.0' = if (deployInVnet && deployDnsZoneKeyVault) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-dnsZoneKeyVault'
  params: {
    name: 'privatelink.vaultcore.azure.net'
    enableTelemetry: enableTelemetry
    tags: tags
    lock: lock
    virtualNetworkLinks: [
      {
        name: '${vnet.outputs.name}-KeyVault-link-${name}'
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}

resource dnsZoneKeyVault_existing 'Microsoft.Network/privateDnsZones@2020-06-01' existing = if (deployInVnet && !deployDnsZoneKeyVault) {
  name: 'privatelink.vaultcore.azure.net'
}

resource dnsZoneKeyVault_vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (deployInVnet && !deployDnsZoneKeyVault) {
  name: 'KeyVault-link-${name}'
  parent: dnsZoneKeyVault_existing
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.outputs.resourceId
    }
  }
}

module dnsZoneContainerRegistry_new 'br/public:avm/res/network/private-dns-zone:0.7.0' = if (deployInVnet && deployDnsZoneContainerRegistry) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-dnsZoneContainerRegistry'
  params: {
    name: 'privatelink.azurecr.io'
    enableTelemetry: enableTelemetry
    tags: tags
    lock: lock
    virtualNetworkLinks: [
      {
        name: '${vnet.outputs.name}-ContainerRegistry-link-${name}'
        virtualNetworkResourceId: vnet.outputs.resourceId
        registrationEnabled: false
      }
    ]
  }
}

resource dnsZoneContainerRegistry_existing 'Microsoft.Network/privateDnsZones@2020-06-01' existing = if (deployInVnet && !deployDnsZoneContainerRegistry) {
  name: 'privatelink.azurecr.io'
}

resource dnsZoneContainerRegistry_vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (deployInVnet && !deployDnsZoneContainerRegistry) {
  name: 'ContainerRegistry-link-${name}'
  parent: dnsZoneContainerRegistry_existing
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.outputs.resourceId
    }
  }
}

module privateEndpoint_KeyVault 'br/public:avm/res/network/private-endpoint:0.9.0' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-privateEndpoint_KeyVault'
  params: {
    name: 'pe-KeyVault-${name}'
    enableTelemetry: enableTelemetry
    subnetResourceId: vnet.outputs.subnetResourceIds[0] // first subnet is the private endpoint subnet
    customNetworkInterfaceName: 'pe-KeyVault-nic-${name}'
    location: location
    tags: tags
    lock: lock
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          name: 'default'
          privateDnsZoneResourceId: deployDnsZoneKeyVault
            ? dnsZoneKeyVault_new.outputs.resourceId
            : dnsZoneKeyVault_existing.id
        }
      ]
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-KeyVault-connection-${name}'
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

module privateEndpoint_ContainerRegistry 'br/public:avm/res/network/private-endpoint:0.9.0' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-privateEndpoint_ContainerRegistry'
  params: {
    name: 'pe-ContainerRegistry-${name}'
    enableTelemetry: enableTelemetry
    subnetResourceId: vnet.outputs.subnetResourceIds[0] // first subnet is the private endpoint subnet
    customNetworkInterfaceName: 'pe-ContainerRegistry-nic-${name}'
    location: location
    tags: tags
    lock: lock
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          name: 'default'
          privateDnsZoneResourceId: deployDnsZoneContainerRegistry
            ? dnsZoneContainerRegistry_new.outputs.resourceId
            : dnsZoneContainerRegistry_existing.id
        }
      ]
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-ContainerRegistry-connection-${name}'
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
resource userIdentity_new 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = if (managedIdentityResourceId == null) {
  name: managedIdentityName ?? 'jobsUserIdentity-${name}'
  location: location
  tags: union(tags, { 'used-by': 'container-job-toolkit' })
}

resource userIdentity_existing 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (managedIdentityResourceId != null) {
  name: last(split(managedIdentityResourceId! ?? 'dummyMsi', '/'))
  // get the resource group from the managed identity, as it could be in another resource group
  scope: resourceGroup(
    split(managedIdentityResourceId! ?? '//', '/')[2],
    split(managedIdentityResourceId! ?? '////', '/')[4]
  )
}

// supporting resources
// -----------------
module vault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: '${uniqueString(deployment().name, location, resourceGroupName, subscription().subscriptionId)}-vault'
  params: {
    name: keyVaultName
    enableTelemetry: enableTelemetry
    enablePurgeProtection: false
    enableRbacAuthorization: true
    location: location
    sku: 'standard'
    tags: union(tags, { 'used-by': 'container-job-toolkit' })
    lock: lock
    secrets: union(
      !empty(appInsightsConnectionString ?? '')
        ? [
            {
              name: 'applicationinsights-connection-string'
              value: appInsightsConnectionString!
            }
          ]
        : [],
      secrets
    )
    roleAssignments: union(
      // role assignement for the managed identity
      [
        {
          principalId: managedIdentityResourceId != null
            ? userIdentity_existing.properties.principalId
            : userIdentity_new.properties.principalId
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User
        }
      ],
      // passed in role assignments
      formattedVaultRoleAssignments
    )
    publicNetworkAccess: deployInVnet ? 'Disabled' : null
  }
}

module registry 'br/public:avm/res/container-registry/registry:0.6.0' = {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-registry'
  params: {
    #disable-next-line BCP334
    name: uniqueString('cr', name, location, resourceGroupName, subscription().subscriptionId)
    location: location
    enableTelemetry: enableTelemetry
    acrSku: deployInVnet ? 'Premium' : 'Standard' // Private Endpoint needs Premium tier
    trustPolicyStatus: deployInVnet ? 'enabled' : 'disabled' // Content Trust requires Premium tier
    retentionPolicyDays: 30
    retentionPolicyStatus: 'enabled'
    softDeletePolicyDays: 7
    softDeletePolicyStatus: 'disabled'
    tags: union(tags, { 'used-by': 'container-job-toolkit' })
    lock: lock
    acrAdminUserEnabled: false
    roleAssignments: formattedRegistryRoleAssignments
    networkRuleBypassOptions: deployInVnet ? 'AzureServices' : null
    publicNetworkAccess: deployInVnet ? 'Disabled' : null
  }
}

module registry_rbac 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.1' = [
  for registryRole in registryRbacRoles: {
    name: '${uniqueString(deployment().name, location, resourceGroupName)}-registry-rbac-${registryRole}'
    params: {
      enableTelemetry: enableTelemetry
      principalId: managedIdentityResourceId != null
        ? userIdentity_existing.properties.principalId
        : userIdentity_new.properties.principalId
      principalType: 'ServicePrincipal'
      roleDefinitionId: registryRole
      resourceId: registry.outputs.resourceId
    }
  }
]

module storage 'br/public:avm/res/storage/storage-account:0.15.0' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-storage'
  params: {
    name: uniqueString('sa', name, location, resourceGroupName, subscription().subscriptionId)
    location: location
    enableTelemetry: enableTelemetry
    tags: union(tags, { 'used-by': 'deployment-script' })
    lock: lock
    kind: 'StorageV2'
    minimumTlsVersion: 'TLS1_2'
    accessTier: 'Hot'
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
        principalId: managedIdentityResourceId != null
          ? userIdentity_existing.properties.principalId
          : userIdentity_new.properties.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: storageRole
      }
    ]
  }
}

module law 'br/public:avm/res/operational-insights/workspace:0.9.0' = if (empty(logAnalyticsWorkspaceResourceId)) {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-law'
  params: {
    name: 'la-${name}'
    location: location
    enableTelemetry: enableTelemetry
    tags: union(tags, { 'used-by': 'container-job-toolkit' })
    lock: lock
  }
}

// Managed Environment
// -------------------
module managedEnvironment 'br/public:avm/res/app/managed-environment:0.8.1' = {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-managedEnvironment'
  params: {
    name: 'container-apps-environment-${name}'
    enableTelemetry: enableTelemetry
    logAnalyticsWorkspaceResourceId: !empty(logAnalyticsWorkspaceResourceId)
      ? logAnalyticsWorkspaceResourceId!
      : law.outputs.resourceId
    location: location
    tags: union(tags, { 'used-by': 'container-job-toolkit' })
    lock: lock
    workloadProfiles: !empty(workloadProfiles) ? workloadProfiles : null
    zoneRedundant: !empty(workloadProfiles) || !empty(addressPrefix) ? true : false
    infrastructureResourceGroupName: '${resourceGroupName}-infrastructure'
    // vnet configuration
    internal: deployInVnet ? true : false
    infrastructureSubnetId: deployInVnet || !empty(addressPrefix) ? vnet.outputs.subnetResourceIds[2] : null // third subnet is the workload subnet
    dockerBridgeCidr: deployInVnet ? dockerBridgeCidr : null
    platformReservedCidr: deployInVnet ? platformReservedCidr : null
    platformReservedDnsIP: deployInVnet ? platformReservedDnsIP : null
  }
}

@description('The resouce ID of the Log Analytics Workspace (passed as parameter value or from the newly created Log Analytics Workspace).')
output logAnalyticsResourceId string = !empty(logAnalyticsWorkspaceResourceId)
  ? logAnalyticsWorkspaceResourceId!
  : law.outputs.resourceId

@description('The name of the Key Vault instance.')
output vaultName string = vault.outputs.name

@description('The Key Vault secret URI for the Application Insights connection string.')
output keyVaultAppInsightsConnectionStringUrl string = !empty(appInsightsConnectionString ?? '')
  ? '${vault.outputs.uri}/secrets/applicationinsights-connection-string'
  : ''

@description('The name of the Container Registry instance.')
output registryName string = registry.outputs.name

@description('The login server of the Container Registry instance.')
output registryLoginServer string = registry.outputs.loginServer

@description('The resource ID of the managed environment resource.')
output managedEnvironmentResourceId string = managedEnvironment.outputs.resourceId

@description('The resource ID of the (new or existing) managed identity.')
output userManagedIdentityResourceId string = managedIdentityResourceId == null
  ? userIdentity_new.id
  : userIdentity_existing.id

@description('The principal ID of the (new or existing) managed identity.')
output userManagedIdentityPrincipalId string = managedIdentityResourceId == null
  ? userIdentity_new.properties.principalId
  : userIdentity_existing.properties.principalId

@description('The resource ID of the storage account instance.')
output storageAccountResourceId string = deployInVnet ? storage.outputs.resourceId : ''

@description('The resource ID of the virtual network instance.')
output vnetResourceId string = deployInVnet ? vnet.outputs.resourceId : ''

@description('The address prefix of the private endpoint subnet.')
output privateEndpointSubnetAddressPrefix string = deployInVnet ? privateEndpointSubnetAddressPrefix : ''

@description('The address prefix of the subnet, the deployment script is using.')
output deploymentscriptSubnetAddressPrefix string = deployInVnet ? deploymentscriptSubnetAddressPrefix : ''

@description('The address prefix of the subnet, the container app is using.')
output workloadSubnetAddressPrefix string = deployInVnet ? workloadSubnetAddressPrefix : '' // also used for zoneRedundant configuration

@description('The resource ID of the subnet, the deployment script is using.')
output subnetResourceId_deploymentScript string = deployInVnet ? vnet.outputs.subnetResourceIds[1] : ''

@description('The CIDR of the Docker bridge.')
output dockerBridgeCidr string = dockerBridgeCidr

@description('The CIDR of the platform reserved range.')
output platformReservedCidr string = platformReservedCidr

@description('The IP address of the platform reserved DNS server.')
output platformReservedDnsIP string = platformReservedDnsIP

// ================ //
// Definitions      //
// ================ //

@export()
@description('Secrets that will be added to Key Vault for later reference in the Container App Job.')
type secretType = {
  @description('Optional. Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity.')
  identity: string?

  @description('Conditional. Azure Key Vault URL pointing to the secret referenced by the Container App Job. Required if `value` is null.')
  @metadata({
    example: '''https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret'''
  })
  keyVaultUrl: string?

  @description('Optional. The name of the secret.')
  name: string?

  @description('Conditional. The secret value, if not fetched from Key Vault. Required if `keyVaultUrl` is null.')
  @secure()
  value: string?
}

@export()
@description('Network security group, that will be added to the workload subnet.')
type securityRuleType = {
  @description('Required. The name of the security rule.')
  name: string

  @description('Required. The properties of the security rule.')
  properties: {
    @description('Required. Whether network traffic is allowed or denied.')
    access: ('Allow' | 'Deny')

    @description('Optional. The description of the security rule.')
    description: string?

    @description('Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.')
    destinationAddressPrefix: string?

    @description('Optional. The destination address prefixes. CIDR or destination IP ranges.')
    destinationAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as destination.')
    destinationApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    destinationPortRange: string?

    @description('Optional. The destination port ranges.')
    destinationPortRanges: string[]?

    @description('Required. The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.')
    direction: ('Inbound' | 'Outbound')

    @minValue(100)
    @maxValue(4096)
    @description('Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
    priority: int

    @description('Required. Network protocol this rule applies to.')
    protocol: ('Ah' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp' | '*')

    @description('Optional. The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.')
    sourceAddressPrefix: string?

    @description('Optional. The CIDR or source IP ranges.')
    sourceAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as source.')
    sourceApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    sourcePortRange: string?

    @description('Optional. The source port ranges.')
    sourcePortRanges: string[]?
  }
}
