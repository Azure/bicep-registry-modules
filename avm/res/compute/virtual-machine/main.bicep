metadata name = 'Virtual Machines'
metadata description = 'This module deploys a Virtual Machine with one or multiple NICs and optionally one or multiple public IPs.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.')
param name string

@description('Optional. Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name.')
param computerName string = name

@description('Required. Specifies the size for the VMs.')
param vmSize string

@description('Optional. This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
param encryptionAtHost bool = true

@description('Optional. Specifies the SecurityType of the virtual machine. It is set as TrustedLaunch to enable UefiSettings.')
param securityType string = ''

@description('Optional. Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param secureBootEnabled bool = false

@description('Optional. Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.')
param vTpmEnabled bool = false

@description('Required. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
param imageReference object

@description('Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.')
param plan object = {}

@description('Required. Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
param osDisk object

@description('Optional. Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
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

@description('Optional. Specifies set of certificates that should be installed onto the virtual machine.')
param certificatesToBeInstalled array = []

@description('Optional. Specifies the priority for the virtual machine.')
@allowed([
  'Regular'
  'Low'
  'Spot'
])
param priority string = 'Regular'

@description('Optional. Specifies the eviction policy for the low priority virtual machine. Will result in \'Deallocate\' eviction policy.')
param enableEvictionPolicy bool = false

@description('Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars.')
param maxPriceForLowPriorityVm string = ''

@description('Optional. Specifies resource ID about the dedicated host that the virtual machine resides in.')
param dedicatedHostId string = ''

@description('Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system.')
@allowed([
  'Windows_Client'
  'Windows_Server'
  ''
])
param licenseType string = ''

@description('Optional. The list of SSH public keys used to authenticate with linux based VMs.')
param publicKeys array = []

@description('Optional. The managed identity definition for this resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True".')
param managedIdentities managedIdentitiesType

@description('Optional. Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled.')
param bootDiagnostics bool = false

@description('Optional. Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided.')
param bootDiagnosticStorageAccountName string = ''

@description('Optional. Storage account boot diagnostic base URI.')
param bootDiagnosticStorageAccountUri string = '.blob.${environment().suffixes.storage}/'

@description('Optional. Resource ID of a proximity placement group.')
param proximityPlacementGroupResourceId string = ''

@description('Optional. Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set.')
param availabilitySetResourceId string = ''

@description('Optional. If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set.')
@allowed([
  0
  1
  2
  3
])
param availabilityZone int = 0

// External resources
@description('Required. Configures NICs and PIPs.')
param nicConfigurations array

@description('Optional. Recovery service vault name to add VMs to backup.')
param backupVaultName string = ''

@description('Optional. Resource group of the backup recovery service vault. If not provided the current resource group name is considered by default.')
param backupVaultResourceGroup string = resourceGroup().name

@description('Optional. Backup policy the VMs should be using for backup. If not provided, it will use the DefaultPolicy from the backup recovery service vault.')
param backupPolicyName string = 'DefaultPolicy'

// Child resources
@description('Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.')
param allowExtensionOperations bool = true

@description('Optional. Required if name is specified. Password of the user specified in user parameter.')
@secure()
param extensionDomainJoinPassword string = ''

@description('Optional. The configuration for the [Domain Join] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionDomainJoinConfig object = {
  enabled: false
}

@description('Optional. The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed.')
param extensionAadJoinConfig object = {
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

@description('Optional. Any object that contains the extension specific protected settings.')
@secure()
param extensionCustomScriptProtectedSetting object = {}

// Shared parameters
@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Generated. Do not provide a value! This date value is used to generate a registration token.')
param baseTime string = utcNow('u')

@description('Optional. SAS token validity length to use to download files from storage accounts. Usage: \'PT8H\' - valid for 8 hours; \'P5D\' - valid for 5 days; \'P1Y\' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.')
param sasTokenValidityLength string = 'PT8H'

@description('Required. The chosen OS type.')
@allowed([
  'Windows'
  'Linux'
])
param osType string

@description('Optional. Specifies whether password authentication should be disabled.')
#disable-next-line secure-secrets-in-params // Not a secret
param disablePasswordAuthentication bool = false

@description('Optional. Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.')
param provisionVMAgent bool = true

@description('Optional. Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. When patchMode is set to Manual, this parameter must be set to false. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.')
param enableAutomaticUpdates bool = true

@description('Optional. VM guest patching orchestration mode. \'AutomaticByOS\' & \'Manual\' are for Windows only, \'ImageDefault\' for Linux only. Refer to \'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching\'.')
@allowed([
  'AutomaticByPlatform'
  'AutomaticByOS'
  'Manual'
  'ImageDefault'
  ''
])
param patchMode string = ''

@description('Optional. VM guest patching assessment mode. Set it to \'AutomaticByPlatform\' to enable automatically check for updates every 24 hours.')
@allowed([
  'AutomaticByPlatform'
  'ImageDefault'
])
param patchAssessmentMode string = 'ImageDefault'

@description('Optional. Specifies the time zone of the virtual machine. e.g. \'Pacific Standard Time\'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`.')
param timeZone string = ''

@description('Optional. Specifies additional XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. Contents are defined by setting name, component name, and the pass in which the content is applied.')
param additionalUnattendContent array = []

@description('Optional. Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. - WinRMConfiguration object.')
param winRM array = []

@description('Required. The configuration profile of automanage.')
@allowed([
  '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesProduction'
  '/providers/Microsoft.Automanage/bestPractices/AzureBestPracticesDevTest'
  ''
])
param configurationProfile string = ''

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
  patchSettings: (provisionVMAgent && (patchMode =~ 'AutomaticByPlatform' || patchMode =~ 'ImageDefault')) ? {
    patchMode: patchMode
    assessmentMode: patchAssessmentMode
  } : null
}

var windowsConfiguration = {
  provisionVMAgent: provisionVMAgent
  enableAutomaticUpdates: enableAutomaticUpdates
  patchSettings: (provisionVMAgent && (patchMode =~ 'AutomaticByPlatform' || patchMode =~ 'AutomaticByOS' || patchMode =~ 'Manual')) ? {
    patchMode: patchMode
    assessmentMode: patchAssessmentMode
  } : null
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

// If AADJoin Extension is enabled then we automatically enable SystemAssigned (required by AADJoin), otherwise we follow the usual logic.
var identity = !empty(managedIdentities) ? {
  type: (extensionAadJoinConfig.enabled ? true : (managedIdentities.?systemAssigned ?? false)) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

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
  name: '46d3xbcp.res.compute-virtualmachine.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module vm_nic 'modules/nic-configuration.bicep' = [for (nicConfiguration, index) in nicConfigurations: {
  name: '${uniqueString(deployment().name, location)}-VM-Nic-${index}'
  params: {
    networkInterfaceName: '${name}${nicConfiguration.nicSuffix}'
    virtualMachineName: name
    location: location
    enableIPForwarding: contains(nicConfiguration, 'enableIPForwarding') ? (!empty(nicConfiguration.enableIPForwarding) ? nicConfiguration.enableIPForwarding : false) : false
    enableAcceleratedNetworking: contains(nicConfiguration, 'enableAcceleratedNetworking') ? nicConfiguration.enableAcceleratedNetworking : true
    dnsServers: contains(nicConfiguration, 'dnsServers') ? (!empty(nicConfiguration.dnsServers) ? nicConfiguration.dnsServers : []) : []
    networkSecurityGroupResourceId: contains(nicConfiguration, 'networkSecurityGroupResourceId') ? nicConfiguration.networkSecurityGroupResourceId : ''
    ipConfigurations: nicConfiguration.ipConfigurations
    lock: nicConfiguration.?lock ?? lock
    tags: nicConfiguration.?tags ?? tags
    diagnosticSettings: nicConfiguration.?diagnosticSettings
    roleAssignments: nicConfiguration.?roleAssignments
    enableTelemetry: nicConfiguration.?enableTelemetry ?? enableTelemetry
  }
}]

resource vm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  zones: availabilityZone != 0 ? array(availabilityZone) : null
  plan: !empty(plan) ? plan : null
  properties: {
    hardwareProfile: {
      vmSize: vmSize
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
        name: '${name}-disk-os-01'
        createOption: contains(osDisk, 'createOption') ? osDisk.createOption : 'FromImage'
        deleteOption: contains(osDisk, 'deleteOption') ? osDisk.deleteOption : 'Delete'
        diskSizeGB: osDisk.diskSizeGB
        caching: contains(osDisk, 'caching') ? osDisk.caching : 'ReadOnly'
        managedDisk: {
          storageAccountType: osDisk.managedDisk.storageAccountType
          diskEncryptionSet: contains(osDisk.managedDisk, 'diskEncryptionSet') ? {
            id: osDisk.managedDisk.diskEncryptionSet.id
          } : null
        }
      }
      dataDisks: [for (dataDisk, index) in dataDisks: {
        lun: index
        name: '${name}-disk-data-${padLeft((index + 1), 2, '0')}'
        diskSizeGB: dataDisk.diskSizeGB
        createOption: contains(dataDisk, 'createOption') ? dataDisk.createOption : 'Empty'
        deleteOption: contains(dataDisk, 'deleteOption') ? dataDisk.deleteOption : 'Delete'
        caching: contains(dataDisk, 'caching') ? dataDisk.caching : 'ReadOnly'
        managedDisk: {
          storageAccountType: dataDisk.managedDisk.storageAccountType
          diskEncryptionSet: contains(dataDisk.managedDisk, 'diskEncryptionSet') ? {
            id: dataDisk.managedDisk.diskEncryptionSet.id
          } : null
        }
      }]
    }
    additionalCapabilities: {
      ultraSSDEnabled: ultraSSDEnabled
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: !empty(customData) ? base64(customData) : null
      windowsConfiguration: osType == 'Windows' ? windowsConfiguration : null
      linuxConfiguration: osType == 'Linux' ? linuxConfiguration : null
      secrets: certificatesToBeInstalled
      allowExtensionOperations: allowExtensionOperations
    }
    networkProfile: {
      networkInterfaces: [for (nicConfiguration, index) in nicConfigurations: {
        properties: {
          deleteOption: contains(nicConfiguration, 'deleteOption') ? nicConfiguration.deleteOption : 'Delete'
          primary: index == 0 ? true : false
        }
        #disable-next-line use-resource-id-functions // It's a reference from inside a loop which makes resolving it using a resource reference particulary difficult.
        id: az.resourceId('Microsoft.Network/networkInterfaces', '${name}${nicConfiguration.nicSuffix}')
      }]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: !empty(bootDiagnosticStorageAccountName) ? true : bootDiagnostics
        storageUri: !empty(bootDiagnosticStorageAccountName) ? 'https://${bootDiagnosticStorageAccountName}${bootDiagnosticStorageAccountUri}' : null
      }
    }
    availabilitySet: !empty(availabilitySetResourceId) ? {
      id: availabilitySetResourceId
    } : null
    proximityPlacementGroup: !empty(proximityPlacementGroupResourceId) ? {
      id: proximityPlacementGroupResourceId
    } : null
    priority: priority
    evictionPolicy: enableEvictionPolicy ? 'Deallocate' : null
    billingProfile: !empty(priority) && !empty(maxPriceForLowPriorityVm) ? {
      maxPrice: maxPriceForLowPriorityVm
    } : null
    host: !empty(dedicatedHostId) ? {
      id: dedicatedHostId
    } : null
    licenseType: !empty(licenseType) ? licenseType : null
  }
  dependsOn: [
    vm_nic
  ]
}

resource vm_configurationProfileAssignment 'Microsoft.Automanage/configurationProfileAssignments@2021-04-30-preview' = if (!empty(configurationProfile)) {
  name: 'default'
  properties: {
    configurationProfile: configurationProfile
  }
  scope: vm
}

module vm_aadJoinExtension 'extension/main.bicep' = if (extensionAadJoinConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-AADLogin'
  params: {
    virtualMachineName: vm.name
    name: 'AADLogin'
    location: location
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: osType == 'Windows' ? 'AADLoginForWindows' : 'AADSSHLoginforLinux'
    typeHandlerVersion: contains(extensionAadJoinConfig, 'typeHandlerVersion') ? extensionAadJoinConfig.typeHandlerVersion : '1.0'
    autoUpgradeMinorVersion: contains(extensionAadJoinConfig, 'autoUpgradeMinorVersion') ? extensionAadJoinConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionAadJoinConfig, 'enableAutomaticUpgrade') ? extensionAadJoinConfig.enableAutomaticUpgrade : false
    settings: contains(extensionAadJoinConfig, 'settings') ? extensionAadJoinConfig.settings : {}
    tags: extensionAadJoinConfig.?tags ?? tags
  }
}

module vm_domainJoinExtension 'extension/main.bicep' = if (extensionDomainJoinConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-DomainJoin'
  params: {
    virtualMachineName: vm.name
    name: 'DomainJoin'
    location: location
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: contains(extensionDomainJoinConfig, 'typeHandlerVersion') ? extensionDomainJoinConfig.typeHandlerVersion : '1.3'
    autoUpgradeMinorVersion: contains(extensionDomainJoinConfig, 'autoUpgradeMinorVersion') ? extensionDomainJoinConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDomainJoinConfig, 'enableAutomaticUpgrade') ? extensionDomainJoinConfig.enableAutomaticUpgrade : false
    settings: extensionDomainJoinConfig.settings
    tags: extensionDomainJoinConfig.?tags ?? tags
    protectedSettings: {
      Password: extensionDomainJoinPassword
    }
  }
}

module vm_microsoftAntiMalwareExtension 'extension/main.bicep' = if (extensionAntiMalwareConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-MicrosoftAntiMalware'
  params: {
    virtualMachineName: vm.name
    name: 'MicrosoftAntiMalware'
    location: location
    publisher: 'Microsoft.Azure.Security'
    type: 'IaaSAntimalware'
    typeHandlerVersion: contains(extensionAntiMalwareConfig, 'typeHandlerVersion') ? extensionAntiMalwareConfig.typeHandlerVersion : '1.3'
    autoUpgradeMinorVersion: contains(extensionAntiMalwareConfig, 'autoUpgradeMinorVersion') ? extensionAntiMalwareConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionAntiMalwareConfig, 'enableAutomaticUpgrade') ? extensionAntiMalwareConfig.enableAutomaticUpgrade : false
    settings: extensionAntiMalwareConfig.settings
    tags: extensionAntiMalwareConfig.?tags ?? tags
  }
}

resource vm_logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = if (!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId)) {
  name: last(split((!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '') ? extensionMonitoringAgentConfig.monitoringWorkspaceId : 'law'), '/'))!
  scope: az.resourceGroup(split((!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '') ? extensionMonitoringAgentConfig.monitoringWorkspaceId : '//'), '/')[2], split((!empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '') ? extensionMonitoringAgentConfig.monitoringWorkspaceId : '////'), '/')[4])
}

module vm_azureMonitorAgentExtension 'extension/main.bicep' = if (extensionMonitoringAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-AzureMonitorAgent'
  params: {
    virtualMachineName: vm.name
    name: 'AzureMonitorAgent'
    location: location
    publisher: 'Microsoft.Azure.Monitor'
    type: osType == 'Windows' ? 'AzureMonitorWindowsAgent' : 'AzureMonitorLinuxAgent'
    typeHandlerVersion: extensionMonitoringAgentConfig.?typeHandlerVersion ?? (osType == 'Windows' ? '1.22' : '1.29')
    autoUpgradeMinorVersion: extensionMonitoringAgentConfig.?autoUpgradeMinorVersion ?? true
    enableAutomaticUpgrade: extensionMonitoringAgentConfig.?enableAutomaticUpgrade ?? false
    settings: {
      workspaceId: !empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '') ? vm_logAnalyticsWorkspace.properties.customerId : ''
      GCS_AUTO_CONFIG: osType == 'Linux' ? true : null
    }
    tags: extensionMonitoringAgentConfig.?tags ?? tags
    protectedSettings: {
      workspaceKey: !empty(extensionMonitoringAgentConfig.?monitoringWorkspaceId ?? '') ? vm_logAnalyticsWorkspace.listKeys().primarySharedKey : ''
    }
  }
}

module vm_dependencyAgentExtension 'extension/main.bicep' = if (extensionDependencyAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-DependencyAgent'
  params: {
    virtualMachineName: vm.name
    name: 'DependencyAgent'
    location: location
    publisher: 'Microsoft.Azure.Monitoring.DependencyAgent'
    type: osType == 'Windows' ? 'DependencyAgentWindows' : 'DependencyAgentLinux'
    typeHandlerVersion: contains(extensionDependencyAgentConfig, 'typeHandlerVersion') ? extensionDependencyAgentConfig.typeHandlerVersion : '9.5'
    autoUpgradeMinorVersion: contains(extensionDependencyAgentConfig, 'autoUpgradeMinorVersion') ? extensionDependencyAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDependencyAgentConfig, 'enableAutomaticUpgrade') ? extensionDependencyAgentConfig.enableAutomaticUpgrade : true
    tags: extensionDependencyAgentConfig.?tags ?? tags
  }
}

module vm_networkWatcherAgentExtension 'extension/main.bicep' = if (extensionNetworkWatcherAgentConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-NetworkWatcherAgent'
  params: {
    virtualMachineName: vm.name
    name: 'NetworkWatcherAgent'
    location: location
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: osType == 'Windows' ? 'NetworkWatcherAgentWindows' : 'NetworkWatcherAgentLinux'
    typeHandlerVersion: contains(extensionNetworkWatcherAgentConfig, 'typeHandlerVersion') ? extensionNetworkWatcherAgentConfig.typeHandlerVersion : '1.4'
    autoUpgradeMinorVersion: contains(extensionNetworkWatcherAgentConfig, 'autoUpgradeMinorVersion') ? extensionNetworkWatcherAgentConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionNetworkWatcherAgentConfig, 'enableAutomaticUpgrade') ? extensionNetworkWatcherAgentConfig.enableAutomaticUpgrade : false
    tags: extensionNetworkWatcherAgentConfig.?tags ?? tags
  }
}

module vm_desiredStateConfigurationExtension 'extension/main.bicep' = if (extensionDSCConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-DesiredStateConfiguration'
  params: {
    virtualMachineName: vm.name
    name: 'DesiredStateConfiguration'
    location: location
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: contains(extensionDSCConfig, 'typeHandlerVersion') ? extensionDSCConfig.typeHandlerVersion : '2.77'
    autoUpgradeMinorVersion: contains(extensionDSCConfig, 'autoUpgradeMinorVersion') ? extensionDSCConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionDSCConfig, 'enableAutomaticUpgrade') ? extensionDSCConfig.enableAutomaticUpgrade : false
    settings: contains(extensionDSCConfig, 'settings') ? extensionDSCConfig.settings : {}
    tags: extensionDSCConfig.?tags ?? tags
    protectedSettings: contains(extensionDSCConfig, 'protectedSettings') ? extensionDSCConfig.protectedSettings : {}
  }
}

module vm_customScriptExtension 'extension/main.bicep' = if (extensionCustomScriptConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-CustomScriptExtension'
  params: {
    virtualMachineName: vm.name
    name: 'CustomScriptExtension'
    location: location
    publisher: osType == 'Windows' ? 'Microsoft.Compute' : 'Microsoft.Azure.Extensions'
    type: osType == 'Windows' ? 'CustomScriptExtension' : 'CustomScript'
    typeHandlerVersion: contains(extensionCustomScriptConfig, 'typeHandlerVersion') ? extensionCustomScriptConfig.typeHandlerVersion : (osType == 'Windows' ? '1.10' : '2.1')
    autoUpgradeMinorVersion: contains(extensionCustomScriptConfig, 'autoUpgradeMinorVersion') ? extensionCustomScriptConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionCustomScriptConfig, 'enableAutomaticUpgrade') ? extensionCustomScriptConfig.enableAutomaticUpgrade : false
    settings: {
      fileUris: [for fileData in extensionCustomScriptConfig.fileData: contains(fileData, 'storageAccountId') ? '${fileData.uri}?${listAccountSas(fileData.storageAccountId, '2019-04-01', accountSasProperties).accountSasToken}' : fileData.uri]
    }
    tags: extensionCustomScriptConfig.?tags ?? tags
    protectedSettings: extensionCustomScriptProtectedSetting
  }
  dependsOn: [
    vm_desiredStateConfigurationExtension
  ]
}

module vm_azureDiskEncryptionExtension 'extension/main.bicep' = if (extensionAzureDiskEncryptionConfig.enabled) {
  name: '${uniqueString(deployment().name, location)}-VM-AzureDiskEncryption'
  params: {
    virtualMachineName: vm.name
    name: 'AzureDiskEncryption'
    location: location
    publisher: 'Microsoft.Azure.Security'
    type: osType == 'Windows' ? 'AzureDiskEncryption' : 'AzureDiskEncryptionForLinux'
    typeHandlerVersion: contains(extensionAzureDiskEncryptionConfig, 'typeHandlerVersion') ? extensionAzureDiskEncryptionConfig.typeHandlerVersion : (osType == 'Windows' ? '2.2' : '1.1')
    autoUpgradeMinorVersion: contains(extensionAzureDiskEncryptionConfig, 'autoUpgradeMinorVersion') ? extensionAzureDiskEncryptionConfig.autoUpgradeMinorVersion : true
    enableAutomaticUpgrade: contains(extensionAzureDiskEncryptionConfig, 'enableAutomaticUpgrade') ? extensionAzureDiskEncryptionConfig.enableAutomaticUpgrade : false
    forceUpdateTag: contains(extensionAzureDiskEncryptionConfig, 'forceUpdateTag') ? extensionAzureDiskEncryptionConfig.forceUpdateTag : '1.0'
    settings: extensionAzureDiskEncryptionConfig.settings
    tags: extensionAzureDiskEncryptionConfig.?tags ?? tags
  }
  dependsOn: [
    vm_customScriptExtension
    vm_azureMonitorAgentExtension
  ]
}

module vm_backup 'modules/protected-item.bicep' = if (!empty(backupVaultName)) {
  name: '${uniqueString(deployment().name, location)}-VM-Backup'
  params: {
    name: 'vm;iaasvmcontainerv2;${resourceGroup().name};${vm.name}'
    location: location
    policyId: az.resourceId('Microsoft.RecoveryServices/vaults/backupPolicies', backupVaultName, backupPolicyName)
    protectedItemType: 'Microsoft.Compute/virtualMachines'
    protectionContainerName: 'iaasvmcontainer;iaasvmcontainerv2;${resourceGroup().name};${vm.name}'
    recoveryVaultName: backupVaultName
    sourceResourceId: vm.id
  }
  scope: az.resourceGroup(backupVaultResourceGroup)
  dependsOn: [
    vm_aadJoinExtension
    vm_domainJoinExtension
    vm_azureMonitorAgentExtension
    vm_microsoftAntiMalwareExtension
    vm_networkWatcherAgentExtension
    vm_dependencyAgentExtension
    vm_desiredStateConfigurationExtension
    vm_customScriptExtension
  ]
}

resource vm_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: vm
}

resource vm_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(vm.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: vm
}]

@description('The name of the VM.')
output name string = vm.name

@description('The resource ID of the VM.')
output resourceId string = vm.id

@description('The name of the resource group the VM was created in.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = vm.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = vm.location

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
