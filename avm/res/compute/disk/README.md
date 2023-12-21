# Compute Disks `[Microsoft.Compute/disks]`

This module deploys a Compute Disk

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
| `Microsoft.Compute/disks` | [2022-07-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-07-02/disks) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/compute.disk:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Image](#example-2-image)
- [Import](#example-3-import)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module disk 'br:bicep/modules/compute.disk:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cdmin'
  params: {
    // Required parameters
    name: 'cdmin001'
    sku: 'Standard_LRS'
    // Non-required parameters
    diskSizeGB: 1
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
      "value": "cdmin001"
    },
    "sku": {
      "value": "Standard_LRS"
    },
    // Non-required parameters
    "diskSizeGB": {
      "value": 1
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Image_

<details>

<summary>via Bicep module</summary>

```bicep
module disk 'br:bicep/modules/compute.disk:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cdimg'
  params: {
    // Required parameters
    name: 'cdimg001'
    sku: 'Standard_LRS'
    // Non-required parameters
    createOption: 'FromImage'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    imageReferenceId: '<imageReferenceId>'
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
      "value": "cdimg001"
    },
    "sku": {
      "value": "Standard_LRS"
    },
    // Non-required parameters
    "createOption": {
      "value": "FromImage"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "imageReferenceId": {
      "value": "<imageReferenceId>"
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

### Example 3: _Import_

<details>

<summary>via Bicep module</summary>

```bicep
module disk 'br:bicep/modules/compute.disk:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cdimp'
  params: {
    // Required parameters
    name: 'cdimp001'
    sku: 'Standard_LRS'
    // Non-required parameters
    createOption: 'Import'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    sourceUri: '<sourceUri>'
    storageAccountId: '<storageAccountId>'
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
      "value": "cdimp001"
    },
    "sku": {
      "value": "Standard_LRS"
    },
    // Non-required parameters
    "createOption": {
      "value": "Import"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
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
    "sourceUri": {
      "value": "<sourceUri>"
    },
    "storageAccountId": {
      "value": "<storageAccountId>"
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

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module disk 'br:bicep/modules/compute.disk:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cdmax'
  params: {
    // Required parameters
    name: 'cdmax001'
    sku: 'UltraSSD_LRS'
    // Non-required parameters
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 60
    diskSizeGB: 128
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    logicalSectorSize: 512
    osType: 'Windows'
    publicNetworkAccess: 'Enabled'
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
      "value": "cdmax001"
    },
    "sku": {
      "value": "UltraSSD_LRS"
    },
    // Non-required parameters
    "diskIOPSReadWrite": {
      "value": 500
    },
    "diskMBpsReadWrite": {
      "value": 60
    },
    "diskSizeGB": {
      "value": 128
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "logicalSectorSize": {
      "value": 512
    },
    "osType": {
      "value": "Windows"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
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

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module disk 'br:bicep/modules/compute.disk:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-cdwaf'
  params: {
    // Required parameters
    name: 'cdwaf001'
    sku: 'UltraSSD_LRS'
    // Non-required parameters
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 60
    diskSizeGB: 128
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    logicalSectorSize: 512
    osType: 'Windows'
    publicNetworkAccess: 'Enabled'
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
      "value": "cdwaf001"
    },
    "sku": {
      "value": "UltraSSD_LRS"
    },
    // Non-required parameters
    "diskIOPSReadWrite": {
      "value": 500
    },
    "diskMBpsReadWrite": {
      "value": 60
    },
    "diskSizeGB": {
      "value": 128
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "logicalSectorSize": {
      "value": 512
    },
    "osType": {
      "value": "Windows"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
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
| [`name`](#parameter-name) | string | The name of the disk that is being created. |
| [`sku`](#parameter-sku) | string | The disks sku name. Can be . |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diskSizeGB`](#parameter-disksizegb) | int | The size of the disk to create. Required if create option is Empty. |
| [`storageAccountId`](#parameter-storageaccountid) | string | The resource ID of the storage account containing the blob to import as a disk. Required if create option is Import. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acceleratedNetwork`](#parameter-acceleratednetwork) | bool | True if the image from which the OS disk is created supports accelerated networking. |
| [`architecture`](#parameter-architecture) | string | CPU architecture supported by an OS disk. |
| [`burstingEnabled`](#parameter-burstingenabled) | bool | Set to true to enable bursting beyond the provisioned performance target of the disk. |
| [`completionPercent`](#parameter-completionpercent) | int | Percentage complete for the background copy when a resource is created via the CopyStart operation. |
| [`createOption`](#parameter-createoption) | string | Sources of a disk creation. |
| [`diskIOPSReadWrite`](#parameter-diskiopsreadwrite) | int | The number of IOPS allowed for this disk; only settable for UltraSSD disks. |
| [`diskMBpsReadWrite`](#parameter-diskmbpsreadwrite) | int | The bandwidth allowed for this disk; only settable for UltraSSD disks. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`hyperVGeneration`](#parameter-hypervgeneration) | string | The hypervisor generation of the Virtual Machine. Applicable to OS disks only. |
| [`imageReferenceId`](#parameter-imagereferenceid) | string | A relative uri containing either a Platform Image Repository or user image reference. |
| [`location`](#parameter-location) | string | Resource location. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`logicalSectorSize`](#parameter-logicalsectorsize) | int | Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096. |
| [`maxShares`](#parameter-maxshares) | int | The maximum number of VMs that can attach to the disk at the same time. Default value is 0. |
| [`networkAccessPolicy`](#parameter-networkaccesspolicy) | string | Policy for accessing the disk via network. |
| [`optimizedForFrequentAttach`](#parameter-optimizedforfrequentattach) | bool | Setting this property to true improves reliability and performance of data disks that are frequently (more than 5 times a day) by detached from one virtual machine and attached to another. This property should not be set for disks that are not detached and attached frequently as it causes the disks to not align with the fault domain of the virtual machine. |
| [`osType`](#parameter-ostype) | string | Sources of a disk creation. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Policy for controlling export on the disk. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`securityDataUri`](#parameter-securitydatauri) | string | If create option is ImportSecure, this is the URI of a blob to be imported into VM guest state. |
| [`sourceResourceId`](#parameter-sourceresourceid) | string | If create option is Copy, this is the ARM ID of the source snapshot or disk. |
| [`sourceUri`](#parameter-sourceuri) | string | If create option is Import, this is the URI of a blob to be imported into a managed disk. |
| [`tags`](#parameter-tags) | object | Tags of the availability set resource. |
| [`uploadSizeBytes`](#parameter-uploadsizebytes) | int | If create option is Upload, this is the size of the contents of the upload including the VHD footer. |

### Parameter: `name`

The name of the disk that is being created.

- Required: Yes
- Type: string

### Parameter: `sku`

The disks sku name. Can be .

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
    'Premium_ZRS'
    'PremiumV2_LRS'
    'Standard_LRS'
    'StandardSSD_LRS'
    'UltraSSD_LRS'
  ]
  ```

### Parameter: `diskSizeGB`

The size of the disk to create. Required if create option is Empty.

- Required: No
- Type: int
- Default: `0`

### Parameter: `storageAccountId`

The resource ID of the storage account containing the blob to import as a disk. Required if create option is Import.

- Required: No
- Type: string
- Default: `''`

### Parameter: `acceleratedNetwork`

True if the image from which the OS disk is created supports accelerated networking.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `architecture`

CPU architecture supported by an OS disk.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Arm64'
    'x64'
  ]
  ```

### Parameter: `burstingEnabled`

Set to true to enable bursting beyond the provisioned performance target of the disk.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `completionPercent`

Percentage complete for the background copy when a resource is created via the CopyStart operation.

- Required: No
- Type: int
- Default: `100`

### Parameter: `createOption`

Sources of a disk creation.

- Required: No
- Type: string
- Default: `'Empty'`
- Allowed:
  ```Bicep
  [
    'Attach'
    'Copy'
    'CopyStart'
    'Empty'
    'FromImage'
    'Import'
    'ImportSecure'
    'Restore'
    'Upload'
    'UploadPreparedSecure'
  ]
  ```

### Parameter: `diskIOPSReadWrite`

The number of IOPS allowed for this disk; only settable for UltraSSD disks.

- Required: No
- Type: int
- Default: `0`

### Parameter: `diskMBpsReadWrite`

The bandwidth allowed for this disk; only settable for UltraSSD disks.

- Required: No
- Type: int
- Default: `0`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hyperVGeneration`

The hypervisor generation of the Virtual Machine. Applicable to OS disks only.

- Required: No
- Type: string
- Default: `'V2'`
- Allowed:
  ```Bicep
  [
    'V1'
    'V2'
  ]
  ```

### Parameter: `imageReferenceId`

A relative uri containing either a Platform Image Repository or user image reference.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Resource location.

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

### Parameter: `logicalSectorSize`

Logical sector size in bytes for Ultra disks. Supported values are 512 ad 4096.

- Required: No
- Type: int
- Default: `4096`

### Parameter: `maxShares`

The maximum number of VMs that can attach to the disk at the same time. Default value is 0.

- Required: No
- Type: int
- Default: `1`

### Parameter: `networkAccessPolicy`

Policy for accessing the disk via network.

- Required: No
- Type: string
- Default: `'DenyAll'`
- Allowed:
  ```Bicep
  [
    'AllowAll'
    'AllowPrivate'
    'DenyAll'
  ]
  ```

### Parameter: `optimizedForFrequentAttach`

Setting this property to true improves reliability and performance of data disks that are frequently (more than 5 times a day) by detached from one virtual machine and attached to another. This property should not be set for disks that are not detached and attached frequently as it causes the disks to not align with the fault domain of the virtual machine.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `osType`

Sources of a disk creation.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Linux'
    'Windows'
  ]
  ```

### Parameter: `publicNetworkAccess`

Policy for controlling export on the disk.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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

### Parameter: `securityDataUri`

If create option is ImportSecure, this is the URI of a blob to be imported into VM guest state.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceResourceId`

If create option is Copy, this is the ARM ID of the source snapshot or disk.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceUri`

If create option is Import, this is the URI of a blob to be imported into a managed disk.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the availability set resource.

- Required: No
- Type: object

### Parameter: `uploadSizeBytes`

If create option is Upload, this is the size of the contents of the upload including the VHD footer.

- Required: No
- Type: int
- Default: `20972032`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the disk. |
| `resourceGroupName` | string | The resource group the  disk was deployed into. |
| `resourceId` | string | The resource ID of the disk. |

## Cross-referenced modules

_None_
