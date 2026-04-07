# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/managed-instance/CHANGELOG.md).

## 0.4.1

### Changes

- Added `administrators` sub-module for post-creation Azure AD administrator management (`Microsoft.Sql/managedInstances/administrators`)
- Added `azure-ad-only-authentication` sub-module for enabling/disabling Entra ID-only authentication (`Microsoft.Sql/managedInstances/azureADOnlyAuthentications`)
- Added `aadAdministrator` parameter to configure the Azure AD administrator via the new sub-module
- Added `azureADOnlyAuthentication` parameter to enable/disable Azure AD-only login
- Added `authenticationMetadata` parameter (`AzureAD` | `Paired` | `Windows`)
- Added `pricingModel` parameter (`Freemium` | `Regular`)
- Added `storageIOps` parameter for custom IOPS provisioning (300–80000)
- Added new `aad-auth` e2e test case covering Azure AD administrator and Azure AD-only authentication end-to-end
- Updated `max` e2e test to exercise the new `aadAdministrator`, `authenticationMetadata` and `pricingModel` parameters

### Breaking Changes

- None

## 0.4.0

### Changes

- Updated/added UDTs & RDTs for `tags`, `vCores`,  `databases`,  `databases.tags`, `vulnerabilityAssessment`, `securityAlertPolicy`, `keys` & `encryptionProtector`
- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.
- Added numerous capabilities to the `securityAlertPolicy` deployment

### Breaking Changes

- Renamed `vulnerabilityAssessmentsObj` to `vulnerabilityAssessment`
- Updated the structure of the `vulnerabilityAssessment` parameter with the original `recurringScans*` properties being embedded in a `recurringScans` object property. For example, `vulnerabilityAssessmentsObj.recurringScansIsEnabled` must now be declared as `vulnerabilityAssessment.recurringScans.isEnabled` in alignment with the API spec.
- Renamed `securityAlertPoliciesObj` to `securityAlertPolicy`
- Renamed `encryptionProtectorObj` to `encryptionProtector`
- Renamed `administratorsObj` to `administrators`, using the `Microsoft.SQL/managedInstances` `administrators` property instead of the `Microsoft.SQL/managedInstances/administrators` child-module

## 0.3.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
