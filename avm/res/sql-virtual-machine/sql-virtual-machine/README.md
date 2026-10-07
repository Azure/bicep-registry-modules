# SQL Virtual Machine `[Microsoft.SqlVirtualMachine/sqlVirtualMachines]`

This module deploys an Azure SQL Virtual Machine.

You can reference the module as follows:
```bicep
module sqlVirtualMachine 'br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>' = {
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
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.SqlVirtualMachine/sqlVirtualMachines` | 2023-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sqlvirtualmachine_sqlvirtualmachines.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SqlVirtualMachine/2023-10-01/sqlVirtualMachines)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module sqlVirtualMachine 'br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>' = {
  params: {
    // Required parameters
    sqlServerLicenseType: 'PAYG'
    virtualMachineResourceId: '<virtualMachineResourceId>'
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
    "sqlServerLicenseType": {
      "value": "PAYG"
    },
    "virtualMachineResourceId": {
      "value": "<virtualMachineResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>'

// Required parameters
param sqlServerLicenseType = 'PAYG'
param virtualMachineResourceId = '<virtualMachineResourceId>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.
Key Vault credential settings are not covered as they require an Entra ID service principal secret, and SQL virtual machine group / WSFC settings are not covered as they require a domain-joined Windows Server Failover Cluster.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module sqlVirtualMachine 'br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>' = {
  params: {
    // Required parameters
    sqlServerLicenseType: 'PAYG'
    virtualMachineResourceId: '<virtualMachineResourceId>'
    // Non-required parameters
    assessmentSettings: {
      enable: true
      runImmediately: false
      schedule: {
        dayOfWeek: 'Sunday'
        enable: true
        startTime: '02:00'
        weeklyInterval: 1
      }
    }
    autoBackupSettings: {
      backupScheduleType: 'Manual'
      backupSystemDbs: true
      daysOfWeek: [
        'Sunday'
      ]
      enable: true
      enableEncryption: false
      fullBackupFrequency: 'Weekly'
      fullBackupStartTime: 2
      fullBackupWindowHours: 4
      logBackupFrequency: 60
      retentionPeriod: 7
      storageAccessKey: '<storageAccessKey>'
      storageAccountUrl: '<storageAccountUrl>'
    }
    autoPatchingSettings: {
      additionalVmPatch: 'MicrosoftUpdate'
      dayOfWeek: 'Sunday'
      enable: true
      maintenanceWindowDuration: 60
      maintenanceWindowStartingHour: 2
    }
    enableAutomaticUpgrade: true
    leastPrivilegeMode: 'Enabled'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    name: '<name>'
    roleAssignments: [
      {
        name: '7f6e9b2a-3c1d-4e8f-9a0b-1c2d3e4f5a6b'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Virtual Machine Contributor'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    serverConfigurationsManagementSettings: {
      sqlConnectivityUpdateSettings: {
        connectivityType: 'PRIVATE'
        port: 1433
      }
      sqlInstanceSettings: {
        isIfiEnabled: true
        isLpimEnabled: true
        isOptimizeForAdHocWorkloadsEnabled: true
        maxDop: 0
      }
    }
    sqlImageOffer: 'SQL2022-WS2022'
    sqlImageSku: 'Developer'
    sqlManagement: 'Full'
    storageConfigurationSettings: {
      diskConfigurationType: 'NEW'
      sqlDataSettings: {
        defaultFilePath: 'F:\\SQLData'
        luns: [
          0
        ]
      }
      sqlLogSettings: {
        defaultFilePath: 'G:\\SQLLog'
        luns: [
          1
        ]
      }
      sqlSystemDbOnDataDisk: false
      sqlTempDbSettings: {
        defaultFilePath: 'H:\\SQLTemp'
        luns: [
          2
        ]
      }
      storageWorkloadType: 'OLTP'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualMachineIdentitySettings: {
      type: 'SystemAssigned'
    }
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
    "sqlServerLicenseType": {
      "value": "PAYG"
    },
    "virtualMachineResourceId": {
      "value": "<virtualMachineResourceId>"
    },
    // Non-required parameters
    "assessmentSettings": {
      "value": {
        "enable": true,
        "runImmediately": false,
        "schedule": {
          "dayOfWeek": "Sunday",
          "enable": true,
          "startTime": "02:00",
          "weeklyInterval": 1
        }
      }
    },
    "autoBackupSettings": {
      "value": {
        "backupScheduleType": "Manual",
        "backupSystemDbs": true,
        "daysOfWeek": [
          "Sunday"
        ],
        "enable": true,
        "enableEncryption": false,
        "fullBackupFrequency": "Weekly",
        "fullBackupStartTime": 2,
        "fullBackupWindowHours": 4,
        "logBackupFrequency": 60,
        "retentionPeriod": 7,
        "storageAccessKey": "<storageAccessKey>",
        "storageAccountUrl": "<storageAccountUrl>"
      }
    },
    "autoPatchingSettings": {
      "value": {
        "additionalVmPatch": "MicrosoftUpdate",
        "dayOfWeek": "Sunday",
        "enable": true,
        "maintenanceWindowDuration": 60,
        "maintenanceWindowStartingHour": 2
      }
    },
    "enableAutomaticUpgrade": {
      "value": true
    },
    "leastPrivilegeMode": {
      "value": "Enabled"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "name": {
      "value": "<name>"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "7f6e9b2a-3c1d-4e8f-9a0b-1c2d3e4f5a6b",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Virtual Machine Contributor"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "serverConfigurationsManagementSettings": {
      "value": {
        "sqlConnectivityUpdateSettings": {
          "connectivityType": "PRIVATE",
          "port": 1433
        },
        "sqlInstanceSettings": {
          "isIfiEnabled": true,
          "isLpimEnabled": true,
          "isOptimizeForAdHocWorkloadsEnabled": true,
          "maxDop": 0
        }
      }
    },
    "sqlImageOffer": {
      "value": "SQL2022-WS2022"
    },
    "sqlImageSku": {
      "value": "Developer"
    },
    "sqlManagement": {
      "value": "Full"
    },
    "storageConfigurationSettings": {
      "value": {
        "diskConfigurationType": "NEW",
        "sqlDataSettings": {
          "defaultFilePath": "F:\\SQLData",
          "luns": [
            0
          ]
        },
        "sqlLogSettings": {
          "defaultFilePath": "G:\\SQLLog",
          "luns": [
            1
          ]
        },
        "sqlSystemDbOnDataDisk": false,
        "sqlTempDbSettings": {
          "defaultFilePath": "H:\\SQLTemp",
          "luns": [
            2
          ]
        },
        "storageWorkloadType": "OLTP"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualMachineIdentitySettings": {
      "value": {
        "type": "SystemAssigned"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>'

// Required parameters
param sqlServerLicenseType = 'PAYG'
param virtualMachineResourceId = '<virtualMachineResourceId>'
// Non-required parameters
param assessmentSettings = {
  enable: true
  runImmediately: false
  schedule: {
    dayOfWeek: 'Sunday'
    enable: true
    startTime: '02:00'
    weeklyInterval: 1
  }
}
param autoBackupSettings = {
  backupScheduleType: 'Manual'
  backupSystemDbs: true
  daysOfWeek: [
    'Sunday'
  ]
  enable: true
  enableEncryption: false
  fullBackupFrequency: 'Weekly'
  fullBackupStartTime: 2
  fullBackupWindowHours: 4
  logBackupFrequency: 60
  retentionPeriod: 7
  storageAccessKey: '<storageAccessKey>'
  storageAccountUrl: '<storageAccountUrl>'
}
param autoPatchingSettings = {
  additionalVmPatch: 'MicrosoftUpdate'
  dayOfWeek: 'Sunday'
  enable: true
  maintenanceWindowDuration: 60
  maintenanceWindowStartingHour: 2
}
param enableAutomaticUpgrade = true
param leastPrivilegeMode = 'Enabled'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param name = '<name>'
param roleAssignments = [
  {
    name: '7f6e9b2a-3c1d-4e8f-9a0b-1c2d3e4f5a6b'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Virtual Machine Contributor'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param serverConfigurationsManagementSettings = {
  sqlConnectivityUpdateSettings: {
    connectivityType: 'PRIVATE'
    port: 1433
  }
  sqlInstanceSettings: {
    isIfiEnabled: true
    isLpimEnabled: true
    isOptimizeForAdHocWorkloadsEnabled: true
    maxDop: 0
  }
}
param sqlImageOffer = 'SQL2022-WS2022'
param sqlImageSku = 'Developer'
param sqlManagement = 'Full'
param storageConfigurationSettings = {
  diskConfigurationType: 'NEW'
  sqlDataSettings: {
    defaultFilePath: 'F:\\SQLData'
    luns: [
      0
    ]
  }
  sqlLogSettings: {
    defaultFilePath: 'G:\\SQLLog'
    luns: [
      1
    ]
  }
  sqlSystemDbOnDataDisk: false
  sqlTempDbSettings: {
    defaultFilePath: 'H:\\SQLTemp'
    luns: [
      2
    ]
  }
  storageWorkloadType: 'OLTP'
}
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualMachineIdentitySettings = {
  type: 'SystemAssigned'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework. Patching is delegated to Azure Update Manager via a maintenance configuration on the underlying virtual machine instead of the retiring SQL IaaS Agent Automated Patching feature.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module sqlVirtualMachine 'br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>' = {
  params: {
    // Required parameters
    sqlServerLicenseType: 'PAYG'
    virtualMachineResourceId: '<virtualMachineResourceId>'
    // Non-required parameters
    assessmentSettings: {
      enable: true
      runImmediately: false
      schedule: {
        dayOfWeek: 'Sunday'
        enable: true
        startTime: '02:00'
        weeklyInterval: 1
      }
    }
    enableAutomaticUpgrade: true
    leastPrivilegeMode: 'Enabled'
    tags: '<tags>'
    virtualMachineIdentitySettings: {
      type: 'SystemAssigned'
    }
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
    "sqlServerLicenseType": {
      "value": "PAYG"
    },
    "virtualMachineResourceId": {
      "value": "<virtualMachineResourceId>"
    },
    // Non-required parameters
    "assessmentSettings": {
      "value": {
        "enable": true,
        "runImmediately": false,
        "schedule": {
          "dayOfWeek": "Sunday",
          "enable": true,
          "startTime": "02:00",
          "weeklyInterval": 1
        }
      }
    },
    "enableAutomaticUpgrade": {
      "value": true
    },
    "leastPrivilegeMode": {
      "value": "Enabled"
    },
    "tags": {
      "value": "<tags>"
    },
    "virtualMachineIdentitySettings": {
      "value": {
        "type": "SystemAssigned"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql-virtual-machine/sql-virtual-machine:<version>'

// Required parameters
param sqlServerLicenseType = 'PAYG'
param virtualMachineResourceId = '<virtualMachineResourceId>'
// Non-required parameters
param assessmentSettings = {
  enable: true
  runImmediately: false
  schedule: {
    dayOfWeek: 'Sunday'
    enable: true
    startTime: '02:00'
    weeklyInterval: 1
  }
}
param enableAutomaticUpgrade = true
param leastPrivilegeMode = 'Enabled'
param tags = '<tags>'
param virtualMachineIdentitySettings = {
  type: 'SystemAssigned'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sqlServerLicenseType`](#parameter-sqlserverlicensetype) | string | The SQL Server license type. |
| [`virtualMachineResourceId`](#parameter-virtualmachineresourceid) | string | The resource ID of the underlying virtual machine. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assessmentSettings`](#parameter-assessmentsettings) | object | SQL best practices assessment settings. |
| [`autoBackupSettings`](#parameter-autobackupsettings) | secureObject | Automated backup settings for SQL Server. Note: Automated Backup authenticates to the target storage account using a storage account access key, so the storage account must allow shared key access and be reachable from the virtual machine. |
| [`autoPatchingSettings`](#parameter-autopatchingsettings) | object | Automated patching settings for the SQL virtual machine. Note: Automated Patching is scheduled to retire on September 17, 2027 and should not be used for new environments. Use Azure Update Manager (for example, a maintenance configuration assigned to the underlying virtual machine) instead. Do not combine multiple patching solutions on the same virtual machine. |
| [`enableAutomaticUpgrade`](#parameter-enableautomaticupgrade) | bool | Enable automatic upgrade of the SQL IaaS Agent extension. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`keyVaultCredentialSettings`](#parameter-keyvaultcredentialsettings) | secureObject | Key Vault credential settings for the SQL virtual machine. |
| [`leastPrivilegeMode`](#parameter-leastprivilegemode) | string | SQL IaaS Agent least privilege mode. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`name`](#parameter-name) | string | The name of the SQL virtual machine. Must match the name of the underlying virtual machine. Defaults to the name of the virtual machine referenced in `virtualMachineResourceId`. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serverConfigurationsManagementSettings`](#parameter-serverconfigurationsmanagementsettings) | secureObject | SQL Server configuration management settings. |
| [`sqlImageOffer`](#parameter-sqlimageoffer) | string | SQL Server image offer. Examples include SQL2019-WS2022 and SQL2022-WS2022. |
| [`sqlImageSku`](#parameter-sqlimagesku) | string | SQL Server edition. |
| [`sqlManagement`](#parameter-sqlmanagement) | string | SQL Server IaaS Agent management mode. Although the API documents this property as automatically detected, it must be set to `Full` when `leastPrivilegeMode` is `Enabled`, as the registration may otherwise fall back to `LightWeight` mode and fail. |
| [`sqlVirtualMachineGroupResourceId`](#parameter-sqlvirtualmachinegroupresourceid) | string | Resource ID of the SQL virtual machine group that this SQL virtual machine is or will be part of. |
| [`storageConfigurationSettings`](#parameter-storageconfigurationsettings) | object | SQL Server storage configuration settings. Cannot be combined with `serverConfigurationsManagementSettings.sqlStorageUpdateSettings` or `serverConfigurationsManagementSettings.sqlWorkloadTypeUpdateSettings`; use `storageWorkloadType` instead. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualMachineIdentitySettings`](#parameter-virtualmachineidentitysettings) | object | Virtual machine identity details used for SQL IaaS Agent extension configurations. |
| [`wsfcDomainCredentials`](#parameter-wsfcdomaincredentials) | secureObject | Domain credentials for configuring a Windows Server Failover Cluster for a SQL availability group. |
| [`wsfcStaticIp`](#parameter-wsfcstaticip) | string | Static IP address used for the Windows Server Failover Cluster. |

### Parameter: `sqlServerLicenseType`

The SQL Server license type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AHUB'
    'DR'
    'PAYG'
  ]
  ```

### Parameter: `virtualMachineResourceId`

The resource ID of the underlying virtual machine.

- Required: Yes
- Type: string

### Parameter: `assessmentSettings`

SQL best practices assessment settings.

- Required: No
- Type: object

### Parameter: `autoBackupSettings`

Automated backup settings for SQL Server. Note: Automated Backup authenticates to the target storage account using a storage account access key, so the storage account must allow shared key access and be reachable from the virtual machine.

- Required: No
- Type: secureObject

### Parameter: `autoPatchingSettings`

Automated patching settings for the SQL virtual machine. Note: Automated Patching is scheduled to retire on September 17, 2027 and should not be used for new environments. Use Azure Update Manager (for example, a maintenance configuration assigned to the underlying virtual machine) instead. Do not combine multiple patching solutions on the same virtual machine.

- Required: No
- Type: object

### Parameter: `enableAutomaticUpgrade`

Enable automatic upgrade of the SQL IaaS Agent extension.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultCredentialSettings`

Key Vault credential settings for the SQL virtual machine.

- Required: No
- Type: secureObject

### Parameter: `leastPrivilegeMode`

SQL IaaS Agent least privilege mode.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Enabled'
    'NotSet'
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

### Parameter: `name`

The name of the SQL virtual machine. Must match the name of the underlying virtual machine. Defaults to the name of the virtual machine referenced in `virtualMachineResourceId`.

- Required: No
- Type: string
- Default: `[last(split(parameters('virtualMachineResourceId'), '/'))]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Virtual Machine Contributor'`

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

### Parameter: `serverConfigurationsManagementSettings`

SQL Server configuration management settings.

- Required: No
- Type: secureObject

### Parameter: `sqlImageOffer`

SQL Server image offer. Examples include SQL2019-WS2022 and SQL2022-WS2022.

- Required: No
- Type: string

### Parameter: `sqlImageSku`

SQL Server edition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Developer'
    'Enterprise'
    'Express'
    'Standard'
    'Web'
  ]
  ```

### Parameter: `sqlManagement`

SQL Server IaaS Agent management mode. Although the API documents this property as automatically detected, it must be set to `Full` when `leastPrivilegeMode` is `Enabled`, as the registration may otherwise fall back to `LightWeight` mode and fail.

- Required: No
- Type: string
- Default: `'Full'`
- Allowed:
  ```Bicep
  [
    'Full'
    'LightWeight'
    'NoAgent'
  ]
  ```

### Parameter: `sqlVirtualMachineGroupResourceId`

Resource ID of the SQL virtual machine group that this SQL virtual machine is or will be part of.

- Required: No
- Type: string

### Parameter: `storageConfigurationSettings`

SQL Server storage configuration settings. Cannot be combined with `serverConfigurationsManagementSettings.sqlStorageUpdateSettings` or `serverConfigurationsManagementSettings.sqlWorkloadTypeUpdateSettings`; use `storageWorkloadType` instead.

- Required: No
- Type: object

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualMachineIdentitySettings`

Virtual machine identity details used for SQL IaaS Agent extension configurations.

- Required: No
- Type: object

### Parameter: `wsfcDomainCredentials`

Domain credentials for configuring a Windows Server Failover Cluster for a SQL availability group.

- Required: No
- Type: secureObject

### Parameter: `wsfcStaticIp`

Static IP address used for the Windows Server Failover Cluster.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the SQL virtual machine. |
| `name` | string | The name of the SQL virtual machine. |
| `resourceGroupName` | string | The name of the resource group in which the SQL virtual machine was created. |
| `resourceId` | string | The resource ID of the SQL virtual machine. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
