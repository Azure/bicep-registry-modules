# Kubernetes Runtime Load Balancers `[Microsoft.KubernetesRuntime/loadBalancers]`

This module deploys a Kubernetes Runtime Load Balancer for MetalLB and related networking services.

You can reference the module as follows:
```bicep
module loadBalancer 'br/public:avm/res/kubernetes-runtime/load-balancer:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.KubernetesConfiguration/extensions` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesconfiguration_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2024-11-01/extensions)</li></ul> |
| `Microsoft.KubernetesConfiguration/fluxConfigurations` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesconfiguration_fluxconfigurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesConfiguration/2025-04-01/fluxConfigurations)</li></ul> |
| `Microsoft.KubernetesRuntime/loadBalancers` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesruntime_loadbalancers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesRuntime/2024-03-01/loadBalancers)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/kubernetes-runtime/load-balancer:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/kubernetes-runtime/load-balancer:<version>' = {
  params: {
    // Required parameters
    addresses: [
      '10.0.0.100-10.0.0.110'
    ]
    advertiseMode: 'ARP'
    clusterName: '<clusterName>'
    kubernetesRuntimeRPObjectId: '<kubernetesRuntimeRPObjectId>'
    name: 'krlbmin001'
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
    "addresses": {
      "value": [
        "10.0.0.100-10.0.0.110"
      ]
    },
    "advertiseMode": {
      "value": "ARP"
    },
    "clusterName": {
      "value": "<clusterName>"
    },
    "kubernetesRuntimeRPObjectId": {
      "value": "<kubernetesRuntimeRPObjectId>"
    },
    "name": {
      "value": "krlbmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kubernetes-runtime/load-balancer:<version>'

// Required parameters
param addresses = [
  '10.0.0.100-10.0.0.110'
]
param advertiseMode = 'ARP'
param clusterName = '<clusterName>'
param kubernetesRuntimeRPObjectId = '<kubernetesRuntimeRPObjectId>'
param name = 'krlbmin001'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/kubernetes-runtime/load-balancer:<version>' = {
  params: {
    // Required parameters
    addresses: [
      '10.0.0.100-10.0.0.110'
    ]
    advertiseMode: 'Both'
    clusterName: '<clusterName>'
    kubernetesRuntimeRPObjectId: '<kubernetesRuntimeRPObjectId>'
    name: 'krlbwaf001'
    // Non-required parameters
    bgpPeers: [
      'test-peer'
    ]
    serviceSelector: {
      test: 'waf-test'
    }
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
    "addresses": {
      "value": [
        "10.0.0.100-10.0.0.110"
      ]
    },
    "advertiseMode": {
      "value": "Both"
    },
    "clusterName": {
      "value": "<clusterName>"
    },
    "kubernetesRuntimeRPObjectId": {
      "value": "<kubernetesRuntimeRPObjectId>"
    },
    "name": {
      "value": "krlbwaf001"
    },
    // Non-required parameters
    "bgpPeers": {
      "value": [
        "test-peer"
      ]
    },
    "serviceSelector": {
      "value": {
        "test": "waf-test"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kubernetes-runtime/load-balancer:<version>'

// Required parameters
param addresses = [
  '10.0.0.100-10.0.0.110'
]
param advertiseMode = 'Both'
param clusterName = '<clusterName>'
param kubernetesRuntimeRPObjectId = '<kubernetesRuntimeRPObjectId>'
param name = 'krlbwaf001'
// Non-required parameters
param bgpPeers = [
  'test-peer'
]
param serviceSelector = {
  test: 'waf-test'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addresses`](#parameter-addresses) | array | IP Range - The IP addresses that this load balancer will advertise. |
| [`advertiseMode`](#parameter-advertisemode) | string | Advertise Mode - The mode in which the load balancer should advertise the IP addresses. |
| [`clusterName`](#parameter-clustername) | string | The name of the AKS cluster or Arc-enabled connected cluster that should be configured. |
| [`kubernetesRuntimeRPObjectId`](#parameter-kubernetesruntimerpobjectid) | string | The service principal object ID of the Kubernetes Runtime HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 087fca6e-4606-4d41-b3f6-5ebdf75b8b4c`. |
| [`name`](#parameter-name) | string | The name of the load balancer. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bgpPeers`](#parameter-bgppeers) | array | The list of BGP peers it should advertise to. Null or empty means to advertise to all peers. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`serviceSelector`](#parameter-serviceselector) | object | A dynamic label mapping to select related services. For instance, if you want to create a load balancer only for services with label "a=b", then please specify {"a": "b"} in the field. |

### Parameter: `addresses`

IP Range - The IP addresses that this load balancer will advertise.

- Required: Yes
- Type: array

### Parameter: `advertiseMode`

Advertise Mode - The mode in which the load balancer should advertise the IP addresses.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ARP'
    'BGP'
    'Both'
  ]
  ```

### Parameter: `clusterName`

The name of the AKS cluster or Arc-enabled connected cluster that should be configured.

- Required: Yes
- Type: string

### Parameter: `kubernetesRuntimeRPObjectId`

The service principal object ID of the Kubernetes Runtime HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 087fca6e-4606-4d41-b3f6-5ebdf75b8b4c`.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the load balancer.

- Required: Yes
- Type: string

### Parameter: `bgpPeers`

The list of BGP peers it should advertise to. Null or empty means to advertise to all peers.

- Required: No
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `serviceSelector`

A dynamic label mapping to select related services. For instance, if you want to create a load balancer only for services with label "a=b", then please specify {"a": "b"} in the field.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-serviceselector>any_other_property<) | string | Any additional property for service selector. |

### Parameter: `serviceSelector.>Any_other_property<`

Any additional property for service selector.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the load balancer. |
| `resourceGroupName` | string | The resource group the load balancer was deployed into. |
| `resourceId` | string | The resource ID of the load balancer. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/kubernetes-configuration/extension:0.3.7` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
