# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/managed-instance/CHANGELOG.md).

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
