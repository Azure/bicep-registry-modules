# Azure Security Center (Defender for Cloud) `[Security/SecurityCenter]`

This module deploys an Azure Security Center (Defender for Cloud) Configuration.

For the associated policy assignments (e.g., Deploy-MDFC-Config), use the [ALZ Bicep Accelerator](https://aka.ms/alz/acc/bicep) or reference the [Deploy-MDFC-Config policy initiative](https://www.azadvertizer.net/azpolicyinitiativesadvertizer/Deploy-MDFC-Config_20240319.html) directly.


You can reference the module as follows:
```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Security/alertsSuppressionRules` | 2019-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_alertssuppressionrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-01-01-preview/alertsSuppressionRules)</li></ul> |
| `Microsoft.Security/assessmentMetadata` | 2025-05-04 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_assessmentmetadata.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2025-05-04/assessmentMetadata)</li></ul> |
| `Microsoft.Security/automations` | 2023-12-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_automations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2023-12-01-preview/automations)</li></ul> |
| `Microsoft.Security/customRecommendations` | 2024-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_customrecommendations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2024-08-01/customRecommendations)</li></ul> |
| `Microsoft.Security/deviceSecurityGroups` | 2019-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_devicesecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/deviceSecurityGroups)</li></ul> |
| `Microsoft.Security/governanceRules` | 2022-01-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_governancerules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2022-01-01-preview/governanceRules)</li></ul> |
| `Microsoft.Security/iotSecuritySolutions` | 2019-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_iotsecuritysolutions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/iotSecuritySolutions)</li></ul> |
| `Microsoft.Security/pricings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_pricings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2024-01-01/pricings)</li></ul> |
| `Microsoft.Security/securityContacts` | 2023-12-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_securitycontacts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2023-12-01-preview/securityContacts)</li></ul> |
| `Microsoft.Security/securityStandards` | 2024-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_securitystandards.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2024-08-01/securityStandards)</li></ul> |
| `Microsoft.Security/serverVulnerabilityAssessmentsSettings` | 2023-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_servervulnerabilityassessmentssettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2023-05-01/serverVulnerabilityAssessmentsSettings)</li></ul> |
| `Microsoft.Security/settings` | 2022-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_settings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2022-05-01/settings)</li></ul> |
| `Microsoft.Security/standardAssignments` | 2024-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_standardassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2024-08-01/standardAssignments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/security/security-center:<version>`.

- [Using default parameter set](#example-1-using-default-parameter-set)
- [Using all parameters](#example-2-using-all-parameters)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using default parameter set_

This instance deploys the module with default parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: {
    defenderPlans: [
      {
        name: 'VirtualMachines'
        pricingTier: 'Standard'
        subPlan: 'P2'
      }
      {
        name: 'SqlServers'
        pricingTier: 'Standard'
      }
      {
        name: 'AppServices'
        pricingTier: 'Standard'
      }
      {
        extensions: [
          {
            isEnabled: 'True'
            name: 'OnUploadMalwareScanning'
          }
          {
            isEnabled: 'True'
            name: 'SensitiveDataDiscovery'
          }
        ]
        name: 'StorageAccounts'
        pricingTier: 'Standard'
        subPlan: 'DefenderForStorageV2'
      }
      {
        name: 'SqlServerVirtualMachines'
        pricingTier: 'Standard'
      }
      {
        name: 'KeyVaults'
        pricingTier: 'Standard'
      }
      {
        name: 'Arm'
        pricingTier: 'Standard'
      }
      {
        name: 'OpenSourceRelationalDatabases'
        pricingTier: 'Standard'
      }
      {
        name: 'Containers'
        pricingTier: 'Standard'
      }
      {
        name: 'CosmosDbs'
        pricingTier: 'Standard'
      }
      {
        name: 'CloudPosture'
        pricingTier: 'Standard'
      }
      {
        name: 'Api'
        pricingTier: 'Standard'
        subPlan: 'P1'
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
    "defenderPlans": {
      "value": [
        {
          "name": "VirtualMachines",
          "pricingTier": "Standard",
          "subPlan": "P2"
        },
        {
          "name": "SqlServers",
          "pricingTier": "Standard"
        },
        {
          "name": "AppServices",
          "pricingTier": "Standard"
        },
        {
          "extensions": [
            {
              "isEnabled": "True",
              "name": "OnUploadMalwareScanning"
            },
            {
              "isEnabled": "True",
              "name": "SensitiveDataDiscovery"
            }
          ],
          "name": "StorageAccounts",
          "pricingTier": "Standard",
          "subPlan": "DefenderForStorageV2"
        },
        {
          "name": "SqlServerVirtualMachines",
          "pricingTier": "Standard"
        },
        {
          "name": "KeyVaults",
          "pricingTier": "Standard"
        },
        {
          "name": "Arm",
          "pricingTier": "Standard"
        },
        {
          "name": "OpenSourceRelationalDatabases",
          "pricingTier": "Standard"
        },
        {
          "name": "Containers",
          "pricingTier": "Standard"
        },
        {
          "name": "CosmosDbs",
          "pricingTier": "Standard"
        },
        {
          "name": "CloudPosture",
          "pricingTier": "Standard"
        },
        {
          "name": "Api",
          "pricingTier": "Standard",
          "subPlan": "P1"
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
using 'br/public:avm/ptn/security/security-center:<version>'

param defenderPlans = [
  {
    name: 'VirtualMachines'
    pricingTier: 'Standard'
    subPlan: 'P2'
  }
  {
    name: 'SqlServers'
    pricingTier: 'Standard'
  }
  {
    name: 'AppServices'
    pricingTier: 'Standard'
  }
  {
    extensions: [
      {
        isEnabled: 'True'
        name: 'OnUploadMalwareScanning'
      }
      {
        isEnabled: 'True'
        name: 'SensitiveDataDiscovery'
      }
    ]
    name: 'StorageAccounts'
    pricingTier: 'Standard'
    subPlan: 'DefenderForStorageV2'
  }
  {
    name: 'SqlServerVirtualMachines'
    pricingTier: 'Standard'
  }
  {
    name: 'KeyVaults'
    pricingTier: 'Standard'
  }
  {
    name: 'Arm'
    pricingTier: 'Standard'
  }
  {
    name: 'OpenSourceRelationalDatabases'
    pricingTier: 'Standard'
  }
  {
    name: 'Containers'
    pricingTier: 'Standard'
  }
  {
    name: 'CosmosDbs'
    pricingTier: 'Standard'
  }
  {
    name: 'CloudPosture'
    pricingTier: 'Standard'
  }
  {
    name: 'Api'
    pricingTier: 'Standard'
    subPlan: 'P1'
  }
]
param location = '<location>'
```

</details>
<p>

### Example 2: _Using all parameters_

This instance deploys the module with all parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: {
    defenderPlans: [
      {
        name: 'VirtualMachines'
        pricingTier: 'Standard'
        subPlan: 'P2'
      }
      {
        name: 'SqlServers'
        pricingTier: 'Standard'
      }
      {
        name: 'AppServices'
        pricingTier: 'Standard'
      }
      {
        extensions: [
          {
            additionalExtensionProperties: {
              CapGBPerMonthPerStorageAccount: 5000
            }
            isEnabled: 'True'
            name: 'OnUploadMalwareScanning'
          }
          {
            isEnabled: 'True'
            name: 'SensitiveDataDiscovery'
          }
        ]
        name: 'StorageAccounts'
        pricingTier: 'Standard'
        subPlan: 'DefenderForStorageV2'
      }
      {
        name: 'SqlServerVirtualMachines'
        pricingTier: 'Standard'
      }
      {
        name: 'KeyVaults'
        pricingTier: 'Standard'
      }
      {
        name: 'Arm'
        pricingTier: 'Standard'
      }
      {
        name: 'OpenSourceRelationalDatabases'
        pricingTier: 'Standard'
      }
      {
        extensions: [
          {
            isEnabled: 'True'
            name: 'ContainerRegistriesVulnerabilityAssessments'
          }
        ]
        name: 'Containers'
        pricingTier: 'Standard'
      }
      {
        name: 'CosmosDbs'
        pricingTier: 'Standard'
      }
      {
        extensions: [
          {
            isEnabled: 'True'
            name: 'AgentlessVmScanning'
          }
          {
            isEnabled: 'True'
            name: 'AgentlessDiscoveryForKubernetes'
          }
          {
            isEnabled: 'True'
            name: 'SensitiveDataDiscovery'
          }
          {
            isEnabled: 'True'
            name: 'ContainerRegistriesVulnerabilityAssessments'
          }
          {
            isEnabled: 'True'
            name: 'EntraPermissionsManagement'
          }
        ]
        name: 'CloudPosture'
        pricingTier: 'Standard'
      }
      {
        name: 'Api'
        pricingTier: 'Standard'
        subPlan: 'P1'
      }
    ]
    location: '<location>'
    securityContactProperties: {
      emails: 'foo@contoso.com'
      isEnabled: true
      notificationsByRole: {
        roles: [
          'Owner'
        ]
        state: 'On'
      }
      notificationsSources: [
        {
          minimalSeverity: 'High'
          sourceType: 'Alert'
        }
        {
          minimalRiskLevel: 'High'
          sourceType: 'AttackPath'
        }
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
    "defenderPlans": {
      "value": [
        {
          "name": "VirtualMachines",
          "pricingTier": "Standard",
          "subPlan": "P2"
        },
        {
          "name": "SqlServers",
          "pricingTier": "Standard"
        },
        {
          "name": "AppServices",
          "pricingTier": "Standard"
        },
        {
          "extensions": [
            {
              "additionalExtensionProperties": {
                "CapGBPerMonthPerStorageAccount": 5000
              },
              "isEnabled": "True",
              "name": "OnUploadMalwareScanning"
            },
            {
              "isEnabled": "True",
              "name": "SensitiveDataDiscovery"
            }
          ],
          "name": "StorageAccounts",
          "pricingTier": "Standard",
          "subPlan": "DefenderForStorageV2"
        },
        {
          "name": "SqlServerVirtualMachines",
          "pricingTier": "Standard"
        },
        {
          "name": "KeyVaults",
          "pricingTier": "Standard"
        },
        {
          "name": "Arm",
          "pricingTier": "Standard"
        },
        {
          "name": "OpenSourceRelationalDatabases",
          "pricingTier": "Standard"
        },
        {
          "extensions": [
            {
              "isEnabled": "True",
              "name": "ContainerRegistriesVulnerabilityAssessments"
            }
          ],
          "name": "Containers",
          "pricingTier": "Standard"
        },
        {
          "name": "CosmosDbs",
          "pricingTier": "Standard"
        },
        {
          "extensions": [
            {
              "isEnabled": "True",
              "name": "AgentlessVmScanning"
            },
            {
              "isEnabled": "True",
              "name": "AgentlessDiscoveryForKubernetes"
            },
            {
              "isEnabled": "True",
              "name": "SensitiveDataDiscovery"
            },
            {
              "isEnabled": "True",
              "name": "ContainerRegistriesVulnerabilityAssessments"
            },
            {
              "isEnabled": "True",
              "name": "EntraPermissionsManagement"
            }
          ],
          "name": "CloudPosture",
          "pricingTier": "Standard"
        },
        {
          "name": "Api",
          "pricingTier": "Standard",
          "subPlan": "P1"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "securityContactProperties": {
      "value": {
        "emails": "foo@contoso.com",
        "isEnabled": true,
        "notificationsByRole": {
          "roles": [
            "Owner"
          ],
          "state": "On"
        },
        "notificationsSources": [
          {
            "minimalSeverity": "High",
            "sourceType": "Alert"
          },
          {
            "minimalRiskLevel": "High",
            "sourceType": "AttackPath"
          }
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
using 'br/public:avm/ptn/security/security-center:<version>'

param defenderPlans = [
  {
    name: 'VirtualMachines'
    pricingTier: 'Standard'
    subPlan: 'P2'
  }
  {
    name: 'SqlServers'
    pricingTier: 'Standard'
  }
  {
    name: 'AppServices'
    pricingTier: 'Standard'
  }
  {
    extensions: [
      {
        additionalExtensionProperties: {
          CapGBPerMonthPerStorageAccount: 5000
        }
        isEnabled: 'True'
        name: 'OnUploadMalwareScanning'
      }
      {
        isEnabled: 'True'
        name: 'SensitiveDataDiscovery'
      }
    ]
    name: 'StorageAccounts'
    pricingTier: 'Standard'
    subPlan: 'DefenderForStorageV2'
  }
  {
    name: 'SqlServerVirtualMachines'
    pricingTier: 'Standard'
  }
  {
    name: 'KeyVaults'
    pricingTier: 'Standard'
  }
  {
    name: 'Arm'
    pricingTier: 'Standard'
  }
  {
    name: 'OpenSourceRelationalDatabases'
    pricingTier: 'Standard'
  }
  {
    extensions: [
      {
        isEnabled: 'True'
        name: 'ContainerRegistriesVulnerabilityAssessments'
      }
    ]
    name: 'Containers'
    pricingTier: 'Standard'
  }
  {
    name: 'CosmosDbs'
    pricingTier: 'Standard'
  }
  {
    extensions: [
      {
        isEnabled: 'True'
        name: 'AgentlessVmScanning'
      }
      {
        isEnabled: 'True'
        name: 'AgentlessDiscoveryForKubernetes'
      }
      {
        isEnabled: 'True'
        name: 'SensitiveDataDiscovery'
      }
      {
        isEnabled: 'True'
        name: 'ContainerRegistriesVulnerabilityAssessments'
      }
      {
        isEnabled: 'True'
        name: 'EntraPermissionsManagement'
      }
    ]
    name: 'CloudPosture'
    pricingTier: 'Standard'
  }
  {
    name: 'Api'
    pricingTier: 'Standard'
    subPlan: 'P1'
  }
]
param location = '<location>'
param securityContactProperties = {
  emails: 'foo@contoso.com'
  isEnabled: true
  notificationsByRole: {
    roles: [
      'Owner'
    ]
    state: 'On'
  }
  notificationsSources: [
    {
      minimalSeverity: 'High'
      sourceType: 'Alert'
    }
    {
      minimalRiskLevel: 'High'
      sourceType: 'AttackPath'
    }
  ]
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: {
    defenderPlans: [
      {
        name: 'VirtualMachines'
        pricingTier: 'Standard'
        subPlan: 'P2'
      }
      {
        name: 'SqlServers'
        pricingTier: 'Standard'
      }
      {
        name: 'AppServices'
        pricingTier: 'Standard'
      }
      {
        extensions: [
          {
            additionalExtensionProperties: {
              CapGBPerMonthPerStorageAccount: 5000
            }
            isEnabled: 'True'
            name: 'OnUploadMalwareScanning'
          }
          {
            isEnabled: 'True'
            name: 'SensitiveDataDiscovery'
          }
        ]
        name: 'StorageAccounts'
        pricingTier: 'Standard'
        subPlan: 'DefenderForStorageV2'
      }
      {
        name: 'SqlServerVirtualMachines'
        pricingTier: 'Standard'
      }
      {
        name: 'KeyVaults'
        pricingTier: 'Standard'
      }
      {
        name: 'Arm'
        pricingTier: 'Standard'
      }
      {
        name: 'OpenSourceRelationalDatabases'
        pricingTier: 'Standard'
      }
      {
        name: 'Containers'
        pricingTier: 'Standard'
      }
      {
        name: 'CosmosDbs'
        pricingTier: 'Standard'
      }
      {
        extensions: [
          {
            isEnabled: 'True'
            name: 'AgentlessVmScanning'
          }
          {
            isEnabled: 'True'
            name: 'AgentlessDiscoveryForKubernetes'
          }
          {
            isEnabled: 'True'
            name: 'SensitiveDataDiscovery'
          }
          {
            isEnabled: 'True'
            name: 'ContainerRegistriesVulnerabilityAssessments'
          }
        ]
        name: 'CloudPosture'
        pricingTier: 'Standard'
      }
      {
        name: 'Api'
        pricingTier: 'Standard'
        subPlan: 'P1'
      }
    ]
    location: '<location>'
    securityContactProperties: {
      emails: 'security@contoso.com'
      isEnabled: true
      notificationsByRole: {
        roles: [
          'Owner'
        ]
        state: 'On'
      }
      notificationsSources: [
        {
          minimalSeverity: 'Medium'
          sourceType: 'Alert'
        }
        {
          minimalRiskLevel: 'High'
          sourceType: 'AttackPath'
        }
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
    "defenderPlans": {
      "value": [
        {
          "name": "VirtualMachines",
          "pricingTier": "Standard",
          "subPlan": "P2"
        },
        {
          "name": "SqlServers",
          "pricingTier": "Standard"
        },
        {
          "name": "AppServices",
          "pricingTier": "Standard"
        },
        {
          "extensions": [
            {
              "additionalExtensionProperties": {
                "CapGBPerMonthPerStorageAccount": 5000
              },
              "isEnabled": "True",
              "name": "OnUploadMalwareScanning"
            },
            {
              "isEnabled": "True",
              "name": "SensitiveDataDiscovery"
            }
          ],
          "name": "StorageAccounts",
          "pricingTier": "Standard",
          "subPlan": "DefenderForStorageV2"
        },
        {
          "name": "SqlServerVirtualMachines",
          "pricingTier": "Standard"
        },
        {
          "name": "KeyVaults",
          "pricingTier": "Standard"
        },
        {
          "name": "Arm",
          "pricingTier": "Standard"
        },
        {
          "name": "OpenSourceRelationalDatabases",
          "pricingTier": "Standard"
        },
        {
          "name": "Containers",
          "pricingTier": "Standard"
        },
        {
          "name": "CosmosDbs",
          "pricingTier": "Standard"
        },
        {
          "extensions": [
            {
              "isEnabled": "True",
              "name": "AgentlessVmScanning"
            },
            {
              "isEnabled": "True",
              "name": "AgentlessDiscoveryForKubernetes"
            },
            {
              "isEnabled": "True",
              "name": "SensitiveDataDiscovery"
            },
            {
              "isEnabled": "True",
              "name": "ContainerRegistriesVulnerabilityAssessments"
            }
          ],
          "name": "CloudPosture",
          "pricingTier": "Standard"
        },
        {
          "name": "Api",
          "pricingTier": "Standard",
          "subPlan": "P1"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "securityContactProperties": {
      "value": {
        "emails": "security@contoso.com",
        "isEnabled": true,
        "notificationsByRole": {
          "roles": [
            "Owner"
          ],
          "state": "On"
        },
        "notificationsSources": [
          {
            "minimalSeverity": "Medium",
            "sourceType": "Alert"
          },
          {
            "minimalRiskLevel": "High",
            "sourceType": "AttackPath"
          }
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
using 'br/public:avm/ptn/security/security-center:<version>'

param defenderPlans = [
  {
    name: 'VirtualMachines'
    pricingTier: 'Standard'
    subPlan: 'P2'
  }
  {
    name: 'SqlServers'
    pricingTier: 'Standard'
  }
  {
    name: 'AppServices'
    pricingTier: 'Standard'
  }
  {
    extensions: [
      {
        additionalExtensionProperties: {
          CapGBPerMonthPerStorageAccount: 5000
        }
        isEnabled: 'True'
        name: 'OnUploadMalwareScanning'
      }
      {
        isEnabled: 'True'
        name: 'SensitiveDataDiscovery'
      }
    ]
    name: 'StorageAccounts'
    pricingTier: 'Standard'
    subPlan: 'DefenderForStorageV2'
  }
  {
    name: 'SqlServerVirtualMachines'
    pricingTier: 'Standard'
  }
  {
    name: 'KeyVaults'
    pricingTier: 'Standard'
  }
  {
    name: 'Arm'
    pricingTier: 'Standard'
  }
  {
    name: 'OpenSourceRelationalDatabases'
    pricingTier: 'Standard'
  }
  {
    name: 'Containers'
    pricingTier: 'Standard'
  }
  {
    name: 'CosmosDbs'
    pricingTier: 'Standard'
  }
  {
    extensions: [
      {
        isEnabled: 'True'
        name: 'AgentlessVmScanning'
      }
      {
        isEnabled: 'True'
        name: 'AgentlessDiscoveryForKubernetes'
      }
      {
        isEnabled: 'True'
        name: 'SensitiveDataDiscovery'
      }
      {
        isEnabled: 'True'
        name: 'ContainerRegistriesVulnerabilityAssessments'
      }
    ]
    name: 'CloudPosture'
    pricingTier: 'Standard'
  }
  {
    name: 'Api'
    pricingTier: 'Standard'
    subPlan: 'P1'
  }
]
param location = '<location>'
param securityContactProperties = {
  emails: 'security@contoso.com'
  isEnabled: true
  notificationsByRole: {
    roles: [
      'Owner'
    ]
    state: 'On'
  }
  notificationsSources: [
    {
      minimalSeverity: 'Medium'
      sourceType: 'Alert'
    }
    {
      minimalRiskLevel: 'High'
      sourceType: 'AttackPath'
    }
  ]
}
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alertsSuppressionRules`](#parameter-alertssuppressionrules) | array | Alert suppression rules to reduce alert noise. Each entry creates a suppression rule for a specific alert type. |
| [`assessmentMetadataList`](#parameter-assessmentmetadatalist) | array | Custom assessment metadata definitions. Used to define custom assessments that pair with custom recommendations. |
| [`customRecommendations`](#parameter-customrecommendations) | array | Custom security recommendations to create. Each entry defines a custom recommendation with a KQL query. |
| [`defenderPlans`](#parameter-defenderplans) | array | Microsoft Defender for Cloud pricing plan configurations. Each entry specifies a Defender plan name, pricing tier, and optional subPlan, enforce, and extensions settings. |
| [`deviceSecurityGroupProperties`](#parameter-devicesecuritygroupproperties) | object | Device Security group properties. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`governanceRules`](#parameter-governancerules) | array | Governance rules to drive security remediation. Each entry defines ownership, remediation timeframes, and notification settings. |
| [`ioTSecuritySolutionProperties`](#parameter-iotsecuritysolutionproperties) | object | Security Solution data for IoT. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`securityAutomations`](#parameter-securityautomations) | array | Continuous export (security automation) configurations. Each entry creates a Microsoft.Security/automations resource that exports alerts and/or recommendations to a Log Analytics workspace, Event Hub, or Logic App. |
| [`securityContactProperties`](#parameter-securitycontactproperties) | object | Security contact configuration for Microsoft Defender for Cloud notifications. |
| [`securitySettings`](#parameter-securitysettings) | array | Defender for Cloud integration settings (MCAS, WDATP, Sentinel). Each entry enables or disables a specific integration. |
| [`securityStandards`](#parameter-securitystandards) | array | Custom security standards to create. Each entry defines a standard with assessments to apply. |
| [`serverVulnerabilityAssessmentsSettings`](#parameter-servervulnerabilityassessmentssettings) | object | Server vulnerability assessment settings. Configures the vulnerability assessment provider (e.g., Microsoft Defender Vulnerability Management). |
| [`standardAssignments`](#parameter-standardassignments) | array | Standard assignments to create. Each entry assigns a security standard to a scope. |

### Parameter: `alertsSuppressionRules`

Alert suppression rules to reduce alert noise. Each entry creates a suppression rule for a specific alert type.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alertType`](#parameter-alertssuppressionrulesalerttype) | string | The alert type to suppress. Use '*' for all alert types. |
| [`name`](#parameter-alertssuppressionrulesname) | string | The unique name of the suppression rule. |
| [`reason`](#parameter-alertssuppressionrulesreason) | string | The reason for dismissing the alert. |
| [`state`](#parameter-alertssuppressionrulesstate) | string | The state of the rule (Enabled, Disabled, or Expired). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`comment`](#parameter-alertssuppressionrulescomment) | string | Comment regarding the rule. |
| [`expirationDateUtc`](#parameter-alertssuppressionrulesexpirationdateutc) | string | Expiration date of the rule in UTC. If not provided, the rule will not expire. |
| [`suppressionAlertsScope`](#parameter-alertssuppressionrulessuppressionalertsscope) | object | The suppression conditions — all conditions must be true to suppress the alert. |

### Parameter: `alertsSuppressionRules.alertType`

The alert type to suppress. Use '*' for all alert types.

- Required: Yes
- Type: string

### Parameter: `alertsSuppressionRules.name`

The unique name of the suppression rule.

- Required: Yes
- Type: string

### Parameter: `alertsSuppressionRules.reason`

The reason for dismissing the alert.

- Required: Yes
- Type: string

### Parameter: `alertsSuppressionRules.state`

The state of the rule (Enabled, Disabled, or Expired).

- Required: Yes
- Type: string

### Parameter: `alertsSuppressionRules.comment`

Comment regarding the rule.

- Required: No
- Type: string

### Parameter: `alertsSuppressionRules.expirationDateUtc`

Expiration date of the rule in UTC. If not provided, the rule will not expire.

- Required: No
- Type: string

### Parameter: `alertsSuppressionRules.suppressionAlertsScope`

The suppression conditions — all conditions must be true to suppress the alert.

- Required: No
- Type: object

### Parameter: `assessmentMetadataList`

Custom assessment metadata definitions. Used to define custom assessments that pair with custom recommendations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assessmentType`](#parameter-assessmentmetadatalistassessmenttype) | string | The assessment type (BuiltIn, CustomPolicy, CustomerManaged, VerifiedPartner). |
| [`displayName`](#parameter-assessmentmetadatalistdisplayname) | string | The display name of the assessment. |
| [`name`](#parameter-assessmentmetadatalistname) | string | The name (GUID) of the assessment metadata. |
| [`severity`](#parameter-assessmentmetadatalistseverity) | string | The severity of the assessment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`categories`](#parameter-assessmentmetadatalistcategories) | array | Categories the assessment belongs to. |
| [`description`](#parameter-assessmentmetadatalistdescription) | string | Description of the assessment. |
| [`implementationEffort`](#parameter-assessmentmetadatalistimplementationeffort) | string | The implementation effort required. |
| [`remediationDescription`](#parameter-assessmentmetadatalistremediationdescription) | string | The remediation description. |
| [`threats`](#parameter-assessmentmetadatalistthreats) | array | Threats the assessment mitigates. |
| [`userImpact`](#parameter-assessmentmetadatalistuserimpact) | string | The user impact of the assessment. |

### Parameter: `assessmentMetadataList.assessmentType`

The assessment type (BuiltIn, CustomPolicy, CustomerManaged, VerifiedPartner).

- Required: Yes
- Type: string

### Parameter: `assessmentMetadataList.displayName`

The display name of the assessment.

- Required: Yes
- Type: string

### Parameter: `assessmentMetadataList.name`

The name (GUID) of the assessment metadata.

- Required: Yes
- Type: string

### Parameter: `assessmentMetadataList.severity`

The severity of the assessment.

- Required: Yes
- Type: string

### Parameter: `assessmentMetadataList.categories`

Categories the assessment belongs to.

- Required: No
- Type: array

### Parameter: `assessmentMetadataList.description`

Description of the assessment.

- Required: No
- Type: string

### Parameter: `assessmentMetadataList.implementationEffort`

The implementation effort required.

- Required: No
- Type: string

### Parameter: `assessmentMetadataList.remediationDescription`

The remediation description.

- Required: No
- Type: string

### Parameter: `assessmentMetadataList.threats`

Threats the assessment mitigates.

- Required: No
- Type: array

### Parameter: `assessmentMetadataList.userImpact`

The user impact of the assessment.

- Required: No
- Type: string

### Parameter: `customRecommendations`

Custom security recommendations to create. Each entry defines a custom recommendation with a KQL query.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-customrecommendationsdisplayname) | string | The display name of the recommendation. |
| [`name`](#parameter-customrecommendationsname) | string | The name (GUID) of the custom recommendation. |
| [`query`](#parameter-customrecommendationsquery) | string | KQL query representing the recommendation results. |
| [`severity`](#parameter-customrecommendationsseverity) | string | The severity of the recommendation. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cloudProviders`](#parameter-customrecommendationscloudproviders) | array | List of cloud providers the recommendation applies to. |
| [`description`](#parameter-customrecommendationsdescription) | string | Description of the recommendation. |
| [`remediationDescription`](#parameter-customrecommendationsremediationdescription) | string | The remediation description. |
| [`securityIssue`](#parameter-customrecommendationssecurityissue) | string | The security issue category. |

### Parameter: `customRecommendations.displayName`

The display name of the recommendation.

- Required: Yes
- Type: string

### Parameter: `customRecommendations.name`

The name (GUID) of the custom recommendation.

- Required: Yes
- Type: string

### Parameter: `customRecommendations.query`

KQL query representing the recommendation results.

- Required: Yes
- Type: string

### Parameter: `customRecommendations.severity`

The severity of the recommendation.

- Required: Yes
- Type: string

### Parameter: `customRecommendations.cloudProviders`

List of cloud providers the recommendation applies to.

- Required: No
- Type: array

### Parameter: `customRecommendations.description`

Description of the recommendation.

- Required: No
- Type: string

### Parameter: `customRecommendations.remediationDescription`

The remediation description.

- Required: No
- Type: string

### Parameter: `customRecommendations.securityIssue`

The security issue category.

- Required: No
- Type: string

### Parameter: `defenderPlans`

Microsoft Defender for Cloud pricing plan configurations. Each entry specifies a Defender plan name, pricing tier, and optional subPlan, enforce, and extensions settings.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-defenderplansname) | string | The Defender plan name (e.g., VirtualMachines, SqlServers, AppServices, StorageAccounts, Containers, KeyVaults, Arm, CloudPosture, Api, CosmosDbs, OpenSourceRelationalDatabases, SqlServerVirtualMachines). |
| [`pricingTier`](#parameter-defenderplanspricingtier) | string | The pricing tier for the Defender plan. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enforce`](#parameter-defenderplansenforce) | string | If set to True, prevents descendants from overriding this pricing configuration. Only available for subscription-level pricing. |
| [`extensions`](#parameter-defenderplansextensions) | array | List of extensions offered under the plan (e.g., OnUploadMalwareScanning, SensitiveDataDiscovery, AgentlessVmScanning, ContainerSensor). |
| [`subPlan`](#parameter-defenderplanssubplan) | string | The sub-plan to select when more than one is available (e.g., P1 or P2 for VirtualMachines, DefenderForStorageV2 for StorageAccounts). |

### Parameter: `defenderPlans.name`

The Defender plan name (e.g., VirtualMachines, SqlServers, AppServices, StorageAccounts, Containers, KeyVaults, Arm, CloudPosture, Api, CosmosDbs, OpenSourceRelationalDatabases, SqlServerVirtualMachines).

- Required: Yes
- Type: string

### Parameter: `defenderPlans.pricingTier`

The pricing tier for the Defender plan.

- Required: Yes
- Type: string

### Parameter: `defenderPlans.enforce`

If set to True, prevents descendants from overriding this pricing configuration. Only available for subscription-level pricing.

- Required: No
- Type: string

### Parameter: `defenderPlans.extensions`

List of extensions offered under the plan (e.g., OnUploadMalwareScanning, SensitiveDataDiscovery, AgentlessVmScanning, ContainerSensor).

- Required: No
- Type: array

### Parameter: `defenderPlans.subPlan`

The sub-plan to select when more than one is available (e.g., P1 or P2 for VirtualMachines, DefenderForStorageV2 for StorageAccounts).

- Required: No
- Type: string

### Parameter: `deviceSecurityGroupProperties`

Device Security group properties.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `governanceRules`

Governance rules to drive security remediation. Each entry defines ownership, remediation timeframes, and notification settings.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conditionSets`](#parameter-governancerulesconditionsets) | array | The condition sets that determine when the rule applies. |
| [`displayName`](#parameter-governancerulesdisplayname) | string | The display name of the governance rule. |
| [`name`](#parameter-governancerulesname) | string | The unique name of the governance rule. |
| [`ownerSource`](#parameter-governancerulesownersource) | object | The owner source for the rule. |
| [`rulePriority`](#parameter-governancerulesrulepriority) | int | The rule priority (0-1000, lower is higher priority). |
| [`ruleType`](#parameter-governancerulesruletype) | string | The rule type (e.g., Integrated, ServiceNow). |
| [`sourceResourceType`](#parameter-governancerulessourceresourcetype) | string | The source resource type (e.g., Assessments). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-governancerulesdescription) | string | Description of the governance rule. |
| [`excludedScopes`](#parameter-governancerulesexcludedscopes) | array | Excluded scopes to filter out descendants. |
| [`governanceEmailNotification`](#parameter-governancerulesgovernanceemailnotification) | object | Email notification settings for the governance rule. |
| [`includeMemberScopes`](#parameter-governancerulesincludememberscopes) | bool | Whether to include member scopes. |
| [`isDisabled`](#parameter-governancerulesisdisabled) | bool | Whether the rule is disabled. |
| [`isGracePeriod`](#parameter-governancerulesisgraceperiod) | bool | Whether there is a grace period on the governance rule. |
| [`remediationTimeframe`](#parameter-governancerulesremediationtimeframe) | string | Remediation timeframe (e.g., 7.00:00:00 for 7 days). |

### Parameter: `governanceRules.conditionSets`

The condition sets that determine when the rule applies.

- Required: Yes
- Type: array

### Parameter: `governanceRules.displayName`

The display name of the governance rule.

- Required: Yes
- Type: string

### Parameter: `governanceRules.name`

The unique name of the governance rule.

- Required: Yes
- Type: string

### Parameter: `governanceRules.ownerSource`

The owner source for the rule.

- Required: Yes
- Type: object

### Parameter: `governanceRules.rulePriority`

The rule priority (0-1000, lower is higher priority).

- Required: Yes
- Type: int

### Parameter: `governanceRules.ruleType`

The rule type (e.g., Integrated, ServiceNow).

- Required: Yes
- Type: string

### Parameter: `governanceRules.sourceResourceType`

The source resource type (e.g., Assessments).

- Required: Yes
- Type: string

### Parameter: `governanceRules.description`

Description of the governance rule.

- Required: No
- Type: string

### Parameter: `governanceRules.excludedScopes`

Excluded scopes to filter out descendants.

- Required: No
- Type: array

### Parameter: `governanceRules.governanceEmailNotification`

Email notification settings for the governance rule.

- Required: No
- Type: object

### Parameter: `governanceRules.includeMemberScopes`

Whether to include member scopes.

- Required: No
- Type: bool

### Parameter: `governanceRules.isDisabled`

Whether the rule is disabled.

- Required: No
- Type: bool

### Parameter: `governanceRules.isGracePeriod`

Whether there is a grace period on the governance rule.

- Required: No
- Type: bool

### Parameter: `governanceRules.remediationTimeframe`

Remediation timeframe (e.g., 7.00:00:00 for 7 days).

- Required: No
- Type: string

### Parameter: `ioTSecuritySolutionProperties`

Security Solution data for IoT.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-iotsecuritysolutionpropertiesdisplayname) | string | The display name of the IoT Security Solution. |
| [`iotHubs`](#parameter-iotsecuritysolutionpropertiesiothubs) | array | IoT Hub resource IDs. |
| [`name`](#parameter-iotsecuritysolutionpropertiesname) | string | The name of the IoT Security Solution. |
| [`resourceGroup`](#parameter-iotsecuritysolutionpropertiesresourcegroup) | string | The resource group to deploy the IoT Security Solution into. |
| [`workspace`](#parameter-iotsecuritysolutionpropertiesworkspace) | string | The workspace resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disabledDataSources`](#parameter-iotsecuritysolutionpropertiesdisableddatasources) | array | Disabled data sources. |
| [`export`](#parameter-iotsecuritysolutionpropertiesexport) | array | List of additional export to workspace data options. |
| [`recommendationsConfiguration`](#parameter-iotsecuritysolutionpropertiesrecommendationsconfiguration) | array | List of the configuration status for each recommendation type. |
| [`status`](#parameter-iotsecuritysolutionpropertiesstatus) | string | Status of the IoT Security Solution. |
| [`userDefinedResources`](#parameter-iotsecuritysolutionpropertiesuserdefinedresources) | object | Properties of the IoT Security Solution's user defined resources. |

### Parameter: `ioTSecuritySolutionProperties.displayName`

The display name of the IoT Security Solution.

- Required: Yes
- Type: string

### Parameter: `ioTSecuritySolutionProperties.iotHubs`

IoT Hub resource IDs.

- Required: Yes
- Type: array

### Parameter: `ioTSecuritySolutionProperties.name`

The name of the IoT Security Solution.

- Required: Yes
- Type: string

### Parameter: `ioTSecuritySolutionProperties.resourceGroup`

The resource group to deploy the IoT Security Solution into.

- Required: Yes
- Type: string

### Parameter: `ioTSecuritySolutionProperties.workspace`

The workspace resource ID.

- Required: Yes
- Type: string

### Parameter: `ioTSecuritySolutionProperties.disabledDataSources`

Disabled data sources.

- Required: No
- Type: array

### Parameter: `ioTSecuritySolutionProperties.export`

List of additional export to workspace data options.

- Required: No
- Type: array

### Parameter: `ioTSecuritySolutionProperties.recommendationsConfiguration`

List of the configuration status for each recommendation type.

- Required: No
- Type: array

### Parameter: `ioTSecuritySolutionProperties.status`

Status of the IoT Security Solution.

- Required: No
- Type: string

### Parameter: `ioTSecuritySolutionProperties.userDefinedResources`

Properties of the IoT Security Solution's user defined resources.

- Required: No
- Type: object

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `securityAutomations`

Continuous export (security automation) configurations. Each entry creates a Microsoft.Security/automations resource that exports alerts and/or recommendations to a Log Analytics workspace, Event Hub, or Logic App.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-securityautomationsactions) | array | The actions triggered when all rules evaluate to true. |
| [`name`](#parameter-securityautomationsname) | string | The name of the security automation resource. |
| [`resourceGroupName`](#parameter-securityautomationsresourcegroupname) | string | The resource group to deploy the automation into. |
| [`scopes`](#parameter-securityautomationsscopes) | array | The scopes on which the automation logic is applied (subscription or resource group IDs). |
| [`sources`](#parameter-securityautomationssources) | array | The source event types which evaluate the automation rules. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-securityautomationsdescription) | string | Description of the security automation. |
| [`isEnabled`](#parameter-securityautomationsisenabled) | bool | Whether the security automation is enabled. Defaults to true. |
| [`location`](#parameter-securityautomationslocation) | string | Location for the automation resource. Defaults to the deployment location. |
| [`tags`](#parameter-securityautomationstags) | object | Tags for the automation resource. |

### Parameter: `securityAutomations.actions`

The actions triggered when all rules evaluate to true.

- Required: Yes
- Type: array

### Parameter: `securityAutomations.name`

The name of the security automation resource.

- Required: Yes
- Type: string

### Parameter: `securityAutomations.resourceGroupName`

The resource group to deploy the automation into.

- Required: Yes
- Type: string

### Parameter: `securityAutomations.scopes`

The scopes on which the automation logic is applied (subscription or resource group IDs).

- Required: Yes
- Type: array

### Parameter: `securityAutomations.sources`

The source event types which evaluate the automation rules.

- Required: Yes
- Type: array

### Parameter: `securityAutomations.description`

Description of the security automation.

- Required: No
- Type: string

### Parameter: `securityAutomations.isEnabled`

Whether the security automation is enabled. Defaults to true.

- Required: No
- Type: bool

### Parameter: `securityAutomations.location`

Location for the automation resource. Defaults to the deployment location.

- Required: No
- Type: string

### Parameter: `securityAutomations.tags`

Tags for the automation resource.

- Required: No
- Type: object

### Parameter: `securityContactProperties`

Security contact configuration for Microsoft Defender for Cloud notifications.

- Required: No
- Type: object

### Parameter: `securitySettings`

Defender for Cloud integration settings (MCAS, WDATP, Sentinel). Each entry enables or disables a specific integration.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-securitysettingsenabled) | bool | Whether the setting is enabled. |
| [`kind`](#parameter-securitysettingskind) | string | The kind of setting (DataExportSettings for MCAS/WDATP, AlertSyncSettings for Sentinel). |
| [`name`](#parameter-securitysettingsname) | string | The setting name (MCAS, WDATP, WDATP_EXCLUDE_LINUX_PUBLIC_PREVIEW, WDATP_UNIFIED_SOLUTION, or Sentinel). |

### Parameter: `securitySettings.enabled`

Whether the setting is enabled.

- Required: Yes
- Type: bool

### Parameter: `securitySettings.kind`

The kind of setting (DataExportSettings for MCAS/WDATP, AlertSyncSettings for Sentinel).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AlertSyncSettings'
    'DataExportSettings'
  ]
  ```

### Parameter: `securitySettings.name`

The setting name (MCAS, WDATP, WDATP_EXCLUDE_LINUX_PUBLIC_PREVIEW, WDATP_UNIFIED_SOLUTION, or Sentinel).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MCAS'
    'Sentinel'
    'WDATP'
    'WDATP_EXCLUDE_LINUX_PUBLIC_PREVIEW'
    'WDATP_UNIFIED_SOLUTION'
  ]
  ```

### Parameter: `securityStandards`

Custom security standards to create. Each entry defines a standard with assessments to apply.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-securitystandardsdisplayname) | string | The display name of the security standard. |
| [`name`](#parameter-securitystandardsname) | string | The name (GUID) of the security standard. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assessments`](#parameter-securitystandardsassessments) | array | List of assessment keys to apply to the standard scope. |
| [`cloudProviders`](#parameter-securitystandardscloudproviders) | array | List of cloud providers the standard supports. |
| [`description`](#parameter-securitystandardsdescription) | string | Description of the security standard. |
| [`policySetDefinitionId`](#parameter-securitystandardspolicysetdefinitionid) | string | The policy set definition ID associated with the standard. |

### Parameter: `securityStandards.displayName`

The display name of the security standard.

- Required: Yes
- Type: string

### Parameter: `securityStandards.name`

The name (GUID) of the security standard.

- Required: Yes
- Type: string

### Parameter: `securityStandards.assessments`

List of assessment keys to apply to the standard scope.

- Required: No
- Type: array

### Parameter: `securityStandards.cloudProviders`

List of cloud providers the standard supports.

- Required: No
- Type: array

### Parameter: `securityStandards.description`

Description of the security standard.

- Required: No
- Type: string

### Parameter: `securityStandards.policySetDefinitionId`

The policy set definition ID associated with the standard.

- Required: No
- Type: string

### Parameter: `serverVulnerabilityAssessmentsSettings`

Server vulnerability assessment settings. Configures the vulnerability assessment provider (e.g., Microsoft Defender Vulnerability Management).

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`selectedProvider`](#parameter-servervulnerabilityassessmentssettingsselectedprovider) | string | The selected vulnerability assessments provider (e.g., MdeTvm for Microsoft Defender Vulnerability Management). |

### Parameter: `serverVulnerabilityAssessmentsSettings.selectedProvider`

The selected vulnerability assessments provider (e.g., MdeTvm for Microsoft Defender Vulnerability Management).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'MdeTvm'
  ]
  ```

### Parameter: `standardAssignments`

Standard assignments to create. Each entry assigns a security standard to a scope.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignedStandard`](#parameter-standardassignmentsassignedstandard) | object | The resource ID of the assigned standard. |
| [`name`](#parameter-standardassignmentsname) | string | The name (GUID) of the standard assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-standardassignmentsdescription) | string | Description of the assignment. |
| [`displayName`](#parameter-standardassignmentsdisplayname) | string | Display name of the assignment. |
| [`effect`](#parameter-standardassignmentseffect) | string | The effect of the assignment (e.g., Audit, Exempt). |
| [`excludedScopes`](#parameter-standardassignmentsexcludedscopes) | array | List of scopes excluded from the assignment. |
| [`expiresOn`](#parameter-standardassignmentsexpireson) | string | Expiration date of the assignment. |
| [`metadata`](#parameter-standardassignmentsmetadata) | object | Additional metadata for the assignment. |

### Parameter: `standardAssignments.assignedStandard`

The resource ID of the assigned standard.

- Required: Yes
- Type: object

### Parameter: `standardAssignments.name`

The name (GUID) of the standard assignment.

- Required: Yes
- Type: string

### Parameter: `standardAssignments.description`

Description of the assignment.

- Required: No
- Type: string

### Parameter: `standardAssignments.displayName`

Display name of the assignment.

- Required: No
- Type: string

### Parameter: `standardAssignments.effect`

The effect of the assignment (e.g., Audit, Exempt).

- Required: No
- Type: string

### Parameter: `standardAssignments.excludedScopes`

List of scopes excluded from the assignment.

- Required: No
- Type: array

### Parameter: `standardAssignments.expiresOn`

Expiration date of the assignment.

- Required: No
- Type: string

### Parameter: `standardAssignments.metadata`

Additional metadata for the assignment.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `configuredDefenderPlans` | array | The list of Defender plan names that were configured. |
| `name` | string | The name of the security center. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
