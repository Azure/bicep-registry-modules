# Azure Compute Galleries `[Microsoft.Compute/galleries]`

This module deploys an Azure Compute Gallery (formerly known as Shared Image Gallery).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Compute/galleries` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries) |
| `Microsoft.Compute/galleries/applications` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/applications) |
| `Microsoft.Compute/galleries/images` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/images) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/compute.gallery:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module gallery 'br:bicep/modules/compute.gallery:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cgmin'
  params: {
    // Required parameters
    name: 'cgmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "name": {
      "value": "cgmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
module gallery 'br:bicep/modules/compute.gallery:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cgmax'
  params: {
    // Required parameters
    name: 'cgmax001'
    // Non-required parameters
    applications: [
      {
        name: 'cgmax-appd-001'
      }
      {
        name: 'cgmax-appd-002'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        supportedOSType: 'Windows'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    images: [
      {
        name: 'az-imgd-ws-001'
      }
      {
        hyperVGeneration: 'V1'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-002'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition'
      }
      {
        hyperVGeneration: 'V2'
        isHibernateSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-003'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-hibernate'
      }
      {
        hyperVGeneration: 'V2'
        isAcceleratedNetworkSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-004'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-accnet'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-wdtl-002'
        offer: 'WindowsDesktop'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsDesktop'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        securityType: 'TrustedLaunch'
        sku: 'Win11-21H2'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 32
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 1
        name: 'az-imgd-us-001'
        offer: '0001-com-ubuntu-server-focal'
        osState: 'Generalized'
        osType: 'Linux'
        publisher: 'canonical'
        sku: '20_04-lts-gen2'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
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
    "name": {
      "value": "cgmax001"
    },
    // Non-required parameters
    "applications": {
      "value": [
        {
          "name": "cgmax-appd-001"
        },
        {
          "name": "cgmax-appd-002",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "supportedOSType": "Windows"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "images": {
      "value": [
        {
          "name": "az-imgd-ws-001"
        },
        {
          "hyperVGeneration": "V1",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-002",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition"
        },
        {
          "hyperVGeneration": "V2",
          "isHibernateSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-003",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-hibernate"
        },
        {
          "hyperVGeneration": "V2",
          "isAcceleratedNetworkSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-004",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-accnet"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-wdtl-002",
          "offer": "WindowsDesktop",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsDesktop",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "securityType": "TrustedLaunch",
          "sku": "Win11-21H2"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 32,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 1,
          "name": "az-imgd-us-001",
          "offer": "0001-com-ubuntu-server-focal",
          "osState": "Generalized",
          "osType": "Linux",
          "publisher": "canonical",
          "sku": "20_04-lts-gen2"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module gallery 'br:bicep/modules/compute.gallery:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cgwaf'
  params: {
    // Required parameters
    name: 'cgwaf001'
    // Non-required parameters
    applications: [
      {
        name: 'cgwaf-appd-001'
      }
      {
        name: 'cgwaf-appd-002'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        supportedOSType: 'Windows'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    images: [
      {
        name: 'az-imgd-ws-001'
      }
      {
        hyperVGeneration: 'V1'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-002'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition'
      }
      {
        hyperVGeneration: 'V2'
        isHibernateSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-003'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-hibernate'
      }
      {
        hyperVGeneration: 'V2'
        isAcceleratedNetworkSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-ws-004'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        sku: '2022-datacenter-azure-edition-accnet'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: 'az-imgd-wdtl-002'
        offer: 'WindowsDesktop'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsDesktop'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        securityType: 'TrustedLaunch'
        sku: 'Win11-21H2'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 32
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 1
        name: 'az-imgd-us-001'
        offer: '0001-com-ubuntu-server-focal'
        osState: 'Generalized'
        osType: 'Linux'
        publisher: 'canonical'
        sku: '20_04-lts-gen2'
      }
    ]
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
    "name": {
      "value": "cgwaf001"
    },
    // Non-required parameters
    "applications": {
      "value": [
        {
          "name": "cgwaf-appd-001"
        },
        {
          "name": "cgwaf-appd-002",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "supportedOSType": "Windows"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "images": {
      "value": [
        {
          "name": "az-imgd-ws-001"
        },
        {
          "hyperVGeneration": "V1",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-002",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition"
        },
        {
          "hyperVGeneration": "V2",
          "isHibernateSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-003",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-hibernate"
        },
        {
          "hyperVGeneration": "V2",
          "isAcceleratedNetworkSupported": "true",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 8,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-ws-004",
          "offer": "WindowsServer",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsServer",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "sku": "2022-datacenter-azure-edition-accnet"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 16,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 2,
          "name": "az-imgd-wdtl-002",
          "offer": "WindowsDesktop",
          "osState": "Generalized",
          "osType": "Windows",
          "publisher": "MicrosoftWindowsDesktop",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "securityType": "TrustedLaunch",
          "sku": "Win11-21H2"
        },
        {
          "hyperVGeneration": "V2",
          "maxRecommendedMemory": 32,
          "maxRecommendedvCPUs": 4,
          "minRecommendedMemory": 4,
          "minRecommendedvCPUs": 1,
          "name": "az-imgd-us-001",
          "offer": "0001-com-ubuntu-server-focal",
          "osState": "Generalized",
          "osType": "Linux",
          "publisher": "canonical",
          "sku": "20_04-lts-gen2"
        }
      ]
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
| [`name`](#parameter-name) | string | Name of the Azure Compute Gallery. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applications`](#parameter-applications) | array | Applications to create. |
| [`description`](#parameter-description) | string | Description of the Azure Shared Image Gallery. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`images`](#parameter-images) | array | Images to create. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |

### Parameter: `name`

Name of the Azure Compute Gallery.

- Required: Yes
- Type: string

### Parameter: `applications`

Applications to create.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `description`

Description of the Azure Shared Image Gallery.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `images`

Images to create.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

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

### Parameter: `tags`

Tags for all resources.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed image gallery. |
| `resourceGroupName` | string | The resource group of the deployed image gallery. |
| `resourceId` | string | The resource ID of the deployed image gallery. |

## Cross-referenced modules

_None_
