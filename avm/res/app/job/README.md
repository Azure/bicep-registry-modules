# Container App Jobs `[Microsoft.App/jobs]`

This module deploys a Container App Job.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/jobs` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-03-01/jobs) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/job:<version>`.

- [Using a consumption plan](#example-1-using-a-consumption-plan)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using a consumption plan_

This instance deploys the module to a Container Apps Environment with a consumption plan.


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
      }
    ]
    environmentResourceId: '<environmentResourceId>'
    name: 'ajcon001'
    triggerType: 'Manual'
    // Non-required parameters
    location: '<location>'
    manualTriggerConfig: {}
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
          "name": "simple-hello-world-container"
        }
      ]
    },
    "environmentResourceId": {
      "value": "<environmentResourceId>"
    },
    "name": {
      "value": "ajcon001"
    },
    "triggerType": {
      "value": "Manual"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "manualTriggerConfig": {
      "value": {}
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

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
          cpu: '0.25'
          memory: '0.5Gi'
        }
      }
    ]
    environmentResourceId: '<environmentResourceId>'
    name: 'ajmin001'
    triggerType: 'Manual'
    // Non-required parameters
    location: '<location>'
    manualTriggerConfig: {}
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
            "cpu": "0.25",
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
      "value": {}
    }
  }
}
```

</details>
<p>

### Example 3: _Using large parameter set_

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
        env: [
          {
            name: 'AZURE_STORAGE_QUEUE_NAME'
            value: '<value>'
          }
          {
            name: 'AZURE_STORAGE_CONNECTION_STRING'
            secretRef: 'connection-string'
          }
        ]
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
          cpu: '1.25'
          memory: '1.5Gi'
        }
        volumeMounts: [
          {
            mountPath: '/mnt/data'
            volumeName: 'ajmaxemptydir'
          }
        ]
      }
      {
        args: [
          'arg1'
          'arg2'
        ]
        command: [
          '-c'
          '/bin/bash'
          'echo hello'
          'sleep 100000'
        ]
        env: [
          {
            name: 'SOME_ENV_VAR'
            value: 'some-value'
          }
        ]
        image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
        name: 'second-simple-container'
      }
    ]
    environmentResourceId: '<environmentResourceId>'
    name: 'ajmax001'
    triggerType: 'Event'
    // Non-required parameters
    eventTriggerConfig: {
      parallelism: 1
      replicaCompletionCount: 1
      scale: {
        maxExecutions: 1
        minExecutions: 1
        pollingInterval: 55
        rules: [
          {
            auth: [
              {
                secretRef: 'connectionString'
                triggerParameter: 'connection'
              }
            ]
            metadata: {
              queueName: '<queueName>'
              storageAccountResourceId: '<storageAccountResourceId>'
            }
            name: 'queue'
            type: 'azure-queue'
          }
        ]
      }
    }
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
    roleAssignments: [
      {
        name: 'be1bb251-6a44-49f7-8658-d836d0049fc4'
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
    secrets: [
      {
        name: 'connection-string'
        value: '<value>'
      }
    ]
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    volumes: [
      {
        name: 'ajmaxemptydir'
        storageType: 'EmptyDir'
      }
    ]
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
          "env": [
            {
              "name": "AZURE_STORAGE_QUEUE_NAME",
              "value": "<value>"
            },
            {
              "name": "AZURE_STORAGE_CONNECTION_STRING",
              "secretRef": "connection-string"
            }
          ],
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
            "cpu": "1.25",
            "memory": "1.5Gi"
          },
          "volumeMounts": [
            {
              "mountPath": "/mnt/data",
              "volumeName": "ajmaxemptydir"
            }
          ]
        },
        {
          "args": [
            "arg1",
            "arg2"
          ],
          "command": [
            "-c",
            "/bin/bash",
            "echo hello",
            "sleep 100000"
          ],
          "env": [
            {
              "name": "SOME_ENV_VAR",
              "value": "some-value"
            }
          ],
          "image": "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest",
          "name": "second-simple-container"
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
      "value": "Event"
    },
    // Non-required parameters
    "eventTriggerConfig": {
      "value": {
        "parallelism": 1,
        "replicaCompletionCount": 1,
        "scale": {
          "maxExecutions": 1,
          "minExecutions": 1,
          "pollingInterval": 55,
          "rules": [
            {
              "auth": [
                {
                  "secretRef": "connectionString",
                  "triggerParameter": "connection"
                }
              ],
              "metadata": {
                "queueName": "<queueName>",
                "storageAccountResourceId": "<storageAccountResourceId>"
              },
              "name": "queue",
              "type": "azure-queue"
            }
          ]
        }
      }
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
    "roleAssignments": {
      "value": [
        {
          "name": "be1bb251-6a44-49f7-8658-d836d0049fc4",
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
    "secrets": {
      "value": [
        {
          "name": "connection-string",
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
    "volumes": {
      "value": [
        {
          "name": "ajmaxemptydir",
          "storageType": "EmptyDir"
        }
      ]
    },
    "workloadProfileName": {
      "value": "<workloadProfileName>"
    }
  }
}
```

</details>
<p>

### Example 4: _WAF-aligned_

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
          cpu: '0.25'
          memory: '0.5Gi'
        }
      }
    ]
    environmentResourceId: '<environmentResourceId>'
    name: 'ajwaf001'
    triggerType: 'Schedule'
    // Non-required parameters
    location: '<location>'
    scheduleTriggerConfig: {
      cronExpression: '0 0 * * *'
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
            "cpu": "0.25",
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
      "value": "Schedule"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "scheduleTriggerConfig": {
      "value": {
        "cronExpression": "0 0 * * *"
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
| [`environmentResourceId`](#parameter-environmentresourceid) | string | Resource ID of Container Apps Environment. |
| [`name`](#parameter-name) | string | Name of the Container App. |
| [`triggerType`](#parameter-triggertype) | string | Trigger type of the job. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventTriggerConfig`](#parameter-eventtriggerconfig) | object | Configuration of an event driven job. Required if `TriggerType` is `Event`. |
| [`manualTriggerConfig`](#parameter-manualtriggerconfig) | object | Configuration of a manually triggered job. Required if `TriggerType` is `Manual`. |
| [`scheduleTriggerConfig`](#parameter-scheduletriggerconfig) | object | Configuration of a schedule based job. Required if `TriggerType` is `Schedule`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`initContainers`](#parameter-initcontainers) | array | List of specialized containers that run before app containers. |
| [`location`](#parameter-location) | string | Location for all Resources. Defaults to the location of the Resource Group. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`registries`](#parameter-registries) | array | Collection of private container registry credentials for containers used by the Container app. |
| [`replicaRetryLimit`](#parameter-replicaretrylimit) | int | The maximum number of times a replica can be retried. |
| [`replicaTimeout`](#parameter-replicatimeout) | int | Maximum number of seconds a replica is allowed to run. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`secrets`](#parameter-secrets) | array | The secrets of the Container App. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`volumes`](#parameter-volumes) | array | List of volume definitions for the Container App. |
| [`workloadProfileName`](#parameter-workloadprofilename) | string | The name of the workload profile to use. Leave empty to use a consumption based profile. |

### Parameter: `containers`

List of container definitions for the Container App.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`image`](#parameter-containersimage) | string | The image of the container. |
| [`name`](#parameter-containersname) | string | The name of the container. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`args`](#parameter-containersargs) | array | Container start command arguments. |
| [`command`](#parameter-containerscommand) | array | The command to run in the container. |
| [`env`](#parameter-containersenv) | array | The environment variables to set in the container. |
| [`probes`](#parameter-containersprobes) | array | The probes of the container. |
| [`resources`](#parameter-containersresources) | object | The resources to allocate to the container. |
| [`volumeMounts`](#parameter-containersvolumemounts) | array | The volume mounts to attach to the container. |

### Parameter: `containers.image`

The image of the container.

- Required: Yes
- Type: string

### Parameter: `containers.name`

The name of the container.

- Required: Yes
- Type: string

### Parameter: `containers.args`

Container start command arguments.

- Required: No
- Type: array

### Parameter: `containers.command`

The command to run in the container.

- Required: No
- Type: array

### Parameter: `containers.env`

The environment variables to set in the container.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containersenvname) | string | The environment variable name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretRef`](#parameter-containersenvsecretref) | string | The name of the Container App secret from which to pull the envrionment variable value. Required if `value` is null. |
| [`value`](#parameter-containersenvvalue) | string | The environment variable value. Required if `secretRef` is null. |

### Parameter: `containers.env.name`

The environment variable name.

- Required: Yes
- Type: string

### Parameter: `containers.env.secretRef`

The name of the Container App secret from which to pull the envrionment variable value. Required if `value` is null.

- Required: No
- Type: string

### Parameter: `containers.env.value`

The environment variable value. Required if `secretRef` is null.

- Required: No
- Type: string

### Parameter: `containers.probes`

The probes of the container.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-containersprobestype) | string | The type of probe. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failureThreshold`](#parameter-containersprobesfailurethreshold) | int | Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. |
| [`httpGet`](#parameter-containersprobeshttpget) | object | HTTPGet specifies the http request to perform. |
| [`initialDelaySeconds`](#parameter-containersprobesinitialdelayseconds) | int | Number of seconds after the container has started before liveness probes are initiated. Defaults to 0 seconds. |
| [`periodSeconds`](#parameter-containersprobesperiodseconds) | int | How often (in seconds) to perform the probe. Defaults to 10 seconds. |
| [`successThreshold`](#parameter-containersprobessuccessthreshold) | int | Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. |
| [`tcpSocket`](#parameter-containersprobestcpsocket) | object | TCPSocket specifies an action involving a TCP port. |
| [`terminationGracePeriodSeconds`](#parameter-containersprobesterminationgraceperiodseconds) | int | Duration in seconds the pod needs to terminate gracefully upon probe failure. This is an alpha field and requires enabling ProbeTerminationGracePeriod feature gate. |
| [`timeoutSeconds`](#parameter-containersprobestimeoutseconds) | int | Number of seconds after which the probe times out. Defaults to 1 second. |

### Parameter: `containers.probes.type`

The type of probe.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Liveness'
    'Readiness'
    'Startup'
  ]
  ```

### Parameter: `containers.probes.failureThreshold`

Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3.

- Required: No
- Type: int

### Parameter: `containers.probes.httpGet`

HTTPGet specifies the http request to perform.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`path`](#parameter-containersprobeshttpgetpath) | string | Path to access on the HTTP server. |
| [`port`](#parameter-containersprobeshttpgetport) | int | Name of the port to access on the container. If not specified, the containerPort is used. |
| [`scheme`](#parameter-containersprobeshttpgetscheme) | string | Scheme to use for connecting to the host. Defaults to HTTP. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`host`](#parameter-containersprobeshttpgethost) | string | Host name to connect to, defaults to the pod IP. |
| [`httpHeaders`](#parameter-containersprobeshttpgethttpheaders) | array | Custom headers to set in the request. |

### Parameter: `containers.probes.httpGet.path`

Path to access on the HTTP server.

- Required: Yes
- Type: string

### Parameter: `containers.probes.httpGet.port`

Name of the port to access on the container. If not specified, the containerPort is used.

- Required: Yes
- Type: int

### Parameter: `containers.probes.httpGet.scheme`

Scheme to use for connecting to the host. Defaults to HTTP.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'HTTP'
    'HTTPS'
  ]
  ```

### Parameter: `containers.probes.httpGet.host`

Host name to connect to, defaults to the pod IP.

- Required: No
- Type: string

### Parameter: `containers.probes.httpGet.httpHeaders`

Custom headers to set in the request.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containersprobeshttpgethttpheadersname) | string | The header field name. |
| [`value`](#parameter-containersprobeshttpgethttpheadersvalue) | string | The header field value. |

### Parameter: `containers.probes.httpGet.httpHeaders.name`

The header field name.

- Required: Yes
- Type: string

### Parameter: `containers.probes.httpGet.httpHeaders.value`

The header field value.

- Required: Yes
- Type: string

### Parameter: `containers.probes.initialDelaySeconds`

Number of seconds after the container has started before liveness probes are initiated. Defaults to 0 seconds.

- Required: No
- Type: int

### Parameter: `containers.probes.periodSeconds`

How often (in seconds) to perform the probe. Defaults to 10 seconds.

- Required: No
- Type: int

### Parameter: `containers.probes.successThreshold`

Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1.

- Required: No
- Type: int

### Parameter: `containers.probes.tcpSocket`

TCPSocket specifies an action involving a TCP port.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-containersprobestcpsocketport) | int | Name of the port to access on the container. If not specified, the containerPort is used. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`host`](#parameter-containersprobestcpsockethost) | string | Host name to connect to, defaults to the pod IP. |

### Parameter: `containers.probes.tcpSocket.port`

Name of the port to access on the container. If not specified, the containerPort is used.

- Required: Yes
- Type: int

### Parameter: `containers.probes.tcpSocket.host`

Host name to connect to, defaults to the pod IP.

- Required: Yes
- Type: string

### Parameter: `containers.probes.terminationGracePeriodSeconds`

Duration in seconds the pod needs to terminate gracefully upon probe failure. This is an alpha field and requires enabling ProbeTerminationGracePeriod feature gate.

- Required: No
- Type: int

### Parameter: `containers.probes.timeoutSeconds`

Number of seconds after which the probe times out. Defaults to 1 second.

- Required: No
- Type: int

### Parameter: `containers.resources`

The resources to allocate to the container.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-containersresourcescpu) | string | The CPU limit of the container in cores. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`memory`](#parameter-containersresourcesmemory) | string | The required memory. |

### Parameter: `containers.resources.cpu`

The CPU limit of the container in cores.

- Required: Yes
- Type: string
- Example:
  ```Bicep
  '0.25'
  '1'
  ```

### Parameter: `containers.resources.memory`

The required memory.

- Required: Yes
- Type: string
- Example:
  ```Bicep
  '250Mb'
  '1.5Gi'
  '1500Mi'
  ```

### Parameter: `containers.volumeMounts`

The volume mounts to attach to the container.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mountPath`](#parameter-containersvolumemountsmountpath) | string | The path within the container at which the volume should be mounted. Must not contain ':'. |
| [`volumeName`](#parameter-containersvolumemountsvolumename) | string | This must match the Name of a Volume. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subPath`](#parameter-containersvolumemountssubpath) | string | Path within the volume from which the container's volume should be mounted. |

### Parameter: `containers.volumeMounts.mountPath`

The path within the container at which the volume should be mounted. Must not contain ':'.

- Required: Yes
- Type: string

### Parameter: `containers.volumeMounts.volumeName`

This must match the Name of a Volume.

- Required: Yes
- Type: string

### Parameter: `containers.volumeMounts.subPath`

Path within the volume from which the container's volume should be mounted.

- Required: No
- Type: string

### Parameter: `environmentResourceId`

Resource ID of Container Apps Environment.

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

### Parameter: `eventTriggerConfig`

Configuration of an event driven job. Required if `TriggerType` is `Event`.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scale`](#parameter-eventtriggerconfigscale) | object | Scaling configurations for event driven jobs. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parallelism`](#parameter-eventtriggerconfigparallelism) | int | Number of parallel replicas of a job that can run at a given time. Defaults to 1. |
| [`replicaCompletionCount`](#parameter-eventtriggerconfigreplicacompletioncount) | int | Minimum number of successful replica completions before overall job completion. Must be equal or or less than the parallelism. Defaults to 1. |

### Parameter: `eventTriggerConfig.scale`

Scaling configurations for event driven jobs.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxExecutions`](#parameter-eventtriggerconfigscalemaxexecutions) | int | Maximum number of job executions that are created for a trigger, default 100. |
| [`minExecutions`](#parameter-eventtriggerconfigscaleminexecutions) | int | Minimum number of job executions that are created for a trigger, default 0. |
| [`pollingInterval`](#parameter-eventtriggerconfigscalepollinginterval) | int | Interval to check each event source in seconds. Defaults to 30s. |
| [`rules`](#parameter-eventtriggerconfigscalerules) | array | Scaling rules for the job. |

### Parameter: `eventTriggerConfig.scale.maxExecutions`

Maximum number of job executions that are created for a trigger, default 100.

- Required: No
- Type: int

### Parameter: `eventTriggerConfig.scale.minExecutions`

Minimum number of job executions that are created for a trigger, default 0.

- Required: No
- Type: int

### Parameter: `eventTriggerConfig.scale.pollingInterval`

Interval to check each event source in seconds. Defaults to 30s.

- Required: No
- Type: int

### Parameter: `eventTriggerConfig.scale.rules`

Scaling rules for the job.

- Required: Yes
- Type: array
- Example:
  ```Bicep
  [
    // for type azure-queue
    {
      name: 'myrule'
      type: 'azure-queue'
      metadata: {
        queueName: 'default'
        storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
      }
      auth: {
        secretRef: 'mysecret'
        triggerParameter: 'queueName'
      }
    }
  ]
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`auth`](#parameter-eventtriggerconfigscalerulesauth) | array | Authentication secrets for the scale rule. |
| [`name`](#parameter-eventtriggerconfigscalerulesname) | string | The name of the scale rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-eventtriggerconfigscalerulesmetadata) | object | Metadata properties to describe the scale rule. |
| [`type`](#parameter-eventtriggerconfigscalerulestype) | string | The type of the rule. |

### Parameter: `eventTriggerConfig.scale.rules.auth`

Authentication secrets for the scale rule.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretRef`](#parameter-eventtriggerconfigscalerulesauthsecretref) | string | Name of the secret from which to pull the auth params. |
| [`triggerParameter`](#parameter-eventtriggerconfigscalerulesauthtriggerparameter) | string | Trigger Parameter that uses the secret. |

### Parameter: `eventTriggerConfig.scale.rules.auth.secretRef`

Name of the secret from which to pull the auth params.

- Required: Yes
- Type: string

### Parameter: `eventTriggerConfig.scale.rules.auth.triggerParameter`

Trigger Parameter that uses the secret.

- Required: Yes
- Type: string

### Parameter: `eventTriggerConfig.scale.rules.name`

The name of the scale rule.

- Required: Yes
- Type: string

### Parameter: `eventTriggerConfig.scale.rules.metadata`

Metadata properties to describe the scale rule.

- Required: Yes
- Type: object
- Example:
  ```Bicep
  {
    "// for type azure-queue
    {
      queueName: 'default'
      storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
    }"
  }
  ```

### Parameter: `eventTriggerConfig.scale.rules.type`

The type of the rule.

- Required: Yes
- Type: string
- Example:
  ```Bicep
  "azure-servicebus"
  "azure-queue"
  "redis"
  ```

### Parameter: `eventTriggerConfig.parallelism`

Number of parallel replicas of a job that can run at a given time. Defaults to 1.

- Required: No
- Type: int

### Parameter: `eventTriggerConfig.replicaCompletionCount`

Minimum number of successful replica completions before overall job completion. Must be equal or or less than the parallelism. Defaults to 1.

- Required: No
- Type: int

### Parameter: `manualTriggerConfig`

Configuration of a manually triggered job. Required if `TriggerType` is `Manual`.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parallelism`](#parameter-manualtriggerconfigparallelism) | int | Number of parallel replicas of a job that can run at a given time. Defaults to 1. |
| [`replicaCompletionCount`](#parameter-manualtriggerconfigreplicacompletioncount) | int | Minimum number of successful replica completions before overall job completion. Must be equal or or less than the parallelism. Defaults to 1. |

### Parameter: `manualTriggerConfig.parallelism`

Number of parallel replicas of a job that can run at a given time. Defaults to 1.

- Required: No
- Type: int

### Parameter: `manualTriggerConfig.replicaCompletionCount`

Minimum number of successful replica completions before overall job completion. Must be equal or or less than the parallelism. Defaults to 1.

- Required: No
- Type: int

### Parameter: `scheduleTriggerConfig`

Configuration of a schedule based job. Required if `TriggerType` is `Schedule`.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cronExpression`](#parameter-scheduletriggerconfigcronexpression) | string | Cron formatted repeating schedule ("* * * * *") of a Cron Job. It supports the standard [cron](https://en.wikipedia.org/wiki/Cron) expression syntax. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parallelism`](#parameter-scheduletriggerconfigparallelism) | int | Number of parallel replicas of a job that can run at a given time. Defaults to 1. |
| [`replicaCompletionCount`](#parameter-scheduletriggerconfigreplicacompletioncount) | int | Number of successful completions of a job that are necessary to consider the job complete. Must be equal or or less than the parallelism. Defaults to 1. |

### Parameter: `scheduleTriggerConfig.cronExpression`

Cron formatted repeating schedule ("* * * * *") of a Cron Job. It supports the standard [cron](https://en.wikipedia.org/wiki/Cron) expression syntax.

- Required: Yes
- Type: string
- Example:
  ```Bicep
  '* * * * *' // Every minute, every hour, every day
  '0 0 * * *' // at 00:00 UTC every day
  ```

### Parameter: `scheduleTriggerConfig.parallelism`

Number of parallel replicas of a job that can run at a given time. Defaults to 1.

- Required: No
- Type: int

### Parameter: `scheduleTriggerConfig.replicaCompletionCount`

Number of successful completions of a job that are necessary to consider the job complete. Must be equal or or less than the parallelism. Defaults to 1.

- Required: No
- Type: int

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `initContainers`

List of specialized containers that run before app containers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`image`](#parameter-initcontainersimage) | string | The image of the container. |
| [`name`](#parameter-initcontainersname) | string | The name of the container. |
| [`resources`](#parameter-initcontainersresources) | object | Container resource requirements. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`args`](#parameter-initcontainersargs) | array | Container start command arguments. |
| [`command`](#parameter-initcontainerscommand) | array | Container start command. |
| [`env`](#parameter-initcontainersenv) | array | The environment variables to set in the container. |
| [`volumeMounts`](#parameter-initcontainersvolumemounts) | array | The volume mounts to attach to the container. |

### Parameter: `initContainers.image`

The image of the container.

- Required: Yes
- Type: string

### Parameter: `initContainers.name`

The name of the container.

- Required: Yes
- Type: string

### Parameter: `initContainers.resources`

Container resource requirements.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-initcontainersresourcescpu) | string | The CPU limit of the container in cores. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`memory`](#parameter-initcontainersresourcesmemory) | string | The required memory. |

### Parameter: `initContainers.resources.cpu`

The CPU limit of the container in cores.

- Required: Yes
- Type: string
- Example:
  ```Bicep
  '0.25'
  '1'
  ```

### Parameter: `initContainers.resources.memory`

The required memory.

- Required: Yes
- Type: string
- Example:
  ```Bicep
  '250Mb'
  '1.5Gi'
  '1500Mi'
  ```

### Parameter: `initContainers.args`

Container start command arguments.

- Required: Yes
- Type: array

### Parameter: `initContainers.command`

Container start command.

- Required: Yes
- Type: array

### Parameter: `initContainers.env`

The environment variables to set in the container.

- Required: No
- Type: array
- Example:
  ```Bicep
  [
    {
      name: 'AZURE_STORAGE_QUEUE_NAME'
      value: '<storage-queue-name>'
    }
    {
      name: 'AZURE_STORAGE_CONNECTION_STRING'
      secretRef: 'connection-string'
    }
  ]
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-initcontainersenvname) | string | The environment variable name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretRef`](#parameter-initcontainersenvsecretref) | string | The name of the Container App secret from which to pull the envrionment variable value. Required if `value` is null. |
| [`value`](#parameter-initcontainersenvvalue) | string | The environment variable value. Required if `secretRef` is null. |

### Parameter: `initContainers.env.name`

The environment variable name.

- Required: Yes
- Type: string

### Parameter: `initContainers.env.secretRef`

The name of the Container App secret from which to pull the envrionment variable value. Required if `value` is null.

- Required: No
- Type: string

### Parameter: `initContainers.env.value`

The environment variable value. Required if `secretRef` is null.

- Required: No
- Type: string

### Parameter: `initContainers.volumeMounts`

The volume mounts to attach to the container.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mountPath`](#parameter-initcontainersvolumemountsmountpath) | string | The path within the container at which the volume should be mounted. Must not contain ':'. |
| [`volumeName`](#parameter-initcontainersvolumemountsvolumename) | string | This must match the Name of a Volume. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subPath`](#parameter-initcontainersvolumemountssubpath) | string | Path within the volume from which the container's volume should be mounted. |

### Parameter: `initContainers.volumeMounts.mountPath`

The path within the container at which the volume should be mounted. Must not contain ':'.

- Required: Yes
- Type: string

### Parameter: `initContainers.volumeMounts.volumeName`

This must match the Name of a Volume.

- Required: Yes
- Type: string

### Parameter: `initContainers.volumeMounts.subPath`

Path within the volume from which the container's volume should be mounted.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources. Defaults to the location of the Resource Group.

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
- Example:
  ```Bicep
  {
    systemAssigned: true,
    userAssignedResourceIds: [
      '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
    ]
  }
  {
    systemAssigned: true
  }
  ```

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

### Parameter: `registries`

Collection of private container registry credentials for containers used by the Container app.

- Required: No
- Type: array
- Example:
  ```Bicep
  [
    {
      server: 'myregistry.azurecr.io'
      identity: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
    }
    {
      server: 'myregistry2.azurecr.io'
      identity: 'system'
    }
    {
      server: 'myregistry3.azurecr.io'
      username: 'myusername'
      passwordSecretRef: 'secret-name'
    }
  ]
  ```

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
- Example: `myregistry.azurecr.io`

### Parameter: `registries.passwordSecretRef`

The name of the secret contains the login password. Required if `username` is not null.

- Required: No
- Type: string

### Parameter: `registries.identity`

The resource ID of the (user) managed identity, which is used to access the Azure Container Registry.

- Required: No
- Type: string
- Example:
  ```Bicep
  user-assigned identity: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity
  system-assigned identity: system
  ```

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
- Roles configurable by name:
  - `'ContainerApp Reader'`
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

### Parameter: `secrets`

The secrets of the Container App.

- Required: No
- Type: array
- Example:
  ```Bicep
  [
    {
      name: 'mysecret'
      identity: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
      keyVaultUrl: 'https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret'
    }
    {
      name: 'mysecret'
      identity: 'system'
      keyVaultUrl: 'https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret'
    }
    {
      // You can do this, but you shouldn't. Use a secret reference instead.
      name: 'mysecret'
      value: 'mysecretvalue'
    }
    {
      name: 'connection-string'
      value: listKeys('/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount', '2023-04-01').keys[0].value
    }
  ]
  ```

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultUrl`](#parameter-secretskeyvaulturl) | string | Azure Key Vault URL pointing to the secret referenced by the Container App Job. Required if `value` is null. |
| [`value`](#parameter-secretsvalue) | securestring | The secret value, if not fetched from Key Vault. Required if `keyVaultUrl` is not null. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-secretsidentity) | string | Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity. |
| [`name`](#parameter-secretsname) | string | The name of the secret. |

### Parameter: `secrets.keyVaultUrl`

Azure Key Vault URL pointing to the secret referenced by the Container App Job. Required if `value` is null.

- Required: No
- Type: string
- Example: `https://myvault${environment().suffixes.keyvaultDns}/secrets/mysecret`

### Parameter: `secrets.value`

The secret value, if not fetched from Key Vault. Required if `keyVaultUrl` is not null.

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
- Example:
  ```Bicep
  {
      key1: 'value1'
      key2: 'value2'
  }
  ```

### Parameter: `volumes`

List of volume definitions for the Container App.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumesname) | string | The name of the volume. |
| [`storageType`](#parameter-volumesstoragetype) | string | The container name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mountOptions`](#parameter-volumesmountoptions) | string | Mount options used while mounting the Azure file share or NFS Azure file share. Must be a comma-separated string. Required if `storageType` is not `EmptyDir`. |
| [`storageName`](#parameter-volumesstoragename) | string | The storage account name. Not needed for EmptyDir and Secret. Required if `storageType` is `AzureFile` or `NfsAzureFile`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secrets`](#parameter-volumessecrets) | array | List of secrets to be added in volume. If no secrets are provided, all secrets in collection will be added to volume. |

### Parameter: `volumes.name`

The name of the volume.

- Required: Yes
- Type: string

### Parameter: `volumes.storageType`

The container name.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureFile'
    'EmptyDir'
    'NfsAzureFile'
    'Secret'
  ]
  ```

### Parameter: `volumes.mountOptions`

Mount options used while mounting the Azure file share or NFS Azure file share. Must be a comma-separated string. Required if `storageType` is not `EmptyDir`.

- Required: No
- Type: string

### Parameter: `volumes.storageName`

The storage account name. Not needed for EmptyDir and Secret. Required if `storageType` is `AzureFile` or `NfsAzureFile`.

- Required: No
- Type: string

### Parameter: `volumes.secrets`

List of secrets to be added in volume. If no secrets are provided, all secrets in collection will be added to volume.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`path`](#parameter-volumessecretspath) | string | Path to project secret to. If no path is provided, path defaults to name of secret listed in secretRef. |
| [`secretRef`](#parameter-volumessecretssecretref) | string | Name of the Container App secret from which to pull the secret value. |

### Parameter: `volumes.secrets.path`

Path to project secret to. If no path is provided, path defaults to name of secret listed in secretRef.

- Required: Yes
- Type: string

### Parameter: `volumes.secrets.secretRef`

Name of the Container App secret from which to pull the secret value.

- Required: Yes
- Type: string

### Parameter: `workloadProfileName`

The name of the workload profile to use. Leave empty to use a consumption based profile.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Container App Job. |
| `resourceGroupName` | string | The name of the resource group the Container App Job was deployed into. |
| `resourceId` | string | The resource ID of the Container App Job. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
