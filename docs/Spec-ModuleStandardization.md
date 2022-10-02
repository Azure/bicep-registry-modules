This specification declares the standards for a Bicep module. This defines the standard input and output parameters, parameter naming, additional parameters, and resource declaration. Note, description annoations are ommited until the examples section, but should always be included for parameters and outputs.


| Name              | Type     | Default          | Allowed                                   | Output           |
| ----------------- | -------- | ---------------- | ----------------------------------------- | ---------------- | 
| `location`        | `string` |                  |                                           | `location`       |
| `name`            | `string` | `uniqueString()` |                                           | `newOrExisting`  | 
| `newOrExisting`   | `string` | `new`            | `@allowed([ 'new', 'existing', 'none' ])` | `newOrExisting`  | 
| `isZoneRedundant` | `bool`   | `true`           |                                           | `isZoneRedudant` |

# Required Parameters

## Location
- Every template should start with a location parameter, with no default value set.

```bicep
@description('Deployment Location')
param location string

output location string = location 
```


## Name
### Parameter Naming 
- Single Resource Default Name Appends `Name` to <ResourceType>
- Multi-resource Default Name Appends <ResourceType> to `Name`
- The default name starts with a prefix such as "store" or "vault", and includes a unique string based on the prefix, resource group id, subscription id and location. The prefix value is not included in default value, but 
- Functions applied to the resource name should be applied directly in the resource declaration so that both the default value, or a user provider value are transformed. Functions should ensure that a valid new name is provided, and prevent issues such as 'to many characters', 'can not contain caps', or 'invalid characters'.
#### Module
```bicep
param name string = uniqueString(resourceGroup().name, location)

module resource 'nested-module.bicep' = {
  name: name
  params: {
    name: name
  }
}

output string name = name
```

#### Resource
```bicep
param prefix string = ''
param nameStorageAccount string = 'store${uniqueString(subscription().id, resourceGroup().id, location, prefix)}'

resource storageAccount 'Microsoft.StorageAccount/StorageAccount@2022-07-01' = {
  name: replace(lower(take('${prefix}${nameStorageAccount}', 40)), '-', '')
  location: location
 properties: {}
}

output idStorageAccount string = storageAccount.id
output nameStorageAccount string = storageAccount.name
```

## New or Existing
### Defaults and Allowed Values
- `new` is default in the basic case.
```bicep
@allowed([ 'new', 'existing'])
param newOrExisting string = 'new'
```
- In some instances, `none` is an required option. In those cases, `none` is default.
```bicep
@allowed([ 'new', 'existing', 'none' ])
param newOrExisting string = 'none'
```

### Parameter Naming
- When a module has a single resource the flag should be 'newOrExisting'
```bicep
@allowed([ 'new', 'existing'])
param newOrExisting string = 'new'
```
- When there are many resources that can be toggled they should be suffixed with the Resource Type.
```bicep
@allowed([ 'new', 'existing'])
param newOrExistingStorageAccount string = 'new'
@allowed([ 'new', 'existing'])
param newOrExistingKeyVault string = 'new'
```

# Optional Parameter Conventions
## Zone Redundancy
- Template may include a parameter to enable zone redundancy. 
```bicep
param isZoneRedundant bool = true
```

# Examples

## Inputs
### Single Resource Module
```bicep
@description('Deployment Location')
param location string

@description('Enable Zonal Redunancy for supported regions (skipped for unsupported regions)')
param isZoneRedundant bool = true

@description('Deploy a new Key Vault or choose from existing Key Vaults)')
@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'

@description('Key Vault Name)')
param name string = 'keyVault${uniqueString(resourceGroup().id, subscription().id)}'
```

### Multiple Resource Module
```bicep
@description('Deployment Location')
param location string

@description('Enable Zonal Redunancy for supported regions (skipped for unsupported regions)')
param isZoneRedundant bool = true

@description('Deploy a new Storage Account or choose from existing Storage Accounts)')
@allowed([ 'new', 'existing', 'none' ])
param newOrExistingStorageAccount string = 'none'
@description('Storage Account Name)')
param nameStorageAccount string = 'store${uniqueString(resourceGroup().id, subscription().id)}'

@description('Deploy a new Key Vault or choose from existing Key Vaults)')
@allowed([ 'new', 'existing', 'none' ])
param newOrExistingKeyVault string = 'none'

@description('Key Vault Name)')
param nameKeyVault string = 'keyVault${uniqueString(resourceGroup().id, subscription().id)}'
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

@description('Storage Account Id')
output storageAccountId string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id

@description('Storage Account Name')
output storageAccountName string = newOrExisting == 'new' ? storageAccount.name : existingStorageAccount.name
```
  
# Samples
## Sample Module
```bicep
// main.bicep
@description('Deployment Location')
param location string

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing', 'none' ])
param newOrExisting string = 'none'

module nestedModule 'nested-module.bicep' = {
  name: name
  params: {
    name: name
    newOrExisting: newOrExisting
  }
}

@description('Deployed Location')
output location string = location

@description('Deployed new or existing resource')
output newOrExisting string = newOrExisting
```

```bicep
// nested-module.bicep
@description('Deployment Location')
param location string
  
@description('Resource Group Name')
param resourceGroupName string = resourceGroup().name

@description('Deployment Name')
param name string = uniqueString(resourceGroup().id, subscription().id)

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing', 'none' ])
param newOrExisting string = 'none'

@description('Storage Account Location')
param locationStorage string = location

@description('Resource Group Name')
param resourceGroupStorageAccountName string = resourceGroupName

@description('Deployment Name')
param nameStorageAccount string = 'store${name}'

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing', 'none' ])
param newOrExistingStorageAccount string = newOrExisting

param propertiesStorageAccount object = //Default Value
...Additional Resource Parameters

resource storageAccount 'Microsoft.StorageAccount/Account' = if (newOrExistingStorageAccount == 'new' ) {
  name: name
  scope: resourceGroupStorageAccountName
  location: location
  properties: propertiesStorageAccount
}

resource existingStorageAccount 'Microsoft.StorageAccount/Account' existing = if (newOrExistingStorageAccount == 'existing' ) {
  name: name
  scope: resourceGroupStorageAccountName
}
...Additional Resource Declarations

@description('Deployed Location')
output location string = location

@description('Deployed Resource Group Name')
output resourceGroupName string = resourceGroupName

@description('Deployed Name')
output name string = name

@description('Deployed new or existing resource')
output newOrExisting string = newOrExisting

@description('Deployed Location')
output locationStorageAccount string = locationStorageAccount

@description('Storage Account's Resource Group Name')
output resourceGroupStorageAccountName string = resourceGroupStorageAccountName

@description('Storage Account Id')
output idStorageAccount string = newOrExisting == 'new' ? keyVault.id : existingKeyVault.id

@description('Storage Account Name')
output nameStorageAccount string = newOrExisting == 'new' ? storageAccount.name : existingStorageAccount.name

@description('Deployed new or existing resource')
output newOrExistingStorageAccount string = newOrExistingStorageAccount

...Additional Resource Outputs

```
