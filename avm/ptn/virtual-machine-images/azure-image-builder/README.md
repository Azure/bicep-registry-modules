# Custom Images using Azure Image Builder `[VirtualMachineImages/AzureImageBuilder]`

This module provides you with a packaged solution to create custom images using the Azure Image Builder service publishing to an Azure Compute Gallery.

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
| `Microsoft.Compute/galleries` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries) |
| `Microsoft.Compute/galleries/applications` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/applications) |
| `Microsoft.Compute/galleries/images` | [2022-03-03](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-03-03/galleries/images) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Resources/resourceGroups` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2024-03-01/resourceGroups) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices/tables) |
| `Microsoft.VirtualMachineImages/imageTemplates` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.VirtualMachineImages/imageTemplates) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/virtual-machine-images/azure-image-builder:<version>`.

- [Using small parameter set](#example-1-using-small-parameter-set)
- [Deploying all resources](#example-2-deploying-all-resources)
- [Deploying only the assets & image](#example-3-deploying-only-the-assets-image)
- [Deploying only the base services](#example-4-deploying-only-the-base-services)
- [Deploying only the image](#example-5-deploying-only-the-image)

### Example 1: _Using small parameter set_

This instance deploys the module with min features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module azureImageBuilder 'br/public:avm/ptn/virtual-machine-images/azure-image-builder:<version>' = {
  name: 'azureImageBuilderDeployment'
  params: {
    // Required parameters
    computeGalleryImageDefinitionName: '<computeGalleryImageDefinitionName>'
    computeGalleryImageDefinitions: [
      {
        hyperVGeneration: 'V2'
        name: 'sid-linux'
        offer: 'devops_linux'
        osType: 'Linux'
        publisher: 'devops'
        sku: 'devops_linux_az'
      }
    ]
    computeGalleryName: 'galapvmiaibmin'
    imageTemplateImageSource: {
      offer: 'ubuntu-24_04-lts'
      publisher: 'canonical'
      sku: 'server'
      type: 'PlatformImage'
      version: 'latest'
    }
    // Non-required parameters
    assetsStorageAccountName: 'stapvmiaibmin'
    deploymentsToPerform: '<deploymentsToPerform>'
    location: '<location>'
    resourceGroupName: '<resourceGroupName>'
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
    "computeGalleryImageDefinitionName": {
      "value": "<computeGalleryImageDefinitionName>"
    },
    "computeGalleryImageDefinitions": {
      "value": [
        {
          "hyperVGeneration": "V2",
          "name": "sid-linux",
          "offer": "devops_linux",
          "osType": "Linux",
          "publisher": "devops",
          "sku": "devops_linux_az"
        }
      ]
    },
    "computeGalleryName": {
      "value": "galapvmiaibmin"
    },
    "imageTemplateImageSource": {
      "value": {
        "offer": "ubuntu-24_04-lts",
        "publisher": "canonical",
        "sku": "server",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    // Non-required parameters
    "assetsStorageAccountName": {
      "value": "stapvmiaibmin"
    },
    "deploymentsToPerform": {
      "value": "<deploymentsToPerform>"
    },
    "location": {
      "value": "<location>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    }
  }
}
```

</details>
<p>

### Example 2: _Deploying all resources_

This instance deploys the module with the conditions set up to deploy all resource and build the image.


<details>

<summary>via Bicep module</summary>

```bicep
module azureImageBuilder 'br/public:avm/ptn/virtual-machine-images/azure-image-builder:<version>' = {
  name: 'azureImageBuilderDeployment'
  params: {
    // Required parameters
    computeGalleryImageDefinitionName: '<computeGalleryImageDefinitionName>'
    computeGalleryImageDefinitions: [
      {
        hyperVGeneration: 'V2'
        name: '<name>'
        offer: 'devops_linux'
        osType: 'Linux'
        publisher: 'devops'
        sku: 'devops_linux_az'
      }
    ]
    computeGalleryName: 'galapvmiaiba'
    imageTemplateImageSource: {
      offer: '0001-com-ubuntu-server-jammy'
      publisher: 'canonical'
      sku: '22_04-lts-gen2'
      type: 'PlatformImage'
      version: 'latest'
    }
    // Non-required parameters
    assetsStorageAccountContainerName: '<assetsStorageAccountContainerName>'
    assetsStorageAccountName: '<assetsStorageAccountName>'
    deploymentsToPerform: '<deploymentsToPerform>'
    imageTemplateCustomizationSteps: [
      {
        name: 'PowerShell installation'
        scriptUri: '<scriptUri>'
        type: 'Shell'
      }
      {
        destination: '<destination>'
        name: '<name>'
        sourceUri: '<sourceUri>'
        type: 'File'
      }
      {
        inline: [
          'pwsh \'<value>\''
        ]
        name: 'Software installation'
        type: 'Shell'
      }
    ]
    location: '<location>'
    resourceGroupName: '<resourceGroupName>'
    storageAccountFilesToUpload: [
      {
        name: '<name>'
        value: '<value>'
      }
      {
        name: '<name>'
        value: '<value>'
      }
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
    "computeGalleryImageDefinitionName": {
      "value": "<computeGalleryImageDefinitionName>"
    },
    "computeGalleryImageDefinitions": {
      "value": [
        {
          "hyperVGeneration": "V2",
          "name": "<name>",
          "offer": "devops_linux",
          "osType": "Linux",
          "publisher": "devops",
          "sku": "devops_linux_az"
        }
      ]
    },
    "computeGalleryName": {
      "value": "galapvmiaiba"
    },
    "imageTemplateImageSource": {
      "value": {
        "offer": "0001-com-ubuntu-server-jammy",
        "publisher": "canonical",
        "sku": "22_04-lts-gen2",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    // Non-required parameters
    "assetsStorageAccountContainerName": {
      "value": "<assetsStorageAccountContainerName>"
    },
    "assetsStorageAccountName": {
      "value": "<assetsStorageAccountName>"
    },
    "deploymentsToPerform": {
      "value": "<deploymentsToPerform>"
    },
    "imageTemplateCustomizationSteps": {
      "value": [
        {
          "name": "PowerShell installation",
          "scriptUri": "<scriptUri>",
          "type": "Shell"
        },
        {
          "destination": "<destination>",
          "name": "<name>",
          "sourceUri": "<sourceUri>",
          "type": "File"
        },
        {
          "inline": [
            "pwsh \"<value>\""
          ],
          "name": "Software installation",
          "type": "Shell"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "storageAccountFilesToUpload": {
      "value": [
        {
          "name": "<name>",
          "value": "<value>"
        },
        {
          "name": "<name>",
          "value": "<value>"
        }
      ]
    }
  }
}
```

</details>
<p>

### Example 3: _Deploying only the assets & image_

This instance deploys the module with the conditions set up to only update the assets on the assets storage account and build the image, assuming all dependencies are setup.


<details>

<summary>via Bicep module</summary>

```bicep
module azureImageBuilder 'br/public:avm/ptn/virtual-machine-images/azure-image-builder:<version>' = {
  name: 'azureImageBuilderDeployment'
  params: {
    // Required parameters
    computeGalleryImageDefinitionName: '<computeGalleryImageDefinitionName>'
    computeGalleryImageDefinitions: '<computeGalleryImageDefinitions>'
    computeGalleryName: '<computeGalleryName>'
    imageTemplateImageSource: {
      offer: 'ubuntu-24_04-lts'
      publisher: 'canonical'
      sku: 'server'
      type: 'PlatformImage'
      version: 'latest'
    }
    // Non-required parameters
    assetsStorageAccountContainerName: '<assetsStorageAccountContainerName>'
    assetsStorageAccountName: '<assetsStorageAccountName>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptSubnetName: '<deploymentScriptSubnetName>'
    deploymentsToPerform: 'Only assets & image'
    imageManagedIdentityName: '<imageManagedIdentityName>'
    imageSubnetName: '<imageSubnetName>'
    imageTemplateCustomizationSteps: [
      {
        name: 'Example script'
        scriptUri: '<scriptUri>'
        type: 'Shell'
      }
    ]
    imageTemplateResourceGroupName: '<imageTemplateResourceGroupName>'
    location: '<location>'
    resourceGroupName: '<resourceGroupName>'
    storageAccountFilesToUpload: [
      {
        name: '<name>'
        value: '<value>'
      }
    ]
    virtualNetworkName: '<virtualNetworkName>'
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
    "computeGalleryImageDefinitionName": {
      "value": "<computeGalleryImageDefinitionName>"
    },
    "computeGalleryImageDefinitions": {
      "value": "<computeGalleryImageDefinitions>"
    },
    "computeGalleryName": {
      "value": "<computeGalleryName>"
    },
    "imageTemplateImageSource": {
      "value": {
        "offer": "ubuntu-24_04-lts",
        "publisher": "canonical",
        "sku": "server",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    // Non-required parameters
    "assetsStorageAccountContainerName": {
      "value": "<assetsStorageAccountContainerName>"
    },
    "assetsStorageAccountName": {
      "value": "<assetsStorageAccountName>"
    },
    "deploymentScriptManagedIdentityName": {
      "value": "<deploymentScriptManagedIdentityName>"
    },
    "deploymentScriptStorageAccountName": {
      "value": "<deploymentScriptStorageAccountName>"
    },
    "deploymentScriptSubnetName": {
      "value": "<deploymentScriptSubnetName>"
    },
    "deploymentsToPerform": {
      "value": "Only assets & image"
    },
    "imageManagedIdentityName": {
      "value": "<imageManagedIdentityName>"
    },
    "imageSubnetName": {
      "value": "<imageSubnetName>"
    },
    "imageTemplateCustomizationSteps": {
      "value": [
        {
          "name": "Example script",
          "scriptUri": "<scriptUri>",
          "type": "Shell"
        }
      ]
    },
    "imageTemplateResourceGroupName": {
      "value": "<imageTemplateResourceGroupName>"
    },
    "location": {
      "value": "<location>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "storageAccountFilesToUpload": {
      "value": [
        {
          "name": "<name>",
          "value": "<value>"
        }
      ]
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    }
  }
}
```

</details>
<p>

### Example 4: _Deploying only the base services_

This instance deploys the module with the conditions set up to only deploy the base resources, that is everything but the image.


<details>

<summary>via Bicep module</summary>

```bicep
module azureImageBuilder 'br/public:avm/ptn/virtual-machine-images/azure-image-builder:<version>' = {
  name: 'azureImageBuilderDeployment'
  params: {
    // Required parameters
    computeGalleryImageDefinitionName: '<computeGalleryImageDefinitionName>'
    computeGalleryImageDefinitions: [
      {
        hyperVGeneration: 'V2'
        name: '<name>'
        offer: 'devops_linux'
        osType: 'Linux'
        publisher: 'devops'
        sku: 'devops_linux_az'
      }
    ]
    computeGalleryName: 'galapvmiaibob'
    imageTemplateImageSource: {
      offer: 'ubuntu-24_04-lts'
      publisher: 'canonical'
      sku: 'server'
      type: 'PlatformImage'
      version: 'latest'
    }
    // Non-required parameters
    assetsStorageAccountName: 'stapvmiaibob'
    deploymentsToPerform: 'Only base'
    imageManagedIdentityName: 'msi-it-apvmiaibob'
    location: '<location>'
    resourceGroupName: '<resourceGroupName>'
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
    "computeGalleryImageDefinitionName": {
      "value": "<computeGalleryImageDefinitionName>"
    },
    "computeGalleryImageDefinitions": {
      "value": [
        {
          "hyperVGeneration": "V2",
          "name": "<name>",
          "offer": "devops_linux",
          "osType": "Linux",
          "publisher": "devops",
          "sku": "devops_linux_az"
        }
      ]
    },
    "computeGalleryName": {
      "value": "galapvmiaibob"
    },
    "imageTemplateImageSource": {
      "value": {
        "offer": "ubuntu-24_04-lts",
        "publisher": "canonical",
        "sku": "server",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    // Non-required parameters
    "assetsStorageAccountName": {
      "value": "stapvmiaibob"
    },
    "deploymentsToPerform": {
      "value": "Only base"
    },
    "imageManagedIdentityName": {
      "value": "msi-it-apvmiaibob"
    },
    "location": {
      "value": "<location>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    }
  }
}
```

</details>
<p>

### Example 5: _Deploying only the image_

This instance deploys the module with the conditions set up to only deploy and bake the image, assuming all dependencies are setup.


<details>

<summary>via Bicep module</summary>

```bicep
module azureImageBuilder 'br/public:avm/ptn/virtual-machine-images/azure-image-builder:<version>' = {
  name: 'azureImageBuilderDeployment'
  params: {
    // Required parameters
    computeGalleryImageDefinitionName: '<computeGalleryImageDefinitionName>'
    computeGalleryImageDefinitions: '<computeGalleryImageDefinitions>'
    computeGalleryName: '<computeGalleryName>'
    imageTemplateImageSource: {
      offer: 'ubuntu-24_04-lts'
      publisher: 'canonical'
      sku: 'server'
      type: 'PlatformImage'
      version: 'latest'
    }
    // Non-required parameters
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptSubnetName: '<deploymentScriptSubnetName>'
    deploymentsToPerform: 'Only image'
    imageManagedIdentityName: '<imageManagedIdentityName>'
    imageSubnetName: '<imageSubnetName>'
    imageTemplateCustomizationSteps: [
      {
        name: 'Example script'
        scriptUri: '<scriptUri>'
        type: 'Shell'
      }
    ]
    imageTemplateResourceGroupName: '<imageTemplateResourceGroupName>'
    location: '<location>'
    resourceGroupName: '<resourceGroupName>'
    virtualNetworkName: '<virtualNetworkName>'
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
    "computeGalleryImageDefinitionName": {
      "value": "<computeGalleryImageDefinitionName>"
    },
    "computeGalleryImageDefinitions": {
      "value": "<computeGalleryImageDefinitions>"
    },
    "computeGalleryName": {
      "value": "<computeGalleryName>"
    },
    "imageTemplateImageSource": {
      "value": {
        "offer": "ubuntu-24_04-lts",
        "publisher": "canonical",
        "sku": "server",
        "type": "PlatformImage",
        "version": "latest"
      }
    },
    // Non-required parameters
    "deploymentScriptManagedIdentityName": {
      "value": "<deploymentScriptManagedIdentityName>"
    },
    "deploymentScriptStorageAccountName": {
      "value": "<deploymentScriptStorageAccountName>"
    },
    "deploymentScriptSubnetName": {
      "value": "<deploymentScriptSubnetName>"
    },
    "deploymentsToPerform": {
      "value": "Only image"
    },
    "imageManagedIdentityName": {
      "value": "<imageManagedIdentityName>"
    },
    "imageSubnetName": {
      "value": "<imageSubnetName>"
    },
    "imageTemplateCustomizationSteps": {
      "value": [
        {
          "name": "Example script",
          "scriptUri": "<scriptUri>",
          "type": "Shell"
        }
      ]
    },
    "imageTemplateResourceGroupName": {
      "value": "<imageTemplateResourceGroupName>"
    },
    "location": {
      "value": "<location>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
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
| [`computeGalleryImageDefinitionName`](#parameter-computegalleryimagedefinitionname) | string | The name of Image Definition of the Azure Compute Gallery to host the new image version. |
| [`computeGalleryImageDefinitions`](#parameter-computegalleryimagedefinitions) | array | The Image Definitions in the Azure Compute Gallery. |
| [`computeGalleryName`](#parameter-computegalleryname) | string | The name of the Azure Compute Gallery. |
| [`imageTemplateImageSource`](#parameter-imagetemplateimagesource) | object | The image source to use for the Image Template. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assetsStorageAccountContainerName`](#parameter-assetsstorageaccountcontainername) | string | The name of container in the Storage Account. |
| [`assetsStorageAccountName`](#parameter-assetsstorageaccountname) | string | The name of the storage account. Only needed if you want to upload scripts to be used during image baking. |
| [`deploymentScriptManagedIdentityName`](#parameter-deploymentscriptmanagedidentityname) | string | The name of the Managed Identity used by deployment scripts. |
| [`deploymentScriptStorageAccountName`](#parameter-deploymentscriptstorageaccountname) | string | The name of the storage account. |
| [`deploymentScriptSubnetName`](#parameter-deploymentscriptsubnetname) | string | The name of the Image Template Virtual Network Subnet to create. |
| [`deploymentsToPerform`](#parameter-deploymentstoperform) | string | A parameter to control which deployments should be executed. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`imageManagedIdentityName`](#parameter-imagemanagedidentityname) | string | The name of the Managed Identity used by the Azure Image Builder. |
| [`imageSubnetName`](#parameter-imagesubnetname) | string | The name of the Image Template Virtual Network Subnet to create. |
| [`imageTemplateCustomizationSteps`](#parameter-imagetemplatecustomizationsteps) | array | The customization steps to use for the Image Template. |
| [`imageTemplateDeploymentScriptName`](#parameter-imagetemplatedeploymentscriptname) | string | The name of the Deployment Script to trigger the image template baking. |
| [`imageTemplateName`](#parameter-imagetemplatename) | string | The name of the Image Template. |
| [`imageTemplateResourceGroupName`](#parameter-imagetemplateresourcegroupname) | string | The name of the Resource Group to deploy the Image Template resources into. |
| [`location`](#parameter-location) | string | The location to deploy into. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The name of the Resource Group. |
| [`storageAccountFilesToUpload`](#parameter-storageaccountfilestoupload) | array | The files to upload to the Assets Storage Account. |
| [`storageDeploymentScriptName`](#parameter-storagedeploymentscriptname) | string | The name of the Deployment Script to upload files to the assets storage account. |
| [`virtualNetworkAddressPrefix`](#parameter-virtualnetworkaddressprefix) | string | The address space of the Virtual Network. |
| [`virtualNetworkDeploymentScriptSubnetAddressPrefix`](#parameter-virtualnetworkdeploymentscriptsubnetaddressprefix) | string | The address space of the Virtual Network Subnet used by the deployment script. |
| [`virtualNetworkName`](#parameter-virtualnetworkname) | string | The name of the Virtual Network. |
| [`virtualNetworkSubnetAddressPrefix`](#parameter-virtualnetworksubnetaddressprefix) | string | The address space of the Virtual Network Subnet. |
| [`waitDeploymentScriptName`](#parameter-waitdeploymentscriptname) | string | The name of the Deployment Script to wait for for the image baking to conclude. |
| [`waitForImageBuild`](#parameter-waitforimagebuild) | bool | A parameter to control if the deployment should wait for the image build to complete. |
| [`waitForImageBuildTimeout`](#parameter-waitforimagebuildtimeout) | string | A parameter to control the timeout of the deployment script waiting for the image build. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to generate a SAS token to access the modules. |

### Parameter: `computeGalleryImageDefinitionName`

The name of Image Definition of the Azure Compute Gallery to host the new image version.

- Required: Yes
- Type: string

### Parameter: `computeGalleryImageDefinitions`

The Image Definitions in the Azure Compute Gallery.

- Required: Yes
- Type: array

### Parameter: `computeGalleryName`

The name of the Azure Compute Gallery.

- Required: Yes
- Type: string

### Parameter: `imageTemplateImageSource`

The image source to use for the Image Template.

- Required: Yes
- Type: object

### Parameter: `assetsStorageAccountContainerName`

The name of container in the Storage Account.

- Required: No
- Type: string
- Default: `'aibscripts'`

### Parameter: `assetsStorageAccountName`

The name of the storage account. Only needed if you want to upload scripts to be used during image baking.

- Required: No
- Type: string

### Parameter: `deploymentScriptManagedIdentityName`

The name of the Managed Identity used by deployment scripts.

- Required: No
- Type: string
- Default: `'msi-ds'`

### Parameter: `deploymentScriptStorageAccountName`

The name of the storage account.

- Required: No
- Type: string
- Default: `[format('{0}ds', parameters('assetsStorageAccountName'))]`

### Parameter: `deploymentScriptSubnetName`

The name of the Image Template Virtual Network Subnet to create.

- Required: No
- Type: string
- Default: `'subnet-ds'`

### Parameter: `deploymentsToPerform`

A parameter to control which deployments should be executed.

- Required: No
- Type: string
- Default: `'Only assets & image'`
- Allowed:
  ```Bicep
  [
    'All'
    'Only assets & image'
    'Only base'
    'Only image'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `imageManagedIdentityName`

The name of the Managed Identity used by the Azure Image Builder.

- Required: No
- Type: string
- Default: `'msi-aib'`

### Parameter: `imageSubnetName`

The name of the Image Template Virtual Network Subnet to create.

- Required: No
- Type: string
- Default: `'subnet-it'`

### Parameter: `imageTemplateCustomizationSteps`

The customization steps to use for the Image Template.

- Required: No
- Type: array

### Parameter: `imageTemplateDeploymentScriptName`

The name of the Deployment Script to trigger the image template baking.

- Required: No
- Type: string
- Default: `'ds-triggerBuild-imageTemplate'`

### Parameter: `imageTemplateName`

The name of the Image Template.

- Required: No
- Type: string
- Default: `'it-aib'`

### Parameter: `imageTemplateResourceGroupName`

The name of the Resource Group to deploy the Image Template resources into.

- Required: No
- Type: string
- Default: `[format('{0}-image-build', parameters('resourceGroupName'))]`

### Parameter: `location`

The location to deploy into.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `resourceGroupName`

The name of the Resource Group.

- Required: No
- Type: string
- Default: `'rg-ado-agents'`

### Parameter: `storageAccountFilesToUpload`

The files to upload to the Assets Storage Account.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-storageaccountfilestouploadname) | string | The name of the environment variable. |
| [`secureValue`](#parameter-storageaccountfilestouploadsecurevalue) | securestring | The value of the secure environment variable. |
| [`value`](#parameter-storageaccountfilestouploadvalue) | string | The value of the environment variable. |

### Parameter: `storageAccountFilesToUpload.name`

The name of the environment variable.

- Required: Yes
- Type: string

### Parameter: `storageAccountFilesToUpload.secureValue`

The value of the secure environment variable.

- Required: No
- Type: securestring

### Parameter: `storageAccountFilesToUpload.value`

The value of the environment variable.

- Required: No
- Type: string

### Parameter: `storageDeploymentScriptName`

The name of the Deployment Script to upload files to the assets storage account.

- Required: No
- Type: string
- Default: `'ds-triggerUpload-storage'`

### Parameter: `virtualNetworkAddressPrefix`

The address space of the Virtual Network.

- Required: No
- Type: string
- Default: `'10.0.0.0/16'`

### Parameter: `virtualNetworkDeploymentScriptSubnetAddressPrefix`

The address space of the Virtual Network Subnet used by the deployment script.

- Required: No
- Type: string
- Default: `[cidrSubnet(parameters('virtualNetworkAddressPrefix'), 24, 1)]`

### Parameter: `virtualNetworkName`

The name of the Virtual Network.

- Required: No
- Type: string
- Default: `'vnet-it'`

### Parameter: `virtualNetworkSubnetAddressPrefix`

The address space of the Virtual Network Subnet.

- Required: No
- Type: string
- Default: `[cidrSubnet(parameters('virtualNetworkAddressPrefix'), 24, 0)]`

### Parameter: `waitDeploymentScriptName`

The name of the Deployment Script to wait for for the image baking to conclude.

- Required: No
- Type: string
- Default: `'ds-wait-imageTemplate-build'`

### Parameter: `waitForImageBuild`

A parameter to control if the deployment should wait for the image build to complete.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `waitForImageBuildTimeout`

A parameter to control the timeout of the deployment script waiting for the image build.

- Required: No
- Type: string
- Default: `'PT1H'`

### Parameter: `baseTime`

Do not provide a value! This date value is used to generate a SAS token to access the modules.

- Required: No
- Type: string
- Default: `[utcNow()]`

## Outputs

_None_

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/compute/gallery:0.4.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.2.2` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.1.6` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.3.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.9.1` | Remote reference |
| `br/public:avm/res/virtual-machine-images/image-template:0.3.1` | Remote reference |

## Notes


### Prerequisites

The deployments described in the following sections assume certain prerequisites to be in place prior to deployment.

- The deployment principal (e.g., the Service Principal tied to the deploying Service Connection) must have at least `Contributor` & `User Access Adminitrator` permissions on the target subscription to be able to deploy both resources and assign permissions to created user-assigned identities
- If you have a policy in place that prevents Storage Accounts from being deployed without a Firewall, you have to create an exemption for the Image Template / Staging Resource Group you can configure for the Image Template Resource (parameter `imageTemplateResourceGroupName`). The rationale is that the Azure-Image-Builder service uses this resource group to deploy both temporal resources used during the image build (e.g., a Virtual Machine), as well as a Storage Account to store temporal files & a 'packerlogs/customization.log' file in (which contains the logs of the image build). This Storage Account has no firewall configured, has a random name, and cannot be configured at deploy time.

### Elements
The image creation uses several components:

| &nbsp;&nbsp;&nbsp; | Resource | Description |
|--|--|--|
| <img src="./src/icons/Resource-Groups.svg" alt="ResourceGroup" height="12"> | Resource Group | The resource group hosting the image resources |
| <img src="./src/icons/Resource-Groups.svg" alt="ResourceGroup" height="12"> | (Image) Resource Group | The resource group hosting the resources created during the image build |
| <img src="./src/icons/Storage-Accounts.svg" alt="Storage Account" height="12"> | (Assets) Storage Account | The storage account that hosts the image customization scripts used by the _Azure Image Building_ when executing the image template. |
| <img src="./src/icons/Storage-Accounts.svg" alt="Storage Account" height="12"> | (DS) Storage Account | The storage account that hosts the files of the Deployment Scripts. Required for private networking. |
| <img src="./src/icons/Managed-identities.svg" alt="Managed Identity" height="12"> | (Image) User-Assigned Managed Identity | Azure Active Directory feature that eliminates the need for credentials in code, rotates credentials automatically, and reduces identity maintenance. In the context of the imaging construct, the managed identity (MSI) is used by the Image Builder Service. It is assigned contributor permissions on the subscription to be able to bake the image. Further, it is assigned read permissions on the Assets Storage Account Container in order to consume the customization scripts. |
| <img src="./src/icons/Managed-identities.svg" alt="Managed Identity" height="12"> | (DS) User-Assigned Managed Identity | Azure Active Directory feature that eliminates the need for credentials in code, rotates credentials automatically, and reduces identity maintenance. In the context of the imaging construct, the managed identity (MSI) is used by the Image Builder Service. It's assigned permissions on the Image Template to trigger it, the Deployment Script Storage Account for Private Networking, and the Assets Storage Account to upload files.  |
| <img src="./src/icons/Deployment-Script.png" alt="Managed Identity" height="12"> | (Storage) Deployment Script | The Deployment Script that uploads the customization scripts to the Assets Storage Account. |
| <img src="./src/icons/Deployment-Script.png" alt="Managed Identity" height="12"> | (Trigger) Deployment Script | The Deployment Script that triggers the Image Template build. |
| <img src="./src/icons/AzureComputeGalleries.svg" alt="Azure Compute Gallery" height="12"> | Azure Compute Gallery | Azure service that helps to build structure and organization for managed images. Provides global replication, versioning, grouping, sharing across subscriptions and scaling. The plain resource in itself is like an empty container. |
| <img src="./src/icons/VMImageDefinitions.svg" alt="Azure Compute Gallery Image" height="12"> | Azure Compute Gallery Image | Created within a gallery and contains information about the image and requirements for using it internally. This includes metadata like whether the image is Windows or Linux, release notes and recommended compute resources. Like the image gallery itself it acts like a container for the actual images. |
| <img src="./src/icons/ImageTemplates.svg" alt="Image Template" height="12"> | Image Template | A standard Azure Image Builder template that defines the parameters for building a custom image with AIB. The parameters include image source (Marketplace, custom image, etc.), customization options (i.e., Updates, scripts, restarts), and distribution (i.e., managed image, Azure Compute Gallery). The template is not an actual resource. Instead, when an image template is created, Azure stores all the metadata of the referenced Azure Compute Gallery Image alongside other image backing instructions as a hidden resource in a temporary resource group. |
| <img src="./src/icons/VMImageVersions.svg" alt="Image Version" height="12"> | Image Version | An image version (for example `0.24322.55884`) is what you use to create a VM when using a gallery. You can have multiple versions of an image as needed for your environment. This value **cannot** be chosen. |

<p>

<img src="./src/image/imageBuilderimage.png" alt="Run workflow" height="350">

### First deployment
When triggering the deployment for the first time, make sure you either select `All` or `Only base` for the `deploymentsToPerform` parameter. In either case the template will deploy all resources and scripts you will subsequently need to create the images. For any subsequent run, you can go with any option you need.

The steps the _Azure Image Builder_ performs on the image are defined by elements configured in the `customizationSteps` parameter of the image template parameter file. In our setup we [Usage Examples](#usage-examples) we use one or multiple custom scripts that are uploaded by the template to a storage account ahead of the image deployment.

### Mermaid Graphs

The following graphs show which services are created based on the chosen `deploymentsToPerform`. As such, they show a (simplified) view of the order and relations in between the included deployments.

#### (Simplified) All
```mermaid
  graph TD;
      imageTemplateRg --> imageTemplate
      rg --> vnet
      rg --> dsMsi
      rg --> imageMSI
      rg --> azureComputeGallery

      azureComputeGallery --> imageTemplate

      imageMSI --> imageMSI_rbac

      dsMsi --> assetsStorageAccount
      imageMSI --> assetsStorageAccount

      dsMsi --> dsStorageAccount
      vnet --> dsStorageAccount

      dsStorageAccount --> storageAccount_upload
      assetsStorageAccount --> storageAccount_upload
      dsMsi --> imageTemplate
      storageAccount_upload ==> imageTemplate

      imageTemplate --> imageTemplate_trigger

      imageTemplate_trigger ==> imageTemplate_wait
      imageMSI_rbac ==> imageTemplate
```



#### (Simplified) Only base
```mermaid
  graph TD;
      rg -- provides value to --> azureComputeGallery
      rg -- provides value to --> vnet
      rg -- provides value to --> dsMsi
      rg -- provides value to --> imageMSI

      imageTemplateRg

      vnet -- provides value to --> dsStorageAccount

      dsMsi -- provides value to --> dsStorageAccount
      dsStorageAccount -- provides value to --> storageAccount_upload
      assetsStorageAccount -- provides value to --> storageAccount_upload

      dsMsi -- provides value to --> assetsStorageAccount
      imageMSI -- provides value to --> assetsStorageAccount
      imageMSI -- provides value to --> imageMSI_rbac
```

#### Only assets & image
Assumes all other services + permissions are deployed
```mermaid
  graph TD;
      imageTemplateRg -- provides value to --> imageTemplate
      storageAccount_upload -- must come after --> imageTemplate
      imageTemplate -- provides value to --> imageTemplate_trigger
      imageTemplate -- provides value to --> imageTemplate_wait
      imageTemplate_trigger -- must come after --> imageTemplate_wait
```

#### Only image
Assumes all other services + permissions are deployed
```mermaid
  graph TD;
      imageTemplateRg -- provides value to --> imageTemplate
      imageTemplate -- provides value to --> imageTemplate_trigger
      imageTemplate -- provides value to --> imageTemplate_wait
      imageTemplate_trigger -- must come after --> imageTemplate_wait
```

### Troubleshooting

Most commonly issues with the construct occur during the image building process due to script errors. As those are hard to troubleshoot and the AIB VMs that are used to bake images are not accessible, the AIB service writes logs into a storage account in the 'staging' resource group it generates during the building process as documented [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/image-builder-troubleshoot#customization-log).

Aside from the packer logs, it will also contain the logs generated by the provided customization scripts and hence provide you insights into 'where' something wrong, and ideally also 'what' went wrong.

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
