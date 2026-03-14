# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/CHANGELOG.md).

## 0.13.3

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.13.2

### Changes

- Introduced [`access-policy`](/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/access-policy) as child module
- Introduced [`key`](/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/key) as child module
- Introduced [`secret`](/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/secret) as child module
- Updates avm-common-types references to `0.6.1`

### Breaking Changes

- None

## 0.13.1

### Changes

- Updated the avm-common-types references to `0.6.0`, enabling notes on locks.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.13.0

### Changes

- Added user definied type (UDT) for the property `KeyVault.networkAcls`
- Updated property `KeyVault.createMode` with allowed values
- Updated property `KeyVault.Secret.name` with contrains
- Updated property `KeyVault.Key.keyOps` to be a string[]
- Added UDT for the property `KeyVault.Key.rotationPolicy`
- Referenced module and Resource Provider (RP) versions updated
- Updated all `tags` properties with RP property

### Breaking Changes

- Values for the property `KeyVault.Key.rotationPolicy.lifetimeActions.type` are now `rotate|notify` instead of `Rotate|Notify` to align to the RP
