# Azure Storage Account

This Bicep module creates a Storage Account with zone-redundancy, encryption, virtual network access, and TLS version.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                                    | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| :-------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `location`                              | `string` | No       | Deployment Location                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `prefix`                                | `string` | No       | Prefix of Storage Account Resource Name. This param is ignored when name is provided.                                                                                                                                                                                                                                                                                                                                                                                     |
| `name`                                  | `string` | No       | Name of Storage Account. Must be unique within Azure.                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `tags`                                  | `object` | No       | Tags to be applied to the Storage Account.                                                                                                                                                                                                                                                                                                                                                                                                                                |
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
module storageAccount 'br/public:storage/storage-account:0.0.1' = {
  name: 'mystorageaccount'
  params: {
    location: 'eastus'
  }
}

output storageAccountID string = storageAccount.outputs.id
```

### Example 2

```bicep
module test '../main.bicep' = {
  name: 'test'
  dependsOn: [
    prereq
  ]
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
        principalId: prereq.outputs.identityPrincipalIds[0]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        description: 'roleAssignment for calllog SA'
      }
      {
        principalId: prereq.outputs.identityPrincipalIds[1]
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
      }
    ]
    containerRoleAssignments: [
      {
        principalId: prereq.outputs.identityPrincipalIds[0]
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
        subnetId: prereq.outputs.subnetIds[0]
        groupId: 'blob'
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
        isManualApproval: false
      }
      {
        name: 'Test2pep-file'
        subnetId: prereq.outputs.subnetIds[0]
        groupId: 'file'
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
        isManualApproval: false
      }
    ]
  }
}

output storageAccountID string = test.outputs.id
```