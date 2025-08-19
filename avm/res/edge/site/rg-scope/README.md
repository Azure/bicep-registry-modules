# Microsoft Edge Site Resources `[Microsoft.Edge/sites]`

Resource group scoped resources for Microsoft Edge Site.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Edge/sites` | 2025-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.edge_sites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Edge/2025-03-01-preview/sites)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/edge/site/rg-scope:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Well-Architected Framework aligned parameters](#example-2-using-well-architected-framework-aligned-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/edge/site/rg-scope:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    name: 'esrgmin001'
    siteAddress: {
      country: 'US'
    }
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
      "value": "esrgmin001"
    },
    "siteAddress": {
      "value": {
        "country": "US"
      }
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
using 'br/public:avm/res/edge/site/rg-scope:<version>'

// Required parameters
param name = 'esrgmin001'
param siteAddress = {
  country: 'US'
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using Well-Architected Framework aligned parameters_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/edge/site/rg-scope:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    name: 'esrgwaf001'
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
    location: '<location>'
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
    "name": {
      "value": "esrgwaf001"
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
    "location": {
      "value": "<location>"
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
using 'br/public:avm/res/edge/site/rg-scope:<version>'

// Required parameters
param name = 'esrgwaf001'
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
param location = '<location>'
param siteDescription = 'Test edge site for region deployment'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`siteAddress`](#parameter-siteaddress) | object | The physical address configuration of the site. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name of the site. |
| [`labels`](#parameter-labels) | object | Labels for the site. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`siteDescription`](#parameter-sitedescription) | string | The description of the site. |

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

### Parameter: `labels`

Labels for the site.

- Required: No
- Type: object

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `siteDescription`

The description of the site.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the site. |
| `resourceGroupName` | string | The name of the resource group the role assignment was applied at. |
| `resourceId` | string | The resource ID of the site. |
