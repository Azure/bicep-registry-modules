# DBforMySQL Flexible Servers `[Microsoft.DBforMySQL/flexibleServers]`

This module deploys a DBforMySQL Flexible Server.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DBforMySQL/flexibleServers` | [2023-12-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/flexibleServers) |
| `Microsoft.DBforMySQL/flexibleServers/administrators` | [2023-06-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2023-06-30/flexibleServers/administrators) |
| `Microsoft.DBforMySQL/flexibleServers/databases` | [2023-06-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2023-06-30/flexibleServers/databases) |
| `Microsoft.DBforMySQL/flexibleServers/firewallRules` | [2023-06-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2023-06-30/flexibleServers/firewallRules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/db-for-my-sql/flexible-server:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Deploys in connectivity mode "Private Access"](#example-3-deploys-in-connectivity-mode-private-access)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-my-sql/flexible-server:<version>' = {
  name: 'flexibleServerDeployment'
  params: {
    // Required parameters
    name: 'dfmsfsmin001'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    location: '<location>'
    storageAutoGrow: 'Enabled'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "dfmsfsmin001"
    },
    "skuName": {
      "value": "Standard_D2ds_v4"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "location": {
      "value": "<location>"
    },
    "storageAutoGrow": {
      "value": "Enabled"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-my-sql/flexible-server:<version>' = {
  name: 'flexibleServerDeployment'
  params: {
    // Required parameters
    name: 'dfmsmax001'
    skuName: 'Standard_D2ads_v5'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    availabilityZone: '1'
    backupRetentionDays: 20
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    customerManagedKeyGeo: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    databases: [
      {
        name: 'testdb1'
      }
      {
        charset: 'ascii'
        collation: 'ascii_general_ci'
        name: 'testdb2'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
      {
        endIpAddress: '10.10.10.10'
        name: 'test-rule1'
        startIpAddress: '10.10.10.1'
      }
      {
        endIpAddress: '100.100.100.10'
        name: 'test-rule2'
        startIpAddress: '100.100.100.1'
      }
    ]
    geoRedundantBackup: 'Enabled'
    highAvailability: 'SameZone'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<geoBackupManagedIdentityResourceId>'
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        name: '2478b63b-0cae-457f-9bd3-9feb00e1925b'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
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
    storageAutoGrow: 'Enabled'
    storageAutoIoScaling: 'Enabled'
    storageIOPS: 400
    storageSizeGB: 64
    tags: {
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'MySQL Flexible Server'
      serverName: 'dfmsmax001'
    }
    version: '8.0.21'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "dfmsmax001"
    },
    "skuName": {
      "value": "Standard_D2ads_v5"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "availabilityZone": {
      "value": "1"
    },
    "backupRetentionDays": {
      "value": 20
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "customerManagedKeyGeo": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "databases": {
      "value": [
        {
          "name": "testdb1"
        },
        {
          "charset": "ascii",
          "collation": "ascii_general_ci",
          "name": "testdb2"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "firewallRules": {
      "value": [
        {
          "endIpAddress": "0.0.0.0",
          "name": "AllowAllWindowsAzureIps",
          "startIpAddress": "0.0.0.0"
        },
        {
          "endIpAddress": "10.10.10.10",
          "name": "test-rule1",
          "startIpAddress": "10.10.10.1"
        },
        {
          "endIpAddress": "100.100.100.10",
          "name": "test-rule2",
          "startIpAddress": "100.100.100.1"
        }
      ]
    },
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "highAvailability": {
      "value": "SameZone"
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
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<geoBackupManagedIdentityResourceId>",
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "2478b63b-0cae-457f-9bd3-9feb00e1925b",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
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
    "storageAutoGrow": {
      "value": "Enabled"
    },
    "storageAutoIoScaling": {
      "value": "Enabled"
    },
    "storageIOPS": {
      "value": 400
    },
    "storageSizeGB": {
      "value": 64
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "resourceType": "MySQL Flexible Server",
        "serverName": "dfmsmax001"
      }
    },
    "version": {
      "value": "8.0.21"
    }
  }
}
```

</details>
<p>

### Example 3: _Deploys in connectivity mode "Private Access"_

This instance deploys the module with connectivity mode "Private Access".


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-my-sql/flexible-server:<version>' = {
  name: 'flexibleServerDeployment'
  params: {
    // Required parameters
    name: 'dfmspvt001'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    administrators: [
      {
        identityResourceId: '<identityResourceId>'
        login: '<login>'
        sid: '<sid>'
      }
    ]
    backupRetentionDays: 10
    databases: [
      {
        name: 'testdb1'
      }
    ]
    delegatedSubnetResourceId: '<delegatedSubnetResourceId>'
    highAvailability: 'SameZone'
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
    storageAutoGrow: 'Enabled'
    storageAutoIoScaling: 'Enabled'
    storageIOPS: 400
    storageSizeGB: 64
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "dfmspvt001"
    },
    "skuName": {
      "value": "Standard_D2ds_v4"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "administrators": {
      "value": [
        {
          "identityResourceId": "<identityResourceId>",
          "login": "<login>",
          "sid": "<sid>"
        }
      ]
    },
    "backupRetentionDays": {
      "value": 10
    },
    "databases": {
      "value": [
        {
          "name": "testdb1"
        }
      ]
    },
    "delegatedSubnetResourceId": {
      "value": "<delegatedSubnetResourceId>"
    },
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "privateDnsZoneResourceId": {
      "value": "<privateDnsZoneResourceId>"
    },
    "storageAutoGrow": {
      "value": "Enabled"
    },
    "storageAutoIoScaling": {
      "value": "Enabled"
    },
    "storageIOPS": {
      "value": 400
    },
    "storageSizeGB": {
      "value": 64
    }
  }
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-my-sql/flexible-server:<version>' = {
  name: 'flexibleServerDeployment'
  params: {
    // Required parameters
    name: 'dfmswaf001'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    availabilityZone: '1'
    highAvailability: 'ZoneRedundant'
    highAvailabilityZone: '2'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    storageAutoGrow: 'Enabled'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "dfmswaf001"
    },
    "skuName": {
      "value": "Standard_D2ds_v4"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "availabilityZone": {
      "value": "1"
    },
    "highAvailability": {
      "value": "ZoneRedundant"
    },
    "highAvailabilityZone": {
      "value": "2"
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
    "storageAutoGrow": {
      "value": "Enabled"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the MySQL flexible server. |
| [`skuName`](#parameter-skuname) | string | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| [`tier`](#parameter-tier) | string | The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3". |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Required if 'customerManagedKey' is not empty. |
| [`privateDnsZoneResourceId`](#parameter-privatednszoneresourceid) | string | Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access". Required if "delegatedSubnetResourceId" is used and the Private DNS Zone name must end with mysql.database.azure.com in order to be linked to the MySQL Flexible Server. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Restore point creation time (ISO8601 format), specifying the time to restore from. Required if "createMode" is set to "PointInTimeRestore". |
| [`sourceServerResourceId`](#parameter-sourceserverresourceid) | string | The source MySQL server ID. Required if "createMode" is set to "PointInTimeRestore". |
| [`storageAutoGrow`](#parameter-storageautogrow) | string | Enable Storage Auto Grow or not. Storage auto-growth prevents a server from running out of storage and becoming read-only. Required if "highAvailability" is not "Disabled". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-administratorlogin) | string | The administrator login name of a server. Can only be specified when the MySQL server is being created. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The administrator login password. |
| [`administrators`](#parameter-administrators) | array | The Azure AD administrators when AAD authentication enabled. |
| [`availabilityZone`](#parameter-availabilityzone) | string | Availability zone information of the server. Default will have no preference set. |
| [`backupRetentionDays`](#parameter-backupretentiondays) | int | Backup retention days for the server. |
| [`createMode`](#parameter-createmode) | string | The mode to create a new MySQL server. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition to use for the managed service. |
| [`customerManagedKeyGeo`](#parameter-customermanagedkeygeo) | object | The customer managed key definition to use when geoRedundantBackup is "Enabled". |
| [`databases`](#parameter-databases) | array | The databases to create in the server. |
| [`delegatedSubnetResourceId`](#parameter-delegatedsubnetresourceid) | string | Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. Delegation must be enabled on the subnet for MySQL Flexible Servers and subnet CIDR size is /29. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the MySQL flexible server. |
| [`geoRedundantBackup`](#parameter-georedundantbackup) | string | A value indicating whether Geo-Redundant backup is enabled on the server. If "Enabled" and "cMKKeyName" is not empty, then "geoBackupCMKKeyVaultResourceId" and "cMKUserAssignedIdentityResourceId" are also required. |
| [`highAvailability`](#parameter-highavailability) | string | The mode for High Availability (HA). It is not supported for the Burstable pricing tier and Zone redundant HA can only be set during server provisioning. |
| [`highAvailabilityZone`](#parameter-highavailabilityzone) | string | Standby availability zone information of the server. Default will have no preference set. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | object | Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled". |
| [`replicationRole`](#parameter-replicationrole) | string | The replication role. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`storageAutoIoScaling`](#parameter-storageautoioscaling) | string | Enable IO Auto Scaling or not. The server scales IOPs up or down automatically depending on your workload needs. |
| [`storageIOPS`](#parameter-storageiops) | int | Storage IOPS for a server. Max IOPS are determined by compute size. |
| [`storageSizeGB`](#parameter-storagesizegb) | int | Max storage allowed for a server. In all compute tiers, the minimum storage supported is 20 GiB and maximum is 16 TiB. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`version`](#parameter-version) | string | MySQL Server version. |

### Parameter: `name`

The name of the MySQL flexible server.

- Required: Yes
- Type: string

### Parameter: `skuName`

The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.

- Required: Yes
- Type: string

### Parameter: `tier`

The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Burstable'
    'GeneralPurpose'
    'MemoryOptimized'
  ]
  ```

### Parameter: `managedIdentities`

The managed identity definition for this resource. Required if 'customerManagedKey' is not empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `privateDnsZoneResourceId`

Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access". Required if "delegatedSubnetResourceId" is used and the Private DNS Zone name must end with mysql.database.azure.com in order to be linked to the MySQL Flexible Server.

- Required: No
- Type: string
- Default: `''`

### Parameter: `restorePointInTime`

Restore point creation time (ISO8601 format), specifying the time to restore from. Required if "createMode" is set to "PointInTimeRestore".

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceServerResourceId`

The source MySQL server ID. Required if "createMode" is set to "PointInTimeRestore".

- Required: No
- Type: string
- Default: `''`

### Parameter: `storageAutoGrow`

Enable Storage Auto Grow or not. Storage auto-growth prevents a server from running out of storage and becoming read-only. Required if "highAvailability" is not "Disabled".

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `administratorLogin`

The administrator login name of a server. Can only be specified when the MySQL server is being created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `administratorLoginPassword`

The administrator login password.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `administrators`

The Azure AD administrators when AAD authentication enabled.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `availabilityZone`

Availability zone information of the server. Default will have no preference set.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    '1'
    '2'
    '3'
  ]
  ```

### Parameter: `backupRetentionDays`

Backup retention days for the server.

- Required: No
- Type: int
- Default: `7`

### Parameter: `createMode`

The mode to create a new MySQL server.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'GeoRestore'
    'PointInTimeRestore'
    'Replica'
  ]
  ```

### Parameter: `customerManagedKey`

The customer managed key definition to use for the managed service.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `customerManagedKeyGeo`

The customer managed key definition to use when geoRedundantBackup is "Enabled".

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeygeokeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeygeokeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeygeouserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-customermanagedkeygeokeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |

### Parameter: `customerManagedKeyGeo.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKeyGeo.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKeyGeo.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key.

- Required: Yes
- Type: string

### Parameter: `customerManagedKeyGeo.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `databases`

The databases to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `delegatedSubnetResourceId`

Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. Delegation must be enabled on the subnet for MySQL Flexible Servers and subnet CIDR size is /29.

- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `firewallRules`

The firewall rules to create in the MySQL flexible server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `geoRedundantBackup`

A value indicating whether Geo-Redundant backup is enabled on the server. If "Enabled" and "cMKKeyName" is not empty, then "geoBackupCMKKeyVaultResourceId" and "cMKUserAssignedIdentityResourceId" are also required.

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

### Parameter: `highAvailability`

The mode for High Availability (HA). It is not supported for the Burstable pricing tier and Zone redundant HA can only be set during server provisioning.

- Required: No
- Type: string
- Default: `'ZoneRedundant'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'SameZone'
    'ZoneRedundant'
  ]
  ```

### Parameter: `highAvailabilityZone`

Standby availability zone information of the server. Default will have no preference set.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `maintenanceWindow`

Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled".

- Required: No
- Type: object
- Default: `{}`

### Parameter: `replicationRole`

The replication role.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'None'
    'Replica'
    'Source'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

### Parameter: `storageAutoIoScaling`

Enable IO Auto Scaling or not. The server scales IOPs up or down automatically depending on your workload needs.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `storageIOPS`

Storage IOPS for a server. Max IOPS are determined by compute size.

- Required: No
- Type: int
- Default: `1000`

### Parameter: `storageSizeGB`

Max storage allowed for a server. In all compute tiers, the minimum storage supported is 20 GiB and maximum is 16 TiB.

- Required: No
- Type: int
- Default: `64`
- Allowed:
  ```Bicep
  [
    20
    32
    64
    128
    256
    512
    1024
    2048
    4096
    8192
    16384
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `version`

MySQL Server version.

- Required: No
- Type: string
- Default: `'8.0.21'`
- Allowed:
  ```Bicep
  [
    '5.7'
    '8.0.21'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `fqdn` | string | The FQDN of the MySQL Flexible server. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed MySQL Flexible server. |
| `resourceGroupName` | string | The resource group of the deployed MySQL Flexible server. |
| `resourceId` | string | The resource ID of the deployed MySQL Flexible server. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
