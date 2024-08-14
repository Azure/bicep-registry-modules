# Azure Compute Galleries `[Microsoft.Compute/galleries]`

This module deploys an Azure Compute Gallery (formerly known as Shared Image Gallery).

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
| `Microsoft.Compute/galleries` | [2023-07-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-07-03/galleries) |
| `Microsoft.Compute/galleries/applications` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/applications) |
| `Microsoft.Compute/galleries/images` | [2023-07-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-07-03/galleries/images) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/compute/gallery:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module gallery 'br/public:avm/res/compute/gallery:<version>' = {
  name: 'galleryDeployment'
  params: {
    // Required parameters
    name: 'cgmin001'
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
    "name": {
      "value": "cgmin001"
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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module gallery 'br/public:avm/res/compute/gallery:<version>' = {
  name: 'galleryDeployment'
  params: {
    // Required parameters
    name: 'cgmax001'
    // Non-required parameters
    applications: [
      {
        name: 'cgmax-appd-001'
        supportedOSType: 'Linux'
      }
      {
        name: 'cgmax-appd-002'
        roleAssignments: [
          {
            name: '4ef8d3d3-54be-4522-92c3-284977292d87'
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
        supportedOSType: 'Windows'
      }
    ]
    images: [
      {
        architecture: 'x64'
        description: 'testDescription'
        endOfLife: '2033-01-01'
        eula: 'test Eula'
        excludedDiskTypes: [
          'Standard_LRS'
        ]
        hyperVGeneration: 'V1'
        identifier: {
          offer: 'WindowsServer'
          publisher: 'MicrosoftWindowsServer'
          sku: '2022-datacenter-azure-edition'
        }
        name: 'az-imgd-ws-001'
        osState: 'Generalized'
        osType: 'Windows'
        privacyStatementUri: 'https://testPrivacyStatementUri.com'
        purchasePlan: {
          name: 'testPlanName1'
          product: 'testProduct1'
          publisher: 'testPublisher1'
        }
        releaseNoteUri: 'https://testReleaseNoteUri.com'
      }
      {
        hyperVGeneration: 'V2'
        identifier: {
          offer: 'WindowsServer'
          publisher: 'MicrosoftWindowsServer'
          sku: '2022-datacenter-azure-edition-hibernate'
        }
        isAcceleratedNetworkSupported: false
        isHibernateSupported: true
        memory: {
          max: 16
          min: 4
        }
        name: 'az-imgd-ws-002'
        osState: 'Generalized'
        osType: 'Windows'
        vCPUs: {
          max: 8
          min: 2
        }
      }
      {
        hyperVGeneration: 'V2'
        identifier: {
          offer: 'WindowsDesktop'
          publisher: 'MicrosoftWindowsDesktop'
          sku: 'Win11-21H2'
        }
        memory: {
          max: 16
          min: 4
        }
        name: 'az-imgd-wdtl-003'
        osState: 'Generalized'
        osType: 'Windows'
        purchasePlan: {
          name: 'testPlanName'
          product: 'testProduct'
          publisher: 'testPublisher'
        }
        securityType: 'TrustedLaunch'
        vCPUs: {
          max: 8
          min: 2
        }
      }
      {
        hyperVGeneration: 'V2'
        identifier: {
          offer: '0001-com-ubuntu-minimal-focal'
          publisher: 'canonical'
          sku: '22_04-lts-gen2'
        }
        isAcceleratedNetworkSupported: false
        memory: {
          max: 32
          min: 4
        }
        name: 'az-imgd-us-004'
        osState: 'Generalized'
        osType: 'Linux'
        vCPUs: {
          max: 4
          min: 1
        }
      }
      {
        hyperVGeneration: 'V2'
        identifier: {
          offer: '0001-com-ubuntu-minimal-focal'
          publisher: 'canonical'
          sku: '20_04-lts-gen2'
        }
        isAcceleratedNetworkSupported: true
        memory: {
          max: 32
          min: 4
        }
        name: 'az-imgd-us-005'
        osState: 'Generalized'
        osType: 'Linux'
        vCPUs: {
          max: 4
          min: 1
        }
      }
      {
        architecture: 'x64'
        description: 'testDescription'
        endOfLife: '2033-01-01'
        eula: 'test Eula'
        excludedDiskTypes: [
          'Standard_LRS'
        ]
        hyperVGeneration: 'V2'
        identifier: {
          offer: '0001-com-ubuntu-server-focal'
          publisher: 'canonical'
          sku: '20_04-lts-gen2'
        }
        isAcceleratedNetworkSupported: false
        isHibernateSupported: true
        memory: {
          max: 32
          min: 4
        }
        name: 'az-imgd-us-006'
        osState: 'Generalized'
        osType: 'Linux'
        privacyStatementUri: 'https://testPrivacyStatementUri.com'
        purchasePlan: {
          name: 'testPlanName'
          product: 'testProduct'
          publisher: 'testPublisher'
        }
        releaseNoteUri: 'https://testReleaseNoteUri.com'
        securityType: 'TrustedLaunch'
        vCPUs: {
          max: 4
          min: 1
        }
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: '3bd58a78-108d-4f87-b404-0a03e49303d8'
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
          "name": "cgmax-appd-001",
          "supportedOSType": "Linux"
        },
        {
          "name": "cgmax-appd-002",
          "roleAssignments": [
            {
              "name": "4ef8d3d3-54be-4522-92c3-284977292d87",
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
          ],
          "supportedOSType": "Windows"
        }
      ]
    },
    "images": {
      "value": [
        {
          "architecture": "x64",
          "description": "testDescription",
          "endOfLife": "2033-01-01",
          "eula": "test Eula",
          "excludedDiskTypes": [
            "Standard_LRS"
          ],
          "hyperVGeneration": "V1",
          "identifier": {
            "offer": "WindowsServer",
            "publisher": "MicrosoftWindowsServer",
            "sku": "2022-datacenter-azure-edition"
          },
          "name": "az-imgd-ws-001",
          "osState": "Generalized",
          "osType": "Windows",
          "privacyStatementUri": "https://testPrivacyStatementUri.com",
          "purchasePlan": {
            "name": "testPlanName1",
            "product": "testProduct1",
            "publisher": "testPublisher1"
          },
          "releaseNoteUri": "https://testReleaseNoteUri.com"
        },
        {
          "hyperVGeneration": "V2",
          "identifier": {
            "offer": "WindowsServer",
            "publisher": "MicrosoftWindowsServer",
            "sku": "2022-datacenter-azure-edition-hibernate"
          },
          "isAcceleratedNetworkSupported": false,
          "isHibernateSupported": true,
          "memory": {
            "max": 16,
            "min": 4
          },
          "name": "az-imgd-ws-002",
          "osState": "Generalized",
          "osType": "Windows",
          "vCPUs": {
            "max": 8,
            "min": 2
          }
        },
        {
          "hyperVGeneration": "V2",
          "identifier": {
            "offer": "WindowsDesktop",
            "publisher": "MicrosoftWindowsDesktop",
            "sku": "Win11-21H2"
          },
          "memory": {
            "max": 16,
            "min": 4
          },
          "name": "az-imgd-wdtl-003",
          "osState": "Generalized",
          "osType": "Windows",
          "purchasePlan": {
            "name": "testPlanName",
            "product": "testProduct",
            "publisher": "testPublisher"
          },
          "securityType": "TrustedLaunch",
          "vCPUs": {
            "max": 8,
            "min": 2
          }
        },
        {
          "hyperVGeneration": "V2",
          "identifier": {
            "offer": "0001-com-ubuntu-minimal-focal",
            "publisher": "canonical",
            "sku": "22_04-lts-gen2"
          },
          "isAcceleratedNetworkSupported": false,
          "memory": {
            "max": 32,
            "min": 4
          },
          "name": "az-imgd-us-004",
          "osState": "Generalized",
          "osType": "Linux",
          "vCPUs": {
            "max": 4,
            "min": 1
          }
        },
        {
          "hyperVGeneration": "V2",
          "identifier": {
            "offer": "0001-com-ubuntu-minimal-focal",
            "publisher": "canonical",
            "sku": "20_04-lts-gen2"
          },
          "isAcceleratedNetworkSupported": true,
          "memory": {
            "max": 32,
            "min": 4
          },
          "name": "az-imgd-us-005",
          "osState": "Generalized",
          "osType": "Linux",
          "vCPUs": {
            "max": 4,
            "min": 1
          }
        },
        {
          "architecture": "x64",
          "description": "testDescription",
          "endOfLife": "2033-01-01",
          "eula": "test Eula",
          "excludedDiskTypes": [
            "Standard_LRS"
          ],
          "hyperVGeneration": "V2",
          "identifier": {
            "offer": "0001-com-ubuntu-server-focal",
            "publisher": "canonical",
            "sku": "20_04-lts-gen2"
          },
          "isAcceleratedNetworkSupported": false,
          "isHibernateSupported": true,
          "memory": {
            "max": 32,
            "min": 4
          },
          "name": "az-imgd-us-006",
          "osState": "Generalized",
          "osType": "Linux",
          "privacyStatementUri": "https://testPrivacyStatementUri.com",
          "purchasePlan": {
            "name": "testPlanName",
            "product": "testProduct",
            "publisher": "testPublisher"
          },
          "releaseNoteUri": "https://testReleaseNoteUri.com",
          "securityType": "TrustedLaunch",
          "vCPUs": {
            "max": 4,
            "min": 1
          }
        }
      ]
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
    "roleAssignments": {
      "value": [
        {
          "name": "3bd58a78-108d-4f87-b404-0a03e49303d8",
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
module gallery 'br/public:avm/res/compute/gallery:<version>' = {
  name: 'galleryDeployment'
  params: {
    // Required parameters
    name: 'cgwaf001'
    // Non-required parameters
    applications: [
      {
        name: 'cgwaf-appd-001'
        supportedOSType: 'Windows'
      }
    ]
    images: [
      {
        identifier: {
          offer: 'WindowsServer'
          publisher: 'MicrosoftWindowsServer'
          sku: '2022-datacenter-azure-edition'
        }
        name: 'az-imgd-ws-001'
        osState: 'Generalized'
        osType: 'Windows'
      }
    ]
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
          "name": "cgwaf-appd-001",
          "supportedOSType": "Windows"
        }
      ]
    },
    "images": {
      "value": [
        {
          "identifier": {
            "offer": "WindowsServer",
            "publisher": "MicrosoftWindowsServer",
            "sku": "2022-datacenter-azure-edition"
          },
          "name": "az-imgd-ws-001",
          "osState": "Generalized",
          "osType": "Windows"
        }
      ]
    },
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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`images`](#parameter-images) | array | Images to create. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sharingProfile`](#parameter-sharingprofile) | object | Profile for gallery sharing to subscription or tenant. |
| [`softDeletePolicy`](#parameter-softdeletepolicy) | object | Soft deletion policy of the gallery. |
| [`tags`](#parameter-tags) | object | Tags for all resources. |

### Parameter: `name`

Name of the Azure Compute Gallery.

- Required: Yes
- Type: string

### Parameter: `applications`

Applications to create.

- Required: No
- Type: array

### Parameter: `description`

Description of the Azure Shared Image Gallery.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `images`

Images to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identifier`](#parameter-imagesidentifier) | object | This is the gallery image definition identifier. |
| [`name`](#parameter-imagesname) | string | Name of the image definition. |
| [`osState`](#parameter-imagesosstate) | string | This property allows the user to specify the state of the OS of the image. |
| [`osType`](#parameter-imagesostype) | string | This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`architecture`](#parameter-imagesarchitecture) | string | The architecture of the image. Applicable to OS disks only. |
| [`description`](#parameter-imagesdescription) | string | The description of this gallery image definition resource. This property is updatable. |
| [`endOfLife`](#parameter-imagesendoflife) | string | The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable. |
| [`eula`](#parameter-imageseula) | string | The Eula agreement for the gallery image definition. |
| [`excludedDiskTypes`](#parameter-imagesexcludeddisktypes) | array | Describes the disallowed disk types. |
| [`hyperVGeneration`](#parameter-imageshypervgeneration) | string | The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1. |
| [`isAcceleratedNetworkSupported`](#parameter-imagesisacceleratednetworksupported) | bool | Specify if the image supports accelerated networking. Defaults to true. |
| [`isHibernateSupported`](#parameter-imagesishibernatesupported) | bool | Specifiy if the image supports hibernation. |
| [`memory`](#parameter-imagesmemory) | object | Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16. |
| [`privacyStatementUri`](#parameter-imagesprivacystatementuri) | string | The privacy statement uri. |
| [`purchasePlan`](#parameter-imagespurchaseplan) | object | Describes the gallery image definition purchase plan. This is used by marketplace images. |
| [`releaseNoteUri`](#parameter-imagesreleasenoteuri) | string | The release note uri. Has to be a valid URL. |
| [`securityType`](#parameter-imagessecuritytype) | string | The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`. |
| [`vCPUs`](#parameter-imagesvcpus) | object | Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4. |

### Parameter: `images.identifier`

This is the gallery image definition identifier.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`offer`](#parameter-imagesidentifieroffer) | string | The name of the gallery image definition offer. |
| [`publisher`](#parameter-imagesidentifierpublisher) | string | The name of the gallery image definition publisher. |
| [`sku`](#parameter-imagesidentifiersku) | string | The name of the gallery image definition SKU. |

### Parameter: `images.identifier.offer`

The name of the gallery image definition offer.

- Required: Yes
- Type: string

### Parameter: `images.identifier.publisher`

The name of the gallery image definition publisher.

- Required: Yes
- Type: string

### Parameter: `images.identifier.sku`

The name of the gallery image definition SKU.

- Required: Yes
- Type: string

### Parameter: `images.name`

Name of the image definition.

- Required: Yes
- Type: string

### Parameter: `images.osState`

This property allows the user to specify the state of the OS of the image.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Generalized'
    'Specialized'
  ]
  ```

### Parameter: `images.osType`

This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `images.architecture`

The architecture of the image. Applicable to OS disks only.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Arm64'
    'x64'
  ]
  ```

### Parameter: `images.description`

The description of this gallery image definition resource. This property is updatable.

- Required: No
- Type: string

### Parameter: `images.endOfLife`

The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.

- Required: No
- Type: string

### Parameter: `images.eula`

The Eula agreement for the gallery image definition.

- Required: No
- Type: string

### Parameter: `images.excludedDiskTypes`

Describes the disallowed disk types.

- Required: No
- Type: array

### Parameter: `images.hyperVGeneration`

The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'V1'
    'V2'
  ]
  ```

### Parameter: `images.isAcceleratedNetworkSupported`

Specify if the image supports accelerated networking. Defaults to true.

- Required: No
- Type: bool

### Parameter: `images.isHibernateSupported`

Specifiy if the image supports hibernation.

- Required: No
- Type: bool

### Parameter: `images.memory`

Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-imagesmemorymax) | int | The minimum number of the resource. |
| [`min`](#parameter-imagesmemorymin) | int | The minimum number of the resource. |

### Parameter: `images.memory.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `images.memory.min`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `images.privacyStatementUri`

The privacy statement uri.

- Required: No
- Type: string

### Parameter: `images.purchasePlan`

Describes the gallery image definition purchase plan. This is used by marketplace images.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-imagespurchaseplanname) | string | The plan ID. |
| [`product`](#parameter-imagespurchaseplanproduct) | string | The product ID. |
| [`publisher`](#parameter-imagespurchaseplanpublisher) | string | The publisher ID. |

### Parameter: `images.purchasePlan.name`

The plan ID.

- Required: Yes
- Type: string

### Parameter: `images.purchasePlan.product`

The product ID.

- Required: Yes
- Type: string

### Parameter: `images.purchasePlan.publisher`

The publisher ID.

- Required: Yes
- Type: string

### Parameter: `images.releaseNoteUri`

The release note uri. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `images.securityType`

The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ConfidentialVM'
    'ConfidentialVMSupported'
    'Standard'
    'TrustedLaunch'
  ]
  ```

### Parameter: `images.vCPUs`

Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-imagesvcpusmax) | int | The minimum number of the resource. |
| [`min`](#parameter-imagesvcpusmin) | int | The minimum number of the resource. |

### Parameter: `images.vCPUs.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `images.vCPUs.min`

The minimum number of the resource.

- Required: No
- Type: int

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

### Parameter: `sharingProfile`

Profile for gallery sharing to subscription or tenant.

- Required: No
- Type: object

### Parameter: `softDeletePolicy`

Soft deletion policy of the gallery.

- Required: No
- Type: object

### Parameter: `tags`

Tags for all resources.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      key1: 'value1'
      key2: 'value2'
  }
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `imageResourceIds` | array | The resource ids of the deployed images. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed image gallery. |
| `resourceGroupName` | string | The resource group of the deployed image gallery. |
| `resourceId` | string | The resource ID of the deployed image gallery. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
