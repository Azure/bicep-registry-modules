# Data Protection Backup Vaults `[Microsoft.DataProtection/backupVaults]`

This module deploys a Data Protection Backup Vault.

You can reference the module as follows:
```bicep
module backupVault 'br/public:avm/res/data-protection/backup-vault:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.DataProtection/backupVaults` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dataprotection_backupvaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults)</li></ul> |
| `Microsoft.DataProtection/backupVaults/backupInstances` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dataprotection_backupvaults_backupinstances.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults/backupInstances)</li></ul> |
| `Microsoft.DataProtection/backupVaults/backupPolicies` | 2024-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dataprotection_backupvaults_backuppolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DataProtection/2024-04-01/backupVaults/backupPolicies)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/data-protection/backup-vault:<version>`.

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Backup Vault. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureMonitorAlertSettingsAlertsForAllJobFailures`](#parameter-azuremonitoralertsettingsalertsforalljobfailures) | string | Settings for Azure Monitor based alerts for job failures. |
| [`backupInstances`](#parameter-backupinstances) | array | List of all backup instances. |
| [`backupPolicies`](#parameter-backuppolicies) | array | List of all backup policies. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key (CMK) definition. ENABLING CMK WITH USER ASSIGNED MANAGED IDENTITY IS A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/en-us/azure/backup/encryption-at-rest-with-cmk-for-backup-vault) FOR CLARIFICATION. |
| [`dataStoreType`](#parameter-datastoretype) | string | The datastore type to use. ArchiveStore does not support ZoneRedundancy. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`featureSettings`](#parameter-featuresettings) | object | Feature settings for the backup vault. |
| [`immutabilitySettingState`](#parameter-immutabilitysettingstate) | string | The immmutability setting state of the backup vault resource. |
| [`infrastructureEncryption`](#parameter-infrastructureencryption) | string | Whether or not the service applies a secondary layer of encryption. For security reasons, it is recommended to set it to Enabled. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`softDeleteSettings`](#parameter-softdeletesettings) | object | The soft delete related settings. |
| [`tags`](#parameter-tags) | object | Tags of the backup vault resource. |
| [`type`](#parameter-type) | string | The vault redundancy level to use. |

### Parameter: `name`

Name of the Backup Vault.

- Required: Yes
- Type: string

### Parameter: `azureMonitorAlertSettingsAlertsForAllJobFailures`

Settings for Azure Monitor based alerts for job failures.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `backupInstances`

List of all backup instances.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataSourceInfo`](#parameter-backupinstancesdatasourceinfo) | object | The data source info for the backup instance. |
| [`name`](#parameter-backupinstancesname) | string | The name of the backup instance. |
| [`policyInfo`](#parameter-backupinstancespolicyinfo) | object | The policy info for the backup instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataSourceSetInfo`](#parameter-backupinstancesdatasourcesetinfo) | object | The data source set info for the backup instance. Required for some data source types (e.g., AKS). |
| [`friendlyName`](#parameter-backupinstancesfriendlyname) | string | The friendly name of the backup instance. |

### Parameter: `backupInstances.dataSourceInfo`

The data source info for the backup instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`datasourceType`](#parameter-backupinstancesdatasourceinfodatasourcetype) | string | The data source type of the resource. |
| [`resourceID`](#parameter-backupinstancesdatasourceinforesourceid) | string | The resource ID of the resource. |
| [`resourceLocation`](#parameter-backupinstancesdatasourceinforesourcelocation) | string | The location of the data source. |
| [`resourceName`](#parameter-backupinstancesdatasourceinforesourcename) | string | Unique identifier of the resource in the context of parent. |
| [`resourceType`](#parameter-backupinstancesdatasourceinforesourcetype) | string | The resource type of the data source. |
| [`resourceUri`](#parameter-backupinstancesdatasourceinforesourceuri) | string | The Uri of the resource. |

### Parameter: `backupInstances.dataSourceInfo.datasourceType`

The data source type of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceID`

The resource ID of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceLocation`

The location of the data source.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceName`

Unique identifier of the resource in the context of parent.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceType`

The resource type of the data source.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceInfo.resourceUri`

The Uri of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.name`

The name of the backup instance.

- Required: Yes
- Type: string

### Parameter: `backupInstances.policyInfo`

The policy info for the backup instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`policyName`](#parameter-backupinstancespolicyinfopolicyname) | string | The name of the backup instance policy. |
| [`policyParameters`](#parameter-backupinstancespolicyinfopolicyparameters) | object | Policy parameters for the backup instance. |

### Parameter: `backupInstances.policyInfo.policyName`

The name of the backup instance policy.

- Required: Yes
- Type: string

### Parameter: `backupInstances.policyInfo.policyParameters`

Policy parameters for the backup instance.

- Required: Yes
- Type: object

### Parameter: `backupInstances.dataSourceSetInfo`

The data source set info for the backup instance. Required for some data source types (e.g., AKS).

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`datasourceType`](#parameter-backupinstancesdatasourcesetinfodatasourcetype) | string | The data source type of the resource. |
| [`resourceID`](#parameter-backupinstancesdatasourcesetinforesourceid) | string | The resource ID of the resource. |
| [`resourceLocation`](#parameter-backupinstancesdatasourcesetinforesourcelocation) | string | The location of the data source. |
| [`resourceName`](#parameter-backupinstancesdatasourcesetinforesourcename) | string | Unique identifier of the resource in the context of parent. |
| [`resourceType`](#parameter-backupinstancesdatasourcesetinforesourcetype) | string | The resource type of the data source. |
| [`resourceUri`](#parameter-backupinstancesdatasourcesetinforesourceuri) | string | The Uri of the resource. |

### Parameter: `backupInstances.dataSourceSetInfo.datasourceType`

The data source type of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceSetInfo.resourceID`

The resource ID of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceSetInfo.resourceLocation`

The location of the data source.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceSetInfo.resourceName`

Unique identifier of the resource in the context of parent.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceSetInfo.resourceType`

The resource type of the data source.

- Required: Yes
- Type: string

### Parameter: `backupInstances.dataSourceSetInfo.resourceUri`

The Uri of the resource.

- Required: Yes
- Type: string

### Parameter: `backupInstances.friendlyName`

The friendly name of the backup instance.

- Required: No
- Type: string

### Parameter: `backupPolicies`

List of all backup policies.

- Required: No
- Type: array

### Parameter: `customerManagedKey`

The customer managed key (CMK) definition. ENABLING CMK WITH USER ASSIGNED MANAGED IDENTITY IS A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/en-us/azure/backup/encryption-at-rest-with-cmk-for-backup-vault) FOR CLARIFICATION.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-customermanagedkeyautorotationenabled) | bool | Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.autoRotationEnabled`

Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.

- Required: No
- Type: bool

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `dataStoreType`

The datastore type to use. ArchiveStore does not support ZoneRedundancy.

- Required: No
- Type: string
- Default: `'VaultStore'`
- Allowed:
  ```Bicep
  [
    'ArchiveStore'
    'OperationalStore'
    'VaultStore'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `featureSettings`

Feature settings for the backup vault.

- Required: No
- Type: object

### Parameter: `immutabilitySettingState`

The immmutability setting state of the backup vault resource.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Locked'
    'Unlocked'
  ]
  ```

### Parameter: `infrastructureEncryption`

Whether or not the service applies a secondary layer of encryption. For security reasons, it is recommended to set it to Enabled.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Backup Contributor'`
  - `'Backup Operator'`
  - `'Backup Reader'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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

### Parameter: `softDeleteSettings`

The soft delete related settings.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`retentionDurationInDays`](#parameter-softdeletesettingsretentiondurationindays) | int | The soft delete retention period in days. |
| [`state`](#parameter-softdeletesettingsstate) | string | The soft delete state. |

### Parameter: `softDeleteSettings.retentionDurationInDays`

The soft delete retention period in days.

- Required: Yes
- Type: int

### Parameter: `softDeleteSettings.state`

The soft delete state.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AlwaysON'
    'Off'
    'On'
  ]
  ```

### Parameter: `tags`

Tags of the backup vault resource.

- Required: No
- Type: object

### Parameter: `type`

The vault redundancy level to use.

- Required: No
- Type: string
- Default: `'GeoRedundant'`
- Allowed:
  ```Bicep
  [
    'GeoRedundant'
    'LocallyRedundant'
    'ZoneRedundant'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the backup vault. |
| `resourceGroupName` | string | The name of the resource group the recovery services vault was created in. |
| `resourceId` | string | The resource ID of the backup vault. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Notes

### Parameter Usage: `backupPolicies`

Create backup policies in the backupvault.

<details>

<summary>Parameter JSON format</summary>
```json
 "backupPolicies": {
    "value": [
        {
            "name": "DefaultPolicy",
            "properties": {
                "policyRules": [
                    {
                        "backupParameters": {
                            "backupType": "Incremental",
                            "objectType": "AzureBackupParams"
                        },
                        "trigger": {
                            "schedule": {
                                "repeatingTimeIntervals": [
                                    "R/2022-05-31T23:30:00+01:00/P1D"
                                ],
                                "timeZone": "W. Europe Standard Time"
                            },
                            "taggingCriteria": [
                                {
                                    "tagInfo": {
                                        "tagName": "Default",
                                        "id": "Default_"
                                    },
                                    "taggingPriority": 99,
                                    "isDefault": true
                                }
                            ],
                            "objectType": "ScheduleBasedTriggerContext"
                        },
                        "dataStore": {
                            "dataStoreType": "OperationalStore",
                            "objectType": "DataStoreInfoBase"
                        },
                        "name": "BackupDaily",
                        "objectType": "AzureBackupRule"
                    },
                    {
                        "lifecycles": [
                            {
                                "deleteAfter": {
                                    "objectType": "AbsoluteDeleteOption",
                                    "duration": "P7D"
                                },
                                "targetDataStoreCopySettings": [],
                                "sourceDataStore": {
                                    "dataStoreType": "OperationalStore",
                                    "objectType": "DataStoreInfoBase"
                                }
                            }
                        ],
                        "isDefault": true,
                        "name": "Default",
                        "objectType": "AzureRetentionRule"
                    }
                ],
                "datasourceTypes": [
                    "Microsoft.Compute/disks"
                ],
                "objectType": "BackupPolicy"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
backupPolicies: [
    {
        name: 'DefaultPolicy'
        properties: {
            policyRules: [
                {
                    backupParameters: {
                        backupType: 'Incremental'
                        objectType: 'AzureBackupParams'
                    }
                    trigger: {
                        schedule: {
                            repeatingTimeIntervals: [
                                'R/2022-05-31T23:30:00+01:00/P1D'
                            ]
                            timeZone: 'W. Europe Standard Time'
                        }
                        taggingCriteria: [
                            {
                                tagInfo: {
                                    tagName: 'Default'
                                    id: 'Default_'
                                }
                                taggingPriority: 99
                                isDefault: true
                            }
                        ]
                        objectType: 'ScheduleBasedTriggerContext'
                    }
                    dataStore: {
                        dataStoreType: 'OperationalStore'
                        objectType: 'DataStoreInfoBase'
                    }
                    name: 'BackupDaily'
                    objectType: 'AzureBackupRule'
                }
                {
                    lifecycles: [
                        {
                            deleteAfter: {
                                objectType: 'AbsoluteDeleteOption'
                                duration: 'P7D'
                            }
                            targetDataStoreCopySettings: []
                            sourceDataStore: {
                                dataStoreType: 'OperationalStore'
                                objectType: 'DataStoreInfoBase'
                            }
                        }
                    ]
                    isDefault: true
                    name: 'Default'
                    objectType: 'AzureRetentionRule'
                }
            ]
            datasourceTypes: [
                'Microsoft.Compute/disks'
            ]
            objectType: 'BackupPolicy'
        }
    }
]
```

</details>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
