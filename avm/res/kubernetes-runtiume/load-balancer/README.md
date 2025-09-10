# Kubernetes Runtime Load Balancers `[Microsoft.kubernetesruntiume/loadbalancer]`

This module deploys a Kubernetes Runtime Load Balancer for MetalLB and related networking services.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.KubernetesRuntime/loadBalancers` | 2024-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.kubernetesruntime_loadbalancers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KubernetesRuntime/2024-03-01/loadBalancers)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/kubernetes-runtiume/load-balancer:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using only defaults](#example-2-using-only-defaults)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with connected cluster.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/kubernetes-runtiume/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    addresses: [
      '10.0.0.100-10.0.0.110'
    ]
    advertiseMode: 'ARP'
    clusterName: '<clusterName>'
    name: 'kcecc001'
    // Non-required parameters
    clusterType: 'connectedCluster'
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
    "name": {
      "value": "kcecc001"
    },
    // Non-required parameters
    "clusterType": {
      "value": "connectedCluster"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kubernetes-runtiume/load-balancer:<version>'

// Required parameters
param addresses = [
  '10.0.0.100-10.0.0.110'
]
param advertiseMode = 'ARP'
param clusterName = '<clusterName>'
param name = 'kcecc001'
// Non-required parameters
param clusterType = 'connectedCluster'
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/kubernetes-runtiume/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    addresses: [
      '10.0.0.100-10.0.0.110'
    ]
    advertiseMode: 'ARP'
    clusterName: '<clusterName>'
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
using 'br/public:avm/res/kubernetes-runtiume/load-balancer:<version>'

// Required parameters
param addresses = [
  '10.0.0.100-10.0.0.110'
]
param advertiseMode = 'ARP'
param clusterName = '<clusterName>'
param name = 'krlbmin001'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/kubernetes-runtiume/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    addresses: [
      '10.0.0.100-10.0.0.120'
      '10.0.1.50-10.0.1.60'
    ]
    advertiseMode: 'BGP'
    clusterName: '<clusterName>'
    name: 'krlbwaf001'
    // Non-required parameters
    bgpPeers: [
      '10.0.2.1'
      '10.0.2.2'
    ]
    clusterType: 'managedCluster'
    serviceSelector: {
      environment: 'production'
      tier: 'frontend'
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
        "10.0.0.100-10.0.0.120",
        "10.0.1.50-10.0.1.60"
      ]
    },
    "advertiseMode": {
      "value": "BGP"
    },
    "clusterName": {
      "value": "<clusterName>"
    },
    "name": {
      "value": "krlbwaf001"
    },
    // Non-required parameters
    "bgpPeers": {
      "value": [
        "10.0.2.1",
        "10.0.2.2"
      ]
    },
    "clusterType": {
      "value": "managedCluster"
    },
    "serviceSelector": {
      "value": {
        "environment": "production",
        "tier": "frontend"
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
using 'br/public:avm/res/kubernetes-runtiume/load-balancer:<version>'

// Required parameters
param addresses = [
  '10.0.0.100-10.0.0.120'
  '10.0.1.50-10.0.1.60'
]
param advertiseMode = 'BGP'
param clusterName = '<clusterName>'
param name = 'krlbwaf001'
// Non-required parameters
param bgpPeers = [
  '10.0.2.1'
  '10.0.2.2'
]
param clusterType = 'managedCluster'
param serviceSelector = {
  environment: 'production'
  tier: 'frontend'
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
| [`name`](#parameter-name) | string | The name of the load balancer. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bgpPeers`](#parameter-bgppeers) | array | The list of BGP peers it should advertise to. Null or empty means to advertise to all peers. |
| [`clusterType`](#parameter-clustertype) | string | The type of cluster to configure. Choose between AKS managed cluster or Arc-enabled connected cluster. |
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

### Parameter: `name`

The name of the load balancer.

- Required: Yes
- Type: string

### Parameter: `bgpPeers`

The list of BGP peers it should advertise to. Null or empty means to advertise to all peers.

- Required: No
- Type: array

### Parameter: `clusterType`

The type of cluster to configure. Choose between AKS managed cluster or Arc-enabled connected cluster.

- Required: No
- Type: string
- Default: `'managedCluster'`
- Allowed:
  ```Bicep
  [
    'connectedCluster'
    'managedCluster'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `serviceSelector`

A dynamic label mapping to select related services. For instance, if you want to create a load balancer only for services with label "a=b", then please specify {"a": "b"} in the field.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the load balancer. |
| `resourceGroupName` | string | The resource group the load balancer was deployed into. |
| `resourceId` | string | The resource ID of the load balancer. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
