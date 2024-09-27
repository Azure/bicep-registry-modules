@description('Optional. The location for the resources.')
param resourceLocation string = resourceGroup().location

@description('Optional. The name of the resource group for the resources.')
param resourceGroupName string = resourceGroup().name

@description('Required. The name will be used as suffix for newly created resources.')
param name string

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
param managedIdentityResourceId string?

@description('Optional. The name of the managed identity to create. If not provided, a name will be generated automatically as `jobsUserIdentity-$\\{name\\}`.')
param managedIdentityName string?

// infrastructure parameters
// -------------------------
@sys.description('Optional. The Log Analytics Resource ID for the Container Apps Environment to use for the job. If not provided, a new Log Analytics workspace will be created.')
param logAnalyticsWorkspaceResourceId string

@sys.description('Optional. The connection string for the Application Insights instance that will be used by the Job.')
param appInsightsConnectionString string?

@description('Optional. The name of the Key Vault that will be created to store the Application Insights connection string and be used for your secrets.')
param keyVaultName string

@description('Optional. Secrets that will be added to Key Vault for later reference in the Container App Job.')
param keyVaultSecrets secretType[]?

@description('Optional. Role assignments that will be added to the Key Vault. The managed Identity will be assigned the `Key Vault Secrets User` role by default.')
param keyVaultRoleAssignments roleAssignmentType

@description('Optional. The permissions that will be assigned to the Container Registry. The managed Identity will be assigned the permissions to get and list images.')
param registryRoleAssignments roleAssignmentType

// workload parameters
// -------------------------

@description('Required. Workload profiles for the managed environment.')
param workloadProfiles array?

@description('Optional. Tags of the resource.')
param tags object = {}

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
var storageAccountRbacRoles = [
  '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Privileged Contributor
]
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
var serviceEndpointSubnetAddressPrefix = cidrSubnet(addressPrefix, 24, 1) // the second /24 subnet in the address space
var workloadSubnetAddressPrefix = cidrSubnet(addressPrefix, 23, 1) // the second /23 subnet in the address space, as the first /24 subnet is used for private endpoints

// filter and prepare secrets that need to be added to Key Vault in order to reference them later
var secrets = [
  for secret in keyVaultSecrets ?? []: (secret.keyVaultUrl != null)
    ? {
        name: last(split(secret.keyVaultUrl, '/'))
        identity: secret.identity
        value: 'dummy' // dummy needed to pass the validation
      }
    : null
]

// Networking resources
// -----------------
module nsg 'br/public:avm/res/network/network-security-group:0.5.0' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-nsg'
  params: {
    name: 'nsg-${name}'
    location: resourceLocation
    tags: tags
    lock: lock
  }
}

module vnet 'br/public:avm/res/network/virtual-network:0.4.0' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-vnet'
  params: {
    name: 'vnet-${name}'
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
        serviceEndpoints: ['Microsoft.Storage']
        delegation: 'Microsoft.ContainerInstance/containerGroups'
      }
      {
        name: 'workload-subnet'
        addressPrefix: workloadSubnetAddressPrefix
        networkSecurityGroupResourceId: nsg.outputs.resourceId
        delegation: 'Microsoft.App/environments'
      }
    ]
    location: resourceLocation
    tags: tags
    lock: lock
  }
}

module dnsZoneKeyVault_new 'br/public:avm/res/network/private-dns-zone:0.6.0' = if (deployInVnet && deployDnsZoneKeyVault) {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-dnsZoneKeyVault'
  params: {
    name: 'privatelink.vaultcore.azure.net'
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

module dnsZoneContainerRegistry_new 'br/public:avm/res/network/private-dns-zone:0.6.0' = if (deployInVnet && deployDnsZoneContainerRegistry) {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-dnsZoneContainerRegistry'
  params: {
    name: 'privatelink.azurecr.io'
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

module privateEndpoint_KeyVault 'br/public:avm/res/network/private-endpoint:0.8.0' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-privateEndpoint_KeyVault'
  params: {
    name: 'pe-KeyVault-${name}'
    subnetResourceId: vnet.outputs.subnetResourceIds[0] // first subnet is the private endpoint subnet
    customNetworkInterfaceName: 'pe-KeyVault-nic-${name}'
    location: resourceLocation
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
module privateEndpoint_ContainerRegistry 'br/public:avm/res/network/private-endpoint:0.8.0' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-privateEndpoint_ContainerRegistry'
  params: {
    name: 'pe-ContainerRegistry-${name}'
    subnetResourceId: vnet.outputs.subnetResourceIds[0] // first subnet is the private endpoint subnet
    customNetworkInterfaceName: 'pe-ContainerRegistry-nic-${name}'
    location: resourceLocation
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
  location: resourceLocation
}
resource userIdentity_existing 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (managedIdentityResourceId != null) {
  name: last(split(managedIdentityResourceId!, '/'))
  scope: resourceGroup(split(managedIdentityResourceId!, '/')[2], split(managedIdentityResourceId!, '/')[4]) // get the resource group from the managed identity, as it could be in another resource group
}

// supporting resources
// -----------------
module vault 'br/public:avm/res/key-vault/vault:0.9.0' = {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-vault'
  params: {
    name: keyVaultName
    enablePurgeProtection: false
    enableRbacAuthorization: true
    location: resourceLocation
    sku: 'standard'
    tags: union(tags, { 'used-by': 'container-job' })
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

module registry 'br/public:avm/res/container-registry/registry:0.5.1' = {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-registry'
  params: {
    #disable-next-line BCP334
    name: uniqueString('cr', name, resourceLocation, resourceGroupName)
    location: resourceLocation
    acrSku: deployInVnet ? 'Premium' : 'Standard' // Private Endpoint needs Premium tier
    retentionPolicyDays: 30
    retentionPolicyStatus: 'enabled'
    softDeletePolicyDays: 7
    softDeletePolicyStatus: 'disabled'
    tags: union(tags, { 'used-by': 'container-job' })
    lock: lock
    acrAdminUserEnabled: false
    roleAssignments: formattedRegistryRoleAssignments
    networkRuleBypassOptions: deployInVnet ? 'AzureServices' : null
    publicNetworkAccess: deployInVnet ? 'Disabled' : null
  }
}
module registry_rbac 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.1' = [
  for registryRole in registryRbacRoles: {
    name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-registry-rbac-${registryRole}'
    params: {
      principalId: managedIdentityResourceId != null
        ? userIdentity_existing.properties.principalId
        : userIdentity_new.properties.principalId
      principalType: 'ServicePrincipal'
      roleDefinitionId: registryRole
      resourceId: registry.outputs.resourceId
    }
  }
]

module storage 'br/public:avm/res/storage/storage-account:0.13.2' = if (deployInVnet) {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-storage'
  params: {
    name: uniqueString('sa', name, resourceLocation, resourceGroupName)
    location: resourceLocation
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

// Managed Environment
// -------------------
module managedEnvironment 'br/public:avm/res/app/managed-environment:0.8.0' = {
  name: '${uniqueString(deployment().name, resourceLocation, resourceGroupName)}-managedEnvironment'
  params: {
    name: 'container-apps-environment-${name}'
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    location: resourceLocation
    tags: tags
    lock: lock
    workloadProfiles: !empty(workloadProfiles) ? workloadProfiles : null
    zoneRedundant: empty(workloadProfiles) ? false : true // zone redundant is not available for consumption plans
    infrastructureResourceGroupName: '${resourceGroupName}-infrastructure'
    // vnet configuration
    internal: deployInVnet ? true : false
    infrastructureSubnetId: deployInVnet ? vnet.outputs.subnetResourceIds[2] : null // third subnet is the workload subnet
    dockerBridgeCidr: deployInVnet ? '172.16.0.1/28' : null
    platformReservedCidr: deployInVnet ? '172.17.17.0/24' : null
    platformReservedDnsIP: deployInVnet ? '172.17.17.17' : null
  }
}

output vaultName string = vault.outputs.name
output keyVaultAppInsightsConnectionStringUrl string = !empty(appInsightsConnectionString ?? '')
  ? '${vault.outputs.uri}/secrets/applicationinsights-connection-string'
  : ''
output registryName string = registry.outputs.name
output registryLoginServer string = registry.outputs.loginServer
output managedEnvironmentId string = managedEnvironment.outputs.resourceId
output userManagedIdentityResourceId string = managedIdentityResourceId == null
  ? userIdentity_new.id
  : userIdentity_existing.id
output vnetResourceId string = deployInVnet ? vnet.outputs.resourceId : ''
output subnetResourceId_deploymentScript string = deployInVnet ? vnet.outputs.subnetResourceIds[1] : ''
output storageAccountResourceId string = deployInVnet ? storage.outputs.resourceId : ''

// ================ //
// Definitions      //
// ================ //

@export()
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

  @description('Conditional. The secret value, if not fetched from Key Vault. Required if `keyVaultUrl` is not null.')
  @secure()
  value: string?
}

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}

@export()
type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
