# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/multi-agent-custom-automation-engine/CHANGELOG.md).

## 0.3.0

### Changes

- Added Azure Container Registry resource deployment with managed identity-based ACR Pull role assignments and private endpoint support
- Updated default GPT models from gpt-4.1-mini/gpt-4.1 to gpt-5.4-mini/gpt-5.4 with updated model versions
- Updated default container image references from custom registry to MCR placeholder images
- Added ACR private DNS zone (`privatelink.azurecr.io`) and private endpoint for WAF-aligned deployments
- Added gpt-image-1.5 model deployment support
- Updated container app configurations to use managed identity credentials for ACR access

### Breaking Changes

-

## 0.2.4

### Changes
- Separated the AI Services private endpoint creation from the Cognitive Services account module into a dedicated `avm/res/network/private-endpoint` module deployment, and added an explicit `dependsOn` from the AI Foundry project to the private endpoint, to resolve `AccountProvisioningStateInvalid` failures caused by inline private endpoint creation racing against account provisioning and inline model deployments

### Breaking Changes

- None

## 0.2.3

### Changes
- Updated MACAE v4 changes
- Updated AVM module version and Microsoft API versions
- Enhanced main.bicep with improved resource configurations
- Removed unused Key vault resource and it's related DNS resource

### Breaking Changes

- None

## 0.2.2

### Changes

- Updated MACAE v4 to latest agent-framework changes
- UPdated the Foundry SDK V1 to Foundry SDK V2
- Enhanced main.bicep with improved resource configurations
- Improved the search searvice deployment performance


### Breaking Changes

- None

## 0.2.1

### Changes

- Updated MACAE v4 changes
- Enhanced main.bicep with improved resource configurations
- Updated AI Foundry Platform connections module
- Improved virtual network and web site configuration modules

### Breaking Changes

- None

## 0.2.0

### Changes

- Updated all the moudules including waf & non-waf with readme.

### Breaking Changes

- None

## 0.1.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
