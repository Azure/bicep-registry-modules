# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/service/product/policy/CHANGELOG.md).

## 0.1.0

### Changes

- Initial version
- Fixed metadata name from "API Management Service Products Policies" to "API Management Service Product Policies" (singular).
- Changed `name` parameter from optional with default `'policy'` to required.
- Updated output descriptions to reference "Product policy" instead of "API policy".

### Breaking Changes

- The `name` parameter is now required (removed default value of `'policy'`).
