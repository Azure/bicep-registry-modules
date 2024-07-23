# DocumentDB Mongo Clusters `[Microsoft.DocumentDB/mongoClusters]`

This module deploys a DocumentDB Mongo Cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/mongoClusters` | [2024-02-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-02-15-preview/mongoClusters) |
| `Microsoft.DocumentDB/mongoClusters/firewallRules` | [2024-02-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-02-15-preview/mongoClusters/firewallRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/document-db/mongo-clusters:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module mongoClusters 'br/public:avm/res/document-db/mongo-clusters:<version>' = {
  name: 'mongoClustersDeployment'
  params: {
    // Required parameters
    administratorLogin: 'Admin001'
    administratorLoginPassword: 'Admin123'
    name: 'ddmcdefmin001'
    nodeCount: 2
    sku: 'M30'
    storage: 256
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
    "administratorLogin": {
      "value": "Admin001"
    },
    "administratorLoginPassword": {
      "value": "Admin123"
    },
    "name": {
      "value": "ddmcdefmin001"
    },
    "nodeCount": {
      "value": 2
    },
    "sku": {
      "value": "M30"
    },
    "storage": {
      "value": 256
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

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module mongoClusters 'br/public:avm/res/document-db/mongo-clusters:<version>' = {
  name: 'mongoClustersDeployment'
  params: {
    // Required parameters
    administratorLogin: 'Admin001'
    administratorLoginPassword: 'Admin123'
    name: 'ddmcwaf001'
    nodeCount: 2
    sku: 'M30'
    storage: 256
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
    "administratorLogin": {
      "value": "Admin001"
    },
    "administratorLoginPassword": {
      "value": "Admin123"
    },
    "name": {
      "value": "ddmcwaf001"
    },
    "nodeCount": {
      "value": 2
    },
    "sku": {
      "value": "M30"
    },
    "storage": {
      "value": 256
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
| [`administratorLogin`](#parameter-administratorlogin) | string | Username for admin user. |
| [`administratorLoginPassword`](#parameter-administratorloginpassword) | securestring | Password for admin user. |
| [`name`](#parameter-name) | string | Name of the Mongo Cluster. |
| [`nodeCount`](#parameter-nodecount) | int | Number of nodes in the node group. |
| [`sku`](#parameter-sku) | string | SKU defines the CPU and memory that is provisioned for each node. |
| [`storage`](#parameter-storage) | int | Disk storage size for the node group in GB. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowAllIPsFirewall`](#parameter-allowallipsfirewall) | bool | Whether to allow all IPs or not. Warning: No IP addresses will be blocked and any host on the Internet can access the coordinator in this server group. It is strongly recommended to use this rule only temporarily and only on test clusters that do not contain sensitive data. |
| [`allowAzureIPsFirewall`](#parameter-allowazureipsfirewall) | bool | Whether to allow Azure internal IPs or not. |
| [`allowedSingleIPs`](#parameter-allowedsingleips) | array | IP addresses to allow access to the cluster from. |
| [`createMode`](#parameter-createmode) | string | Mode to create the mongo cluster. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`highAvailabilityMode`](#parameter-highavailabilitymode) | bool | Whether high availability is enabled on the node group. |
| [`location`](#parameter-location) | string | Default to current resource group scope location. Location for all resources. |
| [`nodeType`](#parameter-nodetype) | string | Deployed Node type in the node group. |
| [`tags`](#parameter-tags) | object | Tags of the Database Account resource. |

### Parameter: `administratorLogin`

Username for admin user.

- Required: Yes
- Type: string

### Parameter: `administratorLoginPassword`

Password for admin user.

- Required: Yes
- Type: securestring

### Parameter: `name`

Name of the Mongo Cluster.

- Required: Yes
- Type: string

### Parameter: `nodeCount`

Number of nodes in the node group.

- Required: Yes
- Type: int

### Parameter: `sku`

SKU defines the CPU and memory that is provisioned for each node.

- Required: Yes
- Type: string

### Parameter: `storage`

Disk storage size for the node group in GB.

- Required: Yes
- Type: int

### Parameter: `allowAllIPsFirewall`

Whether to allow all IPs or not. Warning: No IP addresses will be blocked and any host on the Internet can access the coordinator in this server group. It is strongly recommended to use this rule only temporarily and only on test clusters that do not contain sensitive data.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowAzureIPsFirewall`

Whether to allow Azure internal IPs or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowedSingleIPs`

IP addresses to allow access to the cluster from.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `createMode`

Mode to create the mongo cluster.

- Required: No
- Type: string
- Default: `'Default'`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `highAvailabilityMode`

Whether high availability is enabled on the node group.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Default to current resource group scope location. Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `nodeType`

Deployed Node type in the node group.

- Required: No
- Type: string
- Default: `'Shard'`

### Parameter: `tags`

Tags of the Database Account resource.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `connectionStringKey` | string | The connection string key of the mongo cluster. |
| `name` | string | The name of the mongo cluster. |
| `resourceGroupName` | string | The name of the resource group the mongo cluster was created in. |
| `resourceId` | string | The resource ID of the mongo cluster. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
