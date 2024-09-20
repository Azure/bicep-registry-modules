metadata name = 'Azure Security Center (Defender for Cloud)'
metadata description = 'This module deploys an Azure Security Center (Defender for Cloud) Configuration.'
metadata owner = 'Azure/module-maintainers'

targetScope = 'subscription'

@description('Required. The full resource Id of the Log Analytics workspace to save the data in.')
param workspaceResourceId string

@description('Required. All the VMs in this scope will send their security data to the mentioned workspace unless overridden by a setting with more specific scope.')
param scope string

@description('Optional. Describes what kind of security agent provisioning action to take. - On or Off.')
@allowed([
  'On'
  'Off'
])
param autoProvision string = 'On'

@description('Optional. Device Security group data.')
param deviceSecurityGroupProperties object = {}

@description('Optional. Security Solution data.')
param ioTSecuritySolutionProperties object = {}

@description('Optional. The sub-plan selected for a Standard pricing configuration, when more than one sub-plan is available. Each sub-plan enables a set of security features. When not specified, full plan is applied. For VirtualMachines plan, available sub plans are "P1" & "P2", where for resource level only "P1" sub plan is supported. Only usable if PricingTier = "Standard".')
@allowed([
  'P1'
  'P2'
])
param virtualMachinesSubPlan string?

@description('Optional. The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param virtualMachinesPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param virtualMachinesPricingEnforce string?

@description('Optional. Property values associated with the VirtualMachine extension.')
param virtualMachinesPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the VirtualMachine extension.')
param virtualMachinesPricingIsEnabled string?

@description('Conditional. Property values associated with the VirtualMachine extension.')
param virtualMachinesPricingName string?

@description('Optional. The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param sqlServersPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param sqlServersPricingEnforce string?

@description('Optional. Property values associated with the SqlServers extension.')
param sqlServersPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the SqlServers extension.')
param sqlServersPricingIsEnabled string?

@description('Conditional. Property values associated with the SqlServers extension.')
param sqlServersPricingName string?

@description('Optional. The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param appServicesPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param appServicesPricingEnforce string?

@description('Optional. Property values associated with the AppServices extension.')
param appServicesPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the AppServices extension.')
param appServicesPricingIsEnabled string?

@description('Conditional. Property values associated with the AppServices extension.')
param appServicesPricingName string?

@description('Optional. The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param storageAccountsPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param storageAccountsPricingEnforce string?

@description('Optional. Property values associated with the StorageAccounts extension.')
param storageAccountsPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the StorageAccounts extension.')
param storageAccountsPricingIsEnabled string?

@description('Conditional. Property values associated with the StorageAccounts extension.')
param storageAccountsPricingName string?

@description('Optional. The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param sqlServerVirtualMachinesPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param sqlServerVirtualMachinesPricingEnforce string?

@description('Optional. Property values associated with the SqlServerVirtualMachines extension.')
param sqlServerVirtualMachinesPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the SqlServerVirtualMachines extension.')
param sqlServerVirtualMachinesPricingIsEnabled string?

@description('Conditional. Property values associated with the SqlServerVirtualMachines extension.')
param sqlServerVirtualMachinesPricingName string?

@description('Optional. The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param kubernetesServicePricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param kubernetesServicePricingEnforce string?

@description('Optional. Property values associated with the KubernetesService extension.')
param kubernetesServicePricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the KubernetesService extension.')
param kubernetesServicePricingIsEnabled string?

@description('Conditional. Property values associated with the KubernetesService extension.')
param kubernetesServicePricingName string?

@description('Optional. The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param containerRegistryPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param containerRegistryPricingEnforce string?

@description('Optional. Property values associated with the ContainerRegistry extension.')
param containerRegistryPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the ContainerRegistry extension.')
param containerRegistryPricingIsEnabled string?

@description('Conditional. Property values associated with the ContainerRegistry extension.')
param containerRegistryPricingName string?

@description('Optional. The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param keyVaultsPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param keyVaultsPricingEnforce string?

@description('Optional. Property values associated with the KeyVaults extension.')
param keyVaultsPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the KeyVaults extension.')
param keyVaultsPricingIsEnabled string?

@description('Conditional. Property values associated with the KeyVaults extension.')
param keyVaultsPricingName string?

@description('Optional. The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param dnsPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param dnsPricingEnforce string?

@description('Optional. Property values associated with the DNS extension.')
param dnsPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the DNS extension.')
param dnsPricingIsEnabled string?

@description('Conditional. Property values associated with the DNS extension.')
param dnsPricingName string?

@description('Optional. The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param armPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param armPricingEnforce string?

@description('Optional. Property values associated with the ARM extension.')
param armPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the ARM extension.')
param armPricingIsEnabled string?

@description('Conditional. Property values associated with the ARM extension.')
param armPricingName string?

@description('Optional. The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param openSourceRelationalDatabasesPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param openSourceRelationalDatabasesPricingEnforce string?

@description('Optional. Property values associated with the OpenSourceRelationalDatabases extension.')
param openSourceRelationalDatabasesPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the OpenSourceRelationalDatabases extension.')
param openSourceRelationalDatabasesPricingIsEnabled string?

@description('Conditional. Property values associated with the OpenSourceRelationalDatabases extension.')
param openSourceRelationalDatabasesPricingName string?

@description('Optional. The pricing tier value for containers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param containersPricingTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param containersPricingEnforce string?

@description('Optional. Property values associated with the containers extension.')
param containersPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the containers extension.')
param containersPricingIsEnabled string?

@description('Conditional. Property values associated with the containers extension.')
param containersPricingName string?

@description('Optional. The pricing tier value for CosmosDbs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.')
@allowed([
  'Free'
  'Standard'
])
param cosmosDbsTier string = 'Free'

@description('Optional. If set to "False", it allows the descendants of this scope to override the pricing configuration set on this scope (allows setting inherited="False"). If set to "True", it prevents overrides and forces this pricing configuration on all the descendants of this scope. This field is only available for subscription-level pricing.')
@allowed([
  'True'
  'False'
])
param cosmosDbsPricingEnforce string?

@description('Optional. Property values associated with the CosmosDbs extension.')
param cosmosDbsPricingAdditionalExtensionProperties array?

@description('Conditional. Required if using extensions. Property values associated with the CosmosDbs extension.')
param cosmosDbsPricingIsEnabled string?

@description('Conditional. Property values associated with the CosmosDbs extension.')
param cosmosDbsPricingName string?

@description('Optional. Security contact data.')
param securityContactsProperties securityContactsType

@description('Optional. Location deployment metadata.')
param location string = deployment().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var pricings = [
  {
    name: 'VirtualMachines'
    pricingTier: virtualMachinesPricingTier
    subPlan: (virtualMachinesPricingTier == 'Standard' ? virtualMachinesSubPlan : null)
    enforce: virtualMachinesPricingEnforce
    extensions: {
      additionalExtensionProperties: virtualMachinesPricingAdditionalExtensionProperties
      isEnabled: virtualMachinesPricingIsEnabled
      name: virtualMachinesPricingName
    }
  }
  {
    name: 'SqlServers'
    pricingTier: sqlServersPricingTier
    subPlan: null
    enforce: sqlServersPricingEnforce
    extensions: {
      additionalExtensionProperties: sqlServersPricingAdditionalExtensionProperties
      isEnabled: sqlServersPricingIsEnabled
      name: sqlServersPricingName
    }
  }
  {
    name: 'AppServices'
    pricingTier: appServicesPricingTier
    subPlan: null
    enforce: appServicesPricingEnforce
    extensions: {
      additionalExtensionProperties: appServicesPricingAdditionalExtensionProperties
      isEnabled: appServicesPricingIsEnabled
      name: appServicesPricingName
    }
  }
  {
    name: 'StorageAccounts'
    pricingTier: storageAccountsPricingTier
    subPlan: null
    enforce: storageAccountsPricingEnforce
    extensions: {
      additionalExtensionProperties: storageAccountsPricingAdditionalExtensionProperties
      isEnabled: storageAccountsPricingIsEnabled
      name: storageAccountsPricingName
    }
  }
  {
    name: 'SqlServerVirtualMachines'
    pricingTier: sqlServerVirtualMachinesPricingTier
    subPlan: null
    enforce: sqlServerVirtualMachinesPricingEnforce
    extensions: {
      additionalExtensionProperties: sqlServerVirtualMachinesPricingAdditionalExtensionProperties
      isEnabled: sqlServerVirtualMachinesPricingIsEnabled
      name: sqlServerVirtualMachinesPricingName
    }
  }
  {
    name: 'KubernetesService'
    pricingTier: kubernetesServicePricingTier
    subPlan: null
    enforce: kubernetesServicePricingEnforce
    extensions: {
      additionalExtensionProperties: kubernetesServicePricingAdditionalExtensionProperties
      isEnabled: kubernetesServicePricingIsEnabled
      name: kubernetesServicePricingName
    }
  }
  {
    name: 'ContainerRegistry'
    pricingTier: containerRegistryPricingTier
    subPlan: null
    enforce: containerRegistryPricingEnforce
    extensions: {
      additionalExtensionProperties: containerRegistryPricingAdditionalExtensionProperties
      isEnabled: containerRegistryPricingIsEnabled
      name: containerRegistryPricingName
    }
  }
  {
    name: 'KeyVaults'
    pricingTier: keyVaultsPricingTier
    subPlan: null
    enforce: keyVaultsPricingEnforce
    extensions: {
      additionalExtensionProperties: keyVaultsPricingAdditionalExtensionProperties
      isEnabled: keyVaultsPricingIsEnabled
      name: keyVaultsPricingName
    }
  }
  {
    name: 'Dns'
    pricingTier: dnsPricingTier
    subPlan: null
    enforce: dnsPricingEnforce
    extensions: {
      additionalExtensionProperties: dnsPricingAdditionalExtensionProperties
      isEnabled: dnsPricingIsEnabled
      name: dnsPricingName
    }
  }
  {
    name: 'Arm'
    pricingTier: armPricingTier
    subPlan: null
    enforce: armPricingEnforce
    extensions: {
      additionalExtensionProperties: armPricingAdditionalExtensionProperties
      isEnabled: armPricingIsEnabled
      name: armPricingName
    }
  }
  {
    name: 'OpenSourceRelationalDatabases'
    pricingTier: openSourceRelationalDatabasesPricingTier
    subPlan: null
    enforce: openSourceRelationalDatabasesPricingEnforce
    extensions: {
      additionalExtensionProperties: openSourceRelationalDatabasesPricingAdditionalExtensionProperties
      isEnabled: openSourceRelationalDatabasesPricingIsEnabled
      name: openSourceRelationalDatabasesPricingName
    }
  }
  {
    name: 'Containers'
    pricingTier: containersPricingTier
    subPlan: null
    enforce: containersPricingEnforce
    extensions: {
      additionalExtensionProperties: containersPricingAdditionalExtensionProperties
      isEnabled: containersPricingIsEnabled
      name: containersPricingName
    }
  }
  {
    name: 'CosmosDbs'
    pricingTier: cosmosDbsTier
    subPlan: null
    enforce: cosmosDbsPricingEnforce
    extensions: {
      additionalExtensionProperties: cosmosDbsPricingAdditionalExtensionProperties
      isEnabled: cosmosDbsPricingIsEnabled
      name: cosmosDbsPricingName
    }
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
      enforce: pricing.enforce
      extensions: [
        {
          additionalExtensionProperties: pricing.extension.additionalExtensionProperties
          isEnabled: pricing.extension.isEnabled
          name: pricing.extension.name
        }
      ]
      pricingTier: pricing.pricingTier
      subPlan: pricing.subPlan
    }
  }
]

resource autoProvisioningSettings 'Microsoft.Security/autoProvisioningSettings@2017-08-01-preview' = {
  name: 'default'
  properties: {
    autoProvision: autoProvision
  }
}

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

resource securityContacts 'Microsoft.Security/securityContacts@2023-12-01-preview' = if (securityContactsProperties != null) {
  name: 'default'
  properties: {
    emails: securityContactsProperties.?emails
    isEnabled: securityContactsProperties.?isEnabled
    notificationsByRole: {
      roles: securityContactsProperties.?notificationsByRole.roles
      state: securityContactsProperties.?notificationsByRole.state
    }
    notificationsSources: [
      {
        sourceType: 'Alert'
        minimalSeverity: securityContactsProperties!.alertMinimalSeverity
      }
      {
        sourceType: 'AttackPath'
        minimalRiskLevel: securityContactsProperties!.attackMinimalRiskLevel
      }
    ]
    phone: securityContactsProperties.?phone
  }
}

resource workspaceSettings 'Microsoft.Security/workspaceSettings@2017-08-01-preview' = {
  name: 'default'
  properties: {
    workspaceId: workspaceResourceId
    scope: scope
  }
  dependsOn: [
    autoProvisioningSettings
  ]
}

@description('The resource ID of the used log analytics workspace.')
output workspaceResourceId string = workspaceResourceId

@description('The name of the security center.')
output name string = 'Security'

// =============== //
//   Definitions   //
// =============== //

type securityContactsType = {
  @description('Optional. List of email addresses (;-delimited) which will get notifications from Microsoft Defender for Cloud by the configurations defined in this security contact.')
  emails: string?

  @description('Optional. Indicates whether the security contact is enabled.')
  isEnabled: bool?

  @description('Optional. Defines whether to send email notifications from Microsoft Defender for Cloud to persons with specific RBAC roles on the subscription.')
  notificationsByRole: {
    @description('Conditional. Required if using notificationsByRole. Defines which RBAC roles will get email notifications from Microsoft Defender for Cloud.')
    roles: ('AccountAdmin' | 'Contributor' | 'Owner' | 'ServiceAdmin')[]

    @description('Conditional. Required if using notificationsByRole. Defines whether to send email notifications from AMicrosoft Defender for Cloud to persons with specific RBAC roles on the subscription.')
    state: ('On' | 'Off')
  }?

  @description('Required. Defines the minimal alert risk level which will be sent as email notifications.')
  alertMinimalSeverity: ('High' | 'Low' | 'Medium')

  @description('Required. Defines the minimal attack path risk level which will be sent as email notifications.')
  attackMinimalRiskLevel: ('Critical' | 'High' | 'Low' | 'Medium')

  @description('''Optional. The security contact's phone number.''')
  phone: string?
}?
