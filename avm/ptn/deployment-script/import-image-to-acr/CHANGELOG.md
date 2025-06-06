# Changelog

The latest version of the changelog can be found [here](/Azure/bicep-registry-modules/blob/main/avm/ptn/deployment-script/import-image-to-acr/CHANGELOG.md).

## 0.4.4

### Changes

- updated resource provider versions
- in the test cases, the Azure Container Registry, storage account and Key Vault names are now unique to prevent deployment failures due to duplicate names
- updated az cli version in the deployment script
- added min and max length to the ACR name property
- exclude Content Trues psrule `Azure.ACR.ContentTrust` for this module
- disabled contentTrust in the 'max' and 'waf-aligned' tests, as creating signed images is a big overhead for the CI deployment testing and raise an error in the PSRule `Azure.ACR.ContentTrust`

### Breaking Changes

- none
