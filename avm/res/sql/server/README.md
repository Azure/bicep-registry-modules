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
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Sql/servers` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers) |
| `Microsoft.Sql/servers/auditingSettings` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/auditingSettings) |
| `Microsoft.Sql/servers/databases` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies) |
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
- [Using large parameter set](#example-4-using-large-parameter-set)
- [With a secondary database](#example-5-with-a-secondary-database)
- [With vulnerability assessment](#example-6-with-vulnerability-assessment)
- [WAF-aligned](#example-7-waf-aligned)

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

<summary>via JSON Parameter file</summary>

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

<summary>via JSON Parameter file</summary>

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

<summary>via JSON Parameter file</summary>

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

### Example 4: _Using large parameter set_

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
        capacity: 0
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
        elasticPoolId: '<elasticPoolId>'
        encryptionProtectorObj: {
          serverKeyName: '<serverKeyName>'
          serverKeyType: 'AzureKeyVault'
        }
        licenseType: 'LicenseIncluded'
        maxSizeBytes: 34359738368
        name: 'sqlsmaxdb-001'
        skuName: 'ElasticPool'
        skuTier: 'GeneralPurpose'
      }
    ]
    elasticPools: [
      {
        maintenanceConfigurationId: '<maintenanceConfigurationId>'
        name: 'sqlsmax-ep-001'
        skuCapacity: 10
        skuName: 'GP_Gen5'
        skuTier: 'GeneralPurpose'
      }
    ]
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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

<summary>via JSON Parameter file</summary>

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
          "capacity": 0,
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
          "elasticPoolId": "<elasticPoolId>",
          "encryptionProtectorObj": {
            "serverKeyName": "<serverKeyName>",
            "serverKeyType": "AzureKeyVault"
          },
          "licenseType": "LicenseIncluded",
          "maxSizeBytes": 34359738368,
          "name": "sqlsmaxdb-001",
          "skuName": "ElasticPool",
          "skuTier": "GeneralPurpose"
        }
      ]
    },
    "elasticPools": {
      "value": [
        {
          "maintenanceConfigurationId": "<maintenanceConfigurationId>",
          "name": "sqlsmax-ep-001",
          "skuCapacity": 10,
          "skuName": "GP_Gen5",
          "skuTier": "GeneralPurpose"
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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
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

### Example 5: _With a secondary database_

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
        skuName: 'Basic'
        skuTier: 'Basic'
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

<summary>via JSON Parameter file</summary>

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
          "skuName": "Basic",
          "skuTier": "Basic",
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

### Example 6: _With vulnerability assessment_

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

<summary>via JSON Parameter file</summary>

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

### Example 7: _WAF-aligned_

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
        capacity: 0
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
        elasticPoolId: '<elasticPoolId>'
        encryptionProtectorObj: {
          serverKeyName: '<serverKeyName>'
          serverKeyType: 'AzureKeyVault'
        }
        licenseType: 'LicenseIncluded'
        maxSizeBytes: 34359738368
        name: 'sqlswafdb-001'
        skuName: 'ElasticPool'
        skuTier: 'GeneralPurpose'
      }
    ]
    elasticPools: [
      {
        maintenanceConfigurationId: '<maintenanceConfigurationId>'
        name: 'sqlswaf-ep-001'
        skuCapacity: 10
        skuName: 'GP_Gen5'
        skuTier: 'GeneralPurpose'
      }
    ]
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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

<summary>via JSON Parameter file</summary>

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
          "capacity": 0,
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
          "elasticPoolId": "<elasticPoolId>",
          "encryptionProtectorObj": {
            "serverKeyName": "<serverKeyName>",
            "serverKeyType": "AzureKeyVault"
          },
          "licenseType": "LicenseIncluded",
          "maxSizeBytes": 34359738368,
          "name": "sqlswafdb-001",
          "skuName": "ElasticPool",
          "skuTier": "GeneralPurpose"
        }
      ]
    },
    "elasticPools": {
      "value": [
        {
          "maintenanceConfigurationId": "<maintenanceConfigurationId>",
          "name": "sqlswaf-ep-001",
          "skuCapacity": 10,
          "skuName": "GP_Gen5",
          "skuTier": "GeneralPurpose"
        }
      ]
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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
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
| [`firewallRules`](#parameter-firewallrules) | array | The firewall rules to create in the server. |
| [`keys`](#parameter-keys) | array | The keys to configure. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`minimalTlsVersion`](#parameter-minimaltlsversion) | string | Minimal TLS version allowed. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and neither firewall rules nor virtual network rules are set. |
| [`restrictOutboundNetworkAccess`](#parameter-restrictoutboundnetworkaccess) | string | Whether or not to restrict outbound network access for this server. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
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
- Default: `{}`

### Parameter: `primaryUserAssignedIdentityId`

The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `auditSettings`

The audit settings configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-auditsettingsstate) | string | Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required. |

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
| [`storageAccountResourceId`](#parameter-auditsettingsstorageaccountresourceid) | string | Specifies the identifier key of the auditing storage account. |

### Parameter: `auditSettings.state`

Specifies the state of the audit. If state is Enabled, storageEndpoint or isAzureMonitorTargetEnabled are required.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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

### Parameter: `auditSettings.storageAccountResourceId`

Specifies the identifier key of the auditing storage account.

- Required: No
- Type: string

### Parameter: `databases`

The databases to create in the server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `elasticPools`

The Elastic Pools to create in the server.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `firewallRules`

The firewall rules to create in the server.

- Required: No
- Type: array
- Default: `[]`

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
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

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
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | array | The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-privateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

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

The location to deploy the private endpoint to.

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

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed SQL server. |
| `resourceGroupName` | string | The resource group of the deployed SQL server. |
| `resourceId` | string | The resource ID of the deployed SQL server. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.6.1` | Remote reference |

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
