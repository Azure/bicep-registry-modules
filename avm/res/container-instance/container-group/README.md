# Container Instances Container Groups `[Microsoft.ContainerInstance/containerGroups]`

This module deploys a Container Instance Container Group.

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
| `Microsoft.ContainerInstance/containerGroups` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2023-05-01/containerGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/container-instance/container-group:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using CMK ](#example-2-using-cmk)
- [Using only defaults and low memory containers](#example-3-using-only-defaults-and-low-memory-containers)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [Using private network](#example-5-using-private-network)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
    availabilityZone: -1
    containers: [
      {
        name: 'az-aci-x-001'
        properties: {
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 443
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
    ]
    name: 'cicgmin001'
    // Non-required parameters
    ipAddress: {
      ports: [
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
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
    "availabilityZone": {
      "value": -1
    },
    "containers": {
      "value": [
        {
          "name": "az-aci-x-001",
          "properties": {
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 443,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        }
      ]
    },
    "name": {
      "value": "cicgmin001"
    },
    // Non-required parameters
    "ipAddress": {
      "value": {
        "ports": [
          {
            "port": 443,
            "protocol": "Tcp"
          }
        ]
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
using 'br/public:avm/res/container-instance/container-group:<version>'

// Required parameters
param availabilityZone = -1
param containers = [
  {
    name: 'az-aci-x-001'
    properties: {
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
]
param name = 'cicgmin001'
// Non-required parameters
param ipAddress = {
  ports: [
    {
      port: 443
      protocol: 'Tcp'
    }
  ]
}
```

</details>
<p>

### Example 2: _Using CMK _

This instance deploys the module with a customer-managed key (CMK).


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
    availabilityZone: -1
    containers: [
      {
        name: 'az-aci-x-001'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 80
              protocol: 'Tcp'
            }
            {
              port: 443
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
      {
        name: 'az-aci-x-002'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 8080
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
    ]
    name: 'cicenc001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
    }
    ipAddress: {
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
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
    "availabilityZone": {
      "value": -1
    },
    "containers": {
      "value": [
        {
          "name": "az-aci-x-001",
          "properties": {
            "command": [],
            "environmentVariables": [],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 80,
                "protocol": "Tcp"
              },
              {
                "port": 443,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        },
        {
          "name": "az-aci-x-002",
          "properties": {
            "command": [],
            "environmentVariables": [],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 8080,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        }
      ]
    },
    "name": {
      "value": "cicenc001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
      }
    },
    "ipAddress": {
      "value": {
        "ports": [
          {
            "port": 80,
            "protocol": "Tcp"
          },
          {
            "port": 443,
            "protocol": "Tcp"
          }
        ]
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
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
using 'br/public:avm/res/container-instance/container-group:<version>'

// Required parameters
param availabilityZone = -1
param containers = [
  {
    name: 'az-aci-x-001'
    properties: {
      command: []
      environmentVariables: []
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
  {
    name: 'az-aci-x-002'
    properties: {
      command: []
      environmentVariables: []
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 8080
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
]
param name = 'cicenc001'
// Non-required parameters
param customerManagedKey = {
  keyName: '<keyName>'
  keyVaultResourceId: '<keyVaultResourceId>'
  userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
}
param ipAddress = {
  ports: [
    {
      port: 80
      protocol: 'Tcp'
    }
    {
      port: 443
      protocol: 'Tcp'
    }
  ]
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
```

</details>
<p>

### Example 3: _Using only defaults and low memory containers_

This instance deploys the module with the minimum set of required parameters and with low memory.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
    availabilityZone: -1
    containers: [
      {
        name: 'az-aci-x-001'
        properties: {
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 443
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '0.5'
            }
          }
        }
      }
    ]
    name: 'ciclow001'
    // Non-required parameters
    ipAddress: {
      ports: [
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
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
    "availabilityZone": {
      "value": -1
    },
    "containers": {
      "value": [
        {
          "name": "az-aci-x-001",
          "properties": {
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 443,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "0.5"
              }
            }
          }
        }
      ]
    },
    "name": {
      "value": "ciclow001"
    },
    // Non-required parameters
    "ipAddress": {
      "value": {
        "ports": [
          {
            "port": 443,
            "protocol": "Tcp"
          }
        ]
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
using 'br/public:avm/res/container-instance/container-group:<version>'

// Required parameters
param availabilityZone = -1
param containers = [
  {
    name: 'az-aci-x-001'
    properties: {
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '0.5'
        }
      }
    }
  }
]
param name = 'ciclow001'
// Non-required parameters
param ipAddress = {
  ports: [
    {
      port: 443
      protocol: 'Tcp'
    }
  ]
}
```

</details>
<p>

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
    availabilityZone: '<availabilityZone>'
    containers: [
      {
        name: '<name>'
        properties: {
          command: [
            '-c'
            '/bin/sh'
            'node /usr/src/app/index.js & (sleep 10; touch /tmp/ready); wait'
          ]
          environmentVariables: [
            {
              name: 'CLIENT_ID'
              value: 'TestClientId'
            }
            {
              name: 'CLIENT_SECRET'
              secureValue: 'TestSecret'
            }
          ]
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 80
              protocol: 'Tcp'
            }
            {
              port: 443
              protocol: 'Tcp'
            }
          ]
          readinessProbe: {
            exec: {
              command: [
                '/tmp/ready'
                'cat'
              ]
            }
            failureThreshold: 3
            initialDelaySeconds: 10
            periodSeconds: 5
          }
          resources: {
            limits: {
              cpu: 4
              memoryInGB: '4'
            }
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
      {
        name: '<name>'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 8080
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
    ]
    name: '<name>'
    // Non-required parameters
    ipAddress: {
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    logAnalytics: {
      logType: 'ContainerInstanceLogs'
      workspaceResourceId: '<workspaceResourceId>'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
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
    "availabilityZone": {
      "value": "<availabilityZone>"
    },
    "containers": {
      "value": [
        {
          "name": "<name>",
          "properties": {
            "command": [
              "-c",
              "/bin/sh",
              "node /usr/src/app/index.js & (sleep 10; touch /tmp/ready); wait"
            ],
            "environmentVariables": [
              {
                "name": "CLIENT_ID",
                "value": "TestClientId"
              },
              {
                "name": "CLIENT_SECRET",
                "secureValue": "TestSecret"
              }
            ],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 80,
                "protocol": "Tcp"
              },
              {
                "port": 443,
                "protocol": "Tcp"
              }
            ],
            "readinessProbe": {
              "exec": {
                "command": [
                  "/tmp/ready",
                  "cat"
                ]
              },
              "failureThreshold": 3,
              "initialDelaySeconds": 10,
              "periodSeconds": 5
            },
            "resources": {
              "limits": {
                "cpu": 4,
                "memoryInGB": "4"
              },
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        },
        {
          "name": "<name>",
          "properties": {
            "command": [],
            "environmentVariables": [],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 8080,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "ipAddress": {
      "value": {
        "ports": [
          {
            "port": 80,
            "protocol": "Tcp"
          },
          {
            "port": 443,
            "protocol": "Tcp"
          }
        ]
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
    "logAnalytics": {
      "value": {
        "logType": "ContainerInstanceLogs",
        "workspaceResourceId": "<workspaceResourceId>"
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
using 'br/public:avm/res/container-instance/container-group:<version>'

// Required parameters
param availabilityZone = '<availabilityZone>'
param containers = [
  {
    name: '<name>'
    properties: {
      command: [
        '-c'
        '/bin/sh'
        'node /usr/src/app/index.js & (sleep 10; touch /tmp/ready); wait'
      ]
      environmentVariables: [
        {
          name: 'CLIENT_ID'
          value: 'TestClientId'
        }
        {
          name: 'CLIENT_SECRET'
          secureValue: 'TestSecret'
        }
      ]
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
      readinessProbe: {
        exec: {
          command: [
            '/tmp/ready'
            'cat'
          ]
        }
        failureThreshold: 3
        initialDelaySeconds: 10
        periodSeconds: 5
      }
      resources: {
        limits: {
          cpu: 4
          memoryInGB: '4'
        }
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
  {
    name: '<name>'
    properties: {
      command: []
      environmentVariables: []
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 8080
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
]
param name = '<name>'
// Non-required parameters
param ipAddress = {
  ports: [
    {
      port: 80
      protocol: 'Tcp'
    }
    {
      port: 443
      protocol: 'Tcp'
    }
  ]
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param logAnalytics = {
  logType: 'ContainerInstanceLogs'
  workspaceResourceId: '<workspaceResourceId>'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 5: _Using private network_

This instance deploys the module within a virtual network.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
    availabilityZone: -1
    containers: [
      {
        name: 'az-aci-x-001'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 80
              protocol: 'Tcp'
            }
            {
              port: 443
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '4'
            }
          }
        }
      }
      {
        name: 'az-aci-x-002'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 8080
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
    ]
    name: 'cicgprivate001'
    // Non-required parameters
    ipAddress: {
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
        {
          port: 8080
          protocol: 'Tcp'
        }
      ]
      type: 'Private'
    }
    subnets: [
      {
        subnetResourceId: '<subnetResourceId>'
      }
    ]
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
    "availabilityZone": {
      "value": -1
    },
    "containers": {
      "value": [
        {
          "name": "az-aci-x-001",
          "properties": {
            "command": [],
            "environmentVariables": [],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 80,
                "protocol": "Tcp"
              },
              {
                "port": 443,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "4"
              }
            }
          }
        },
        {
          "name": "az-aci-x-002",
          "properties": {
            "command": [],
            "environmentVariables": [],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 8080,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        }
      ]
    },
    "name": {
      "value": "cicgprivate001"
    },
    // Non-required parameters
    "ipAddress": {
      "value": {
        "ports": [
          {
            "port": 80,
            "protocol": "Tcp"
          },
          {
            "port": 443,
            "protocol": "Tcp"
          },
          {
            "port": 8080,
            "protocol": "Tcp"
          }
        ],
        "type": "Private"
      }
    },
    "subnets": {
      "value": [
        {
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/container-instance/container-group:<version>'

// Required parameters
param availabilityZone = -1
param containers = [
  {
    name: 'az-aci-x-001'
    properties: {
      command: []
      environmentVariables: []
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '4'
        }
      }
    }
  }
  {
    name: 'az-aci-x-002'
    properties: {
      command: []
      environmentVariables: []
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 8080
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
]
param name = 'cicgprivate001'
// Non-required parameters
param ipAddress = {
  ports: [
    {
      port: 80
      protocol: 'Tcp'
    }
    {
      port: 443
      protocol: 'Tcp'
    }
    {
      port: 8080
      protocol: 'Tcp'
    }
  ]
  type: 'Private'
}
param subnets = [
  {
    subnetResourceId: '<subnetResourceId>'
  }
]
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
    availabilityZone: 1
    containers: [
      {
        name: 'az-aci-x-001'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 80
              protocol: 'Tcp'
            }
            {
              port: 443
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
      {
        name: 'az-aci-x-002'
        properties: {
          command: []
          environmentVariables: []
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: [
            {
              port: 8080
              protocol: 'Tcp'
            }
          ]
          resources: {
            requests: {
              cpu: 2
              memoryInGB: '2'
            }
          }
        }
      }
    ]
    name: 'cicgwaf001'
    // Non-required parameters
    ipAddress: {
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
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
    "availabilityZone": {
      "value": 1
    },
    "containers": {
      "value": [
        {
          "name": "az-aci-x-001",
          "properties": {
            "command": [],
            "environmentVariables": [],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 80,
                "protocol": "Tcp"
              },
              {
                "port": 443,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        },
        {
          "name": "az-aci-x-002",
          "properties": {
            "command": [],
            "environmentVariables": [],
            "image": "mcr.microsoft.com/azuredocs/aci-helloworld",
            "ports": [
              {
                "port": 8080,
                "protocol": "Tcp"
              }
            ],
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": "2"
              }
            }
          }
        }
      ]
    },
    "name": {
      "value": "cicgwaf001"
    },
    // Non-required parameters
    "ipAddress": {
      "value": {
        "ports": [
          {
            "port": 80,
            "protocol": "Tcp"
          },
          {
            "port": 443,
            "protocol": "Tcp"
          }
        ]
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
using 'br/public:avm/res/container-instance/container-group:<version>'

// Required parameters
param availabilityZone = 1
param containers = [
  {
    name: 'az-aci-x-001'
    properties: {
      command: []
      environmentVariables: []
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 80
          protocol: 'Tcp'
        }
        {
          port: 443
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
  {
    name: 'az-aci-x-002'
    properties: {
      command: []
      environmentVariables: []
      image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
      ports: [
        {
          port: 8080
          protocol: 'Tcp'
        }
      ]
      resources: {
        requests: {
          cpu: 2
          memoryInGB: '2'
        }
      }
    }
  }
]
param name = 'cicgwaf001'
// Non-required parameters
param ipAddress = {
  ports: [
    {
      port: 80
      protocol: 'Tcp'
    }
    {
      port: 443
      protocol: 'Tcp'
    }
  ]
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
| [`availabilityZone`](#parameter-availabilityzone) | int | If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |
| [`containers`](#parameter-containers) | array | The containers and their respective config within the container group. |
| [`name`](#parameter-name) | string | Name for the container group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`dnsConfig`](#parameter-dnsconfig) | object | The DNS config information for a container group. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`imageRegistryCredentials`](#parameter-imageregistrycredentials) | array | The image registry credentials by which the container group is created from. |
| [`initContainers`](#parameter-initcontainers) | array | A list of container definitions which will be executed before the application container starts. |
| [`ipAddress`](#parameter-ipaddress) | object | The IP address type of the container group. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`logAnalytics`](#parameter-loganalytics) | object | The log analytics diagnostic information for a container group. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`osType`](#parameter-ostype) | string | The operating system type required by the containers in the container group. - Windows or Linux. |
| [`priority`](#parameter-priority) | string | The priority of the container group. |
| [`restartPolicy`](#parameter-restartpolicy) | string | Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never. |
| [`sku`](#parameter-sku) | string | The container group SKU. |
| [`subnets`](#parameter-subnets) | array | The subnets to use by the container group. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`volumes`](#parameter-volumes) | array | Specify if volumes (emptyDir, AzureFileShare or GitRepo) shall be attached to your containergroup. |

### Parameter: `availabilityZone`

If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).

- Required: Yes
- Type: int
- Allowed:
  ```Bicep
  [
    -1
    1
    2
    3
  ]
  ```

### Parameter: `containers`

The containers and their respective config within the container group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containersname) | string | The name of the container instance. |
| [`properties`](#parameter-containersproperties) | object | The properties of the container instance. |

### Parameter: `containers.name`

The name of the container instance.

- Required: Yes
- Type: string

### Parameter: `containers.properties`

The properties of the container instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`image`](#parameter-containerspropertiesimage) | string | The name of the container source image. |
| [`resources`](#parameter-containerspropertiesresources) | object | The resource requirements of the container instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`command`](#parameter-containerspropertiescommand) | array | The command to execute within the container instance. |
| [`environmentVariables`](#parameter-containerspropertiesenvironmentvariables) | array | The environment variables to set in the container instance. |
| [`livenessProbe`](#parameter-containerspropertieslivenessprobe) | object | The liveness probe. |
| [`ports`](#parameter-containerspropertiesports) | array | The exposed ports on the container instance. |
| [`readinessProbe`](#parameter-containerspropertiesreadinessprobe) | object | The readiness probe. |
| [`securityContext`](#parameter-containerspropertiessecuritycontext) | object | The security context of the container instance. |
| [`volumeMounts`](#parameter-containerspropertiesvolumemounts) | array | The volume mounts within the container instance. |

### Parameter: `containers.properties.image`

The name of the container source image.

- Required: Yes
- Type: string

### Parameter: `containers.properties.resources`

The resource requirements of the container instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`requests`](#parameter-containerspropertiesresourcesrequests) | object | The resource requests of this container instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`limits`](#parameter-containerspropertiesresourceslimits) | object | The resource limits of this container instance. |

### Parameter: `containers.properties.resources.requests`

The resource requests of this container instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-containerspropertiesresourcesrequestscpu) | int | The CPU request of this container instance. |
| [`memoryInGB`](#parameter-containerspropertiesresourcesrequestsmemoryingb) | string | The memory request in GB of this container instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gpu`](#parameter-containerspropertiesresourcesrequestsgpu) | object | The GPU request of this container instance. |

### Parameter: `containers.properties.resources.requests.cpu`

The CPU request of this container instance.

- Required: Yes
- Type: int

### Parameter: `containers.properties.resources.requests.memoryInGB`

The memory request in GB of this container instance.

- Required: Yes
- Type: string

### Parameter: `containers.properties.resources.requests.gpu`

The GPU request of this container instance.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-containerspropertiesresourcesrequestsgpucount) | int | The count of the GPU resource. |
| [`sku`](#parameter-containerspropertiesresourcesrequestsgpusku) | string | The SKU of the GPU resource. |

### Parameter: `containers.properties.resources.requests.gpu.count`

The count of the GPU resource.

- Required: Yes
- Type: int

### Parameter: `containers.properties.resources.requests.gpu.sku`

The SKU of the GPU resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'K80'
    'P100'
    'V100'
  ]
  ```

### Parameter: `containers.properties.resources.limits`

The resource limits of this container instance.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-containerspropertiesresourceslimitscpu) | int | The CPU limit of this container instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gpu`](#parameter-containerspropertiesresourceslimitsgpu) | object | The GPU limit of this container instance. |
| [`memoryInGB`](#parameter-containerspropertiesresourceslimitsmemoryingb) | string | The memory limit in GB of this container instance. |

### Parameter: `containers.properties.resources.limits.cpu`

The CPU limit of this container instance.

- Required: Yes
- Type: int

### Parameter: `containers.properties.resources.limits.gpu`

The GPU limit of this container instance.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-containerspropertiesresourceslimitsgpucount) | int | The count of the GPU resource. |
| [`sku`](#parameter-containerspropertiesresourceslimitsgpusku) | string | The SKU of the GPU resource. |

### Parameter: `containers.properties.resources.limits.gpu.count`

The count of the GPU resource.

- Required: Yes
- Type: int

### Parameter: `containers.properties.resources.limits.gpu.sku`

The SKU of the GPU resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'K80'
    'P100'
    'V100'
  ]
  ```

### Parameter: `containers.properties.resources.limits.memoryInGB`

The memory limit in GB of this container instance.

- Required: No
- Type: string

### Parameter: `containers.properties.command`

The command to execute within the container instance.

- Required: No
- Type: array

### Parameter: `containers.properties.environmentVariables`

The environment variables to set in the container instance.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containerspropertiesenvironmentvariablesname) | string | The name of the environment variable. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secureValue`](#parameter-containerspropertiesenvironmentvariablessecurevalue) | securestring | The value of the secure environment variable. |
| [`value`](#parameter-containerspropertiesenvironmentvariablesvalue) | string | The value of the environment variable. |

### Parameter: `containers.properties.environmentVariables.name`

The name of the environment variable.

- Required: Yes
- Type: string

### Parameter: `containers.properties.environmentVariables.secureValue`

The value of the secure environment variable.

- Required: No
- Type: securestring

### Parameter: `containers.properties.environmentVariables.value`

The value of the environment variable.

- Required: No
- Type: string

### Parameter: `containers.properties.livenessProbe`

The liveness probe.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exec`](#parameter-containerspropertieslivenessprobeexec) | object | The execution command to probe. |
| [`failureThreshold`](#parameter-containerspropertieslivenessprobefailurethreshold) | int | The failure threshold. |
| [`httpGet`](#parameter-containerspropertieslivenessprobehttpget) | object | The HTTP request to perform. |
| [`initialDelaySeconds`](#parameter-containerspropertieslivenessprobeinitialdelayseconds) | int | The initial delay seconds. |
| [`periodSeconds`](#parameter-containerspropertieslivenessprobeperiodseconds) | int | The period seconds. |
| [`successThreshold`](#parameter-containerspropertieslivenessprobesuccessthreshold) | int | The success threshold. |
| [`timeoutSeconds`](#parameter-containerspropertieslivenessprobetimeoutseconds) | int | The timeout seconds. |

### Parameter: `containers.properties.livenessProbe.exec`

The execution command to probe.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`command`](#parameter-containerspropertieslivenessprobeexeccommand) | array | The commands to execute within the container. |

### Parameter: `containers.properties.livenessProbe.exec.command`

The commands to execute within the container.

- Required: Yes
- Type: array

### Parameter: `containers.properties.livenessProbe.failureThreshold`

The failure threshold.

- Required: No
- Type: int

### Parameter: `containers.properties.livenessProbe.httpGet`

The HTTP request to perform.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-containerspropertieslivenessprobehttpgetport) | int | The port number to probe. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpHeaders`](#parameter-containerspropertieslivenessprobehttpgethttpheaders) | array | The HTTP headers. |
| [`path`](#parameter-containerspropertieslivenessprobehttpgetpath) | string | The path to probe. |
| [`scheme`](#parameter-containerspropertieslivenessprobehttpgetscheme) | string | The scheme. |

### Parameter: `containers.properties.livenessProbe.httpGet.port`

The port number to probe.

- Required: Yes
- Type: int

### Parameter: `containers.properties.livenessProbe.httpGet.httpHeaders`

The HTTP headers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containerspropertieslivenessprobehttpgethttpheadersname) | string | The name of the header. |
| [`value`](#parameter-containerspropertieslivenessprobehttpgethttpheadersvalue) | string | The value of the header. |

### Parameter: `containers.properties.livenessProbe.httpGet.httpHeaders.name`

The name of the header.

- Required: Yes
- Type: string

### Parameter: `containers.properties.livenessProbe.httpGet.httpHeaders.value`

The value of the header.

- Required: Yes
- Type: string

### Parameter: `containers.properties.livenessProbe.httpGet.path`

The path to probe.

- Required: No
- Type: string

### Parameter: `containers.properties.livenessProbe.httpGet.scheme`

The scheme.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'HTTP'
    'HTTPS'
  ]
  ```

### Parameter: `containers.properties.livenessProbe.initialDelaySeconds`

The initial delay seconds.

- Required: No
- Type: int

### Parameter: `containers.properties.livenessProbe.periodSeconds`

The period seconds.

- Required: No
- Type: int

### Parameter: `containers.properties.livenessProbe.successThreshold`

The success threshold.

- Required: No
- Type: int

### Parameter: `containers.properties.livenessProbe.timeoutSeconds`

The timeout seconds.

- Required: No
- Type: int

### Parameter: `containers.properties.ports`

The exposed ports on the container instance.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-containerspropertiesportsport) | int | The port number exposed on the container instance. |
| [`protocol`](#parameter-containerspropertiesportsprotocol) | string | The protocol associated with the port number. |

### Parameter: `containers.properties.ports.port`

The port number exposed on the container instance.

- Required: Yes
- Type: int

### Parameter: `containers.properties.ports.protocol`

The protocol associated with the port number.

- Required: Yes
- Type: string

### Parameter: `containers.properties.readinessProbe`

The readiness probe.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exec`](#parameter-containerspropertiesreadinessprobeexec) | object | The execution command to probe. |
| [`failureThreshold`](#parameter-containerspropertiesreadinessprobefailurethreshold) | int | The failure threshold. |
| [`httpGet`](#parameter-containerspropertiesreadinessprobehttpget) | object | The HTTP request to perform. |
| [`initialDelaySeconds`](#parameter-containerspropertiesreadinessprobeinitialdelayseconds) | int | The initial delay seconds. |
| [`periodSeconds`](#parameter-containerspropertiesreadinessprobeperiodseconds) | int | The period seconds. |
| [`successThreshold`](#parameter-containerspropertiesreadinessprobesuccessthreshold) | int | The success threshold. |
| [`timeoutSeconds`](#parameter-containerspropertiesreadinessprobetimeoutseconds) | int | The timeout seconds. |

### Parameter: `containers.properties.readinessProbe.exec`

The execution command to probe.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`command`](#parameter-containerspropertiesreadinessprobeexeccommand) | array | The commands to execute within the container. |

### Parameter: `containers.properties.readinessProbe.exec.command`

The commands to execute within the container.

- Required: Yes
- Type: array

### Parameter: `containers.properties.readinessProbe.failureThreshold`

The failure threshold.

- Required: No
- Type: int

### Parameter: `containers.properties.readinessProbe.httpGet`

The HTTP request to perform.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-containerspropertiesreadinessprobehttpgetport) | int | The port number to probe. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpHeaders`](#parameter-containerspropertiesreadinessprobehttpgethttpheaders) | array | The HTTP headers. |
| [`path`](#parameter-containerspropertiesreadinessprobehttpgetpath) | string | The path to probe. |
| [`scheme`](#parameter-containerspropertiesreadinessprobehttpgetscheme) | string | The scheme. |

### Parameter: `containers.properties.readinessProbe.httpGet.port`

The port number to probe.

- Required: Yes
- Type: int

### Parameter: `containers.properties.readinessProbe.httpGet.httpHeaders`

The HTTP headers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containerspropertiesreadinessprobehttpgethttpheadersname) | string | The name of the header. |
| [`value`](#parameter-containerspropertiesreadinessprobehttpgethttpheadersvalue) | string | The value of the header. |

### Parameter: `containers.properties.readinessProbe.httpGet.httpHeaders.name`

The name of the header.

- Required: Yes
- Type: string

### Parameter: `containers.properties.readinessProbe.httpGet.httpHeaders.value`

The value of the header.

- Required: Yes
- Type: string

### Parameter: `containers.properties.readinessProbe.httpGet.path`

The path to probe.

- Required: No
- Type: string

### Parameter: `containers.properties.readinessProbe.httpGet.scheme`

The scheme.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'HTTP'
    'HTTPS'
  ]
  ```

### Parameter: `containers.properties.readinessProbe.initialDelaySeconds`

The initial delay seconds.

- Required: No
- Type: int

### Parameter: `containers.properties.readinessProbe.periodSeconds`

The period seconds.

- Required: No
- Type: int

### Parameter: `containers.properties.readinessProbe.successThreshold`

The success threshold.

- Required: No
- Type: int

### Parameter: `containers.properties.readinessProbe.timeoutSeconds`

The timeout seconds.

- Required: No
- Type: int

### Parameter: `containers.properties.securityContext`

The security context of the container instance.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowPrivilegeEscalation`](#parameter-containerspropertiessecuritycontextallowprivilegeescalation) | bool | Whether privilege escalation is allowed for the container. |
| [`capabilities`](#parameter-containerspropertiessecuritycontextcapabilities) | object | The capabilities to add or drop for the container. |
| [`privileged`](#parameter-containerspropertiessecuritycontextprivileged) | bool | Whether the container is run in privileged mode. |
| [`runAsGroup`](#parameter-containerspropertiessecuritycontextrunasgroup) | int | The GID to run the container as. |
| [`runAsUser`](#parameter-containerspropertiessecuritycontextrunasuser) | int | The UID to run the container as. |
| [`seccompProfile`](#parameter-containerspropertiessecuritycontextseccompprofile) | string | The seccomp profile to use for the container. |

### Parameter: `containers.properties.securityContext.allowPrivilegeEscalation`

Whether privilege escalation is allowed for the container.

- Required: No
- Type: bool

### Parameter: `containers.properties.securityContext.capabilities`

The capabilities to add or drop for the container.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`add`](#parameter-containerspropertiessecuritycontextcapabilitiesadd) | array | The list of capabilities to add. |
| [`drop`](#parameter-containerspropertiessecuritycontextcapabilitiesdrop) | array | The list of capabilities to drop. |

### Parameter: `containers.properties.securityContext.capabilities.add`

The list of capabilities to add.

- Required: No
- Type: array

### Parameter: `containers.properties.securityContext.capabilities.drop`

The list of capabilities to drop.

- Required: No
- Type: array

### Parameter: `containers.properties.securityContext.privileged`

Whether the container is run in privileged mode.

- Required: No
- Type: bool

### Parameter: `containers.properties.securityContext.runAsGroup`

The GID to run the container as.

- Required: No
- Type: int

### Parameter: `containers.properties.securityContext.runAsUser`

The UID to run the container as.

- Required: No
- Type: int

### Parameter: `containers.properties.securityContext.seccompProfile`

The seccomp profile to use for the container.

- Required: No
- Type: string

### Parameter: `containers.properties.volumeMounts`

The volume mounts within the container instance.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mountPath`](#parameter-containerspropertiesvolumemountsmountpath) | string | The path within the container where the volume should be mounted. Must not contain colon (:). |
| [`name`](#parameter-containerspropertiesvolumemountsname) | string | The name of the volume mount. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`readOnly`](#parameter-containerspropertiesvolumemountsreadonly) | bool | The flag indicating whether the volume mount is read-only. |

### Parameter: `containers.properties.volumeMounts.mountPath`

The path within the container where the volume should be mounted. Must not contain colon (:).

- Required: Yes
- Type: string

### Parameter: `containers.properties.volumeMounts.name`

The name of the volume mount.

- Required: Yes
- Type: string

### Parameter: `containers.properties.volumeMounts.readOnly`

The flag indicating whether the volume mount is read-only.

- Required: No
- Type: bool

### Parameter: `name`

Name for the container group.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-customermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-customermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-customermanagedkeyautorotationenabled) | bool | Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used. |
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.autoRotationEnabled`

Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.

- Required: No
- Type: bool

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using version as per 'autoRotationEnabled' setting.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `dnsConfig`

The DNS config information for a container group.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nameServers`](#parameter-dnsconfignameservers) | array | 	The DNS servers for the container group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`options`](#parameter-dnsconfigoptions) | string | The DNS options for the container group. |
| [`searchDomains`](#parameter-dnsconfigsearchdomains) | string | The DNS search domains for hostname lookup in the container group. |

### Parameter: `dnsConfig.nameServers`

	The DNS servers for the container group.

- Required: Yes
- Type: array

### Parameter: `dnsConfig.options`

The DNS options for the container group.

- Required: No
- Type: string

### Parameter: `dnsConfig.searchDomains`

The DNS search domains for hostname lookup in the container group.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `imageRegistryCredentials`

The image registry credentials by which the container group is created from.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`server`](#parameter-imageregistrycredentialsserver) | string | The Docker image registry server without a protocol such as "http" and "https". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-imageregistrycredentialsidentity) | string | The identity for the private registry. |
| [`identityUrl`](#parameter-imageregistrycredentialsidentityurl) | string | The identity URL for the private registry. |
| [`password`](#parameter-imageregistrycredentialspassword) | securestring | The password for the private registry. |
| [`username`](#parameter-imageregistrycredentialsusername) | string | The username for the private registry. |

### Parameter: `imageRegistryCredentials.server`

The Docker image registry server without a protocol such as "http" and "https".

- Required: Yes
- Type: string

### Parameter: `imageRegistryCredentials.identity`

The identity for the private registry.

- Required: No
- Type: string

### Parameter: `imageRegistryCredentials.identityUrl`

The identity URL for the private registry.

- Required: No
- Type: string

### Parameter: `imageRegistryCredentials.password`

The password for the private registry.

- Required: No
- Type: securestring

### Parameter: `imageRegistryCredentials.username`

The username for the private registry.

- Required: No
- Type: string

### Parameter: `initContainers`

A list of container definitions which will be executed before the application container starts.

- Required: No
- Type: array

### Parameter: `ipAddress`

The IP address type of the container group.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ports`](#parameter-ipaddressports) | array | The list of ports exposed on the container group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoGeneratedDomainNameLabelScope`](#parameter-ipaddressautogenerateddomainnamelabelscope) | string | The value representing the security enum. |
| [`dnsNameLabel`](#parameter-ipaddressdnsnamelabel) | string | The Dns name label for the IP. |
| [`ip`](#parameter-ipaddressip) | string | The IP exposed to the public internet. |
| [`type`](#parameter-ipaddresstype) | string | Specifies if the IP is exposed to the public internet or private VNET. |

### Parameter: `ipAddress.ports`

The list of ports exposed on the container group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-ipaddressportsport) | int | The port number exposed on the container instance. |
| [`protocol`](#parameter-ipaddressportsprotocol) | string | The protocol associated with the port number. |

### Parameter: `ipAddress.ports.port`

The port number exposed on the container instance.

- Required: Yes
- Type: int

### Parameter: `ipAddress.ports.protocol`

The protocol associated with the port number.

- Required: Yes
- Type: string

### Parameter: `ipAddress.autoGeneratedDomainNameLabelScope`

The value representing the security enum.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Noreuse'
    'ResourceGroupReuse'
    'SubscriptionReuse'
    'TenantReuse'
    'Unsecure'
  ]
  ```

### Parameter: `ipAddress.dnsNameLabel`

The Dns name label for the IP.

- Required: No
- Type: string

### Parameter: `ipAddress.ip`

The IP exposed to the public internet.

- Required: No
- Type: string

### Parameter: `ipAddress.type`

Specifies if the IP is exposed to the public internet or private VNET.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Private'
    'Public'
  ]
  ```

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

### Parameter: `logAnalytics`

The log analytics diagnostic information for a container group.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logType`](#parameter-loganalyticslogtype) | string | The log type to be used. |
| [`workspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | The workspace resource ID for log analytics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-loganalyticsmetadata) | object | Metadata for log analytics. |

### Parameter: `logAnalytics.logType`

The log type to be used.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ContainerInsights'
    'ContainerInstanceLogs'
  ]
  ```

### Parameter: `logAnalytics.workspaceResourceId`

The workspace resource ID for log analytics.

- Required: Yes
- Type: string

### Parameter: `logAnalytics.metadata`

Metadata for log analytics.

- Required: No
- Type: object

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `osType`

The operating system type required by the containers in the container group. - Windows or Linux.

- Required: No
- Type: string
- Default: `'Linux'`

### Parameter: `priority`

The priority of the container group.

- Required: No
- Type: string
- Default: `'Regular'`
- Allowed:
  ```Bicep
  [
    'Regular'
    'Spot'
  ]
  ```

### Parameter: `restartPolicy`

Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never.

- Required: No
- Type: string
- Default: `'Always'`
- Allowed:
  ```Bicep
  [
    'Always'
    'Never'
    'OnFailure'
  ]
  ```

### Parameter: `sku`

The container group SKU.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Dedicated'
    'Standard'
  ]
  ```

### Parameter: `subnets`

The subnets to use by the container group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-subnetssubnetresourceid) | string | Resource ID of virtual network and subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-subnetsname) | string | Friendly name for the subnet. |

### Parameter: `subnets.subnetResourceId`

Resource ID of virtual network and subnet.

- Required: Yes
- Type: string

### Parameter: `subnets.name`

Friendly name for the subnet.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `volumes`

Specify if volumes (emptyDir, AzureFileShare or GitRepo) shall be attached to your containergroup.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `iPv4Address` | string | The IPv4 address of the container group. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the container group. |
| `resourceGroupName` | string | The resource group the container group was deployed into. |
| `resourceId` | string | The resource ID of the container group. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
