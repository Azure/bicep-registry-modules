# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/logic/integration-account/CHANGELOG.md).

## 0.3.0

### Changes

- Marked assembly content as secure when forwarding it to the assembly child module.
- Added `location` outputs to the six published child modules to meet the existing repository validation convention, falling back to the configured location when child GET responses omit it.

### Breaking Changes

- None

## 0.2.0

### Changes

- None

### Breaking Changes

- Updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

## 0.1.1

### Changes

- Publishing child modules: `agreement`, `assembly`, `certificate`, `map`, `partner`, `schema`

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial release of the integration-account module.

### Breaking Changes

- None
