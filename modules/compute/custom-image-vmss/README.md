<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-new-standard-for-bicep-modules---avm-%EF%B8%8F).

# Azure VMSS with Custom Image

Create an Azure VMSS Cluster with a Custom Image to simplify creation of Marketplace Applications

## Details

The Azure Marketplace makes it easy to [create and publish](https://learn.microsoft.com/en-us/azure/marketplace/azure-vm-use-own-image) custom Virtual Machine images.
Customers can then use the custom image to create a Virtual Machine or [Scale Set](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview). But, if custom configurations are required, the user must provide the proper custom data input. Creating a [Marketplace Application](https://learn.microsoft.com/en-us/azure/marketplace/azure-app-offer-setup) enables publishers to customize the [creation experince](https://learn.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/create-uidefinition-overview) in the portal.
This Bicep Module can be used to easily wrap a Marketplace or Community image for use on Azure VMSS.

## Parameters

| Name                         | Type           | Required | Description                                                                                                              |
| :--------------------------- | :------------: | :------: | :----------------------------------------------------------------------------------------------------------------------- |
| `location`                   | `string`       | No       | Deployment Location                                                                                                      |
| `vmssName`                   | `string`       | Yes      | Name of VMSS Cluster                                                                                                     |
| `vmssSku`                    | `string`       | No       | GameDev Sku                                                                                                              |
| `vmssImgPublisher`           | `string`       | No       | Image Publisher                                                                                                          |
| `vmssImgProduct`             | `string`       | No       | Image Product Id                                                                                                         |
| `vmssImgSku`                 | `string`       | No       | Image Sku                                                                                                                |
| `vmssImgVersion`             | `string`       | No       | GameDev Image Product Id                                                                                                 |
| `vmssOsDiskType`             | `string`       | No       | GameDev Disk Type                                                                                                        |
| `vmssInstanceCount`          | `int`          | No       | VMSS Instance Count                                                                                                      |
| `administratorLogin`         | `string`       | Yes      | Administrator Login for access                                                                                           |
| `passwordAdministratorLogin` | `securestring` | Yes      | Administrator Password for access                                                                                        |
| `vnetName`                   | `string`       | No       | Virtual Network Resource Name                                                                                            |
| `subnetName`                 | `string`       | No       | Virtual Network Subnet Name                                                                                              |
| `networkSecurityGroupName`   | `string`       | No       | Virtual Network Security Group Name                                                                                      |
| `vnetAddressPrefix`          | `string`       | No       | Virtual Network Address Prefix                                                                                           |
| `subnetAddressPrefix`        | `string`       | No       | Virtual Network Subnet Address Prefix                                                                                    |
| `imageLocation`              | `string`       | No       | Parameter used for debugging with trail offer                                                                            |
| `communityGalleryImageId`    | `string`       | No       | Pointer to community gallery image. Example: /CommunityGalleries/<sharedGallery>/Images/<definition>/Versions/<imageVer> |
| `customData`                 | `string`       | No       | Base64 Encoded string to provide to VMSS for configuration                                                               |

## Outputs

| Name   | Type     | Description                                |
| :----- | :------: | :----------------------------------------- |
| `id`   | `string` | Resource Id of Virtual Machine Scale Set   |
| `name` | `string` | Resource Name of Virtual Machine Scale Set |

## Examples

### Example 1

The custom data can be loaded from a file.

```bicep
var communityGalleryImageId = '/CommunityGalleries/${sharedGalleryID}/Images/${definitionId}/Versions/${imageVer}'

var customData = loadFileAsBase64('imageConfig.json')

module Example1 'br/public:compute/custom-image-vmss:1.0.2' = {
  name: 'Example1'
  params: {
    location: location
    administratorLogin: uniqueString(resourceGroup().name)
    passwordAdministratorLogin: guid(resourceGroup().name)
    vmssName: uniqueString(resourceGroup().name)
    communityGalleryImageId: communityGalleryImageId
    customData: customData
  }
}

```

### Example 2

The custom data may also be created directly in Bicep, so that the settings may be provided at deployment time.

```bicep
param developer_mode bool = true

var communityGalleryImageId = '/CommunityGalleries/${sharedGalleryId}/Images/${definitionId}/Versions/${imageVer}'

var customData = {
    developer_mode: developer_mode
}

module Example2 'br/public:compute/custom-image-vmss:1.0.2' = {
  name: 'Example2'
  params: {
    location: location
    administratorLogin: uniqueString(resourceGroup().name)
    passwordAdministratorLogin: guid(resourceGroup().name)
    vmssName: uniqueString(resourceGroup().name)
    communityGalleryImageId: communityGalleryImageId
    customData: base64(string(customData))
  }
}

```
