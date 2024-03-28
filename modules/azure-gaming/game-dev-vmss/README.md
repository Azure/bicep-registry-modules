<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-new-standard-for-bicep-modules---avm-%EF%B8%8F).

# Azure Game Developer VMSS

Bicep Module to simplify deployment of the Azure Game Developer VMSS

## Details

The Game Development Virtual Machine is a customizable development workstation or build server in Azure, pre-installed with common game development tooling for game creators to build their games in the cloud. Microsoft partnered with the top game development partners to pre-install Visual Studio, Unreal Engine, Perforce Helix Core, Parsec, Teradici, Incredibuild, Blender, DirectX/GDK/PlayFab SDKs and more in a customizable Azure workstation to make deploying your game creation environment simple, seamless, and secure. No additional costs are added above base Azure VM pricing for leveraging this VM, though Solutions like Incredibuild, Parsec and Teradici require you to Bring Your Own License (BYOL) when leveraging those products, and passing in licensing details is configurable on deployment. The Game Development Virtual Machine currently supports Windows Server 2019 and Windows 10 operating systems.

See our [documentation](https://docs.microsoft.com/en-us/gaming/azure/game-dev-virtual-machine/) for more information.

## Parameters

| Name                         | Type           | Required | Description                           |
| :--------------------------- | :------------: | :------: | :------------------------------------ |
| `location`                   | `string`       | No       | Deployment Location                   |
| `vmssName`                   | `string`       | Yes      | Name of VMSS Cluster                  |
| `vmssSku`                    | `string`       | No       | GameDev Sku                           |
| `vmssImgPublisher`           | `string`       | No       | GameDev Image Publisher               |
| `vmssImgSku`                 | `string`       | No       | GameDev Image Sku                     |
| `vmssImgVersion`             | `string`       | No       | GameDev Image Product Id              |
| `vmssOsDiskType`             | `string`       | No       | GameDev Disk Type                     |
| `vmssInstanceCount`          | `int`          | No       | VMSS Instance Count                   |
| `administratorLogin`         | `string`       | Yes      | Administrator Login for access        |
| `passwordAdministratorLogin` | `securestring` | Yes      | Administrator Password for access     |
| `fileShareStorageAccount`    | `string`       | No       | File Share Storage Account name       |
| `fileShareStorageAccountKey` | `securestring` | No       | File Share Storage Account key        |
| `fileShareName`              | `string`       | No       | File Share name                       |
| `p4Port`                     | `string`       | No       | Perforce Port address                 |
| `p4Username`                 | `string`       | No       | Perforce User                         |
| `p4Password`                 | `securestring` | No       | Perforce User password                |
| `p4Workspace`                | `string`       | No       | Perforce Client Workspace             |
| `p4Stream`                   | `string`       | No       | Perforce Stream                       |
| `p4ClientViews`              | `string`       | No       | Perforce Depot Client View mappings   |
| `ibLicenseKey`               | `securestring` | No       | Incredibuild License Key              |
| `gdkVersion`                 | `string`       | No       | GDK Version                           |
| `useVmToSysprepCustomImage`  | `bool`         | No       | Use VM to sysprep an image from       |
| `remoteAccessTechnology`     | `string`       | No       | Remote Access technology              |
| `teradiciRegKey`             | `securestring` | No       | Teradici Registration Key             |
| `parsecTeamId`               | `string`       | No       | Parsec Team ID                        |
| `parsecTeamKey`              | `securestring` | No       | Parsec Team Key                       |
| `parsecHost`                 | `string`       | No       | Parsec Hostname                       |
| `parsecUserEmail`            | `string`       | No       | Parsec User Email                     |
| `parsecIsGuestAccess`        | `bool`         | No       | Parsec Is Guest Access                |
| `vnetName`                   | `string`       | No       | Virtual Network Resource Name         |
| `subnetName`                 | `string`       | No       | Virtual Network Subnet Name           |
| `networkSecurityGroupName`   | `string`       | No       | Virtual Network Security Group Name   |
| `vnetAddressPrefix`          | `string`       | No       | Virtual Network Address Prefix        |
| `subnetAddressPrefix`        | `string`       | No       | Virtual Network Subnet Address Prefix |
| `enableAnalyticsDashboard`   | `bool`         | No       | Enable Analytics Dashboard Extension  |
| `analyticsWorkspaceName`     | `string`       | No       | Analytics Workspace Name              |

## Outputs

| Name   | Type     | Description |
| :----- | :------: | :---------- |
| `id`   | `string` | VMSS ID     |
| `name` | `string` | VMSS Name   |

## Examples

### Using the Azure Game Developer VMSS module

```bicep
module gameDevVMSS 'br/public:azure-gaming/game-dev-vmss:1.1.2' = {
  name: 'gameDevVMSS'
  params: {
    vmssName: 'vmssPool'
  }
}
```
