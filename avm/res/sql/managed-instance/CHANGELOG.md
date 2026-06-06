# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/managed-instance/CHANGELOG.md).

## 0.5.0

### Changes

- Added `administrator` sub-module for post-creation Azure AD administrator management (`Microsoft.Sql/managedInstances/administrators`)
- Added `azure-ad-only-authentication` sub-module for enabling/disabling Entra ID-only authentication (`Microsoft.Sql/managedInstances/azureADOnlyAuthentications`)
- Added `aadAdministrator` parameter to configure the Azure AD administrator via the new sub-module
- Added `azureADOnlyAuthentication` parameter to enable/disable Azure AD-only login
- Added `authenticationMetadata` parameter (`AzureAD` | `Paired` | `Windows`)
- Added `pricingModel` parameter (`Freemium` | `Regular`)
- Added `storageIOps` parameter for custom IOPS provisioning (300–80000)
- Added new `aad-auth` e2e test case covering Azure AD administrator and Azure AD-only authentication end-to-end
- Updated `max` e2e test to exercise the new `aadAdministrator`, `authenticationMetadata` and `pricingModel` parameters
- Bumped parent and child module API versions to `Microsoft.Sql/managedInstances*@2025-02-01-preview`

### Breaking Changes

- Removed the inline `administrators` parameter (and the exported `serverExternalAdministratorType` type) from the parent module. Azure AD administrator configuration is now managed exclusively via the new `aadAdministrator` parameter and the `administrator` sub-module, enabling post-creation updates without redeploying the managed instance.

## 0.4.1

### Changes

- Publishing child modules:
  - `avm/res/sql/managed-instance/database`
  - `avm/res/sql/managed-instance/database/backup-long-term-retention-policy`
  - `avm/res/sql/managed-instance/database/backup-short-term-retention-policy`
  - `avm/res/sql/managed-instance/encryption-protector`
  - `avm/res/sql/managed-instance/key`
  - `avm/res/sql/managed-instance/security-alert-policy`
  - `avm/res/sql/managed-instance/vulnerability-assessment`

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
