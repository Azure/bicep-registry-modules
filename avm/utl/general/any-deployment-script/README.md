# Any example deployment script utility `[General/AnyDeploymentScript]`

This module provides you with whatever deployment script experience.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Exported functions](#Exported-functions)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/utl/general/any-deployment-script:<version>`.

- [Using only defaults](#example-1-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module anyDeploymentScript 'br/public:avm/utl/general/any-deployment-script:<version>' = {
  name: 'anyDeploymentScriptDeployment'
  params: {
    // Required parameters
    managedIdentityResourceId: '<managedIdentityResourceId>'
    storageDeploymentScriptName: 'gadsdmin001'
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
    "managedIdentityResourceId": {
      "value": "<managedIdentityResourceId>"
    },
    "storageDeploymentScriptName": {
      "value": "gadsdmin001"
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
| [`managedIdentityResourceId`](#parameter-managedidentityresourceid) | string | The resource Id of the managed identity to use for the deployment script. |
| [`storageDeploymentScriptName`](#parameter-storagedeploymentscriptname) | string | The name of the deployment script. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location to deploy into. |

### Parameter: `managedIdentityResourceId`

The resource Id of the managed identity to use for the deployment script.

- Required: Yes
- Type: string

### Parameter: `storageDeploymentScriptName`

The name of the deployment script.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location to deploy into.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`


## Outputs

_None_

## Cross-referenced modules

_None_

## Exported functions

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
