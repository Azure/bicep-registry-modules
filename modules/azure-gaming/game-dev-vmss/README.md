# Azure GameDev VMSS

Bicep Module to simplify deployment of the Azure Game Developer VMSS

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                         | Type           | Required | Description                           |
| :--------------------------- | :------------: | :------: | :------------------------------------ |
| `location`                   | `string`       | No       | Deployment Location                   |
| `vmssName`                   | `string`       | Yes      | Name of VMSS Cluster                  |
| `vmssSku`                    | `string`       | No       | GameDev Sku                           |
| `vmssImgPublisher`           | `string`       | No       | GameDev Image Publisher               |
| `vmssImgProduct`             | `string`       | No       | GameDev Image Product Id              |
| `vmssImgSku`                 | `string`       | No       | GameDev Image Sku                     |
| `vmssImgVersion`             | `string`       | No       | GameDev Image Product Id              |
| `vmssOsDiskType`             | `string`       | No       | GameDev Disk Type                     |
| `vmssInstanceCount`          | `int`          | No       | VMSS Instance Count                   |
| `administratorLogin`         | `string`       | Yes      | Administrator Login for access        |
| `passwordAdministratorLogin` | `secureString` | Yes      | Administrator Password for access     |
| `fileShareStorageAccount`    | `string`       | No       | File Share Storage Account name       |
| `fileShareStorageAccountKey` | `secureString` | No       | File Share Storage Account key        |
| `fileShareName`              | `string`       | No       | File Share name                       |
| `p4Port`                     | `string`       | No       | Perforce Port address                 |
| `p4Username`                 | `string`       | No       | Perforce User                         |
| `p4Password`                 | `secureString` | No       | Perforce User password                |
| `p4Workspace`                | `string`       | No       | Perforce Client Workspace             |
| `p4Stream`                   | `string`       | No       | Perforce Stream                       |
| `p4ClientViews`              | `string`       | No       | Perforce Depot Client View mappings   |
| `ibLicenseKey`               | `secureString` | No       | Incredibuild License Key              |
| `gdkVersion`                 | `string`       | No       | GDK Version                           |
| `useVmToSysprepCustomImage`  | `bool`         | No       | Use VM to sysprep an image from       |
| `remoteAccessTechnology`     | `string`       | No       | Remote Access technology              |
| `teradiciRegKey`             | `secureString` | No       | Teradici Registration Key             |
| `parsecTeamId`               | `string`       | No       | Parsec Team ID                        |
| `parsecTeamKey`              | `secureString` | No       | Parsec Team Key                       |
| `parsecHost`                 | `string`       | No       | Parsec Hostname                       |
| `parsecUserEmail`            | `string`       | No       | Parsec User Email                     |
| `parsecIsGuestAccess`        | `bool`         | No       | Parsec Is Guest Access                |
| `vnetName`                   | `string`       | No       | Virtual Network Resource Name         |
| `subnetName`                 | `string`       | No       | Virtual Network Subnet Name           |
| `networkSecurityGroupName`   | `string`       | No       | Virtual Network Security Group Name   |
| `vnetAddressPrefix`          | `string`       | No       | Virtual Network Address Prefix        |
| `subnetAddressPrefix`        | `string`       | No       | Virtual Network Subnet Address Prefix |

## Outputs

| Name | Type   | Description |
| :--- | :----: | :---------- |
| id   | string | VMSS ID     |
| name | string | VMSS Name   |

## Examples

### Using the Azure Game Developer VMSS module

```bicep
module gameDevVMSS 'br/public:azure-gaming/game-dev-vmss:1.0.0' = {
  name: 'gameDevVMSS'
  params: {
    vmssName: 'vmssPool'
  }
}
```