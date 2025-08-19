# Microsoft Edge Site Resources `[Microsoft.Edge/sites]`

Subscription scoped resources for Microsoft Edge Site.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Edge/sites` | 2025-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.edge_sites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Edge/2025-03-01-preview/sites)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/edge/site/sub-scope:<version>`.

- [Using subscription scope deployment](#example-1-using-subscription-scope-deployment)
- [Using subscription scope deployment](#example-2-using-subscription-scope-deployment)

### Example 1: _Using subscription scope deployment_

This instance deploys the module at subscription scope without requiring a resource group.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/edge/site/sub-scope:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    location: '<location>'
    name: 'essubmin001'
    siteAddress: {
      country: 'US'
    }
    // Non-required parameters
    displayName: 'Subscription-Scoped Edge Site'
    siteDescription: 'Edge site deployed at subscription scope'
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
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "essubmin001"
    },
    "siteAddress": {
      "value": {
        "country": "US"
      }
    },
    // Non-required parameters
    "displayName": {
      "value": "Subscription-Scoped Edge Site"
    },
    "siteDescription": {
      "value": "Edge site deployed at subscription scope"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/edge/site/sub-scope:<version>'

// Required parameters
param location = '<location>'
param name = 'essubmin001'
param siteAddress = {
  country: 'US'
}
// Non-required parameters
param displayName = 'Subscription-Scoped Edge Site'
param siteDescription = 'Edge site deployed at subscription scope'
```

</details>
<p>

### Example 2: _Using subscription scope deployment_

This instance deploys the module at subscription scope without requiring a resource group.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/edge/site/sub-scope:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    location: '<location>'
    name: 'essubwaf001'
    siteAddress: {
      city: 'New York'
      country: 'US'
      postalCode: '10001'
      stateOrProvince: 'New York'
      streetAddress1: '350 Fifth Avenue'
      streetAddress2: 'Floor 34'
    }
    // Non-required parameters
    displayName: 'Test Edge Site'
    labels: {
      businessUnit: 'IT'
      costCenter: 'CC-1234'
      environment: 'test'
      project: 'EdgeDeployment'
    }
    siteDescription: 'Test edge site for region deployment'
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
    "location": {
      "value": "<location>"
    },
    "name": {
      "value": "essubwaf001"
    },
    "siteAddress": {
      "value": {
        "city": "New York",
        "country": "US",
        "postalCode": "10001",
        "stateOrProvince": "New York",
        "streetAddress1": "350 Fifth Avenue",
        "streetAddress2": "Floor 34"
      }
    },
    // Non-required parameters
    "displayName": {
      "value": "Test Edge Site"
    },
    "labels": {
      "value": {
        "businessUnit": "IT",
        "costCenter": "CC-1234",
        "environment": "test",
        "project": "EdgeDeployment"
      }
    },
    "siteDescription": {
      "value": "Test edge site for region deployment"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/edge/site/sub-scope:<version>'

// Required parameters
param location = '<location>'
param name = 'essubwaf001'
param siteAddress = {
  city: 'New York'
  country: 'US'
  postalCode: '10001'
  stateOrProvince: 'New York'
  streetAddress1: '350 Fifth Avenue'
  streetAddress2: 'Floor 34'
}
// Non-required parameters
param displayName = 'Test Edge Site'
param labels = {
  businessUnit: 'IT'
  costCenter: 'CC-1234'
  environment: 'test'
  project: 'EdgeDeployment'
}
param siteDescription = 'Test edge site for region deployment'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`siteAddress`](#parameter-siteaddress) | object | The physical address configuration of the site. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name of the site. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`labels`](#parameter-labels) | object | Labels for the site. |
| [`siteDescription`](#parameter-sitedescription) | string | The description of the site. |

### Parameter: `location`

Location for all Resources.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `siteAddress`

The physical address configuration of the site.

- Required: Yes
- Type: object

### Parameter: `displayName`

The display name of the site.

- Required: No
- Type: string
- Default: `[parameters('name')]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `labels`

Labels for the site.

- Required: No
- Type: object

### Parameter: `siteDescription`

The description of the site.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the site. |
| `resourceId` | string | The resource ID of the site. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
