metadata name = 'Virtual Machine Scale Sets'
metadata description = 'This module deploys a Virtual Machine Scale Set.'

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
param plan resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-11-01'>.plan?

@description('Required. Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.')
param osDisk resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-11-01'>.properties.virtualMachineProfile.storageProfile.osDisk

@description('Optional. Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VM Scale sets.')
param dataDisks resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-11-01'>.properties.virtualMachineProfile.storageProfile.dataDisks = []

@description('Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.')
param ultraSSDEnabled bool = false

@description('Required. Administrator username.')
@secure()
param adminUsername string

@description('Required. When specifying a Windows Virtual Machine, this value should be passed.')
@secure()
param adminPassword string

@description('Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.')
param customData string = ''

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Fault Domain count for each placement group.')
param scaleSetFaultDomain int = 1

@description('Optional. Resource ID of a proximity placement group.')
param proximityPlacementGroupResourceId string?

@description('Required. Configures NICs and PIPs. The first item in the list is considered the `primary` configuration.')
param nicConfigurations nicConfigurationType[]

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
param maxPriceForLowPriorityVm int?

@description('Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system.')
@allowed([
  'Windows_Client'
  'Windows_Server'
])
param licenseType string?

@description('Optional. Required if name is specified. Password of the user specified in user parameter.')
@secure()
param extensionDomainJoinPassword string = ''

@description('Optional. The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed.')
@secure()
#disable-next-line secure-parameter-default
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
  autoUpgradeMinorVersion: true
}

@description('Optional. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceResourceId string = ''

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

@description('Optional. Turned on by default. The configuration for the [Application Health Monitoring] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionHealthConfig extensionHealthConfigType = {
  enabled: true
  protocol: 'http'
  port: 80
  requestPath: '/'
}

@description('Optional. The configuration for the [Desired State Configuration] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDSCConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [Custom Script] extension.')
param extensionCustomScriptConfig extensionCustomScriptConfigType?

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

@description('Optional. The name of the boot diagnostic storage account. Provide this if you want to use your own storage account for security reasons instead of the recommended Microsoft Managed Storage Account.')
param bootDiagnosticStorageAccountName string?

@description('Optional. Enable boot diagnostics to use default managed or secure storage. Defaults set to false.')
param bootDiagnosticEnabled bool = false

import { diagnosticSettingMetricsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingMetricsOnlyType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Specifies the mode of an upgrade to virtual machines in the scale set.\' Manual - You control the application of updates to virtual machines in the scale set. You do this by using the manualUpgrade action. ; Automatic - All virtual machines in the scale set are automatically updated at the same time. - Automatic, Manual, Rolling.')
@allowed([
  'Manual'
  'Automatic'
  'Rolling'
])
param upgradePolicyMode string = 'Manual'

@description('Optional. Allow VMSS to ignore AZ boundaries when constructing upgrade batches. Take into consideration the Update Domain and maxBatchInstancePercent to determine the batch size.')
param enableCrossZoneUpgrade bool = false

@description('Optional. Create new virtual machines to upgrade the scale set, rather than updating the existing virtual machines. Existing virtual machines will be deleted once the new virtual machines are created for each batch.')
param maxSurge bool = false

@description('Optional. Upgrade all unhealthy instances in a scale set before any healthy instances.')
param prioritizeUnhealthyInstances bool = false

@description('Optional. Rollback failed instances to previous model if the Rolling Upgrade policy is violated.')
param rollbackFailedInstancesOnPolicyBreach bool = false

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
param automaticRepairsPolicyEnabled bool = true

@description('Optional. The amount of time for which automatic repairs are suspended due to a state change on VM. The grace time starts after the state change has completed. This helps avoid premature or accidental repairs. The time duration should be specified in ISO 8601 format. The minimum allowed grace period is 30 minutes (PT30M). The maximum allowed grace period is 90 minutes (PT90M).')
param gracePeriod string = 'PT30M'

@description('Optional. Specifies the computer name prefix for all of the virtual machines in the scale set.')
@minLength(1)
@maxLength(15)
param vmNamePrefix string = 'vmssvm'

@description('Optional. Specifies the orchestration mode for the virtual machine scale set.')
@allowed([
  'Flexible'
  'Uniform'
])
param orchestrationMode string = 'Flexible'

@description('Optional. Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.')
param provisionVMAgent bool = true

@description('Optional. Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.')
param enableAutomaticUpdates bool = true

@description('Optional. VM guest patching orchestration mode. \'AutomaticByOS\' & \'Manual\' are for Windows only, \'ImageDefault\' for Linux only. Refer to \'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching\'.')
@allowed([
  'AutomaticByPlatform'
  'AutomaticByOS'
  'Manual'
  'ImageDefault'
  ''
])
param patchMode string = 'AutomaticByPlatform'

@description('Optional. Enables customer to schedule patching without accidental upgrades.')
param bypassPlatformSafetyChecksOnUserSchedule bool = true

@description('Optional. Specifies the reboot setting for all AutomaticByPlatform patch installation operations.')
@allowed([
  'Always'
  'IfRequired'
  'Never'
  'Unknown'
])
param rebootSetting string = 'IfRequired'

@description('Optional. VM guest patching assessment mode. Set it to \'AutomaticByPlatform\' to enable automatically check for updates every 24 hours.')
@allowed([
  'AutomaticByPlatform'
  'ImageDefault'
])
param patchAssessmentMode string = 'ImageDefault'

@description('Optional. Specifies the time zone of the virtual machine. e.g. \'Pacific Standard Time\'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`.')
param timeZone string?

@description('Optional. Specifies additional base-64 encoded XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. - AdditionalUnattendContent object.')
param additionalUnattendContent resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-07-01'>.properties.virtualMachineProfile.osProfile.windowsConfiguration.additionalUnattendContent?

@description('Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.')
param winRM resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-07-01'>.properties.virtualMachineProfile.osProfile.windowsConfiguration.winRM?

@description('Optional. Specifies whether password authentication should be disabled.')
#disable-next-line secure-secrets-in-params // Not a secret
param disablePasswordAuthentication bool = false

@description('Optional. The list of SSH public keys used to authenticate with linux based VMs.')
param publicKeys resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-07-01'>.properties.virtualMachineProfile.osProfile.linuxConfiguration.ssh.publicKeys?

@description('Optional. Specifies set of certificates that should be installed onto the virtual machines in the scale set.')
#disable-next-line secure-secrets-in-params // Not a secret
param secrets resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-07-01'>.properties.virtualMachineProfile.osProfile.secrets = []

@description('Optional. Specifies Scheduled Event related configurations.')
param scheduledEventsProfile resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-07-01'>.properties.virtualMachineProfile.scheduledEventsProfile = {}

@description('Optional. Specifies whether the Virtual Machine Scale Set should be overprovisioned.')
param overprovision bool = false

@description('Optional. When Overprovision is enabled, extensions are launched only on the requested number of VMs which are finally kept. This property will hence ensure that the extensions do not run on the extra overprovisioned VMs.')
param doNotRunExtensionsOnOverprovisionedVMs bool = false

@description('Optional. Whether to force strictly even Virtual Machine distribution cross x-zones in case there is zone outage.')
param zoneBalance bool = false

@description('Optional. When true this limits the scale set to a single placement group, of max size 100 virtual machines. NOTE: If singlePlacementGroup is true, it may be modified to false. However, if singlePlacementGroup is false, it may not be modified to true.')
param singlePlacementGroup bool = false

@description('Optional. Specifies the scale-in policy that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled-in.')
param scaleInPolicy resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-07-01'>.properties.scaleInPolicy = {
  rules: [
    'Default'
  ]
}

@description('Required. The SKU size of the VMs.')
param skuName string

@description('Optional. The initial instance count of scale set VMs.')
param skuCapacity int = 1

@description('Optional. The virtual machine scale set zones. NOTE: Availability zones can only be set when you create the scale set.')
@allowed([
  1
  2
  3
])
param availabilityZones int[] = [1, 2, 3]

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Compute/virtualMachineScaleSets@2024-07-01'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The chosen OS type.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

var networkInterfaceConfigurations = [
  for (nicConfiguration, index) in nicConfigurations: {
    name: nicConfiguration.?name ?? '${name}${nicConfiguration.?nicSuffix}configuration-${index}'
    properties: {
      primary: (index == 0) ? true : any(null)
      enableAcceleratedNetworking: nicConfiguration.?enableAcceleratedNetworking ?? true
      networkSecurityGroup: contains(nicConfiguration, 'networkSecurityGroupResourceId')
        ? {
            id: nicConfiguration.networkSecurityGroupResourceId!
          }
        : null
      ipConfigurations: nicConfiguration.ipConfigurations
    }
  }
]

var linuxConfiguration = {
  disablePasswordAuthentication: disablePasswordAuthentication
  ssh: {
    publicKeys: publicKeys
  }
  provisionVMAgent: provisionVMAgent
  patchSettings: (provisionVMAgent && (patchMode =~ 'AutomaticByPlatform' || patchMode =~ 'ImageDefault'))
    ? {
        patchMode: patchMode
        assessmentMode: patchAssessmentMode
        automaticByPlatformSettings: (patchMode =~ 'AutomaticByPlatform')
          ? {
              bypassPlatformSafetyChecksOnUserSchedule: bypassPlatformSafetyChecksOnUserSchedule
              rebootSetting: rebootSetting
            }
          : null
      }
    : null
}

var windowsConfiguration = {
  provisionVMAgent: provisionVMAgent
  enableAutomaticUpdates: enableAutomaticUpdates
  patchSettings: (provisionVMAgent && (patchMode =~ 'AutomaticByPlatform' || patchMode =~ 'AutomaticByOS' || patchMode =~ 'Manual'))
    ? {
        patchMode: patchMode
        assessmentMode: patchAssessmentMode
        automaticByPlatformSettings: (patchMode =~ 'AutomaticByPlatform')
          ? {
              bypassPlatformSafetyChecksOnUserSchedule: bypassPlatformSafetyChecksOnUserSchedule
              rebootSetting: rebootSetting
            }
          : null
      }
    : null
  timeZone: timeZone
  additionalUnattendContent: additionalUnattendContent
  winRM: winRM
}

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Data Operator for Managed Disks': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '959f8984-c045-4866-89c7-12bf9737be2e'
  )
  'Desktop Virtualization Power On Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '489581de-a3bd-480d-9518-53dea7416b33'
  )
  'Desktop Virtualization Power On Off Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '40c5ff49-9181-41f8-ae61-143b0e78555e'
  )
  'Desktop Virtualization Virtual Machine Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a959dbd1-f747-45e3-8ba6-dd80f235f97c'
  )
  'DevTest Labs User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '76283e04-6283-4c54-8f91-bcf1374a3c64'
  )
  'Disk Backup Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3e5e47e6-65f7-47ef-90b5-e5dd4d455f24'
  )
  'Disk Pool Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '60fc6e62-5479-42d4-8bf4-67625fcc2840'
  )
  'Disk Restore Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b50d9833-a0cb-478e-945f-707fcc997c13'
  )
  'Disk Snapshot Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7efff54f-a5b4-42b5-a1c5-5411624893ce'
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
  'Virtual Machine Administrator Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1c0163c0-47e6-4577-8991-ea5c82e286e4'
  )
  'Virtual Machine Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  )
  'Virtual Machine User Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fb879df8-f326-4884-b1cf-06f3ad86be52'
  )
  'VM Scanner Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd24ecba3-c1f4-40fa-a7bb-4588a071e8fd'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
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

resource vmss 'Microsoft.Compute/virtualMachineScaleSets@2024-11-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  zones: map(availabilityZones, zone => '${zone}')
  properties: {
    orchestrationMode: orchestrationMode
    proximityPlacementGroup: !empty(proximityPlacementGroupResourceId)
      ? {
          id: proximityPlacementGroupResourceId
        }
      : null
    upgradePolicy: {
      mode: upgradePolicyMode
      rollingUpgradePolicy: upgradePolicyMode == 'Rolling'
        ? {
            enableCrossZoneUpgrade: enableCrossZoneUpgrade
            maxBatchInstancePercent: maxBatchInstancePercent
            maxSurge: maxSurge
            maxUnhealthyInstancePercent: maxUnhealthyInstancePercent
            maxUnhealthyUpgradedInstancePercent: maxUnhealthyUpgradedInstancePercent
            pauseTimeBetweenBatches: pauseTimeBetweenBatches
            prioritizeUnhealthyInstances: prioritizeUnhealthyInstances
            rollbackFailedInstancesOnPolicyBreach: rollbackFailedInstancesOnPolicyBreach
          }
        : null
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
        adminPassword: adminPassword
        customData: !empty(customData) ? base64(customData) : null
        windowsConfiguration: osType == 'Windows' ? windowsConfiguration : null
        linuxConfiguration: osType == 'Linux' ? linuxConfiguration : null
        secrets: secrets
      }
      securityProfile: {
        encryptionAtHost: encryptionAtHost ? encryptionAtHost : null
        securityType: securityType
        uefiSettings: securityType == 'TrustedLaunch'
          ? {
              secureBootEnabled: secureBootEnabled
              vTpmEnabled: vTpmEnabled
            }
          : null
      }
      storageProfile: {
        imageReference: imageReference
        osDisk: osDisk
        dataDisks: dataDisks
      }
      networkProfile: union(
        orchestrationMode == 'Flexible' ? { networkApiVersion: '2020-11-01' } : {},
        { networkInterfaceConfigurations: networkInterfaceConfigurations }
      )
      diagnosticsProfile: {
        bootDiagnostics: {
          enabled: !empty(bootDiagnosticStorageAccountName) ? true : bootDiagnosticEnabled
          storageUri: !empty(bootDiagnosticStorageAccountName)
            ? 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}'
            : null
        }
      }
      // Health-Config must be deployed using the property as you can otherwise not set the VMSS's `patchMode` to `AutomaticByPlatform`
      extensionProfile: extensionHealthConfig.?enabled ?? false
        ? {
            extensions: [
              {
                name: 'HealthExtension'
                properties: {
                  publisher: 'Microsoft.ManagedServices'
                  type: (osType == 'Windows' ? 'ApplicationHealthWindows' : 'ApplicationHealthLinux')
                  typeHandlerVersion: extensionHealthConfig.?typeHandlerVersion ?? '2.0'
                  autoUpgradeMinorVersion: extensionHealthConfig.?autoUpgradeMinorVersion ?? false
                  settings: {
                    protocol: extensionHealthConfig.?protocol ?? 'http'
                    port: extensionHealthConfig.?port ?? 80
                    requestPath: extensionHealthConfig.?requestPath ?? ((contains(extensionHealthConfig, 'protocol') && extensionHealthConfig.?protocol != 'tcp')
                      ? '/'
                      : '')
                    intervalInSeconds: extensionHealthConfig.?intervalInSeconds ?? 5
                    numberOfProbes: extensionHealthConfig.?numberOfProbes ?? 1
                    gracePeriod: extensionHealthConfig.?gracePeriod ?? ((extensionHealthConfig.?intervalInSeconds ?? 5) * (extensionHealthConfig.?numberOfProbes ?? 1))
                  }
                  provisionAfterExtensions: extensionHealthConfig.?provisionAfterExtensions
                }
              }
            ]
          }
        : null
      licenseType: licenseType
      priority: vmPriority
      evictionPolicy: enableEvictionPolicy ? 'Deallocate' : null
      billingProfile: !empty(vmPriority) && null != maxPriceForLowPriorityVm
        ? {
            maxPrice: maxPriceForLowPriorityVm
          }
        : null
      scheduledEventsProfile: scheduledEventsProfile
    }
    overprovision: (orchestrationMode == 'Uniform') ? overprovision : null
    doNotRunExtensionsOnOverprovisionedVMs: (orchestrationMode == 'Uniform')
      ? doNotRunExtensionsOnOverprovisionedVMs
      : null
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
  plan: plan
}

module vmss_domainJoinExtension 'extension/main.bicep' = if (extensionDomainJoinConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-DomainJoin'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'DomainJoin'
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: extensionDomainJoinConfig.?typeHandlerVersion ?? '1.3'
    autoUpgradeMinorVersion: extensionDomainJoinConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionDomainJoinConfig.?enableAutomaticUpgrade ?? false
    settings: extensionDomainJoinConfig.settings
    protectedSettings: {
      Password: extensionDomainJoinPassword
    }
    provisionAfterExtensions: extensionDomainJoinConfig.?provisionAfterExtensions
  }
}

module vmss_microsoftAntiMalwareExtension 'extension/main.bicep' = if (extensionAntiMalwareConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-MicrosoftAntiMalware'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'MicrosoftAntiMalware'
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: extensionAntiMalwareConfig.?typeHandlerVersion ?? '1.3'
    autoUpgradeMinorVersion: extensionAntiMalwareConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionAntiMalwareConfig.?enableAutomaticUpgrade ?? false
    settings: extensionAntiMalwareConfig.settings
    provisionAfterExtensions: extensionAntiMalwareConfig.?provisionAfterExtensions
  }
  dependsOn: [
    vmss_domainJoinExtension
  ]
}

resource vmss_logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = if (!empty(monitoringWorkspaceResourceId)) {
  name: last(split((!empty(monitoringWorkspaceResourceId) ? monitoringWorkspaceResourceId : 'law'), '/'))!
  scope: az.resourceGroup(
    split((!empty(monitoringWorkspaceResourceId) ? monitoringWorkspaceResourceId : '//'), '/')[2],
    split((!empty(monitoringWorkspaceResourceId) ? monitoringWorkspaceResourceId : '////'), '/')[4]
  )
}

module vmss_azureMonitorAgentExtension 'extension/main.bicep' = if (extensionMonitoringAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VMSS-AzureMonitorAgent'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: 'AzureMonitorAgent'
    publisher: 'Microsoft.Azure.Monitor'
    type: osType == 'Windows' ? 'AzureMonitorWindowsAgent' : 'AzureMonitorLinuxAgent'
    typeHandlerVersion: extensionMonitoringAgentConfig.?typeHandlerVersion != null
      ? extensionMonitoringAgentConfig.typeHandlerVersion
      : (osType == 'Windows' ? '1.22' : '1.29')
    autoUpgradeMinorVersion: extensionMonitoringAgentConfig.autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionMonitoringAgentConfig.?enableAutomaticUpgrade ?? false
    settings: {
      workspaceId: !empty(monitoringWorkspaceResourceId) ? vmss_logAnalyticsWorkspace!.properties.customerId : ''
      GCS_AUTO_CONFIG: osType == 'Linux' ? true : null
    }
    protectedSettings: {
      workspaceKey: !empty(monitoringWorkspaceResourceId) ? vmss_logAnalyticsWorkspace!.listKeys().primarySharedKey : ''
    }
    provisionAfterExtensions: extensionMonitoringAgentConfig.?provisionAfterExtensions
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
    typeHandlerVersion: extensionDependencyAgentConfig.?typeHandlerVersion ?? '9.5'
    autoUpgradeMinorVersion: extensionDependencyAgentConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionDependencyAgentConfig.?enableAutomaticUpgrade ?? true
    provisionAfterExtensions: extensionDependencyAgentConfig.?provisionAfterExtensions
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
    typeHandlerVersion: extensionNetworkWatcherAgentConfig.?typeHandlerVersion ?? '1.4'
    autoUpgradeMinorVersion: extensionNetworkWatcherAgentConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionNetworkWatcherAgentConfig.?enableAutomaticUpgrade ?? false
    provisionAfterExtensions: extensionNetworkWatcherAgentConfig.?provisionAfterExtensions
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
    typeHandlerVersion: extensionDSCConfig.?typeHandlerVersion ?? '2.77'
    autoUpgradeMinorVersion: extensionDSCConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionDSCConfig.?enableAutomaticUpgrade ?? false
    settings: extensionDSCConfig.?settings ?? {}
    protectedSettings: extensionDSCConfig.?protectedSettings ?? {}
    provisionAfterExtensions: extensionDSCConfig.?provisionAfterExtensions
  }
  dependsOn: [
    vmss_networkWatcherAgentExtension
  ]
}

resource cseIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(extensionCustomScriptConfig.?protectedSettings.?managedIdentityResourceId)) {
  name: last(split(extensionCustomScriptConfig!.protectedSettings!.managedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(extensionCustomScriptConfig!.protectedSettings!.managedIdentityResourceId!, '/')[2],
    split(extensionCustomScriptConfig!.protectedSettings!.managedIdentityResourceId!, '/')[4]
  )
}

module vmss_customScriptExtension 'extension/main.bicep' = if (!empty(extensionCustomScriptConfig)) {
  name: '${uniqueString(deployment().name, location)}-VMSS-CustomScriptExtension'
  params: {
    virtualMachineScaleSetName: vmss.name
    name: extensionCustomScriptConfig.?name ?? 'CustomScriptExtension'
    publisher: osType == 'Windows' ? 'Microsoft.Compute' : 'Microsoft.Azure.Extensions'
    type: osType == 'Windows' ? 'CustomScriptExtension' : 'CustomScript'
    typeHandlerVersion: extensionCustomScriptConfig.?typeHandlerVersion ?? (osType == 'Windows' ? '1.10' : '2.1')
    autoUpgradeMinorVersion: extensionCustomScriptConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionCustomScriptConfig.?enableAutomaticUpgrade ?? false
    forceUpdateTag: extensionCustomScriptConfig.?forceUpdateTag
    provisionAfterExtensions: extensionCustomScriptConfig.?provisionAfterExtensions
    supressFailures: extensionCustomScriptConfig.?supressFailures ?? false
    protectedSettingsFromKeyVault: extensionCustomScriptConfig.?protectedSettingsFromKeyVault
    settings: {
      ...(!empty(extensionCustomScriptConfig!.?settings.?commandToExecute)
        ? { commandToExecute: extensionCustomScriptConfig!.?settings.?commandToExecute }
        : {})
      ...(!empty(extensionCustomScriptConfig!.?settings.?fileUris)
        ? { fileUris: extensionCustomScriptConfig!.?settings.fileUris }
        : {})
    }
    protectedSettings: {
      ...(!empty(extensionCustomScriptConfig!.?protectedSettings.?commandToExecute)
        ? { commandToExecute: extensionCustomScriptConfig!.protectedSettings!.?commandToExecute }
        : {})
      ...(!empty(extensionCustomScriptConfig!.?protectedSettings.?storageAccountName)
        ? { storageAccountName: extensionCustomScriptConfig!.protectedSettings!.storageAccountName! }
        : {})
      ...(!empty(extensionCustomScriptConfig!.?protectedSettings.?storageAccountKey)
        ? { storageAccountKey: extensionCustomScriptConfig!.protectedSettings!.storageAccountKey! }
        : {})
      ...(!empty(extensionCustomScriptConfig!.?protectedSettings.?fileUris)
        ? { fileUris: extensionCustomScriptConfig!.protectedSettings!.fileUris! }
        : {})
      ...(extensionCustomScriptConfig!.?protectedSettings.?managedIdentityResourceId != null
        ? {
            managedIdentity: !empty(extensionCustomScriptConfig!.protectedSettings!.?managedIdentityResourceId)
              ? {
                  clientId: cseIdentity!.properties.clientId // Uses user-assigned
                }
              : {} // Uses system-assigned
          }
        : {})
    }
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
    typeHandlerVersion: extensionAzureDiskEncryptionConfig.?typeHandlerVersion ?? (osType == 'Windows' ? '2.2' : '1.1')
    autoUpgradeMinorVersion: extensionAzureDiskEncryptionConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionAzureDiskEncryptionConfig.?enableAutomaticUpgrade ?? false
    forceUpdateTag: extensionAzureDiskEncryptionConfig.?forceUpdateTag ?? '1.0'
    settings: extensionAzureDiskEncryptionConfig.settings
    provisionAfterExtensions: extensionAzureDiskEncryptionConfig.?provisionAfterExtensions
  }
  dependsOn: [
    vmss_customScriptExtension
  ]
}

resource vmss_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: vmss
}

resource vmss_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: vmss
  }
]

resource vmss_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(vmss.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: vmss
  }
]

@description('The resource ID of the virtual machine scale set.')
output resourceId string = vmss.id

@description('The resource group of the virtual machine scale set.')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual machine scale set.')
output name string = vmss.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = vmss.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = vmss.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of the health config extension.')
type extensionHealthConfigType = {
  @description('Required. Enable or disable the Health Config extension.')
  enabled: bool

  @description('Optional. Specifies the version of the script handler. Defaults to `2.0`.')
  typeHandlerVersion: string?

  @description('Optional. Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. Defaults to `false`.')
  autoUpgradeMinorVersion: bool?

  @description('Optional. Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. Defaults to `true`.')
  enableAutomaticUpgrade: bool?

  @description('Optional. The protocol to connect with. Defaults to `http`.')
  protocol: ('http' | 'https' | 'tcp')?

  @description('Conditional. The port to connect to. Defaults to `80`. Required if `protocol` is `tcp`.')
  port: int?

  @description('Optional. The path of the request. Not allowed if `protocol` is `tcp`.')
  requestPath: string?

  @description('Optional. This is the interval between each health probe. For example, if intervalInSeconds == 5, a probe will be sent to the local application endpoint once every 5 seconds. Defaults to `5`.')
  @minValue(5)
  @maxValue(60)
  intervalInSeconds: int?

  @description('Optional. This is the number of consecutive probes required for the health status to change. For example, if numberOfProbles == 3, you will need 3 consecutive "Healthy" signals to change the health status from "Unhealthy" into "Healthy" state. The same requirement applies to change health status into "Unhealthy" state. Defaults to `1`.')
  @minValue(1)
  @maxValue(24)
  numberOfProbes: int?

  @description('Optional. The grace period for newly created instances. Defaults to `intervalInSeconds` x `numberOfProbes`.')
  @maxValue(14400)
  gracePeriod: int?

  @description('Optional. Collection of extension names after which this extension needs to be provisioned.')
  provisionAfterExtensions: string[]?
}

@export()
@description('The type of a NIC configuration.')
type nicConfigurationType = {
  @description('Optional. The name of the NIC configuration. If not provided, a name is generated using the `nicSuffic` and an incremental counter.')
  name: string?

  @description('Optional. The suffix to add to each NIC configuration name if no `name` was provided.')
  nicSuffix: string?

  @description('Optional. Specifies whether the network interface is accelerated networking-enabled. Defaults to `true`.')
  enableAcceleratedNetworking: bool?

  @description('Required. Specifies the IP configurations of the network interface.')
  ipConfigurations: array

  @description('Optional. The resource ID of a network security group to associate with the NIC.')
  networkSecurityGroupResourceId: string?
}

@export()
@description('The type of a \'CustomScriptExtension\' extension.')
type extensionCustomScriptConfigType = {
  @description('Optional. The name of the virtual machine extension. Defaults to `CustomScriptExtension`.')
  name: string?

  @description('Optional. Specifies the version of the script handler. Defaults to `1.10` for Windows and `2.1` for Linux.')
  typeHandlerVersion: string?

  @description('Optional. Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. Defaults to `true`.')
  autoUpgradeMinorVersion: bool?

  @description('Optional. How the extension handler should be forced to update even if the extension configuration has not changed.')
  forceUpdateTag: string?

  @description('Optional. The configuration of the custom script extension. Note: You can provide any property either in the `settings` or `protectedSettings` but not both. If your property contains secrets, use `protectedSettings`.')
  settings: {
    @description('Conditional. The entry point script to run. If the command contains any credentials, use the same property of the `protectedSettings` instead. Required if `protectedSettings.commandToExecute` is not provided.')
    commandToExecute: string?

    @description('Optional. URLs for files to be downloaded. If URLs are sensitive, for example, if they contain keys, this field should be specified in `protectedSettings`.')
    fileUris: string[]?
  }?

  @description('Optional. The configuration of the custom script extension. Note: You can provide any property either in the `settings` or `protectedSettings` but not both. If your property contains secrets, use `protectedSettings`.')
  @secure()
  protectedSettings: {
    @description('Conditional. The entry point script to run. Use this property if your command contains secrets such as passwords or if your file URIs are sensitive. Required if `settings.commandToExecute` is not provided.')
    commandToExecute: string?

    @description('Optional. The name of storage account. If you specify storage credentials, all fileUris values must be URLs for Azure blobs..')
    storageAccountName: string?

    @description('Optional. The access key of the storage account.')
    storageAccountKey: string?

    @description('Optional. The managed identity for downloading files. Must not be used in conjunction with the `storageAccountName` or `storageAccountKey` property. If you want to use the VM\'s system assigned identity, set the `value` to an empty string.')
    managedIdentityResourceId: string?

    @description('Optional. URLs for files to be downloaded.')
    fileUris: string[]?
  }?

  @description('Optional. Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). Defaults to `false`.')
  supressFailures: bool?

  @description('Optional. Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. Defaults to `false`.')
  enableAutomaticUpgrade: bool?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Compute/virtualMachines/extensions@2024-11-01'>.tags?

  @description('Optional. The extensions protected settings that are passed by reference, and consumed from key vault.')
  protectedSettingsFromKeyVault: resourceInput<'Microsoft.Compute/virtualMachines/extensions@2024-11-01'>.properties.protectedSettingsFromKeyVault?

  @description('Optional. Collection of extension names after which this extension needs to be provisioned.')
  provisionAfterExtensions: resourceInput<'Microsoft.Compute/virtualMachines/extensions@2024-11-01'>.properties.provisionAfterExtensions?
}
