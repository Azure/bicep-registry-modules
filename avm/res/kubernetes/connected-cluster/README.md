# Kubernetes Connected Cluster `[Microsoft.Kubernetes/connectedClusters]`

This module deploys an Azure Arc connected cluster.

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
| `Microsoft.Kubernetes/connectedClusters` | [2024-07-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Kubernetes/2024-07-15-preview/connectedClusters) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/kubernetes/connected-cluster:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module connectedCluster 'br/public:avm/res/kubernetes/connected-cluster:<version>' = {
  name: 'connectedClusterDeployment'
  params: {
    name: 'kccmin001'
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
    "name": {
      "value": "kccmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/kubernetes/connected-cluster:<version>'

param name = 'kccmin001'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module connectedCluster 'br/public:avm/res/kubernetes/connected-cluster:<version>' = {
  name: 'connectedClusterDeployment'
  params: {
    // Required parameters
    name: 'kccmax001'
    // Non-required parameters
    aadProfile: {
      adminGroupObjectIDs: []
      enableAzureRBAC: true
      tenantID: '<tenantID>'
    }
    enableTelemetry: true
    location: '<location>'
    oidcIssuerProfile: {
      enabled: true
    }
    roleAssignments: [
      {
        name: 'cbc3932a-1bee-4318-ae76-d70e1ba399c8'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
    }
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
    "name": {
      "value": "kccmax001"
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "adminGroupObjectIDs": [],
        "enableAzureRBAC": true,
        "tenantID": "<tenantID>"
      }
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "oidcIssuerProfile": {
      "value": {
        "enabled": true
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "cbc3932a-1bee-4318-ae76-d70e1ba399c8",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "securityProfile": {
      "value": {
        "workloadIdentity": {
          "enabled": true
        }
      }
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
using 'br/public:avm/res/kubernetes/connected-cluster:<version>'

// Required parameters
param name = 'kccmax001'
// Non-required parameters
param aadProfile = {
  adminGroupObjectIDs: []
  enableAzureRBAC: true
  tenantID: '<tenantID>'
}
param enableTelemetry = true
param location = '<location>'
param oidcIssuerProfile = {
  enabled: true
}
param roleAssignments = [
  {
    name: 'cbc3932a-1bee-4318-ae76-d70e1ba399c8'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param securityProfile = {
  workloadIdentity: {
    enabled: true
  }
}
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module connectedCluster 'br/public:avm/res/kubernetes/connected-cluster:<version>' = {
  name: 'connectedClusterDeployment'
  params: {
    // Required parameters
    name: 'kccwaf001'
    // Non-required parameters
    aadProfile: {
      adminGroupObjectIDs: []
      enableAzureRBAC: true
      tenantID: '<tenantID>'
    }
    location: '<location>'
    oidcIssuerProfile: {
      enabled: true
    }
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
    }
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
    "name": {
      "value": "kccwaf001"
    },
    // Non-required parameters
    "aadProfile": {
      "value": {
        "adminGroupObjectIDs": [],
        "enableAzureRBAC": true,
        "tenantID": "<tenantID>"
      }
    },
    "location": {
      "value": "<location>"
    },
    "oidcIssuerProfile": {
      "value": {
        "enabled": true
      }
    },
    "securityProfile": {
      "value": {
        "workloadIdentity": {
          "enabled": true
        }
      }
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
using 'br/public:avm/res/kubernetes/connected-cluster:<version>'

// Required parameters
param name = 'kccwaf001'
// Non-required parameters
param aadProfile = {
  adminGroupObjectIDs: []
  enableAzureRBAC: true
  tenantID: '<tenantID>'
}
param location = '<location>'
param oidcIssuerProfile = {
  enabled: true
}
param securityProfile = {
  workloadIdentity: {
    enabled: true
  }
}
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
| [`name`](#parameter-name) | string | The name of the Azure Arc connected cluster. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadProfile`](#parameter-aadprofile) | object | AAD profile for the connected cluster. |
| [`arcAgentProfile`](#parameter-arcagentprofile) | object | Arc agentry configuration for the provisioned cluster. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`oidcIssuerProfile`](#parameter-oidcissuerprofile) | object | Open ID Connect (OIDC) Issuer Profile for the connected cluster. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityProfile`](#parameter-securityprofile) | object | Security profile for the connected cluster. |
| [`tags`](#parameter-tags) | object | Tags for the cluster resource. |

### Parameter: `name`

The name of the Azure Arc connected cluster.

- Required: Yes
- Type: string

### Parameter: `aadProfile`

AAD profile for the connected cluster.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminGroupObjectIDs`](#parameter-aadprofileadmingroupobjectids) | array | The list of AAD group object IDs that will have admin role of the cluster. |
| [`enableAzureRBAC`](#parameter-aadprofileenableazurerbac) | bool | Whether to enable Azure RBAC for Kubernetes authorization. |
| [`tenantID`](#parameter-aadprofiletenantid) | string | The AAD tenant ID. |

### Parameter: `aadProfile.adminGroupObjectIDs`

The list of AAD group object IDs that will have admin role of the cluster.

- Required: Yes
- Type: array

### Parameter: `aadProfile.enableAzureRBAC`

Whether to enable Azure RBAC for Kubernetes authorization.

- Required: Yes
- Type: bool

### Parameter: `aadProfile.tenantID`

The AAD tenant ID.

- Required: Yes
- Type: string

### Parameter: `arcAgentProfile`

Arc agentry configuration for the provisioned cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      agentAutoUpgrade: 'Enabled'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentAutoUpgrade`](#parameter-arcagentprofileagentautoupgrade) | string | Indicates whether the Arc agents on the be upgraded automatically to the latest version. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentErrors`](#parameter-arcagentprofileagenterrors) | array | The errors encountered by the Arc agent. |
| [`desiredAgentVersion`](#parameter-arcagentprofiledesiredagentversion) | string | The desired version of the Arc agent. |
| [`systemComponents`](#parameter-arcagentprofilesystemcomponents) | array | List of system extensions that are installed on the cluster resource. |

### Parameter: `arcAgentProfile.agentAutoUpgrade`

Indicates whether the Arc agents on the be upgraded automatically to the latest version.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `arcAgentProfile.agentErrors`

The errors encountered by the Arc agent.

- Required: No
- Type: array

### Parameter: `arcAgentProfile.desiredAgentVersion`

The desired version of the Arc agent.

- Required: No
- Type: string

### Parameter: `arcAgentProfile.systemComponents`

List of system extensions that are installed on the cluster resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`majorVersion`](#parameter-arcagentprofilesystemcomponentsmajorversion) | int | The major version of the system component. |
| [`type`](#parameter-arcagentprofilesystemcomponentstype) | string | The type of the system component. |
| [`userSpecifiedVersion`](#parameter-arcagentprofilesystemcomponentsuserspecifiedversion) | string | The user specified version of the system component. |

### Parameter: `arcAgentProfile.systemComponents.majorVersion`

The major version of the system component.

- Required: Yes
- Type: int

### Parameter: `arcAgentProfile.systemComponents.type`

The type of the system component.

- Required: Yes
- Type: string

### Parameter: `arcAgentProfile.systemComponents.userSpecifiedVersion`

The user specified version of the system component.

- Required: Yes
- Type: string

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

### Parameter: `oidcIssuerProfile`

Open ID Connect (OIDC) Issuer Profile for the connected cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      enabled: false
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-oidcissuerprofileenabled) | bool | Whether the OIDC issuer is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`selfHostedIssuerUrl`](#parameter-oidcissuerprofileselfhostedissuerurl) | string | The URL of the self-hosted OIDC issuer. |

### Parameter: `oidcIssuerProfile.enabled`

Whether the OIDC issuer is enabled.

- Required: Yes
- Type: bool

### Parameter: `oidcIssuerProfile.selfHostedIssuerUrl`

The URL of the self-hosted OIDC issuer.

- Required: No
- Type: string

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

### Parameter: `securityProfile`

Security profile for the connected cluster.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      workloadIdentity: {
        enabled: false
      }
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workloadIdentity`](#parameter-securityprofileworkloadidentity) | object | The workload identity configuration. |

### Parameter: `securityProfile.workloadIdentity`

The workload identity configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-securityprofileworkloadidentityenabled) | bool | Whether workload identity is enabled. |

### Parameter: `securityProfile.workloadIdentity.enabled`

Whether workload identity is enabled.

- Required: Yes
- Type: bool

### Parameter: `tags`

Tags for the cluster resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the connected cluster. |
| `name` | string | The name of the connected cluster. |
| `resourceGroupName` | string | The resource group of the connected cluster. |
| `resourceId` | string | The resource ID of the connected cluster. |
| `systemAssignedMIPrincipalId` | string | The principalId of the connected cluster identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
