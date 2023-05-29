# Azure Storage Account

This Bicep module creates a Storage Account with zone-redundancy, encryption, virtual network access, and TLS version.

## Description

Azure Storage is a cloud-based storage service offered by Microsoft that provides highly scalable and durable storage for data and applications.
Storage Accounts are the fundamental storage entity in Azure Storage and can be used to store data objects such as blobs, files, queues, tables, and disks.

This Bicep module allows users to create or use existing Storage Accounts with options to control redundancy, access, and security settings.
Zone-redundancy allows data to be stored across multiple Availability Zones, increasing availability and durability.
Virtual network rules can be used to restrict or allow network traffic to and from the Storage Account.
Encryption and TLS settings can be configured to ensure data security.

The module supports both blob and file services, allowing users to store and retrieve unstructured data and files.
The output of the module is the ID of the created or existing Storage Account, which can be used in other Azure resource deployments.

## Parameters

| Name                      | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| :------------------------ | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                | `string` | Yes      | Deployment Location                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `prefix`                  | `string` | No       | Prefix of Storage Account Resource Name. This param is ignored when name is provided.                                                                                                                                                                                                                                                                                                                                                                       |
| `name`                    | `string` | No       | Name of Storage Account. Must be unique within Azure.                                                                                                                                                                                                                                                                                                                                                                                                       |
| `subnetID`                | `string` | No       | ID of the subnet where the Storage Account will be deployed, if virtual network access is enabled.                                                                                                                                                                                                                                                                                                                                                          |
| `enableVNET`              | `bool`   | No       | Toggle to enable or disable virtual network access for the Storage Account.                                                                                                                                                                                                                                                                                                                                                                                 |
| `isZoneRedundant`         | `bool`   | No       | Toggle to enable or disable zone redundancy for the Storage Account.                                                                                                                                                                                                                                                                                                                                                                                        |
| `storageAccountType`      | `string` | No       | Storage Account Type. Use Zonal Redundant Storage when able.                                                                                                                                                                                                                                                                                                                                                                                                |
| `blobName`                | `string` | No       | Name of a blob service to be created.                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `blobProperties`          | `object` | No       | Properties object for a Blob service of a Storage Account.                                                                                                                                                                                                                                                                                                                                                                                                  |
| `blobContainerName`       | `string` | No       | Name of a blob container to be created                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `blobContainerProperties` | `object` | No       | Properties object for a Blob container of a Storage Account.                                                                                                                                                                                                                                                                                                                                                                                                |
| `roleAssignments`         | `array`  | No       | Array of role assignment objects that contain the 'roleDefinitionIdOrName', 'principalId' and 'resourceType' as 'storageAccount' or 'blobContainer' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |

## Outputs

| Name | Type   | Description                                                                                                      |
| :--- | :----: | :--------------------------------------------------------------------------------------------------------------- |
| name | string | The name of the Storage Account resource                                                                         |
| id   | string | The ID of the Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments. |

## Examples

### Example 1

This example creates a new Storage Account with a unique name in the East US region using the default Storage Account configuration settings. The module output is the ID of the created Storage Account, which can be used in other Azure resource deployments.

```bicep
module storageAccount 'br/public:storage/storage-account:2.0.2' = {
  name: 'mystorageaccount'
  params: {
    location: 'eastus'
  }
}

output storageAccountID string = storageAccount.outputs.id
```

### Example 2

This example creates a new Storage Account with the name "mystorageaccount" in the "myresourcegroup" resource group located in the East US region. The Storage Account is configured to use zone-redundancy and virtual network access. The module output is the ID of the created or existing Storage Account, which can be used in other Azure resource deployments.

```bicep
param location string = 'eastus'
param name string = 'mystorageaccount'
param newOrExisting string = 'new'
param resourceGroupName string = 'myresourcegroup'
param isZoneRedundant bool = true

module storageAccount 'br/public:storage/storage-account:2.0.2' = {
  name: 'mystorageaccount'
  params: {
    location: location
    name: name
    newOrExisting: newOrExisting
    resourceGroupName: resourceGroupName
    isZoneRedundant: isZoneRedundant
  }
}

output storageAccountID string = storageAccount.outputs.id
```
