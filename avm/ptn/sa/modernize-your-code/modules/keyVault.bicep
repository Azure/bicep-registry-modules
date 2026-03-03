@description('Required. Name of the Key Vault.')
param name string

@description('Required. Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Optional. Specifies the SKU for the vault.')
@allowed([
  'premium'
  'standard'
])
param sku string = 'premium'

@description('Optional. Resource ID of the Log Analytics workspace to use for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string?

import { resourcePrivateNetworkingType } from 'customTypes.bicep'
@description('Optional. Values to establish private networking for the Key Vault resource.')
param privateNetworking resourcePrivateNetworkingType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { secretType } from 'br/public:avm/res/key-vault/vault:0.12.1'
@description('Optional. Array of secrets to create in the Key Vault.')
param secrets secretType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var privateDnsZoneResourceId = privateNetworking != null ? privateNetworking.?privateDnsZoneResourceId ?? '' : ''

module keyvault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: take('avm.res.key-vault.vault.${name}', 64)
  params: {
    name: name
    location: location
    tags: tags
    createMode: 'default'
    sku: sku
    publicNetworkAccess: privateNetworking != null ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
    }
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enablePurgeProtection: false
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    diagnosticSettings: !empty(logAnalyticsWorkspaceResourceId)
      ? [
          {
            workspaceResourceId: logAnalyticsWorkspaceResourceId
          }
        ]
      : []
    privateEndpoints: privateNetworking != null
      ? [
          {
            name: 'pep-${name}'
            customNetworkInterfaceName: 'nic-${name}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateDnsZoneResourceId
                }
              ]
            }
            service: 'vault'
            subnetResourceId: privateNetworking.?subnetResourceId ?? ''
          }
        ]
      : []
    roleAssignments: roleAssignments
    secrets: secrets
    enableTelemetry: enableTelemetry
  }
}

@description('Name of the Key Vault resource.')
output name string = keyvault.outputs.name

@description('Resource ID of the Key Vault.')
output resourceId string = keyvault.outputs.resourceId
