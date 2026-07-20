targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

import {
  diagnosticSettingFullType
  lockType
  roleAssignmentType
} from 'br/public:avm/utl/types/avm-common-types:0.7.0'

@description('The location where the resources will be created.')
param location string = resourceGroup().location

@description('The name of the Key Vault.')
param keyVaultName string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('The resource ID of the Hub Virtual Network.')
param hubVNetResourceId string

@description('The resource ID of the VNet to which the private endpoint will be connected.')
param spokeVNetResourceId string

@description('The name of the subnet in the VNet to which the private endpoint will be connected.')
param spokePrivateEndpointSubnetName string

@description('Optional. The name of the private endpoint to be created for Key Vault. If left empty, it defaults to "<resourceName>-pep')
param keyVaultPrivateEndpointName string = 'keyvault-pep'

@description('Optional. Diagnostic Settings for the Key Vault.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Required. The principal ID of the App Service managed identity to grant Key Vault access.')
param appServiceManagedIdentityPrincipalId string

@description('Optional. Specify the type of resource lock.')
param lock lockType?

@description('Optional. Enable purge protection for the Key Vault. Defaults to true for production safety.')
param enablePurgeProtection bool = true

@description('Optional. Soft delete retention in days. Defaults to 90.')
param softDeleteRetentionInDays int = 90

@description('Optional. Additional role assignments to apply to the Key Vault beyond the default App Service identity assignment.')
param additionalRoleAssignments roleAssignmentType[]?

@description('Optional. Access policies for the Key Vault (non-RBAC mode).')
param accessPolicies array?

@description('Optional. Secrets to create in the Key Vault.')
param secrets array?

@description('Optional. Keys to create in the Key Vault.')
param keys array?

@description('Optional. Enable the Key Vault for template deployment.')
param enableVaultForTemplateDeployment bool = true

@description('Optional. Enable the Key Vault for disk encryption.')
param enableVaultForDiskEncryption bool = true

@description('Optional. The create mode for the Key Vault (default or recover).')
@allowed(['default', 'recover'])
param createMode string = 'default'

@description('Optional. The SKU of the Key Vault.')
@allowed(['standard', 'premium'])
param keyVaultSku string = 'standard'

@description('Optional. Enable RBAC authorization on the Key Vault. Defaults to true.')
param enableRbacAuthorization bool = true

@description('Optional. Enable the Key Vault for deployment. Defaults to true.')
param enableVaultForDeployment bool = true

@description('Optional. Network ACLs for the Key Vault.')
param networkAcls object?

@description('Optional. Public network access for the Key Vault.')
@allowed(['Enabled', 'Disabled', ''])
param keyVaultPublicNetworkAccess string = 'Disabled'

// ------------------
// VARIABLES
// ------------------

var vaultDnsZoneName = 'privatelink.vaultcore.azure.net'
var spokeVNetIdTokens = split(spokeVNetResourceId, '/')
var spokeSubscriptionId = spokeVNetIdTokens[2]
var spokeResourceGroupName = spokeVNetIdTokens[4]
var spokeVNetName = spokeVNetIdTokens[8]
var virtualNetworkLinks = concat(
  [
    {
      virtualNetworkResourceId: spokeVNetResourceId
      registrationEnabled: false
    }
  ],
  (!empty(hubVNetResourceId))
    ? [
        {
          virtualNetworkResourceId: hubVNetResourceId
          registrationEnabled: false
        }
      ]
    : []
)
// ------------------
// RESOURCES
// ------------------

resource vnetSpoke 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  scope: resourceGroup(spokeSubscriptionId, spokeResourceGroupName)
  name: spokeVNetName
}

resource spokePrivateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' existing = {
  parent: vnetSpoke
  name: spokePrivateEndpointSubnetName
}

module vaultdnszone 'br/public:avm/res/network/private-dns-zone:0.8.1' = {
  name: 'keyvaultDnsZoneDeployment-${uniqueString(resourceGroup().id)}'
  params: {
    name: vaultDnsZoneName
    location: 'global'
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: virtualNetworkLinks
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: 'vault-${uniqueString(resourceGroup().id)}'
  params: {
    name: keyVaultName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    sku: keyVaultSku
    networkAcls: networkAcls ?? {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: enablePurgeProtection
    publicNetworkAccess: !empty(keyVaultPublicNetworkAccess) ? keyVaultPublicNetworkAccess : 'Disabled'
    enableRbacAuthorization: enableRbacAuthorization
    enableVaultForDeployment: enableVaultForDeployment
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    enableVaultForDiskEncryption: enableVaultForDiskEncryption
    createMode: createMode
    accessPolicies: accessPolicies
    secrets: secrets
    keys: keys
    privateEndpoints: [
      {
        name: keyVaultPrivateEndpointName
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: vaultdnszone.outputs.resourceId
            }
          ]
        }
        subnetResourceId: spokePrivateEndpointSubnet.id
      }
    ]
    diagnosticSettings: diagnosticSettings
    lock: lock
    roleAssignments: concat(
      [
        {
          principalId: appServiceManagedIdentityPrincipalId
          roleDefinitionIdOrName: 'Key Vault Secrets User'
        }
      ],
      additionalRoleAssignments ?? []
    )
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the key vault.')
output keyVaultResourceId string = keyvault.outputs.resourceId

@description('The name of the key vault.')
output keyVaultName string = keyvault.outputs.name
