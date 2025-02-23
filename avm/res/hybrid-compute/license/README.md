# Azure Arc License `[Microsoft.HybridCompute/licenses]`

This module deploys an Azure Arc License for use with Azure Arc-enabled servers. This module should not be used for other Arc-enabled server scenarios, where the Arc License resource is created automatically by the onboarding process.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.HybridCompute/licenses` | [2024-11-10-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HybridCompute/2024-11-10-preview/licenses) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/hybrid-compute/license:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module license 'br/public:avm/res/hybrid-compute/license:<version>' = {
  name: 'licenseDeployment'
  params: {
    name: 'hclmin001'
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
      "value": "hclmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/hybrid-compute/license:<version>'

param name = 'hclmin001'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module license 'br/public:avm/res/hybrid-compute/license:<version>' = {
  name: 'licenseDeployment'
  params: {
    name: 'hclwaf001'
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
      "value": "hclwaf001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/hybrid-compute/license:<version>'

param name = 'hclwaf001'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Azure Arc License to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`licenseDetailEdition`](#parameter-licensedetailedition) | string | Describes the edition of the license. The values are either Standard or Datacenter.. |
| [`licenseDetailProcessors`](#parameter-licensedetailprocessors) | int | Describes the number of processors. |
| [`licenseDetailState`](#parameter-licensedetailstate) | string | Describes the license state. |
| [`licenseDetailTarget`](#parameter-licensedetailtarget) | string | Describes the license target server. |
| [`licenseDetailType`](#parameter-licensedetailtype) | string | Provide the core type (vCore or pCore) needed for this ESU licens. |
| [`licenseType`](#parameter-licensetype) | string | The type of the license resource. The value is ESU. |
| [`licenseVolumeLicenseDetails`](#parameter-licensevolumelicensedetails) | array | A list of volume license details. |
| [`location`](#parameter-location) | string | The location of the Azure Arc License to be created. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`tenantId`](#parameter-tenantid) | string | The tenant ID of the license resource. Default is the tenant ID of the current subscription. |

### Parameter: `name`

The name of the Azure Arc License to be created.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `licenseDetailEdition`

Describes the edition of the license. The values are either Standard or Datacenter..

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Datacenter'
    'Standard'
  ]
  ```

### Parameter: `licenseDetailProcessors`

Describes the number of processors.

- Required: No
- Type: int
- Default: `2`

### Parameter: `licenseDetailState`

Describes the license state.

- Required: No
- Type: string
- Default: `'Deactivated'`
- Allowed:
  ```Bicep
  [
    'Active'
    'Deactivated'
  ]
  ```

### Parameter: `licenseDetailTarget`

Describes the license target server.

- Required: No
- Type: string
- Default: `'Windows Server 2012 R2'`
- Allowed:
  ```Bicep
  [
    'Windows Server 2012'
    'Windows Server 2012 R2'
  ]
  ```

### Parameter: `licenseDetailType`

Provide the core type (vCore or pCore) needed for this ESU licens.

- Required: No
- Type: string
- Default: `'vCore'`
- Allowed:
  ```Bicep
  [
    'pCore'
    'vCore'
  ]
  ```

### Parameter: `licenseType`

The type of the license resource. The value is ESU.

- Required: No
- Type: string
- Default: `'ESU'`
- Allowed:
  ```Bicep
  [
    'ESU'
  ]
  ```

### Parameter: `licenseVolumeLicenseDetails`

A list of volume license details.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`invoiceId`](#parameter-licensevolumelicensedetailsinvoiceid) | string | The invoice id for the volume license. |
| [`programYear`](#parameter-licensevolumelicensedetailsprogramyear) | string | Describes the program year the volume license is for. |

### Parameter: `licenseVolumeLicenseDetails.invoiceId`

The invoice id for the volume license.

- Required: Yes
- Type: string

### Parameter: `licenseVolumeLicenseDetails.programYear`

Describes the program year the volume license is for.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Year 1'
    'Year 2'
    'Year 3'
  ]
  ```

### Parameter: `location`

The location of the Azure Arc License to be created.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `tenantId`

The tenant ID of the license resource. Default is the tenant ID of the current subscription.

- Required: No
- Type: string
- Default: `[tenant().tenantId]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the machine. |
| `resourceGroupName` | string | The name of the resource group the VM was created in. |
| `resourceId` | string | The resource ID of the machine. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
