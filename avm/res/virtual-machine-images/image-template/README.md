# Virtual Machine Image Templates `[Microsoft.VirtualMachineImages/imageTemplates]`

This module deploys a Virtual Machine Image Template that can be consumed by Azure Image Builder (AIB).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.VirtualMachineImages/imageTemplates` | [2022-02-14](https://learn.microsoft.com/en-us/azure/templates/Microsoft.VirtualMachineImages/2022-02-14/imageTemplates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/virtual-machine-images.image-template:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module imageTemplate 'br:bicep/modules/virtual-machine-images.image-template:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-vmiitmin'
  params: {
    // Required parameters
    customizationSteps: [
      {
        restartTimeout: '30m'
        type: 'WindowsRestart'
      }
    ]
    imageSource: {
      offer: 'Windows-10'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'win10-22h2-ent'
      type: 'PlatformImage'
      version: 'latest'
    }
    name: 'vmiitmin001'
    userMsiName: '<userMsiName>'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managedImageName: 'mi-vmiitmin-001'
    userMsiResourceGroup: '<userMsiResourceGroup>'
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
    "imageSource": {
      "value": {
        "offer": "Windows-10",
        "publisher": "MicrosoftWindowsDesktop",
        "sku": "win10-22h2-ent",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    "name": {
      "value": "vmiitmin001"
    },
    "userMsiName": {
      "value": "<userMsiName>"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managedImageName": {
      "value": "mi-vmiitmin-001"
    },
    "userMsiResourceGroup": {
      "value": "<userMsiResourceGroup>"
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
module imageTemplate 'br:bicep/modules/virtual-machine-images.image-template:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-vmiitmax'
  params: {
    // Required parameters
    customizationSteps: [
      {
        restartTimeout: '10m'
        type: 'WindowsRestart'
      }
    ]
    imageSource: {
      offer: 'Windows-11'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'win11-22h2-avd'
      type: 'PlatformImage'
      version: 'latest'
    }
    name: 'vmiitmax001'
    userMsiName: '<userMsiName>'
    // Non-required parameters
    buildTimeoutInMinutes: 60
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    imageReplicationRegions: []
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedImageName: 'mi-vmiitmax-001'
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
    sigImageDefinitionId: '<sigImageDefinitionId>'
    sigImageVersion: '<sigImageVersion>'
    stagingResourceGroup: '<stagingResourceGroup>'
    subnetId: '<subnetId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    unManagedImageName: 'umi-vmiitmax-001'
    userAssignedIdentities: [
      '<managedIdentityResourceId>'
    ]
    userMsiResourceGroup: '<userMsiResourceGroup>'
    vmSize: 'Standard_D2s_v3'
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
    "imageSource": {
      "value": {
        "offer": "Windows-11",
        "publisher": "MicrosoftWindowsDesktop",
        "sku": "win11-22h2-avd",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    "name": {
      "value": "vmiitmax001"
    },
    "userMsiName": {
      "value": "<userMsiName>"
    },
    // Non-required parameters
    "buildTimeoutInMinutes": {
      "value": 60
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "imageReplicationRegions": {
      "value": []
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedImageName": {
      "value": "mi-vmiitmax-001"
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
    "sigImageDefinitionId": {
      "value": "<sigImageDefinitionId>"
    },
    "sigImageVersion": {
      "value": "<sigImageVersion>"
    },
    "stagingResourceGroup": {
      "value": "<stagingResourceGroup>"
    },
    "subnetId": {
      "value": "<subnetId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "unManagedImageName": {
      "value": "umi-vmiitmax-001"
    },
    "userAssignedIdentities": {
      "value": [
        "<managedIdentityResourceId>"
      ]
    },
    "userMsiResourceGroup": {
      "value": "<userMsiResourceGroup>"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
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
module imageTemplate 'br:bicep/modules/virtual-machine-images.image-template:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-vmiitwaf'
  params: {
    // Required parameters
    customizationSteps: [
      {
        restartTimeout: '10m'
        type: 'WindowsRestart'
      }
    ]
    imageSource: {
      offer: 'Windows-11'
      publisher: 'MicrosoftWindowsDesktop'
      sku: 'win11-22h2-avd'
      type: 'PlatformImage'
      version: 'latest'
    }
    name: 'vmiitwaf001'
    userMsiName: '<userMsiName>'
    // Non-required parameters
    buildTimeoutInMinutes: 60
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    imageReplicationRegions: []
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedImageName: 'mi-vmiitwaf-001'
    osDiskSizeGB: 127
    sigImageDefinitionId: '<sigImageDefinitionId>'
    sigImageVersion: '<sigImageVersion>'
    stagingResourceGroup: '<stagingResourceGroup>'
    subnetId: '<subnetId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    unManagedImageName: 'umi-vmiitwaf-001'
    userAssignedIdentities: [
      '<managedIdentityResourceId>'
    ]
    userMsiResourceGroup: '<userMsiResourceGroup>'
    vmSize: 'Standard_D2s_v3'
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
    "imageSource": {
      "value": {
        "offer": "Windows-11",
        "publisher": "MicrosoftWindowsDesktop",
        "sku": "win11-22h2-avd",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    "name": {
      "value": "vmiitwaf001"
    },
    "userMsiName": {
      "value": "<userMsiName>"
    },
    // Non-required parameters
    "buildTimeoutInMinutes": {
      "value": 60
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "imageReplicationRegions": {
      "value": []
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedImageName": {
      "value": "mi-vmiitwaf-001"
    },
    "osDiskSizeGB": {
      "value": 127
    },
    "sigImageDefinitionId": {
      "value": "<sigImageDefinitionId>"
    },
    "sigImageVersion": {
      "value": "<sigImageVersion>"
    },
    "stagingResourceGroup": {
      "value": "<stagingResourceGroup>"
    },
    "subnetId": {
      "value": "<subnetId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "unManagedImageName": {
      "value": "umi-vmiitwaf-001"
    },
    "userAssignedIdentities": {
      "value": [
        "<managedIdentityResourceId>"
      ]
    },
    "userMsiResourceGroup": {
      "value": "<userMsiResourceGroup>"
    },
    "vmSize": {
      "value": "Standard_D2s_v3"
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
| [`imageSource`](#parameter-imagesource) | object | Image source definition in object format. |
| [`name`](#parameter-name) | string | Name prefix of the Image Template to be built by the Azure Image Builder service. |
| [`userMsiName`](#parameter-usermsiname) | string | Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`buildTimeoutInMinutes`](#parameter-buildtimeoutinminutes) | int | Image build timeout in minutes. Allowed values: 0-960. 0 means the default 240 minutes. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`excludeFromLatest`](#parameter-excludefromlatest) | bool | Exclude the created Azure Compute Gallery image version from the latest. |
| [`imageReplicationRegions`](#parameter-imagereplicationregions) | array | List of the regions the image produced by this solution should be stored in the Shared Image Gallery. When left empty, the deployment's location will be taken as a default value. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedImageName`](#parameter-managedimagename) | string | Name of the managed image that will be created in the AIB resourcegroup. |
| [`osDiskSizeGB`](#parameter-osdisksizegb) | int | Specifies the size of OS disk. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sigImageDefinitionId`](#parameter-sigimagedefinitionid) | string | Resource ID of Shared Image Gallery to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition>. |
| [`sigImageVersion`](#parameter-sigimageversion) | string | Version of the Shared Image Gallery Image. Supports the following Version Syntax: Major.Minor.Build (i.e., '1.1.1' or '10.1.2'). |
| [`stagingResourceGroup`](#parameter-stagingresourcegroup) | string | Resource ID of the staging resource group in the same subscription and location as the image template that will be used to build the image.</p>If this field is empty, a resource group with a random name will be created.</p>If the resource group specified in this field doesn't exist, it will be created with the same name.</p>If the resource group specified exists, it must be empty and in the same region as the image template.</p>The resource group created will be deleted during template deletion if this field is empty or the resource group specified doesn't exist,</p>but if the resource group specified exists the resources created in the resource group will be deleted during template deletion and the resource group itself will remain. |
| [`storageAccountType`](#parameter-storageaccounttype) | string | Storage account type to be used to store the image in the Azure Compute Gallery. |
| [`subnetId`](#parameter-subnetid) | string | Resource ID of an already existing subnet, e.g.: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>.</p>If no value is provided, a new temporary VNET and subnet will be created in the staging resource group and will be deleted along with the remaining temporary resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`unManagedImageName`](#parameter-unmanagedimagename) | string | Name of the unmanaged image that will be created in the AIB resourcegroup. |
| [`userAssignedIdentities`](#parameter-userassignedidentities) | array | List of User-Assigned Identities associated to the Build VM for accessing Azure resources such as Key Vaults from your customizer scripts.</p>Be aware, the user assigned identity specified in the 'userMsiName' parameter must have the 'Managed Identity Operator' role assignment on all the user assigned identities specified in this parameter for Azure Image Builder to be able to associate them to the build VM. |
| [`userMsiResourceGroup`](#parameter-usermsiresourcegroup) | string | Resource group of the user assigned identity. |
| [`vmSize`](#parameter-vmsize) | string | Specifies the size for the VM. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to generate a unique image template name. |

### Parameter: `customizationSteps`

Customization steps to be run when building the VM image.

- Required: Yes
- Type: array

### Parameter: `imageSource`

Image source definition in object format.

- Required: Yes
- Type: object

### Parameter: `name`

Name prefix of the Image Template to be built by the Azure Image Builder service.

- Required: Yes
- Type: string

### Parameter: `userMsiName`

Name of the User Assigned Identity to be used to deploy Image Templates in Azure Image Builder.

- Required: Yes
- Type: string

### Parameter: `buildTimeoutInMinutes`

Image build timeout in minutes. Allowed values: 0-960. 0 means the default 240 minutes.

- Required: No
- Type: int
- Default: `0`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `excludeFromLatest`

Exclude the created Azure Compute Gallery image version from the latest.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `imageReplicationRegions`

List of the regions the image produced by this solution should be stored in the Shared Image Gallery. When left empty, the deployment's location will be taken as a default value.

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

### Parameter: `managedImageName`

Name of the managed image that will be created in the AIB resourcegroup.

- Required: No
- Type: string
- Default: `''`

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

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

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

### Parameter: `sigImageDefinitionId`

Resource ID of Shared Image Gallery to distribute image to, e.g.: /subscriptions/<subscriptionID>/resourceGroups/<SIG resourcegroup>/providers/Microsoft.Compute/galleries/<SIG name>/images/<image definition>.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sigImageVersion`

Version of the Shared Image Gallery Image. Supports the following Version Syntax: Major.Minor.Build (i.e., '1.1.1' or '10.1.2').

- Required: No
- Type: string
- Default: `''`

### Parameter: `stagingResourceGroup`

Resource ID of the staging resource group in the same subscription and location as the image template that will be used to build the image.</p>If this field is empty, a resource group with a random name will be created.</p>If the resource group specified in this field doesn't exist, it will be created with the same name.</p>If the resource group specified exists, it must be empty and in the same region as the image template.</p>The resource group created will be deleted during template deletion if this field is empty or the resource group specified doesn't exist,</p>but if the resource group specified exists the resources created in the resource group will be deleted during template deletion and the resource group itself will remain.

- Required: No
- Type: string
- Default: `''`

### Parameter: `storageAccountType`

Storage account type to be used to store the image in the Azure Compute Gallery.

- Required: No
- Type: string
- Default: `'Standard_LRS'`
- Allowed:
  ```Bicep
  [
    'Standard_LRS'
    'Standard_ZRS'
  ]
  ```

### Parameter: `subnetId`

Resource ID of an already existing subnet, e.g.: /subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>.</p>If no value is provided, a new temporary VNET and subnet will be created in the staging resource group and will be deleted along with the remaining temporary resources.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `unManagedImageName`

Name of the unmanaged image that will be created in the AIB resourcegroup.

- Required: No
- Type: string
- Default: `''`

### Parameter: `userAssignedIdentities`

List of User-Assigned Identities associated to the Build VM for accessing Azure resources such as Key Vaults from your customizer scripts.</p>Be aware, the user assigned identity specified in the 'userMsiName' parameter must have the 'Managed Identity Operator' role assignment on all the user assigned identities specified in this parameter for Azure Image Builder to be able to associate them to the build VM.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `userMsiResourceGroup`

Resource group of the user assigned identity.

- Required: No
- Type: string
- Default: `[resourceGroup().name]`

### Parameter: `vmSize`

Specifies the size for the VM.

- Required: No
- Type: string
- Default: `'Standard_D2s_v3'`

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
