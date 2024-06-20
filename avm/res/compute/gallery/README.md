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
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        supportedOSType: 'Windows'
      }
    ]
    images: [
      {
        name: 'az-imgd-ws-001'
        properties: {
          architecture: 'x64'
          description: 'testDescription'
          disallowed: {
            diskTypes: [
              'Standard_LRS'
            ]
          }
          endOfLifeDate: '2033-01-01'
          eula: 'test Eula'
          hyperVGeneration: 'V1'
          identifier: {
            offer: 'WindowsServer'
            publisher: 'MicrosoftWindowsServer'
            sku: '2022-datacenter-azure-edition'
          }
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
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
      {
        isAcceleratedNetworkSupported: false
        isHibernateSupported: true
        name: 'az-imgd-ws-002'
        properties: {
          hyperVGeneration: 'V2'
          identifier: {
            offer: 'WindowsServer'
            publisher: 'MicrosoftWindowsServer'
            sku: '2022-datacenter-azure-edition-hibernate'
          }
          osState: 'Generalized'
          osType: 'Windows'
          recommended: {
            memory: {
              max: 16
              min: 4
            }
            vCPUs: {
              max: 8
              min: 2
            }
          }
        }
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
      {
        name: 'az-imgd-wdtl-003'
        properties: {
          hyperVGeneration: 'V2'
          identifier: {
            offer: 'WindowsDesktop'
            publisher: 'MicrosoftWindowsDesktop'
            sku: 'Win11-21H2'
          }
          osState: 'Generalized'
          osType: 'Windows'
          purchasePlan: {
            name: 'testPlanName'
            product: 'testProduct'
            publisher: 'testPublisher'
          }
          recommended: {
            memory: {
              max: 16
              min: 4
            }
            vCPUs: {
              max: 8
              min: 2
            }
          }
        }
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        securityType: 'TrustedLaunch'
      }
      {
        isAcceleratedNetworkSupported: false
        name: 'az-imgd-us-004'
        properties: {
          hyperVGeneration: 'V2'
          identifier: {
            offer: '0001-com-ubuntu-minimal-focal'
            publisher: 'canonical'
            sku: '22_04-lts-gen2'
          }
          osState: 'Generalized'
          osType: 'Linux'
          recommended: {
            memory: {
              max: 32
              min: 4
            }
            vCPUs: {
              max: 4
              min: 1
            }
          }
        }
      }
      {
        isAcceleratedNetworkSupported: true
        name: 'az-imgd-us-005'
        properties: {
          hyperVGeneration: 'V2'
          identifier: {
            offer: '0001-com-ubuntu-minimal-focal'
            publisher: 'canonical'
            sku: '20_04-lts-gen2'
          }
          osState: 'Generalized'
          osType: 'Linux'
          recommended: {
            memory: {
              max: 32
              min: 4
            }
            vCPUs: {
              max: 4
              min: 1
            }
          }
        }
      }
      {
        isAcceleratedNetworkSupported: false
        name: 'az-imgd-us-006'
        properties: {
          hyperVGeneration: 'V2'
          identifier: {
            offer: '0001-com-ubuntu-server-focal'
            publisher: 'canonical'
            sku: '20_04-lts-gen2'
          }
          osState: 'Generalized'
          osType: 'Linux'
          recommended: {
            memory: {
              max: 32
              min: 4
            }
            vCPUs: {
              max: 4
              min: 1
            }
          }
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
          "name": "cgmax-appd-001",
          "supportedOSType": "Linux"
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
    "images": {
      "value": [
        {
          "name": "az-imgd-ws-001",
          "properties": {
            "architecture": "x64",
            "description": "testDescription",
            "disallowed": {
              "diskTypes": [
                "Standard_LRS"
              ]
            },
            "endOfLifeDate": "2033-01-01",
            "eula": "test Eula",
            "hyperVGeneration": "V1",
            "identifier": {
              "offer": "WindowsServer",
              "publisher": "MicrosoftWindowsServer",
              "sku": "2022-datacenter-azure-edition"
            },
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
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        },
        {
          "isAcceleratedNetworkSupported": false,
          "isHibernateSupported": true,
          "name": "az-imgd-ws-002",
          "properties": {
            "hyperVGeneration": "V2",
            "identifier": {
              "offer": "WindowsServer",
              "publisher": "MicrosoftWindowsServer",
              "sku": "2022-datacenter-azure-edition-hibernate"
            },
            "osState": "Generalized",
            "osType": "Windows",
            "recommended": {
              "memory": {
                "max": 16,
                "min": 4
              },
              "vCPUs": {
                "max": 8,
                "min": 2
              }
            }
          },
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        },
        {
          "name": "az-imgd-wdtl-003",
          "properties": {
            "hyperVGeneration": "V2",
            "identifier": {
              "offer": "WindowsDesktop",
              "publisher": "MicrosoftWindowsDesktop",
              "sku": "Win11-21H2"
            },
            "osState": "Generalized",
            "osType": "Windows",
            "purchasePlan": {
              "name": "testPlanName",
              "product": "testProduct",
              "publisher": "testPublisher"
            },
            "recommended": {
              "memory": {
                "max": 16,
                "min": 4
              },
              "vCPUs": {
                "max": 8,
                "min": 2
              }
            }
          },
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "securityType": "TrustedLaunch"
        },
        {
          "isAcceleratedNetworkSupported": false,
          "name": "az-imgd-us-004",
          "properties": {
            "hyperVGeneration": "V2",
            "identifier": {
              "offer": "0001-com-ubuntu-minimal-focal",
              "publisher": "canonical",
              "sku": "22_04-lts-gen2"
            },
            "osState": "Generalized",
            "osType": "Linux",
            "recommended": {
              "memory": {
                "max": 32,
                "min": 4
              },
              "vCPUs": {
                "max": 4,
                "min": 1
              }
            }
          }
        },
        {
          "isAcceleratedNetworkSupported": true,
          "name": "az-imgd-us-005",
          "properties": {
            "hyperVGeneration": "V2",
            "identifier": {
              "offer": "0001-com-ubuntu-minimal-focal",
              "publisher": "canonical",
              "sku": "20_04-lts-gen2"
            },
            "osState": "Generalized",
            "osType": "Linux",
            "recommended": {
              "memory": {
                "max": 32,
                "min": 4
              },
              "vCPUs": {
                "max": 4,
                "min": 1
              }
            }
          }
        },
        {
          "isAcceleratedNetworkSupported": false,
          "name": "az-imgd-us-006",
          "properties": {
            "hyperVGeneration": "V2",
            "identifier": {
              "offer": "0001-com-ubuntu-server-focal",
              "publisher": "canonical",
              "sku": "20_04-lts-gen2"
            },
            "osState": "Generalized",
            "osType": "Linux",
            "recommended": {
              "memory": {
                "max": 32,
                "min": 4
              },
              "vCPUs": {
                "max": 4,
                "min": 1
              }
            }
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
        name: 'az-imgd-ws-001'
        properties: {
          identifier: {
            offer: 'WindowsServer'
            publisher: 'MicrosoftWindowsServer'
            sku: '2022-datacenter-azure-edition'
          }
          osState: 'Generalized'
          osType: 'Windows'
        }
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
          "name": "az-imgd-ws-001",
          "properties": {
            "identifier": {
              "offer": "WindowsServer",
              "publisher": "MicrosoftWindowsServer",
              "sku": "2022-datacenter-azure-edition"
            },
            "osState": "Generalized",
            "osType": "Windows"
          }
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
| [`name`](#parameter-imagesname) | string | The resource name. |
| [`properties`](#parameter-imagesproperties) | object | Describes the properties of a gallery image definition. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isAcceleratedNetworkSupported`](#parameter-imagesisacceleratednetworksupported) | bool | Specify if the image supports accelerated networking. Defaults to true. |
| [`isHibernateSupported`](#parameter-imagesishibernatesupported) | bool | Specifiy if the image supports hibernation. |
| [`location`](#parameter-imageslocation) | string | The location of the resource. Defaults to the gallery resource location. |
| [`roleAssignments`](#parameter-imagesroleassignments) | array | Array of role assignments to create. |
| [`securityType`](#parameter-imagessecuritytype) | string | The security type of the image. Requires a hyperVGeneration V2. Defaults to `Standard`. |
| [`tags`](#parameter-imagestags) | object | Tags for all resources. Defaults to the tags of the gallery. |

### Parameter: `images.name`

The resource name.

- Required: Yes
- Type: string

### Parameter: `images.properties`

Describes the properties of a gallery image definition.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identifier`](#parameter-imagespropertiesidentifier) | object | This is the gallery image definition identifier. |
| [`osState`](#parameter-imagespropertiesosstate) | string | This property allows the user to specify whether the virtual machines created under this image are `Generalized` or `Specialized`. |
| [`osType`](#parameter-imagespropertiesostype) | string | This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. Possible values are: `Windows`, `Linux`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`architecture`](#parameter-imagespropertiesarchitecture) | string | The architecture of the image. Applicable to OS disks only. |
| [`description`](#parameter-imagespropertiesdescription) | string | The description of this gallery image definition resource. This property is updatable. |
| [`disallowed`](#parameter-imagespropertiesdisallowed) | object | Describes the disallowed disk types. |
| [`endOfLifeDate`](#parameter-imagespropertiesendoflifedate) | string | The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable. |
| [`eula`](#parameter-imagespropertieseula) | string | The Eula agreement for the gallery image definition. |
| [`hyperVGeneration`](#parameter-imagespropertieshypervgeneration) | string | The hypervisor generation of the Virtual Machine. If this value is not specified, then it is determined by the securityType parameter. If the securityType parameter is specified, then the value of hyperVGeneration will be V2, else V1. |
| [`privacyStatementUri`](#parameter-imagespropertiesprivacystatementuri) | string | The privacy statement uri. |
| [`purchasePlan`](#parameter-imagespropertiespurchaseplan) | object | Describes the gallery image definition purchase plan. This is used by marketplace images. |
| [`recommended`](#parameter-imagespropertiesrecommended) | object | The properties describe the recommended machine configuration for this Image Definition. These properties are updatable. |
| [`releaseNoteUri`](#parameter-imagespropertiesreleasenoteuri) | string | The release note uri. Has to be a valid URL. |

### Parameter: `images.properties.identifier`

This is the gallery image definition identifier.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`offer`](#parameter-imagespropertiesidentifieroffer) | string | The name of the gallery image definition publisher. |
| [`publisher`](#parameter-imagespropertiesidentifierpublisher) | string | The name of the gallery image definition offer. |
| [`sku`](#parameter-imagespropertiesidentifiersku) | string | The name of the gallery image definition SKU. |

### Parameter: `images.properties.identifier.offer`

The name of the gallery image definition publisher.

- Required: Yes
- Type: string

### Parameter: `images.properties.identifier.publisher`

The name of the gallery image definition offer.

- Required: Yes
- Type: string

### Parameter: `images.properties.identifier.sku`

The name of the gallery image definition SKU.

- Required: Yes
- Type: string

### Parameter: `images.properties.osState`

This property allows the user to specify whether the virtual machines created under this image are `Generalized` or `Specialized`.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Generalized'
    'Specialized'
  ]
  ```

### Parameter: `images.properties.osType`

This property allows you to specify the type of the OS that is included in the disk when creating a VM from a managed image. Possible values are: `Windows`, `Linux`.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `images.properties.architecture`

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

### Parameter: `images.properties.description`

The description of this gallery image definition resource. This property is updatable.

- Required: No
- Type: string

### Parameter: `images.properties.disallowed`

Describes the disallowed disk types.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskTypes`](#parameter-imagespropertiesdisalloweddisktypes) | array | A list of disk types. |

### Parameter: `images.properties.disallowed.diskTypes`

A list of disk types.

- Required: Yes
- Type: array

### Parameter: `images.properties.endOfLifeDate`

The end of life date of the gallery image definition. This property can be used for decommissioning purposes. This property is updatable.

- Required: No
- Type: string

### Parameter: `images.properties.eula`

The Eula agreement for the gallery image definition.

- Required: No
- Type: string

### Parameter: `images.properties.hyperVGeneration`

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

### Parameter: `images.properties.privacyStatementUri`

The privacy statement uri.

- Required: No
- Type: string

### Parameter: `images.properties.purchasePlan`

Describes the gallery image definition purchase plan. This is used by marketplace images.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-imagespropertiespurchaseplanname) | string | The plan ID. |
| [`product`](#parameter-imagespropertiespurchaseplanproduct) | string | The product ID. |
| [`publisher`](#parameter-imagespropertiespurchaseplanpublisher) | string | The publisher ID. |

### Parameter: `images.properties.purchasePlan.name`

The plan ID.

- Required: Yes
- Type: string

### Parameter: `images.properties.purchasePlan.product`

The product ID.

- Required: Yes
- Type: string

### Parameter: `images.properties.purchasePlan.publisher`

The publisher ID.

- Required: Yes
- Type: string

### Parameter: `images.properties.recommended`

The properties describe the recommended machine configuration for this Image Definition. These properties are updatable.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`memory`](#parameter-imagespropertiesrecommendedmemory) | object | Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16. |
| [`vCPUs`](#parameter-imagespropertiesrecommendedvcpus) | object | Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4. |

### Parameter: `images.properties.recommended.memory`

Describes the resource range (1-4000 GB RAM). Defaults to min=4, max=16.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-imagespropertiesrecommendedmemorymax) | int | The minimum number of the resource. |
| [`min`](#parameter-imagespropertiesrecommendedmemorymin) | int | The minimum number of the resource. |

### Parameter: `images.properties.recommended.memory.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `images.properties.recommended.memory.min`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `images.properties.recommended.vCPUs`

Describes the resource range (1-128 CPU cores). Defaults to min=1, max=4.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-imagespropertiesrecommendedvcpusmax) | int | The minimum number of the resource. |
| [`min`](#parameter-imagespropertiesrecommendedvcpusmin) | int | The minimum number of the resource. |

### Parameter: `images.properties.recommended.vCPUs.max`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `images.properties.recommended.vCPUs.min`

The minimum number of the resource.

- Required: No
- Type: int

### Parameter: `images.properties.releaseNoteUri`

The release note uri. Has to be a valid URL.

- Required: No
- Type: string

### Parameter: `images.isAcceleratedNetworkSupported`

Specify if the image supports accelerated networking. Defaults to true.

- Required: No
- Type: bool

### Parameter: `images.isHibernateSupported`

Specifiy if the image supports hibernation.

- Required: No
- Type: bool

### Parameter: `images.location`

The location of the resource. Defaults to the gallery resource location.

- Required: No
- Type: string

### Parameter: `images.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-imagesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-imagesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-imagesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-imagesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-imagesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-imagesroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-imagesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `images.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `images.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `images.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `images.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `images.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `images.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `images.roleAssignments.principalType`

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

### Parameter: `images.tags`

Tags for all resources. Defaults to the tags of the gallery.

- Required: No
- Type: object

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
