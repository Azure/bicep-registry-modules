# Azure Stack HCI Virtual Machine Instance `[Microsoft.AzureStackHCI/virtualMachineInstances]`

This module deploys an Azure Stack HCI virtual machine.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.AzureStackHCI/virtualMachineInstances` | [2024-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-08-01-preview/virtualMachineInstances) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>`.

- [Using default config](#example-1-using-default-config)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using default config_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    arcMachineResourceName: '<arcMachineResourceName>'
    customLocation: '<customLocation>'
    hardwareProfile: {
      memoryMB: 4096
      processors: 2
    }
    name: 'ashvmiminvm'
    networkProfile: {
      networkInterfaces: []
    }
    osProfile: {
      adminPassword: '<adminPassword>'
      adminUsername: 'Administator'
      computerName: '<computerName>'
      linuxConfiguration: {}
      windowsConfiguration: {
        provisionVMAgent: true
        provisionVMConfigAgent: true
      }
    }
    storageProfile: {
      imageReference: '<imageReference>'
      osDisk: {
        osType: 'Windows'
      }
    }
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "arcMachineResourceName": {
      "value": "<arcMachineResourceName>"
    },
    "customLocation": {
      "value": "<customLocation>"
    },
    "hardwareProfile": {
      "value": {
        "memoryMB": 4096,
        "processors": 2
      }
    },
    "name": {
      "value": "ashvmiminvm"
    },
    "networkProfile": {
      "value": {
        "networkInterfaces": []
      }
    },
    "osProfile": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "Administator",
        "computerName": "<computerName>",
        "linuxConfiguration": {},
        "windowsConfiguration": {
          "provisionVMAgent": true,
          "provisionVMConfigAgent": true
        }
      }
    },
    "storageProfile": {
      "value": {
        "imageReference": "<imageReference>",
        "osDisk": {
          "osType": "Windows"
        }
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>'

// Required parameters
param arcMachineResourceName = '<arcMachineResourceName>'
param customLocation = '<customLocation>'
param hardwareProfile = {
  memoryMB: 4096
  processors: 2
}
param name = 'ashvmiminvm'
param networkProfile = {
  networkInterfaces: []
}
param osProfile = {
  adminPassword: '<adminPassword>'
  adminUsername: 'Administator'
  computerName: '<computerName>'
  linuxConfiguration: {}
  windowsConfiguration: {
    provisionVMAgent: true
    provisionVMConfigAgent: true
  }
}
param storageProfile = {
  imageReference: '<imageReference>'
  osDisk: {
    osType: 'Windows'
  }
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualMachineInstance 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>' = {
  name: 'virtualMachineInstanceDeployment'
  params: {
    // Required parameters
    arcMachineResourceName: '<arcMachineResourceName>'
    customLocation: '<customLocation>'
    hardwareProfile: {
      dynamicMemoryConfig: {
        maximumMemoryMB: 8192
        minimumMemoryMB: 512
        targetMemoryBuffer: 20
      }
      memoryMB: 4096
      processors: 2
      vmSize: 'Custom'
    }
    name: 'ashvmiwafvm'
    networkProfile: {
      networkInterfaces: []
    }
    osProfile: {
      adminPassword: '<adminPassword>'
      adminUsername: 'Administator'
      computerName: '<computerName>'
      linuxConfiguration: {}
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        provisionVMConfigAgent: true
        ssh: {
          publicKeys: []
        }
      }
    }
    storageProfile: {
      imageReference: '<imageReference>'
      osDisk: {
        osType: 'Windows'
      }
    }
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "arcMachineResourceName": {
      "value": "<arcMachineResourceName>"
    },
    "customLocation": {
      "value": "<customLocation>"
    },
    "hardwareProfile": {
      "value": {
        "dynamicMemoryConfig": {
          "maximumMemoryMB": 8192,
          "minimumMemoryMB": 512,
          "targetMemoryBuffer": 20
        },
        "memoryMB": 4096,
        "processors": 2,
        "vmSize": "Custom"
      }
    },
    "name": {
      "value": "ashvmiwafvm"
    },
    "networkProfile": {
      "value": {
        "networkInterfaces": []
      }
    },
    "osProfile": {
      "value": {
        "adminPassword": "<adminPassword>",
        "adminUsername": "Administator",
        "computerName": "<computerName>",
        "linuxConfiguration": {},
        "windowsConfiguration": {
          "enableAutomaticUpdates": true,
          "provisionVMAgent": true,
          "provisionVMConfigAgent": true,
          "ssh": {
            "publicKeys": []
          }
        }
      }
    },
    "storageProfile": {
      "value": {
        "imageReference": "<imageReference>",
        "osDisk": {
          "osType": "Windows"
        }
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/virtual-machine-instance:<version>'

// Required parameters
param arcMachineResourceName = '<arcMachineResourceName>'
param customLocation = '<customLocation>'
param hardwareProfile = {
  dynamicMemoryConfig: {
    maximumMemoryMB: 8192
    minimumMemoryMB: 512
    targetMemoryBuffer: 20
  }
  memoryMB: 4096
  processors: 2
  vmSize: 'Custom'
}
param name = 'ashvmiwafvm'
param networkProfile = {
  networkInterfaces: []
}
param osProfile = {
  adminPassword: '<adminPassword>'
  adminUsername: 'Administator'
  computerName: '<computerName>'
  linuxConfiguration: {}
  windowsConfiguration: {
    enableAutomaticUpdates: true
    provisionVMAgent: true
    provisionVMConfigAgent: true
    ssh: {
      publicKeys: []
    }
  }
}
param storageProfile = {
  imageReference: '<imageReference>'
  osDisk: {
    osType: 'Windows'
  }
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arcMachineResourceName`](#parameter-arcmachineresourcename) | string | Existing Arc Machine resource name. |
| [`customLocation`](#parameter-customlocation) | string | Resource ID of the associated custom location. |
| [`hardwareProfile`](#parameter-hardwareprofile) | object | Hardware profile configuration. |
| [`name`](#parameter-name) | string | Name of the virtual machine instance. |
| [`networkProfile`](#parameter-networkprofile) | object | Network profile configuration. |
| [`osProfile`](#parameter-osprofile) | object | OS profile configuration. |
| [`storageProfile`](#parameter-storageprofile) | object | Storage profile configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`httpProxyConfig`](#parameter-httpproxyconfig) | object | HTTP proxy configuration. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`securityProfile`](#parameter-securityprofile) | object | Security profile configuration. |

### Parameter: `arcMachineResourceName`

Existing Arc Machine resource name.

- Required: Yes
- Type: string

### Parameter: `customLocation`

Resource ID of the associated custom location.

- Required: Yes
- Type: string

### Parameter: `hardwareProfile`

Hardware profile configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`memoryMB`](#parameter-hardwareprofilememorymb) | int | Memory in MB. |
| [`processors`](#parameter-hardwareprofileprocessors) | int | Number of processors. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamicMemoryConfig`](#parameter-hardwareprofiledynamicmemoryconfig) | object | Dynamic memory configuration. |
| [`vmSize`](#parameter-hardwareprofilevmsize) | string | Size of the virtual machine. |

### Parameter: `hardwareProfile.memoryMB`

Memory in MB.

- Required: Yes
- Type: int

### Parameter: `hardwareProfile.processors`

Number of processors.

- Required: Yes
- Type: int

### Parameter: `hardwareProfile.dynamicMemoryConfig`

Dynamic memory configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maximumMemoryMB`](#parameter-hardwareprofiledynamicmemoryconfigmaximummemorymb) | int | Maximum memory in MB. |
| [`minimumMemoryMB`](#parameter-hardwareprofiledynamicmemoryconfigminimummemorymb) | int | Minimum memory in MB. |
| [`targetMemoryBuffer`](#parameter-hardwareprofiledynamicmemoryconfigtargetmemorybuffer) | int | Target memory buffer percentage. |

### Parameter: `hardwareProfile.dynamicMemoryConfig.maximumMemoryMB`

Maximum memory in MB.

- Required: Yes
- Type: int

### Parameter: `hardwareProfile.dynamicMemoryConfig.minimumMemoryMB`

Minimum memory in MB.

- Required: Yes
- Type: int

### Parameter: `hardwareProfile.dynamicMemoryConfig.targetMemoryBuffer`

Target memory buffer percentage.

- Required: Yes
- Type: int

### Parameter: `hardwareProfile.vmSize`

Size of the virtual machine.

- Required: No
- Type: string

### Parameter: `name`

Name of the virtual machine instance.

- Required: Yes
- Type: string

### Parameter: `networkProfile`

Network profile configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkInterfaces`](#parameter-networkprofilenetworkinterfaces) | array | List of network interfaces. |

### Parameter: `networkProfile.networkInterfaces`

List of network interfaces.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-networkprofilenetworkinterfacesid) | string | ID of the network interface. |

### Parameter: `networkProfile.networkInterfaces.id`

ID of the network interface.

- Required: Yes
- Type: string

### Parameter: `osProfile`

OS profile configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminPassword`](#parameter-osprofileadminpassword) | string | Admin password. |
| [`adminUsername`](#parameter-osprofileadminusername) | string | Admin username. |
| [`computerName`](#parameter-osprofilecomputername) | string | Computer name. |
| [`linuxConfiguration`](#parameter-osprofilelinuxconfiguration) | object | Linux configuration. |
| [`windowsConfiguration`](#parameter-osprofilewindowsconfiguration) | object | Windows configuration. |

### Parameter: `osProfile.adminPassword`

Admin password.

- Required: Yes
- Type: string

### Parameter: `osProfile.adminUsername`

Admin username.

- Required: Yes
- Type: string

### Parameter: `osProfile.computerName`

Computer name.

- Required: Yes
- Type: string

### Parameter: `osProfile.linuxConfiguration`

Linux configuration.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disablePasswordAuthentication`](#parameter-osprofilelinuxconfigurationdisablepasswordauthentication) | bool | Whether to disable password authentication. |
| [`provisionVMAgent`](#parameter-osprofilelinuxconfigurationprovisionvmagent) | bool | Whether to provision VM agent. |
| [`provisionVMConfigAgent`](#parameter-osprofilelinuxconfigurationprovisionvmconfigagent) | bool | Whether to provision VM config agent. |
| [`ssh`](#parameter-osprofilelinuxconfigurationssh) | object | SSH configuration. |

### Parameter: `osProfile.linuxConfiguration.disablePasswordAuthentication`

Whether to disable password authentication.

- Required: No
- Type: bool

### Parameter: `osProfile.linuxConfiguration.provisionVMAgent`

Whether to provision VM agent.

- Required: No
- Type: bool

### Parameter: `osProfile.linuxConfiguration.provisionVMConfigAgent`

Whether to provision VM config agent.

- Required: No
- Type: bool

### Parameter: `osProfile.linuxConfiguration.ssh`

SSH configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`publicKeys`](#parameter-osprofilelinuxconfigurationsshpublickeys) | array | List of SSH public keys. |

### Parameter: `osProfile.linuxConfiguration.ssh.publicKeys`

List of SSH public keys.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyData`](#parameter-osprofilelinuxconfigurationsshpublickeyskeydata) | string | SSH public key data. |
| [`path`](#parameter-osprofilelinuxconfigurationsshpublickeyspath) | string | Path for the SSH public key. |

### Parameter: `osProfile.linuxConfiguration.ssh.publicKeys.keyData`

SSH public key data.

- Required: Yes
- Type: string

### Parameter: `osProfile.linuxConfiguration.ssh.publicKeys.path`

Path for the SSH public key.

- Required: Yes
- Type: string

### Parameter: `osProfile.windowsConfiguration`

Windows configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`provisionVMAgent`](#parameter-osprofilewindowsconfigurationprovisionvmagent) | bool | Whether to provision VM agent. |
| [`provisionVMConfigAgent`](#parameter-osprofilewindowsconfigurationprovisionvmconfigagent) | bool | Whether to provision VM config agent. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableAutomaticUpdates`](#parameter-osprofilewindowsconfigurationenableautomaticupdates) | bool | Whether to enable automatic updates. |
| [`ssh`](#parameter-osprofilewindowsconfigurationssh) | object | SSH configuration. |
| [`timeZone`](#parameter-osprofilewindowsconfigurationtimezone) | string | Time zone. |

### Parameter: `osProfile.windowsConfiguration.provisionVMAgent`

Whether to provision VM agent.

- Required: Yes
- Type: bool

### Parameter: `osProfile.windowsConfiguration.provisionVMConfigAgent`

Whether to provision VM config agent.

- Required: Yes
- Type: bool

### Parameter: `osProfile.windowsConfiguration.enableAutomaticUpdates`

Whether to enable automatic updates.

- Required: No
- Type: bool

### Parameter: `osProfile.windowsConfiguration.ssh`

SSH configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`publicKeys`](#parameter-osprofilewindowsconfigurationsshpublickeys) | array | List of SSH public keys. |

### Parameter: `osProfile.windowsConfiguration.ssh.publicKeys`

List of SSH public keys.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyData`](#parameter-osprofilewindowsconfigurationsshpublickeyskeydata) | string | SSH public key data. |
| [`path`](#parameter-osprofilewindowsconfigurationsshpublickeyspath) | string | Path for the SSH public key. |

### Parameter: `osProfile.windowsConfiguration.ssh.publicKeys.keyData`

SSH public key data.

- Required: Yes
- Type: string

### Parameter: `osProfile.windowsConfiguration.ssh.publicKeys.path`

Path for the SSH public key.

- Required: Yes
- Type: string

### Parameter: `osProfile.windowsConfiguration.timeZone`

Time zone.

- Required: No
- Type: string

### Parameter: `storageProfile`

Storage profile configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`imageReference`](#parameter-storageprofileimagereference) | object | Image reference. |
| [`osDisk`](#parameter-storageprofileosdisk) | object | OS disk. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataDisks`](#parameter-storageprofiledatadisks) | array | List of data disks. |
| [`vmConfigStoragePathId`](#parameter-storageprofilevmconfigstoragepathid) | string | VM config storage path ID. |

### Parameter: `storageProfile.imageReference`

Image reference.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-storageprofileimagereferenceid) | string | ID of the image. |

### Parameter: `storageProfile.imageReference.id`

ID of the image.

- Required: Yes
- Type: string

### Parameter: `storageProfile.osDisk`

OS disk.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`osType`](#parameter-storageprofileosdiskostype) | string | OS type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-storageprofileosdiskid) | string | ID of the OS disk. |

### Parameter: `storageProfile.osDisk.osType`

OS type.

- Required: Yes
- Type: string

### Parameter: `storageProfile.osDisk.id`

ID of the OS disk.

- Required: No
- Type: string

### Parameter: `storageProfile.dataDisks`

List of data disks.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-storageprofiledatadisksid) | string | ID of the data disk. |

### Parameter: `storageProfile.dataDisks.id`

ID of the data disk.

- Required: Yes
- Type: string

### Parameter: `storageProfile.vmConfigStoragePathId`

VM config storage path ID.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `httpProxyConfig`

HTTP proxy configuration.

- Required: No
- Type: object
- Default: `{}`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpProxy`](#parameter-httpproxyconfighttpproxy) | string | HTTP proxy URL. |
| [`httpsProxy`](#parameter-httpproxyconfighttpsproxy) | string | HTTPS proxy URL. |
| [`noProxy`](#parameter-httpproxyconfignoproxy) | array | List of addresses that should bypass the proxy. |
| [`trustedCa`](#parameter-httpproxyconfigtrustedca) | string | Trusted CA certificate. |

### Parameter: `httpProxyConfig.httpProxy`

HTTP proxy URL.

- Required: No
- Type: string

### Parameter: `httpProxyConfig.httpsProxy`

HTTPS proxy URL.

- Required: No
- Type: string

### Parameter: `httpProxyConfig.noProxy`

List of addresses that should bypass the proxy.

- Required: No
- Type: array

### Parameter: `httpProxyConfig.trustedCa`

Trusted CA certificate.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `securityProfile`

Security profile configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      uefiSettings: {
        secureBootEnabled: true
      }
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uefiSettings`](#parameter-securityprofileuefisettings) | object | UEFI settings. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTPM`](#parameter-securityprofileenabletpm) | bool | Whether TPM is enabled. |
| [`securityType`](#parameter-securityprofilesecuritytype) | string | Security type. |

### Parameter: `securityProfile.uefiSettings`

UEFI settings.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secureBootEnabled`](#parameter-securityprofileuefisettingssecurebootenabled) | bool | Whether secure boot is enabled. |

### Parameter: `securityProfile.uefiSettings.secureBootEnabled`

Whether secure boot is enabled.

- Required: Yes
- Type: bool

### Parameter: `securityProfile.enableTPM`

Whether TPM is enabled.

- Required: No
- Type: bool

### Parameter: `securityProfile.securityType`

Security type.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual machine instance. |
| `resourceGroupName` | string | The resource group of the virtual machine instance. |
| `resourceId` | string | The resource ID of the virtual machine instance. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
