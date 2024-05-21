# Container App Jobs `[Microsoft.App/jobs]`

This module deploys a Container App Job.

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
| `Microsoft.App/jobs` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-05-01/jobs) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/job:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module job 'br/public:avm/res/app/job:<version>' = {
  name: 'jobDeployment'
  params: {
    // Required parameters
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'simple-hello-world-container'
        resources: {
          cpu: '<cpu>'
          memory: '0.5Gi'
        }
      }
    ]
    environmentResourceId: '<environmentResourceId>'
    name: 'ajmin001'
    triggerType: 'Manual'
    // Non-required parameters
    location: '<location>'
    manualTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
    }
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
    "containers": {
      "value": [
        {
          "image": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest",
          "name": "simple-hello-world-container",
          "resources": {
            "cpu": "<cpu>",
            "memory": "0.5Gi"
          }
        }
      ]
    },
    "environmentResourceId": {
      "value": "<environmentResourceId>"
    },
    "name": {
      "value": "ajmin001"
    },
    "triggerType": {
      "value": "Manual"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "manualTriggerConfig": {
      "value": {
        "parallelism": 1,
        "replicaCompletionCount": 1
      }
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
module job 'br/public:avm/res/app/job:<version>' = {
  name: 'jobDeployment'
  params: {
    // Required parameters
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'simple-hello-world-container'
        probes: [
          {
            httpGet: {
              httpHeaders: [
                {
                  name: 'Custom-Header'
                  value: 'Awesome'
                }
              ]
              path: '/health'
              port: 8080
            }
            initialDelaySeconds: 3
            periodSeconds: 3
            type: 'Liveness'
          }
        ]
        resources: {
          cpu: '<cpu>'
          memory: '0.5Gi'
        }
      }
    ]
    environmentResourceId: '<environmentResourceId>'
    name: 'ajmax001'
    triggerType: 'Manual'
    // Non-required parameters
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
    manualTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
    }
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
    secrets: [
      {
        name: 'customtest'
        value: '<value>'
      }
    ]
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfileName: '<workloadProfileName>'
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
    "containers": {
      "value": [
        {
          "image": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest",
          "name": "simple-hello-world-container",
          "probes": [
            {
              "httpGet": {
                "httpHeaders": [
                  {
                    "name": "Custom-Header",
                    "value": "Awesome"
                  }
                ],
                "path": "/health",
                "port": 8080
              },
              "initialDelaySeconds": 3,
              "periodSeconds": 3,
              "type": "Liveness"
            }
          ],
          "resources": {
            "cpu": "<cpu>",
            "memory": "0.5Gi"
          }
        }
      ]
    },
    "environmentResourceId": {
      "value": "<environmentResourceId>"
    },
    "name": {
      "value": "ajmax001"
    },
    "triggerType": {
      "value": "Manual"
    },
    // Non-required parameters
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
    "manualTriggerConfig": {
      "value": {
        "parallelism": 1,
        "replicaCompletionCount": 1
      }
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
    "secrets": {
      "value": [
        {
          "name": "customtest",
          "value": "<value>"
        }
      ]
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfileName": {
      "value": "<workloadProfileName>"
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
module job 'br/public:avm/res/app/job:<version>' = {
  name: 'jobDeployment'
  params: {
    // Required parameters
    containers: [
      {
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'simple-hello-world-container'
        probes: [
          {
            httpGet: {
              httpHeaders: [
                {
                  name: 'Custom-Header'
                  value: 'Awesome'
                }
              ]
              path: '/health'
              port: 8080
            }
            initialDelaySeconds: 3
            periodSeconds: 3
            type: 'Liveness'
          }
        ]
        resources: {
          cpu: '<cpu>'
          memory: '0.5Gi'
        }
      }
    ]
    environmentResourceId: '<environmentResourceId>'
    name: 'ajwaf001'
    triggerType: 'Manual'
    // Non-required parameters
    location: '<location>'
    manualTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
    }
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfileName: '<workloadProfileName>'
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
    "containers": {
      "value": [
        {
          "image": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest",
          "name": "simple-hello-world-container",
          "probes": [
            {
              "httpGet": {
                "httpHeaders": [
                  {
                    "name": "Custom-Header",
                    "value": "Awesome"
                  }
                ],
                "path": "/health",
                "port": 8080
              },
              "initialDelaySeconds": 3,
              "periodSeconds": 3,
              "type": "Liveness"
            }
          ],
          "resources": {
            "cpu": "<cpu>",
            "memory": "0.5Gi"
          }
        }
      ]
    },
    "environmentResourceId": {
      "value": "<environmentResourceId>"
    },
    "name": {
      "value": "ajwaf001"
    },
    "triggerType": {
      "value": "Manual"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "manualTriggerConfig": {
      "value": {
        "parallelism": 1,
        "replicaCompletionCount": 1
      }
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfileName": {
      "value": "<workloadProfileName>"
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
| [`containers`](#parameter-containers) | array | List of container definitions for the Container App. |
| [`environmentResourceId`](#parameter-environmentresourceid) | string | Resource ID of environment. |
| [`name`](#parameter-name) | string | Name of the Container App. |
| [`triggerType`](#parameter-triggertype) | string | Trigger type of the job. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`eventTriggerConfig`](#parameter-eventtriggerconfig) | object | Required if TriggerType is Event. Configuration of an event driven job. |
| [`initContainersTemplate`](#parameter-initcontainerstemplate) | array | List of specialized containers that run before app containers. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`manualTriggerConfig`](#parameter-manualtriggerconfig) | object | Required if TriggerType is Manual. Configuration of a manual job. |
| [`registries`](#parameter-registries) | array | Collection of private container registry credentials for containers used by the Container app. |
| [`replicaRetryLimit`](#parameter-replicaretrylimit) | int | The maximum number of times a replica can be retried. |
| [`replicaTimeout`](#parameter-replicatimeout) | int | Maximum number of seconds a replica is allowed to run. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scheduleTriggerConfig`](#parameter-scheduletriggerconfig) | object | Required if TriggerType is Schedule. Configuration of a schedule based job. |
| [`secrets`](#parameter-secrets) | array | The secrets of the Container App. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`volumes`](#parameter-volumes) | array | List of volume definitions for the Container App. |
| [`workloadProfileName`](#parameter-workloadprofilename) | string | The name of the workload profile to use. |

### Parameter: `containers`

List of container definitions for the Container App.

- Required: Yes
- Type: array

### Parameter: `environmentResourceId`

Resource ID of environment.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the Container App.

- Required: Yes
- Type: string

### Parameter: `triggerType`

Trigger type of the job.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Event'
    'Manual'
    'Schedule'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `eventTriggerConfig`

Required if TriggerType is Event. Configuration of an event driven job.

- Required: No
- Type: object

### Parameter: `initContainersTemplate`

List of specialized containers that run before app containers.

- Required: No
- Type: array

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

### Parameter: `manualTriggerConfig`

Required if TriggerType is Manual. Configuration of a manual job.

- Required: No
- Type: object

### Parameter: `registries`

Collection of private container registry credentials for containers used by the Container app.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`server`](#parameter-registriesserver) | string | The FQDN name of the container registry. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`passwordSecretRef`](#parameter-registriespasswordsecretref) | string | The name of the secret contains the login password. Required if `username` is not null. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-registriesidentity) | string | The resource ID of the (user) managed identity, which is used to access the Azure Container Registry. |
| [`username`](#parameter-registriesusername) | string | The username for the container registry. |

### Parameter: `registries.server`

The FQDN name of the container registry.

- Required: Yes
- Type: string

### Parameter: `registries.passwordSecretRef`

The name of the secret contains the login password. Required if `username` is not null.

- Required: No
- Type: string

### Parameter: `registries.identity`

The resource ID of the (user) managed identity, which is used to access the Azure Container Registry.

- Required: No
- Type: string

### Parameter: `registries.username`

The username for the container registry.

- Required: No
- Type: string

### Parameter: `replicaRetryLimit`

The maximum number of times a replica can be retried.

- Required: No
- Type: int
- Default: `0`

### Parameter: `replicaTimeout`

Maximum number of seconds a replica is allowed to run.

- Required: No
- Type: int
- Default: `1800`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

### Parameter: `scheduleTriggerConfig`

Required if TriggerType is Schedule. Configuration of a schedule based job.

- Required: No
- Type: object

### Parameter: `secrets`

The secrets of the Container App.

- Required: No
- Type: array

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultUrl`](#parameter-secretskeyvaulturl) | string | If an identity is used, the resource ID of a user-managed identity or System for a system-assigned managed identity to authenticate with Azure Key Vault. Required if `identity` is not null. |
| [`value`](#parameter-secretsvalue) | securestring | If name is used to specify a username, this value holds the secret for that username. Required if `name` is not null. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-secretsidentity) | string | Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity. |
| [`name`](#parameter-secretsname) | string | The name of the secret. |

### Parameter: `secrets.keyVaultUrl`

If an identity is used, the resource ID of a user-managed identity or System for a system-assigned managed identity to authenticate with Azure Key Vault. Required if `identity` is not null.

- Required: No
- Type: string

### Parameter: `secrets.value`

If name is used to specify a username, this value holds the secret for that username. Required if `name` is not null.

- Required: No
- Type: securestring

### Parameter: `secrets.identity`

Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity.

- Required: No
- Type: string

### Parameter: `secrets.name`

The name of the secret.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `volumes`

List of volume definitions for the Container App.

- Required: No
- Type: array

### Parameter: `workloadProfileName`

The name of the workload profile to use.

- Required: No
- Type: string
- Default: `'Consumption'`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Container App Job. |
| `resourceGroupName` | string | The name of the resource group the Container App Job was deployed into. |
| `resourceId` | string | The resource ID of the Container App Job. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
