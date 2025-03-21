# SQL Managed Instances `[Microsoft.Sql/managedInstances]`

This module deploys a SQL Managed Instance.

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/managedInstances` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances) |
| `Microsoft.Sql/managedInstances/administrators` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/administrators) |
| `Microsoft.Sql/managedInstances/databases` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/databases) |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/databases/backupShortTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/encryptionProtector` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/encryptionProtector) |
| `Microsoft.Sql/managedInstances/keys` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/keys) |
| `Microsoft.Sql/managedInstances/securityAlertPolicies` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/securityAlertPolicies) |
| `Microsoft.Sql/managedInstances/vulnerabilityAssessments` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/vulnerabilityAssessments) |

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
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmimin'
    subnetResourceId: '<subnetResourceId>'
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "sqlmimin"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
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
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param name = 'sqlmimin'
param subnetResourceId = '<subnetResourceId>'
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
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmimax'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
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
    dnsZonePartner: ''
    encryptionProtectorObj: {
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
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
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
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    timezoneId: 'UTC'
    vCores: 4
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: '<storageAccountResourceId>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "sqlmimax"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
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
    "dnsZonePartner": {
      "value": ""
    },
    "encryptionProtectorObj": {
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
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
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
    "securityAlertPoliciesObj": {
      "value": {
        "emailAccountAdmins": true,
        "name": "default",
        "state": "Enabled"
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
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
        "storageAccountResourceId": "<storageAccountResourceId>",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
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
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param name = 'sqlmimax'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
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
param dnsZonePartner = ''
param encryptionProtectorObj = {
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
param primaryUserAssignedIdentityId = '<primaryUserAssignedIdentityId>'
param proxyOverride = 'Proxy'
param publicDataEndpointEnabled = false
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
param securityAlertPoliciesObj = {
  emailAccountAdmins: true
  name: 'default'
  state: 'Enabled'
}
param servicePrincipal = 'SystemAssigned'
param skuName = 'GP_Gen5'
param skuTier = 'GeneralPurpose'
param storageSizeInGB = 32
param timezoneId = 'UTC'
param vCores = 4
param vulnerabilityAssessmentsObj = {
  emailSubscriptionAdmins: true
  name: 'default'
  recurringScansEmails: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  recurringScansIsEnabled: true
  storageAccountResourceId: '<storageAccountResourceId>'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
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
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmivln'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
    }
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
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
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "sqlmivln"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "securityAlertPoliciesObj": {
      "value": {
        "emailAccountAdmins": true,
        "name": "default",
        "state": "Enabled"
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
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        },
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
using 'br/public:avm/res/sql/managed-instance:<version>'

// Required parameters
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param name = 'sqlmivln'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
}
param securityAlertPoliciesObj = {
  emailAccountAdmins: true
  name: 'default'
  state: 'Enabled'
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
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
  useStorageAccountAccessKey: false
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
    administratorLogin: 'adminUserName'
    administratorLoginPassword: '<administratorLoginPassword>'
    name: 'sqlmiwaf'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
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
    dnsZonePartner: ''
    encryptionProtectorObj: {
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
    maintenanceWindow: 'Custom2'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    primaryUserAssignedIdentityId: '<primaryUserAssignedIdentityId>'
    proxyOverride: 'Proxy'
    publicDataEndpointEnabled: false
    securityAlertPoliciesObj: {
      emailAccountAdmins: true
      name: 'default'
      state: 'Enabled'
    }
    servicePrincipal: 'SystemAssigned'
    skuName: 'GP_Gen5'
    skuTier: 'GeneralPurpose'
    storageSizeInGB: 32
    timezoneId: 'UTC'
    vCores: 4
    vulnerabilityAssessmentsObj: {
      emailSubscriptionAdmins: true
      name: 'default'
      recurringScansEmails: [
        'test1@contoso.com'
        'test2@contoso.com'
      ]
      recurringScansIsEnabled: true
      storageAccountResourceId: '<storageAccountResourceId>'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
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
    "administratorLogin": {
      "value": "adminUserName"
    },
    "administratorLoginPassword": {
      "value": "<administratorLoginPassword>"
    },
    "name": {
      "value": "sqlmiwaf"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
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
    "dnsZonePartner": {
      "value": ""
    },
    "encryptionProtectorObj": {
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
    "primaryUserAssignedIdentityId": {
      "value": "<primaryUserAssignedIdentityId>"
    },
    "proxyOverride": {
      "value": "Proxy"
    },
    "publicDataEndpointEnabled": {
      "value": false
    },
    "securityAlertPoliciesObj": {
      "value": {
        "emailAccountAdmins": true,
        "name": "default",
        "state": "Enabled"
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
    "vulnerabilityAssessmentsObj": {
      "value": {
        "emailSubscriptionAdmins": true,
        "name": "default",
        "recurringScansEmails": [
          "test1@contoso.com",
          "test2@contoso.com"
        ],
        "recurringScansIsEnabled": true,
        "storageAccountResourceId": "<storageAccountResourceId>",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
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
param administratorLogin = 'adminUserName'
param administratorLoginPassword = '<administratorLoginPassword>'
param name = 'sqlmiwaf'
param subnetResourceId = '<subnetResourceId>'
// Non-required parameters
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
param dnsZonePartner = ''
param encryptionProtectorObj = {
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
param maintenanceWindow = 'Custom2'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param primaryUserAssignedIdentityId = '<primaryUserAssignedIdentityId>'
param proxyOverride = 'Proxy'
param publicDataEndpointEnabled = false
param securityAlertPoliciesObj = {
  emailAccountAdmins: true
  name: 'default'
  state: 'Enabled'
}
param servicePrincipal = 'SystemAssigned'
param skuName = 'GP_Gen5'
param skuTier = 'GeneralPurpose'
param storageSizeInGB = 32
param timezoneId = 'UTC'
param vCores = 4
param vulnerabilityAssessmentsObj = {
  emailSubscriptionAdmins: true
  name: 'default'
  recurringScansEmails: [
    'test1@contoso.com'
    'test2@contoso.com'
  ]
  recurringScansIsEnabled: true
  storageAccountResourceId: '<storageAccountResourceId>'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorLogin`](#parameter-administratorlogin) | string | The username used to establish jumpbox VMs. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | The password given to the admin user. |
| [`name`](#parameter-name) | string | The name of the SQL managed instance. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The fully qualified resource ID of the subnet on which the SQL managed instance will be placed. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`primaryUserAssignedIdentityId`](#parameter-primaryuserassignedidentityid) | string | The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`administratorsObj`](#parameter-administratorsobj) | object | The administrator configuration. |
| [`collation`](#parameter-collation) | string | Collation of the managed instance. |
| [`databases`](#parameter-databases) | array | Databases to create in this server. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsZonePartner`](#parameter-dnszonepartner) | string | The resource ID of another managed instance whose DNS zone this managed instance will share after creation. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionProtectorObj`](#parameter-encryptionprotectorobj) | object | The encryption protection configuration. |
| [`hardwareFamily`](#parameter-hardwarefamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`instancePoolResourceId`](#parameter-instancepoolresourceid) | string | The resource ID of the instance pool this managed server belongs to. |
| [`keys`](#parameter-keys) | array | The keys to configure. |
| [`licenseType`](#parameter-licensetype) | string | The license type. Possible values are 'LicenseIncluded' (regular price inclusive of a new SQL license) and 'BasePrice' (discounted AHB price for bringing your own SQL licenses). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceWindow`](#parameter-maintenancewindow) | string | The maintenance window for the SQL Managed Instance.<p><p>SystemManaged: The system automatically selects a 9-hour maintenance window between 8:00 AM to 5:00 PM local time, Monday - Sunday.<p>Custom1: Weekday window: 10:00 PM to 6:00 AM local time, Monday - Thursday.<p>Custom2: Weekend window: 10:00 PM to 6:00 AM local time, Friday - Sunday.<p> |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`managedInstanceCreateMode`](#parameter-managedinstancecreatemode) | string | Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified. |
| [`minimalTlsVersion`](#parameter-minimaltlsversion) | string | Minimal TLS version allowed. |
| [`proxyOverride`](#parameter-proxyoverride) | string | Connection type used for connecting to the instance. |
| [`publicDataEndpointEnabled`](#parameter-publicdataendpointenabled) | bool | Whether or not the public data endpoint is enabled. |
| [`requestedBackupStorageRedundancy`](#parameter-requestedbackupstorageredundancy) | string | The storage account type used to store backups for this database. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityAlertPoliciesObj`](#parameter-securityalertpoliciesobj) | object | The security alert policy configuration. |
| [`servicePrincipal`](#parameter-serviceprincipal) | string | Service principal type. If using AD Authentication and applying Admin, must be set to `SystemAssigned`. Then Global Admin must allow Reader access to Azure AD for the Service Principal. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |
| [`skuTier`](#parameter-skutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |
| [`sourceManagedInstanceId`](#parameter-sourcemanagedinstanceid) | string | The resource identifier of the source managed instance associated with create operation of this instance. |
| [`storageSizeInGB`](#parameter-storagesizeingb) | int | Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`timezoneId`](#parameter-timezoneid) | string | ID of the timezone. Allowed values are timezones supported by Windows. |
| [`vCores`](#parameter-vcores) | int | The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80. |
| [`vulnerabilityAssessmentsObj`](#parameter-vulnerabilityassessmentsobj) | object | The vulnerability assessment configuration. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not multi-az is enabled. |

### Parameter: `administratorLogin`

The username used to establish jumpbox VMs.

- Required: Yes
- Type: string

### Parameter: `administratorLoginPassword`

The password given to the admin user.

- Required: Yes
- Type: securestring

### Parameter: `name`

The name of the SQL managed instance.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

The fully qualified resource ID of the subnet on which the SQL managed instance will be placed.

- Required: Yes
- Type: string

### Parameter: `primaryUserAssignedIdentityId`

The resource ID of a user assigned identity to be used by default. Required if "userAssignedIdentities" is not empty.

- Required: No
- Type: string

### Parameter: `administratorsObj`

The administrator configuration.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `collation`

Collation of the managed instance.

- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `databases`

Databases to create in this server.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `dnsZonePartner`

The resource ID of another managed instance whose DNS zone this managed instance will share after creation.

- Required: No
- Type: string

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
- Default: `[]`

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

The maintenance window for the SQL Managed Instance.<p><p>SystemManaged: The system automatically selects a 9-hour maintenance window between 8:00 AM to 5:00 PM local time, Monday - Sunday.<p>Custom1: Weekday window: 10:00 PM to 6:00 AM local time, Monday - Thursday.<p>Custom2: Weekend window: 10:00 PM to 6:00 AM local time, Friday - Sunday.<p>

- Required: No
- Type: string
- Default: `'Custom2'`
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

Specifies the mode of database creation. Default: Regular instance creation. Restore: Creates an instance by restoring a set of backups to specific point in time. RestorePointInTime and SourceManagedInstanceId must be specified.

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

### Parameter: `securityAlertPoliciesObj`

The security alert policy configuration.

- Required: No
- Type: object
- Default: `{}`

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

### Parameter: `sourceManagedInstanceId`

The resource identifier of the source managed instance associated with create operation of this instance.

- Required: No
- Type: string

### Parameter: `storageSizeInGB`

Storage size in GB. Minimum value: 32. Maximum value: 8192. Increments of 32 GB allowed only.

- Required: No
- Type: int
- Default: `32`

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

The number of vCores. Allowed values: 8, 16, 24, 32, 40, 64, 80.

- Required: No
- Type: int
- Default: `4`

### Parameter: `vulnerabilityAssessmentsObj`

The vulnerability assessment configuration.

- Required: No
- Type: object
- Default: `{}`

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
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
