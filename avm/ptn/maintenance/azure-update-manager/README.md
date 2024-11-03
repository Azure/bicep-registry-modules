# Azure Update Manager

This module deploys multiple maintenance windows for Azure update manager and assigns them to existing VMs dynamically using tags.

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
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Maintenance/maintenanceConfigurations` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/maintenanceConfigurations) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.maintenance/2023-04-01/configurationassignments)|
| `Microsoft.Authorization/policyDefinitions` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.authorization/2021-06-01/policydefinitions) |
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/microsoft.authorization/2022-06-01/policyassignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/maintenance/azure-update-manager:<version>`.

- [Using only defaults.](#example-1-using-only-defaults)
- [Using large parameter set.](#example-2-using-large-parameter-set)

### Example 1: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module updateManagerConfig 'br/public:avm/ptn/maintenance/azure-update-manager:<version>' = {
  name: 'updateManagerConfigDeployment'
  params: {
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
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/maintenance/azure-update-manager:<version>'


```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module updateManagerConfig 'br/public:avm/ptn/maintenance/azure-update-manager:<version>' = {
  name: 'updateManagerConfigDeployment'
  params: {
    location: '<location>'
    maintenanceConfigurationsResourceGroupNeworExisting: 'new'
    maintenanceConfigurationsResourceGroupName: '<maintenanceConfigurationsResourceGroupName>'
    maintenanceConfigurations:[
      {
        maintenanceConfigName: 'maintenance_ring-01'
        location: location
        installPatches: {
          linuxParameters: {
            classificationsToInclude:'<classificationsToInclude>'
            packageNameMasksToExclude: '<packageNameMasksToExclude>'
            packageNameMasksToInclude: '<packageNameMasksToInclude>'
          }
          rebootSetting: 'IfRequired'
          windowsParameters: {
            classificationsToInclude: '<classificationsToInclude>'
            kbNumbersToExclude: '<kbNumbersToExclude>'
            kbNumbersToInclude: '<kbNumbersToInclude>'
          }
        }
        lock: {
          kind: 'CanNotDelete'
          name: 'myCustomLockName'
        }
        maintenanceWindow: {
          duration: '03:00'
          expirationDateTime: '9999-12-31 23:59:59'
          recurEvery: '1Day'
          startDateTime: '2022-12-31 13:00'
          timeZone: 'UTC'
        }
        visibility: 'Custom'
        resourceFilter: {
          resourceGroups: '<resourceGroups>'
          osTypes: '<osTypes>'
          locations: '<locations>'
        }
      }
    ]
    enableAUMTagName:'<enableAUMTagName>'
    enableAUMTagValue: '<enableAUMTagValue>'
    maintenanceConfigEnrollmentTagName: '<maintenanceConfigEnrollmentTagName>'
    policyDeploymentManagedIdentityName: '<policyDeploymentManagedIdentityName>'
    enableTelemetry: '<enableTelemetry>'
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
    "location": {
      "value": "<location>"
    },
    "maintenanceConfigurationsResourceGroupNeworExisting":{
      "value": "new"
    },
    "maintenanceConfigurationsResourceGroupName": {
      "value": "<maintenanceConfigurationsResourceGroupName>"
    },
    "maintenanceConfigurations": {
      "value": [
        {
          "maintenanceConfigName": "maintenance_ring-01",
          "location": "[parameters('location')]",
          "installPatches": {
            "linuxParameters": {
              "classificationsToInclude": "<classificationsToInclude>",
              "packageNameMasksToExclude": "<packageNameMasksToExclude>",
              "packageNameMasksToInclude": "<packageNameMasksToInclude>"
            },
            "rebootSetting": "IfRequired",
            "windowsParameters": {
              "classificationsToInclude": "<classificationsToInclude>'",
              "kbNumbersToExclude": "<kbNumbersToExclude>",
              "kbNumbersToInclude": "<kbNumbersToInclude>"
            }
          },
          "lock": {},
          "maintenanceWindow": {
            "duration": "03:00",
            "expirationDateTime":"9999-12-31 23:59:59",
            "recurEvery": "1Day",
            "startDateTime": "2022-12-31 13:00",
            "timeZone": "UTC"
          },
          "visibility": "Custom",
          "resourceFilter": {
            "resourceGroups": "<resourceGroups>",
            "osTypes": "<osTypes>",
            "locations": "<locations>"
          }
        }
      ]
    },
    "enableAUMTagName": {
      "value": "<enableAUMTagName>"
    },
    "enableAUMTagValue": {
      "value": "<enableAUMTagValue>"
    },
    "maintenanceConfigEnrollmentTagName": {
      "value": "<maintenanceConfigEnrollmentTagName>"
    },
    "policyDeploymentManagedIdentityName": {
      "value": "<policyDeploymentManagedIdentityName>"
    },
    "enableTelemetry": {
      "value": "<enableTelemetry>"
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

param location = '<location>'
param maintenanceConfigurationsResourceGroupNeworExisting = 'new'
param maintenanceConfigurationsResourceGroupName = '<maintenanceConfigurationsResourceGroupName>'
param maintenanceConfigurations = [
        {
          maintenanceConfigName: 'maintenance_ring-01'
          location: location
          installPatches: {
            linuxParameters: {
              classificationsToInclude:'<classificationsToInclude>'
              packageNameMasksToExclude: '<packageNameMasksToExclude>'
              packageNameMasksToInclude: '<packageNameMasksToInclude>'
            }
            rebootSetting: 'IfRequired'
            windowsParameters: {
              classificationsToInclude: '<classificationsToInclude>'
              kbNumbersToExclude: '<kbNumbersToExclude>'
              kbNumbersToInclude: '<kbNumbersToInclude>'
            }
          }
          lock: {
            kind: 'CanNotDelete'
            name: 'myCustomLockName'
          }
          maintenanceWindow: {
            duration: '03:00'
            expirationDateTime: '9999-12-31 23:59:59'
            recurEvery: '1Day'
            startDateTime: '2022-12-31 13:00'
            timeZone: 'UTC'
          }
          visibility: 'Custom'
          resourceFilter: {
            resourceGroups: '<resourceGroups>'
            osTypes: '<osTypes>'
            locations: '<locations>'
          }
        }
      ]
param enableAUMTagName = '<enableAUMTagName>'
param enableAUMTagValue = '<enableAUMTagValue>'
param maintenanceConfigEnrollmentTagName = '<maintenanceConfigEnrollmentTagName>'
param policyDeploymentManagedIdentityName = '<policyDeploymentManagedIdentityName>'
param enableTelemetry = '<enableTelemetry>'

```

</details>
<p>


## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Azure region where the maintenance configurations and managed identity will be deployed, default to deployment location if not specified. |
| [`maintenanceConfigurationsResourceGroupNeworExisting`](#parameter-maintenanceConfigurationsResourceGroupNeworExisting) | string | Specify whether to create a new or use an existing Resource Group to deploy the maintenance configurations and User Assigned Managed Identity.|
|[`maintenanceConfigurationsResourceGroupName`](#parameter-maintenanceConfigurationsResourceGroupName) | string | Name of the new/existing Resource Group to deploy the maintenance configurations and User Assigned Managed Identity.|
| [`maintenanceConfigurations`](#parameter-maintenanceConfigurations)| array | An array of objects which contain the properties of the maintenance configurations to be created. |
|[`enableAUMTagName`](#parameter-enableAUMTagName) | string | The name of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager.|
|[`enableAUMTagValue`](#parameter-enableAUMTagValue)| string | The value of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager. Only the VMs/ARC enabled servers with Tags of the combination `<enableAUMTagName>`:`<enableAUMTagValue>` will be considered for Maintenance Configuration dynamic scoping. |
|[`maintenanceConfigEnrollmentTagName`](#parameter-maintenanceConfigEnrollmentTagName)| string  | The name of the tag that will be used to filter the VMs/ARC enabled servers to assign to a maintenance configuration. The value of this tag should contain the name of the maintenance configuration which the VM/ARC enabled server should belong to, specified in the parameter `maintenanceConfigurations`|
|[`policyDeploymentManagedIdentityName`](#parameter-policyDeploymentManagedIdentityName) | string | The name of the User Assigned Managed Identity that will be used to deploy the policies.|

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Azure region where the maintenance configurations and managed identity will be deployed, default to deployment location if not specified.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `maintenanceConfigurationsResourceGroupNeworExisting`

Specify whether to create a new or use an existing Resource Group to deploy the maintenance configurations and User Assigned Managed Identity.

- Required: No
- Type: string
- Default: `new`
- Allowed values:
  ```Bicep
  [
    'new'
    'existing'
  ]
  ```

### Parameter: `maintenanceConfigurationsResourceGroupName`

Name of the new/existing Resource Group to deploy the maintenance configurations and User Assigned Managed Identity.

- Required: No
- Type: string
- Default: `myMaintenanceConfigurations-RG`


### Parameter: `maintenanceConfigurations`

An array of objects which contain the properties of the maintenance configurations to be created.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      maintenanceConfigName: 'maintenance_ring-01'
      location: location
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
      lock: {}
      maintenanceWindow: {
        duration: '03:00'
        expirationDateTime: null
        recurEvery: '1Day'
        startDateTime: '2024-09-19 00:00'
        timeZone: 'UTC'
      }
      visibility: 'Custom'
      resourceFilter: {
        resourceGroups: []
        osTypes: [
          'Windows'
          'Linux'
        ]
        locations: []
      }
    }
    {
    maintenanceConfigName: 'maintenance_ring-02'
    location: location
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
    lock: {}
    maintenanceWindow: {
      duration: '05:00'
      expirationDateTime: null
      recurEvery: 'Week Saturday,Sunday'
      startDateTime: '2024-09-19 00:00'
      timeZone: 'UTC'
    }
    visibility: 'Custom'
    resourceFilter: {
      resourceGroups: []
      osTypes: [
        'Windows'
        'Linux'
      ]
      locations: []
    }
  }
  ]
  ```

### Parameter: `enableAUMTagName`

The name of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager. If this tag is present on the Azure VMs/ARC enabled servers with value specified in the parameter `enableAUMTagValue`, the resource is enrolled to a maintenance configuration specified in the value of the tag `maintenanceConfigEnrollmentTagName`

- Required: No
- Type: string
- Default: `aum_maintenance`

### Parameter: `enableAUMTagValue`

The value of the tag that will be used to filter the Azure VMs/ARC enabled servers for enabling Azure Update Manager.  An Azure VM/ ARC enabled server is enrolled to a maintenance configuration specified in the value of the tag `maintenanceConfigEnrollmentTagName` only if the tag `enableAUMTagName` has the value `enableAUMTagValue`.

*e.g.* : With the default parameters, an Azure VM/ARC enabled server is enrolled to a maintenance configuration if the resource has a tag `aum_maintenance`: `Enabled`

- Required: No
- Type: string
- Default: `Enabled`

### Parameter: `maintenanceConfigEnrollmentTagName`

The name of the tag that will be used to filter the VMs/ARC enabled servers to assign to a maintenance configuration. The value of this tag should contain the name of the maintenance configuration which the VM/ARC enabled server should belong to, specified in the parameter `maintenanceConfigurations`

- Required: No
- Type: string
- Default: `aum_maintenance_config`

### Parameter: `policyDeploymentManagedIdentityName`

The name of the User Assigned Managed Identity that will be used to deploy the policies.

- Required: No
- Type: string
- Default: `id-aumpolicy-contributor-001`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `maintenanceConfigurationIds` | array | The array with the IDs of the maintenance configurations created.  |


## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/resources/resource-group:0.4.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.0` | Remote reference|
| `br/public:avm/res/maintenance/maintenance-configuration:0.3.0` | Remote reference |


## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
