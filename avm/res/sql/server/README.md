# Azure SQL Servers `[Microsoft.Sql/servers]`

This module deploys an Azure SQL Server.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Sql/servers` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers) |
| `Microsoft.Sql/servers/auditingSettings` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/auditingSettings) |
| `Microsoft.Sql/servers/connectionPolicies` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/connectionPolicies) |
| `Microsoft.Sql/servers/databases` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/servers/elasticPools` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/elasticPools) |
| `Microsoft.Sql/servers/encryptionProtector` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/encryptionProtector) |
| `Microsoft.Sql/servers/failoverGroups` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/servers/failoverGroups) |
| `Microsoft.Sql/servers/firewallRules` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/firewallRules) |
| `Microsoft.Sql/servers/keys` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/keys) |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/securityAlertPolicies) |
| `Microsoft.Sql/servers/virtualNetworkRules` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/virtualNetworkRules) |
| `Microsoft.Sql/servers/vulnerabilityAssessments` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01/servers/vulnerabilityAssessments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/sql/server:<version>`.

- [With an administrator](#example-1-with-an-administrator)
- [With audit settings](#example-2-with-audit-settings)
- [Using Customer-Managed-Keys with User-Assigned identity](#example-3-using-customer-managed-keys-with-user-assigned-identity)
- [Using only defaults](#example-4-using-only-defaults)
- [Using elastic pool](#example-5-using-elastic-pool)
- [Using failover groups](#example-6-using-failover-groups)
- [Deploying with a key vault reference to save secrets](#example-7-deploying-with-a-key-vault-reference-to-save-secrets)
- [Using large parameter set](#example-8-using-large-parameter-set)
- [With a secondary database](#example-9-with-a-secondary-database)
- [With vulnerability assessment](#example-10-with-vulnerability-assessment)
- [WAF-aligned](#example-11-waf-aligned)

### Example 1: _With an administrator_

This instance deploys the module with a Microsoft Entra ID identity as SQL administrator.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'sqlsadmin'
    // Non-required parameters
    administrators: {
      azureADOnlyAuthentication: true
      login: 'myspn'
      principalType: 'Application'
      sid: '<sid>'
    }
    location: '<location>'
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
    "name": {
      "value": "sqlsadmin"
    },
    // Non-required parameters
    "administrators": {
      "value": {
        "azureADOnlyAuthentication": true,
        "login": "myspn",
        "principalType": "Application",
        "sid": "<sid>"
      }
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'sqlsadmin'
// Non-required parameters
param administrators = {
  azureADOnlyAuthentication: true
  login: 'myspn'
  principalType: 'Application'
  sid: '<sid>'
}
param location = '<location>'
```

</details>
<p>

### Example 2: _With audit settings_

This instance deploys the module with auditing settings.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'ssaud001'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    auditSettings: {
      isManagedIdentityInUse: true
      state: 'Enabled'
      storageAccountResourceId: '<storageAccountResourceId>'
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
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
    "name": {
      "value": "ssaud001"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "auditSettings": {
      "value": {
        "isManagedIdentityInUse": true,
        "state": "Enabled",
        "storageAccountResourceId": "<storageAccountResourceId>"
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
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
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'ssaud001'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param auditSettings = {
  isManagedIdentityInUse: true
  state: 'Enabled'
  storageAccountResourceId: '<storageAccountResourceId>'
}
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
}
```

</details>
<p>

### Example 3: _Using Customer-Managed-Keys with User-Assigned identity_

This instance deploys the module with Customer-Managed-Keys using a User-Assigned Identity to access the key.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'sscmk001'
    // Non-required parameters
    administrators: {
      azureADOnlyAuthentication: true
      login: 'myspn'
      principalType: 'Application'
      sid: '<sid>'
      tenantId: '<tenantId>'
    }
    customerManagedKey: {
      autoRotationEnabled: true
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      keyVersion: '<keyVersion>'
    }
    databases: [
      {
        availabilityZone: -1
        customerManagedKey: {
          autoRotationEnabled: true
          keyName: '<keyName>'
          keyVaultResourceId: '<keyVaultResourceId>'
          keyVersion: '<keyVersion>'
        }
        managedIdentities: {
          userAssignedResourceIds: [
            '<databaseIdentityResourceId>'
          ]
        }
        maxSizeBytes: 2147483648
        name: 'sscmk-db'
        sku: {
          name: 'Basic'
          tier: 'Basic'
        }
        zoneRedundant: false
      }
    ]
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityResourceId: '<primaryUserAssignedIdentityResourceId>'
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
    "name": {
      "value": "sscmk001"
    },
    // Non-required parameters
    "administrators": {
      "value": {
        "azureADOnlyAuthentication": true,
        "login": "myspn",
        "principalType": "Application",
        "sid": "<sid>",
        "tenantId": "<tenantId>"
      }
    },
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": true,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "keyVersion": "<keyVersion>"
      }
    },
    "databases": {
      "value": [
        {
          "availabilityZone": -1,
          "customerManagedKey": {
            "autoRotationEnabled": true,
            "keyName": "<keyName>",
            "keyVaultResourceId": "<keyVaultResourceId>",
            "keyVersion": "<keyVersion>"
          },
          "managedIdentities": {
            "userAssignedResourceIds": [
              "<databaseIdentityResourceId>"
            ]
          },
          "maxSizeBytes": 2147483648,
          "name": "sscmk-db",
          "sku": {
            "name": "Basic",
            "tier": "Basic"
          },
          "zoneRedundant": false
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "primaryUserAssignedIdentityResourceId": {
      "value": "<primaryUserAssignedIdentityResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'sscmk001'
// Non-required parameters
param administrators = {
  azureADOnlyAuthentication: true
  login: 'myspn'
  principalType: 'Application'
  sid: '<sid>'
  tenantId: '<tenantId>'
}
param customerManagedKey = {
  autoRotationEnabled: true
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  keyVersion: '<keyVersion>'
}
param databases = [
  {
    availabilityZone: -1
    customerManagedKey: {
      autoRotationEnabled: true
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      keyVersion: '<keyVersion>'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<databaseIdentityResourceId>'
      ]
    }
    maxSizeBytes: 2147483648
    name: 'sscmk-db'
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    zoneRedundant: false
  }
]
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityResourceId = '<primaryUserAssignedIdentityResourceId>'
```

</details>
<p>

### Example 4: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'ssmin001'
    // Non-required parameters
    administrators: {
      azureADOnlyAuthentication: true
      login: '<login>'
      principalType: 'Application'
      sid: '<sid>'
    }
    location: '<location>'
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
    "name": {
      "value": "ssmin001"
    },
    // Non-required parameters
    "administrators": {
      "value": {
        "azureADOnlyAuthentication": true,
        "login": "<login>",
        "principalType": "Application",
        "sid": "<sid>"
      }
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'ssmin001'
// Non-required parameters
param administrators = {
  azureADOnlyAuthentication: true
  login: '<login>'
  principalType: 'Application'
  sid: '<sid>'
}
param location = '<location>'
```

</details>
<p>

### Example 5: _Using elastic pool_

This instance deploys the module with an elastic pool.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'ssep001'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    elasticPools: [
      {
        availabilityZone: -1
        name: 'ssep-ep-001'
        zoneRedundant: false
      }
      {
        availabilityZone: -1
        name: 'ssep-ep-002'
        perDatabaseSettings: {
          maxCapacity: '4'
          minCapacity: '0.5'
        }
        sku: {
          capacity: 4
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
        }
        zoneRedundant: false
      }
    ]
    location: '<location>'
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
    "name": {
      "value": "ssep001"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "elasticPools": {
      "value": [
        {
          "availabilityZone": -1,
          "name": "ssep-ep-001",
          "zoneRedundant": false
        },
        {
          "availabilityZone": -1,
          "name": "ssep-ep-002",
          "perDatabaseSettings": {
            "maxCapacity": "4",
            "minCapacity": "0.5"
          },
          "sku": {
            "capacity": 4,
            "name": "GP_Gen5",
            "tier": "GeneralPurpose"
          },
          "zoneRedundant": false
        }
      ]
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'ssep001'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param elasticPools = [
  {
    availabilityZone: -1
    name: 'ssep-ep-001'
    zoneRedundant: false
  }
  {
    availabilityZone: -1
    name: 'ssep-ep-002'
    perDatabaseSettings: {
      maxCapacity: '4'
      minCapacity: '0.5'
    }
    sku: {
      capacity: 4
      name: 'GP_Gen5'
      tier: 'GeneralPurpose'
    }
    zoneRedundant: false
  }
]
param location = '<location>'
```

</details>
<p>

### Example 6: _Using failover groups_

This instance deploys the module with failover groups.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'ssfog001'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    databases: [
      {
        availabilityZone: -1
        maxSizeBytes: 2147483648
        name: 'ssfog-db1'
        sku: {
          name: 'S1'
          tier: 'Standard'
        }
        zoneRedundant: false
      }
      {
        availabilityZone: -1
        maxSizeBytes: 2147483648
        name: 'ssfog-db2'
        sku: {
          capacity: 2
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
        }
        zoneRedundant: false
      }
      {
        availabilityZone: -1
        maxSizeBytes: 2147483648
        name: 'ssfog-db3'
        sku: {
          name: 'S1'
          tier: 'Standard'
        }
        zoneRedundant: false
      }
    ]
    failoverGroups: [
      {
        databases: [
          'ssfog-db1'
        ]
        name: 'ssfog-fg-geo'
        partnerServers: [
          '<secondaryServerName>'
        ]
        readWriteEndpoint: {
          failoverPolicy: 'Manual'
        }
        secondaryType: 'Geo'
      }
      {
        databases: [
          'ssfog-db2'
        ]
        name: 'ssfog-fg-standby'
        partnerServers: [
          '<secondaryServerName>'
        ]
        readWriteEndpoint: {
          failoverPolicy: 'Automatic'
          failoverWithDataLossGracePeriodMinutes: 60
        }
        secondaryType: 'Standby'
      }
      {
        databases: [
          'ssfog-db3'
        ]
        name: 'ssfog-fg-readonly'
        partnerServers: [
          '<secondaryServerName>'
        ]
        readOnlyEndpoint: {
          failoverPolicy: 'Enabled'
          targetServer: '<targetServer>'
        }
        readWriteEndpoint: {
          failoverPolicy: 'Manual'
        }
        secondaryType: 'Geo'
      }
    ]
    location: '<location>'
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
    "name": {
      "value": "ssfog001"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
          "availabilityZone": -1,
          "maxSizeBytes": 2147483648,
          "name": "ssfog-db1",
          "sku": {
            "name": "S1",
            "tier": "Standard"
          },
          "zoneRedundant": false
        },
        {
          "availabilityZone": -1,
          "maxSizeBytes": 2147483648,
          "name": "ssfog-db2",
          "sku": {
            "capacity": 2,
            "name": "GP_Gen5",
            "tier": "GeneralPurpose"
          },
          "zoneRedundant": false
        },
        {
          "availabilityZone": -1,
          "maxSizeBytes": 2147483648,
          "name": "ssfog-db3",
          "sku": {
            "name": "S1",
            "tier": "Standard"
          },
          "zoneRedundant": false
        }
      ]
    },
    "failoverGroups": {
      "value": [
        {
          "databases": [
            "ssfog-db1"
          ],
          "name": "ssfog-fg-geo",
          "partnerServers": [
            "<secondaryServerName>"
          ],
          "readWriteEndpoint": {
            "failoverPolicy": "Manual"
          },
          "secondaryType": "Geo"
        },
        {
          "databases": [
            "ssfog-db2"
          ],
          "name": "ssfog-fg-standby",
          "partnerServers": [
            "<secondaryServerName>"
          ],
          "readWriteEndpoint": {
            "failoverPolicy": "Automatic",
            "failoverWithDataLossGracePeriodMinutes": 60
          },
          "secondaryType": "Standby"
        },
        {
          "databases": [
            "ssfog-db3"
          ],
          "name": "ssfog-fg-readonly",
          "partnerServers": [
            "<secondaryServerName>"
          ],
          "readOnlyEndpoint": {
            "failoverPolicy": "Enabled",
            "targetServer": "<targetServer>"
          },
          "readWriteEndpoint": {
            "failoverPolicy": "Manual"
          },
          "secondaryType": "Geo"
        }
      ]
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'ssfog001'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param databases = [
  {
    availabilityZone: -1
    maxSizeBytes: 2147483648
    name: 'ssfog-db1'
    sku: {
      name: 'S1'
      tier: 'Standard'
    }
    zoneRedundant: false
  }
  {
    availabilityZone: -1
    maxSizeBytes: 2147483648
    name: 'ssfog-db2'
    sku: {
      capacity: 2
      name: 'GP_Gen5'
      tier: 'GeneralPurpose'
    }
    zoneRedundant: false
  }
  {
    availabilityZone: -1
    maxSizeBytes: 2147483648
    name: 'ssfog-db3'
    sku: {
      name: 'S1'
      tier: 'Standard'
    }
    zoneRedundant: false
  }
]
param failoverGroups = [
  {
    databases: [
      'ssfog-db1'
    ]
    name: 'ssfog-fg-geo'
    partnerServers: [
      '<secondaryServerName>'
    ]
    readWriteEndpoint: {
      failoverPolicy: 'Manual'
    }
    secondaryType: 'Geo'
  }
  {
    databases: [
      'ssfog-db2'
    ]
    name: 'ssfog-fg-standby'
    partnerServers: [
      '<secondaryServerName>'
    ]
    readWriteEndpoint: {
      failoverPolicy: 'Automatic'
      failoverWithDataLossGracePeriodMinutes: 60
    }
    secondaryType: 'Standby'
  }
  {
    databases: [
      'ssfog-db3'
    ]
    name: 'ssfog-fg-readonly'
    partnerServers: [
      '<secondaryServerName>'
    ]
    readOnlyEndpoint: {
      failoverPolicy: 'Enabled'
      targetServer: '<targetServer>'
    }
    readWriteEndpoint: {
      failoverPolicy: 'Manual'
    }
    secondaryType: 'Geo'
  }
]
param location = '<location>'
```

</details>
<p>

### Example 7: _Deploying with a key vault reference to save secrets_

This instance deploys the module saving all its secrets in a key vault.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'sqlkvs001'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    databases: [
      {
        availabilityZone: -1
        name: 'myDatabase'
        zoneRedundant: false
      }
    ]
    location: '<location>'
    secretsExportConfiguration: {
      keyVaultResourceId: '<keyVaultResourceId>'
      sqlAdminPasswordSecretName: 'adminLoginPasswordKey'
      sqlAzureConnectionStringSecretName: 'sqlConnectionStringKey'
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
    "name": {
      "value": "sqlkvs001"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
          "availabilityZone": -1,
          "name": "myDatabase",
          "zoneRedundant": false
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "secretsExportConfiguration": {
      "value": {
        "keyVaultResourceId": "<keyVaultResourceId>",
        "sqlAdminPasswordSecretName": "adminLoginPasswordKey",
        "sqlAzureConnectionStringSecretName": "sqlConnectionStringKey"
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
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'sqlkvs001'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param databases = [
  {
    availabilityZone: -1
    name: 'myDatabase'
    zoneRedundant: false
  }
]
param location = '<location>'
param secretsExportConfiguration = {
  keyVaultResourceId: '<keyVaultResourceId>'
  sqlAdminPasswordSecretName: 'adminLoginPasswordKey'
  sqlAzureConnectionStringSecretName: 'sqlConnectionStringKey'
}
```

</details>
<p>

### Example 8: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'sqlsmax'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    customerManagedKey: {
      autoRotationEnabled: true
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      keyVersion: '<keyVersion>'
    }
    databases: [
      {
        availabilityZone: -1
        backupLongTermRetentionPolicy: {
          monthlyRetention: 'P6M'
        }
        backupShortTermRetentionPolicy: {
          retentionDays: 14
        }
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        customerManagedKey: {
          autoRotationEnabled: true
          keyName: '<keyName>'
          keyVaultResourceId: '<keyVaultResourceId>'
          keyVersion: '<keyVersion>'
        }
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        elasticPoolResourceId: '<elasticPoolResourceId>'
        licenseType: 'LicenseIncluded'
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
        managedIdentities: {
          userAssignedResourceIds: [
            '<databaseIdentityResourceId>'
          ]
        }
        maxSizeBytes: 34359738368
        name: 'sqlsmaxdb-001'
        sku: {
          capacity: 0
          name: 'ElasticPool'
          tier: 'GeneralPurpose'
        }
      }
    ]
    elasticPools: [
      {
        availabilityZone: -1
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
        name: 'sqlsmax-ep-001'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'SQL DB Contributor'
          }
        ]
        sku: {
          capacity: 10
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
        }
      }
    ]
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<serverIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityResourceId: '<primaryUserAssignedIdentityResourceId>'
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
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    restrictOutboundNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        name: '7027a5c5-d1b1-49e0-80cc-ffdff3a3ada9'
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
    securityAlertPolicies: [
      {
        emailAccountAdmins: true
        name: 'Default'
        state: 'Enabled'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualNetworkRules: [
      {
        ignoreMissingVnetServiceEndpoint: true
        name: 'newVnetRule1'
        virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
      }
    ]
    vulnerabilityAssessmentsObj: {
      name: 'default'
      recurringScans: {
        emails: [
          'test1@contoso.com'
          'test2@contoso.com'
        ]
        emailSubscriptionAdmins: true
        isEnabled: true
      }
      storageAccountResourceId: '<storageAccountResourceId>'
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
    "name": {
      "value": "sqlsmax"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": true,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "keyVersion": "<keyVersion>"
      }
    },
    "databases": {
      "value": [
        {
          "availabilityZone": -1,
          "backupLongTermRetentionPolicy": {
            "monthlyRetention": "P6M"
          },
          "backupShortTermRetentionPolicy": {
            "retentionDays": 14
          },
          "collation": "SQL_Latin1_General_CP1_CI_AS",
          "customerManagedKey": {
            "autoRotationEnabled": true,
            "keyName": "<keyName>",
            "keyVaultResourceId": "<keyVaultResourceId>",
            "keyVersion": "<keyVersion>"
          },
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "elasticPoolResourceId": "<elasticPoolResourceId>",
          "licenseType": "LicenseIncluded",
          "lock": {
            "kind": "CanNotDelete",
            "name": "myCustomLockName"
          },
          "managedIdentities": {
            "userAssignedResourceIds": [
              "<databaseIdentityResourceId>"
            ]
          },
          "maxSizeBytes": 34359738368,
          "name": "sqlsmaxdb-001",
          "sku": {
            "capacity": 0,
            "name": "ElasticPool",
            "tier": "GeneralPurpose"
          }
        }
      ]
    },
    "elasticPools": {
      "value": [
        {
          "availabilityZone": -1,
          "lock": {
            "kind": "CanNotDelete",
            "name": "myCustomLockName"
          },
          "name": "sqlsmax-ep-001",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "SQL DB Contributor"
            }
          ],
          "sku": {
            "capacity": 10,
            "name": "GP_Gen5",
            "tier": "GeneralPurpose"
          }
        }
      ]
    },
    "firewallRules": {
      "value": [
        {
          "endIpAddress": "0.0.0.0",
          "name": "AllowAllWindowsAzureIps",
          "startIpAddress": "0.0.0.0"
        }
      ]
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
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<serverIdentityResourceId>"
        ]
      }
    },
    "primaryUserAssignedIdentityResourceId": {
      "value": "<primaryUserAssignedIdentityResourceId>"
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
        },
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "restrictOutboundNetworkAccess": {
      "value": "Disabled"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "7027a5c5-d1b1-49e0-80cc-ffdff3a3ada9",
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
    "securityAlertPolicies": {
      "value": [
        {
          "emailAccountAdmins": true,
          "name": "Default",
          "state": "Enabled"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualNetworkRules": {
      "value": [
        {
          "ignoreMissingVnetServiceEndpoint": true,
          "name": "newVnetRule1",
          "virtualNetworkSubnetResourceId": "<virtualNetworkSubnetResourceId>"
        }
      ]
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "name": "default",
        "recurringScans": {
          "emails": [
            "test1@contoso.com",
            "test2@contoso.com"
          ],
          "emailSubscriptionAdmins": true,
          "isEnabled": true
        },
        "storageAccountResourceId": "<storageAccountResourceId>"
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
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'sqlsmax'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param customerManagedKey = {
  autoRotationEnabled: true
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  keyVersion: '<keyVersion>'
}
param databases = [
  {
    availabilityZone: -1
    backupLongTermRetentionPolicy: {
      monthlyRetention: 'P6M'
    }
    backupShortTermRetentionPolicy: {
      retentionDays: 14
    }
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    customerManagedKey: {
      autoRotationEnabled: true
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      keyVersion: '<keyVersion>'
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    elasticPoolResourceId: '<elasticPoolResourceId>'
    licenseType: 'LicenseIncluded'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<databaseIdentityResourceId>'
      ]
    }
    maxSizeBytes: 34359738368
    name: 'sqlsmaxdb-001'
    sku: {
      capacity: 0
      name: 'ElasticPool'
      tier: 'GeneralPurpose'
    }
  }
]
param elasticPools = [
  {
    availabilityZone: -1
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    name: 'sqlsmax-ep-001'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'SQL DB Contributor'
      }
    ]
    sku: {
      capacity: 10
      name: 'GP_Gen5'
      tier: 'GeneralPurpose'
    }
  }
]
param firewallRules = [
  {
    endIpAddress: '0.0.0.0'
    name: 'AllowAllWindowsAzureIps'
    startIpAddress: '0.0.0.0'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<serverIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityResourceId = '<primaryUserAssignedIdentityResourceId>'
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
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
  }
]
param restrictOutboundNetworkAccess = 'Disabled'
param roleAssignments = [
  {
    name: '7027a5c5-d1b1-49e0-80cc-ffdff3a3ada9'
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
param securityAlertPolicies = [
  {
    emailAccountAdmins: true
    name: 'Default'
    state: 'Enabled'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualNetworkRules = [
  {
    ignoreMissingVnetServiceEndpoint: true
    name: 'newVnetRule1'
    virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
  }
]
param vulnerabilityAssessmentsObj = {
  name: 'default'
  recurringScans: {
    emails: [
      'test1@contoso.com'
      'test2@contoso.com'
    ]
    emailSubscriptionAdmins: true
    isEnabled: true
  }
  storageAccountResourceId: '<storageAccountResourceId>'
}
```

</details>
<p>

### Example 9: _With a secondary database_

This instance deploys the module with a secondary database.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'sqlsec-sec'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    databases: [
      {
        availabilityZone: -1
        createMode: 'Secondary'
        maxSizeBytes: 2147483648
        name: '<name>'
        sku: {
          name: 'Basic'
          tier: 'Basic'
        }
        sourceDatabaseResourceId: '<sourceDatabaseResourceId>'
        zoneRedundant: false
      }
    ]
    location: '<location>'
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
    "name": {
      "value": "sqlsec-sec"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
          "availabilityZone": -1,
          "createMode": "Secondary",
          "maxSizeBytes": 2147483648,
          "name": "<name>",
          "sku": {
            "name": "Basic",
            "tier": "Basic"
          },
          "sourceDatabaseResourceId": "<sourceDatabaseResourceId>",
          "zoneRedundant": false
        }
      ]
    },
    "location": {
      "value": "<location>"
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
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'sqlsec-sec'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param databases = [
  {
    availabilityZone: -1
    createMode: 'Secondary'
    maxSizeBytes: 2147483648
    name: '<name>'
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    sourceDatabaseResourceId: '<sourceDatabaseResourceId>'
    zoneRedundant: false
  }
]
param location = '<location>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 10: _With vulnerability assessment_

This instance deploys the module with a vulnerability assessment.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'sqlsvln'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityResourceId: '<primaryUserAssignedIdentityResourceId>'
    securityAlertPolicies: [
      {
        emailAccountAdmins: true
        name: 'Default'
        state: 'Enabled'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vulnerabilityAssessmentsObj: {
      createStorageRoleAssignment: true
      name: 'default'
      recurringScans: {
        emails: [
          'test1@contoso.com'
          'test2@contoso.com'
        ]
        emailSubscriptionAdmins: true
        isEnabled: true
      }
      storageAccountResourceId: '<storageAccountResourceId>'
      useStorageAccountAccessKey: false
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
    "name": {
      "value": "sqlsvln"
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "primaryUserAssignedIdentityResourceId": {
      "value": "<primaryUserAssignedIdentityResourceId>"
    },
    "securityAlertPolicies": {
      "value": [
        {
          "emailAccountAdmins": true,
          "name": "Default",
          "state": "Enabled"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "createStorageRoleAssignment": true,
        "name": "default",
        "recurringScans": {
          "emails": [
            "test1@contoso.com",
            "test2@contoso.com"
          ],
          "emailSubscriptionAdmins": true,
          "isEnabled": true
        },
        "storageAccountResourceId": "<storageAccountResourceId>",
        "useStorageAccountAccessKey": false
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
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'sqlsvln'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityResourceId = '<primaryUserAssignedIdentityResourceId>'
param securityAlertPolicies = [
  {
    emailAccountAdmins: true
    name: 'Default'
    state: 'Enabled'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param vulnerabilityAssessmentsObj = {
  createStorageRoleAssignment: true
  name: 'default'
  recurringScans: {
    emails: [
      'test1@contoso.com'
      'test2@contoso.com'
    ]
    emailSubscriptionAdmins: true
    isEnabled: true
  }
  storageAccountResourceId: '<storageAccountResourceId>'
  useStorageAccountAccessKey: false
}
```

</details>
<p>

### Example 11: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module server 'br/public:avm/res/sql/server:<version>' = {
  name: 'serverDeployment'
  params: {
    // Required parameters
    name: 'sqlswaf'
    // Non-required parameters
    administrators: {
      azureADOnlyAuthentication: true
      login: 'myspn'
      principalType: 'Application'
      sid: '<sid>'
      tenantId: '<tenantId>'
    }
    connectionPolicy: 'Redirect'
    customerManagedKey: {
      autoRotationEnabled: true
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      keyVersion: '<keyVersion>'
    }
    databases: [
      {
        availabilityZone: 1
        backupLongTermRetentionPolicy: {
          monthlyRetention: 'P6M'
        }
        backupShortTermRetentionPolicy: {
          retentionDays: 14
        }
        collation: 'SQL_Latin1_General_CP1_CI_AS'
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        elasticPoolResourceId: '<elasticPoolResourceId>'
        licenseType: 'LicenseIncluded'
        maxSizeBytes: 34359738368
        name: 'sqlswafdb-001'
        sku: {
          capacity: 0
          name: 'ElasticPool'
          tier: 'GeneralPurpose'
        }
      }
    ]
    elasticPools: [
      {
        availabilityZone: -1
        maintenanceConfigurationId: '<maintenanceConfigurationId>'
        name: 'sqlswaf-ep-001'
        sku: {
          capacity: 10
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
        }
      }
    ]
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityResourceId: '<primaryUserAssignedIdentityResourceId>'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'sqlServer'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    restrictOutboundNetworkAccess: 'Disabled'
    securityAlertPolicies: [
      {
        emailAccountAdmins: true
        name: 'Default'
        state: 'Enabled'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualNetworkRules: [
      {
        ignoreMissingVnetServiceEndpoint: true
        name: 'newVnetRule1'
        virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
      }
    ]
    vulnerabilityAssessmentsObj: {
      name: 'default'
      recurringScans: {
        emails: [
          'test1@contoso.com'
          'test2@contoso.com'
        ]
        emailSubscriptionAdmins: true
        isEnabled: true
      }
      storageAccountResourceId: '<storageAccountResourceId>'
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
    "name": {
      "value": "sqlswaf"
    },
    // Non-required parameters
    "administrators": {
      "value": {
        "azureADOnlyAuthentication": true,
        "login": "myspn",
        "principalType": "Application",
        "sid": "<sid>",
        "tenantId": "<tenantId>"
      }
    },
    "connectionPolicy": {
      "value": "Redirect"
    },
    "customerManagedKey": {
      "value": {
        "autoRotationEnabled": true,
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "keyVersion": "<keyVersion>"
      }
    },
    "databases": {
      "value": [
        {
          "availabilityZone": 1,
          "backupLongTermRetentionPolicy": {
            "monthlyRetention": "P6M"
          },
          "backupShortTermRetentionPolicy": {
            "retentionDays": 14
          },
          "collation": "SQL_Latin1_General_CP1_CI_AS",
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "elasticPoolResourceId": "<elasticPoolResourceId>",
          "licenseType": "LicenseIncluded",
          "maxSizeBytes": 34359738368,
          "name": "sqlswafdb-001",
          "sku": {
            "capacity": 0,
            "name": "ElasticPool",
            "tier": "GeneralPurpose"
          }
        }
      ]
    },
    "elasticPools": {
      "value": [
        {
          "availabilityZone": -1,
          "maintenanceConfigurationId": "<maintenanceConfigurationId>",
          "name": "sqlswaf-ep-001",
          "sku": {
            "capacity": 10,
            "name": "GP_Gen5",
            "tier": "GeneralPurpose"
          }
        }
      ]
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
    "primaryUserAssignedIdentityResourceId": {
      "value": "<primaryUserAssignedIdentityResourceId>"
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
          "service": "sqlServer",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "restrictOutboundNetworkAccess": {
      "value": "Disabled"
    },
    "securityAlertPolicies": {
      "value": [
        {
          "emailAccountAdmins": true,
          "name": "Default",
          "state": "Enabled"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualNetworkRules": {
      "value": [
        {
          "ignoreMissingVnetServiceEndpoint": true,
          "name": "newVnetRule1",
          "virtualNetworkSubnetResourceId": "<virtualNetworkSubnetResourceId>"
        }
      ]
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "name": "default",
        "recurringScans": {
          "emails": [
            "test1@contoso.com",
            "test2@contoso.com"
          ],
          "emailSubscriptionAdmins": true,
          "isEnabled": true
        },
        "storageAccountResourceId": "<storageAccountResourceId>"
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
using 'br/public:avm/res/sql/server:<version>'

// Required parameters
param name = 'sqlswaf'
// Non-required parameters
param administrators = {
  azureADOnlyAuthentication: true
  login: 'myspn'
  principalType: 'Application'
  sid: '<sid>'
  tenantId: '<tenantId>'
}
param connectionPolicy = 'Redirect'
param customerManagedKey = {
  autoRotationEnabled: true
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  keyVersion: '<keyVersion>'
}
param databases = [
  {
    availabilityZone: 1
    backupLongTermRetentionPolicy: {
      monthlyRetention: 'P6M'
    }
    backupShortTermRetentionPolicy: {
      retentionDays: 14
    }
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    elasticPoolResourceId: '<elasticPoolResourceId>'
    licenseType: 'LicenseIncluded'
    maxSizeBytes: 34359738368
    name: 'sqlswafdb-001'
    sku: {
      capacity: 0
      name: 'ElasticPool'
      tier: 'GeneralPurpose'
    }
  }
]
param elasticPools = [
  {
    availabilityZone: -1
    maintenanceConfigurationId: '<maintenanceConfigurationId>'
    name: 'sqlswaf-ep-001'
    sku: {
      capacity: 10
      name: 'GP_Gen5'
      tier: 'GeneralPurpose'
    }
  }
]
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityResourceId = '<primaryUserAssignedIdentityResourceId>'
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'sqlServer'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param restrictOutboundNetworkAccess = 'Disabled'
param securityAlertPolicies = [
  {
    emailAccountAdmins: true
    name: 'Default'
    state: 'Enabled'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualNetworkRules = [
  {
    ignoreMissingVnetServiceEndpoint: true
    name: 'newVnetRule1'
    virtualNetworkSubnetResourceId: '<virtualNetworkSubnetResourceId>'
  }
]
param vulnerabilityAssessmentsObj = {
  name: 'default'
  recurringScans: {
    emails: [
      'test1@contoso.com'
      'test2@contoso.com'
    ]
    emailSubscriptionAdmins: true
    isEnabled: true
  }
  storageAccountResourceId: '<storageAccountResourceId>'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the server. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-administratorlogin) | string | The administrator username for the server. Required if no `administrators` object for AAD authentication is provided. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The administrator login password. Required if no `administrators` object for AAD authentication is provided. |
| [`administrators`](#parameter-administrators) | object | The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided. |
| [`primaryUserAssignedIdentityResourceId`](#parameter-primaryuserassignedidentityresourceid) | string | The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auditSettings`](#parameter-auditsettings) | object | The audit settings configuration. If you want to disable auditing, set the parmaeter to an empty object. |
| [`connectionPolicy`](#parameter-connectionpolicy) | string | SQL logical server connection policy. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition for server TDE. |
| [`databases`](#parameter-databases) | array | The databases to create in the server. |
| [`elasticPools`](#parameter-elasticpools) | array | The Elastic Pools to create in the server. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`failoverGroups`](#parameter-failovergroups) | array | The failover groups configuration. |
| [`federatedClientId`](#parameter-federatedclientid) | string | The Client id used for cross tenant CMK scenario. |
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the server. |
| [`isIPv6Enabled`](#parameter-isipv6enabled) | string | Whether or not to enable IPv6 support for this server. |
| [`keys`](#parameter-keys) | array | The keys to configure. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`minimalTlsVersion`](#parameter-minimaltlsversion) | string | Minimal TLS version allowed. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set. |
| [`restrictOutboundNetworkAccess`](#parameter-restrictoutboundnetworkaccess) | string | Whether or not to restrict outbound network access for this server. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`secretsExportConfiguration`](#parameter-secretsexportconfiguration) | object | Key vault reference and secret settings for the module's secrets export. |
| [`securityAlertPolicies`](#parameter-securityalertpolicies) | array | The security alert policies to create in the server. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualNetworkRules`](#parameter-virtualnetworkrules) | array | The virtual network rules to create in the server. |
| [`vulnerabilityAssessmentsObj`](#parameter-vulnerabilityassessmentsobj) | object | The vulnerability assessment configuration. |

### Parameter: `name`

The name of the server.

- Required: Yes
- Type: string

### Parameter: `administratorLogin`

The administrator username for the server. Required if no `administrators` object for AAD authentication is provided.

- Required: No
- Type: string

### Parameter: `administratorLoginPassword`

The administrator login password. Required if no `administrators` object for AAD authentication is provided.

- Required: No
- Type: securestring

### Parameter: `administrators`

The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureADOnlyAuthentication`](#parameter-administratorsazureadonlyauthentication) | bool | Azure Active Directory only Authentication enabled. |
| [`login`](#parameter-administratorslogin) | string | Login name of the server administrator. |
| [`principalType`](#parameter-administratorsprincipaltype) | string | Principal Type of the sever administrator. |
| [`sid`](#parameter-administratorssid) | string | SID (object ID) of the server administrator. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorType`](#parameter-administratorsadministratortype) | string | Type of the sever administrator. |
| [`tenantId`](#parameter-administratorstenantid) | string | Tenant ID of the administrator. |

### Parameter: `administrators.azureADOnlyAuthentication`

Azure Active Directory only Authentication enabled.

- Required: Yes
- Type: bool

### Parameter: `administrators.login`

Login name of the server administrator.

- Required: Yes
- Type: string

### Parameter: `administrators.principalType`

Principal Type of the sever administrator.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Application'
    'Group'
    'User'
  ]
  ```

### Parameter: `administrators.sid`

SID (object ID) of the server administrator.

- Required: Yes
- Type: string

### Parameter: `administrators.administratorType`

Type of the sever administrator.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ActiveDirectory'
  ]
  ```

### Parameter: `administrators.tenantId`

Tenant ID of the administrator.

- Required: No
- Type: string

### Parameter: `primaryUserAssignedIdentityResourceId`

The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.

- Required: No
- Type: string

### Parameter: `auditSettings`

The audit settings configuration. If you want to disable auditing, set the parmaeter to an empty object.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      state: 'Enabled'
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auditActionsAndGroups`](#parameter-auditsettingsauditactionsandgroups) | array | Specifies the Actions-Groups and Actions to audit. |
| [`isAzureMonitorTargetEnabled`](#parameter-auditsettingsisazuremonitortargetenabled) | bool | Specifies whether audit events are sent to Azure Monitor. |
| [`isDevopsAuditEnabled`](#parameter-auditsettingsisdevopsauditenabled) | bool | Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor. |
| [`isManagedIdentityInUse`](#parameter-auditsettingsismanagedidentityinuse) | bool | Specifies whether Managed Identity is used to access blob storage. |
| [`isStorageSecondaryKeyInUse`](#parameter-auditsettingsisstoragesecondarykeyinuse) | bool | Specifies whether storageAccountAccessKey value is the storage's secondary key. |
| [`name`](#parameter-auditsettingsname) | string | Specifies the name of the audit settings. |
| [`queueDelayMs`](#parameter-auditsettingsqueuedelayms) | int | Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed. |
| [`retentionDays`](#parameter-auditsettingsretentiondays) | int | Specifies the number of days to keep in the audit logs in the storage account. |
| [`state`](#parameter-auditsettingsstate) | string | Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required. |
| [`storageAccountResourceId`](#parameter-auditsettingsstorageaccountresourceid) | string | Specifies the identifier key of the auditing storage account. |

### Parameter: `auditSettings.auditActionsAndGroups`

Specifies the Actions-Groups and Actions to audit.

- Required: No
- Type: array

### Parameter: `auditSettings.isAzureMonitorTargetEnabled`

Specifies whether audit events are sent to Azure Monitor.

- Required: No
- Type: bool

### Parameter: `auditSettings.isDevopsAuditEnabled`

Specifies the state of devops audit. If state is Enabled, devops logs will be sent to Azure Monitor.

- Required: No
- Type: bool

### Parameter: `auditSettings.isManagedIdentityInUse`

Specifies whether Managed Identity is used to access blob storage.

- Required: No
- Type: bool

### Parameter: `auditSettings.isStorageSecondaryKeyInUse`

Specifies whether storageAccountAccessKey value is the storage's secondary key.

- Required: No
- Type: bool

### Parameter: `auditSettings.name`

Specifies the name of the audit settings.

- Required: No
- Type: string

### Parameter: `auditSettings.queueDelayMs`

Specifies the amount of time in milliseconds that can elapse before audit actions are forced to be processed.

- Required: No
- Type: int

### Parameter: `auditSettings.retentionDays`

Specifies the number of days to keep in the audit logs in the storage account.

- Required: No
- Type: int

### Parameter: `auditSettings.state`

Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `auditSettings.storageAccountResourceId`

Specifies the identifier key of the auditing storage account.

- Required: No
- Type: string

### Parameter: `connectionPolicy`

SQL logical server connection policy.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'Proxy'
    'Redirect'
  ]
  ```

### Parameter: `customerManagedKey`

The customer managed key definition for server TDE.

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZone`](#parameter-databasesavailabilityzone) | int | If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |
| [`name`](#parameter-databasesname) | string | The name of the Elastic Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-databasesautopausedelay) | int | Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. |
| [`backupLongTermRetentionPolicy`](#parameter-databasesbackuplongtermretentionpolicy) | object | The long term backup retention policy for the database. |
| [`backupShortTermRetentionPolicy`](#parameter-databasesbackupshorttermretentionpolicy) | object | The short term backup retention policy for the database. |
| [`catalogCollation`](#parameter-databasescatalogcollation) | string | Collation of the metadata catalog. |
| [`collation`](#parameter-databasescollation) | string | The collation of the database. |
| [`createMode`](#parameter-databasescreatemode) | string | Specifies the mode of database creation. |
| [`customerManagedKey`](#parameter-databasescustomermanagedkey) | object | The customer managed key definition for database TDE. |
| [`diagnosticSettings`](#parameter-databasesdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`elasticPoolResourceId`](#parameter-databaseselasticpoolresourceid) | string | The resource identifier of the elastic pool containing this database. |
| [`federatedClientId`](#parameter-databasesfederatedclientid) | string | The Client id used for cross tenant per database CMK scenario. |
| [`freeLimitExhaustionBehavior`](#parameter-databasesfreelimitexhaustionbehavior) | string | Specifies the behavior when monthly free limits are exhausted for the free database. |
| [`highAvailabilityReplicaCount`](#parameter-databaseshighavailabilityreplicacount) | int | The number of secondary replicas associated with the database that are used to provide high availability. Not applicable to a Hyperscale database within an elastic pool. |
| [`isLedgerOn`](#parameter-databasesisledgeron) | bool | Whether or not this database is a ledger database, which means all tables in the database are ledger tables. |
| [`licenseType`](#parameter-databaseslicensetype) | string | The license type to apply for this database. |
| [`lock`](#parameter-databaseslock) | object | The lock settings of the database. |
| [`longTermRetentionBackupResourceId`](#parameter-databaseslongtermretentionbackupresourceid) | string | The resource identifier of the long term retention backup associated with create operation of this database. |
| [`maintenanceConfigurationId`](#parameter-databasesmaintenanceconfigurationid) | string | Maintenance configuration id assigned to the database. This configuration defines the period when the maintenance updates will occur. |
| [`managedIdentities`](#parameter-databasesmanagedidentities) | object | The managed identities for the database. |
| [`manualCutover`](#parameter-databasesmanualcutover) | bool | Whether or not customer controlled manual cutover needs to be done during Update Database operation to Hyperscale tier. |
| [`maxSizeBytes`](#parameter-databasesmaxsizebytes) | int | The max size of the database expressed in bytes. |
| [`minCapacity`](#parameter-databasesmincapacity) | string | Minimal capacity that database will always have allocated, if not paused. |
| [`performCutover`](#parameter-databasesperformcutover) | bool | To trigger customer controlled manual cutover during the wait state while Scaling operation is in progress. |
| [`preferredEnclaveType`](#parameter-databasespreferredenclavetype) | string | Type of enclave requested on the database. |
| [`readScale`](#parameter-databasesreadscale) | string | The state of read-only routing. If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica in the same region. Not applicable to a Hyperscale database within an elastic pool. |
| [`recoverableDatabaseResourceId`](#parameter-databasesrecoverabledatabaseresourceid) | string | The resource identifier of the recoverable database associated with create operation of this database. |
| [`recoveryServicesRecoveryPointResourceId`](#parameter-databasesrecoveryservicesrecoverypointresourceid) | string | The resource identifier of the recovery point associated with create operation of this database. |
| [`requestedBackupStorageRedundancy`](#parameter-databasesrequestedbackupstorageredundancy) | string | The storage account type to be used to store backups for this database. |
| [`restorableDroppedDatabaseResourceId`](#parameter-databasesrestorabledroppeddatabaseresourceid) | string | The resource identifier of the restorable dropped database associated with create operation of this database. |
| [`restorePointInTime`](#parameter-databasesrestorepointintime) | string | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| [`sampleName`](#parameter-databasessamplename) | string | The name of the sample schema to apply when creating this database. |
| [`secondaryType`](#parameter-databasessecondarytype) | string | The secondary type of the database if it is a secondary. |
| [`sku`](#parameter-databasessku) | object | The database SKU. |
| [`sourceDatabaseDeletionDate`](#parameter-databasessourcedatabasedeletiondate) | string | Specifies the time that the database was deleted. |
| [`sourceDatabaseResourceId`](#parameter-databasessourcedatabaseresourceid) | string | The resource identifier of the source database associated with create operation of this database. |
| [`sourceResourceId`](#parameter-databasessourceresourceid) | string | The resource identifier of the source associated with the create operation of this database. |
| [`tags`](#parameter-databasestags) | object | Tags of the resource. |
| [`useFreeLimit`](#parameter-databasesusefreelimit) | bool | Whether or not the database uses free monthly limits. Allowed on one database in a subscription. |
| [`zoneRedundant`](#parameter-databaseszoneredundant) | bool | Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. |

### Parameter: `databases.availabilityZone`

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

### Parameter: `databases.name`

The name of the Elastic Pool.

- Required: Yes
- Type: string

### Parameter: `databases.autoPauseDelay`

Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.

- Required: No
- Type: int

### Parameter: `databases.backupLongTermRetentionPolicy`

The long term backup retention policy for the database.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`monthlyRetention`](#parameter-databasesbackuplongtermretentionpolicymonthlyretention) | string | Monthly retention in ISO 8601 duration format. |
| [`weeklyRetention`](#parameter-databasesbackuplongtermretentionpolicyweeklyretention) | string | Weekly retention in ISO 8601 duration format. |
| [`weekOfYear`](#parameter-databasesbackuplongtermretentionpolicyweekofyear) | int | Week of year backup to keep for yearly retention. |
| [`yearlyRetention`](#parameter-databasesbackuplongtermretentionpolicyyearlyretention) | string | Yearly retention in ISO 8601 duration format. |

### Parameter: `databases.backupLongTermRetentionPolicy.monthlyRetention`

Monthly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `databases.backupLongTermRetentionPolicy.weeklyRetention`

Weekly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `databases.backupLongTermRetentionPolicy.weekOfYear`

Week of year backup to keep for yearly retention.

- Required: No
- Type: int

### Parameter: `databases.backupLongTermRetentionPolicy.yearlyRetention`

Yearly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `databases.backupShortTermRetentionPolicy`

The short term backup retention policy for the database.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diffBackupIntervalInHours`](#parameter-databasesbackupshorttermretentionpolicydiffbackupintervalinhours) | int | Differential backup interval in hours. For Hyperscale tiers this value will be ignored. |
| [`retentionDays`](#parameter-databasesbackupshorttermretentionpolicyretentiondays) | int | Point-in-time retention in days. |

### Parameter: `databases.backupShortTermRetentionPolicy.diffBackupIntervalInHours`

Differential backup interval in hours. For Hyperscale tiers this value will be ignored.

- Required: No
- Type: int

### Parameter: `databases.backupShortTermRetentionPolicy.retentionDays`

Point-in-time retention in days.

- Required: No
- Type: int

### Parameter: `databases.catalogCollation`

Collation of the metadata catalog.

- Required: No
- Type: string

### Parameter: `databases.collation`

The collation of the database.

- Required: No
- Type: string

### Parameter: `databases.createMode`

Specifies the mode of database creation.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Copy'
    'Default'
    'OnlineSecondary'
    'PointInTimeRestore'
    'Recovery'
    'Restore'
    'RestoreExternalBackup'
    'RestoreExternalBackupSecondary'
    'RestoreLongTermRetentionBackup'
    'Secondary'
  ]
  ```

### Parameter: `databases.customerManagedKey`

The customer managed key definition for database TDE.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-databasescustomermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-databasescustomermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-databasescustomermanagedkeyautorotationenabled) | bool | Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used. |
| [`keyVersion`](#parameter-databasescustomermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting. |
| [`userAssignedIdentityResourceId`](#parameter-databasescustomermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `databases.customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `databases.customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `databases.customerManagedKey.autoRotationEnabled`

Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.

- Required: No
- Type: bool

### Parameter: `databases.customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting.

- Required: No
- Type: string

### Parameter: `databases.customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-databasesdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-databasesdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-databasesdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-databasesdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-databasesdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-databasesdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-databasesdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-databasesdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-databasesdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `databases.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `databases.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-databasesdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-databasesdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-databasesdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `databases.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `databases.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-databasesdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-databasesdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `databases.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `databases.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `databases.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `databases.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `databases.elasticPoolResourceId`

The resource identifier of the elastic pool containing this database.

- Required: No
- Type: string

### Parameter: `databases.federatedClientId`

The Client id used for cross tenant per database CMK scenario.

- Required: No
- Type: string

### Parameter: `databases.freeLimitExhaustionBehavior`

Specifies the behavior when monthly free limits are exhausted for the free database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AutoPause'
    'BillOverUsage'
  ]
  ```

### Parameter: `databases.highAvailabilityReplicaCount`

The number of secondary replicas associated with the database that are used to provide high availability. Not applicable to a Hyperscale database within an elastic pool.

- Required: No
- Type: int

### Parameter: `databases.isLedgerOn`

Whether or not this database is a ledger database, which means all tables in the database are ledger tables.

- Required: No
- Type: bool

### Parameter: `databases.licenseType`

The license type to apply for this database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'BasePrice'
    'LicenseIncluded'
  ]
  ```

### Parameter: `databases.lock`

The lock settings of the database.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-databaseslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-databaseslockname) | string | Specify the name of lock. |

### Parameter: `databases.lock.kind`

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

### Parameter: `databases.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `databases.longTermRetentionBackupResourceId`

The resource identifier of the long term retention backup associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `databases.maintenanceConfigurationId`

Maintenance configuration id assigned to the database. This configuration defines the period when the maintenance updates will occur.

- Required: No
- Type: string

### Parameter: `databases.managedIdentities`

The managed identities for the database.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-databasesmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `databases.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `databases.manualCutover`

Whether or not customer controlled manual cutover needs to be done during Update Database operation to Hyperscale tier.

- Required: No
- Type: bool

### Parameter: `databases.maxSizeBytes`

The max size of the database expressed in bytes.

- Required: No
- Type: int

### Parameter: `databases.minCapacity`

Minimal capacity that database will always have allocated, if not paused.

- Required: No
- Type: string

### Parameter: `databases.performCutover`

To trigger customer controlled manual cutover during the wait state while Scaling operation is in progress.

- Required: No
- Type: bool

### Parameter: `databases.preferredEnclaveType`

Type of enclave requested on the database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'VBS'
  ]
  ```

### Parameter: `databases.readScale`

The state of read-only routing. If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica in the same region. Not applicable to a Hyperscale database within an elastic pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `databases.recoverableDatabaseResourceId`

The resource identifier of the recoverable database associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `databases.recoveryServicesRecoveryPointResourceId`

The resource identifier of the recovery point associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `databases.requestedBackupStorageRedundancy`

The storage account type to be used to store backups for this database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Geo'
    'GeoZone'
    'Local'
    'Zone'
  ]
  ```

### Parameter: `databases.restorableDroppedDatabaseResourceId`

The resource identifier of the restorable dropped database associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `databases.restorePointInTime`

Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.

- Required: No
- Type: string

### Parameter: `databases.sampleName`

The name of the sample schema to apply when creating this database.

- Required: No
- Type: string

### Parameter: `databases.secondaryType`

The secondary type of the database if it is a secondary.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Geo'
    'Named'
    'Standby'
  ]
  ```

### Parameter: `databases.sku`

The database SKU.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-databasesskuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-databasesskucapacity) | int | The capacity of the particular SKU. |
| [`family`](#parameter-databasesskufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`size`](#parameter-databasesskusize) | string | Size of the particular SKU. |
| [`tier`](#parameter-databasesskutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |

### Parameter: `databases.sku.name`

The name of the SKU, typically, a letter + Number code, e.g. P3.

- Required: Yes
- Type: string

### Parameter: `databases.sku.capacity`

The capacity of the particular SKU.

- Required: No
- Type: int

### Parameter: `databases.sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here.

- Required: No
- Type: string

### Parameter: `databases.sku.size`

Size of the particular SKU.

- Required: No
- Type: string

### Parameter: `databases.sku.tier`

The tier or edition of the particular SKU, e.g. Basic, Premium.

- Required: No
- Type: string

### Parameter: `databases.sourceDatabaseDeletionDate`

Specifies the time that the database was deleted.

- Required: No
- Type: string

### Parameter: `databases.sourceDatabaseResourceId`

The resource identifier of the source database associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `databases.sourceResourceId`

The resource identifier of the source associated with the create operation of this database.

- Required: No
- Type: string

### Parameter: `databases.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `databases.useFreeLimit`

Whether or not the database uses free monthly limits. Allowed on one database in a subscription.

- Required: No
- Type: bool

### Parameter: `databases.zoneRedundant`

Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones.

- Required: No
- Type: bool

### Parameter: `elasticPools`

The Elastic Pools to create in the server.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZone`](#parameter-elasticpoolsavailabilityzone) | int | If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |
| [`name`](#parameter-elasticpoolsname) | string | The name of the Elastic Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-elasticpoolsautopausedelay) | int | Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled. |
| [`highAvailabilityReplicaCount`](#parameter-elasticpoolshighavailabilityreplicacount) | int | The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools. |
| [`licenseType`](#parameter-elasticpoolslicensetype) | string | The license type to apply for this elastic pool. |
| [`lock`](#parameter-elasticpoolslock) | object | The lock settings of the elastic pool. |
| [`maintenanceConfigurationId`](#parameter-elasticpoolsmaintenanceconfigurationid) | string | Maintenance configuration id assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur. |
| [`maxSizeBytes`](#parameter-elasticpoolsmaxsizebytes) | int | The storage limit for the database elastic pool in bytes. |
| [`minCapacity`](#parameter-elasticpoolsmincapacity) | int | Minimal capacity that serverless pool will not shrink below, if not paused. |
| [`perDatabaseSettings`](#parameter-elasticpoolsperdatabasesettings) | object | The per database settings for the elastic pool. |
| [`preferredEnclaveType`](#parameter-elasticpoolspreferredenclavetype) | string | Type of enclave requested on the elastic pool. |
| [`roleAssignments`](#parameter-elasticpoolsroleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-elasticpoolssku) | object | The elastic pool SKU. |
| [`tags`](#parameter-elasticpoolstags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-elasticpoolszoneredundant) | bool | Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones. |

### Parameter: `elasticPools.availabilityZone`

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

### Parameter: `elasticPools.name`

The name of the Elastic Pool.

- Required: Yes
- Type: string

### Parameter: `elasticPools.autoPauseDelay`

Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled.

- Required: No
- Type: int

### Parameter: `elasticPools.highAvailabilityReplicaCount`

The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools.

- Required: No
- Type: int

### Parameter: `elasticPools.licenseType`

The license type to apply for this elastic pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'BasePrice'
    'LicenseIncluded'
  ]
  ```

### Parameter: `elasticPools.lock`

The lock settings of the elastic pool.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-elasticpoolslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-elasticpoolslockname) | string | Specify the name of lock. |

### Parameter: `elasticPools.lock.kind`

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

### Parameter: `elasticPools.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `elasticPools.maintenanceConfigurationId`

Maintenance configuration id assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur.

- Required: No
- Type: string

### Parameter: `elasticPools.maxSizeBytes`

The storage limit for the database elastic pool in bytes.

- Required: No
- Type: int

### Parameter: `elasticPools.minCapacity`

Minimal capacity that serverless pool will not shrink below, if not paused.

- Required: No
- Type: int

### Parameter: `elasticPools.perDatabaseSettings`

The per database settings for the elastic pool.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxCapacity`](#parameter-elasticpoolsperdatabasesettingsmaxcapacity) | string | The maximum capacity any one database can consume. Examples: '0.5', '2'. |
| [`minCapacity`](#parameter-elasticpoolsperdatabasesettingsmincapacity) | string | The minimum capacity all databases are guaranteed. Examples: '0.5', '1'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-elasticpoolsperdatabasesettingsautopausedelay) | int | Auto Pause Delay for per database within pool. |

### Parameter: `elasticPools.perDatabaseSettings.maxCapacity`

The maximum capacity any one database can consume. Examples: '0.5', '2'.

- Required: Yes
- Type: string

### Parameter: `elasticPools.perDatabaseSettings.minCapacity`

The minimum capacity all databases are guaranteed. Examples: '0.5', '1'.

- Required: Yes
- Type: string

### Parameter: `elasticPools.perDatabaseSettings.autoPauseDelay`

Auto Pause Delay for per database within pool.

- Required: No
- Type: int

### Parameter: `elasticPools.preferredEnclaveType`

Type of enclave requested on the elastic pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'VBS'
  ]
  ```

### Parameter: `elasticPools.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Monitoring Contributor'`
  - `'Monitoring Metrics Publisher'`
  - `'Monitoring Reader'`
  - `'Reservation Purchaser'`
  - `'Resource Policy Contributor'`
  - `'SQL DB Contributor'`
  - `'SQL Security Manager'`
  - `'SQL Server Contributor'`
  - `'SqlDb Migration Role'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-elasticpoolsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-elasticpoolsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-elasticpoolsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-elasticpoolsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-elasticpoolsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-elasticpoolsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-elasticpoolsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-elasticpoolsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `elasticPools.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `elasticPools.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `elasticPools.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `elasticPools.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `elasticPools.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `elasticPools.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `elasticPools.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `elasticPools.roleAssignments.principalType`

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

### Parameter: `elasticPools.sku`

The elastic pool SKU.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-elasticpoolsskuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-elasticpoolsskucapacity) | int | The capacity of the particular SKU. |
| [`family`](#parameter-elasticpoolsskufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`size`](#parameter-elasticpoolsskusize) | string | Size of the particular SKU. |
| [`tier`](#parameter-elasticpoolsskutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |

### Parameter: `elasticPools.sku.name`

The name of the SKU, typically, a letter + Number code, e.g. P3.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'BasicPool'
    'BC_DC'
    'BC_Gen5'
    'GP_DC'
    'GP_FSv2'
    'GP_Gen5'
    'HS_Gen5'
    'HS_MOPRMS'
    'HS_PRMS'
    'PremiumPool'
    'ServerlessPool'
    'StandardPool'
  ]
  ```

### Parameter: `elasticPools.sku.capacity`

The capacity of the particular SKU.

- Required: No
- Type: int

### Parameter: `elasticPools.sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here.

- Required: No
- Type: string

### Parameter: `elasticPools.sku.size`

Size of the particular SKU.

- Required: No
- Type: string

### Parameter: `elasticPools.sku.tier`

The tier or edition of the particular SKU, e.g. Basic, Premium.

- Required: No
- Type: string

### Parameter: `elasticPools.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `elasticPools.zoneRedundant`

Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones.

- Required: No
- Type: bool

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `failoverGroups`

The failover groups configuration.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databases`](#parameter-failovergroupsdatabases) | array | List of databases in the failover group. |
| [`name`](#parameter-failovergroupsname) | string | The name of the failover group. |
| [`partnerServers`](#parameter-failovergroupspartnerservers) | array | List of the partner servers for the failover group. |
| [`readWriteEndpoint`](#parameter-failovergroupsreadwriteendpoint) | object | Read-write endpoint of the failover group instance. |
| [`secondaryType`](#parameter-failovergroupssecondarytype) | string | Databases secondary type on partner server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`readOnlyEndpoint`](#parameter-failovergroupsreadonlyendpoint) | object | Read-only endpoint of the failover group instance. |
| [`tags`](#parameter-failovergroupstags) | object | Tags of the resource. |

### Parameter: `failoverGroups.databases`

List of databases in the failover group.

- Required: Yes
- Type: array

### Parameter: `failoverGroups.name`

The name of the failover group.

- Required: Yes
- Type: string

### Parameter: `failoverGroups.partnerServers`

List of the partner servers for the failover group.

- Required: Yes
- Type: array

### Parameter: `failoverGroups.readWriteEndpoint`

Read-write endpoint of the failover group instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failoverPolicy`](#parameter-failovergroupsreadwriteendpointfailoverpolicy) | string | Failover policy of the read-write endpoint for the failover group. If failoverPolicy is Automatic then failoverWithDataLossGracePeriodMinutes is required. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failoverWithDataLossGracePeriodMinutes`](#parameter-failovergroupsreadwriteendpointfailoverwithdatalossgraceperiodminutes) | int | Grace period before failover with data loss is attempted for the read-write endpoint. |

### Parameter: `failoverGroups.readWriteEndpoint.failoverPolicy`

Failover policy of the read-write endpoint for the failover group. If failoverPolicy is Automatic then failoverWithDataLossGracePeriodMinutes is required.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Automatic'
    'Manual'
  ]
  ```

### Parameter: `failoverGroups.readWriteEndpoint.failoverWithDataLossGracePeriodMinutes`

Grace period before failover with data loss is attempted for the read-write endpoint.

- Required: No
- Type: int

### Parameter: `failoverGroups.secondaryType`

Databases secondary type on partner server.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Geo'
    'Standby'
  ]
  ```

### Parameter: `failoverGroups.readOnlyEndpoint`

Read-only endpoint of the failover group instance.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failoverPolicy`](#parameter-failovergroupsreadonlyendpointfailoverpolicy) | string | Failover policy of the read-only endpoint for the failover group. |
| [`targetServer`](#parameter-failovergroupsreadonlyendpointtargetserver) | string | The target partner server where the read-only endpoint points to. |

### Parameter: `failoverGroups.readOnlyEndpoint.failoverPolicy`

Failover policy of the read-only endpoint for the failover group.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `failoverGroups.readOnlyEndpoint.targetServer`

The target partner server where the read-only endpoint points to.

- Required: Yes
- Type: string

### Parameter: `failoverGroups.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `federatedClientId`

The Client id used for cross tenant CMK scenario.

- Required: No
- Type: string

### Parameter: `firewallRules`

The firewall rules to create in the server.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-firewallrulesname) | string | The name of the firewall rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIpAddress`](#parameter-firewallrulesendipaddress) | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| [`startIpAddress`](#parameter-firewallrulesstartipaddress) | string | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |

### Parameter: `firewallRules.name`

The name of the firewall rule.

- Required: Yes
- Type: string

### Parameter: `firewallRules.endIpAddress`

The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: No
- Type: string

### Parameter: `firewallRules.startIpAddress`

The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: No
- Type: string

### Parameter: `isIPv6Enabled`

Whether or not to enable IPv6 support for this server.

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

### Parameter: `keys`

The keys to configure.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-keysname) | string | The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern. |
| [`serverKeyType`](#parameter-keysserverkeytype) | string | The server key type. |
| [`uri`](#parameter-keysuri) | string | The URI of the server key. If the ServerKeyType is AzureKeyVault, then the URI is required. The AKV URI is required to be in this format: 'https://YourVaultName.azure.net/keys/YourKeyName/YourKeyVersion'. |

### Parameter: `keys.name`

The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.

- Required: No
- Type: string

### Parameter: `keys.serverKeyType`

The server key type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureKeyVault'
    'ServiceManaged'
  ]
  ```

### Parameter: `keys.uri`

The URI of the server key. If the ServerKeyType is AzureKeyVault, then the URI is required. The AKV URI is required to be in this format: 'https://YourVaultName.azure.net/keys/YourKeyName/YourKeyVersion'.

- Required: No
- Type: string

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

### Parameter: `minimalTlsVersion`

Minimal TLS version allowed.

- Required: No
- Type: string
- Default: `'1.2'`
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
    '1.3'
  ]
  ```

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

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

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Disabled'
    'Enabled'
    'SecuredByPerimeter'
  ]
  ```

### Parameter: `restrictOutboundNetworkAccess`

Whether or not to restrict outbound network access for this server.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
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
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Monitoring Contributor'`
  - `'Monitoring Metrics Publisher'`
  - `'Monitoring Reader'`
  - `'Reservation Purchaser'`
  - `'Resource Policy Contributor'`
  - `'SQL DB Contributor'`
  - `'SQL Security Manager'`
  - `'SQL Server Contributor'`
  - `'SqlDb Migration Role'`

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

### Parameter: `secretsExportConfiguration`

Key vault reference and secret settings for the module's secrets export.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultResourceId`](#parameter-secretsexportconfigurationkeyvaultresourceid) | string | The resource ID of the key vault where to store the secrets of this module. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sqlAdminPasswordSecretName`](#parameter-secretsexportconfigurationsqladminpasswordsecretname) | string | The sqlAdminPassword secret name to create. |
| [`sqlAzureConnectionStringSecretName`](#parameter-secretsexportconfigurationsqlazureconnectionstringsecretname) | string | The sqlAzureConnectionString secret name to create. |

### Parameter: `secretsExportConfiguration.keyVaultResourceId`

The resource ID of the key vault where to store the secrets of this module.

- Required: Yes
- Type: string

### Parameter: `secretsExportConfiguration.sqlAdminPasswordSecretName`

The sqlAdminPassword secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.sqlAzureConnectionStringSecretName`

The sqlAzureConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `securityAlertPolicies`

The security alert policies to create in the server.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-securityalertpoliciesname) | string | The name of the Security Alert Policy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disabledAlerts`](#parameter-securityalertpoliciesdisabledalerts) | array | Alerts to disable. |
| [`emailAccountAdmins`](#parameter-securityalertpoliciesemailaccountadmins) | bool | Specifies that the alert is sent to the account administrators. |
| [`emailAddresses`](#parameter-securityalertpoliciesemailaddresses) | array | Specifies an array of email addresses to which the alert is sent. |
| [`retentionDays`](#parameter-securityalertpoliciesretentiondays) | int | Specifies the number of days to keep in the Threat Detection audit logs. |
| [`state`](#parameter-securityalertpoliciesstate) | string | Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database. |
| [`storageAccountAccessKey`](#parameter-securityalertpoliciesstorageaccountaccesskey) | string | Specifies the identifier key of the Threat Detection audit storage account. |
| [`storageEndpoint`](#parameter-securityalertpoliciesstorageendpoint) | string | Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs. |

### Parameter: `securityAlertPolicies.name`

The name of the Security Alert Policy.

- Required: Yes
- Type: string

### Parameter: `securityAlertPolicies.disabledAlerts`

Alerts to disable.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'Access_Anomaly'
    'Brute_Force'
    'Data_Exfiltration'
    'Sql_Injection'
    'Sql_Injection_Vulnerability'
    'Unsafe_Action'
  ]
  ```

### Parameter: `securityAlertPolicies.emailAccountAdmins`

Specifies that the alert is sent to the account administrators.

- Required: No
- Type: bool

### Parameter: `securityAlertPolicies.emailAddresses`

Specifies an array of email addresses to which the alert is sent.

- Required: No
- Type: array

### Parameter: `securityAlertPolicies.retentionDays`

Specifies the number of days to keep in the Threat Detection audit logs.

- Required: No
- Type: int

### Parameter: `securityAlertPolicies.state`

Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `securityAlertPolicies.storageAccountAccessKey`

Specifies the identifier key of the Threat Detection audit storage account.

- Required: No
- Type: string

### Parameter: `securityAlertPolicies.storageEndpoint`

Specifies the blob storage endpoint. This blob storage will hold all Threat Detection audit logs.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualNetworkRules`

The virtual network rules to create in the server.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworkrulesname) | string | The name of the Server Virtual Network Rule. |
| [`virtualNetworkSubnetResourceId`](#parameter-virtualnetworkrulesvirtualnetworksubnetresourceid) | string | The resource ID of the virtual network subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ignoreMissingVnetServiceEndpoint`](#parameter-virtualnetworkrulesignoremissingvnetserviceendpoint) | bool | Allow creating a firewall rule before the virtual network has vnet service endpoint enabled. |

### Parameter: `virtualNetworkRules.name`

The name of the Server Virtual Network Rule.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkRules.virtualNetworkSubnetResourceId`

The resource ID of the virtual network subnet.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkRules.ignoreMissingVnetServiceEndpoint`

Allow creating a firewall rule before the virtual network has vnet service endpoint enabled.

- Required: No
- Type: bool

### Parameter: `vulnerabilityAssessmentsObj`

The vulnerability assessment configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-vulnerabilityassessmentsobjname) | string | The name of the vulnerability assessment. |
| [`storageAccountResourceId`](#parameter-vulnerabilityassessmentsobjstorageaccountresourceid) | string | The resource ID of the storage account to store the scan reports. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`createStorageRoleAssignment`](#parameter-vulnerabilityassessmentsobjcreatestorageroleassignment) | bool | Specifies whether to create a role assignment for the storage account. |
| [`recurringScans`](#parameter-vulnerabilityassessmentsobjrecurringscans) | object | The recurring scans settings. |
| [`useStorageAccountAccessKey`](#parameter-vulnerabilityassessmentsobjusestorageaccountaccesskey) | bool | Specifies whether to use the storage account access key to access the storage account. |

### Parameter: `vulnerabilityAssessmentsObj.name`

The name of the vulnerability assessment.

- Required: Yes
- Type: string

### Parameter: `vulnerabilityAssessmentsObj.storageAccountResourceId`

The resource ID of the storage account to store the scan reports.

- Required: Yes
- Type: string

### Parameter: `vulnerabilityAssessmentsObj.createStorageRoleAssignment`

Specifies whether to create a role assignment for the storage account.

- Required: No
- Type: bool

### Parameter: `vulnerabilityAssessmentsObj.recurringScans`

The recurring scans settings.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emails`](#parameter-vulnerabilityassessmentsobjrecurringscansemails) | array | Specifies an array of e-mail addresses to which the scan notification is sent. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailSubscriptionAdmins`](#parameter-vulnerabilityassessmentsobjrecurringscansemailsubscriptionadmins) | bool | Specifies that the schedule scan notification will be sent to the subscription administrators. |
| [`isEnabled`](#parameter-vulnerabilityassessmentsobjrecurringscansisenabled) | bool | Recurring scans state. |

### Parameter: `vulnerabilityAssessmentsObj.recurringScans.emails`

Specifies an array of e-mail addresses to which the scan notification is sent.

- Required: Yes
- Type: array

### Parameter: `vulnerabilityAssessmentsObj.recurringScans.emailSubscriptionAdmins`

Specifies that the schedule scan notification will be sent to the subscription administrators.

- Required: No
- Type: bool

### Parameter: `vulnerabilityAssessmentsObj.recurringScans.isEnabled`

Recurring scans state.

- Required: No
- Type: bool

### Parameter: `vulnerabilityAssessmentsObj.useStorageAccountAccessKey`

Specifies whether to use the storage account access key to access the storage account.

- Required: No
- Type: bool

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `exportedSecrets` |  | A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret's name. |
| `fullyQualifiedDomainName` | string | The fully qualified domain name of the deployed SQL server. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed SQL server. |
| `privateEndpoints` | array | The private endpoints of the SQL server. |
| `resourceGroupName` | string | The resource group of the deployed SQL server. |
| `resourceId` | string | The resource ID of the deployed SQL server. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Notes

### Parameter Usage: `administrators`

Configure Azure Active Directory Authentication method for server administrator.
<https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/administrators?tabs=bicep>

<details>

<summary>Parameter JSON format</summary>

```json
"administrators": {
    "value": {
        "azureADOnlyAuthentication": true,
        "login": "John Doe", // if application can be anything
        "sid": "[[objectId]]", // if application, the object ID
        "principalType" : "User", // options: "User", "Group", "Application"
        "tenantId": "[[tenantId]]"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
administrators: {
    azureADOnlyAuthentication: true
    login: 'John Doe' // if application can be anything
    sid: '[[objectId]]' // if application the object ID
    'principalType' : 'User' // options: 'User' 'Group' 'Application'
    tenantId: '[[tenantId]]'
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
