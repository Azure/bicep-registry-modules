# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/virtual-machine-images/azure-image-builder/CHANGELOG.md).

## 0.2.2

### Changes

- Removed icon from parameter description that can conflict with upstream tools

### Breaking Changes

- None

## 0.2.1

### Changes

- Added disclaimer for `storageAccountFilesToUpload` parameter to **not** upload files containing emojis (🍪) as they may cause problems when loaded into the environment of the uploading deployment script.
- Updated to latest Compute Gallery version `0.9.3` to incorporate a disclaimer for DevBox-tailored images

### Breaking Changes

- None

## 0.2.0

### Changes

- Updated to latest AVM versions
- Adjusted image template deployment to make use of the of the `vnetConfig` parameter's `containerInstanceSubnetResourceId` property of the `avm/res/virtual-machine-images/image-template` version `0.6.0` by adding the optional parameters
  - `imageContainerInstanceSubnetName`
  - `imagecontainerInstanceSubnetAddressPrefix`
  If you **don't** want to make use of the container instance subnet, pass the `imagecontainerInstanceSubnetAddressName` parameter as empty(`''`) into the deployment to override its default
- Added type to `imageTemplateImageSource` parameter.
- Updated the deployment of the image template MSI permissions to not configure the `Contributor` role on both the primary & build resource groups but instead granting it
  - `Contributor` only on the build resource group (to deploy the required resources during the image build),
  - `Contributor` on the Compute Gallery (to distribute images to the gallery)
  - `Network Contributor` on the Virtual Network (to deploy the required resource during the image build into the corresponding subnets)
- Removed now redundant conditions in conditional properties referencing other modules that were required to prevent Bicep from evaluating outputs of conditionally-deployed resources. Reference of the bugfix issue: [ref](https://github.com/Azure/bicep/issues/2371)
- Added the conscious configuration of the intended subscription to the deployment scripts logic to avoid issues with identities that have access to multiple subscriptions.
- Removed/disabled several redundant dependencies

### Breaking Changes

- None

## 0.1.6

### Changes

- Initial version

### Breaking Changes

- None
