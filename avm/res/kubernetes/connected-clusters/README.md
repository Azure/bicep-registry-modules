# Kubernetes Connected Clusters `[Microsoft.Kubernetes/connectedClusters]`

Deploy an Azure Arc connected cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Kubernetes/connectedClusters` | [2024-12-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kubernetes/2024-12-01-preview/connectedClusters) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/kubernetes/connected-clusters:<version>`.

- [Defaults](#example-1-defaults)
- [Waf-Aligned](#example-2-waf-aligned)

### Example 1: _Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module connectedClusters 'br/public:avm/res/kubernetes/connected-clusters:<version>' = {
  name: 'connectedClustersDeployment'
  params: {
    // Required parameters
    name: 'kccdef001'
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
      "value": "kccdef001"
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

### Example 2: _Waf-Aligned_

<details>

<summary>via Bicep module</summary>

```bicep
module connectedClusters 'br/public:avm/res/kubernetes/connected-clusters:<version>' = {
  name: 'connectedClustersDeployment'
  params: {
    // Required parameters
    name: 'kccwaf001'
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
      "value": "kccwaf001"
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
| [`name`](#parameter-name) | string | The name of the Azure Arc connected cluster. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadAdminGroupObjectIds`](#parameter-aadadmingroupobjectids) | array | The Azure AD admin group object IDs |
| [`aadTenantId`](#parameter-aadtenantid) | string | Optional. The Azure AD tenant ID |
| [`agentAutoUpgrade`](#parameter-agentautoupgrade) | string | Enable automatic agent upgrades |
| [`enableAzureRBAC`](#parameter-enableazurerbac) | bool | Enable Azure RBAC |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`identityType`](#parameter-identitytype) | string | The identity type for the cluster. Allowed values: "SystemAssigned", "None" |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`oidcIssuerEnabled`](#parameter-oidcissuerenabled) | bool | Enable OIDC issuer |
| [`tags`](#parameter-tags) | object | Tags for the cluster resource |
| [`workloadIdentityEnabled`](#parameter-workloadidentityenabled) | bool | Enable workload identity |

### Parameter: `name`

The name of the Azure Arc connected cluster.

- Required: Yes
- Type: string

### Parameter: `aadAdminGroupObjectIds`

The Azure AD admin group object IDs

- Required: No
- Type: array
- Default: `[]`

### Parameter: `aadTenantId`

Optional. The Azure AD tenant ID

- Required: No
- Type: string
- Default: `''`

### Parameter: `agentAutoUpgrade`

Enable automatic agent upgrades

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `enableAzureRBAC`

Enable Azure RBAC

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `identityType`

The identity type for the cluster. Allowed values: "SystemAssigned", "None"

- Required: No
- Type: string
- Default: `'SystemAssigned'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
  ]
  ```

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `oidcIssuerEnabled`

Enable OIDC issuer

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags for the cluster resource

- Required: No
- Type: object
- Default: `{}`

### Parameter: `workloadIdentityEnabled`

Enable workload identity

- Required: No
- Type: bool
- Default: `False`

## Outputs

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
