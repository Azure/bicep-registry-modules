# SQL Managed Instances `[Microsoft.Sql/managedInstances]`

> ⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️
> 
> - Only security and bug fixes are being handled by the AVM core team at present.
> - If interested in becoming the module owner of this orphaned module (must be Microsoft FTE), please look for the related "orphaned module" GitHub issue [here](https://aka.ms/AVM/OrphanedModules)!

This module deploys a SQL Managed Instance.

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
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Sql/managedInstances` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances)</li></ul> |
| `Microsoft.Sql/managedInstances/databases` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_databases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/databases)</li></ul> |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_databases_backuplongtermretentionpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/databases/backupLongTermRetentionPolicies)</li></ul> |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_databases_backupshorttermretentionpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/databases/backupShortTermRetentionPolicies)</li></ul> |
| `Microsoft.Sql/managedInstances/encryptionProtector` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_encryptionprotector.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/encryptionProtector)</li></ul> |
| `Microsoft.Sql/managedInstances/keys` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/keys)</li></ul> |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_securityalertpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/securityAlertPolicies)</li></ul> |
| `Microsoft.Sql/managedInstances/vulnerabilityAssessments` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_vulnerabilityassessments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/vulnerabilityAssessments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/sql/managed-instance:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [With vulnerability assessment](#example-3-with-vulnerability-assessment)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module managedInstance 'br/public:avm/res/sql/managed-instance:<version>' = {
  name: 'managedInstanceDeployment'
  params: {
    // Required parameters
    name: 'sqlmimin'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
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
      "value": "sqlmimin"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/sql/managed-instance:<version>'

// Required parameters
param name = 'sqlmimin'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module managedInstance 'br/public:avm/res/sql/managed-instance:<version>' = {
  name: 'managedInstanceDeployment'
  params: {
    // Required parameters
    name: 'sqlmimax'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    databases: [
      {
        backupLongTermRetentionPolicy: {
          name: 'default'
        }
        backupShortTermRetentionPolicy: {
          name: 'default'
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
        name: 'sqlmimax-db-001'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    dnsZonePartnerResourceId: ''
    encryptionProtector: {
      serverKeyName: '<serverKeyName>'
      serverKeyType: 'AzureKeyVault'
    }
    hardwareFamily: 'Gen5'
    keys: [
      {
        name: '<name>'
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
      }
    ]
    licenseType: 'LicenseIncluded'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maintenanceWindow: 'Custom1'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityResourceId: '<primaryUserAssignedIdentityResourceId>'
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
    roleAssignments: [
      {
        name: '4de0cbb1-1f3d-4eb3-ac11-5797f548199b'
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
    securityAlertPolicy: {
      disabledAlerts: [
        'Unsafe_Action'
      ]
      emailAccountAdmins: true
      emailAddresses: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      name: 'default'
      retentionDays: 7
      state: 'Enabled'
      storageAccountResourceId: '<storageAccountResourceId>'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    timezoneId: 'UTC'
    vCores: 4
    vulnerabilityAssessment: {
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
    "name": {
      "value": "sqlmimax"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "collation": {
      "value": "SQL_Latin1_General_CP1_CI_AS"
    },
    "databases": {
      "value": [
        {
          "backupLongTermRetentionPolicy": {
            "name": "default"
          },
          "backupShortTermRetentionPolicy": {
            "name": "default"
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
          "name": "sqlmimax-db-001"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "dnsZonePartnerResourceId": {
      "value": ""
    },
    "encryptionProtector": {
      "value": {
        "serverKeyName": "<serverKeyName>",
        "serverKeyType": "AzureKeyVault"
      }
    },
    "hardwareFamily": {
      "value": "Gen5"
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
    "licenseType": {
      "value": "LicenseIncluded"
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
    "maintenanceWindow": {
      "value": "Custom1"
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
    "proxyOverride": {
      "value": "Proxy"
    },
    "publicDataEndpointEnabled": {
      "value": false
    },
    "roleAssignments": {
      "value": [
        {
          "name": "4de0cbb1-1f3d-4eb3-ac11-5797f548199b",
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
    "securityAlertPolicy": {
      "value": {
        "disabledAlerts": [
          "Unsafe_Action"
        ],
        "emailAccountAdmins": true,
        "emailAddresses": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "name": "default",
        "retentionDays": 7,
        "state": "Enabled",
        "storageAccountResourceId": "<storageAccountResourceId>"
      }
    },
    "servicePrincipal": {
      "value": "SystemAssigned"
    },
    "skuName": {
      "value": "GP_Gen5"
    },
    "skuTier": {
      "value": "GeneralPurpose"
    },
    "storageSizeInGB": {
      "value": 32
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "timezoneId": {
      "value": "UTC"
    },
    "vCores": {
      "value": 4
    },
    "vulnerabilityAssessment": {
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
using 'br/public:avm/res/sql/managed-instance:<version>'

// Required parameters
param name = 'sqlmimax'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param collation = 'SQL_Latin1_General_CP1_CI_AS'
param databases = [
  {
    backupLongTermRetentionPolicy: {
      name: 'default'
    }
    backupShortTermRetentionPolicy: {
      name: 'default'
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
    name: 'sqlmimax-db-001'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param dnsZonePartnerResourceId = ''
param encryptionProtector = {
  serverKeyName: '<serverKeyName>'
  serverKeyType: 'AzureKeyVault'
}
param hardwareFamily = 'Gen5'
param keys = [
  {
    name: '<name>'
    serverKeyType: 'AzureKeyVault'
    uri: '<uri>'
  }
]
param licenseType = 'LicenseIncluded'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param maintenanceWindow = 'Custom1'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityResourceId = '<primaryUserAssignedIdentityResourceId>'
param proxyOverride = 'Proxy'
param publicDataEndpointEnabled = false
param roleAssignments = [
  {
    name: '4de0cbb1-1f3d-4eb3-ac11-5797f548199b'
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
param securityAlertPolicy = {
  disabledAlerts: [
    'Unsafe_Action'
  ]
  emailAccountAdmins: true
  emailAddresses: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  name: 'default'
  retentionDays: 7
  state: 'Enabled'
  storageAccountResourceId: '<storageAccountResourceId>'
}
param servicePrincipal = 'SystemAssigned'
param skuName = 'GP_Gen5'
param skuTier = 'GeneralPurpose'
param storageSizeInGB = 32
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param timezoneId = 'UTC'
param vCores = 4
param vulnerabilityAssessment = {
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

### Example 3: _With vulnerability assessment_

This instance deploys the module with a vulnerability assessment.


<details>

<summary>via Bicep module</summary>

```bicep
module managedInstance 'br/public:avm/res/sql/managed-instance:<version>' = {
  name: 'managedInstanceDeployment'
  params: {
    // Required parameters
    name: 'sqlmivln'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    managedIdentities: {
      systemAssigned: true
    }
    securityAlertPolicy: {
      disabledAlerts: [
        'Unsafe_Action'
      ]
      emailAccountAdmins: true
      emailAddresses: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      name: 'default'
      retentionDays: 7
      state: 'Enabled'
      storageAccountResourceId: '<storageAccountResourceId>'
    }
    vulnerabilityAssessment: {
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
      "value": "sqlmivln"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "securityAlertPolicy": {
      "value": {
        "disabledAlerts": [
          "Unsafe_Action"
        ],
        "emailAccountAdmins": true,
        "emailAddresses": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "name": "default",
        "retentionDays": 7,
        "state": "Enabled",
        "storageAccountResourceId": "<storageAccountResourceId>"
      }
    },
    "vulnerabilityAssessment": {
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
using 'br/public:avm/res/sql/managed-instance:<version>'

// Required parameters
param name = 'sqlmivln'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param managedIdentities = {
  systemAssigned: true
}
param securityAlertPolicy = {
  disabledAlerts: [
    'Unsafe_Action'
  ]
  emailAccountAdmins: true
  emailAddresses: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  name: 'default'
  retentionDays: 7
  state: 'Enabled'
  storageAccountResourceId: '<storageAccountResourceId>'
}
param vulnerabilityAssessment = {
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module managedInstance 'br/public:avm/res/sql/managed-instance:<version>' = {
  name: 'managedInstanceDeployment'
  params: {
    // Required parameters
    name: 'sqlmiwaf'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    databases: [
      {
        backupLongTermRetentionPolicy: {
          name: 'default'
        }
        backupShortTermRetentionPolicy: {
          name: 'default'
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
        name: 'sqlmiwaf-db-001'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    dnsZonePartnerResourceId: ''
    encryptionProtector: {
      serverKeyName: '<serverKeyName>'
      serverKeyType: 'AzureKeyVault'
    }
    hardwareFamily: 'Gen5'
    keys: [
      {
        name: '<name>'
        serverKeyType: 'AzureKeyVault'
        uri: '<uri>'
      }
    ]
    licenseType: 'LicenseIncluded'
    maintenanceWindow: 'Custom2'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityResourceId: '<primaryUserAssignedIdentityResourceId>'
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
    securityAlertPolicy: {
      emailAccountAdmins: true
      emailAddresses: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      name: 'default'
      state: 'Enabled'
      storageAccountResourceId: '<storageAccountResourceId>'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    timezoneId: 'UTC'
    vCores: 4
    vulnerabilityAssessment: {
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
    "name": {
      "value": "sqlmiwaf"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "collation": {
      "value": "SQL_Latin1_General_CP1_CI_AS"
    },
    "databases": {
      "value": [
        {
          "backupLongTermRetentionPolicy": {
            "name": "default"
          },
          "backupShortTermRetentionPolicy": {
            "name": "default"
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
          "name": "sqlmiwaf-db-001"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "dnsZonePartnerResourceId": {
      "value": ""
    },
    "encryptionProtector": {
      "value": {
        "serverKeyName": "<serverKeyName>",
        "serverKeyType": "AzureKeyVault"
      }
    },
    "hardwareFamily": {
      "value": "Gen5"
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
    "licenseType": {
      "value": "LicenseIncluded"
    },
    "maintenanceWindow": {
      "value": "Custom2"
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
    "proxyOverride": {
      "value": "Proxy"
    },
    "publicDataEndpointEnabled": {
      "value": false
    },
    "securityAlertPolicy": {
      "value": {
        "emailAccountAdmins": true,
        "emailAddresses": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "name": "default",
        "state": "Enabled",
        "storageAccountResourceId": "<storageAccountResourceId>"
      }
    },
    "servicePrincipal": {
      "value": "SystemAssigned"
    },
    "skuName": {
      "value": "GP_Gen5"
    },
    "skuTier": {
      "value": "GeneralPurpose"
    },
    "storageSizeInGB": {
      "value": 32
    },
    "timezoneId": {
      "value": "UTC"
    },
    "vCores": {
      "value": 4
    },
    "vulnerabilityAssessment": {
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
using 'br/public:avm/res/sql/managed-instance:<version>'

// Required parameters
param name = 'sqlmiwaf'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param collation = 'SQL_Latin1_General_CP1_CI_AS'
param databases = [
  {
    backupLongTermRetentionPolicy: {
      name: 'default'
    }
    backupShortTermRetentionPolicy: {
      name: 'default'
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
    name: 'sqlmiwaf-db-001'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param dnsZonePartnerResourceId = ''
param encryptionProtector = {
  serverKeyName: '<serverKeyName>'
  serverKeyType: 'AzureKeyVault'
}
param hardwareFamily = 'Gen5'
param keys = [
  {
    name: '<name>'
    serverKeyType: 'AzureKeyVault'
    uri: '<uri>'
  }
]
param licenseType = 'LicenseIncluded'
param maintenanceWindow = 'Custom2'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityResourceId = '<primaryUserAssignedIdentityResourceId>'
param proxyOverride = 'Proxy'
param publicDataEndpointEnabled = false
param securityAlertPolicy = {
  emailAccountAdmins: true
  emailAddresses: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  name: 'default'
  state: 'Enabled'
  storageAccountResourceId: '<storageAccountResourceId>'
}
param servicePrincipal = 'SystemAssigned'
param skuName = 'GP_Gen5'
param skuTier = 'GeneralPurpose'
param storageSizeInGB = 32
param timezoneId = 'UTC'
param vCores = 4
param vulnerabilityAssessment = {
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
| [`name`](#parameter-name) | string | The name of the SQL managed instance. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The fully qualified resource ID of the subnet on which the SQL managed instance will be placed. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-administratorlogin) | string | The administrator username for the server. Required if no `administrators` object for AAD authentication is provided. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The administrator login password. Required if no `administrators` object for AAD authentication is provided. |
| [`administrators`](#parameter-administrators) | object | The Azure Active Directory (AAD) administrator authentication. Required if no `administratorLogin` & `administratorLoginPassword` is provided. |
| [`primaryUserAssignedIdentityResourceId`](#parameter-primaryuserassignedidentityresourceid) | string | The resource ID of a user assigned identity to be used by default. Required if `userAssignedIdentities` is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`collation`](#parameter-collation) | string | Collation of the managed instance. |
| [`databases`](#parameter-databases) | array | Databases to create in this server. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsZonePartnerResourceId`](#parameter-dnszonepartnerresourceid) | string | The resource ID of another managed instance whose DNS zone this managed instance will share after creation. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionProtector`](#parameter-encryptionprotector) | object | The encryption protection configuration. |
| [`hardwareFamily`](#parameter-hardwarefamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`instancePoolResourceId`](#parameter-instancepoolresourceid) | string | The resource ID of the instance pool this managed server belongs to. |
| [`keys`](#parameter-keys) | array | The keys to configure. |
| [`licenseType`](#parameter-licensetype) | string | The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | string | The maintenance window for the SQL Managed Instance.<p><p>SystemManaged: The system automatically selects a 9-hour maintenance window between 8:00 AM to 5:00 PM local time, Monday - Sunday.<p>Custom1: Weekday window: 10:00 PM to 6:00 AM local time, Monday - Thursday.<p>Custom2: Weekend window: 10:00 PM to 6:00 AM local time, Friday - Sunday.<p> |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedInstanceCreateMode`](#parameter-managedinstancecreatemode) | string | Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and sourceManagedInstanceResourceId must be specified. |
| [`minimalTlsVersion`](#parameter-minimaltlsversion) | string | Minimal TLS version allowed. |
| [`proxyOverride`](#parameter-proxyoverride) | string | Connection type used for connecting to the instance. |
| [`publicDataEndpointEnabled`](#parameter-publicdataendpointenabled) | bool | Whether or not the public data endpoint is enabled. |
| [`requestedBackupStorageRedundancy`](#parameter-requestedbackupstorageredundancy) | string | The storage account type used to store backups for this database. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityAlertPolicy`](#parameter-securityalertpolicy) | object | The security alert policy configuration. |
| [`servicePrincipal`](#parameter-serviceprincipal) | string | Service principal type. If using AD Authentication and applying Admin, must be set to `SystemAssigned`. Then Global Admin must allow Reader access to Azure AD for the Service Principal. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |
| [`skuTier`](#parameter-skutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |
| [`sourceManagedInstanceResourceId`](#parameter-sourcemanagedinstanceresourceid) | string | The resource identifier of the source managed instance associated with create operation of this instance. |
| [`storageSizeInGB`](#parameter-storagesizeingb) | int | Storage size in GB. Increments of 32 GB allowed only. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timezoneId`](#parameter-timezoneid) | string | ID of the timezone. Allowed values are timezones supported by Windows. |
| [`vCores`](#parameter-vcores) | int | The number of vCores. |
| [`vulnerabilityAssessment`](#parameter-vulnerabilityassessment) | object | The vulnerability assessment configuration. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not multi-az is enabled. |

### Parameter: `name`

The name of the SQL managed instance.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

The fully qualified resource ID of the subnet on which the SQL managed instance will be placed.

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

### Parameter: `administrators.tenantId`

Tenant ID of the administrator.

- Required: No
- Type: string

### Parameter: `primaryUserAssignedIdentityResourceId`

The resource ID of a user assigned identity to be used by default. Required if `userAssignedIdentities` is not empty.

- Required: No
- Type: string

### Parameter: `collation`

Collation of the managed instance.

- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `databases`

Databases to create in this server.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-databasesname) | string | The name of the SQL managed instance database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`longTermRetentionBackupResourceId`](#parameter-databaseslongtermretentionbackupresourceid) | string | The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup. |
| [`recoverableDatabaseId`](#parameter-databasesrecoverabledatabaseid) | string | The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery. |
| [`restorePointInTime`](#parameter-databasesrestorepointintime) | string | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore. |
| [`sourceDatabaseId`](#parameter-databasessourcedatabaseid) | string | The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore. |
| [`storageContainerSasToken`](#parameter-databasesstoragecontainersastoken) | securestring | Specifies the storage container sas token. Required if createMode is RestoreExternalBackup. |
| [`storageContainerUri`](#parameter-databasesstoragecontaineruri) | string | Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupLongTermRetentionPolicy`](#parameter-databasesbackuplongtermretentionpolicy) | object | The configuration for the backup long term retention policy definition. |
| [`backupShortTermRetentionPolicy`](#parameter-databasesbackupshorttermretentionpolicy) | object | The configuration for the backup short term retention policy definition. |
| [`catalogCollation`](#parameter-databasescatalogcollation) | string | Collation of the managed instance. |
| [`collation`](#parameter-databasescollation) | string | Collation of the managed instance database. |
| [`createMode`](#parameter-databasescreatemode) | string | Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required). |
| [`diagnosticSettings`](#parameter-databasesdiagnosticsettings) | array | The database-level diagnostic settings of the service. |
| [`location`](#parameter-databaseslocation) | string | Location for all resources. |
| [`lock`](#parameter-databaseslock) | object | The lock settings of the service. |
| [`restorableDroppedDatabaseId`](#parameter-databasesrestorabledroppeddatabaseid) | string | The restorable dropped database resource ID to restore when creating this database. |
| [`tags`](#parameter-databasestags) | object | Tags of the resource. |

### Parameter: `databases.name`

The name of the SQL managed instance database.

- Required: Yes
- Type: string

### Parameter: `databases.longTermRetentionBackupResourceId`

The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup.

- Required: No
- Type: string

### Parameter: `databases.recoverableDatabaseId`

The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery.

- Required: No
- Type: string

### Parameter: `databases.restorePointInTime`

Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore.

- Required: No
- Type: string

### Parameter: `databases.sourceDatabaseId`

The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore.

- Required: No
- Type: string

### Parameter: `databases.storageContainerSasToken`

Specifies the storage container sas token. Required if createMode is RestoreExternalBackup.

- Required: No
- Type: securestring

### Parameter: `databases.storageContainerUri`

Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup.

- Required: No
- Type: string

### Parameter: `databases.backupLongTermRetentionPolicy`

The configuration for the backup long term retention policy definition.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupStorageAccessTier`](#parameter-databasesbackuplongtermretentionpolicybackupstorageaccesstier) | string | The BackupStorageAccessTier for the LTR backups. |
| [`monthlyRetention`](#parameter-databasesbackuplongtermretentionpolicymonthlyretention) | string | The monthly retention policy for an LTR backup in an ISO 8601 format. |
| [`name`](#parameter-databasesbackuplongtermretentionpolicyname) | string | The name of the long term retention policy. If not specified, 'default' name will be used. |
| [`weeklyRetention`](#parameter-databasesbackuplongtermretentionpolicyweeklyretention) | string | The weekly retention policy for an LTR backup in an ISO 8601 format. |
| [`weekOfYear`](#parameter-databasesbackuplongtermretentionpolicyweekofyear) | int | The week of year to take the yearly backup in an ISO 8601 format. |
| [`yearlyRetention`](#parameter-databasesbackuplongtermretentionpolicyyearlyretention) | string | The yearly retention policy for an LTR backup in an ISO 8601 format. |

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

### Parameter: `databases.backupLongTermRetentionPolicy.monthlyRetention`

The monthly retention policy for an LTR backup in an ISO 8601 format.

- Required: No
- Type: string

### Parameter: `databases.backupLongTermRetentionPolicy.name`

The name of the long term retention policy. If not specified, 'default' name will be used.

- Required: No
- Type: string

### Parameter: `databases.backupLongTermRetentionPolicy.weeklyRetention`

The weekly retention policy for an LTR backup in an ISO 8601 format.

- Required: No
- Type: string

### Parameter: `databases.backupLongTermRetentionPolicy.weekOfYear`

The week of year to take the yearly backup in an ISO 8601 format.

- Required: No
- Type: int

### Parameter: `databases.backupLongTermRetentionPolicy.yearlyRetention`

The yearly retention policy for an LTR backup in an ISO 8601 format.

- Required: No
- Type: string

### Parameter: `databases.backupShortTermRetentionPolicy`

The configuration for the backup short term retention policy definition.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-databasesbackupshorttermretentionpolicyname) | string | The name of the short term retention policy. If not specified, 'default' name will be used. |
| [`retentionDays`](#parameter-databasesbackupshorttermretentionpolicyretentiondays) | int | The backup retention period in days. This is how many days Point-in-Time Restore will be supported. If not specified, the default value is 35 days. |

### Parameter: `databases.backupShortTermRetentionPolicy.name`

The name of the short term retention policy. If not specified, 'default' name will be used.

- Required: No
- Type: string

### Parameter: `databases.backupShortTermRetentionPolicy.retentionDays`

The backup retention period in days. This is how many days Point-in-Time Restore will be supported. If not specified, the default value is 35 days.

- Required: No
- Type: int

### Parameter: `databases.catalogCollation`

Collation of the managed instance.

- Required: No
- Type: string

### Parameter: `databases.collation`

Collation of the managed instance database.

- Required: No
- Type: string

### Parameter: `databases.createMode`

Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'PointInTimeRestore'
    'Recovery'
    'RestoreExternalBackup'
    'RestoreLongTermRetentionBackup'
  ]
  ```

### Parameter: `databases.diagnosticSettings`

The database-level diagnostic settings of the service.

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
| [`name`](#parameter-databasesdiagnosticsettingsname) | string | The name of diagnostic setting. |
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

### Parameter: `databases.diagnosticSettings.name`

The name of diagnostic setting.

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

### Parameter: `databases.location`

Location for all resources.

- Required: No
- Type: string

### Parameter: `databases.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-databaseslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-databaseslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-databaseslocknotes) | string | Specify the notes of the lock. |

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

### Parameter: `databases.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `databases.restorableDroppedDatabaseId`

The restorable dropped database resource ID to restore when creating this database.

- Required: No
- Type: string

### Parameter: `databases.tags`

Tags of the resource.

- Required: No
- Type: object

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

### Parameter: `dnsZonePartnerResourceId`

The resource ID of another managed instance whose DNS zone this managed instance will share after creation.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionProtector`

The encryption protection configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverKeyName`](#parameter-encryptionprotectorserverkeyname) | string | The name of the SQL managed instance key. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-encryptionprotectorautorotationenabled) | bool | Key auto rotation opt-in flag. |
| [`serverKeyType`](#parameter-encryptionprotectorserverkeytype) | string | The encryption protector type like "ServiceManaged", "AzureKeyVault". |

### Parameter: `encryptionProtector.serverKeyName`

The name of the SQL managed instance key.

- Required: Yes
- Type: string

### Parameter: `encryptionProtector.autoRotationEnabled`

Key auto rotation opt-in flag.

- Required: No
- Type: bool

### Parameter: `encryptionProtector.serverKeyType`

The encryption protector type like "ServiceManaged", "AzureKeyVault".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureKeyVault'
    'ServiceManaged'
  ]
  ```

### Parameter: `hardwareFamily`

If the service has different generations of hardware, for the same SKU, then that can be captured here.

- Required: No
- Type: string
- Default: `'Gen5'`

### Parameter: `instancePoolResourceId`

The resource ID of the instance pool this managed server belongs to.

- Required: No
- Type: string

### Parameter: `keys`

The keys to configure.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-keysname) | string | The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverKeyType`](#parameter-keysserverkeytype) | string | The encryption protector type like "ServiceManaged", "AzureKeyVault". |
| [`uri`](#parameter-keysuri) | string | The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required. |

### Parameter: `keys.name`

The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.

- Required: Yes
- Type: string

### Parameter: `keys.serverKeyType`

The encryption protector type like "ServiceManaged", "AzureKeyVault".

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

The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required.

- Required: No
- Type: string

### Parameter: `licenseType`

The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses).

- Required: No
- Type: string
- Default: `'LicenseIncluded'`
- Allowed:
  ```Bicep
  [
    'BasePrice'
    'LicenseIncluded'
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

The maintenance window for the SQL Managed Instance.<p><p>SystemManaged: The system automatically selects a 9-hour maintenance window between 8:00 AM to 5:00 PM local time, Monday - Sunday.<p>Custom1: Weekday window: 10:00 PM to 6:00 AM local time, Monday - Thursday.<p>Custom2: Weekend window: 10:00 PM to 6:00 AM local time, Friday - Sunday.<p>

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Custom1'
    'Custom2'
    'SystemManaged'
  ]
  ```

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

### Parameter: `managedInstanceCreateMode`

Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and sourceManagedInstanceResourceId must be specified.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'PointInTimeRestore'
  ]
  ```

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
    'None'
  ]
  ```

### Parameter: `proxyOverride`

Connection type used for connecting to the instance.

- Required: No
- Type: string
- Default: `'Proxy'`
- Allowed:
  ```Bicep
  [
    'Default'
    'Proxy'
    'Redirect'
  ]
  ```

### Parameter: `publicDataEndpointEnabled`

Whether or not the public data endpoint is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `requestedBackupStorageRedundancy`

The storage account type used to store backups for this database.

- Required: No
- Type: string
- Default: `'Geo'`
- Allowed:
  ```Bicep
  [
    'Geo'
    'GeoZone'
    'Local'
    'Zone'
  ]
  ```

### Parameter: `restorePointInTime`

Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.

- Required: No
- Type: string

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

### Parameter: `securityAlertPolicy`

The security alert policy configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-securityalertpolicyname) | string | The name of the security alert policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountResourceId`](#parameter-securityalertpolicystorageaccountresourceid) | string | A blob storage to  hold all Threat Detection audit logs. Required if state is 'Enabled'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disabledAlerts`](#parameter-securityalertpolicydisabledalerts) | array | Specifies an array of alerts that are disabled. |
| [`emailAccountAdmins`](#parameter-securityalertpolicyemailaccountadmins) | bool | Specifies that the schedule scan notification will be is sent to the subscription administrators. |
| [`emailAddresses`](#parameter-securityalertpolicyemailaddresses) | array | Specifies an array of e-mail addresses to which the alert is sent. |
| [`retentionDays`](#parameter-securityalertpolicyretentiondays) | int | Specifies the number of days to keep in the Threat Detection audit logs. |
| [`state`](#parameter-securityalertpolicystate) | string | Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided. |

### Parameter: `securityAlertPolicy.name`

The name of the security alert policy.

- Required: Yes
- Type: string

### Parameter: `securityAlertPolicy.storageAccountResourceId`

A blob storage to  hold all Threat Detection audit logs. Required if state is 'Enabled'.

- Required: No
- Type: string

### Parameter: `securityAlertPolicy.disabledAlerts`

Specifies an array of alerts that are disabled.

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

### Parameter: `securityAlertPolicy.emailAccountAdmins`

Specifies that the schedule scan notification will be is sent to the subscription administrators.

- Required: No
- Type: bool

### Parameter: `securityAlertPolicy.emailAddresses`

Specifies an array of e-mail addresses to which the alert is sent.

- Required: No
- Type: array

### Parameter: `securityAlertPolicy.retentionDays`

Specifies the number of days to keep in the Threat Detection audit logs.

- Required: No
- Type: int

### Parameter: `securityAlertPolicy.state`

Enables advanced data security features, like recuring vulnerability assesment scans and ATP. If enabled, storage account must be provided.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `servicePrincipal`

Service principal type. If using AD Authentication and applying Admin, must be set to `SystemAssigned`. Then Global Admin must allow Reader access to Azure AD for the Service Principal.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `skuName`

The name of the SKU, typically, a letter + Number code, e.g. P3.

- Required: No
- Type: string
- Default: `'GP_Gen5'`

### Parameter: `skuTier`

The tier or edition of the particular SKU, e.g. Basic, Premium.

- Required: No
- Type: string
- Default: `'GeneralPurpose'`

### Parameter: `sourceManagedInstanceResourceId`

The resource identifier of the source managed instance associated with create operation of this instance.

- Required: No
- Type: string

### Parameter: `storageSizeInGB`

Storage size in GB. Increments of 32 GB allowed only.

- Required: No
- Type: int
- Default: `32`
- MinValue: 32
- MaxValue: 8192

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `timezoneId`

ID of the timezone. Allowed values are timezones supported by Windows.

- Required: No
- Type: string
- Default: `'UTC'`

### Parameter: `vCores`

The number of vCores.

- Required: No
- Type: int
- Default: `4`

### Parameter: `vulnerabilityAssessment`

The vulnerability assessment configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-vulnerabilityassessmentname) | string | The name of the vulnerability assessment. |
| [`storageAccountResourceId`](#parameter-vulnerabilityassessmentstorageaccountresourceid) | string | A blob storage to hold the scan results. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`createStorageRoleAssignment`](#parameter-vulnerabilityassessmentcreatestorageroleassignment) | bool | Create the Storage Blob Data Contributor role assignment on the storage account. Note, the role assignment must not already exist on the storage account. |
| [`recurringScans`](#parameter-vulnerabilityassessmentrecurringscans) | object | The recurring scans configuration. |
| [`useStorageAccountAccessKey`](#parameter-vulnerabilityassessmentusestorageaccountaccesskey) | bool | Use Access Key to access the storage account. The storage account cannot be behind a firewall or virtual network. If an access key is not used, the SQL MI system assigned managed identity must be assigned the Storage Blob Data Contributor role on the storage account. |

### Parameter: `vulnerabilityAssessment.name`

The name of the vulnerability assessment.

- Required: Yes
- Type: string

### Parameter: `vulnerabilityAssessment.storageAccountResourceId`

A blob storage to hold the scan results.

- Required: Yes
- Type: string

### Parameter: `vulnerabilityAssessment.createStorageRoleAssignment`

Create the Storage Blob Data Contributor role assignment on the storage account. Note, the role assignment must not already exist on the storage account.

- Required: No
- Type: bool

### Parameter: `vulnerabilityAssessment.recurringScans`

The recurring scans configuration.

- Required: No
- Type: object

### Parameter: `vulnerabilityAssessment.useStorageAccountAccessKey`

Use Access Key to access the storage account. The storage account cannot be behind a firewall or virtual network. If an access key is not used, the SQL MI system assigned managed identity must be assigned the Storage Blob Data Contributor role on the storage account.

- Required: No
- Type: bool

### Parameter: `zoneRedundant`

Whether or not multi-az is enabled.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed managed instance. |
| `resourceGroupName` | string | The resource group of the deployed managed instance. |
| `resourceId` | string | The resource ID of the deployed managed instance. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
