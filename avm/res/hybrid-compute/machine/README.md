# Hybrid Compute Machines `[Microsoft.HybridCompute/machines]`

This module deploys an Arc Machine for use with Arc Resource Bridge for Azure Stack HCI or VMware. In these scenarios, this resource module will be used in combination with another resource module to create the require Virtual Machine Instance extension resource on this Arc Machine resource. This module should not be used for other Arc-enabled server scenarios, where the Arc Machine resource is created automatically by the onboarding process.

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
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.HybridCompute/machines` | [2024-07-10](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HybridCompute/2024-07-10/machines) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/hybrid-compute/machine:<version>`.

- [Creates an Arc Machine using only the defaults](#example-1-creates-an-arc-machine-using-only-the-defaults)
- [Creates an Arc Machine with maximum configurations](#example-2-creates-an-arc-machine-with-maximum-configurations)
- [Creates an VMWare machine using only the defaults](#example-3-creates-an-vmware-machine-using-only-the-defaults)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Creates an Arc Machine using only the defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module machine 'br/public:avm/res/hybrid-compute/machine:<version>' = {
  name: 'machineDeployment'
  params: {
    // Required parameters
    kind: 'HCI'
    name: 'arcmachcimin'
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
    "kind": {
      "value": "HCI"
    },
    "name": {
      "value": "arcmachcimin"
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
using 'br/public:avm/res/hybrid-compute/machine:<version>'

// Required parameters
param kind = 'HCI'
param name = 'arcmachcimin'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Creates an Arc Machine with maximum configurations_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module machine 'br/public:avm/res/hybrid-compute/machine:<version>' = {
  name: 'machineDeployment'
  params: {
    // Required parameters
    kind: 'HCI'
    name: 'arcmachcimx'
    // Non-required parameters
    guestConfiguration: {
      assignmentType: 'ApplyAndMonitor'
      configurationParameter: [
        {
          name: 'Minimum Password Length;ExpectedValue'
          value: '16'
        }
        {
          name: 'Minimum Password Length;RemediateValue'
          value: '16'
        }
        {
          name: 'Maximum Password Age;ExpectedValue'
          value: '75'
        }
        {
          name: 'Maximum Password Age;RemediateValue'
          value: '75'
        }
      ]
      name: 'AzureWindowsBaseline'
      version: '1.*'
    }
    location: '<location>'
    osType: 'Windows'
    patchAssessmentMode: 'AutomaticByPlatform'
    patchMode: 'AutomaticByPlatform'
    privateLinkScopeResourceId: '<privateLinkScopeResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "kind": {
      "value": "HCI"
    },
    "name": {
      "value": "arcmachcimx"
    },
    // Non-required parameters
    "guestConfiguration": {
      "value": {
        "assignmentType": "ApplyAndMonitor",
        "configurationParameter": [
          {
            "name": "Minimum Password Length;ExpectedValue",
            "value": "16"
          },
          {
            "name": "Minimum Password Length;RemediateValue",
            "value": "16"
          },
          {
            "name": "Maximum Password Age;ExpectedValue",
            "value": "75"
          },
          {
            "name": "Maximum Password Age;RemediateValue",
            "value": "75"
          }
        ],
        "name": "AzureWindowsBaseline",
        "version": "1.*"
      }
    },
    "location": {
      "value": "<location>"
    },
    "osType": {
      "value": "Windows"
    },
    "patchAssessmentMode": {
      "value": "AutomaticByPlatform"
    },
    "patchMode": {
      "value": "AutomaticByPlatform"
    },
    "privateLinkScopeResourceId": {
      "value": "<privateLinkScopeResourceId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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
using 'br/public:avm/res/hybrid-compute/machine:<version>'

// Required parameters
param kind = 'HCI'
param name = 'arcmachcimx'
// Non-required parameters
param guestConfiguration = {
  assignmentType: 'ApplyAndMonitor'
  configurationParameter: [
    {
      name: 'Minimum Password Length;ExpectedValue'
      value: '16'
    }
    {
      name: 'Minimum Password Length;RemediateValue'
      value: '16'
    }
    {
      name: 'Maximum Password Age;ExpectedValue'
      value: '75'
    }
    {
      name: 'Maximum Password Age;RemediateValue'
      value: '75'
    }
  ]
  name: 'AzureWindowsBaseline'
  version: '1.*'
}
param location = '<location>'
param osType = 'Windows'
param patchAssessmentMode = 'AutomaticByPlatform'
param patchMode = 'AutomaticByPlatform'
param privateLinkScopeResourceId = '<privateLinkScopeResourceId>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _Creates an VMWare machine using only the defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module machine 'br/public:avm/res/hybrid-compute/machine:<version>' = {
  name: 'machineDeployment'
  params: {
    // Required parameters
    kind: 'VMware'
    name: 'arcmacvmwmin'
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
    "kind": {
      "value": "VMware"
    },
    "name": {
      "value": "arcmacvmwmin"
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
using 'br/public:avm/res/hybrid-compute/machine:<version>'

// Required parameters
param kind = 'VMware'
param name = 'arcmacvmwmin'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module machine 'br/public:avm/res/hybrid-compute/machine:<version>' = {
  name: 'machineDeployment'
  params: {
    // Required parameters
    kind: 'HCI'
    name: 'arcmacwaf'
    // Non-required parameters
    location: '<location>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "kind": {
      "value": "HCI"
    },
    "name": {
      "value": "arcmacwaf"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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
using 'br/public:avm/res/hybrid-compute/machine:<version>'

// Required parameters
param kind = 'HCI'
param name = 'arcmacwaf'
// Non-required parameters
param location = '<location>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | Kind of Arc machine to be created. Possible values are: HCI, SCVMM, VMware. |
| [`name`](#parameter-name) | string | The name of the Arc machine to be created. You should use a unique prefix to reduce name collisions in Active Directory. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`osType`](#parameter-ostype) | string | Required if you are providing OS-type specified configurations, such as patch settings. The chosen OS type, either Windows or Linux. |
| [`privateLinkScopeResourceId`](#parameter-privatelinkscoperesourceid) | string | The resource ID of an Arc Private Link Scope which which to associate this machine. Required if you are using Private Link for Arc and your Arc Machine will resolve a Private Endpoint for connectivity to Azure. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientPublicKey`](#parameter-clientpublickey) | securestring | The Public Key that the client provides to be used during initial resource onboarding. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`guestConfiguration`](#parameter-guestconfiguration) | object | The guest configuration for the Arc machine. Needs the Guest Configuration extension to be enabled. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`parentClusterResourceId`](#parameter-parentclusterresourceid) | string | Parent cluster resource ID (Azure Stack HCI). |
| [`patchAssessmentMode`](#parameter-patchassessmentmode) | string | VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours. |
| [`patchMode`](#parameter-patchmode) | string | VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vmId`](#parameter-vmid) | string | The GUID of the on-premises virtual machine from your hypervisor. |

### Parameter: `kind`

Kind of Arc machine to be created. Possible values are: HCI, SCVMM, VMware.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Arc machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.

- Required: Yes
- Type: string

### Parameter: `osType`

Required if you are providing OS-type specified configurations, such as patch settings. The chosen OS type, either Windows or Linux.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `privateLinkScopeResourceId`

The resource ID of an Arc Private Link Scope which which to associate this machine. Required if you are using Private Link for Arc and your Arc Machine will resolve a Private Endpoint for connectivity to Azure.

- Required: No
- Type: string
- Default: `''`

### Parameter: `clientPublicKey`

The Public Key that the client provides to be used during initial resource onboarding.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `guestConfiguration`

The guest configuration for the Arc machine. Needs the Guest Configuration extension to be enabled.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `parentClusterResourceId`

Parent cluster resource ID (Azure Stack HCI).

- Required: No
- Type: string
- Default: `''`

### Parameter: `patchAssessmentMode`

VM guest patching assessment mode. Set it to 'AutomaticByPlatform' to enable automatically check for updates every 24 hours.

- Required: No
- Type: string
- Default: `'ImageDefault'`
- Allowed:
  ```Bicep
  [
    'AutomaticByPlatform'
    'ImageDefault'
  ]
  ```

### Parameter: `patchMode`

VM guest patching orchestration mode. 'AutomaticByOS' & 'Manual' are for Windows only, 'ImageDefault' for Linux only.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AutomaticByOS'
    'AutomaticByPlatform'
    'ImageDefault'
    'Manual'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Arc machine Administrator Login'`
  - `'Arc machine Contributor'`
  - `'Arc machine User Login'`
  - `'Windows Admin Center Administrator Login'`

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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vmId`

The GUID of the on-premises virtual machine from your hypervisor.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the machine. |
| `resourceGroupName` | string | The name of the resource group the VM was created in. |
| `resourceId` | string | The resource ID of the machine. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
