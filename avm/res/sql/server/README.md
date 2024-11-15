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
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Sql/servers` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers) |
| `Microsoft.Sql/servers/auditingSettings` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/auditingSettings) |
| `Microsoft.Sql/servers/databases` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/servers/elasticPools` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/elasticPools) |
| `Microsoft.Sql/servers/encryptionProtector` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/encryptionProtector) |
| `Microsoft.Sql/servers/firewallRules` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/firewallRules) |
| `Microsoft.Sql/servers/keys` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/keys) |
| `Microsoft.Sql/servers/securityAlertPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/securityAlertPolicies) |
| `Microsoft.Sql/servers/virtualNetworkRules` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/virtualNetworkRules) |
| `Microsoft.Sql/servers/vulnerabilityAssessments` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/vulnerabilityAssessments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/sql/server:<version>`.

- [With an administrator](#example-1-with-an-administrator)
- [With audit settings](#example-2-with-audit-settings)
- [Using only defaults](#example-3-using-only-defaults)
- [Using elastic pool](#example-4-using-elastic-pool)
- [Deploying with a key vault reference to save secrets](#example-5-deploying-with-a-key-vault-reference-to-save-secrets)
- [Using large parameter set](#example-6-using-large-parameter-set)
- [With a secondary database](#example-7-with-a-secondary-database)
- [With vulnerability assessment](#example-8-with-vulnerability-assessment)
- [WAF-aligned](#example-9-waf-aligned)

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

### Example 3: _Using only defaults_

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
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
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
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param location = '<location>'
```

</details>
<p>

### Example 4: _Using elastic pool_

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
        name: 'ssep-ep-001'
      }
      {
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
          "name": "ssep-ep-001"
        },
        {
          "name": "ssep-ep-002",
          "perDatabaseSettings": {
            "maxCapacity": "4",
            "minCapacity": "0.5"
          },
          "sku": {
            "capacity": 4,
            "name": "GP_Gen5",
            "tier": "GeneralPurpose"
          }
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
    name: 'ssep-ep-001'
  }
  {
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
  }
]
param location = '<location>'
```

</details>
<p>

### Example 5: _Deploying with a key vault reference to save secrets_

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
        name: 'myDatabase'
      }
    ]
    location: '<location>'
    secretsExportConfiguration: {
      keyVaultResourceId: '<keyVaultResourceId>'
      sqlAdminPasswordSecretName: 'adminLoginPasswordKey'
      sqlAzureConnectionStringSercretName: 'sqlConnectionStringKey'
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
          "name": "myDatabase"
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
        "sqlAzureConnectionStringSercretName": "sqlConnectionStringKey"
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
    name: 'myDatabase'
  }
]
param location = '<location>'
param secretsExportConfiguration = {
  keyVaultResourceId: '<keyVaultResourceId>'
  sqlAdminPasswordSecretName: 'adminLoginPasswordKey'
  sqlAzureConnectionStringSercretName: 'sqlConnectionStringKey'
}
```

</details>
<p>

### Example 6: _Using large parameter set_

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
    databases: [
      {
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
        name: 'sqlsmax-ep-001'
        sku: {
          capacity: 10
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
        }
      }
    ]
    encryptionProtectorObj: {
      serverKeyName: '<serverKeyName>'
      serverKeyType: 'AzureKeyVault'
    }
    firewallRules: [
      {
        endIpAddress: '0.0.0.0'
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
      }
    ]
    keys: [
      {
        name: '<name>'
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
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
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
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
        virtualNetworkSubnetId: '<virtualNetworkSubnetId>'
      }
    ]
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
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
    "name": {
      "value": "sqlsmax"
    },
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "databases": {
      "value": [
        {
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
          "name": "sqlsmax-ep-001",
          "sku": {
            "capacity": 10,
            "name": "GP_Gen5",
            "tier": "GeneralPurpose"
          }
        }
      ]
    },
    "encryptionProtectorObj": {
      "value": {
        "serverKeyName": "<serverKeyName>",
        "serverKeyType": "AzureKeyVault"
      }
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
    "keys": {
      "value": [
        {
          "name": "<name>",
          "serverKeyType": "AzureKeyVault",
          "uri": "<uri>"
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
          "<managedIdentityResourceId>"
        ]
      }
    },
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
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
          "virtualNetworkSubnetId": "<virtualNetworkSubnetId>"
        }
      ]
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
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
param databases = [
  {
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
    name: 'sqlsmax-ep-001'
    sku: {
      capacity: 10
      name: 'GP_Gen5'
      tier: 'GeneralPurpose'
    }
  }
]
param encryptionProtectorObj = {
  serverKeyName: '<serverKeyName>'
  serverKeyType: 'AzureKeyVault'
}
param firewallRules = [
  {
    endIpAddress: '0.0.0.0'
    name: 'AllowAllWindowsAzureIps'
    startIpAddress: '0.0.0.0'
  }
]
param keys = [
  {
    name: '<name>'
    serverKeyType: 'AzureKeyVault'
    uri: '<uri>'
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
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityId = '<primaryUserAssignedIdentityId>'
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
    virtualNetworkSubnetId: '<virtualNetworkSubnetId>'
  }
]
param vulnerabilityAssessmentsObj = {
  emailSubscriptionAdmins: true
  name: 'default'
  recurringScansEmails: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  recurringScansIsEnabled: true
  storageAccountResourceId: '<storageAccountResourceId>'
}
```

</details>
<p>

### Example 7: _With a secondary database_

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
        createMode: 'Secondary'
        maxSizeBytes: 2147483648
        name: '<name>'
        sku: {
          name: 'Basic'
          tier: 'Basic'
        }
        sourceDatabaseResourceId: '<sourceDatabaseResourceId>'
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
          "createMode": "Secondary",
          "maxSizeBytes": 2147483648,
          "name": "<name>",
          "sku": {
            "name": "Basic",
            "tier": "Basic"
          },
          "sourceDatabaseResourceId": "<sourceDatabaseResourceId>"
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
    createMode: 'Secondary'
    maxSizeBytes: 2147483648
    name: '<name>'
    sku: {
      name: 'Basic'
      tier: 'Basic'
    }
    sourceDatabaseResourceId: '<sourceDatabaseResourceId>'
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

### Example 8: _With vulnerability assessment_

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
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
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
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
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
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
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
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
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
param primaryUserAssignedIdentityId = '<primaryUserAssignedIdentityId>'
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
  emailSubscriptionAdmins: true
  name: 'default'
  recurringScansEmails: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  recurringScansIsEnabled: true
  storageAccountResourceId: '<storageAccountResourceId>'
  useStorageAccountAccessKey: false
}
```

</details>
<p>

### Example 9: _WAF-aligned_

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
    databases: [
      {
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
        maintenanceConfigurationId: '<maintenanceConfigurationId>'
        name: 'sqlswaf-ep-001'
        sku: {
          capacity: 10
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
        }
      }
    ]
    encryptionProtectorObj: {
      serverKeyName: '<serverKeyName>'
      serverKeyType: 'AzureKeyVault'
    }
    keys: [
      {
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
      }
    ]
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
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
        virtualNetworkSubnetId: '<virtualNetworkSubnetId>'
      }
    ]
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
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
    "name": {
      "value": "sqlswaf"
    },
    "administrators": {
      "value": {
        "azureADOnlyAuthentication": true,
        "login": "myspn",
        "principalType": "Application",
        "sid": "<sid>",
        "tenantId": "<tenantId>"
      }
    },
    "databases": {
      "value": [
        {
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
    "encryptionProtectorObj": {
      "value": {
        "serverKeyName": "<serverKeyName>",
        "serverKeyType": "AzureKeyVault"
      }
    },
    "keys": {
      "value": [
        {
          "serverKeyType": "AzureKeyVault",
          "uri": "<uri>"
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
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
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
          "virtualNetworkSubnetId": "<virtualNetworkSubnetId>"
        }
      ]
    },
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
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
param databases = [
  {
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
    maintenanceConfigurationId: '<maintenanceConfigurationId>'
    name: 'sqlswaf-ep-001'
    sku: {
      capacity: 10
      name: 'GP_Gen5'
      tier: 'GeneralPurpose'
    }
  }
]
param encryptionProtectorObj = {
  serverKeyName: '<serverKeyName>'
  serverKeyType: 'AzureKeyVault'
}
param keys = [
  {
    serverKeyType: 'AzureKeyVault'
    uri: '<uri>'
  }
]
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityId = '<primaryUserAssignedIdentityId>'
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
    virtualNetworkSubnetId: '<virtualNetworkSubnetId>'
  }
]
param vulnerabilityAssessmentsObj = {
  emailSubscriptionAdmins: true
  name: 'default'
  recurringScansEmails: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  recurringScansIsEnabled: true
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
| [`primaryUserAssignedIdentityId`](#parameter-primaryuserassignedidentityid) | string | The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auditSettings`](#parameter-auditsettings) | object | The audit settings configuration. |
| [`databases`](#parameter-databases) | array | The databases to create in the server. |
| [`elasticPools`](#parameter-elasticpools) | array | The Elastic Pools to create in the server. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionProtectorObj`](#parameter-encryptionprotectorobj) | object | The encryption protection configuration. |
| [`federatedClientId`](#parameter-federatedclientid) | string | The Client id used for cross tenant CMK scenario. |
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the server. |
| [`isIPv6Enabled`](#parameter-isipv6enabled) | string | Whether or not to enable IPv6 support for this server. |
| [`keyId`](#parameter-keyid) | string | A CMK URI of the key to use for encryption. |
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
- Default: `''`

### Parameter: `administratorLoginPassword`

The administrator login password. Required if no `administrators` object for AAD authentication is provided.

- Required: No
- Type: securestring
- Default: `''`

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

### Parameter: `primaryUserAssignedIdentityId`

The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `auditSettings`

The audit settings configuration.

- Required: No
- Type: object
- Default: `{}`

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

### Parameter: `databases`

The databases to create in the server.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-databasesname) | string | The name of the Elastic Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-databasesautopausedelay) | int | Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. |
| [`availabilityZone`](#parameter-databasesavailabilityzone) | string | Specifies the availability zone the database is pinned to. |
| [`backupLongTermRetentionPolicy`](#parameter-databasesbackuplongtermretentionpolicy) | object | The long term backup retention policy for the database. |
| [`backupShortTermRetentionPolicy`](#parameter-databasesbackupshorttermretentionpolicy) | object | The short term backup retention policy for the database. |
| [`catalogCollation`](#parameter-databasescatalogcollation) | string | Collation of the metadata catalog. |
| [`collation`](#parameter-databasescollation) | string | The collation of the database. |
| [`createMode`](#parameter-databasescreatemode) | string | Specifies the mode of database creation. |
| [`diagnosticSettings`](#parameter-databasesdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`elasticPoolResourceId`](#parameter-databaseselasticpoolresourceid) | string | The resource identifier of the elastic pool containing this database. |
| [`encryptionProtector`](#parameter-databasesencryptionprotector) | string | The azure key vault URI of the database if it's configured with per Database Customer Managed Keys. |
| [`encryptionProtectorAutoRotation`](#parameter-databasesencryptionprotectorautorotation) | bool | The flag to enable or disable auto rotation of database encryption protector AKV key. |
| [`federatedClientId`](#parameter-databasesfederatedclientid) | string | The Client id used for cross tenant per database CMK scenario. |
| [`freeLimitExhaustionBehavior`](#parameter-databasesfreelimitexhaustionbehavior) | string | Specifies the behavior when monthly free limits are exhausted for the free database. |
| [`highAvailabilityReplicaCount`](#parameter-databaseshighavailabilityreplicacount) | int | The number of secondary replicas associated with the database that are used to provide high availability. Not applicable to a Hyperscale database within an elastic pool. |
| [`isLedgerOn`](#parameter-databasesisledgeron) | bool | Whether or not this database is a ledger database, which means all tables in the database are ledger tables. |
| [`licenseType`](#parameter-databaseslicensetype) | string | The license type to apply for this database. |
| [`longTermRetentionBackupResourceId`](#parameter-databaseslongtermretentionbackupresourceid) | string | The resource identifier of the long term retention backup associated with create operation of this database. |
| [`maintenanceConfigurationId`](#parameter-databasesmaintenanceconfigurationid) | string | Maintenance configuration id assigned to the database. This configuration defines the period when the maintenance updates will occur. |
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

### Parameter: `databases.name`

The name of the Elastic Pool.

- Required: Yes
- Type: string

### Parameter: `databases.autoPauseDelay`

Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.

- Required: No
- Type: int

### Parameter: `databases.availabilityZone`

Specifies the availability zone the database is pinned to.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '1'
    '2'
    '3'
    'NoPreference'
  ]
  ```

### Parameter: `databases.backupLongTermRetentionPolicy`

The long term backup retention policy for the database.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupStorageAccessTier`](#parameter-databasesbackuplongtermretentionpolicybackupstorageaccesstier) | string | The BackupStorageAccessTier for the LTR backups. |
| [`makeBackupsImmutable`](#parameter-databasesbackuplongtermretentionpolicymakebackupsimmutable) | bool | The setting whether to make LTR backups immutable. |
| [`monthlyRetention`](#parameter-databasesbackuplongtermretentionpolicymonthlyretention) | string | Monthly retention in ISO 8601 duration format. |
| [`weeklyRetention`](#parameter-databasesbackuplongtermretentionpolicyweeklyretention) | string | Weekly retention in ISO 8601 duration format. |
| [`weekOfYear`](#parameter-databasesbackuplongtermretentionpolicyweekofyear) | int | Week of year backup to keep for yearly retention. |
| [`yearlyRetention`](#parameter-databasesbackuplongtermretentionpolicyyearlyretention) | string | Yearly retention in ISO 8601 duration format. |

### Parameter: `databases.backupLongTermRetentionPolicy.backupStorageAccessTier`

The BackupStorageAccessTier for the LTR backups.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Archive'
    'Hot'
  ]
  ```

### Parameter: `databases.backupLongTermRetentionPolicy.makeBackupsImmutable`

The setting whether to make LTR backups immutable.

- Required: No
- Type: bool

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

### Parameter: `databases.encryptionProtector`

The azure key vault URI of the database if it's configured with per Database Customer Managed Keys.

- Required: No
- Type: string

### Parameter: `databases.encryptionProtectorAutoRotation`

The flag to enable or disable auto rotation of database encryption protector AKV key.

- Required: No
- Type: bool

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

### Parameter: `databases.longTermRetentionBackupResourceId`

The resource identifier of the long term retention backup associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `databases.maintenanceConfigurationId`

Maintenance configuration id assigned to the database. This configuration defines the period when the maintenance updates will occur.

- Required: No
- Type: string

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
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-elasticpoolsname) | string | The name of the Elastic Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-elasticpoolsautopausedelay) | int | Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled. |
| [`availabilityZone`](#parameter-elasticpoolsavailabilityzone) | string | Specifies the availability zone the pool's primary replica is pinned to. |
| [`highAvailabilityReplicaCount`](#parameter-elasticpoolshighavailabilityreplicacount) | int | The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools. |
| [`licenseType`](#parameter-elasticpoolslicensetype) | string | The license type to apply for this elastic pool. |
| [`maintenanceConfigurationId`](#parameter-elasticpoolsmaintenanceconfigurationid) | string | Maintenance configuration id assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur. |
| [`maxSizeBytes`](#parameter-elasticpoolsmaxsizebytes) | int | The storage limit for the database elastic pool in bytes. |
| [`minCapacity`](#parameter-elasticpoolsmincapacity) | int | Minimal capacity that serverless pool will not shrink below, if not paused. |
| [`perDatabaseSettings`](#parameter-elasticpoolsperdatabasesettings) | object | The per database settings for the elastic pool. |
| [`preferredEnclaveType`](#parameter-elasticpoolspreferredenclavetype) | string | Type of enclave requested on the elastic pool. |
| [`sku`](#parameter-elasticpoolssku) | object | The elastic pool SKU. |
| [`tags`](#parameter-elasticpoolstags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-elasticpoolszoneredundant) | bool | Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones. |

### Parameter: `elasticPools.name`

The name of the Elastic Pool.

- Required: Yes
- Type: string

### Parameter: `elasticPools.autoPauseDelay`

Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled.

- Required: No
- Type: int

### Parameter: `elasticPools.availabilityZone`

Specifies the availability zone the pool's primary replica is pinned to.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '1'
    '2'
    '3'
    'NoPreference'
  ]
  ```

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

### Parameter: `encryptionProtectorObj`

The encryption protection configuration.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `federatedClientId`

The Client id used for cross tenant CMK scenario.

- Required: No
- Type: string

### Parameter: `firewallRules`

The firewall rules to create in the server.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `keyId`

A CMK URI of the key to use for encryption.

- Required: No
- Type: string

### Parameter: `keys`

The keys to configure.

- Required: No
- Type: array
- Default: `[]`

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
| [`resourceGroupName`](#parameter-privateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different Resource Group than the main resource. |
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

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different Resource Group than the main resource.

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
  - `'Role Based Access Control Administrator (Preview)'`

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
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
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
  - `'Reservation Purchaser'`
  - `'Role Based Access Control Administrator'`
  - `'SQL DB Contributor'`
  - `'SQL Managed Instance Contributor'`
  - `'SQL Security Manager'`
  - `'SQL Server Contributor'`
  - `'SqlDb Migration Role'`
  - `'SqlMI Migration Role'`
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
| [`sqlAzureConnectionStringSercretName`](#parameter-secretsexportconfigurationsqlazureconnectionstringsercretname) | string | The sqlAzureConnectionString secret name to create. |

### Parameter: `secretsExportConfiguration.keyVaultResourceId`

The resource ID of the key vault where to store the secrets of this module.

- Required: Yes
- Type: string

### Parameter: `secretsExportConfiguration.sqlAdminPasswordSecretName`

The sqlAdminPassword secret name to create.

- Required: No
- Type: string

### Parameter: `secretsExportConfiguration.sqlAzureConnectionStringSercretName`

The sqlAzureConnectionString secret name to create.

- Required: No
- Type: string

### Parameter: `securityAlertPolicies`

The security alert policies to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualNetworkRules`

The virtual network rules to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `vulnerabilityAssessmentsObj`

The vulnerability assessment configuration.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `exportedSecrets` |  | A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret's name. |
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
| `br/public:avm/res/network/private-endpoint:0.7.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |

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
