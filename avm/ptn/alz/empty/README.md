# avm/ptn/alz/empty `[Alz/Empty]`

Azure Landing Zones - Bicep - Empty

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

_None_

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/alz/empty:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Max](#example-2-max)
- [Waf-Aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module empty 'br/public:avm/ptn/alz/empty:<version>' = {
  name: 'emptyDeployment'
  params: {

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
  "parameters": {}
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/alz/empty:<version>'


```

</details>
<p>

### Example 2: _Max_

<details>

<summary>via Bicep module</summary>

```bicep
module empty 'br/public:avm/ptn/alz/empty:<version>' = {
  name: 'emptyDeployment'
  params: {
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'pdnsZonesLock'
    }
    privateLinkPrivateDnsZones: [
      'testpdnszone1.int'
      'testpdnszone2.local'
    ]
    tags: {
      Environment: 'Example'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualNetworkResourceIdsToLinkTo: [
      '<vnetResourceId>'
    ]
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
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "pdnsZonesLock"
      }
    },
    "privateLinkPrivateDnsZones": {
      "value": [
        "testpdnszone1.int",
        "testpdnszone2.local"
      ]
    },
    "tags": {
      "value": {
        "Environment": "Example",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualNetworkResourceIdsToLinkTo": {
      "value": [
        "<vnetResourceId>"
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/alz/empty:<version>'

param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'pdnsZonesLock'
}
param privateLinkPrivateDnsZones = [
  'testpdnszone1.int'
  'testpdnszone2.local'
]
param tags = {
  Environment: 'Example'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualNetworkResourceIdsToLinkTo = [
  '<vnetResourceId>'
]
```

</details>
<p>

### Example 3: _Waf-Aligned_

<details>

<summary>via Bicep module</summary>

```bicep
module empty 'br/public:avm/ptn/alz/empty:<version>' = {
  name: 'emptyDeployment'
  params: {
    virtualNetworkResourceIdsToLinkTo: [
      '<vnetResourceId>'
    ]
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
    "virtualNetworkResourceIdsToLinkTo": {
      "value": [
        "<vnetResourceId>"
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/alz/empty:<version>'

param virtualNetworkResourceIdsToLinkTo = [
  '<vnetResourceId>'
]
```

</details>
<p>

## Parameters

_None_

## Outputs

_None_
