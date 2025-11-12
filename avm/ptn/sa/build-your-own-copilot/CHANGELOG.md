# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/build-your-own-copilot/CHANGELOG.md).

## 0.2.0

### Changes

- Fixed parameter descriptions to comply with AVM standards - all descriptions now start with a category (Optional./Required.) and end with a period
- Removed trailing colons from parameter descriptions for `solutionName`, `gptModelDeploymentType`, `gptModelName`, `gptModelCapacity`, and `embeddingModel`
- Added missing periods to parameter descriptions for `cosmosLocation`, `embeddingDeploymentCapacity`, `existingFoundryProjectResourceId`, `enablePurgeProtection`, and `createdBy`
- Improved parameter validation compliance with AVM specification requirements

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version of Build your own copilot solution accelerator
- Comprehensive AI document processing solution with Azure OpenAI, Cognitive Services, and Azure Search
- Support for private networking, monitoring, redundancy, and scalability configurations
- Integrated Azure Bastion and jumpbox for secure access
- AVM compliance with telemetry, proper naming conventions, and governance

### Breaking Changes

- None
