# Container Instances Container Groups `[Microsoft.ContainerInstance/containerGroups]`

This module deploys a Container Instance Container Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
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
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Using private network](#example-4-using-private-network)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
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
              memoryInGB: 2
            }
          }
        }
      }
    ]
    ipAddressPorts: [
      {
        port: 443
        protocol: 'Tcp'
      }
    ]
    name: 'cicgmin001'
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
                "memoryInGB": 2
              }
            }
          }
        }
      ]
    },
    "ipAddressPorts": {
      "value": [
        {
          "port": 443,
          "protocol": "Tcp"
        }
      ]
    },
    "name": {
      "value": "cicgmin001"
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

### Example 2: _Using CMK _

This instance deploys the module with a customer-managed key (CMK).


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
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
              memoryInGB: 2
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
              memoryInGB: 2
            }
          }
        }
      }
    ]
    ipAddressPorts: [
      {
        port: 80
        protocol: 'Tcp'
      }
      {
        port: 443
        protocol: 'Tcp'
      }
    ]
    name: 'cicgencr001'
    // Non-required parameters
    customerManagedKey: {
      keyName: '<keyName>'
      keyVaultResourceId: '<keyVaultResourceId>'
      userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
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
                "memoryInGB": 2
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
                "memoryInGB": 2
              }
            }
          }
        }
      ]
    },
    "ipAddressPorts": {
      "value": [
        {
          "port": 80,
          "protocol": "Tcp"
        },
        {
          "port": 443,
          "protocol": "Tcp"
        }
      ]
    },
    "name": {
      "value": "cicgencr001"
    },
    // Non-required parameters
    "customerManagedKey": {
      "value": {
        "keyName": "<keyName>",
        "keyVaultResourceId": "<keyVaultResourceId>",
        "userAssignedIdentityResourceId": "<userAssignedIdentityResourceId>"
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
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
    containers: [
      {
        name: 'az-aci-x-001'
        properties: {
          command: []
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
          resources: {
            requests: {
              cpu: 2
              memoryInGB: 2
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
              memoryInGB: 2
            }
          }
        }
      }
    ]
    ipAddressPorts: [
      {
        port: 80
        protocol: 'Tcp'
      }
      {
        port: 443
        protocol: 'Tcp'
      }
    ]
    name: 'cicgmax001'
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
          "name": "az-aci-x-001",
          "properties": {
            "command": [],
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
            "resources": {
              "requests": {
                "cpu": 2,
                "memoryInGB": 2
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
                "memoryInGB": 2
              }
            }
          }
        }
      ]
    },
    "ipAddressPorts": {
      "value": [
        {
          "port": 80,
          "protocol": "Tcp"
        },
        {
          "port": 443,
          "protocol": "Tcp"
        }
      ]
    },
    "name": {
      "value": "cicgmax001"
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

### Example 4: _Using private network_

This instance deploys the module within a virtual network.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
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
              memoryInGB: 4
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
              memoryInGB: 2
            }
          }
        }
      }
    ]
    ipAddressPorts: [
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
    name: 'cicgprivate001'
    // Non-required parameters
    ipAddressType: 'Private'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    subnetId: '<subnetId>'
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
                "memoryInGB": 4
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
                "memoryInGB": 2
              }
            }
          }
        }
      ]
    },
    "ipAddressPorts": {
      "value": [
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
      ]
    },
    "name": {
      "value": "cicgprivate001"
    },
    // Non-required parameters
    "ipAddressType": {
      "value": "Private"
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
    "subnetId": {
      "value": "<subnetId>"
    }
  }
}
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module containerGroup 'br/public:avm/res/container-instance/container-group:<version>' = {
  name: 'containerGroupDeployment'
  params: {
    // Required parameters
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
              memoryInGB: 2
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
              memoryInGB: 2
            }
          }
        }
      }
    ]
    ipAddressPorts: [
      {
        port: 80
        protocol: 'Tcp'
      }
      {
        port: 443
        protocol: 'Tcp'
      }
    ]
    name: 'cicgwaf001'
    // Non-required parameters
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
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
                "memoryInGB": 2
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
                "memoryInGB": 2
              }
            }
          }
        }
      ]
    },
    "ipAddressPorts": {
      "value": [
        {
          "port": 80,
          "protocol": "Tcp"
        },
        {
          "port": 443,
          "protocol": "Tcp"
        }
      ]
    },
    "name": {
      "value": "cicgwaf001"
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

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containers`](#parameter-containers) | array | The containers and their respective config within the container group. |
| [`name`](#parameter-name) | string | Name for the container group. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddressPorts`](#parameter-ipaddressports) | array | Ports to open on the public IP address. Must include all ports assigned on container level. Required if `ipAddressType` is set to `public`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoGeneratedDomainNameLabelScope`](#parameter-autogenerateddomainnamelabelscope) | string | Specify level of protection of the domain name label. |
| [`customerManagedKey`](#parameter-customermanagedkey) | object | The customer managed key definition. |
| [`dnsNameLabel`](#parameter-dnsnamelabel) | string | The Dns name label for the resource. |
| [`dnsNameServers`](#parameter-dnsnameservers) | array | List of dns servers used by the containers for lookups. |
| [`dnsSearchDomains`](#parameter-dnssearchdomains) | string | DNS search domain which will be appended to each DNS lookup. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`imageRegistryCredentials`](#parameter-imageregistrycredentials) | array | The image registry credentials by which the container group is created from. |
| [`initContainers`](#parameter-initcontainers) | array | A list of container definitions which will be executed before the application container starts. |
| [`ipAddressType`](#parameter-ipaddresstype) | string | Specifies if the IP is exposed to the public internet or private VNET. - Public or Private. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`osType`](#parameter-ostype) | string | The operating system type required by the containers in the container group. - Windows or Linux. |
| [`restartPolicy`](#parameter-restartpolicy) | string | Restart policy for all containers within the container group. - Always: Always restart. OnFailure: Restart on failure. Never: Never restart. - Always, OnFailure, Never. |
| [`sku`](#parameter-sku) | string | The container group SKU. |
| [`subnetId`](#parameter-subnetid) | string | Resource ID of the subnet. Only specify when ipAddressType is Private. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`volumes`](#parameter-volumes) | array | Specify if volumes (emptyDir, AzureFileShare or GitRepo) shall be attached to your containergroup. |

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
| [`securityContext`](#parameter-containerspropertiesresourcessecuritycontext) | object | The security context of the container instance. |

### Parameter: `containers.properties.resources.requests`

The resource requests of this container instance.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-containerspropertiesresourcesrequestscpu) | int | The CPU request of this container instance. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gpu`](#parameter-containerspropertiesresourcesrequestsgpu) | object | The GPU request of this container instance. |
| [`memoryInGB`](#parameter-containerspropertiesresourcesrequestsmemoryingb) | int | The memory request in GB of this container instance. To specify a decimal value, use the json() function. |

### Parameter: `containers.properties.resources.requests.cpu`

The CPU request of this container instance.

- Required: Yes
- Type: int

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

### Parameter: `containers.properties.resources.requests.memoryInGB`

The memory request in GB of this container instance. To specify a decimal value, use the json() function.

- Required: No
- Type: int

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
| [`memoryInGB`](#parameter-containerspropertiesresourceslimitsmemoryingb) | int | The memory limit in GB of this container instance. To specify a decimal value, use the json() function. |

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

The memory limit in GB of this container instance. To specify a decimal value, use the json() function.

- Required: No
- Type: int

### Parameter: `containers.properties.resources.securityContext`

The security context of the container instance.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowPrivilegeEscalation`](#parameter-containerspropertiesresourcessecuritycontextallowprivilegeescalation) | bool | Whether privilege escalation is allowed for the container. |
| [`capabilities`](#parameter-containerspropertiesresourcessecuritycontextcapabilities) | object | The capabilities to add or drop for the container. |
| [`privileged`](#parameter-containerspropertiesresourcessecuritycontextprivileged) | bool | Whether the container is run in privileged mode. |
| [`runAsGroup`](#parameter-containerspropertiesresourcessecuritycontextrunasgroup) | int | The GID to run the container as. |
| [`runAsUser`](#parameter-containerspropertiesresourcessecuritycontextrunasuser) | int | The UID to run the container as. |
| [`seccompProfile`](#parameter-containerspropertiesresourcessecuritycontextseccompprofile) | string | The seccomp profile to use for the container. |

### Parameter: `containers.properties.resources.securityContext.allowPrivilegeEscalation`

Whether privilege escalation is allowed for the container.

- Required: No
- Type: bool

### Parameter: `containers.properties.resources.securityContext.capabilities`

The capabilities to add or drop for the container.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`add`](#parameter-containerspropertiesresourcessecuritycontextcapabilitiesadd) | array | The list of capabilities to add. |
| [`drop`](#parameter-containerspropertiesresourcessecuritycontextcapabilitiesdrop) | array | The list of capabilities to drop. |

### Parameter: `containers.properties.resources.securityContext.capabilities.add`

The list of capabilities to add.

- Required: No
- Type: array

### Parameter: `containers.properties.resources.securityContext.capabilities.drop`

The list of capabilities to drop.

- Required: No
- Type: array

### Parameter: `containers.properties.resources.securityContext.privileged`

Whether the container is run in privileged mode.

- Required: No
- Type: bool

### Parameter: `containers.properties.resources.securityContext.runAsGroup`

The GID to run the container as.

- Required: No
- Type: int

### Parameter: `containers.properties.resources.securityContext.runAsUser`

The UID to run the container as.

- Required: No
- Type: int

### Parameter: `containers.properties.resources.securityContext.seccompProfile`

The seccomp profile to use for the container.

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

### Parameter: `ipAddressPorts`

Ports to open on the public IP address. Must include all ports assigned on container level. Required if `ipAddressType` is set to `public`.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-ipaddressportsport) | int | The port number exposed on the container instance. |
| [`protocol`](#parameter-ipaddressportsprotocol) | string | The protocol associated with the port number. |

### Parameter: `ipAddressPorts.port`

The port number exposed on the container instance.

- Required: Yes
- Type: int

### Parameter: `ipAddressPorts.protocol`

The protocol associated with the port number.

- Required: Yes
- Type: string

### Parameter: `autoGeneratedDomainNameLabelScope`

Specify level of protection of the domain name label.

- Required: No
- Type: string
- Default: `'TenantReuse'`
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
| [`keyVersion`](#parameter-customermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
| [`userAssignedIdentityResourceId`](#parameter-customermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `dnsNameLabel`

The Dns name label for the resource.

- Required: No
- Type: string

### Parameter: `dnsNameServers`

List of dns servers used by the containers for lookups.

- Required: No
- Type: array

### Parameter: `dnsSearchDomains`

DNS search domain which will be appended to each DNS lookup.

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

### Parameter: `ipAddressType`

Specifies if the IP is exposed to the public internet or private VNET. - Public or Private.

- Required: No
- Type: string
- Default: `'Public'`
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

### Parameter: `osType`

The operating system type required by the containers in the container group. - Windows or Linux.

- Required: No
- Type: string
- Default: `'Linux'`

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

### Parameter: `subnetId`

Resource ID of the subnet. Only specify when ipAddressType is Private.

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
