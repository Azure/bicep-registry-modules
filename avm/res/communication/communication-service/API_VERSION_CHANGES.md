# API Version Update Summary

This document summarizes the new features and changes introduced by the API version updates in this module.

## Updated: February 2026

## API Version Changes

### Microsoft.Communication/communicationServices: 2023-04-01 → 2025-09-01

**Impact:** ✅ **No Breaking Changes** - Backward Compatible

**Schema Changes:**
- **No new properties added** in 2025-09-01 compared to 2023-04-01
- **No properties removed or modified**
- All existing functionality remains unchanged

**Available Properties (Unchanged):**
- `dataLocation` - The location where the communication service stores its data at rest
- `linkedDomains` - List of email domain resource IDs
- `identity` - Managed identity configuration (SystemAssigned, UserAssigned)
- `publicNetworkAccess` - Network access configuration
- `disableLocalAuth` - Local authentication settings
- `tags` - Resource tags

**Why Update?**
- Keeps the module aligned with the latest stable Azure API versions
- Ensures compatibility with current Azure Resource Manager features
- Avoids warnings about using outdated API versions
- Positions the module for future feature adoption

### Microsoft.Resources/deployments: 2024-03-01 → 2025-04-01

**Impact:** ✅ **New Features Available** (Not Used in Current Module)

**New Features in 2025-04-01:**

1. **DeploymentExternalInput**
   - Enables deployments to accept external inputs at runtime
   - Useful for fetching secrets, tokens, or other values externally
   - Enhances security by avoiding hardcoded values

2. **DeploymentIdentity**
   - Support for managed identities at the deployment level
   - Allows user-assigned identities in deployment definitions
   - Improves security for deployments accessing Azure resources

3. **Enhanced DeploymentParameter**
   - New `expression` property for richer parameter scenarios
   - Enables more complex parameter evaluation logic

4. **External Input Definitions**
   - `externalInputDefinitions` - Define external input schemas
   - `externalInputs` - Provide external input values
   - Better separation between parameters and external inputs

**Current Module Usage:**
- This module uses the deployments API only for AVM telemetry tracking
- The new features are not currently utilized in the module
- Future enhancements could leverage these capabilities

## Summary

### For Communication Services (Primary Resource)
- ✅ **Backward Compatible** - No code changes required
- ✅ **Schema Stable** - All properties work exactly as before
- ✅ **Best Practice** - Using latest stable API version

### For Deployments (Telemetry Resource)
- ✅ **New Capabilities Available** - External inputs and identity support
- ℹ️ **Not Currently Used** - Module doesn't leverage new features yet
- 🔮 **Future Potential** - Could be used for enhanced deployment scenarios

## Recommendations

1. **No Action Required** - The update is backward compatible
2. **Testing** - Existing deployments should work without modification
3. **Future Enhancements** - Consider leveraging new deployment features for:
   - Dynamic secret injection
   - Managed identity authentication
   - Complex parameter expressions

## References

- [Microsoft.Communication/communicationServices API Change Log](https://learn.microsoft.com/en-us/azure/templates/microsoft.communication/change-log/communicationservices)
- [Microsoft.Resources/deployments API Change Log](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/change-log/deployments)
- [Communication Services 2025-09-01 Documentation](https://learn.microsoft.com/en-us/azure/templates/microsoft.communication/communicationservices)
- [Deployments 2025-04-01 Documentation](https://learn.microsoft.com/en-us/azure/templates/microsoft.resources/2025-04-01/deployments)
