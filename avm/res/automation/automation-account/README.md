# Automation Accounts `[Microsoft.Automation/automationAccounts]`

This module deploys an Azure Automation Account.

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
| `Microsoft.Automation/automationAccounts` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts) |
| `Microsoft.Automation/automationAccounts/credentials` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2023-11-01/automationAccounts/credentials) |
| `Microsoft.Automation/automationAccounts/jobSchedules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/jobSchedules) |
| `Microsoft.Automation/automationAccounts/modules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/modules) |
| `Microsoft.Automation/automationAccounts/runbooks` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2023-11-01/automationAccounts/runbooks) |
| `Microsoft.Automation/automationAccounts/schedules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/schedules) |
| `Microsoft.Automation/automationAccounts/softwareUpdateConfigurations` | [2019-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2019-06-01/automationAccounts/softwareUpdateConfigurations) |
| `Microsoft.Automation/automationAccounts/variables` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/variables) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/automation/automation-account:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using encryption with Customer-Managed-Key](#example-2-using-encryption-with-customer-managed-key)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module automationAccount 'br/public:avm/res/automation/automation-account:<version>' = {
  name: 'automationAccountDeployment'
  params: {
    // Required parameters
    name: 'aamin001'
    // Non-required parameters
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
      "value": "aamin001"
    },
    // Non-required parameters
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
using 'br/public:avm/res/automation/automation-account:<version>'

// Required parameters
param name = 'aamin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using encryption with Customer-Managed-Key_

This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.


<details>

<summary>via Bicep module</summary>

```bicep
module automationAccount 'br/public:avm/res/automation/automation-account:<version>' = {
  name: 'automationAccountDeployment'
  params: {
    // Required parameters
    name: 'aaencr001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    location: '<location>'
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
    "name": {
      "value": "aaencr001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/automation/automation-account:<version>'

// Required parameters
param name = 'aaencr001'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module automationAccount 'br/public:avm/res/automation/automation-account:<version>' = {
  name: 'automationAccountDeployment'
  params: {
    // Required parameters
    name: 'aamax001'
    // Non-required parameters
    credentials: [
      {
        description: 'Description of Credential01'
        name: 'Credential01'
        password: '<password>'
        userName: 'userName01'
      }
      {
        name: 'Credential02'
        password: '<password>'
        userName: 'username02'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableLocalAuth: true
    gallerySolutions: [
      {
        name: 'Updates'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
    jobSchedules: [
      {
        runbookName: 'TestRunbook'
        scheduleName: 'TestSchedule'
      }
    ]
    linkedWorkspaceResourceId: '<linkedWorkspaceResourceId>'
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
    modules: [
      {
        name: 'PSWindowsUpdate'
        uri: 'https://www.powershellgallery.com/api/v2/package'
        version: 'latest'
      }
    ]
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'Webhook'
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
        service: 'Webhook'
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
        service: 'DSCAndHybridWorker'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        name: 'de334944-f952-4273-8ab3-bd523380034c'
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
    runbooks: [
      {
        description: 'Test runbook'
        name: 'TestRunbook'
        type: 'PowerShell'
        uri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1'
        version: '1.0.0.0'
      }
    ]
    schedules: [
      {
        advancedSchedule: {}
        expiryTime: '9999-12-31T13:00'
        frequency: 'Hour'
        interval: 12
        name: 'TestSchedule'
        startTime: ''
        timeZone: 'Europe/Berlin'
      }
    ]
    softwareUpdateConfigurations: [
      {
        excludeUpdates: [
          '123456'
        ]
        frequency: 'Month'
        includeUpdates: [
          '654321'
        ]
        interval: 1
        maintenanceWindow: 'PT4H'
        monthlyOccurrences: [
          {
            day: 'Friday'
            occurrence: 3
          }
        ]
        name: 'Windows_ZeroDay'
        operatingSystem: 'Windows'
        rebootSetting: 'IfRequired'
        scopeByTags: {
          Update: [
            'Automatic-Wave1'
          ]
        }
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Definition'
          'FeaturePack'
          'Security'
          'ServicePack'
          'Tools'
          'UpdateRollup'
          'Updates'
        ]
      }
      {
        excludeUpdates: [
          'icacls'
        ]
        frequency: 'OneTime'
        includeUpdates: [
          'kernel'
        ]
        maintenanceWindow: 'PT4H'
        name: 'Linux_ZeroDay'
        operatingSystem: 'Linux'
        rebootSetting: 'IfRequired'
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Other'
          'Security'
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    variables: [
      {
        description: 'TestStringDescription'
        name: 'TestString'
        value: '\'TestString\''
      }
      {
        description: 'TestIntegerDescription'
        name: 'TestInteger'
        value: '500'
      }
      {
        description: 'TestBooleanDescription'
        name: 'TestBoolean'
        value: 'false'
      }
      {
        description: 'TestDateTimeDescription'
        isEncrypted: false
        name: 'TestDateTime'
        value: '\'\\/Date(1637934042656)\\/\''
      }
      {
        description: 'TestEncryptedDescription'
        name: 'TestEncryptedVariable'
        value: '\'TestEncryptedValue\''
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
    "name": {
      "value": "aamax001"
    },
    // Non-required parameters
    "credentials": {
      "value": [
        {
          "description": "Description of Credential01",
          "name": "Credential01",
          "password": "<password>",
          "userName": "userName01"
        },
        {
          "name": "Credential02",
          "password": "<password>",
          "userName": "username02"
        }
      ]
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
    "disableLocalAuth": {
      "value": true
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "Updates",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "jobSchedules": {
      "value": [
        {
          "runbookName": "TestRunbook",
          "scheduleName": "TestSchedule"
        }
      ]
    },
    "linkedWorkspaceResourceId": {
      "value": "<linkedWorkspaceResourceId>"
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
    "modules": {
      "value": [
        {
          "name": "PSWindowsUpdate",
          "uri": "https://www.powershellgallery.com/api/v2/package",
          "version": "latest"
        }
      ]
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
          "service": "Webhook",
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
          "service": "Webhook",
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
          "service": "DSCAndHybridWorker",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "de334944-f952-4273-8ab3-bd523380034c",
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
    "runbooks": {
      "value": [
        {
          "description": "Test runbook",
          "name": "TestRunbook",
          "type": "PowerShell",
          "uri": "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1",
          "version": "1.0.0.0"
        }
      ]
    },
    "schedules": {
      "value": [
        {
          "advancedSchedule": {},
          "expiryTime": "9999-12-31T13:00",
          "frequency": "Hour",
          "interval": 12,
          "name": "TestSchedule",
          "startTime": "",
          "timeZone": "Europe/Berlin"
        }
      ]
    },
    "softwareUpdateConfigurations": {
      "value": [
        {
          "excludeUpdates": [
            "123456"
          ],
          "frequency": "Month",
          "includeUpdates": [
            "654321"
          ],
          "interval": 1,
          "maintenanceWindow": "PT4H",
          "monthlyOccurrences": [
            {
              "day": "Friday",
              "occurrence": 3
            }
          ],
          "name": "Windows_ZeroDay",
          "operatingSystem": "Windows",
          "rebootSetting": "IfRequired",
          "scopeByTags": {
            "Update": [
              "Automatic-Wave1"
            ]
          },
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Definition",
            "FeaturePack",
            "Security",
            "ServicePack",
            "Tools",
            "UpdateRollup",
            "Updates"
          ]
        },
        {
          "excludeUpdates": [
            "icacls"
          ],
          "frequency": "OneTime",
          "includeUpdates": [
            "kernel"
          ],
          "maintenanceWindow": "PT4H",
          "name": "Linux_ZeroDay",
          "operatingSystem": "Linux",
          "rebootSetting": "IfRequired",
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Other",
            "Security"
          ]
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
    "variables": {
      "value": [
        {
          "description": "TestStringDescription",
          "name": "TestString",
          "value": "\"TestString\""
        },
        {
          "description": "TestIntegerDescription",
          "name": "TestInteger",
          "value": "500"
        },
        {
          "description": "TestBooleanDescription",
          "name": "TestBoolean",
          "value": "false"
        },
        {
          "description": "TestDateTimeDescription",
          "isEncrypted": false,
          "name": "TestDateTime",
          "value": "\"\\/Date(1637934042656)\\/\""
        },
        {
          "description": "TestEncryptedDescription",
          "name": "TestEncryptedVariable",
          "value": "\"TestEncryptedValue\""
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
using 'br/public:avm/res/automation/automation-account:<version>'

// Required parameters
param name = 'aamax001'
// Non-required parameters
param credentials = [
  {
    description: 'Description of Credential01'
    name: 'Credential01'
    password: '<password>'
    userName: 'userName01'
  }
  {
    name: 'Credential02'
    password: '<password>'
    userName: 'username02'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disableLocalAuth = true
param gallerySolutions = [
  {
    name: 'Updates'
    product: 'OMSGallery'
    publisher: 'Microsoft'
  }
]
param jobSchedules = [
  {
    runbookName: 'TestRunbook'
    scheduleName: 'TestSchedule'
  }
]
param linkedWorkspaceResourceId = '<linkedWorkspaceResourceId>'
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
param modules = [
  {
    name: 'PSWindowsUpdate'
    uri: 'https://www.powershellgallery.com/api/v2/package'
    version: 'latest'
  }
]
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'Webhook'
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
    service: 'Webhook'
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
    service: 'DSCAndHybridWorker'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param roleAssignments = [
  {
    name: 'de334944-f952-4273-8ab3-bd523380034c'
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
param runbooks = [
  {
    description: 'Test runbook'
    name: 'TestRunbook'
    type: 'PowerShell'
    uri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1'
    version: '1.0.0.0'
  }
]
param schedules = [
  {
    advancedSchedule: {}
    expiryTime: '9999-12-31T13:00'
    frequency: 'Hour'
    interval: 12
    name: 'TestSchedule'
    startTime: ''
    timeZone: 'Europe/Berlin'
  }
]
param softwareUpdateConfigurations = [
  {
    excludeUpdates: [
      '123456'
    ]
    frequency: 'Month'
    includeUpdates: [
      '654321'
    ]
    interval: 1
    maintenanceWindow: 'PT4H'
    monthlyOccurrences: [
      {
        day: 'Friday'
        occurrence: 3
      }
    ]
    name: 'Windows_ZeroDay'
    operatingSystem: 'Windows'
    rebootSetting: 'IfRequired'
    scopeByTags: {
      Update: [
        'Automatic-Wave1'
      ]
    }
    startTime: '22:00'
    updateClassifications: [
      'Critical'
      'Definition'
      'FeaturePack'
      'Security'
      'ServicePack'
      'Tools'
      'UpdateRollup'
      'Updates'
    ]
  }
  {
    excludeUpdates: [
      'icacls'
    ]
    frequency: 'OneTime'
    includeUpdates: [
      'kernel'
    ]
    maintenanceWindow: 'PT4H'
    name: 'Linux_ZeroDay'
    operatingSystem: 'Linux'
    rebootSetting: 'IfRequired'
    startTime: '22:00'
    updateClassifications: [
      'Critical'
      'Other'
      'Security'
    ]
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param variables = [
  {
    description: 'TestStringDescription'
    name: 'TestString'
    value: '\'TestString\''
  }
  {
    description: 'TestIntegerDescription'
    name: 'TestInteger'
    value: '500'
  }
  {
    description: 'TestBooleanDescription'
    name: 'TestBoolean'
    value: 'false'
  }
  {
    description: 'TestDateTimeDescription'
    isEncrypted: false
    name: 'TestDateTime'
    value: '\'\\/Date(1637934042656)\\/\''
  }
  {
    description: 'TestEncryptedDescription'
    name: 'TestEncryptedVariable'
    value: '\'TestEncryptedValue\''
  }
]
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module automationAccount 'br/public:avm/res/automation/automation-account:<version>' = {
  name: 'automationAccountDeployment'
  params: {
    // Required parameters
    name: 'aawaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableLocalAuth: true
    gallerySolutions: [
      {
        name: 'Updates'
        product: 'OMSGallery'
        publisher: 'Microsoft'
      }
    ]
    jobSchedules: [
      {
        runbookName: 'TestRunbook'
        scheduleName: 'TestSchedule'
      }
    ]
    linkedWorkspaceResourceId: '<linkedWorkspaceResourceId>'
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
    modules: [
      {
        name: 'PSWindowsUpdate'
        uri: 'https://www.powershellgallery.com/api/v2/package'
        version: 'latest'
      }
    ]
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'Webhook'
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
        service: 'DSCAndHybridWorker'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    runbooks: [
      {
        description: 'Test runbook'
        name: 'TestRunbook'
        type: 'PowerShell'
        uri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1'
        version: '1.0.0.0'
      }
    ]
    schedules: [
      {
        advancedSchedule: {}
        expiryTime: '9999-12-31T13:00'
        frequency: 'Hour'
        interval: 12
        name: 'TestSchedule'
        startTime: ''
        timeZone: 'Europe/Berlin'
      }
    ]
    softwareUpdateConfigurations: [
      {
        excludeUpdates: [
          '123456'
        ]
        frequency: 'Month'
        includeUpdates: [
          '654321'
        ]
        interval: 1
        maintenanceWindow: 'PT4H'
        monthlyOccurrences: [
          {
            day: 'Friday'
            occurrence: 3
          }
        ]
        name: 'Windows_ZeroDay'
        operatingSystem: 'Windows'
        rebootSetting: 'IfRequired'
        scopeByTags: {
          Update: [
            'Automatic-Wave1'
          ]
        }
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Definition'
          'FeaturePack'
          'Security'
          'ServicePack'
          'Tools'
          'UpdateRollup'
          'Updates'
        ]
      }
      {
        excludeUpdates: [
          'icacls'
        ]
        frequency: 'OneTime'
        includeUpdates: [
          'kernel'
        ]
        maintenanceWindow: 'PT4H'
        name: 'Linux_ZeroDay'
        operatingSystem: 'Linux'
        rebootSetting: 'IfRequired'
        startTime: '22:00'
        updateClassifications: [
          'Critical'
          'Other'
          'Security'
        ]
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    variables: [
      {
        description: 'TestStringDescription'
        name: 'TestString'
        value: '\'TestString\''
      }
      {
        description: 'TestIntegerDescription'
        name: 'TestInteger'
        value: '500'
      }
      {
        description: 'TestBooleanDescription'
        name: 'TestBoolean'
        value: 'false'
      }
      {
        description: 'TestDateTimeDescription'
        name: 'TestDateTime'
        value: '\'\\/Date(1637934042656)\\/\''
      }
      {
        description: 'TestEncryptedDescription'
        name: 'TestEncryptedVariable'
        value: '\'TestEncryptedValue\''
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
    "name": {
      "value": "aawaf001"
    },
    // Non-required parameters
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
    "disableLocalAuth": {
      "value": true
    },
    "gallerySolutions": {
      "value": [
        {
          "name": "Updates",
          "product": "OMSGallery",
          "publisher": "Microsoft"
        }
      ]
    },
    "jobSchedules": {
      "value": [
        {
          "runbookName": "TestRunbook",
          "scheduleName": "TestSchedule"
        }
      ]
    },
    "linkedWorkspaceResourceId": {
      "value": "<linkedWorkspaceResourceId>"
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
    "modules": {
      "value": [
        {
          "name": "PSWindowsUpdate",
          "uri": "https://www.powershellgallery.com/api/v2/package",
          "version": "latest"
        }
      ]
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
          "service": "Webhook",
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
          "service": "DSCAndHybridWorker",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "runbooks": {
      "value": [
        {
          "description": "Test runbook",
          "name": "TestRunbook",
          "type": "PowerShell",
          "uri": "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1",
          "version": "1.0.0.0"
        }
      ]
    },
    "schedules": {
      "value": [
        {
          "advancedSchedule": {},
          "expiryTime": "9999-12-31T13:00",
          "frequency": "Hour",
          "interval": 12,
          "name": "TestSchedule",
          "startTime": "",
          "timeZone": "Europe/Berlin"
        }
      ]
    },
    "softwareUpdateConfigurations": {
      "value": [
        {
          "excludeUpdates": [
            "123456"
          ],
          "frequency": "Month",
          "includeUpdates": [
            "654321"
          ],
          "interval": 1,
          "maintenanceWindow": "PT4H",
          "monthlyOccurrences": [
            {
              "day": "Friday",
              "occurrence": 3
            }
          ],
          "name": "Windows_ZeroDay",
          "operatingSystem": "Windows",
          "rebootSetting": "IfRequired",
          "scopeByTags": {
            "Update": [
              "Automatic-Wave1"
            ]
          },
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Definition",
            "FeaturePack",
            "Security",
            "ServicePack",
            "Tools",
            "UpdateRollup",
            "Updates"
          ]
        },
        {
          "excludeUpdates": [
            "icacls"
          ],
          "frequency": "OneTime",
          "includeUpdates": [
            "kernel"
          ],
          "maintenanceWindow": "PT4H",
          "name": "Linux_ZeroDay",
          "operatingSystem": "Linux",
          "rebootSetting": "IfRequired",
          "startTime": "22:00",
          "updateClassifications": [
            "Critical",
            "Other",
            "Security"
          ]
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
    "variables": {
      "value": [
        {
          "description": "TestStringDescription",
          "name": "TestString",
          "value": "\"TestString\""
        },
        {
          "description": "TestIntegerDescription",
          "name": "TestInteger",
          "value": "500"
        },
        {
          "description": "TestBooleanDescription",
          "name": "TestBoolean",
          "value": "false"
        },
        {
          "description": "TestDateTimeDescription",
          "name": "TestDateTime",
          "value": "\"\\/Date(1637934042656)\\/\""
        },
        {
          "description": "TestEncryptedDescription",
          "name": "TestEncryptedVariable",
          "value": "\"TestEncryptedValue\""
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
using 'br/public:avm/res/automation/automation-account:<version>'

// Required parameters
param name = 'aawaf001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disableLocalAuth = true
param gallerySolutions = [
  {
    name: 'Updates'
    product: 'OMSGallery'
    publisher: 'Microsoft'
  }
]
param jobSchedules = [
  {
    runbookName: 'TestRunbook'
    scheduleName: 'TestSchedule'
  }
]
param linkedWorkspaceResourceId = '<linkedWorkspaceResourceId>'
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
param modules = [
  {
    name: 'PSWindowsUpdate'
    uri: 'https://www.powershellgallery.com/api/v2/package'
    version: 'latest'
  }
]
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    service: 'Webhook'
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
    service: 'DSCAndHybridWorker'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
]
param runbooks = [
  {
    description: 'Test runbook'
    name: 'TestRunbook'
    type: 'PowerShell'
    uri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1'
    version: '1.0.0.0'
  }
]
param schedules = [
  {
    advancedSchedule: {}
    expiryTime: '9999-12-31T13:00'
    frequency: 'Hour'
    interval: 12
    name: 'TestSchedule'
    startTime: ''
    timeZone: 'Europe/Berlin'
  }
]
param softwareUpdateConfigurations = [
  {
    excludeUpdates: [
      '123456'
    ]
    frequency: 'Month'
    includeUpdates: [
      '654321'
    ]
    interval: 1
    maintenanceWindow: 'PT4H'
    monthlyOccurrences: [
      {
        day: 'Friday'
        occurrence: 3
      }
    ]
    name: 'Windows_ZeroDay'
    operatingSystem: 'Windows'
    rebootSetting: 'IfRequired'
    scopeByTags: {
      Update: [
        'Automatic-Wave1'
      ]
    }
    startTime: '22:00'
    updateClassifications: [
      'Critical'
      'Definition'
      'FeaturePack'
      'Security'
      'ServicePack'
      'Tools'
      'UpdateRollup'
      'Updates'
    ]
  }
  {
    excludeUpdates: [
      'icacls'
    ]
    frequency: 'OneTime'
    includeUpdates: [
      'kernel'
    ]
    maintenanceWindow: 'PT4H'
    name: 'Linux_ZeroDay'
    operatingSystem: 'Linux'
    rebootSetting: 'IfRequired'
    startTime: '22:00'
    updateClassifications: [
      'Critical'
      'Other'
      'Security'
    ]
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param variables = [
  {
    description: 'TestStringDescription'
    name: 'TestString'
    value: '\'TestString\''
  }
  {
    description: 'TestIntegerDescription'
    name: 'TestInteger'
    value: '500'
  }
  {
    description: 'TestBooleanDescription'
    name: 'TestBoolean'
    value: 'false'
  }
  {
    description: 'TestDateTimeDescription'
    name: 'TestDateTime'
    value: '\'\\/Date(1637934042656)\\/\''
  }
  {
    description: 'TestEncryptedDescription'
    name: 'TestEncryptedVariable'
    value: '\'TestEncryptedValue\''
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-credentials) | array | List of credentials to be created in the automation account. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | Disable local authentication profile used within the resource. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gallerySolutions`](#parameter-gallerysolutions) | array | List of gallerySolutions to be created in the linked log analytics workspace. |
| [`jobSchedules`](#parameter-jobschedules) | array | List of jobSchedules to be created in the automation account. |
| [`linkedWorkspaceResourceId`](#parameter-linkedworkspaceresourceid) | string | ID of the log analytics workspace to be linked to the deployed automation account. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`modules`](#parameter-modules) | array | List of modules to be created in the automation account. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`runbooks`](#parameter-runbooks) | array | List of runbooks to be created in the automation account. |
| [`schedules`](#parameter-schedules) | array | List of schedules to be created in the automation account. |
| [`skuName`](#parameter-skuname) | string | SKU name of the account. |
| [`softwareUpdateConfigurations`](#parameter-softwareupdateconfigurations) | array | List of softwareUpdateConfigurations to be created in the automation account. |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`variables`](#parameter-variables) | array | List of variables to be created in the automation account. |

### Parameter: `name`

Name of the Automation Account.

- Required: Yes
- Type: string

### Parameter: `credentials`

List of credentials to be created in the automation account.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-credentialsname) | string | Name of the Automation Account credential. |
| [`password`](#parameter-credentialspassword) | securestring | Password of the credential. |
| [`userName`](#parameter-credentialsusername) | string | The user name associated to the credential. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-credentialsdescription) | string | Description of the credential. |

### Parameter: `credentials.name`

Name of the Automation Account credential.

- Required: Yes
- Type: string

### Parameter: `credentials.password`

Password of the credential.

- Required: Yes
- Type: securestring

### Parameter: `credentials.userName`

The user name associated to the credential.

- Required: Yes
- Type: string

### Parameter: `credentials.description`

Description of the credential.

- Required: No
- Type: string

### Parameter: `disableLocalAuth`

Disable local authentication profile used within the resource.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `gallerySolutions`

List of gallerySolutions to be created in the linked log analytics workspace.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `jobSchedules`

List of jobSchedules to be created in the automation account.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `linkedWorkspaceResourceId`

ID of the log analytics workspace to be linked to the deployed automation account.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `modules`

List of modules to be created in the automation account.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.

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

### Parameter: `runbooks`

List of runbooks to be created in the automation account.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `schedules`

List of schedules to be created in the automation account.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `skuName`

SKU name of the account.

- Required: No
- Type: string
- Default: `'Basic'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
  ]
  ```

### Parameter: `softwareUpdateConfigurations`

List of softwareUpdateConfigurations to be created in the automation account.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

### Parameter: `variables`

List of variables to be created in the automation account.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed automation account. |
| `privateEndpoints` | array | The private endpoints of the automation account. |
| `resourceGroupName` | string | The resource group of the deployed automation account. |
| `resourceId` | string | The resource ID of the deployed automation account. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.7.1` | Remote reference |
| `br/public:avm/res/operations-management/solution:0.1.3` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
