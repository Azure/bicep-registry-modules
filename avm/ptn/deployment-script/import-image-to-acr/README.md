# import-image-to-acr `[DeploymentScript/ImportImageToAcr]`

This modules deployes an image to an Azure Container Registry.

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
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/deployment-script/import-image-to-acr:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module importImageToAcr 'br/public:avm/ptn/deployment-script/import-image-to-acr:<version>' = {
  name: 'importImageToAcrDeployment'
  params: {
    // Required parameters
    acrName: '<acrName>'
    image: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    name: 'dsiitamin001'
    // Non-required parameters
    location: '<location>'
    overwriteExistingImage: '<overwriteExistingImage>'
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
    "acrName": {
      "value": "<acrName>"
    },
    "image": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "name": {
      "value": "dsiitamin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "overwriteExistingImage": {
      "value": "<overwriteExistingImage>"
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
module importImageToAcr 'br/public:avm/ptn/deployment-script/import-image-to-acr:<version>' = {
  name: 'importImageToAcrDeployment'
  params: {
    // Required parameters
    acrName: '<acrName>'
    image: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    name: 'dsiitamax001'
    // Non-required parameters
    assignRbacRole: true
    cleanupPreference: 'OnExpiration'
    location: '<location>'
    managedIdentities: '<managedIdentities>'
    newImageName: 'your-image-name:tag'
    overwriteExistingImage: true
    storageAccountResourceId: '<storageAccountResourceId>'
    subnetResourceIds: '<subnetResourceIds>'
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
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
    "acrName": {
      "value": "<acrName>"
    },
    "image": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "name": {
      "value": "dsiitamax001"
    },
    // Non-required parameters
    "assignRbacRole": {
      "value": true
    },
    "cleanupPreference": {
      "value": "OnExpiration"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": "<managedIdentities>"
    },
    "newImageName": {
      "value": "your-image-name:tag"
    },
    "overwriteExistingImage": {
      "value": true
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "subnetResourceIds": {
      "value": "<subnetResourceIds>"
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
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
module importImageToAcr 'br/public:avm/ptn/deployment-script/import-image-to-acr:<version>' = {
  name: 'importImageToAcrDeployment'
  params: {
    // Required parameters
    acrName: '<acrName>'
    image: 'mcr.microsoft.com/k8se/quickstart-jobs:latest'
    name: 'dsiitawaf001'
    // Non-required parameters
    location: '<location>'
    managedIdentities: '<managedIdentities>'
    overwriteExistingImage: true
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
    "acrName": {
      "value": "<acrName>"
    },
    "image": {
      "value": "mcr.microsoft.com/k8se/quickstart-jobs:latest"
    },
    "name": {
      "value": "dsiitawaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": "<managedIdentities>"
    },
    "overwriteExistingImage": {
      "value": true
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
| [`acrName`](#parameter-acrname) | string | The name of the Azure Container Registry. |
| [`image`](#parameter-image) | string | A fully qualified image name to import. |
| [`name`](#parameter-name) | string | The name of the deployment script resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Required if `assignRbacRole` is `true` and `managedIdentityName` is `null`. |
| [`managedIdentityName`](#parameter-managedidentityname) | string | Name of the Managed Identity resource to create. Required if `assignRbacRole` is `true` and `managedIdentities` is `null`. Defaults to `id-ContainerRegistryImport`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignRbacRole`](#parameter-assignrbacrole) | bool | If set, the `Contributor` role will be granted to the managed identity (passed by the `managedIdentities` parameter or create with the name specified in parameter `managedIdentityName`), which is needed to import images into the Azure Container Registry. Defaults to `true`. |
| [`cleanupPreference`](#parameter-cleanuppreference) | string | When the script resource is cleaned up. Default is OnExpiration and the cleanup time is after 1h. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`initialScriptDelay`](#parameter-initialscriptdelay) | int | A delay in seconds before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate. Default is 30s. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`newImageName`](#parameter-newimagename) | string | The new image name in the ACR. You can use this to import a publically available image with a custom name for later updating from e.g., your build pipeline. |
| [`overwriteExistingImage`](#parameter-overwriteexistingimage) | bool | The image will be overwritten if it already exists in the ACR with the same tag. Default is false. |
| [`retryMax`](#parameter-retrymax) | int | The maximum number of retries for the script import operation. Default is 3. |
| [`runOnce`](#parameter-runonce) | bool | How the deployment script should be forced to execute. Default is to force the script to deploy the image to run every time. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | The resource id of the storage account to use for the deployment script. An existing storage account is needed, if PrivateLink is going to be used for the deployment script. |
| [`subnetResourceIds`](#parameter-subnetresourceids) | array | The subnet ids to use for the deployment script. An existing subnet is needed, if PrivateLink is going to be used for the deployment script. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `acrName`

The name of the Azure Container Registry.

- Required: Yes
- Type: string

### Parameter: `image`

A fully qualified image name to import.

- Required: Yes
- Type: string
- Example: `mcr.microsoft.com/k8se/quickstart-jobs:latest`

### Parameter: `name`

The name of the deployment script resource.

- Required: Yes
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource. Required if `assignRbacRole` is `true` and `managedIdentityName` is `null`.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourcesIds`](#parameter-managedidentitiesuserassignedresourcesids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourcesIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `managedIdentityName`

Name of the Managed Identity resource to create. Required if `assignRbacRole` is `true` and `managedIdentities` is `null`. Defaults to `id-ContainerRegistryImport`.

- Required: No
- Type: string

### Parameter: `assignRbacRole`

If set, the `Contributor` role will be granted to the managed identity (passed by the `managedIdentities` parameter or create with the name specified in parameter `managedIdentityName`), which is needed to import images into the Azure Container Registry. Defaults to `true`.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `cleanupPreference`

When the script resource is cleaned up. Default is OnExpiration and the cleanup time is after 1h.

- Required: No
- Type: string
- Default: `'OnExpiration'`
- Allowed:
  ```Bicep
  [
    'Always'
    'OnExpiration'
    'OnSuccess'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `initialScriptDelay`

A delay in seconds before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate. Default is 30s.

- Required: No
- Type: int
- Default: `30`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `newImageName`

The new image name in the ACR. You can use this to import a publically available image with a custom name for later updating from e.g., your build pipeline.

- Required: No
- Type: string
- Default: `[last(split(parameters('image'), '/'))]`
- Example: `your-image-name:tag`

### Parameter: `overwriteExistingImage`

The image will be overwritten if it already exists in the ACR with the same tag. Default is false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `retryMax`

The maximum number of retries for the script import operation. Default is 3.

- Required: No
- Type: int
- Default: `3`

### Parameter: `runOnce`

How the deployment script should be forced to execute. Default is to force the script to deploy the image to run every time.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `storageAccountResourceId`

The resource id of the storage account to use for the deployment script. An existing storage account is needed, if PrivateLink is going to be used for the deployment script.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subnetResourceIds`

The subnet ids to use for the deployment script. An existing subnet is needed, if PrivateLink is going to be used for the deployment script.

- Required: No
- Type: array

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Example:
  ```Bicep
  {
      "key1": "value1"
      "key2": "value2"
  }
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `deploymentScriptOutput` | array | The script output of each image import. |
| `importedImage` |  | An array of the imported images. |
| `resourceGroupName` | string | The resource group the deployment script was deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/resources/deployment-script:0.2.3` | Remote reference |

## Notes

The deployment script service will need and provision a Storage Account as well as a Container Instance to execute the provided script. _The deployment script resource is available only in the regions where Azure Container Instances is available._

> The service cleans up these resources after the deployment script finishes. You incur charges for these resources until they're removed.

### Private network access

Using a Container Registry that is not available via public network access is possible as well. In this case a subnet needs to be passed to the module. A working configuration is in the max examples for this module.

Links:

- [Access a private virtual network from a Bicep deployment script](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet)
- [Run Bicep deployment script privately over a private endpoint](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet-private-endpoint)

### Renaming the image

In the case an image is updated later from a pipeline, it can makes sense to initially upload a dummy image from e.g. a public registry. However, you might want to change the name and tag from that image for processes to pick up the image before **your image** has actually be published to the registry.

The pattern module [avm/ptn/app/container-job](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/authorization/policy-assignment) uses this module to create the job initially with an image that is available, which most likely will be updated later and the job will pick up the new image then.

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
