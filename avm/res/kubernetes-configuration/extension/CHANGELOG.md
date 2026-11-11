# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/kubernetes-configuration/extension/CHANGELOG.md).

## 0.4.0

### Changes

- Typed `fluxConfigurations` with `fluxConfigurationType`, marking `configurationProtectedSettings` as secure to match the flux-configuration module.
- Kept provider-derived types and optionality for forwarded properties. Unconsumed provider fields remain accepted but are not forwarded, as before; this does not add support for other Flux sources.
- Fixed a typo in the `fluxConfigurations` description.

### Breaking Changes

- The explicit `fluxConfigurations` object schema now enforces the declared property types in ARM, unlike the previous native type's metadata-only schema. Inputs previously accepted through an ARM parameter file can therefore be rejected; this is not a backward-compatible replacement for the native type. The parameter remains nullable with no explicit default, and child-module required inputs and defaults are unchanged.

## 0.3.8

### Changes

- Fix flux extension install failed for connectedCluster

### Breaking Changes

- None

## 0.3.7

### Changes

- Support extension for connectedCluster

### Breaking Changes

- None

## 0.3.6

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
