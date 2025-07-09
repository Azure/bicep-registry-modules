@description('Name of the Key Vault.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Resource ID of the virtual network to link the private DNS zones.')
param virtualNetworkResourceId string

@description('Resource ID of the subnet for the private endpoint.')
param virtualNetworkSubnetResourceId string

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Resource ID of the Log Analytics workspace for diagnostic logs.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional. Specifies if the Key Vault should be deployed with private networking enabled. This will disable public access to the Key Vault and require all access to go through the private endpoint.')
param networkIsolation bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (networkIsolation) {
  name: 'private-dns-keyvault-deployment'
  params: {
    name: 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'vaultcore.usgovcloudapi.net' : 'vaultcore.azure.net'}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

var nameFormatted = take(toLower(name), 24)

module keyvault 'br/public:avm/res/key-vault/vault:0.13.0' = {
  name: take('${nameFormatted}-keyvault-deployment', 64)
  params: {
    name: nameFormatted
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: networkIsolation ? 'Deny' : 'Allow'
    }
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    diagnosticSettings: !empty(logAnalyticsWorkspaceResourceId)
      ? [
          {
            name: 'sendToLogAnalytics'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                category: 'AuditEvent'
                enabled: true
              }
              {
                category: 'AzurePolicyEvaluationDetails'
                enabled: true
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
                enabled: true
              }
            ]
          }
        ]
      : []
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateDnsZone!.outputs.resourceId
                }
              ]
            }
            service: 'vault'
            subnetResourceId: virtualNetworkSubnetResourceId
          }
        ]
      : []
    roleAssignments: roleAssignments
  }
}

output resourceId string = keyvault.outputs.resourceId
output name string = keyvault.outputs.name
