# Virtual Machines `[Sa/ChatWithYourDataSolutionAcceleratorModulesComputeVirtualMachine]`

This module deploys a Virtual Machine with one or multiple NICs and optionally one or multiple public IPs.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Compute/disks` | 2024-03-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_disks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks)</li></ul> |
| `Microsoft.Compute/virtualMachines` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines)</li></ul> |
| `Microsoft.Compute/virtualMachines/extensions` | 2022-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.compute_virtualmachines_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions)</li></ul> |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | 2020-06-25 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.guestconfiguration_guestconfigurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Network/networkInterfaces` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networkinterfaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminUsername`](#parameter-adminusername) | securestring | Administrator username. |
| [`imageReference`](#parameter-imagereference) | object | OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image. |
| [`name`](#parameter-name) | string | The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. |
| [`nicConfigurations`](#parameter-nicconfigurations) | array | Configures NICs and PIPs. |
| [`osDisk`](#parameter-osdisk) | object | Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`osType`](#parameter-ostype) | string | The chosen OS type. |
| [`vmSize`](#parameter-vmsize) | string | Specifies the size for the VMs. |
| [`zone`](#parameter-zone) | int | If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalUnattendContent`](#parameter-additionalunattendcontent) | array | Specifies additional XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. Contents are defined by setting name, component name, and the pass in which the content is applied. |
| [`adminPassword`](#parameter-adminpassword) | securestring | When specifying a Windows Virtual Machine, this value should be passed. |
| [`allowExtensionOperations`](#parameter-allowextensionoperations) | bool | Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| [`availabilitySetResourceId`](#parameter-availabilitysetresourceid) | string | Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set. |
| [`bootDiagnostics`](#parameter-bootdiagnostics) | bool | Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled. |
| [`bootDiagnosticStorageAccountName`](#parameter-bootdiagnosticstorageaccountname) | string | Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided. |
| [`bootDiagnosticStorageAccountUri`](#parameter-bootdiagnosticstorageaccounturi) | string | Storage account boot diagnostic base URI. |
| [`bypassPlatformSafetyChecksOnUserSchedule`](#parameter-bypassplatformsafetychecksonuserschedule) | bool | Enables customer to schedule patching without accidental upgrades. |
| [`certificatesToBeInstalled`](#parameter-certificatestobeinstalled) | array | Specifies set of certificates that should be installed onto the virtual machine. |
| [`computerName`](#parameter-computername) | string | Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name. |
| [`customData`](#parameter-customdata) | string | Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| [`dataDisks`](#parameter-datadisks) | array | Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`dedicatedHostId`](#parameter-dedicatedhostid) | string | Specifies resource ID about the dedicated host that the virtual machine resides in. |
| [`disablePasswordAuthentication`](#parameter-disablepasswordauthentication) | bool | Specifies whether password authentication should be disabled. |
| [`enableAutomaticUpdates`](#parameter-enableautomaticupdates) | bool | Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. When patchMode is set to Manual, this parameter must be set to false. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning. |
| [`enableHotpatching`](#parameter-enablehotpatching) | bool | Enables customers to patch their Azure VMs without requiring a reboot. For enableHotpatching, the 'provisionVMAgent' must be set to true and 'patchMode' must be set to 'AutomaticByPlatform'. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionAtHost`](#parameter-encryptionathost) | bool | This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs. |
| [`evictionPolicy`](#parameter-evictionpolicy) | string | Specifies the eviction policy for the low priority virtual machine. |
| [`extensionAadJoinConfig`](#parameter-extensionaadjoinconfig) | object | The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed. To enroll in Intune, add the setting mdmId: "0000000a-0000-0000-c000-000000000000". |
| [`extensionAntiMalwareConfig`](#parameter-extensionantimalwareconfig) | object | The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed. |
| [`extensionGuestConfigurationExtension`](#parameter-extensionguestconfigurationextension) | object | The configuration for the [Guest Configuration] extension. Must at least contain the ["enabled": true] property to be executed. Needs a managed identy. |
| [`extensionGuestConfigurationExtensionProtectedSettings`](#parameter-extensionguestconfigurationextensionprotectedsettings) | secureObject | An object that contains the extension specific protected settings. |
| [`galleryApplications`](#parameter-galleryapplications) | array | Specifies the gallery applications that should be made available to the VM/VMSS. |
| [`guestConfiguration`](#parameter-guestconfiguration) | object | The guest configuration for the virtual machine. Needs the Guest Configuration extension to be enabled. |
| [`hibernationEnabled`](#parameter-hibernationenabled) | bool | The flag that enables or disables hibernation capability on the VM. |
| [`licenseType`](#parameter-licensetype) | string | Specifies that the image or disk that is being used was licensed on-premises. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceConfigurationResourceId`](#parameter-maintenanceconfigurationresourceid) | string | The resource Id of a maintenance configuration for this VM. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True". |
| [`maxPriceForLowPriorityVm`](#parameter-maxpriceforlowpriorityvm) | string | Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| [`patchAssessmentMode`](#parameter-patchassessmentmode) | string | VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours. |
| [`patchMode`](#parameter-patchmode) | string | VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. Refer to 'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching'. |
| [`plan`](#parameter-plan) | object | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. |
| [`priority`](#parameter-priority) | string | Specifies the priority for the virtual machine. |
| [`provisionVMAgent`](#parameter-provisionvmagent) | bool | Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later. |
| [`proximityPlacementGroupResourceId`](#parameter-proximityplacementgroupresourceid) | string | Resource ID of a proximity placement group. |
| [`publicKeys`](#parameter-publickeys) | array | The list of SSH public keys used to authenticate with linux based VMs. |
| [`rebootSetting`](#parameter-rebootsetting) | string | Specifies the reboot setting for all AutomaticByPlatform patch installation operations. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`secureBootEnabled`](#parameter-securebootenabled) | bool | Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`securityType`](#parameter-securitytype) | string | Specifies the SecurityType of the virtual machine. It has to be set to any specified value to enable UefiSettings. The default behavior is: UefiSettings will not be enabled unless this property is set. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timeZone`](#parameter-timezone) | string | Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`. |
| [`ultraSSDEnabled`](#parameter-ultrassdenabled) | bool | The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| [`userData`](#parameter-userdata) | string | UserData for the VM, which must be base-64 encoded. Customer should not pass any secrets in here. |
| [`virtualMachineScaleSetResourceId`](#parameter-virtualmachinescalesetresourceid) | string | Resource ID of a virtual machine scale set, where the VM should be added. |
| [`vTpmEnabled`](#parameter-vtpmenabled) | bool | Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings. |
| [`winRMListeners`](#parameter-winrmlisteners) | array | Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell. |

### Parameter: `adminUsername`

Administrator username.

- Required: Yes
- Type: securestring

### Parameter: `imageReference`

OS image reference. In case of marketplace images, it's the combination of the publisher, offer, sku, version attributes. In case of custom images it's the resource ID of the custom image.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`communityGalleryImageId`](#parameter-imagereferencecommunitygalleryimageid) | string | Specified the community gallery image unique id for vm deployment. This can be fetched from community gallery image GET call. |
| [`id`](#parameter-imagereferenceid) | string | The resource Id of the image reference. |
| [`offer`](#parameter-imagereferenceoffer) | string | Specifies the offer of the platform image or marketplace image used to create the virtual machine. |
| [`publisher`](#parameter-imagereferencepublisher) | string | The image publisher. |
| [`sharedGalleryImageId`](#parameter-imagereferencesharedgalleryimageid) | string | Specified the shared gallery image unique id for vm deployment. This can be fetched from shared gallery image GET call. |
| [`sku`](#parameter-imagereferencesku) | string | The SKU of the image. |
| [`version`](#parameter-imagereferenceversion) | string | Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available. |

### Parameter: `imageReference.communityGalleryImageId`

Specified the community gallery image unique id for vm deployment. This can be fetched from community gallery image GET call.

- Required: No
- Type: string

### Parameter: `imageReference.id`

The resource Id of the image reference.

- Required: No
- Type: string

### Parameter: `imageReference.offer`

Specifies the offer of the platform image or marketplace image used to create the virtual machine.

- Required: No
- Type: string

### Parameter: `imageReference.publisher`

The image publisher.

- Required: No
- Type: string

### Parameter: `imageReference.sharedGalleryImageId`

Specified the shared gallery image unique id for vm deployment. This can be fetched from shared gallery image GET call.

- Required: No
- Type: string

### Parameter: `imageReference.sku`

The SKU of the image.

- Required: No
- Type: string

### Parameter: `imageReference.version`

Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available.

- Required: No
- Type: string

### Parameter: `name`

The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations`

Configures NICs and PIPs.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipConfigurations`](#parameter-nicconfigurationsipconfigurations) | array | The IP configurations of the network interface. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deleteOption`](#parameter-nicconfigurationsdeleteoption) | string | Specify what happens to the network interface when the VM is deleted. |
| [`diagnosticSettings`](#parameter-nicconfigurationsdiagnosticsettings) | array | The diagnostic settings of the IP configuration. |
| [`dnsServers`](#parameter-nicconfigurationsdnsservers) | array | List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection. |
| [`enableAcceleratedNetworking`](#parameter-nicconfigurationsenableacceleratednetworking) | bool | If the network interface is accelerated networking enabled. |
| [`enableIPForwarding`](#parameter-nicconfigurationsenableipforwarding) | bool | Indicates whether IP forwarding is enabled on this network interface. |
| [`enableTelemetry`](#parameter-nicconfigurationsenabletelemetry) | bool | Enable/Disable usage telemetry for the module. |
| [`lock`](#parameter-nicconfigurationslock) | object | The lock settings of the service. |
| [`name`](#parameter-nicconfigurationsname) | string | The name of the NIC configuration. |
| [`networkSecurityGroupResourceId`](#parameter-nicconfigurationsnetworksecuritygroupresourceid) | string | The network security group (NSG) to attach to the network interface. |
| [`nicSuffix`](#parameter-nicconfigurationsnicsuffix) | string | The suffix to append to the NIC name. |
| [`roleAssignments`](#parameter-nicconfigurationsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-nicconfigurationstags) | object | The tags of the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations`

The IP configurations of the network interface.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-nicconfigurationsipconfigurationssubnetresourceid) | string | The resource ID of the subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayBackendAddressPools`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspools) | array | The application gateway backend address pools. |
| [`applicationSecurityGroups`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroups) | array | The application security groups. |
| [`diagnosticSettings`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettings) | array | The diagnostic settings of the IP configuration. |
| [`enableTelemetry`](#parameter-nicconfigurationsipconfigurationsenabletelemetry) | bool | Enable/Disable usage telemetry for the module. |
| [`gatewayLoadBalancer`](#parameter-nicconfigurationsipconfigurationsgatewayloadbalancer) | object | The gateway load balancer settings. |
| [`loadBalancerBackendAddressPools`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspools) | array | The load balancer backend address pools. |
| [`loadBalancerInboundNatRules`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrules) | array | The load balancer inbound NAT rules. |
| [`name`](#parameter-nicconfigurationsipconfigurationsname) | string | The name of the IP configuration. |
| [`pipConfiguration`](#parameter-nicconfigurationsipconfigurationspipconfiguration) | object | The public IP address configuration. |
| [`privateIPAddress`](#parameter-nicconfigurationsipconfigurationsprivateipaddress) | string | The private IP address. |
| [`privateIPAddressVersion`](#parameter-nicconfigurationsipconfigurationsprivateipaddressversion) | string | The private IP address version. |
| [`privateIPAllocationMethod`](#parameter-nicconfigurationsipconfigurationsprivateipallocationmethod) | string | The private IP address allocation method. |
| [`tags`](#parameter-nicconfigurationsipconfigurationstags) | object | The tags of the public IP address. |
| [`virtualNetworkTaps`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktaps) | array | The virtual network taps. |

### Parameter: `nicConfigurations.ipConfigurations.subnetResourceId`

The resource ID of the subnet.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools`

The application gateway backend address pools.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolsid) | string | Resource ID of the backend address pool. |
| [`name`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolsname) | string | Name of the backend address pool that is unique within an Application Gateway. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolsproperties) | object | Properties of the application gateway backend address pool. |

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.id`

Resource ID of the backend address pool.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.name`

Name of the backend address pool that is unique within an Application Gateway.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties`

Properties of the application gateway backend address pool.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddresses`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddresses) | array | Backend addresses. |

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses`

Backend addresses.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddressesfqdn) | string | FQDN of the backend address. |
| [`ipAddress`](#parameter-nicconfigurationsipconfigurationsapplicationgatewaybackendaddresspoolspropertiesbackendaddressesipaddress) | string | IP address of the backend address. |

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses.fqdn`

FQDN of the backend address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationGatewayBackendAddressPools.properties.backendAddresses.ipAddress`

IP address of the backend address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups`

The application security groups.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupsid) | string | Resource ID of the application security group. |
| [`location`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupslocation) | string | Location of the application security group. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupsproperties) | object | Properties of the application security group. |
| [`tags`](#parameter-nicconfigurationsipconfigurationsapplicationsecuritygroupstags) | object | Tags of the application security group. |

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.id`

Resource ID of the application security group.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.location`

Location of the application security group.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.properties`

Properties of the application security group.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.applicationSecurityGroups.tags`

Tags of the application security group.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings`

The diagnostic settings of the IP configuration.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-nicconfigurationsipconfigurationsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.enableTelemetry`

Enable/Disable usage telemetry for the module.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.gatewayLoadBalancer`

The gateway load balancer settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsgatewayloadbalancerid) | string | Resource ID of the sub resource. |

### Parameter: `nicConfigurations.ipConfigurations.gatewayLoadBalancer.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools`

The load balancer backend address pools.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspoolsid) | string | The resource ID of the backend address pool. |
| [`name`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspoolsname) | string | The name of the backend address pool. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsloadbalancerbackendaddresspoolsproperties) | object | The properties of the backend address pool. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools.id`

The resource ID of the backend address pool.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools.name`

The name of the backend address pool.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerBackendAddressPools.properties`

The properties of the backend address pool.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules`

The load balancer inbound NAT rules.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulesid) | string | Resource ID of the inbound NAT rule. |
| [`name`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulesname) | string | Name of the resource that is unique within the set of inbound NAT rules used by the load balancer. This name can be used to access the resource. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulesproperties) | object | Properties of the inbound NAT rule. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.id`

Resource ID of the inbound NAT rule.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.name`

Name of the resource that is unique within the set of inbound NAT rules used by the load balancer. This name can be used to access the resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties`

Properties of the inbound NAT rule.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddressPool`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesbackendaddresspool) | object | A reference to backendAddressPool resource. |
| [`backendPort`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesbackendport) | int | The port used for the internal endpoint. Acceptable values range from 1 to 65535. |
| [`enableFloatingIP`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesenablefloatingip) | bool | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint. |
| [`enableTcpReset`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesenabletcpreset) | bool | Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP. |
| [`frontendIPConfiguration`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendipconfiguration) | object | A reference to frontend IP addresses. |
| [`frontendPort`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendport) | int | The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534. |
| [`frontendPortRangeEnd`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendportrangeend) | int | The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534. |
| [`frontendPortRangeStart`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendportrangestart) | int | The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534. |
| [`protocol`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesprotocol) | string | The reference to the transport protocol used by the load balancing rule. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.backendAddressPool`

A reference to backendAddressPool resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesbackendaddresspoolid) | string | Resource ID of the sub resource. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.backendAddressPool.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.backendPort`

The port used for the internal endpoint. Acceptable values range from 1 to 65535.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.enableFloatingIP`

Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.enableTcpReset`

Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendIPConfiguration`

A reference to frontend IP addresses.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsloadbalancerinboundnatrulespropertiesfrontendipconfigurationid) | string | Resource ID of the sub resource. |

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendIPConfiguration.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendPort`

The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendPortRangeEnd`

The port range end for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeStart. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.frontendPortRangeStart`

The port range start for the external endpoint. This property is used together with BackendAddressPool and FrontendPortRangeEnd. Individual inbound NAT rule port mappings will be created for each backend address from BackendAddressPool. Acceptable values range from 1 to 65534.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.loadBalancerInboundNatRules.properties.protocol`

The reference to the transport protocol used by the load balancing rule.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'All'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.name`

The name of the IP configuration.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration`

The public IP address configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ddosSettings`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettings) | object | The DDoS protection plan configuration associated with the public IP address. |
| [`diagnosticSettings`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettings) | array | Diagnostic settings for the public IP address. |
| [`dnsSettings`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettings) | object | The DNS settings of the public IP address. |
| [`enableTelemetry`](#parameter-nicconfigurationsipconfigurationspipconfigurationenabletelemetry) | bool | Enable/Disable usage telemetry for the module. |
| [`idleTimeoutInMinutes`](#parameter-nicconfigurationsipconfigurationspipconfigurationidletimeoutinminutes) | int | The idle timeout of the public IP address. |
| [`location`](#parameter-nicconfigurationsipconfigurationspipconfigurationlocation) | string | The idle timeout in minutes. |
| [`lock`](#parameter-nicconfigurationsipconfigurationspipconfigurationlock) | object | The lock settings of the public IP address. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationname) | string | The name of the Public IP Address. |
| [`publicIPAddressResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipaddressresourceid) | string | The resource ID of the public IP address. |
| [`publicIPAddressVersion`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipaddressversion) | string | The public IP address version. |
| [`publicIPAllocationMethod`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipallocationmethod) | string | The public IP address allocation method. |
| [`publicIpNameSuffix`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipnamesuffix) | string | The name suffix of the public IP address resource. |
| [`publicIpPrefixResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationpublicipprefixresourceid) | string | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`roleAssignments`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignments) | array | Array of role assignments to create. |
| [`skuName`](#parameter-nicconfigurationsipconfigurationspipconfigurationskuname) | string | The SKU name of the public IP address. |
| [`skuTier`](#parameter-nicconfigurationsipconfigurationspipconfigurationskutier) | string | The SKU tier of the public IP address. |
| [`tags`](#parameter-nicconfigurationsipconfigurationspipconfigurationtags) | object | The tags of the public IP address. |
| [`zones`](#parameter-nicconfigurationsipconfigurationspipconfigurationzones) | array | The zones of the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings`

The DDoS protection plan configuration associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`protectionMode`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettingsprotectionmode) | string | The DDoS protection policy customizations. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ddosProtectionPlan`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettingsddosprotectionplan) | object | The DDoS protection plan associated with the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings.protectionMode`

The DDoS protection policy customizations.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Enabled'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings.ddosProtectionPlan`

The DDoS protection plan associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationspipconfigurationddossettingsddosprotectionplanid) | string | The resource ID of the DDOS protection plan associated with the public IP address. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.ddosSettings.ddosProtectionPlan.id`

The resource ID of the DDOS protection plan associated with the public IP address.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings`

Diagnostic settings for the public IP address.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-nicconfigurationsipconfigurationspipconfigurationdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings`

The DNS settings of the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabel`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsdomainnamelabel) | string | The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabelScope`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsdomainnamelabelscope) | string | The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN. |
| [`fqdn`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsfqdn) | string | The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
| [`reverseFqdn`](#parameter-nicconfigurationsipconfigurationspipconfigurationdnssettingsreversefqdn) | string | The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.domainNameLabel`

The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.domainNameLabelScope`

The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NoReuse'
    'ResourceGroupReuse'
    'SubscriptionReuse'
    'TenantReuse'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.fqdn`

The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.dnsSettings.reverseFqdn`

The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.enableTelemetry`

Enable/Disable usage telemetry for the module.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.idleTimeoutInMinutes`

The idle timeout of the public IP address.

- Required: No
- Type: int

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.location`

The idle timeout in minutes.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock`

The lock settings of the public IP address.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-nicconfigurationsipconfigurationspipconfigurationlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-nicconfigurationsipconfigurationspipconfigurationlocknotes) | string | Specify the notes of the lock. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.name`

The name of the Public IP Address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIPAddressResourceId`

The resource ID of the public IP address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIPAddressVersion`

The public IP address version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIPAllocationMethod`

The public IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIpNameSuffix`

The name suffix of the public IP address resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.publicIpPrefixResourceId`

Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-nicconfigurationsipconfigurationspipconfigurationroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.skuName`

The SKU name of the public IP address.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.skuTier`

The SKU tier of the public IP address.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Global'
    'Regional'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.tags`

The tags of the public IP address.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.pipConfiguration.zones`

The zones of the public IP address.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.privateIPAddress`

The private IP address.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.privateIPAddressVersion`

The private IP address version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.privateIPAllocationMethod`

The private IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `nicConfigurations.ipConfigurations.tags`

The tags of the public IP address.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps`

The virtual network taps.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapsid) | string | Resource ID of the virtual network tap. |
| [`location`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapslocation) | string | Location of the virtual network tap. |
| [`properties`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapsproperties) | object | Properties of the virtual network tap. |
| [`tags`](#parameter-nicconfigurationsipconfigurationsvirtualnetworktapstags) | object | Tags of the virtual network tap. |

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.id`

Resource ID of the virtual network tap.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.location`

Location of the virtual network tap.

- Required: No
- Type: string

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.properties`

Properties of the virtual network tap.

- Required: No
- Type: object

### Parameter: `nicConfigurations.ipConfigurations.virtualNetworkTaps.tags`

Tags of the virtual network tap.

- Required: No
- Type: object

### Parameter: `nicConfigurations.deleteOption`

Specify what happens to the network interface when the VM is deleted.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Delete'
    'Detach'
  ]
  ```

### Parameter: `nicConfigurations.diagnosticSettings`

The diagnostic settings of the IP configuration.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-nicconfigurationsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-nicconfigurationsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-nicconfigurationsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-nicconfigurationsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-nicconfigurationsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-nicconfigurationsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-nicconfigurationsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-nicconfigurationsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `nicConfigurations.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-nicconfigurationsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-nicconfigurationsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-nicconfigurationsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `nicConfigurations.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `nicConfigurations.dnsServers`

List of DNS servers IP addresses. Use 'AzureProvidedDNS' to switch to azure provided DNS resolution. 'AzureProvidedDNS' value cannot be combined with other IPs, it must be the only value in dnsServers collection.

- Required: No
- Type: array

### Parameter: `nicConfigurations.enableAcceleratedNetworking`

If the network interface is accelerated networking enabled.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.enableIPForwarding`

Indicates whether IP forwarding is enabled on this network interface.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.enableTelemetry`

Enable/Disable usage telemetry for the module.

- Required: No
- Type: bool

### Parameter: `nicConfigurations.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-nicconfigurationslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-nicconfigurationslockname) | string | Specify the name of lock. |

### Parameter: `nicConfigurations.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `nicConfigurations.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `nicConfigurations.name`

The name of the NIC configuration.

- Required: No
- Type: string

### Parameter: `nicConfigurations.networkSecurityGroupResourceId`

The network security group (NSG) to attach to the network interface.

- Required: No
- Type: string

### Parameter: `nicConfigurations.nicSuffix`

The suffix to append to the NIC name.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-nicconfigurationsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-nicconfigurationsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-nicconfigurationsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-nicconfigurationsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-nicconfigurationsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-nicconfigurationsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-nicconfigurationsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-nicconfigurationsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `nicConfigurations.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `nicConfigurations.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `nicConfigurations.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `nicConfigurations.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `nicConfigurations.tags`

The tags of the public IP address.

- Required: No
- Type: object

### Parameter: `osDisk`

Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedDisk`](#parameter-osdiskmanageddisk) | object | The managed disk parameters. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`caching`](#parameter-osdiskcaching) | string | Specifies the caching requirements. |
| [`createOption`](#parameter-osdiskcreateoption) | string | Specifies how the virtual machine should be created. |
| [`deleteOption`](#parameter-osdiskdeleteoption) | string | Specifies whether data disk should be deleted or detached upon VM deletion. |
| [`diffDiskSettings`](#parameter-osdiskdiffdisksettings) | object | Specifies the ephemeral Disk Settings for the operating system disk. |
| [`diskSizeGB`](#parameter-osdiskdisksizegb) | int | Specifies the size of an empty data disk in gigabytes. |
| [`name`](#parameter-osdiskname) | string | The disk name. |

### Parameter: `osDisk.managedDisk`

The managed disk parameters.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskEncryptionSetResourceId`](#parameter-osdiskmanageddiskdiskencryptionsetresourceid) | string | Specifies the customer managed disk encryption set resource id for the managed disk. |
| [`storageAccountType`](#parameter-osdiskmanageddiskstorageaccounttype) | string | Specifies the storage account type for the managed disk. |

### Parameter: `osDisk.managedDisk.diskEncryptionSetResourceId`

Specifies the customer managed disk encryption set resource id for the managed disk.

- Required: No
- Type: string

### Parameter: `osDisk.managedDisk.storageAccountType`

Specifies the storage account type for the managed disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'PremiumV2_LRS'
    'Standard_LRS'
    'StandardSSD_LRS'
    'StandardSSD_ZRS'
    'UltraSSD_LRS'
  ]
  ```

### Parameter: `osDisk.caching`

Specifies the caching requirements.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `osDisk.createOption`

Specifies how the virtual machine should be created.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Attach'
    'Empty'
    'FromImage'
  ]
  ```

### Parameter: `osDisk.deleteOption`

Specifies whether data disk should be deleted or detached upon VM deletion.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Delete'
    'Detach'
  ]
  ```

### Parameter: `osDisk.diffDiskSettings`

Specifies the ephemeral Disk Settings for the operating system disk.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`placement`](#parameter-osdiskdiffdisksettingsplacement) | string | Specifies the ephemeral disk placement for the operating system disk. |

### Parameter: `osDisk.diffDiskSettings.placement`

Specifies the ephemeral disk placement for the operating system disk.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CacheDisk'
    'NvmeDisk'
    'ResourceDisk'
  ]
  ```

### Parameter: `osDisk.diskSizeGB`

Specifies the size of an empty data disk in gigabytes.

- Required: No
- Type: int

### Parameter: `osDisk.name`

The disk name.

- Required: No
- Type: string

### Parameter: `osType`

The chosen OS type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `vmSize`

Specifies the size for the VMs.

- Required: Yes
- Type: string

### Parameter: `zone`

If set to 1, 2 or 3, the availability zone for all VMs is hardcoded to that value. If zero, then availability zones is not used. Cannot be used in combination with availability set nor scale set.

- Required: Yes
- Type: int
- Allowed:
  ```Bicep
  [
    0
    1
    2
    3
  ]
  ```

### Parameter: `additionalUnattendContent`

Specifies additional XML formatted information that can be included in the Unattend.xml file, which is used by Windows Setup. Contents are defined by setting name, component name, and the pass in which the content is applied.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-additionalunattendcontentcontent) | string | Specifies the XML formatted content that is added to the unattend.xml file for the specified path and component. The XML must be less than 4KB and must include the root element for the setting or feature that is being inserted. |
| [`settingName`](#parameter-additionalunattendcontentsettingname) | string | Specifies the name of the setting to which the content applies. |

### Parameter: `additionalUnattendContent.content`

Specifies the XML formatted content that is added to the unattend.xml file for the specified path and component. The XML must be less than 4KB and must include the root element for the setting or feature that is being inserted.

- Required: No
- Type: string

### Parameter: `additionalUnattendContent.settingName`

Specifies the name of the setting to which the content applies.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AutoLogon'
    'FirstLogonCommands'
  ]
  ```

### Parameter: `adminPassword`

When specifying a Windows Virtual Machine, this value should be passed.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `allowExtensionOperations`

Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `availabilitySetResourceId`

Resource ID of an availability set. Cannot be used in combination with availability zone nor scale set.

- Required: No
- Type: string
- Default: `''`

### Parameter: `bootDiagnostics`

Whether boot diagnostics should be enabled on the Virtual Machine. Boot diagnostics will be enabled with a managed storage account if no bootDiagnosticsStorageAccountName value is provided. If bootDiagnostics and bootDiagnosticsStorageAccountName values are not provided, boot diagnostics will be disabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `bootDiagnosticStorageAccountName`

Custom storage account used to store boot diagnostic information. Boot diagnostics will be enabled with a custom storage account if a value is provided.

- Required: No
- Type: string
- Default: `''`

### Parameter: `bootDiagnosticStorageAccountUri`

Storage account boot diagnostic base URI.

- Required: No
- Type: string
- Default: `[format('.blob.{0}/', environment().suffixes.storage)]`

### Parameter: `bypassPlatformSafetyChecksOnUserSchedule`

Enables customer to schedule patching without accidental upgrades.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `certificatesToBeInstalled`

Specifies set of certificates that should be installed onto the virtual machine.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sourceVault`](#parameter-certificatestobeinstalledsourcevault) | object | The relative URL of the Key Vault containing all of the certificates in VaultCertificates. |
| [`vaultCertificates`](#parameter-certificatestobeinstalledvaultcertificates) | array | The list of key vault references in SourceVault which contain certificates. |

### Parameter: `certificatesToBeInstalled.sourceVault`

The relative URL of the Key Vault containing all of the certificates in VaultCertificates.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-certificatestobeinstalledsourcevaultid) | string | Resource ID of the sub resource. |

### Parameter: `certificatesToBeInstalled.sourceVault.id`

Resource ID of the sub resource.

- Required: No
- Type: string

### Parameter: `certificatesToBeInstalled.vaultCertificates`

The list of key vault references in SourceVault which contain certificates.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateStore`](#parameter-certificatestobeinstalledvaultcertificatescertificatestore) | string | For Windows VMs, specifies the certificate store on the Virtual Machine to which the certificate should be added. The specified certificate store is implicitly in the LocalMachine account. For Linux VMs, the certificate file is placed under the /var/lib/waagent directory, with the file name <UppercaseThumbprint>.crt for the X509 certificate file and <UppercaseThumbprint>.prv for private key. Both of these files are .pem formatted. |
| [`certificateUrl`](#parameter-certificatestobeinstalledvaultcertificatescertificateurl) | string | This is the URL of a certificate that has been uploaded to Key Vault as a secret. |

### Parameter: `certificatesToBeInstalled.vaultCertificates.certificateStore`

For Windows VMs, specifies the certificate store on the Virtual Machine to which the certificate should be added. The specified certificate store is implicitly in the LocalMachine account. For Linux VMs, the certificate file is placed under the /var/lib/waagent directory, with the file name <UppercaseThumbprint>.crt for the X509 certificate file and <UppercaseThumbprint>.prv for private key. Both of these files are .pem formatted.

- Required: No
- Type: string

### Parameter: `certificatesToBeInstalled.vaultCertificates.certificateUrl`

This is the URL of a certificate that has been uploaded to Key Vault as a secret.

- Required: No
- Type: string

### Parameter: `computerName`

Can be used if the computer name needs to be different from the Azure VM resource name. If not used, the resource name will be used as computer name.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `customData`

Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format.

- Required: No
- Type: string
- Default: `''`

### Parameter: `dataDisks`

Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedDisk`](#parameter-datadisksmanageddisk) | object | The managed disk parameters. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`caching`](#parameter-datadiskscaching) | string | Specifies the caching requirements. This property is automatically set to 'None' when attaching a pre-existing disk. |
| [`createOption`](#parameter-datadiskscreateoption) | string | Specifies how the virtual machine should be created. This property is automatically set to 'Attach' when attaching a pre-existing disk. |
| [`deleteOption`](#parameter-datadisksdeleteoption) | string | Specifies whether data disk should be deleted or detached upon VM deletion. This property is automatically set to 'Detach' when attaching a pre-existing disk. |
| [`diskIOPSReadWrite`](#parameter-datadisksdiskiopsreadwrite) | int | The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes. Ignored when attaching a pre-existing disk. |
| [`diskMBpsReadWrite`](#parameter-datadisksdiskmbpsreadwrite) | int | The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10. Ignored when attaching a pre-existing disk. |
| [`diskSizeGB`](#parameter-datadisksdisksizegb) | int | Specifies the size of an empty data disk in gigabytes. This property is ignored when attaching a pre-existing disk. |
| [`lun`](#parameter-datadiskslun) | int | Specifies the logical unit number of the data disk. |
| [`name`](#parameter-datadisksname) | string | The disk name. When attaching a pre-existing disk, this name is ignored and the name of the existing disk is used. |
| [`tags`](#parameter-datadiskstags) | object | The tags of the public IP address. Valid only when creating a new managed disk. |

### Parameter: `dataDisks.managedDisk`

The managed disk parameters.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskEncryptionSetResourceId`](#parameter-datadisksmanageddiskdiskencryptionsetresourceid) | string | Specifies the customer managed disk encryption set resource id for the managed disk. |
| [`id`](#parameter-datadisksmanageddiskid) | string | Specifies the resource id of a pre-existing managed disk. If the disk should be created, this property should be empty. |
| [`storageAccountType`](#parameter-datadisksmanageddiskstorageaccounttype) | string | Specifies the storage account type for the managed disk. Ignored when attaching a pre-existing disk. |

### Parameter: `dataDisks.managedDisk.diskEncryptionSetResourceId`

Specifies the customer managed disk encryption set resource id for the managed disk.

- Required: No
- Type: string

### Parameter: `dataDisks.managedDisk.id`

Specifies the resource id of a pre-existing managed disk. If the disk should be created, this property should be empty.

- Required: No
- Type: string

### Parameter: `dataDisks.managedDisk.storageAccountType`

Specifies the storage account type for the managed disk. Ignored when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'PremiumV2_LRS'
    'Standard_LRS'
    'StandardSSD_LRS'
    'StandardSSD_ZRS'
    'UltraSSD_LRS'
  ]
  ```

### Parameter: `dataDisks.caching`

Specifies the caching requirements. This property is automatically set to 'None' when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'None'
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `dataDisks.createOption`

Specifies how the virtual machine should be created. This property is automatically set to 'Attach' when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Attach'
    'Empty'
    'FromImage'
  ]
  ```

### Parameter: `dataDisks.deleteOption`

Specifies whether data disk should be deleted or detached upon VM deletion. This property is automatically set to 'Detach' when attaching a pre-existing disk.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Delete'
    'Detach'
  ]
  ```

### Parameter: `dataDisks.diskIOPSReadWrite`

The number of IOPS allowed for this disk; only settable for UltraSSD disks. One operation can transfer between 4k and 256k bytes. Ignored when attaching a pre-existing disk.

- Required: No
- Type: int

### Parameter: `dataDisks.diskMBpsReadWrite`

The bandwidth allowed for this disk; only settable for UltraSSD disks. MBps means millions of bytes per second - MB here uses the ISO notation, of powers of 10. Ignored when attaching a pre-existing disk.

- Required: No
- Type: int

### Parameter: `dataDisks.diskSizeGB`

Specifies the size of an empty data disk in gigabytes. This property is ignored when attaching a pre-existing disk.

- Required: No
- Type: int

### Parameter: `dataDisks.lun`

Specifies the logical unit number of the data disk.

- Required: No
- Type: int

### Parameter: `dataDisks.name`

The disk name. When attaching a pre-existing disk, this name is ignored and the name of the existing disk is used.

- Required: No
- Type: string

### Parameter: `dataDisks.tags`

The tags of the public IP address. Valid only when creating a new managed disk.

- Required: No
- Type: object

### Parameter: `dedicatedHostId`

Specifies resource ID about the dedicated host that the virtual machine resides in.

- Required: No
- Type: string
- Default: `''`

### Parameter: `disablePasswordAuthentication`

Specifies whether password authentication should be disabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableAutomaticUpdates`

Indicates whether Automatic Updates is enabled for the Windows virtual machine. Default value is true. When patchMode is set to Manual, this parameter must be set to false. For virtual machine scale sets, this property can be updated and updates will take effect on OS reprovisioning.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableHotpatching`

Enables customers to patch their Azure VMs without requiring a reboot. For enableHotpatching, the 'provisionVMAgent' must be set to true and 'patchMode' must be set to 'AutomaticByPlatform'.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionAtHost`

This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to True. Restrictions: Cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `evictionPolicy`

Specifies the eviction policy for the low priority virtual machine.

- Required: No
- Type: string
- Default: `'Deallocate'`
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```

### Parameter: `extensionAadJoinConfig`

The configuration for the [AAD Join] extension. Must at least contain the ["enabled": true] property to be executed. To enroll in Intune, add the setting mdmId: "0000000a-0000-0000-c000-000000000000".

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionAntiMalwareConfig`

The configuration for the [Anti Malware] extension. Must at least contain the ["enabled": true] property to be executed.

- Required: No
- Type: object
- Default: `[if(equals(parameters('osType'), 'Windows'), createObject('enabled', true()), createObject('enabled', false()))]`

### Parameter: `extensionGuestConfigurationExtension`

The configuration for the [Guest Configuration] extension. Must at least contain the ["enabled": true] property to be executed. Needs a managed identy.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

### Parameter: `extensionGuestConfigurationExtensionProtectedSettings`

An object that contains the extension specific protected settings.

- Required: No
- Type: secureObject
- Default: `{}`

### Parameter: `galleryApplications`

Specifies the gallery applications that should be made available to the VM/VMSS.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`packageReferenceId`](#parameter-galleryapplicationspackagereferenceid) | string | Specifies the GalleryApplicationVersion resource id on the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/applications/{application}/versions/{version}. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurationReference`](#parameter-galleryapplicationsconfigurationreference) | string | Specifies the uri to an azure blob that will replace the default configuration for the package if provided. |
| [`enableAutomaticUpgrade`](#parameter-galleryapplicationsenableautomaticupgrade) | bool | If set to true, when a new Gallery Application version is available in PIR/SIG, it will be automatically updated for the VM/VMSS. |
| [`order`](#parameter-galleryapplicationsorder) | int | Specifies the order in which the packages have to be installed. |
| [`tags`](#parameter-galleryapplicationstags) | string | Specifies a passthrough value for more generic context. |
| [`treatFailureAsDeploymentFailure`](#parameter-galleryapplicationstreatfailureasdeploymentfailure) | bool | If true, any failure for any operation in the VmApplication will fail the deployment. |

### Parameter: `galleryApplications.packageReferenceId`

Specifies the GalleryApplicationVersion resource id on the form of /subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.Compute/galleries/{galleryName}/applications/{application}/versions/{version}.

- Required: Yes
- Type: string

### Parameter: `galleryApplications.configurationReference`

Specifies the uri to an azure blob that will replace the default configuration for the package if provided.

- Required: No
- Type: string

### Parameter: `galleryApplications.enableAutomaticUpgrade`

If set to true, when a new Gallery Application version is available in PIR/SIG, it will be automatically updated for the VM/VMSS.

- Required: No
- Type: bool

### Parameter: `galleryApplications.order`

Specifies the order in which the packages have to be installed.

- Required: No
- Type: int

### Parameter: `galleryApplications.tags`

Specifies a passthrough value for more generic context.

- Required: No
- Type: string

### Parameter: `galleryApplications.treatFailureAsDeploymentFailure`

If true, any failure for any operation in the VmApplication will fail the deployment.

- Required: No
- Type: bool

### Parameter: `guestConfiguration`

The guest configuration for the virtual machine. Needs the Guest Configuration extension to be enabled.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `hibernationEnabled`

The flag that enables or disables hibernation capability on the VM.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `licenseType`

Specifies that the image or disk that is being used was licensed on-premises.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'RHEL_BYOS'
    'SLES_BYOS'
    'Windows_Client'
    'Windows_Server'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `maintenanceConfigurationResourceId`

The resource Id of a maintenance configuration for this VM.

- Required: No
- Type: string
- Default: `''`

### Parameter: `managedIdentities`

The managed identity definition for this resource. The system-assigned managed identity will automatically be enabled if extensionAadJoinConfig.enabled = "True".

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `maxPriceForLowPriorityVm`

Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars.

- Required: No
- Type: string
- Default: `''`

### Parameter: `patchAssessmentMode`

VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours.

- Required: No
- Type: string
- Default: `'ImageDefault'`
- Allowed:
  ```Bicep
  [
    'AutomaticByPlatform'
    'ImageDefault'
  ]
  ```

### Parameter: `patchMode`

VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. Refer to 'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching'.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'AutomaticByOS'
    'AutomaticByPlatform'
    'ImageDefault'
    'Manual'
  ]
  ```

### Parameter: `plan`

Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-planname) | string | The name of the plan. |
| [`product`](#parameter-planproduct) | string | Specifies the product of the image from the marketplace. |
| [`promotionCode`](#parameter-planpromotioncode) | string | The promotion code. |
| [`publisher`](#parameter-planpublisher) | string | The publisher ID. |

### Parameter: `plan.name`

The name of the plan.

- Required: No
- Type: string

### Parameter: `plan.product`

Specifies the product of the image from the marketplace.

- Required: No
- Type: string

### Parameter: `plan.promotionCode`

The promotion code.

- Required: No
- Type: string

### Parameter: `plan.publisher`

The publisher ID.

- Required: No
- Type: string

### Parameter: `priority`

Specifies the priority for the virtual machine.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Low'
    'Regular'
    'Spot'
  ]
  ```

### Parameter: `provisionVMAgent`

Indicates whether virtual machine agent should be provisioned on the virtual machine. When this property is not specified in the request body, default behavior is to set it to true. This will ensure that VM Agent is installed on the VM so that extensions can be added to the VM later.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `proximityPlacementGroupResourceId`

Resource ID of a proximity placement group.

- Required: No
- Type: string
- Default: `''`

### Parameter: `publicKeys`

The list of SSH public keys used to authenticate with linux based VMs.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyData`](#parameter-publickeyskeydata) | string | Specifies the SSH public key data used to authenticate through ssh. |
| [`path`](#parameter-publickeyspath) | string | Specifies the full path on the created VM where ssh public key is stored. If the file already exists, the specified key is appended to the file. |

### Parameter: `publicKeys.keyData`

Specifies the SSH public key data used to authenticate through ssh.

- Required: Yes
- Type: string

### Parameter: `publicKeys.path`

Specifies the full path on the created VM where ssh public key is stored. If the file already exists, the specified key is appended to the file.

- Required: Yes
- Type: string

### Parameter: `rebootSetting`

Specifies the reboot setting for all AutomaticByPlatform patch installation operations.

- Required: No
- Type: string
- Default: `'IfRequired'`
- Allowed:
  ```Bicep
  [
    'Always'
    'IfRequired'
    'Never'
    'Unknown'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Data Operator for Managed Disks'`
  - `'Desktop Virtualization Power On Contributor'`
  - `'Desktop Virtualization Power On Off Contributor'`
  - `'Desktop Virtualization Virtual Machine Contributor'`
  - `'DevTest Labs User'`
  - `'Disk Backup Reader'`
  - `'Disk Pool Operator'`
  - `'Disk Restore Operator'`
  - `'Disk Snapshot Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Virtual Machine Administrator Login'`
  - `'Virtual Machine Contributor'`
  - `'Virtual Machine User Login'`
  - `'VM Scanner Operator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `secureBootEnabled`

Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `securityType`

Specifies the SecurityType of the virtual machine. It has to be set to any specified value to enable UefiSettings. The default behavior is: UefiSettings will not be enabled unless this property is set.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'ConfidentialVM'
    'TrustedLaunch'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `timeZone`

Specifies the time zone of the virtual machine. e.g. 'Pacific Standard Time'. Possible values can be `TimeZoneInfo.id` value from time zones returned by `TimeZoneInfo.GetSystemTimeZones`.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ultraSSDEnabled`

The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `userData`

UserData for the VM, which must be base-64 encoded. Customer should not pass any secrets in here.

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualMachineScaleSetResourceId`

Resource ID of a virtual machine scale set, where the VM should be added.

- Required: No
- Type: string
- Default: `''`

### Parameter: `vTpmEnabled`

Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `winRMListeners`

Specifies the Windows Remote Management listeners. This enables remote Windows PowerShell.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateUrl`](#parameter-winrmlistenerscertificateurl) | string | The URL of a certificate that has been uploaded to Key Vault as a secret. |
| [`protocol`](#parameter-winrmlistenersprotocol) | string | Specifies the protocol of WinRM listener. |

### Parameter: `winRMListeners.certificateUrl`

The URL of a certificate that has been uploaded to Key Vault as a secret.

- Required: No
- Type: string

### Parameter: `winRMListeners.protocol`

Specifies the protocol of WinRM listener.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Https'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VM. |
| `resourceId` | string | The resource ID of the VM. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
