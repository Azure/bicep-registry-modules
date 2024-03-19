<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been replaced by the following equivalent module in Azure Verified Modules (AVM): [avm/res/storage/storage-account](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/storage/storage-account).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Azure Storage Account

This Bicep module creates a Storage Account with zone-redundancy, encryption, virtual network access, and TLS version.

## Details

Azure Storage is a cloud-based storage service offered by Microsoft that provides highly scalable and durable storage for data and applications.
Storage Accounts are the fundamental storage entity in Azure Storage and can be used to store data objects such as blobs, files, queues, tables, and disks.

This Bicep module allows users to create or use existing Storage Accounts with options to control redundancy, access, and security settings.
Zone-redundancy allows data to be stored across multiple Availability Zones, increasing availability and durability.
Virtual network rules can be used to restrict or allow network traffic to and from the Storage Account.
Encryption and TLS settings can be configured to ensure data security.

The module supports both blob and file services, allowing users to store and retrieve unstructured data and files.
The output of the module is the ID of the created or existing Storage Account, which can be used in other Azure resource deployments.

## Parameters

| Name                                    | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| :-------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `location`                              | `string` | No       | Deployment Location. It defaults to the location of the resource group.                                                                                                                                                                                                                                                                                                                                                                                                   |
| `prefix`                                | `string` | No       | Prefix of Storage Account Resource Name. This param is ignored when name is provided.                                                                                                                                                                                                                                                                                                                                                                                     |
| `name`                                  | `string` | No       | Name of Storage Account. Must be unique within Azure.                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `tags`                                  | `object` | No       | Tags to be applied to the Storage Account.                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `isZoneRedundant`                       | `bool`   | No       | This toggle changes the default value of the sku parameter from Standard_LRS to Standard_ZRS.                                                                                                                                                                                                                                                                                                                                                                             |
| `sku`                                   | `string` | No       | Storage Account SKU.                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `kind`                                  | `string` | No       | Storage Account Kind.                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `identityType`                          | `string` | No       | The type of identity used for the storage account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the resource.                                                                                                                                                                                                                              |
| `userAssignedIdentities`                | `array`  | No       | The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"                                                                                                                                                                                            |
| `accessTier`                            | `string` | No       | The access tier of the storage account, which is used for billing.<br />Required for storage accounts where kind = BlobStorage. The 'Premium' access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.                                                                                                                                                                    |
| `allowBlobPublicAccess`                 | `bool`   | No       | Allow or disallow public access to all blobs or containers in the storage account.                                                                                                                                                                                                                                                                                                                                                                                        |
| `allowCrossTenantReplication`           | `bool`   | No       | Replication of objects between AAD tenants is allowed or not. For this property, the default interpretation is true.                                                                                                                                                                                                                                                                                                                                                      |
| `allowedCopyScope`                      | `object` | No       | Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.                                                                                                                                                                                                                                                                                                                                                                   |
| `allowSharedKeyAccess`                  | `bool`   | No       | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD).                                                                                                                                                                                                                           |
| `azureFilesIdentityBasedAuthentication` | `object` | No       | Provides the identity based authentication settings for Azure Files.                                                                                                                                                                                                                                                                                                                                                                                                      |
| `defaultToOAuthAuthentication`          | `bool`   | No       | A boolean flag which indicates whether the default authentication is OAuth or not.                                                                                                                                                                                                                                                                                                                                                                                        |
| `dnsEndpointType`                       | `string` | No       | Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.                                                                                                                                                                                                                       |
| `encryption`                            | `object` | No       | Encryption settings to be used for server-side encryption for the storage account.                                                                                                                                                                                                                                                                                                                                                                                        |
| `enableHns`                             | `bool`   | No       | Account HierarchicalNamespace enabled if sets to true.                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `enableLocalUser`                       | `bool`   | No       | Enables local users feature, if set to true.                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `enableNfsV3`                           | `bool`   | No       | NFS 3.0 protocol support enabled if set to true.                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `enableSftp`                            | `bool`   | No       | Enables Secure File Transfer Protocol, if set to true.                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `accessKeyPolicy`                       | `object` | No       | Policies for the access keys of the storage account.                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `enablelargeFileShares`                 | `bool`   | No       | Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.                                                                                                                                                                                                                                                                                                                                                                                     |
| `networkAcls`                           | `object` | No       | Configuration for network access rules.                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `routingPreference`                     | `object` | No       | Network routing choice for data transfer.                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `sasTokenPolicy`                        | `object` | No       | SasPolicy assigned to the storage account.                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `supportHttpsTrafficOnly`               | `bool`   | No       | Allows https traffic only to storage service if sets to true.                                                                                                                                                                                                                                                                                                                                                                                                             |
| `enablePublicNetworkAccess`             | `bool`   | No       | Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be Enabled or Disabled.                                                                                                                                                                                                                                                                                                                                              |
| `minimumTlsVersion`                     | `string` | No       | Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.                                                                                                                                                                                                                                                                                                                                              |
| `privateEndpoints`                      | `array`  | No       | Private Endpoints that should be created for the storage account.                                                                                                                                                                                                                                                                                                                                                                                                         |
| `blobServiceProperties`                 | `object` | No       | Properties object for a Blob service of a Storage Account.                                                                                                                                                                                                                                                                                                                                                                                                                |
| `blobContainers`                        | `array`  | No       | Array of blob containers to be created for blobServices of Storage Account.                                                                                                                                                                                                                                                                                                                                                                                               |
| `managementPolicyRules`                 | `array`  | No       | Configuration for the blob inventory policy.                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `objectReplicationSourcePolicy`         | `array`  | No       | Configure object replication on a source storage accounts.<br />This config only applies to the current storage account managed by this module.                                                                                                                                                                                                                                                                                                                           |
| `objectReplicationDestinationPolicy`    | `array`  | No       | Configure object replication on a destination storage accounts.<br />This config only applies to the current storage account managed by this module.                                                                                                                                                                                                                                                                                                                      |
| `storageRoleAssignments`                | `array`  | No       | Array of role assignment objects with Storage Account scope that contain the 'roleDefinitionIdOrName', 'principalId' and 'principalType' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'                          |
| `containerRoleAssignments`              | `array`  | No       | Array of role assignment objects with blobServices/containers scope that contain the 'containerName', 'roleDefinitionIdOrName', 'principalId' and 'principalType' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |

## Outputs

| Name                                              | Type     | Description                                                                                                      |
| :------------------------------------------------ | :------: | :--------------------------------------------------------------------------------------------------------------- |
| `name`                                            | `string` | The name of the Storage Account resource                                                                         |
| `id`                                              | `string` | The ID of the Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments. |
| `objectReplicationDestinationPolicyIdsAndRuleIds` | `array`  | Array of Object Replication Policy IDs and Object Replication PolicyID Rules for OR Policy                       |

## Examples

### Example 1

This example creates a new Storage Account with a unique name in the East US region using the default Storage Account configuration settings. The module output is the ID of the created Storage Account, which can be used in other Azure resource deployments.

```bicep
module storageAccount 'br/public:storage/storage-account:3.0.1' = {
  name: 'mystorageaccount'
  params: {
    location: 'eastus'
  }
}

output storageAccountID string = storageAccount.outputs.id
```

### Example 2

```bicep
module test 'br/public:storage/storage-account:3.0.1' = {
  name: 'test'
  params: {
    name: 'mystorageaccountname'
    location: 'eastus'
    encryption: {
      enable: true
      configurations: {
        keySource: 'Microsoft.Storage'
        requireInfrastructureEncryption: true
      }
    }
    blobServiceProperties: {
      isVersioningEnabled: true
      changeFeed: {
        enabled: true
      }
      lastAccessTimeTrackingPolicy: {
        enable: true
      }
    }
    blobContainers: [
      {
        name: 'container1'
      }
      {
        name: 'container2'
        properties: {
          publicAccess: 'None'
        }
      }
    ]
    storageRoleAssignments: [
      {
        principalId: 'd6d335d7-74ab-4c1b-8c43-f20ca7cfc269' // a fake Service Principal ID
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        description: 'roleAssignment for calllog SA'
      }
      {
        principalId: 'ad6d5375-aefb-4b76-9eaf-2e4e009a6cc3' // a fake Service Principal ID
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
      }
    ]
    containerRoleAssignments: [
      {
        principalId: 'd6d335d7-74ab-4c1b-8c43-f20ca7cfc269' // a fake Service Principal ID
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        containerName: 'test2container1'
        description: 'roleAssignment for audiolog Container'
      }
    ]
    managementPolicyRules: [
      {
        name: 'rule1'
        definition: {
          actions: {
            baseBlob: {
              enableAutoTierToHotFromCool: true
              tierToCool: { daysAfterLastAccessTimeGreaterThan: 30 }
            }
            snapshot: {
              delete: { daysAfterCreationGreaterThan: 30 }
            }
          }
          filters: {
            blobTypes: [ 'blockBlob' ]
            prefixMatch: [ 'test' ]
          }
        }
      }
    ]
    privateEndpoints: [
      {
        name: 'Test2pep-blob'
        subnetId: '/subscriptions/f020357f-3f04-4dc6-80cc-ba41715c5d70/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet-name/subnets/my-subnet-name' // a fake subnet ID
        groupId: 'blob'
        privateDnsZoneId: '/subscriptions/f020357f-3f04-4dc6-80cc-ba41715c5d70/resourceGroups/my-resource-group/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net' // a fake private DNS zone ID
        isManualApproval: false
      }
      {
        name: 'Test2pep-file'
        subnetId: '/subscriptions/f020357f-3f04-4dc6-80cc-ba41715c5d70/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet-name/subnets/my-subnet-name' // a fake subnet ID
        groupId: 'file'
        privateDnsZoneId: '/subscriptions/f020357f-3f04-4dc6-80cc-ba41715c5d70/resourceGroups/my-resource-group/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net' // a fake private DNS zone ID
        isManualApproval: false
      }
    ]
  }
}

output storageAccountID string = test.outputs.id
```
