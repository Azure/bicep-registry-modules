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

@description('Specifies whether network isolation is enabled. This will create a private endpoint for the Key Vault and link the private DNS zone.')
param networkIsolation bool = true

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string

@description('Resource ID of the Log Analytics workspace for diagnostic logs.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate.')
param aiFoundryType string

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
    publicNetworkAccess: toLower(aiFoundryType) == 'standardprivate' ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: toLower(aiFoundryType) == 'standardprivate' ? 'Deny' : 'Allow'
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
                  privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
                }
              ]
            }
            service: 'vault'
            subnetResourceId: virtualNetworkSubnetResourceId
          }
        ]
      : []
    roleAssignments: empty(userObjectId)
      ? []
      : [
          {
            principalId: userObjectId
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Key Vault Secrets User'
          }
        ]
  }
}

output resourceId string = keyvault.outputs.resourceId
output name string = keyvault.outputs.name
