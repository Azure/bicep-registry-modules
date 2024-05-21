# Virtual Machine Image Templates `[Microsoft.VirtualMachineImages/imageTemplates]`

This module deploys a Virtual Machine Image Template that can be consumed by Azure Image Builder (AIB).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.VirtualMachineImages/imageTemplates` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.VirtualMachineImages/imageTemplates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/virtual-machine-images/image-template:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module imageTemplate 'br/public:avm/res/virtual-machine-images/image-template:<version>' = {
  name: 'imageTemplateDeployment'
  params: {
    // Required parameters
    customizationSteps: [
      {
        restartTimeout: '30m'
        type: 'WindowsRestart'
      }
    ]
    distributions: [
      {
        imageName: 'mi-vmiitmin-001'
        type: 'ManagedImage'
      }
    ]
    imageSource: {
      offer: 'Windows-10'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'win10-22h2-ent'
      type: 'PlatformImage'
      version: 'latest'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vmiitmin001'
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
    "customizationSteps": {
      "value": [
        {
          "restartTimeout": "30m",
          "type": "WindowsRestart"
        }
      ]
    },
    "distributions": {
      "value": [
        {
          "imageName": "mi-vmiitmin-001",
          "type": "ManagedImage"
        }
      ]
    },
    "imageSource": {
      "value": {
        "offer": "Windows-10",
        "publisher": "MicrosoftWindowsDesktop",
        "sku": "win10-22h2-ent",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "name": {
      "value": "vmiitmin001"
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
module imageTemplate 'br/public:avm/res/virtual-machine-images/image-template:<version>' = {
  name: 'imageTemplateDeployment'
  params: {
    // Required parameters
    customizationSteps: [
      {
        name: 'PowerShell installation'
        scriptUri: '<scriptUri>'
        type: 'Shell'
      }
      {
        destination: 'Initialize-LinuxSoftware.ps1'
        name: 'Initialize-LinuxSoftware'
        sourceUri: '<sourceUri>'
        type: 'File'
      }
      {
        inline: [
          'pwsh \'Initialize-LinuxSoftware.ps1\''
        ]
        name: 'Software installation'
        type: 'Shell'
      }
    ]
    distributions: [
      {
        imageName: 'mi-vmiitmax-001'
        type: 'ManagedImage'
      }
      {
        imageName: 'umi-vmiitmax-001'
        type: 'VHD'
      }
      {
        replicationRegions: [
          '<resourceLocation>'
        ]
        sharedImageGalleryImageDefinitionResourceId: '<sharedImageGalleryImageDefinitionResourceId>'
        sharedImageGalleryImageDefinitionTargetVersion: '<sharedImageGalleryImageDefinitionTargetVersion>'
        type: 'SharedImage'
      }
    ]
    imageSource: {
      offer: '0001-com-ubuntu-server-lunar'
      publisher: 'canonical'
      sku: '23_04-gen2'
      type: 'PlatformImage'
      version: 'latest'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vmiitmax001'
    // Non-required parameters
    buildTimeoutInMinutes: 60
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    optimizeVmBoot: 'Enabled'
    osDiskSizeGB: 127
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
    stagingResourceGroup: '<stagingResourceGroup>'
    subnetResourceId: '<subnetResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    validationProcess: {
      continueDistributeOnFailure: true
      inVMValidations: [
        {
          inline: [
            'echo \'Software validation successful.\''
          ]
          name: 'Validate-Software'
          type: 'Shell'
        }
      ]
      sourceValidationOnly: false
    }
    vmSize: 'Standard_D2s_v3'
    vmUserAssignedIdentities: [
      '<managedIdentityResourceId>'
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
    "customizationSteps": {
      "value": [
        {
          "name": "PowerShell installation",
          "scriptUri": "<scriptUri>",
          "type": "Shell"
        },
        {
          "destination": "Initialize-LinuxSoftware.ps1",
          "name": "Initialize-LinuxSoftware",
          "sourceUri": "<sourceUri>",
          "type": "File"
        },
        {
          "inline": [
            "pwsh \"Initialize-LinuxSoftware.ps1\""
          ],
          "name": "Software installation",
          "type": "Shell"
        }
      ]
    },
    "distributions": {
      "value": [
        {
          "imageName": "mi-vmiitmax-001",
          "type": "ManagedImage"
        },
        {
          "imageName": "umi-vmiitmax-001",
          "type": "VHD"
        },
        {
          "replicationRegions": [
            "<resourceLocation>"
          ],
          "sharedImageGalleryImageDefinitionResourceId": "<sharedImageGalleryImageDefinitionResourceId>",
          "sharedImageGalleryImageDefinitionTargetVersion": "<sharedImageGalleryImageDefinitionTargetVersion>",
          "type": "SharedImage"
        }
      ]
    },
    "imageSource": {
      "value": {
        "offer": "0001-com-ubuntu-server-lunar",
        "publisher": "canonical",
        "sku": "23_04-gen2",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "name": {
      "value": "vmiitmax001"
    },
    // Non-required parameters
    "buildTimeoutInMinutes": {
      "value": 60
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
    "optimizeVmBoot": {
      "value": "Enabled"
    },
    "osDiskSizeGB": {
      "value": 127
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
    "stagingResourceGroup": {
      "value": "<stagingResourceGroup>"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "validationProcess": {
      "value": {
        "continueDistributeOnFailure": true,
        "inVMValidations": [
          {
            "inline": [
              "echo \"Software validation successful.\""
            ],
            "name": "Validate-Software",
            "type": "Shell"
          }
        ],
        "sourceValidationOnly": false
      }
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
    },
    "vmUserAssignedIdentities": {
      "value": [
        "<managedIdentityResourceId>"
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
module imageTemplate 'br/public:avm/res/virtual-machine-images/image-template:<version>' = {
  name: 'imageTemplateDeployment'
  params: {
    // Required parameters
    customizationSteps: [
      {
        restartTimeout: '10m'
        type: 'WindowsRestart'
      }
    ]
    distributions: [
      {
        sharedImageGalleryImageDefinitionResourceId: '<sharedImageGalleryImageDefinitionResourceId>'
        type: 'SharedImage'
      }
    ]
    imageSource: {
      offer: 'Windows-11'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'win11-22h2-avd'
      type: 'PlatformImage'
      version: 'latest'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    name: 'vmiitwaf001'
    // Non-required parameters
    location: '<location>'
    subnetResourceId: '<subnetResourceId>'
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
    "customizationSteps": {
      "value": [
        {
          "restartTimeout": "10m",
          "type": "WindowsRestart"
        }
      ]
    },
    "distributions": {
      "value": [
        {
          "sharedImageGalleryImageDefinitionResourceId": "<sharedImageGalleryImageDefinitionResourceId>",
          "type": "SharedImage"
        }
      ]
    },
    "imageSource": {
      "value": {
        "offer": "Windows-11",
        "publisher": "MicrosoftWindowsDesktop",
        "sku": "win11-22h2-avd",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "name": {
      "value": "vmiitwaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
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
| [`customizationSteps`](#parameter-customizationsteps) | array | Customization steps to be run when building the VM image. |
| [`distributions`](#parameter-distributions) | array | The distribution targets where the image output needs to go to. |
| [`imageSource`](#parameter-imagesource) | object | Image source definition in object format. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`name`](#parameter-name) | string | The name prefix of the Image Template to be built by the Azure Image Builder service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`buildTimeoutInMinutes`](#parameter-buildtimeoutinminutes) | int | The image build timeout in minutes. 0 means the default 240 minutes. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`optimizeVmBoot`](#parameter-optimizevmboot) | string | The optimize property can be enabled while creating a VM image and allows VM optimization to improve image creation time. |
| [`osDiskSizeGB`](#parameter-osdisksizegb) | int | Specifies the size of OS disk. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`stagingResourceGroup`](#parameter-stagingresourcegroup) | string | Resource ID of the staging resource group in the same subscription and location as the image template that will be used to build the image.</p>If this field is empty, a resource group with a random name will be created.</p>If the resource group specified in this field doesn't exist, it will be created with the same name.</p>If the resource group specified exists, it must be empty and in the same region as the image template.</p>The resource group created will be deleted during template deletion if this field is empty or the resource group specified doesn't exist,</p>but if the resource group specified exists the resources created in the resource group will be deleted during template deletion and the resource group itself will remain. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | Resource ID of an already existing subnet, e.g.: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>.</p>If no value is provided, a new temporary VNET and subnet will be created in the staging resource group and will be deleted along with the remaining temporary resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`validationProcess`](#parameter-validationprocess) | object | Configuration options and list of validations to be performed on the resulting image. |
| [`vmSize`](#parameter-vmsize) | string | Specifies the size for the VM. |
| [`vmUserAssignedIdentities`](#parameter-vmuserassignedidentities) | array | List of User-Assigned Identities associated to the Build VM for accessing Azure resources such as Key Vaults from your customizer scripts. Be aware, the user assigned identities specified in the 'managedIdentities' parameter must have the 'Managed Identity Operator' role assignment on all the user assigned identities specified in this parameter for Azure Image Builder to be able to associate them to the build VM. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to generate a unique image template name. |

### Parameter: `customizationSteps`

Customization steps to be run when building the VM image.

- Required: Yes
- Type: array

### Parameter: `distributions`

The distribution targets where the image output needs to go to.

- Required: Yes
- Type: array

### Parameter: `imageSource`

Image source definition in object format.

- Required: Yes
- Type: object

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: Yes
- Type: array

### Parameter: `name`

The name prefix of the Image Template to be built by the Azure Image Builder service.

- Required: Yes
- Type: string

### Parameter: `buildTimeoutInMinutes`

The image build timeout in minutes. 0 means the default 240 minutes.

- Required: No
- Type: int
- Default: `0`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `optimizeVmBoot`

The optimize property can be enabled while creating a VM image and allows VM optimization to improve image creation time.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `osDiskSizeGB`

Specifies the size of OS disk.

- Required: No
- Type: int
- Default: `128`

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

### Parameter: `stagingResourceGroup`

Resource ID of the staging resource group in the same subscription and location as the image template that will be used to build the image.</p>If this field is empty, a resource group with a random name will be created.</p>If the resource group specified in this field doesn't exist, it will be created with the same name.</p>If the resource group specified exists, it must be empty and in the same region as the image template.</p>The resource group created will be deleted during template deletion if this field is empty or the resource group specified doesn't exist,</p>but if the resource group specified exists the resources created in the resource group will be deleted during template deletion and the resource group itself will remain.

- Required: No
- Type: string

### Parameter: `subnetResourceId`

Resource ID of an already existing subnet, e.g.: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>.</p>If no value is provided, a new temporary VNET and subnet will be created in the staging resource group and will be deleted along with the remaining temporary resources.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `validationProcess`

Configuration options and list of validations to be performed on the resulting image.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`continueDistributeOnFailure`](#parameter-validationprocesscontinuedistributeonfailure) | bool | If validation fails and this field is set to false, output image(s) will not be distributed. This is the default behavior. If validation fails and this field is set to true, output image(s) will still be distributed. Please use this option with caution as it may result in bad images being distributed for use. In either case (true or false), the end to end image run will be reported as having failed in case of a validation failure. [Note: This field has no effect if validation succeeds.]. |
| [`inVMValidations`](#parameter-validationprocessinvmvalidations) | array | A list of validators that will be performed on the image. Azure Image Builder supports File, PowerShell and Shell validators. |
| [`sourceValidationOnly`](#parameter-validationprocesssourcevalidationonly) | bool | If this field is set to true, the image specified in the 'source' section will directly be validated. No separate build will be run to generate and then validate a customized image. Not supported when performing customizations, validations or distributions on the image. |

### Parameter: `validationProcess.continueDistributeOnFailure`

If validation fails and this field is set to false, output image(s) will not be distributed. This is the default behavior. If validation fails and this field is set to true, output image(s) will still be distributed. Please use this option with caution as it may result in bad images being distributed for use. In either case (true or false), the end to end image run will be reported as having failed in case of a validation failure. [Note: This field has no effect if validation succeeds.].

- Required: No
- Type: bool

### Parameter: `validationProcess.inVMValidations`

A list of validators that will be performed on the image. Azure Image Builder supports File, PowerShell and Shell validators.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-validationprocessinvmvalidationstype) | string | The type of validation. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-validationprocessinvmvalidationsdestination) | string | Destination of the file. |
| [`inline`](#parameter-validationprocessinvmvalidationsinline) | array | Array of commands to be run, separated by commas. |
| [`name`](#parameter-validationprocessinvmvalidationsname) | string | Friendly Name to provide context on what this validation step does. |
| [`runAsSystem`](#parameter-validationprocessinvmvalidationsrunassystem) | bool | If specified, the PowerShell script will be run with elevated privileges using the Local System user. Can only be true when the runElevated field above is set to true. |
| [`runElevated`](#parameter-validationprocessinvmvalidationsrunelevated) | bool | If specified, the PowerShell script will be run with elevated privileges. |
| [`scriptUri`](#parameter-validationprocessinvmvalidationsscripturi) | string | URI of the PowerShell script to be run for validation. It can be a github link, Azure Storage URI, etc. |
| [`sha256Checksum`](#parameter-validationprocessinvmvalidationssha256checksum) | string | Value of sha256 checksum of the file, you generate this locally, and then Image Builder will checksum and validate. |
| [`sourceUri`](#parameter-validationprocessinvmvalidationssourceuri) | string | The source URI of the file. |
| [`validExitCodes`](#parameter-validationprocessinvmvalidationsvalidexitcodes) | array | Valid codes that can be returned from the script/inline command, this avoids reported failure of the script/inline command. |

### Parameter: `validationProcess.inVMValidations.type`

The type of validation.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'File'
    'PowerShell'
    'Shell'
  ]
  ```

### Parameter: `validationProcess.inVMValidations.destination`

Destination of the file.

- Required: No
- Type: string

### Parameter: `validationProcess.inVMValidations.inline`

Array of commands to be run, separated by commas.

- Required: No
- Type: array

### Parameter: `validationProcess.inVMValidations.name`

Friendly Name to provide context on what this validation step does.

- Required: No
- Type: string

### Parameter: `validationProcess.inVMValidations.runAsSystem`

If specified, the PowerShell script will be run with elevated privileges using the Local System user. Can only be true when the runElevated field above is set to true.

- Required: No
- Type: bool

### Parameter: `validationProcess.inVMValidations.runElevated`

If specified, the PowerShell script will be run with elevated privileges.

- Required: No
- Type: bool

### Parameter: `validationProcess.inVMValidations.scriptUri`

URI of the PowerShell script to be run for validation. It can be a github link, Azure Storage URI, etc.

- Required: No
- Type: string

### Parameter: `validationProcess.inVMValidations.sha256Checksum`

Value of sha256 checksum of the file, you generate this locally, and then Image Builder will checksum and validate.

- Required: No
- Type: string

### Parameter: `validationProcess.inVMValidations.sourceUri`

The source URI of the file.

- Required: No
- Type: string

### Parameter: `validationProcess.inVMValidations.validExitCodes`

Valid codes that can be returned from the script/inline command, this avoids reported failure of the script/inline command.

- Required: No
- Type: array

### Parameter: `validationProcess.sourceValidationOnly`

If this field is set to true, the image specified in the 'source' section will directly be validated. No separate build will be run to generate and then validate a customized image. Not supported when performing customizations, validations or distributions on the image.

- Required: No
- Type: bool

### Parameter: `vmSize`

Specifies the size for the VM.

- Required: No
- Type: string
- Default: `'Standard_D2s_v3'`

### Parameter: `vmUserAssignedIdentities`

List of User-Assigned Identities associated to the Build VM for accessing Azure resources such as Key Vaults from your customizer scripts. Be aware, the user assigned identities specified in the 'managedIdentities' parameter must have the 'Managed Identity Operator' role assignment on all the user assigned identities specified in this parameter for Azure Image Builder to be able to associate them to the build VM.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `baseTime`

Do not provide a value! This date value is used to generate a unique image template name.

- Required: No
- Type: string
- Default: `[utcNow('yyyy-MM-dd-HH-mm-ss')]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The full name of the deployed image template. |
| `namePrefix` | string | The prefix of the image template name provided as input. |
| `resourceGroupName` | string | The resource group the image template was deployed into. |
| `resourceId` | string | The resource ID of the image template. |
| `runThisCommand` | string | The command to run in order to trigger the image build. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `imageSource`

Tag names and tag values can be provided as needed. A tag can be left without a value.

#### Platform Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "PlatformImage",
    "publisher": "MicrosoftWindowsDesktop",
    "offer": "Windows-10",
    "sku": "19h2-evd",
    "version": "latest"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'PlatformImage'
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'Windows-10'
    sku: '19h2-evd'
    version: 'latest'
}
```

</details>
<p>

#### Managed Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "ManagedImage",
    "imageId": "/subscriptions/<subscriptionId>/resourceGroups/{destinationResourceGroupName}/providers/Microsoft.Compute/images/<imageName>"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'ManagedImage'
    imageId: '/subscriptions/<subscriptionId>/resourceGroups/{destinationResourceGroupName}/providers/Microsoft.Compute/images/<imageName>'
}
```

</details>
<p>

#### Shared Image

<details>

<summary>Parameter JSON format</summary>

```json
"source": {
    "type": "SharedImageVersion",
    "imageVersionID": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/galleries/<sharedImageGalleryName>/images/<imageDefinitionName/versions/<imageVersion>"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
source: {
    type: 'SharedImageVersion'
    imageVersionID: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Compute/galleries/<sharedImageGalleryName>/images/<imageDefinitionName/versions/<imageVersion>'
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
