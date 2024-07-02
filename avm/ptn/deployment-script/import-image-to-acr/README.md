# import-image-to-acr `[Microsoft.deploymentscript/importimagetoacr]`

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
| `Microsoft.Authorization/roleAssignments` | [2020-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/roleAssignments) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/deployment-script/import-image-to-acr:<version>`.

- [min](#example-1-min)
- [max](#example-2-max)
- [waf-aligned](#example-3-waf-aligned)

### Example 1: _min_

This instance deployes the module with default parameters.


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
      "value": "dsiitamin001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "overwriteExistingImage": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 2: _max_

This instance deployes the module with most parameters and Private Link enabled.


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
    cleanupPreference: 'OnExpiration'
    existingManagedIdentityResourceGroupName: '<existingManagedIdentityResourceGroupName>'
    existingManagedIdentitySubId: '<existingManagedIdentitySubId>'
    location: '<location>'
    managedIdentityName: '<managedIdentityName>'
    overwriteExistingImage: true
    storageAccountName: '<storageAccountName>'
    subnetId: '<subnetId>'
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    useExistingManagedIdentity: true
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
    "cleanupPreference": {
      "value": "OnExpiration"
    },
    "existingManagedIdentityResourceGroupName": {
      "value": "<existingManagedIdentityResourceGroupName>"
    },
    "existingManagedIdentitySubId": {
      "value": "<existingManagedIdentitySubId>"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentityName": {
      "value": "<managedIdentityName>"
    },
    "overwriteExistingImage": {
      "value": true
    },
    "storageAccountName": {
      "value": "<storageAccountName>"
    },
    "subnetId": {
      "value": "<subnetId>"
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "useExistingManagedIdentity": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 3: _waf-aligned_

This instance deployes the module in a WAF-aligned way.


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
    existingManagedIdentityResourceGroupName: '<existingManagedIdentityResourceGroupName>'
    existingManagedIdentitySubId: '<existingManagedIdentitySubId>'
    location: '<location>'
    managedIdentityName: '<managedIdentityName>'
    overwriteExistingImage: true
    useExistingManagedIdentity: true
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
    "existingManagedIdentityResourceGroupName": {
      "value": "<existingManagedIdentityResourceGroupName>"
    },
    "existingManagedIdentitySubId": {
      "value": "<existingManagedIdentitySubId>"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentityName": {
      "value": "<managedIdentityName>"
    },
    "overwriteExistingImage": {
      "value": true
    },
    "useExistingManagedIdentity": {
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
| [`existingManagedIdentityResourceGroupName`](#parameter-existingmanagedidentityresourcegroupname) | string | For an existing Managed Identity, the Resource Group it is located in. Default is the current resource group. Required if `useExistingManagedIdentity` is `true`. Defaults to the current resource group. |
| [`existingManagedIdentitySubId`](#parameter-existingmanagedidentitysubid) | string | For an existing Managed Identity, the Subscription Id it is located in. Default is the current subscription. Required if `useExistingManagedIdentity` is `true`. Defaults to the curent subscription. |
| [`managedIdentityName`](#parameter-managedidentityname) | string | Name of the Managed Identity resource to create. Required if `useExistingManagedIdentity` is `true`. Defaults to `id-ContainerRegistryImport`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cleanupPreference`](#parameter-cleanuppreference) | string | When the script resource is cleaned up. Default is OnExpiration and the cleanup time is after 1h. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`forceUpdateTag`](#parameter-forceupdatetag) | string | How the deployment script should be forced to execute. Default is to force the script to deploy the image to run every time. |
| [`initialScriptDelay`](#parameter-initialscriptdelay) | int | A delay in seconds before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate. Default is 30s. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`overwriteExistingImage`](#parameter-overwriteexistingimage) | bool | The image will be overwritten if it already exists in the ACR with the same tag. Default is false. |
| [`rbacRoleNeeded`](#parameter-rbacroleneeded) | string | Azure RoleId that are required for the DeploymentScript resource to import images. Default is AcrPush, which is needed to import into an ACR. |
| [`retryMax`](#parameter-retrymax) | int | The maximum number of retries for the script import operation. Default is 3. |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the storage account to use for the deployment script. An existing storage account is needed, if PrivateLink is going to be used for the deployment script. |
| [`subnetId`](#parameter-subnetid) | string | The subnet id to use for the deployment script. An existing subnet is needed, if PrivateLink is going to be used for the deployment script. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`useExistingManagedIdentity`](#parameter-useexistingmanagedidentity) | bool | Does the Managed Identity already exists, or should be created. Default is false. |

### Parameter: `acrName`

The name of the Azure Container Registry.

- Required: Yes
- Type: string

### Parameter: `image`

A fully qualified image name to import.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the deployment script resource.

- Required: Yes
- Type: string

### Parameter: `existingManagedIdentityResourceGroupName`

For an existing Managed Identity, the Resource Group it is located in. Default is the current resource group. Required if `useExistingManagedIdentity` is `true`. Defaults to the current resource group.

- Required: No
- Type: string
- Default: `[resourceGroup().name]`

### Parameter: `existingManagedIdentitySubId`

For an existing Managed Identity, the Subscription Id it is located in. Default is the current subscription. Required if `useExistingManagedIdentity` is `true`. Defaults to the curent subscription.

- Required: No
- Type: string
- Default: `[subscription().subscriptionId]`

### Parameter: `managedIdentityName`

Name of the Managed Identity resource to create. Required if `useExistingManagedIdentity` is `true`. Defaults to `id-ContainerRegistryImport`.

- Required: No
- Type: string
- Default: `'id-ContainerRegistryImport'`

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

### Parameter: `forceUpdateTag`

How the deployment script should be forced to execute. Default is to force the script to deploy the image to run every time.

- Required: No
- Type: string
- Default: `[utcNow()]`

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

### Parameter: `overwriteExistingImage`

The image will be overwritten if it already exists in the ACR with the same tag. Default is false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `rbacRoleNeeded`

Azure RoleId that are required for the DeploymentScript resource to import images. Default is AcrPush, which is needed to import into an ACR.

- Required: No
- Type: string
- Default: `'b24988ac-6180-42a0-ab88-20f7382dd24c'`

### Parameter: `retryMax`

The maximum number of retries for the script import operation. Default is 3.

- Required: No
- Type: int
- Default: `3`

### Parameter: `storageAccountName`

The name of the storage account to use for the deployment script. An existing storage account is needed, if PrivateLink is going to be used for the deployment script.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subnetId`

The subnet id to use for the deployment script. An existing subnet is needed, if PrivateLink is going to be used for the deployment script.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `useExistingManagedIdentity`

Does the Managed Identity already exists, or should be created. Default is false.

- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `deploymentScriptOutput` | array | The script output of each image import. |
| `importedImage` |  | An array of the imported images. |
| `resourceGroupName` | string | The resource group the deployment script was deployed into. |

## Cross-referenced modules

_None_

## Notes

The deployment script service will need and provision a Storage Account as well as a Container Instance to execute the provided script. *The deployment script resource is available only in the regions where Azure Container Instances is available.*

> The service cleans up these resources after the deployment script finishes. You incur charges for these resources until they're removed.

Using a Container Registry that is not available via public network access is possible as well. In this case a subnet needs to be passed to the module. A working configuration is in the max examples for this module.

Links:

- [Access a private virtual network from a Bicep deployment script](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet)
- [Run Bicep deployment script privately over a private endpoint](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet-private-endpoint)

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
