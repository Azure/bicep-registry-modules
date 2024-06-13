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
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
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

<summary>via JSON Parameter file</summary>

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

<summary>via JSON Parameter file</summary>

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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'Webhook'
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
        service: 'Webhook'
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

<summary>via JSON Parameter file</summary>

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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "Webhook",
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
          "service": "Webhook",
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'Webhook'
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

<summary>via JSON Parameter file</summary>

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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "Webhook",
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-credentials) | array | List of credentials to be created in the automation account. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableLocalAuth`](#parameter-disablelocalauth) | bool | Disable local authentication profile used within the resource. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gallerySolutions`](#parameter-gallerysolutions) | array | List of gallerySolutions to be created in the linked log analytics workspace. |
| [`jobSchedules`](#parameter-jobschedules) | array | List of jobSchedules to be created in the automation account. |
| [`linkedWorkspaceResourceId`](#parameter-linkedworkspaceresourceid) | string | ID of the log analytics workspace to be linked to the deployed automation account. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`modules`](#parameter-modules) | array | List of modules to be created in the automation account. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
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
- Default: `[]`

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
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

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

### Parameter: `modules`

List of modules to be created in the automation account.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file". |
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
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | array | The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-privateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.service`

The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file".

- Required: Yes
- Type: string

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
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint ip address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private ip addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint ip address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private ip addresses of the private endpoint.

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
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private ip address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private ip address obtained from the private endpoint's subnet.

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

The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.

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

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

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
| `resourceGroupName` | string | The resource group of the deployed automation account. |
| `resourceId` | string | The resource ID of the deployed automation account. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `res/operational-insights/workspace/linked-service` | Local reference |
| `br/public:avm/res/network/private-endpoint:0.4.1` | Remote reference |
| `br/public:avm/res/operations-management/solution:0.1.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
