# avm/ptn/azd/apim-api `[Azd/ApimApi]`

Creates and configure an API within an API Management service instance.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/diagnostics` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/diagnostics) |
| `Microsoft.ApiManagement/service/apis/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/policies) |
| `Microsoft.Web/sites/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/apim-api:<version>`.

- [Using only defaults](#example-1-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module apimApi 'br/public:avm/ptn/azd/apim-api:<version>' = {
  name: 'apimApiDeployment'
  params: {
    // Required parameters
    apiBackendUrl: '<apiBackendUrl>'
    apiDescription: 'api description'
    apiDisplayName: 'apd-aapmin'
    apiName: 'an-aapmin001'
    apiPath: 'apipath-aapmin'
    name: '<name>'
    webFrontendUrl: '<webFrontendUrl>'
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
    "apiBackendUrl": {
      "value": "<apiBackendUrl>"
    },
    "apiDescription": {
      "value": "api description"
    },
    "apiDisplayName": {
      "value": "apd-aapmin"
    },
    "apiName": {
      "value": "an-aapmin001"
    },
    "apiPath": {
      "value": "apipath-aapmin"
    },
    "name": {
      "value": "<name>"
    },
    "webFrontendUrl": {
      "value": "<webFrontendUrl>"
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

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiBackendUrl`](#parameter-apibackendurl) | string | Absolute URL of the backend service implementing this API. |
| [`apiDescription`](#parameter-apidescription) | string | Description of the API. May include HTML formatting tags. |
| [`apiDisplayName`](#parameter-apidisplayname) | string | The Display Name of the API. |
| [`apiName`](#parameter-apiname) | string | Resource name to uniquely identify this API within the API Management service instance. |
| [`apiPath`](#parameter-apipath) | string | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |
| [`name`](#parameter-name) | string | Name of the API Management service instance. |
| [`webFrontendUrl`](#parameter-webfrontendurl) | string | Absolute URL of web frontend. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiAppName`](#parameter-apiappname) | string | Resource name for backend Web App or Function App. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `apiBackendUrl`

Absolute URL of the backend service implementing this API.

- Required: Yes
- Type: string

### Parameter: `apiDescription`

Description of the API. May include HTML formatting tags.

- Required: Yes
- Type: string

### Parameter: `apiDisplayName`

The Display Name of the API.

- Required: Yes
- Type: string

### Parameter: `apiName`

Resource name to uniquely identify this API within the API Management service instance.

- Required: Yes
- Type: string

### Parameter: `apiPath`

Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the API Management service instance.

- Required: Yes
- Type: string

### Parameter: `webFrontendUrl`

Absolute URL of web frontend.

- Required: Yes
- Type: string

### Parameter: `apiAppName`

Resource name for backend Web App or Function App.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The name of the resource group. |
| `serviceApiUri` | string | The complete URL for accessing the API. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
