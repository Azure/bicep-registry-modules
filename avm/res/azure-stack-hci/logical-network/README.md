# Azure Stack HCI Logical Network `[Microsoft.AzureStackHCI/logicalNetworks]`

This module deploys an Azure Stack HCI Logical Network.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.AzureStackHCI/logicalNetworks` | [2024-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/2024-05-01-preview/logicalNetworks) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/logical-network:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module logicalNetwork 'br/public:avm/res/azure-stack-hci/logical-network:<version>' = {
  name: 'logicalNetworkDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    name: 'ashlnminlogicalnetwork'
    vmSwitchName: '<vmSwitchName>'
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "name": {
      "value": "ashlnminlogicalnetwork"
    },
    "vmSwitchName": {
      "value": "<vmSwitchName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/logical-network:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param name = 'ashlnminlogicalnetwork'
param vmSwitchName = '<vmSwitchName>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module logicalNetwork 'br/public:avm/res/azure-stack-hci/logical-network:<version>' = {
  name: 'logicalNetworkDeployment'
  params: {
    // Required parameters
    customLocationResourceId: '<customLocationResourceId>'
    name: 'ashlnwaflogicalnetwork'
    vmSwitchName: '<vmSwitchName>'
    // Non-required parameters
    addressPrefix: '192.168.1.0/24'
    defaultGateway: '192.168.1.1'
    dnsServers: [
      '192.168.1.254'
    ]
    endingAddress: '192.168.1.190'
    ipAllocationMethod: 'Static'
    routeName: 'default'
    startingAddress: '192.168.1.171'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vlanId: '<vlanId>'
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
    "customLocationResourceId": {
      "value": "<customLocationResourceId>"
    },
    "name": {
      "value": "ashlnwaflogicalnetwork"
    },
    "vmSwitchName": {
      "value": "<vmSwitchName>"
    },
    // Non-required parameters
    "addressPrefix": {
      "value": "192.168.1.0/24"
    },
    "defaultGateway": {
      "value": "192.168.1.1"
    },
    "dnsServers": {
      "value": [
        "192.168.1.254"
      ]
    },
    "endingAddress": {
      "value": "192.168.1.190"
    },
    "ipAllocationMethod": {
      "value": "Static"
    },
    "routeName": {
      "value": "default"
    },
    "startingAddress": {
      "value": "192.168.1.171"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vlanId": {
      "value": "<vlanId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/azure-stack-hci/logical-network:<version>'

// Required parameters
param customLocationResourceId = '<customLocationResourceId>'
param name = 'ashlnwaflogicalnetwork'
param vmSwitchName = '<vmSwitchName>'
// Non-required parameters
param addressPrefix = '192.168.1.0/24'
param defaultGateway = '192.168.1.1'
param dnsServers = [
  '192.168.1.254'
]
param endingAddress = '192.168.1.190'
param ipAllocationMethod = 'Static'
param routeName = 'default'
param startingAddress = '192.168.1.171'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param vlanId = '<vlanId>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customLocationResourceId`](#parameter-customlocationresourceid) | string | The custom location ID. |
| [`name`](#parameter-name) | string | Name of the resource to create. |
| [`vmSwitchName`](#parameter-vmswitchname) | string | The VM switch name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-addressprefix) | string | Address prefix for the logical network. Required if ipAllocationMethod is Static. |
| [`defaultGateway`](#parameter-defaultgateway) | string | The default gateway for the network. Required if ipAllocationMethod is Static. |
| [`dnsServers`](#parameter-dnsservers) | array | The DNS servers list. Required if ipAllocationMethod is Static. |
| [`endingAddress`](#parameter-endingaddress) | string | The ending IP address of the IP address range. Required if ipAllocationMethod is Static. |
| [`routeName`](#parameter-routename) | string | The route name. Required if ipAllocationMethod is Static. |
| [`startingAddress`](#parameter-startingaddress) | string | The starting IP address of the IP address range. Required if ipAllocationMethod is Static. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipAllocationMethod`](#parameter-ipallocationmethod) | string | The IP allocation method. |
| [`ipConfigurationReferences`](#parameter-ipconfigurationreferences) | array | A list of IP configuration references. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`subnet0Name`](#parameter-subnet0name) | string | The subnet name. |
| [`tags`](#parameter-tags) | object | Tags for the logical network. |
| [`vlanId`](#parameter-vlanid) | int | VLan Id for the logical network. |

### Parameter: `customLocationResourceId`

The custom location ID.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `vmSwitchName`

The VM switch name.

- Required: Yes
- Type: string

### Parameter: `addressPrefix`

Address prefix for the logical network. Required if ipAllocationMethod is Static.

- Required: No
- Type: string

### Parameter: `defaultGateway`

The default gateway for the network. Required if ipAllocationMethod is Static.

- Required: No
- Type: string

### Parameter: `dnsServers`

The DNS servers list. Required if ipAllocationMethod is Static.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `endingAddress`

The ending IP address of the IP address range. Required if ipAllocationMethod is Static.

- Required: No
- Type: string

### Parameter: `routeName`

The route name. Required if ipAllocationMethod is Static.

- Required: No
- Type: string

### Parameter: `startingAddress`

The starting IP address of the IP address range. Required if ipAllocationMethod is Static.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ipAllocationMethod`

The IP allocation method.

- Required: No
- Type: string
- Default: `'Dynamic'`
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `ipConfigurationReferences`

A list of IP configuration references.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-ipconfigurationreferencesid) | string | The ARM ID for a Network Interface. |

### Parameter: `ipConfigurationReferences.id`

The ARM ID for a Network Interface.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'User Access Administrator'`
  - `'Role Based Access Control Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `subnet0Name`

The subnet name.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `tags`

Tags for the logical network.

- Required: No
- Type: object

### Parameter: `vlanId`

VLan Id for the logical network.

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the logical network. |
| `name` | string | The name of the logical network. |
| `resourceGroupName` | string | The resource group of the logical network. |
| `resourceId` | string | The resource ID of the logical network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
