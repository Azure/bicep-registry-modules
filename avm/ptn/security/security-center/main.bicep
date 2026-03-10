metadata name = 'Azure Security Center (Defender for Cloud)'
metadata description = 'This module deploys an Azure Security Center (Defender for Cloud) Configuration.'

targetScope = 'subscription'

@description('Optional. Device Security group data.')
param deviceSecurityGroupProperties object = {}

@description('Optional. Security Solution data.')
param ioTSecuritySolutionProperties object = {}

@description('Optional. The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param virtualMachinesPricingTier string = 'Free'

@description('Optional. The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param sqlServersPricingTier string = 'Free'

@description('Optional. The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param appServicesPricingTier string = 'Free'

@description('Optional. The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param storageAccountsPricingTier string = 'Free'

@description('Optional. If the pricing tier value for StorageAccounts is Standard. Choose the settings for malware scanning.')
param storageAccountsMalwareScanningSettings {
  @description('Required. Enable or disable on-upload malware scanning for storage accounts. - True or False.')
  onUploadMalwareScanningEnabled: ('True' | 'False')
  @description('Optional. If on-upload malware scanning is enabled, set a cap for the amount of GB per month per storage account that can be scanned. If not set, there will be no cap applied.')
  capGBPerMonthPerStorageAccount: int?
  @description('Required. Enable or disable sensitive data discovery for storage accounts. - True or False.')
  sensitiveDataDiscoveryEnabled: ('True' | 'False')
}?

@description('Optional. The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param sqlServerVirtualMachinesPricingTier string = 'Free'

@description('Optional. The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param kubernetesServicePricingTier string = 'Free'

@description('Optional. The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param containerRegistryPricingTier string = 'Free'

@description('Optional. The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param keyVaultsPricingTier string = 'Free'

@description('Optional. The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param dnsPricingTier string = 'Free'

@description('Optional. The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param armPricingTier string = 'Free'

@description('Optional. The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param openSourceRelationalDatabasesTier string = 'Free'

@description('Optional. The pricing tier value for containers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param containersTier string = 'Free'

@description('Optional. The pricing tier value for CosmosDbs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param cosmosDbsTier string = 'Free'

@description('Optional. Security contact data.')
param securityContactProperties object = {}

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var pricings = [
  {
    name: 'VirtualMachines'
    pricingTier: virtualMachinesPricingTier
  }
  {
    name: 'SqlServers'
    pricingTier: sqlServersPricingTier
  }
  {
    name: 'AppServices'
    pricingTier: appServicesPricingTier
  }
  {
    name: 'StorageAccounts'
    pricingTier: storageAccountsPricingTier
    storageAccountsMalwareScanningSettings: storageAccountsMalwareScanningSettings
  }
  {
    name: 'SqlServerVirtualMachines'
    pricingTier: sqlServerVirtualMachinesPricingTier
  }
  {
    name: 'KubernetesService'
    pricingTier: kubernetesServicePricingTier
  }
  {
    name: 'ContainerRegistry'
    pricingTier: containerRegistryPricingTier
  }
  {
    name: 'KeyVaults'
    pricingTier: keyVaultsPricingTier
  }
  {
    name: 'Dns'
    pricingTier: dnsPricingTier
  }
  {
    name: 'Arm'
    pricingTier: armPricingTier
  }
  {
    name: 'OpenSourceRelationalDatabases'
    pricingTier: openSourceRelationalDatabasesTier
  }
  {
    name: 'Containers'
    pricingTier: containersTier
  }
  {
    name: 'CosmosDbs'
    pricingTier: cosmosDbsTier
  }
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.security-securitycenter.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

@batchSize(1)
resource pricingTiers 'Microsoft.Security/pricings@2024-01-01' = [
  for (pricing, index) in pricings: {
    name: pricing.name
    properties: {
      pricingTier: pricing.pricingTier
      subPlan: pricing.name == 'VirtualMachines' && pricing.pricingTier == 'Standard'
        ? 'P2'
        : pricing.name == 'StorageAccounts' && pricing.pricingTier == 'Standard' ? 'DefenderForStorageV2' : null
      #disable-next-line BCP187
      extensions: pricing.name == 'StorageAccounts' && pricing.pricingTier == 'Standard' && !empty(pricing.?storageAccountsMalwareScanningSettings)
        ? [
            {
              name: 'OnUploadMalwareScanning'
              isEnabled: storageAccountsMalwareScanningSettings.?onUploadMalwareScanningEnabled
              additionalExtensionProperties: (storageAccountsMalwareScanningSettings.?capGBPerMonthPerStorageAccount != null)
                ? {
                    CapGBPerMonthPerStorageAccount: storageAccountsMalwareScanningSettings.?capGBPerMonthPerStorageAccount
                  }
                : null
            }
            {
              name: 'SensitiveDataDiscovery'
              isEnabled: storageAccountsMalwareScanningSettings.?sensitiveDataDiscoveryEnabled
            }
          ]
        : null
    }
  }
]

resource deviceSecurityGroups 'Microsoft.Security/deviceSecurityGroups@2019-08-01' = if (!empty(deviceSecurityGroupProperties)) {
  name: 'deviceSecurityGroups'
  properties: {
    thresholdRules: deviceSecurityGroupProperties.thresholdRules
    timeWindowRules: deviceSecurityGroupProperties.timeWindowRules
    allowlistRules: deviceSecurityGroupProperties.allowlistRules
    denylistRules: deviceSecurityGroupProperties.denylistRules
  }
}

module iotSecuritySolutions 'modules/iotSecuritySolutions.bicep' = if (!empty(ioTSecuritySolutionProperties)) {
  name: '${uniqueString(deployment().name)}-ASC-IotSecuritySolutions'
  scope: resourceGroup(empty(ioTSecuritySolutionProperties) ? 'dummy' : ioTSecuritySolutionProperties.resourceGroup)
  params: {
    ioTSecuritySolutionProperties: ioTSecuritySolutionProperties
  }
}

resource securityContacts 'Microsoft.Security/securityContacts@2023-12-01-preview' = if (!empty(securityContactProperties)) {
  name: 'default'
  properties: {
    emails: securityContactProperties.emails
    isEnabled: securityContactProperties.?isEnabled ?? true
    notificationsByRole: securityContactProperties.notificationsByRole
    notificationsSources: securityContactProperties.notificationsSources
  }
}

@description('The name of the security center.')
output name string = 'Security'
