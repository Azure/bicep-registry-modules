<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Azure Game Developer VM

Bicep Module to simplify deployment of the Azure Game Developer VM

## Details

The Game Development Virtual Machine is a customizable development workstation or build server in Azure, pre-installed with common game development tooling for game creators to build their games in the cloud. Microsoft partnered with the top game development partners to pre-install Visual Studio, Unreal Engine, Perforce Helix Core, Parsec, Teradici, Incredibuild, Blender, DirectX/GDK/PlayFab SDKs and more in a customizable Azure workstation to make deploying your game creation environment simple, seamless, and secure. No additional costs are added above base Azure VM pricing for leveraging this VM, though Solutions like Incredibuild, Parsec and Teradici require you to Bring Your Own License (BYOL) when leveraging those products, and passing in licensing details is configurable on deployment. The Game Development Virtual Machine currently supports Windows Server 2019 and Windows 10 operating systems.

See our [documentation](https://docs.microsoft.com/en-us/gaming/azure/game-dev-virtual-machine/) for more information.

## Parameters

| Name                          | Type           | Required | Description                                                 |
| :---------------------------- | :------------: | :------: | :---------------------------------------------------------- |
| `location`                    | `string`       | No       | Resource Location.                                          |
| `vmSize`                      | `string`       | No       | Virtual Machine Size.                                       |
| `useVmToSysprepCustomImage`   | `bool`         | No       | Use VM to sysprep an image from                             |
| `vmName`                      | `string`       | No       | Virtual Machine Name.                                       |
| `adminName`                   | `string`       | Yes      | Virtual Machine User Name .                                 |
| `adminPass`                   | `securestring` | Yes      | Admin password.                                             |
| `osType`                      | `string`       | No       | Operating System type                                       |
| `gameEngine`                  | `string`       | No       | Game Engine                                                 |
| `gdkVersion`                  | `string`       | No       | GDK Version                                                 |
| `ibLicenseKey`                | `securestring` | No       | Incredibuild License Key                                    |
| `remoteAccessTechnology`      | `string`       | No       | Remote Access technology                                    |
| `teradiciRegKey`              | `securestring` | No       | Teradici Registration Key                                   |
| `parsec_teamId`               | `string`       | No       | Parsec Team ID                                              |
| `parsec_teamKey`              | `securestring` | No       | Parsec Team Key                                             |
| `parsec_host`                 | `string`       | No       | Parsec Hostname                                             |
| `parsec_userEmail`            | `string`       | No       | Parsec User Email                                           |
| `parsec_isGuestAccess`        | `bool`         | No       | Parsec Is Guest Access                                      |
| `numDataDisks`                | `int`          | No       | Number of data disks                                        |
| `dataDiskSize`                | `int`          | No       | Disk Performance Tier                                       |
| `fileShareStorageAccount`     | `string`       | No       | File Share Storage Account name                             |
| `fileShareStorageAccountKey`  | `securestring` | No       | File Share Storage Account key                              |
| `fileShareName`               | `string`       | No       | File Share name                                             |
| `p4Port`                      | `string`       | No       | Perforce Port address                                       |
| `p4Username`                  | `string`       | No       | Perforce User                                               |
| `p4Password`                  | `securestring` | No       | Perforce User password                                      |
| `p4Workspace`                 | `string`       | No       | Perforce Client Workspace                                   |
| `p4Stream`                    | `string`       | No       | Perforce Stream                                             |
| `p4ClientViews`               | `string`       | No       | Perforce Depot Client View mappings                         |
| `vnetName`                    | `string`       | No       | Virtual Network name                                        |
| `vnetARPrefixes`              | `array`        | No       | Address prefix of the virtual network                       |
| `vnetNewOrExisting`           | `string`       | No       | Virtual network is new or existing                          |
| `vnetRGName`                  | `string`       | No       | Resource Group of the Virtual network                       |
| `subNetName`                  | `string`       | No       | VM Subnet name                                              |
| `subNetARPrefix`              | `string`       | No       | Subnet prefix of the virtual network                        |
| `publicIpName`                | `string`       | No       | Unique public ip address name                               |
| `publicIpDns`                 | `string`       | No       | Unique DNS Public IP attached the VM                        |
| `publicIpAllocationMethod`    | `string`       | No       | Public IP Allocoation Method                                |
| `publicIpSku`                 | `string`       | No       | SKU number                                                  |
| `publicIpNewOrExisting`       | `string`       | No       | Public IP New or Existing or None?                          |
| `publicIpRGName`              | `string`       | No       | Resource Group of the Public IP Address                     |
| `environment`                 | `string`       | No       | Select Image Deployment for debugging only                  |
| `outTagsByResource`           | `object`       | No       | Tags by resource.                                           |
| `unrealPixelStreamingEnabled` | `bool`         | No       | Enable or disable Unreal Pixel Streaming port.              |
| `enableManagedIdentity`       | `bool`         | No       | Enable or disable the use of a Managed Identity for the VM. |
| `enableAAD`                   | `bool`         | No       | Enable or disable AAD-based login.                          |
| `windowsUpdateOption`         | `string`       | No       | Specifies the OS patching behavior.                         |

## Outputs

| Name        | Type     | Description                              |
| :---------- | :------: | :--------------------------------------- |
| `Host_Name` | `string` | Game Developer Virtual Machine Host Name |
| `UserName`  | `string` | Game Developer Virtual Machine User Name |

## Examples

### Using the Azure Game Developer VM module

```bicep
module gameDevVM 'br/public:azure-gaming/game-dev-vm:2.0.3' = {
  name: 'gameDevVM'
  params: {
    vmName: 'gameDevVM'
  }
}
```
