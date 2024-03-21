metadata name = 'Virtual Machine Scale Sets'
metadata description = 'This module deploys a Virtual Machine Scale Set.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the VMSS.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your virtual machine scale sets.')
param encryptionAtHost bool = true

@description('Optional. Specifies the SecurityType of the virtual machine scale set. It is set as TrustedLaunch to enable UefiSettings.')
param securityType string = ''

@description('Optional. Specifies whether secure boot should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param secureBootEnabled bool = false

@description('Optional. Specifies whether vTPM should be enabled on the virtual machine scale set. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param vTpmEnabled bool = false

@description('Required. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
param imageReference object

@description('Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.')
param plan object = {}

@description('Required. Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.')
param osDisk object

@description('Optional. Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.')
param dataDisks array = []

@description('Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.')
param ultraSSDEnabled bool = false

@description('Required. Administrator username.')
@secure()
param adminUsername string

@description('Optional. When specifying a Windows Virtual Machine, this value should be passed.')
@secure()
param adminPassword string = ''

@description('Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.')
param customData string = ''

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Fault Domain count for each placement group.')
param scaleSetFaultDomain int = 1

@description('Optional. Resource ID of a proximity placement group.')
param proximityPlacementGroupResourceId string = ''

@description('Required. Configures NICs and PIPs.')
param nicConfigurations array = []

@description('Optional. Specifies the priority for the virtual machine.')
@allowed([
  'Regular'
  'Low'
  'Spot'
])
param vmPriority string = 'Regular'

@description('Optional. Specifies the eviction policy for the low priority virtual machine. Will result in \'Deallocate\' eviction policy.')
param enableEvictionPolicy bool = false

@description('Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars.')
param maxPriceForLowPriorityVm string = ''

@description('Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system.')
@allowed([
  'Windows_Client'
  'Windows_Server'
  ''
])
param licenseType string = ''

@description('Optional. Required if name is specified. Password of the user specified in user parameter.')
@secure()
param extensionDomainJoinPassword string = ''

@description('Optional. The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDomainJoinConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionAntiMalwareConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Monitoring Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionMonitoringAgentConfig object = {
  enabled: false
}

@description('Optional. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceId string = ''

@description('Optional. The configuration for the [Dependency Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDependencyAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Network Watcher Agent] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionNetworkWatcherAgentConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Azure Disk Encryption] extension. Must at least contain the ["enabled": true] property to be executed. Restrictions: Cannot be enabled on disks that have encryption at host enabled. Managed disks encrypted using Azure Disk Encryption cannot be encrypted using customer-managed keys.')
param extensionAzureDiskEncryptionConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDSCConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Custom Script] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionCustomScriptConfig object = {
  enabled: false
  fileData: []
}

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

@description('Optional. Storage account used to store boot diagnostic information. Boot diagnostics will be disabled if no value is provided.')
param bootDiagnosticStorageAccountName string = ''

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Specifies the mode of an upgrade to virtual machines in the scale set.\' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling.')
@allowed([
  'Manual'
  'Automatic'
  'Rolling'
])
param upgradePolicyMode string = 'Manual'

@description('Optional. The maximum percent of total virtual machine instances that will be upgraded simultaneously by the rolling upgrade in one batch. As this is a maximum, unhealthy instances in previous or future batches can cause the percentage of instances in a batch to decrease to ensure higher reliability.')
param maxBatchInstancePercent int = 20

@description('Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch.')
param maxUnhealthyInstancePercent int = 20

@description('Optional. The maximum percentage of the total virtual machine instances in the scale set that can be simultaneously unhealthy, either as a result of being upgraded, or by being found in an unhealthy state by the virtual machine health checks before the rolling upgrade aborts. This constraint will be checked prior to starting any batch.')
param maxUnhealthyUpgradedInstancePercent int = 20

@description('Optional. The wait time between completing the update for all virtual machines in one batch and starting the next batch. The time duration should be specified in ISO 8601 format.')
param pauseTimeBetweenBatches string = 'PT0S'

@description('Optional. Indicates whether OS upgrades should automatically be applied to scale set instances in a rolling fashion when a newer version of the OS image becomes available. Default value is false. If this is set to true for Windows based scale sets, enableAutomaticUpdates is automatically set to false and cannot be set to true.')
param enableAutomaticOSUpgrade bool = false

@description('Optional. Whether OS image rollback feature should be disabled.')
param disableAutomaticRollback bool = false

@description('Optional. Specifies whether automatic repairs should be enabled on the virtual machine scale set.')
param automaticRepairsPolicyEnabled bool = false

@description('Optional. The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M).')
param gracePeriod string = 'PT30M'

@description('Optional. Specifies the computer name prefix for all of the virtual machines in the scale set.')
@minLength(1)
@maxLength(15)
param vmNamePrefix string = 'vmssvm'

@description('Optional. Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.')
param provisionVMAgent bool = true

@description('Optional. Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.')
param enableAutomaticUpdates bool = true

@description('Optional. Specifies the time zone of the virtual machine. e.g. \'Pacific Standard Time\'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`.')
param timeZone string = ''

@description('Optional. Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object.')
param additionalUnattendContent array = []

@description('Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.')
param winRM object = {}

@description('Optional. Specifies whether password authentication should be disabled.')
#disable-next-line secure-secrets-in-params // Not a secret
param disablePasswordAuthentication bool = false

@description('Optional. The list of SSH public keys used to authenticate with linux based VMs.')
param publicKeys array = []

@description('Optional. Specifies set of certificates that should be installed onto the virtual machines in the scale set.')
#disable-next-line secure-secrets-in-params // Not a secret
param secrets array = []

@description('Optional. Specifies Scheduled Event related configurations.')
param scheduledEventsProfile object = {}

@description('Optional. Specifies whether the Virtual Machine Scale Set should be overprovisioned.')
param overprovision bool = false

@description('Optional. When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs.')
param doNotRunExtensionsOnOverprovisionedVMs bool = false

@description('Optional. Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage.')
param zoneBalance bool = false

@description('Optional. When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true.')
param singlePlacementGroup bool = false

@description('Optional. Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in.')
param scaleInPolicy object = {
  rules: [
    'Default'
  ]
}

@description('Required. The SKU size of the VMs.')
param skuName string

@description('Optional. The initial instance count of scale set VMs.')
param skuCapacity int = 1

@description('Optional. The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set.')
param availabilityZones array = [ 1, 2, 3 ]

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The chosen OS type.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length to use to download files from storage accounts. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

var publicKeysFormatted = [for publicKey in publicKeys: {
  path: publicKey.path
  keyData: publicKey.keyData
}]

var linuxConfiguration = {
  disablePasswordAuthentication: disablePasswordAuthentication
  ssh: {
    publicKeys: publicKeysFormatted
  }
  provisionVMAgent: provisionVMAgent
}

var windowsConfiguration = {
  provisionVMAgent: provisionVMAgent
  enableAutomaticUpdates: enableAutomaticUpdates
  timeZone: empty(timeZone) ? null : timeZone
  additionalUnattendContent: empty(additionalUnattendContent) ? null : additionalUnattendContent
  winRM: !empty(winRM) ? {
    listeners: winRM
  } : null
}

var accountSasProperties = {
  signedServices: 'b'
  signedPermission: 'r'
  signedExpiry: dateTimeAdd(baseTime, sasTokenValidityLength)
  signedResourceTypes: 'o'
  signedProtocol: 'https'
}

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var enableReferencedModulesTelemetry = false

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Operator for Managed Disks': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '959f8984-c045-4866-89c7-12bf9737be2e')
  'Desktop Virtualization Power On Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '489581de-a3bd-480d-9518-53dea7416b33')
  'Desktop Virtualization Power On Off Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '40c5ff49-9181-41f8-ae61-143b0e78555e')
  'Desktop Virtualization Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a959dbd1-f747-45e3-8ba6-dd80f235f97c')
  'DevTest Labs User': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76283e04-6283-4c54-8f91-bcf1374a3c64')
  'Disk Backup Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24')
  'Disk Pool Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '60fc6e62-5479-42d4-8bf4-67625fcc2840')
  'Disk Restore Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b50d9833-a0cb-478e-945f-707fcc997c13')
  'Disk Snapshot Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7efff54f-a5b4-42b5-a1c5-5411624893ce')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
  'Virtual Machine Administrator Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1c0163c0-47e6-4577-8991-ea5c82e286e4')
  'Virtual Machine Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '9980e02c-c2be-4d73-94e8-173b1dc7cf3c')
  'Virtual Machine User Login': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'fb879df8-f326-4884-b1cf-06f3ad86be52')
  'VM Scanner Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd24ecba3-c1f4-40fa-a7bb-4588a071e8fd')
}

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.compute-virtualmachinescaleset.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2022-11-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  zones: availabilityZones
  properties: {
    proximityPlacementGroup: !empty(proximityPlacementGroupResourceId) ? {
      id: proximityPlacementGroupResourceId
    } : null
    upgradePolicy: {
      mode: upgradePolicyMode
      rollingUpgradePolicy: {
        maxBatchInstancePercent: maxBatchInstancePercent
        maxUnhealthyInstancePercent: maxUnhealthyInstancePercent
        maxUnhealthyUpgradedInstancePercent: maxUnhealthyUpgradedInstancePercent
        pauseTimeBetweenBatches: pauseTimeBetweenBatches
      }
      automaticOSUpgradePolicy: {
        enableAutomaticOSUpgrade: enableAutomaticOSUpgrade
        disableAutomaticRollback: disableAutomaticRollback
      }
    }
    automaticRepairsPolicy: {
      enabled: automaticRepairsPolicyEnabled
      gracePeriod: gracePeriod
    }
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: vmNamePrefix
        adminUsername: adminUsername
        adminPassword: !empty(adminPassword) ? adminPassword : null
        customData: !empty(customData) ? base64(customData) : null
        windowsConfiguration: osType == 'Windows' ? windowsConfiguration : null
        linuxConfiguration: osType == 'Linux' ? linuxConfiguration : null
        secrets: secrets
      }
      securityProfile: {
        encryptionAtHost: encryptionAtHost ? encryptionAtHost : null
        securityType: securityType
        uefiSettings: securityType == 'TrustedLaunch' ? {
          secureBootEnabled: secureBootEnabled
          vTpmEnabled: vTpmEnabled
        } : null
      }
      storageProfile: {
        imageReference: imageReference
        osDisk: {
          createOption: osDisk.createOption
          diskSizeGB: osDisk.diskSizeGB
          caching: contains(osDisk, 'caching') ? osDisk.caching : null
          writeAcceleratorEnabled: contains(osDisk, 'writeAcceleratorEnabled') ? osDisk.writeAcceleratorEnabled : null
          diffDiskSettings: contains(osDisk, 'diffDiskSettings') ? osDisk.diffDiskSettings : null
          osType: contains(osDisk, 'osType') ? osDisk.osType : null
          image: contains(osDisk, 'image') ? osDisk.image : null
          vhdContainers: contains(osDisk, 'vhdContainers') ? osDisk.vhdContainers : null
          managedDisk: {
            storageAccountType: osDisk.managedDisk.storageAccountType
            diskEncryptionSet: contains(osDisk.managedDisk, 'diskEncryptionSet') ? {
              id: osDisk.managedDisk.diskEncryptionSet.id
            } : null
          }
        }
        dataDisks: [for (dataDisk, index) in dataDisks: {
          lun: index
          diskSizeGB: dataDisk.diskSizeGB
          createOption: dataDisk.createOption
          caching: dataDisk.caching
          writeAcceleratorEnabled: contains(osDisk, 'writeAcceleratorEnabled') ? osDisk.writeAcceleratorEnabled : null
          managedDisk: {
            storageAccountType: dataDisk.managedDisk.storageAccountType
            diskEncryptionSet: contains(dataDisk.managedDisk, 'diskEncryptionSet') ? {
              id: dataDisk.managedDisk.diskEncryptionSet.id
            } : null
          }
          diskIOPSReadWrite: contains(osDisk, 'diskIOPSReadWrite') ? dataDisk.diskIOPSReadWrite : null
          diskMBpsReadWrite: contains(osDisk, 'diskMBpsReadWrite') ? dataDisk.diskMBpsReadWrite : null
        }]
      }
      networkProfile: {
        networkInterfaceConfigurations: [for (nicConfiguration, index) in nicConfigurations: {
          name: '${name}${nicConfiguration.nicSuffix}configuration-${index}'
          properties: {
            primary: (index == 0) ? true : any(null)
            enableAcceleratedNetworking: contains(nicConfiguration, 'enableAcceleratedNetworking') ? nicConfiguration.enableAcceleratedNetworking : true
            networkSecurityGroup: contains(nicConfiguration, 'nsgId') ? {
              id: nicConfiguration.nsgId
            } : null
            ipConfigurations: nicConfiguration.ipConfigurations
          }
        }]
      }
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: !empty(bootDiagnosticStorageAccountName)
          storageUri: !empty(bootDiagnosticStorageAccountName) ? 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}' : null
        }
      }
      licenseType: empty(licenseType) ? null : licenseType
      priority: vmPriority
      evictionPolicy: enableEvictionPolicy ? 'Deallocate' : null
      billingProfile: !empty(vmPriority) && !empty(maxPriceForLowPriorityVm) ? {
        maxPrice: maxPriceForLowPriorityVm
      } : null
      scheduledEventsProfile: scheduledEventsProfile
    }
    overprovision: overprovision
    doNotRunExtensionsOnOverprovisionedVMs: doNotRunExtensionsOnOverprovisionedVMs
    zoneBalance: zoneBalance == 'true' ? zoneBalance : null
    platformFaultDomainCount: scaleSetFaultDomain
    singlePlacementGroup: singlePlacementGroup
    additionalCapabilities: {
      ultraSSDEnabled: ultraSSDEnabled
    }
    scaleInPolicy: scaleInPolicy
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  plan: !empty(plan) ? plan : null
}

module vmss_domainJoinExtension 'extension/main.bicep' = if (extensionDomainJoinConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DomainJoin'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DomainJoin'
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: contains(extensionDomainJoinConfig, 'typeHandlerVersion') ? extensionDomainJoinConfig.typeHandlerVersion : '1.3'
    autoUpgradeMinorVersion: contains(extensionDomainJoinConfig, 'autoUpgradeMinorVersion') ? extensionDomainJoinConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDomainJoinConfig, 'enableAutomaticUpgrade') ? extensionDomainJoinConfig.enableAutomaticUpgrade : false
    settings: extensionDomainJoinConfig.settings
    protectedSettings: {
      Password: extensionDomainJoinPassword
    }
  }
}

module vmss_microsoftAntiMalwareExtension 'extension/main.bicep' = if (extensionAntiMalwareConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-MicrosoftAntiMalware'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'MicrosoftAntiMalware'
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: contains(extensionAntiMalwareConfig, 'typeHandlerVersion') ? extensionAntiMalwareConfig.typeHandlerVersion : '1.3'
    autoUpgradeMinorVersion: contains(extensionAntiMalwareConfig, 'autoUpgradeMinorVersion') ? extensionAntiMalwareConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionAntiMalwareConfig, 'enableAutomaticUpgrade') ? extensionAntiMalwareConfig.enableAutomaticUpgrade : false
    settings: extensionAntiMalwareConfig.settings
  }
  dependsOn: [
    vmss_domainJoinExtension
  ]
}

resource vmss_logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (!empty(monitoringWorkspaceId)) {
  name: last(split((!empty(monitoringWorkspaceId) ? monitoringWorkspaceId : 'law'), '/'))!
  scope: az.resourceGroup(split((!empty(monitoringWorkspaceId) ? monitoringWorkspaceId : '//'), '/')[2], split((!empty(monitoringWorkspaceId) ? monitoringWorkspaceId : '////'), '/')[4])
}

module vmss_azureMonitorAgentExtension 'extension/main.bicep' = if (extensionMonitoringAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-AzureMonitorAgent'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'AzureMonitorAgent'
    publisher: 'Microsoft.Azure.Monitor'
    type: osType == 'Windows' ? 'AzureMonitorWindowsAgent' : 'AzureMonitorLinuxAgent'
    typeHandlerVersion: contains(extensionMonitoringAgentConfig, 'typeHandlerVersion') ? extensionMonitoringAgentConfig.typeHandlerVersion : (osType == 'Windows' ? '1.22' : '1.29')
    autoUpgradeMinorVersion: contains(extensionMonitoringAgentConfig, 'autoUpgradeMinorVersion') ? extensionMonitoringAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionMonitoringAgentConfig, 'enableAutomaticUpgrade') ? extensionMonitoringAgentConfig.enableAutomaticUpgrade : false
    settings: {
      workspaceId: !empty(monitoringWorkspaceId) ? reference(vmss_logAnalyticsWorkspace.id, vmss_logAnalyticsWorkspace.apiVersion).customerId : ''
      GCS_AUTO_CONFIG: osType == 'Linux' ? true : null
    }
    protectedSettings: {
      workspaceKey: !empty(monitoringWorkspaceId) ? vmss_logAnalyticsWorkspace.listKeys().primarySharedKey : ''
    }
  }
  dependsOn: [
    vmss_microsoftAntiMalwareExtension
  ]
}

module vmss_dependencyAgentExtension 'extension/main.bicep' = if (extensionDependencyAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DependencyAgent'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DependencyAgent'
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: osType == 'Windows' ? 'DependencyAgentWindows' : 'DependencyAgentLinux'
    typeHandlerVersion: contains(extensionDependencyAgentConfig, 'typeHandlerVersion') ? extensionDependencyAgentConfig.typeHandlerVersion : '9.5'
    autoUpgradeMinorVersion: contains(extensionDependencyAgentConfig, 'autoUpgradeMinorVersion') ? extensionDependencyAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDependencyAgentConfig, 'enableAutomaticUpgrade') ? extensionDependencyAgentConfig.enableAutomaticUpgrade : true
  }
  dependsOn: [
    vmss_azureMonitorAgentExtension
  ]
}

module vmss_networkWatcherAgentExtension 'extension/main.bicep' = if (extensionNetworkWatcherAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-NetworkWatcherAgent'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'NetworkWatcherAgent'
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: osType == 'Windows' ? 'NetworkWatcherAgentWindows' : 'NetworkWatcherAgentLinux'
    typeHandlerVersion: contains(extensionNetworkWatcherAgentConfig, 'typeHandlerVersion') ? extensionNetworkWatcherAgentConfig.typeHandlerVersion : '1.4'
    autoUpgradeMinorVersion: contains(extensionNetworkWatcherAgentConfig, 'autoUpgradeMinorVersion') ? extensionNetworkWatcherAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionNetworkWatcherAgentConfig, 'enableAutomaticUpgrade') ? extensionNetworkWatcherAgentConfig.enableAutomaticUpgrade : false
  }
  dependsOn: [
    vmss_dependencyAgentExtension
  ]
}

module vmss_desiredStateConfigurationExtension 'extension/main.bicep' = if (extensionDSCConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DesiredStateConfiguration'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DesiredStateConfiguration'
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: contains(extensionDSCConfig, 'typeHandlerVersion') ? extensionDSCConfig.typeHandlerVersion : '2.77'
    autoUpgradeMinorVersion: contains(extensionDSCConfig, 'autoUpgradeMinorVersion') ? extensionDSCConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDSCConfig, 'enableAutomaticUpgrade') ? extensionDSCConfig.enableAutomaticUpgrade : false
    settings: contains(extensionDSCConfig, 'settings') ? extensionDSCConfig.settings : {}
    protectedSettings: contains(extensionDSCConfig, 'protectedSettings') ? extensionDSCConfig.protectedSettings : {}
  }
  dependsOn: [
    vmss_networkWatcherAgentExtension
  ]
}

module vmss_customScriptExtension 'extension/main.bicep' = if (extensionCustomScriptConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-CustomScriptExtension'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'CustomScriptExtension'
    publisher: osType == 'Windows' ? 'Microsoft.Compute' : 'Microsoft.Azure.Extensions'
    type: osType == 'Windows' ? 'CustomScriptExtension' : 'CustomScript'
    typeHandlerVersion: contains(extensionCustomScriptConfig, 'typeHandlerVersion') ? extensionCustomScriptConfig.typeHandlerVersion : (osType == 'Windows' ? '1.10' : '2.1')
    autoUpgradeMinorVersion: contains(extensionCustomScriptConfig, 'autoUpgradeMinorVersion') ? extensionCustomScriptConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionCustomScriptConfig, 'enableAutomaticUpgrade') ? extensionCustomScriptConfig.enableAutomaticUpgrade : false
    settings: {
      fileUris: [for fileData in extensionCustomScriptConfig.fileData: contains(fileData, 'storageAccountId') ? '${fileData.uri}?${listAccountSas(fileData.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}' : fileData.uri]
    }
    protectedSettings: contains(extensionCustomScriptConfig, 'protectedSettings') ? extensionCustomScriptConfig.protectedSettings : {}
  }
  dependsOn: [
    vmss_desiredStateConfigurationExtension
  ]
}

module vmss_azureDiskEncryptionExtension 'extension/main.bicep' = if (extensionAzureDiskEncryptionConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-AzureDiskEncryption'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'AzureDiskEncryption'
    publisher: 'Microsoft.Azure.Security'
    type: osType == 'Windows' ? 'AzureDiskEncryption' : 'AzureDiskEncryptionForLinux'
    typeHandlerVersion: contains(extensionAzureDiskEncryptionConfig, 'typeHandlerVersion') ? extensionAzureDiskEncryptionConfig.typeHandlerVersion : (osType == 'Windows' ? '2.2' : '1.1')
    autoUpgradeMinorVersion: contains(extensionAzureDiskEncryptionConfig, 'autoUpgradeMinorVersion') ? extensionAzureDiskEncryptionConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionAzureDiskEncryptionConfig, 'enableAutomaticUpgrade') ? extensionAzureDiskEncryptionConfig.enableAutomaticUpgrade : false
    forceUpdateTag: contains(extensionAzureDiskEncryptionConfig, 'forceUpdateTag') ? extensionAzureDiskEncryptionConfig.forceUpdateTag : '1.0'
    settings: extensionAzureDiskEncryptionConfig.settings
  }
  dependsOn: [
    vmss_customScriptExtension
  ]
}

resource vmss_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: vmss
}

resource vmss_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: [for group in (diagnosticSetting.?metricCategories ?? [ { category: 'AllMetrics' } ]): {
      category: group.category
      enabled: group.?enabled ?? true
      timeGrain: null
    }]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: vmss
}]

resource vmss_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(vmss.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: vmss
}]

@description('The resource ID of the virtual machine scale set.')
output resourceId string = vmss.id

@description('The resource group of the virtual machine scale set.')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual machine scale set.')
output name string = vmss.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = vmss.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = vmss.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
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

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
