# DBforPostgreSQL Flexible Servers `[Microsoft.DBforPostgreSQL/flexibleServers]`

This module deploys a DBforPostgreSQL Flexible Server.

You can reference the module as follows:
```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
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
| `Microsoft.DBforPostgreSQL/flexibleServers` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/administrators` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_administrators.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/administrators)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_advancedthreatprotectionsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/advancedThreatProtectionSettings)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_configurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/configurations)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/databases` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/databases)</li></ul> |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | 2025-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbforpostgresql_flexibleservers_firewallrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2025-06-01-preview/flexibleServers/firewallRules)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/db-for-postgre-sql/flexible-server:<version>`.

- [Using managed HSM Customer-Managed-Keys with User-Assigned identity](#example-1-using-managed-hsm-customer-managed-keys-with-user-assigned-identity)
- [Using only defaults](#example-2-using-only-defaults)
- [Using Customer-Managed-Keys with User-Assigned identity](#example-3-using-customer-managed-keys-with-user-assigned-identity)
- [Private access](#example-4-private-access)
- [Public access with private endpoints](#example-5-public-access-with-private-endpoints)
- [Public access](#example-6-public-access)
- [Primary server and Readonly Replication server](#example-7-primary-server-and-readonly-replication-server)
- [WAF-aligned](#example-8-waf-aligned)

### Example 1: _Using managed HSM Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module with Managed HSM-based Customer Managed Key (CMK) encryption, using a User-Assigned Managed Identity to access the HSM key.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/cmk-hsm-uami]

> **Note**: This test is skipped from the CI deployment validation due to the presence of a `.e2eignore` file in the test folder. The reason for skipping the deployment is:
```text
The test is skipped because running the HSM scenario requires a persistent Managed HSM instance to be available and configured at all times, which would incur significant costs for contributors.
```

<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: -1
    name: 'dfpshsmu003'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administrators: [
      {
        objectId: '<objectId>'
        principalName: '<principalName>'
        principalType: 'ServicePrincipal'
      }
    ]
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    geoRedundantBackup: 'Disabled'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
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
    "availabilityZone": {
      "value": -1
    },
    "name": {
      "value": "dfpshsmu003"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administrators": {
      "value": [
        {
          "objectId": "<objectId>",
          "principalName": "<principalName>",
          "principalType": "ServicePrincipal"
        }
      ]
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "geoRedundantBackup": {
      "value": "Disabled"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
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
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = -1
param name = 'dfpshsmu003'
param skuName = 'Standard_D2s_v3'
param tier = 'GeneralPurpose'
// Non-required parameters
param administrators = [
  {
    objectId: '<objectId>'
    principalName: '<principalName>'
    principalType: 'ServicePrincipal'
  }
]
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param geoRedundantBackup = 'Disabled'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: 1
    name: 'dfpsmin001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administrators: [
      {
        objectId: '<objectId>'
        principalName: '<principalName>'
        principalType: 'ServicePrincipal'
      }
    ]
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
    "availabilityZone": {
      "value": 1
    },
    "name": {
      "value": "dfpsmin001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administrators": {
      "value": [
        {
          "objectId": "<objectId>",
          "principalName": "<principalName>",
          "principalType": "ServicePrincipal"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = 1
param name = 'dfpsmin001'
param skuName = 'Standard_D2s_v3'
param tier = 'GeneralPurpose'
// Non-required parameters
param administrators = [
  {
    objectId: '<objectId>'
    principalName: '<principalName>'
    principalType: 'ServicePrincipal'
  }
]
```

</details>
<p>

### Example 3: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: 1
    name: 'dfpfmax001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }
    autoGrow: 'Enabled'
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    geoRedundantBackup: 'Disabled'
    highAvailability: 'Disabled'
    highAvailabilityZone: 2
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    serverThreatProtection: 'Enabled'
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
    "availabilityZone": {
      "value": 1
    },
    "name": {
      "value": "dfpfmax001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
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
    "authConfig": {
      "value": {
        "activeDirectoryAuth": "Disabled",
        "passwordAuth": "Enabled"
      }
    },
    "autoGrow": {
      "value": "Enabled"
    },
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "geoRedundantBackup": {
      "value": "Disabled"
    },
    "highAvailability": {
      "value": "Disabled"
    },
    "highAvailabilityZone": {
      "value": 2
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "serverThreatProtection": {
      "value": "Enabled"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = 1
param name = 'dfpfmax001'
param skuName = 'Standard_D2s_v3'
param tier = 'GeneralPurpose'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param authConfig = {
  activeDirectoryAuth: 'Disabled'
  passwordAuth: 'Enabled'
}
param autoGrow = 'Enabled'
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param geoRedundantBackup = 'Disabled'
param highAvailability = 'Disabled'
param highAvailabilityZone = 2
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param serverThreatProtection = 'Enabled'
```

</details>
<p>

### Example 4: _Private access_

This instance deploys the module with private access only.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/private]


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: -1
    name: 'dfpspvt001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }
    configurations: [
      {
        name: 'log_min_messages'
        source: 'user-override'
        value: 'INFO'
      }
      {
        name: 'autovacuum_naptime'
        source: 'user-override'
        value: '80'
      }
    ]
    databases: [
      {
        charset: 'UTF8'
        collation: 'en_US.utf8'
        name: 'testdb1'
      }
      {
        name: 'testdb2'
      }
    ]
    delegatedSubnetResourceId: '<delegatedSubnetResourceId>'
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
    geoRedundantBackup: 'Enabled'
    privateDnsZoneArmResourceId: '<privateDnsZoneArmResourceId>'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
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
    "availabilityZone": {
      "value": -1
    },
    "name": {
      "value": "dfpspvt001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
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
    "authConfig": {
      "value": {
        "activeDirectoryAuth": "Disabled",
        "passwordAuth": "Enabled"
      }
    },
    "configurations": {
      "value": [
        {
          "name": "log_min_messages",
          "source": "user-override",
          "value": "INFO"
        },
        {
          "name": "autovacuum_naptime",
          "source": "user-override",
          "value": "80"
        }
      ]
    },
    "databases": {
      "value": [
        {
          "charset": "UTF8",
          "collation": "en_US.utf8",
          "name": "testdb1"
        },
        {
          "name": "testdb2"
        }
      ]
    },
    "delegatedSubnetResourceId": {
      "value": "<delegatedSubnetResourceId>"
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
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "privateDnsZoneArmResourceId": {
      "value": "<privateDnsZoneArmResourceId>"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = -1
param name = 'dfpspvt001'
param skuName = 'Standard_D2s_v3'
param tier = 'GeneralPurpose'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param authConfig = {
  activeDirectoryAuth: 'Disabled'
  passwordAuth: 'Enabled'
}
param configurations = [
  {
    name: 'log_min_messages'
    source: 'user-override'
    value: 'INFO'
  }
  {
    name: 'autovacuum_naptime'
    source: 'user-override'
    value: '80'
  }
]
param databases = [
  {
    charset: 'UTF8'
    collation: 'en_US.utf8'
    name: 'testdb1'
  }
  {
    name: 'testdb2'
  }
]
param delegatedSubnetResourceId = '<delegatedSubnetResourceId>'
param diagnosticSettings = [
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
param geoRedundantBackup = 'Enabled'
param privateDnsZoneArmResourceId = '<privateDnsZoneArmResourceId>'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
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
```

</details>
<p>

### Example 5: _Public access with private endpoints_

This instance deploys the module with public access and private endpoints.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/public-with-pe]


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: -1
    name: 'dfpspe001'
    skuName: 'Standard_D2ds_v5'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    authConfig: {
      activeDirectoryAuth: 'Enabled'
      passwordAuth: 'Enabled'
    }
    geoRedundantBackup: 'Enabled'
    highAvailability: 'ZoneRedundant'
    maintenanceWindow: {
      customWindow: 'Enabled'
      dayOfWeek: 0
      startHour: 1
      startMinute: 0
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
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
    "availabilityZone": {
      "value": -1
    },
    "name": {
      "value": "dfpspe001"
    },
    "skuName": {
      "value": "Standard_D2ds_v5"
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
    "authConfig": {
      "value": {
        "activeDirectoryAuth": "Enabled",
        "passwordAuth": "Enabled"
      }
    },
    "geoRedundantBackup": {
      "value": "Enabled"
    },
    "highAvailability": {
      "value": "ZoneRedundant"
    },
    "maintenanceWindow": {
      "value": {
        "customWindow": "Enabled",
        "dayOfWeek": 0,
        "startHour": 1,
        "startMinute": 0
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = -1
param name = 'dfpspe001'
param skuName = 'Standard_D2ds_v5'
param tier = 'GeneralPurpose'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param authConfig = {
  activeDirectoryAuth: 'Enabled'
  passwordAuth: 'Enabled'
}
param geoRedundantBackup = 'Enabled'
param highAvailability = 'ZoneRedundant'
param maintenanceWindow = {
  customWindow: 'Enabled'
  dayOfWeek: 0
  startHour: 1
  startMinute: 0
}
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
```

</details>
<p>

### Example 6: _Public access_

This instance deploys the module with public access and most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/public]


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: 1
    name: 'dfpspub001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administrators: [
      {
        objectId: '<objectId>'
        principalName: '<principalName>'
        principalType: 'ServicePrincipal'
      }
    ]
    backupRetentionDays: 20
    configurations: [
      {
        name: 'log_min_messages'
        source: 'user-override'
        value: 'INFO'
      }
    ]
    databases: [
      {
        charset: 'UTF8'
        collation: 'en_US.utf8'
        name: 'testdb1'
      }
      {
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
    geoRedundantBackup: 'Disabled'
    highAvailability: 'SameZone'
    location: '<location>'
    publicNetworkAccess: 'Enabled'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
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
    storageSizeGB: 1024
    version: '14'
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
    "availabilityZone": {
      "value": 1
    },
    "name": {
      "value": "dfpspub001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administrators": {
      "value": [
        {
          "objectId": "<objectId>",
          "principalName": "<principalName>",
          "principalType": "ServicePrincipal"
        }
      ]
    },
    "backupRetentionDays": {
      "value": 20
    },
    "configurations": {
      "value": [
        {
          "name": "log_min_messages",
          "source": "user-override",
          "value": "INFO"
        }
      ]
    },
    "databases": {
      "value": [
        {
          "charset": "UTF8",
          "collation": "en_US.utf8",
          "name": "testdb1"
        },
        {
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
      "value": "Disabled"
    },
    "highAvailability": {
      "value": "SameZone"
    },
    "location": {
      "value": "<location>"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
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
    "storageSizeGB": {
      "value": 1024
    },
    "version": {
      "value": "14"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = 1
param name = 'dfpspub001'
param skuName = 'Standard_D2s_v3'
param tier = 'GeneralPurpose'
// Non-required parameters
param administrators = [
  {
    objectId: '<objectId>'
    principalName: '<principalName>'
    principalType: 'ServicePrincipal'
  }
]
param backupRetentionDays = 20
param configurations = [
  {
    name: 'log_min_messages'
    source: 'user-override'
    value: 'INFO'
  }
]
param databases = [
  {
    charset: 'UTF8'
    collation: 'en_US.utf8'
    name: 'testdb1'
  }
  {
    name: 'testdb2'
  }
]
param diagnosticSettings = [
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
param firewallRules = [
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
param geoRedundantBackup = 'Disabled'
param highAvailability = 'SameZone'
param location = '<location>'
param publicNetworkAccess = 'Enabled'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
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
param storageSizeGB = 1024
param version = '14'
```

</details>
<p>

### Example 7: _Primary server and Readonly Replication server_

This instance deploys a primary and readonly replication server using the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/replication]


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: -1
    name: 'dfpsrep001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    autoGrow: 'Enabled'
    createMode: '<createMode>'
    highAvailability: 'Disabled'
    sourceServerResourceId: '<sourceServerResourceId>'
    storageSizeGB: 512
    version: '17'
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
    "availabilityZone": {
      "value": -1
    },
    "name": {
      "value": "dfpsrep001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "autoGrow": {
      "value": "Enabled"
    },
    "createMode": {
      "value": "<createMode>"
    },
    "highAvailability": {
      "value": "Disabled"
    },
    "sourceServerResourceId": {
      "value": "<sourceServerResourceId>"
    },
    "storageSizeGB": {
      "value": 512
    },
    "version": {
      "value": "17"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = -1
param name = 'dfpsrep001'
param skuName = 'Standard_D2s_v3'
param tier = 'GeneralPurpose'
// Non-required parameters
param autoGrow = 'Enabled'
param createMode = '<createMode>'
param highAvailability = 'Disabled'
param sourceServerResourceId = '<sourceServerResourceId>'
param storageSizeGB = 512
param version = '17'
```

</details>
<p>

### Example 8: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module flexibleServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>' = {
  params: {
    // Required parameters
    availabilityZone: 1
    name: 'dfpswaf001'
    skuName: 'Standard_D2s_v3'
    tier: 'GeneralPurpose'
    // Non-required parameters
    administrators: [
      {
        objectId: '<objectId>'
        principalName: '<principalName>'
        principalType: 'ServicePrincipal'
      }
    ]
    authConfig: {
      activeDirectoryAuth: 'Enabled'
      passwordAuth: 'Disabled'
    }
    configurations: [
      {
        name: 'log_min_messages'
        source: 'user-override'
        value: 'INFO'
      }
      {
        name: 'autovacuum_naptime'
        source: 'user-override'
        value: '80'
      }
    ]
    databases: [
      {
        charset: 'UTF8'
        collation: 'en_US.utf8'
        name: 'testdb1'
      }
      {
        name: 'testdb2'
      }
    ]
    delegatedSubnetResourceId: '<delegatedSubnetResourceId>'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    highAvailability: 'ZoneRedundant'
    maintenanceWindow: {
      customWindow: 'Enabled'
      dayOfWeek: 0
      startHour: 1
      startMinute: 0
    }
    privateDnsZoneArmResourceId: '<privateDnsZoneArmResourceId>'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "availabilityZone": {
      "value": 1
    },
    "name": {
      "value": "dfpswaf001"
    },
    "skuName": {
      "value": "Standard_D2s_v3"
    },
    "tier": {
      "value": "GeneralPurpose"
    },
    // Non-required parameters
    "administrators": {
      "value": [
        {
          "objectId": "<objectId>",
          "principalName": "<principalName>",
          "principalType": "ServicePrincipal"
        }
      ]
    },
    "authConfig": {
      "value": {
        "activeDirectoryAuth": "Enabled",
        "passwordAuth": "Disabled"
      }
    },
    "configurations": {
      "value": [
        {
          "name": "log_min_messages",
          "source": "user-override",
          "value": "INFO"
        },
        {
          "name": "autovacuum_naptime",
          "source": "user-override",
          "value": "80"
        }
      ]
    },
    "databases": {
      "value": [
        {
          "charset": "UTF8",
          "collation": "en_US.utf8",
          "name": "testdb1"
        },
        {
          "name": "testdb2"
        }
      ]
    },
    "delegatedSubnetResourceId": {
      "value": "<delegatedSubnetResourceId>"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "highAvailability": {
      "value": "ZoneRedundant"
    },
    "maintenanceWindow": {
      "value": {
        "customWindow": "Enabled",
        "dayOfWeek": 0,
        "startHour": 1,
        "startMinute": 0
      }
    },
    "privateDnsZoneArmResourceId": {
      "value": "<privateDnsZoneArmResourceId>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/db-for-postgre-sql/flexible-server:<version>'

// Required parameters
param availabilityZone = 1
param name = 'dfpswaf001'
param skuName = 'Standard_D2s_v3'
param tier = 'GeneralPurpose'
// Non-required parameters
param administrators = [
  {
    objectId: '<objectId>'
    principalName: '<principalName>'
    principalType: 'ServicePrincipal'
  }
]
param authConfig = {
  activeDirectoryAuth: 'Enabled'
  passwordAuth: 'Disabled'
}
param configurations = [
  {
    name: 'log_min_messages'
    source: 'user-override'
    value: 'INFO'
  }
  {
    name: 'autovacuum_naptime'
    source: 'user-override'
    value: '80'
  }
]
param databases = [
  {
    charset: 'UTF8'
    collation: 'en_US.utf8'
    name: 'testdb1'
  }
  {
    name: 'testdb2'
  }
]
param delegatedSubnetResourceId = '<delegatedSubnetResourceId>'
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param highAvailability = 'ZoneRedundant'
param maintenanceWindow = {
  customWindow: 'Enabled'
  dayOfWeek: 0
  startHour: 1
  startMinute: 0
}
param privateDnsZoneArmResourceId = '<privateDnsZoneArmResourceId>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZone`](#parameter-availabilityzone) | int | If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |
| [`name`](#parameter-name) | string | The name of the PostgreSQL flexible server. |
| [`skuName`](#parameter-skuname) | string | The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3. |
| [`tier`](#parameter-tier) | string | The tier of the particular SKU. Tier must align with the 'skuName' property. Example, tier cannot be 'Burstable' if skuName is 'Standard_D4s_v3'. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Required if 'cMKKeyName' is not empty. |
| [`pointInTimeUTC`](#parameter-pointintimeutc) | string | Required if 'createMode' is set to 'PointInTimeRestore'. |
| [`sourceServerResourceId`](#parameter-sourceserverresourceid) | string | Required if 'createMode' is set to 'PointInTimeRestore'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-administratorlogin) | string | The administrator login name of the server. Can only be specified when the PostgreSQL server is being created. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The administrator login password. |
| [`administrators`](#parameter-administrators) | array | The Azure AD administrators when AAD authentication enabled. |
| [`authConfig`](#parameter-authconfig) | object | The authentication configuration for the server. |
| [`autoGrow`](#parameter-autogrow) | string | Flag to enable / disable Storage Auto grow for flexible server. |
| [`backupRetentionDays`](#parameter-backupretentiondays) | int | Backup retention days for the server. |
| [`configurations`](#parameter-configurations) | array | The configurations to create in the server. |
| [`createMode`](#parameter-createmode) | string | The mode to create a new PostgreSQL server. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`databases`](#parameter-databases) | array | The databases to create in the server. |
| [`delegatedSubnetResourceId`](#parameter-delegatedsubnetresourceid) | string | Delegated subnet arm resource ID. Used when the desired connectivity mode is 'Private Access' - virtual network integration. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableAdvancedThreatProtection`](#parameter-enableadvancedthreatprotection) | bool | Enable/Disable advanced threat protection. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the PostgreSQL flexible server. |
| [`geoRedundantBackup`](#parameter-georedundantbackup) | string | A value indicating whether Geo-Redundant backup is enabled on the server. Should be disabled if 'cMKKeyName' is not empty. |
| [`highAvailability`](#parameter-highavailability) | string | The mode for high availability. |
| [`highAvailabilityZone`](#parameter-highavailabilityzone) | int | Standby availability zone information of the server. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Default will have no preference set. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | object | Properties for the maintenence window. If provided, 'customWindow' property must exist and set to 'Enabled'. |
| [`privateDnsZoneArmResourceId`](#parameter-privatednszonearmresourceid) | string | Private dns zone arm resource ID. Used when the desired connectivity mode is 'Private Access' and required when 'delegatedSubnetResourceId' is used. The Private DNS Zone must be linked to the Virtual Network referenced in 'delegatedSubnetResourceId'. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. Used when the desired connectivity mode is 'Public Access' and 'delegatedSubnetResourceId' is NOT used. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Determines whether or not public network access is enabled or disabled. |
| [`replica`](#parameter-replica) | object | The replication settings for the server. Can only be set on existing flexible servers. |
| [`replicationRole`](#parameter-replicationrole) | string | The replication role for the server. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`serverThreatProtection`](#parameter-serverthreatprotection) | string | Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server. |
| [`storageSizeGB`](#parameter-storagesizegb) | int | Max storage allowed for a server. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`version`](#parameter-version) | string | PostgreSQL Server version. |

### Parameter: `availabilityZone`

If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).

- Required: Yes
- Type: int
- Allowed:
  ```Bicep
  [
    -1
    1
    2
    3
  ]
  ```

### Parameter: `name`

The name of the PostgreSQL flexible server.

- Required: Yes
- Type: string

### Parameter: `skuName`

The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.

- Required: Yes
- Type: string

### Parameter: `tier`

The tier of the particular SKU. Tier must align with the 'skuName' property. Example, tier cannot be 'Burstable' if skuName is 'Standard_D4s_v3'.

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

The managed identity definition for this resource. Required if 'cMKKeyName' is not empty.

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

### Parameter: `pointInTimeUTC`

Required if 'createMode' is set to 'PointInTimeRestore'.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceServerResourceId`

Required if 'createMode' is set to 'PointInTimeRestore'.

- Required: No
- Type: string
- Default: `''`

### Parameter: `administratorLogin`

The administrator login name of the server. Can only be specified when the PostgreSQL server is being created.

- Required: No
- Type: string

### Parameter: `administratorLoginPassword`

The administrator login password.

- Required: No
- Type: securestring

### Parameter: `administrators`

The Azure AD administrators when AAD authentication enabled.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`objectId`](#parameter-administratorsobjectid) | string | The objectId of the Active Directory administrator. |
| [`principalName`](#parameter-administratorsprincipalname) | string | Active Directory administrator principal name. |
| [`principalType`](#parameter-administratorsprincipaltype) | string | The principal type used to represent the type of Active Directory Administrator. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tenantId`](#parameter-administratorstenantid) | string | The tenantId of the Active Directory administrator. |

### Parameter: `administrators.objectId`

The objectId of the Active Directory administrator.

- Required: Yes
- Type: string

### Parameter: `administrators.principalName`

Active Directory administrator principal name.

- Required: Yes
- Type: string

### Parameter: `administrators.principalType`

The principal type used to represent the type of Active Directory Administrator.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Group'
    'ServicePrincipal'
    'Unknown'
    'User'
  ]
  ```

### Parameter: `administrators.tenantId`

The tenantId of the Active Directory administrator.

- Required: No
- Type: string

### Parameter: `authConfig`

The authentication configuration for the server.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      activeDirectoryAuth: 'Enabled'
      passwordAuth: 'Disabled'
  }
  ```

### Parameter: `autoGrow`

Flag to enable / disable Storage Auto grow for flexible server.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `backupRetentionDays`

Backup retention days for the server.

- Required: No
- Type: int
- Default: `7`
- MinValue: 7
- MaxValue: 35

### Parameter: `configurations`

The configurations to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `createMode`

The mode to create a new PostgreSQL server.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Create'
    'Default'
    'GeoRestore'
    'PointInTimeRestore'
    'Replica'
    'Update'
  ]
  ```

### Parameter: `customerManagedKey`

The customer managed key definition.

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

### Parameter: `databases`

The databases to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `delegatedSubnetResourceId`

Delegated subnet arm resource ID. Used when the desired connectivity mode is 'Private Access' - virtual network integration.

- Required: No
- Type: string

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
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
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

The name of the diagnostic setting.

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

### Parameter: `enableAdvancedThreatProtection`

Enable/Disable advanced threat protection.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `firewallRules`

The firewall rules to create in the PostgreSQL flexible server.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIpAddress`](#parameter-firewallrulesendipaddress) | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| [`name`](#parameter-firewallrulesname) | string | The name of the PostgreSQL flexible server Firewall Rule. |
| [`startIpAddress`](#parameter-firewallrulesstartipaddress) | string | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |

### Parameter: `firewallRules.endIpAddress`

The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

### Parameter: `firewallRules.name`

The name of the PostgreSQL flexible server Firewall Rule.

- Required: Yes
- Type: string

### Parameter: `firewallRules.startIpAddress`

The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

### Parameter: `geoRedundantBackup`

A value indicating whether Geo-Redundant backup is enabled on the server. Should be disabled if 'cMKKeyName' is not empty.

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

The mode for high availability.

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

Standby availability zone information of the server. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Default will have no preference set.

- Required: No
- Type: int
- Default: `-1`
- Allowed:
  ```Bicep
  [
    -1
    1
    2
    3
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

### Parameter: `maintenanceWindow`

Properties for the maintenence window. If provided, 'customWindow' property must exist and set to 'Enabled'.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      customWindow: 'Enabled'
      dayOfWeek: 0
      startHour: 1
      startMinute: 0
  }
  ```

### Parameter: `privateDnsZoneArmResourceId`

Private dns zone arm resource ID. Used when the desired connectivity mode is 'Private Access' and required when 'delegatedSubnetResourceId' is used. The Private DNS Zone must be linked to the Virtual Network referenced in 'delegatedSubnetResourceId'.

- Required: No
- Type: string
- Default: `''`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. Used when the desired connectivity mode is 'Public Access' and 'delegatedSubnetResourceId' is NOT used.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the Private Endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-privateendpointslocknotes) | string | Specify the notes of the lock. |

### Parameter: `privateEndpoints.lock.kind`

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

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

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

### Parameter: `privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `publicNetworkAccess`

Determines whether or not public network access is enabled or disabled.

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

### Parameter: `replica`

The replication settings for the server. Can only be set on existing flexible servers.

- Required: No
- Type: object

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`promoteMode`](#parameter-replicapromotemode) | string | Sets the promote mode for a replica server. This is a write only property. Required if enabling replication. |
| [`promoteOption`](#parameter-replicapromoteoption) | string | Sets the promote options for a replica server. This is a write only property. Required if enabling replication. |
| [`role`](#parameter-replicarole) | string | Used to indicate role of the server in replication set. Required if enabling replication. |

### Parameter: `replica.promoteMode`

Sets the promote mode for a replica server. This is a write only property. Required if enabling replication.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'standalone'
    'switchover'
  ]
  ```

### Parameter: `replica.promoteOption`

Sets the promote options for a replica server. This is a write only property. Required if enabling replication.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'forced'
    'planned'
  ]
  ```

### Parameter: `replica.role`

Used to indicate role of the server in replication set. Required if enabling replication.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AsyncReplica'
    'GeoAsyncReplica'
    'None'
    'Primary'
  ]
  ```

### Parameter: `replicationRole`

The replication role for the server.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'AsyncReplica'
    'GeoAsyncReplica'
    'None'
    'Primary'
  ]
  ```

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

### Parameter: `serverThreatProtection`

Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server.

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

### Parameter: `storageSizeGB`

Max storage allowed for a server.

- Required: No
- Type: int
- Default: `32`
- Allowed:
  ```Bicep
  [
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

PostgreSQL Server version.

- Required: No
- Type: string
- Default: `'18'`
- Allowed:
  ```Bicep
  [
    '11'
    '12'
    '13'
    '14'
    '15'
    '16'
    '17'
    '18'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `fqdn` | string | The FQDN of the PostgreSQL Flexible server. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed PostgreSQL Flexible server. |
| `privateEndpoints` | array | The private endpoints of the PostgreSQL Flexible server. |
| `resourceGroupName` | string | The resource group of the deployed PostgreSQL Flexible server. |
| `resourceId` | string | The resource ID of the deployed PostgreSQL Flexible server. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned managed identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
