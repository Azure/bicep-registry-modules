# SQL Server Instance Pool `[Microsoft.Sql/instancePools]`

This module deploys an Azure SQL Server Instance Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/instancePools` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-05-01-preview/instancePools) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/sql/instance-pool:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module instancePool 'br/public:avm/res/sql/instance-pool:<version>' = {
  name: 'instancePoolDeployment'
  params: {
    // Required parameters
    name: '<name>'
    subnetResourceId: '<subnetResourceId>'
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
      "value": "<name>"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
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

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module instancePool 'br/public:avm/res/sql/instance-pool:<version>' = {
  name: 'instancePoolDeployment'
  params: {
    // Required parameters
    name: '<name>'
    subnetResourceId: '<subnetResourceId>'
    // Non-required parameters
    location: '<location>'
    skuName: 'GP_Gen8IM'
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
      "value": "<name>"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "skuName": {
      "value": "GP_Gen8IM"
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
| [`name`](#parameter-name) | string | The name of the instance pool. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The subnet resource ID for the instance pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`licenseType`](#parameter-licensetype) | string | The license type to apply for this database. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`skuFamily`](#parameter-skufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`skuName`](#parameter-skuname) | string | The SKU name for the instance pool. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tier`](#parameter-tier) | string | The vCore service tier for the instance pool. |
| [`vCores`](#parameter-vcores) | int | The number of vCores for the instance pool. |

### Parameter: `name`

The name of the instance pool.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

The subnet resource ID for the instance pool.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `licenseType`

The license type to apply for this database.

- Required: No
- Type: string
- Default: `'BasePrice'`
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

### Parameter: `skuFamily`

If the service has different generations of hardware, for the same SKU, then that can be captured here.

- Required: No
- Type: string
- Default: `'Gen5'`

### Parameter: `skuName`

The SKU name for the instance pool.

- Required: No
- Type: string
- Default: `'GP_Gen5'`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `tier`

The vCore service tier for the instance pool.

- Required: No
- Type: string
- Default: `'GeneralPurpose'`
- Allowed:
  ```Bicep
  [
    'GeneralPurpose'
  ]
  ```

### Parameter: `vCores`

The number of vCores for the instance pool.

- Required: No
- Type: int
- Default: `8`
- Allowed:
  ```Bicep
  [
    8
    16
    24
    32
    40
    64
    80
    96
    128
    160
    192
    224
    256
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `instancePoolLocation` | string | The location of the SQL instance pool. |
| `name` | string | The name of the SQL instance pool. |
| `resourceGroupName` | string | The resource group name of the SQL instance pool. |
| `resourceId` | string | The ID of the SQL instance pool. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
