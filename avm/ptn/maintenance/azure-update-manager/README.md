# update-manager-configuration `[Maintenance/AzureUpdateManager]`

This module creates multiple maintenance windows for Azure update manager and assigns them to existing VMs dynamically using tags .

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
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-06-01/policyAssignments) |
| `Microsoft.Authorization/policyDefinitions` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2021-06-01/policyDefinitions) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Resources/resourceGroups` | [2021-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/maintenance/azure-update-manager:<version>`.

- [Using only defaults.](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module azureUpdateManager 'br/public:avm/ptn/maintenance/azure-update-manager:<version>' = {
  name: 'azureUpdateManagerDeployment'
  params: {
    // Required parameters
    maintenanceConfigurationsResourceGroupName: '<maintenanceConfigurationsResourceGroupName>'
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
    "maintenanceConfigurationsResourceGroupName": {
      "value": "<maintenanceConfigurationsResourceGroupName>"
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
using 'br/public:avm/ptn/maintenance/azure-update-manager:<version>'

// Required parameters
param maintenanceConfigurationsResourceGroupName = '<maintenanceConfigurationsResourceGroupName>'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module azureUpdateManager 'br/public:avm/ptn/maintenance/azure-update-manager:<version>' = {
  name: 'azureUpdateManagerDeployment'
  params: {
    // Required parameters
    maintenanceConfigurationsResourceGroupName: '<maintenanceConfigurationsResourceGroupName>'
    // Non-required parameters
    enableAUMTagName: 'aum_maintenance'
    enableAUMTagValue: 'Enabled'
    location: '<location>'
    maintenanceConfigEnrollmentTagName: 'aum_maintenance_config'
    maintenanceConfigurations: [
      {
        installPatches: {
          linuxParameters: {
            classificationsToInclude: [
              'Critical'
              'Security'
            ]
            packageNameMasksToExclude: []
            packageNameMasksToInclude: []
          }
          rebootSetting: 'IfRequired'
          windowsParameters: {
            classificationsToInclude: [
              'Critical'
              'Security'
            ]
            kbNumbersToExclude: []
            kbNumbersToInclude: []
          }
        }
        location: '<location>'
        lock: {}
        maintenanceConfigName: 'maintenance_ring-maumwaf-01'
        maintenanceWindow: {
          duration: '03:00'
          expirationDateTime: '<expirationDateTime>'
          recurEvery: '1Day'
          startDateTime: '2024-09-19 00:00'
          timeZone: 'UTC'
        }
        resourceFilter: {
          locations: []
          osTypes: [
            'Linux'
            'Windows'
          ]
          resourceGroups: []
        }
        visibility: 'Custom'
      }
      {
        installPatches: {
          linuxParameters: {
            classificationsToInclude: [
              'Other'
            ]
            packageNameMasksToExclude: []
            packageNameMasksToInclude: []
          }
          rebootSetting: 'IfRequired'
          windowsParameters: {
            classificationsToInclude: [
              'FeaturePack'
              'ServicePack'
            ]
            kbNumbersToExclude: []
            kbNumbersToInclude: []
          }
        }
        location: '<location>'
        lock: {}
        maintenanceConfigName: 'maintenance_ring-maumwaf-02'
        maintenanceWindow: {
          duration: '03:00'
          expirationDateTime: '<expirationDateTime>'
          recurEvery: 'Week Saturday,Sunday'
          startDateTime: '2024-09-19 00:00'
          timeZone: 'UTC'
        }
        resourceFilter: {
          locations: []
          osTypes: [
            'Linux'
            'Windows'
          ]
          resourceGroups: []
        }
        visibility: 'Custom'
      }
    ]
    policyDeploymentManagedIdentityName: 'id-aumpolicy-contributor-maumwaf'
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
    "maintenanceConfigurationsResourceGroupName": {
      "value": "<maintenanceConfigurationsResourceGroupName>"
    },
    // Non-required parameters
    "enableAUMTagName": {
      "value": "aum_maintenance"
    },
    "enableAUMTagValue": {
      "value": "Enabled"
    },
    "location": {
      "value": "<location>"
    },
    "maintenanceConfigEnrollmentTagName": {
      "value": "aum_maintenance_config"
    },
    "maintenanceConfigurations": {
      "value": [
        {
          "installPatches": {
            "linuxParameters": {
              "classificationsToInclude": [
                "Critical",
                "Security"
              ],
              "packageNameMasksToExclude": [],
              "packageNameMasksToInclude": []
            },
            "rebootSetting": "IfRequired",
            "windowsParameters": {
              "classificationsToInclude": [
                "Critical",
                "Security"
              ],
              "kbNumbersToExclude": [],
              "kbNumbersToInclude": []
            }
          },
          "location": "<location>",
          "lock": {},
          "maintenanceConfigName": "maintenance_ring-maumwaf-01",
          "maintenanceWindow": {
            "duration": "03:00",
            "expirationDateTime": "<expirationDateTime>",
            "recurEvery": "1Day",
            "startDateTime": "2024-09-19 00:00",
            "timeZone": "UTC"
          },
          "resourceFilter": {
            "locations": [],
            "osTypes": [
              "Linux",
              "Windows"
            ],
            "resourceGroups": []
          },
          "visibility": "Custom"
        },
        {
          "installPatches": {
            "linuxParameters": {
              "classificationsToInclude": [
                "Other"
              ],
              "packageNameMasksToExclude": [],
              "packageNameMasksToInclude": []
            },
            "rebootSetting": "IfRequired",
            "windowsParameters": {
              "classificationsToInclude": [
                "FeaturePack",
                "ServicePack"
              ],
              "kbNumbersToExclude": [],
              "kbNumbersToInclude": []
            }
          },
          "location": "<location>",
          "lock": {},
          "maintenanceConfigName": "maintenance_ring-maumwaf-02",
          "maintenanceWindow": {
            "duration": "03:00",
            "expirationDateTime": "<expirationDateTime>",
            "recurEvery": "Week Saturday,Sunday",
            "startDateTime": "2024-09-19 00:00",
            "timeZone": "UTC"
          },
          "resourceFilter": {
            "locations": [],
            "osTypes": [
              "Linux",
              "Windows"
            ],
            "resourceGroups": []
          },
          "visibility": "Custom"
        }
      ]
    },
    "policyDeploymentManagedIdentityName": {
      "value": "id-aumpolicy-contributor-maumwaf"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/maintenance/azure-update-manager:<version>'

// Required parameters
param maintenanceConfigurationsResourceGroupName = '<maintenanceConfigurationsResourceGroupName>'
// Non-required parameters
param enableAUMTagName = 'aum_maintenance'
param enableAUMTagValue = 'Enabled'
param location = '<location>'
param maintenanceConfigEnrollmentTagName = 'aum_maintenance_config'
param maintenanceConfigurations = [
  {
    installPatches: {
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
        packageNameMasksToExclude: []
        packageNameMasksToInclude: []
      }
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
        kbNumbersToExclude: []
        kbNumbersToInclude: []
      }
    }
    location: '<location>'
    lock: {}
    maintenanceConfigName: 'maintenance_ring-maumwaf-01'
    maintenanceWindow: {
      duration: '03:00'
      expirationDateTime: '<expirationDateTime>'
      recurEvery: '1Day'
      startDateTime: '2024-09-19 00:00'
      timeZone: 'UTC'
    }
    resourceFilter: {
      locations: []
      osTypes: [
        'Linux'
        'Windows'
      ]
      resourceGroups: []
    }
    visibility: 'Custom'
  }
  {
    installPatches: {
      linuxParameters: {
        classificationsToInclude: [
          'Other'
        ]
        packageNameMasksToExclude: []
        packageNameMasksToInclude: []
      }
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'FeaturePack'
          'ServicePack'
        ]
        kbNumbersToExclude: []
        kbNumbersToInclude: []
      }
    }
    location: '<location>'
    lock: {}
    maintenanceConfigName: 'maintenance_ring-maumwaf-02'
    maintenanceWindow: {
      duration: '03:00'
      expirationDateTime: '<expirationDateTime>'
      recurEvery: 'Week Saturday,Sunday'
      startDateTime: '2024-09-19 00:00'
      timeZone: 'UTC'
    }
    resourceFilter: {
      locations: []
      osTypes: [
        'Linux'
        'Windows'
      ]
      resourceGroups: []
    }
    visibility: 'Custom'
  }
]
param policyDeploymentManagedIdentityName = 'id-aumpolicy-contributor-maumwaf'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maintenanceConfigurationsResourceGroupName`](#parameter-maintenanceconfigurationsresourcegroupname) | string | Name of the Resource Group to deploy the maintenance configurations and associated resources. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableAUMTagName`](#parameter-enableaumtagname) | string | The name of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager. |
| [`enableAUMTagValue`](#parameter-enableaumtagvalue) | string | The value of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager. Only the VMs/ARC enabled servers with Tags of the combination `<enableAUMTagName>`:`<enableAUMTagValue>` will be considered for Maintenance Configuration dynamic scoping. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Azure region where the maintenance configurations and associated resources will be deployed to, default to deployment location if not specified. |
| [`maintenanceConfigEnrollmentTagName`](#parameter-maintenanceconfigenrollmenttagname) | string | The name of the tag that will be used to filter the VMs/ARC enabled servers to assign to a maintenance configuration. The value of this tag should contain the name of the maintenance configuration which the VM/ARC enabled server should belong to, specified in the parameter `maintenanceConfigurations`. |
| [`maintenanceConfigurations`](#parameter-maintenanceconfigurations) | array | An array of objects which contain the properties of the maintenance configurations to be created. |
| [`policyDeploymentManagedIdentityName`](#parameter-policydeploymentmanagedidentityname) | string | The name of the User Assigned Managed Identity that will be used to deploy the policies. |
| [`tags`](#parameter-tags) | object | Resource tags, which will be added to all resources. |

### Parameter: `maintenanceConfigurationsResourceGroupName`

Name of the Resource Group to deploy the maintenance configurations and associated resources.

- Required: Yes
- Type: string

### Parameter: `enableAUMTagName`

The name of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager.

- Required: No
- Type: string
- Default: `'aum_maintenance'`

### Parameter: `enableAUMTagValue`

The value of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager. Only the VMs/ARC enabled servers with Tags of the combination `<enableAUMTagName>`:`<enableAUMTagValue>` will be considered for Maintenance Configuration dynamic scoping.

- Required: No
- Type: string
- Default: `'Enabled'`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Azure region where the maintenance configurations and associated resources will be deployed to, default to deployment location if not specified.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `maintenanceConfigEnrollmentTagName`

The name of the tag that will be used to filter the VMs/ARC enabled servers to assign to a maintenance configuration. The value of this tag should contain the name of the maintenance configuration which the VM/ARC enabled server should belong to, specified in the parameter `maintenanceConfigurations`.

- Required: No
- Type: string
- Default: `'aum_maintenance_config'`

### Parameter: `maintenanceConfigurations`

An array of objects which contain the properties of the maintenance configurations to be created.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      installPatches: {
        linuxParameters: {
          classificationsToInclude: [
            'Critical'
            'Security'
          ]
          packageNameMasksToExclude: []
          packageNameMasksToInclude: []
        }
        rebootSetting: 'IfRequired'
        windowsParameters: {
          classificationsToInclude: [
            'Critical'
            'Security'
          ]
          kbNumbersToExclude: []
          kbNumbersToInclude: []
        }
      }
      location: '[parameters(\'location\')]'
      lock: {}
      maintenanceConfigName: 'maintenance_ring-01'
      maintenanceWindow: {
        duration: '03:00'
        expirationDateTime: null
        recurEvery: '1Day'
        startDateTime: '2024-09-19 00:00'
        timeZone: 'UTC'
      }
      resourceFilter: {
        locations: []
        osTypes: [
          'Linux'
          'Windows'
        ]
        resourceGroups: []
      }
      visibility: 'Custom'
    }
    {
      installPatches: {
        linuxParameters: {
          classificationsToInclude: [
            'Other'
          ]
          packageNameMasksToExclude: []
          packageNameMasksToInclude: []
        }
        rebootSetting: 'IfRequired'
        windowsParameters: {
          classificationsToInclude: [
            'FeaturePack'
            'ServicePack'
          ]
          kbNumbersToExclude: []
          kbNumbersToInclude: []
        }
      }
      location: '[parameters(\'location\')]'
      lock: {}
      maintenanceConfigName: 'maintenance_ring-02'
      maintenanceWindow: {
        duration: '03:00'
        expirationDateTime: null
        recurEvery: 'Week Saturday,Sunday'
        startDateTime: '2024-09-19 00:00'
        timeZone: 'UTC'
      }
      resourceFilter: {
        locations: []
        osTypes: [
          'Linux'
          'Windows'
        ]
        resourceGroups: []
      }
      visibility: 'Custom'
    }
  ]
  ```

### Parameter: `policyDeploymentManagedIdentityName`

The name of the User Assigned Managed Identity that will be used to deploy the policies.

- Required: No
- Type: string
- Default: `'id-aumpolicy-contributor-01'`

### Parameter: `tags`

Resource tags, which will be added to all resources.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `maintenanceConfigurationIds` | array | The resource IDs of the maintenance configurations. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/maintenance/maintenance-configuration:0.3.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.0` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
