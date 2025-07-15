# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cognitive-services/account/CHANGELOG.md).

## 0.12.0

### Changes

- Added support for deploying commitment plans via the new commitmentPlans parameter, enabling Disconnected Container and other hosting models (e.g., NTTS, STT, CUSTOMSTT, ADDON).
- Introduced type commitmentPlanType to define plan configuration including autoRenew, hostingModel, and tiered instance count.
- Updated main.bicep to provision Microsoft.CognitiveServices/accounts/commitmentPlans resources under the account.

### Breaking Changes

- None

## 0.11.0

### Changes

- Initial version

### Breaking Changes

- None
