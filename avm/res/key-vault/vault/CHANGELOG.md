# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/CHANGELOG.md).

## 0.14.0

### Changes

- converted [`access-policy`](/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/access-policy) to a child module
- converted [`key`](/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/key) to a child module
- converted [`secret`](/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/secret) to a child module

### Breaking Changes

- none

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
