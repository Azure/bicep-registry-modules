

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

