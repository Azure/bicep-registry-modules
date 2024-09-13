# App ManagedEnvironments `[Microsoft.App/managedEnvironments]`

This module deploys an App Managed Environment (also known as a Container App Environment).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/managedEnvironments` | [2024-02-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-02-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/storages` | [2024-02-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-02-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/managed-environment:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'amemin001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetId: '<infrastructureSubnetId>'
    internal: true
    location: '<location>'
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
      }
    ]
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
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "amemin001"
    },
    // Non-required parameters
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetId": {
      "value": "<infrastructureSubnetId>"
    },
    "internal": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'amemax001'
    // Non-required parameters
    appInsightsConnectionString: '<appInsightsConnectionString>'
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetId: '<infrastructureSubnetId>'
    internal: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    openTelemetryConfiguration: {
      logsConfiguration: {
        destinations: [
          'appInsights'
        ]
      }
      tracesConfiguration: {
        destinations: [
          'appInsights'
        ]
      }
    }
    peerTrafficEncryption: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    roleAssignments: [
      {
        name: '43fc5250-f111-472b-8722-f1cb4a0e754b'
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
    storages: [
      {
        accessMode: 'ReadWrite'
        kind: 'SMB'
        shareName: 'smbfileshare'
        storageAccountName: '<storageAccountName>'
      }
      {
        accessMode: 'ReadWrite'
        kind: 'NFS'
        shareName: 'nfsfileshare'
        storageAccountName: '<storageAccountName>'
      }
    ]
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
      }
    ]
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
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "amemax001"
    },
    // Non-required parameters
    "appInsightsConnectionString": {
      "value": "<appInsightsConnectionString>"
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetId": {
      "value": "<infrastructureSubnetId>"
    },
    "internal": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "openTelemetryConfiguration": {
      "value": {
        "logsConfiguration": {
          "destinations": [
            "appInsights"
          ]
        },
        "tracesConfiguration": {
          "destinations": [
            "appInsights"
          ]
        }
      }
    },
    "peerTrafficEncryption": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "43fc5250-f111-472b-8722-f1cb4a0e754b",
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
    "storages": {
      "value": [
        {
          "accessMode": "ReadWrite",
          "kind": "SMB",
          "shareName": "smbfileshare",
          "storageAccountName": "<storageAccountName>"
        },
        {
          "accessMode": "ReadWrite",
          "kind": "NFS",
          "shareName": "nfsfileshare",
          "storageAccountName": "<storageAccountName>"
        }
      ]
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    name: 'amewaf001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetId: '<infrastructureSubnetId>'
    internal: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
      }
    ]
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
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "name": {
      "value": "amewaf001"
    },
    // Non-required parameters
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetId": {
      "value": "<infrastructureSubnetId>"
    },
    "internal": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
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
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
        }
      ]
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
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990). |
| [`name`](#parameter-name) | string | Name of the Container Apps Managed Environment. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dockerBridgeCidr`](#parameter-dockerbridgecidr) | string | CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`infrastructureResourceGroupName`](#parameter-infrastructureresourcegroupname) | string | Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`infrastructureSubnetId`](#parameter-infrastructuresubnetid) | string | Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`internal`](#parameter-internal) | bool | Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`platformReservedCidr`](#parameter-platformreservedcidr) | string | IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant. |
| [`platformReservedDnsIP`](#parameter-platformreserveddnsip) | string | An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`workloadProfiles`](#parameter-workloadprofiles) | array | Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightsConnectionString`](#parameter-appinsightsconnectionstring) | securestring | Application Insights connection string. |
| [`certificatePassword`](#parameter-certificatepassword) | securestring | Password of the certificate used by the custom domain. |
| [`certificateValue`](#parameter-certificatevalue) | securestring | Certificate to use for the custom domain. PFX or PEM. |
| [`daprAIConnectionString`](#parameter-dapraiconnectionstring) | securestring | Application Insights connection string used by Dapr to export Service to Service communication telemetry. |
| [`daprAIInstrumentationKey`](#parameter-dapraiinstrumentationkey) | securestring | Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry. |
| [`dnsSuffix`](#parameter-dnssuffix) | string | DNS suffix for the environment domain. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`logsDestination`](#parameter-logsdestination) | string | Logs destination. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`openTelemetryConfiguration`](#parameter-opentelemetryconfiguration) | object | Open Telemetry configuration. |
| [`peerTrafficEncryption`](#parameter-peertrafficencryption) | bool | Whether or not to encrypt peer traffic. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`storages`](#parameter-storages) | array | The list of storages to mount on the environment. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not this Managed Environment is zone-redundant. |

### Parameter: `logAnalyticsWorkspaceResourceId`

Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990).

- Required: Yes
- Type: string

### Parameter: `name`

Name of the Container Apps Managed Environment.

- Required: Yes
- Type: string

### Parameter: `dockerBridgeCidr`

CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `infrastructureResourceGroupName`

Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `[take(format('ME_{0}', parameters('name')), 63)]`

### Parameter: `infrastructureSubnetId`

Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `internal`

Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `platformReservedCidr`

IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `platformReservedDnsIP`

An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `workloadProfiles`

Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appInsightsConnectionString`

Application Insights connection string.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `certificatePassword`

Password of the certificate used by the custom domain.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `certificateValue`

Certificate to use for the custom domain. PFX or PEM.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIConnectionString`

Application Insights connection string used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIInstrumentationKey`

Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `dnsSuffix`

DNS suffix for the environment domain.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `logsDestination`

Logs destination.

- Required: No
- Type: string
- Default: `'log-analytics'`

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `openTelemetryConfiguration`

Open Telemetry configuration.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `peerTrafficEncryption`

Whether or not to encrypt peer traffic.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `storages`

The list of storages to mount on the environment.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessMode`](#parameter-storagesaccessmode) | string | Access mode for storage: "ReadOnly" or "ReadWrite". |
| [`kind`](#parameter-storageskind) | string | Type of storage: "SMB" or "NFS". |
| [`shareName`](#parameter-storagessharename) | string | File share name. |
| [`storageAccountName`](#parameter-storagesstorageaccountname) | string | Storage account name. |

### Parameter: `storages.accessMode`

Access mode for storage: "ReadOnly" or "ReadWrite".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `storages.kind`

Type of storage: "SMB" or "NFS".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NFS'
    'SMB'
  ]
  ```

### Parameter: `storages.shareName`

File share name.

- Required: Yes
- Type: string

### Parameter: `storages.storageAccountName`

Storage account name.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zoneRedundant`

Whether or not this Managed Environment is zone-redundant.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `defaultDomain` | string | The Default domain of the Managed Environment. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Managed Environment. |
| `resourceGroupName` | string | The name of the resource group the Managed Environment was deployed into. |
| `resourceId` | string | The resource ID of the Managed Environment. |
| `staticIp` | string | The IP address of the Managed Environment. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
