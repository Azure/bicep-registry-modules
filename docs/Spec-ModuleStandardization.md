This specification declares the standards for a Bicep module. This defines the standard input and output parameters, parameter naming, additional parameters, and resource declaration.

# Standardizations
## Toggle Defaults and Allowed Values
- `new` is default in the basic basic.
```bicep
@allowed([ 'new', 'existing'])
param newOrExisting string = 'new'
```
- In some instances, `none` is an required option. In those cases, `none` is default.
```bicep
@allowed([ 'new', 'existing', 'none' ])
param newOrExisting string = 'none'
```
## Toggle Name
- When a module has a single resource the flag should be 'newOrExisting' but when there are many resources that can be toggled they should be suffixed with the Resource Type.
```bicep
@allowed([ 'new', 'existing'])
param newOrExisting string = 'new'
```
```bicep
@allowed([ 'new', 'existing'])
param newOrExistingStorageAccount string = 'new'
@allowed([ 'new', 'existing'])
param newOrExistingKeyVault string = 'new'
```
## Resource Name Parameter
- Single Resource Default Name Appends `Name` to <ResourceType>
```bicep
param name string
```
- Multi-resource Default Name Appends <ResourceType> to `Name`
```bicep
param nameStorageAccount string
```
## Resource Name Default
- The default name starts with a prefix such as "store" or "vault", and includes a unique string based on the prefix, resource group id, subscription id and location. The prefix value is not included in default value, but 
```bicep
param prefix string = ''
param name string = 'store${uniqueString(prefix, resourceGroup().id, subscription().id, location)}'

## Functions applied to Resource Name
- Functions applied to the resource name should be applied directly in the resource declaration so that both the default value, or a user provider value are transformed. Functions should ensure that a valid new name is provided, and prevent issues such as 'to many characters', 'can not contain caps', or 'invalid characters'. 
```bicep
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = if (newOrExisting == 'new') {
  name: take('${prefix}${name}', 24)
  location: location
 properties: {}
}
```

## Default Outputs 
- Outputs should include both name and ID. 
```bicep
output id string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id
output name string = newOrExisting == 'new' ? keyVault.name : existingKeyVault.name
```
-When multiple resources are returned, the Resource Type should be used as a suffix.
```bicep
output idKeyVault string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id
output nameKeyVault string = newOrExisting == 'new' ? keyVault.name : existingKeyVault.name
output idStorageAccount string = newOrExisting == 'new' ? storageAccount.id : existingStorageAccount.id
output nameStorageAccount string = newOrExisting == 'new' ? storageAccount.name : existingStorageAccount.name
```

# Examples

## Inputs
### Single Resource Module
```bicep
param location string
param isZoneRedundant bool = true
@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'
param name string = 'keyVault${uniqueString(resourceGroup().id, subscription().id)}'
```

### Multiple Resource Module
```bicep
param location string
param isZoneRedundant bool = true
@allowed([ 'new', 'existing', 'none' ])
param newOrExistingStorageAccount string = 'none'
param storageAccountName string = 'store${uniqueString(resourceGroup().id, subscription().id)}'

@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKeyVault string = 'none'
param keyVaultName string = 'keyVault${uniqueString(resourceGroup().id, subscription().id)}'
```

## New Resource
```bicep
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = if (newOrExisting == 'new') {
  name: take(name, 24)
  location: location
 properties: {}
}
```

## Existing Resource
```bicep
resource existingKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = if (newOrExisting == 'existing') {
  name: name
}
```

## Output 
### Single Resource
```bicep
@description('Key Vault Id')
output id string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id

@description('Key Vault Name')
output name string = newOrExisting == 'new' ? keyVault.name : existingKeyVault.name
```

### Multi Resource
```bicep
@description('Key Vault Id')
output keyVaultId string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id

@description('Key Vault Name')
output keyVaultName string = newOrExisting == 'new' ? keyVault.name : existingKeyVault.name

@description('Key Vault Id')
output storageAccountId string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id

@description('Key Vault Name')
output storageAccountName string = newOrExisting == 'new' ? storageAccount.name : existingStorageAccount.name
```
