This specification declares the standards for a Bicep module. This defines the standard input and output parameters, parameter naming, additional parameters, and resource declaration. Note, description annoations are ommited until the examples section, but should always be included for parameters and outputs.

The main template should include the following parameters.
| Name                 | Type     | Default                | Allowed                                   | Notes |
| -------------------- | -------- | ---------------------- | ----------------------------------------- | ----- |
| `location`           | `string` |                        |                                           | |
| `resourceGroupName`  | `string` | `resourceGroup().name` |                                           | |
| `name`               | `string` | `uniqueString()`       |                                           | |
| `newOrExisting`      | `string` | `new`                  | `@allowed([ 'new', 'existing', 'none' ])` | Optional |
| `isZoneRedundant`    | `bool`   | `true`                 |                                           | Optional |
| `virtualNetworkName` | `string` | `uniqueString()`       |                                           | Optional |
| `subnetName`         | `string` | `uniqueString()`       |                                           | Optional |
| `tags`               | `object` | `{}`                   |                                           | Optional |

In addition, the template should include the following parameters for each resource in the template. This example shows the defaults for a `KeyVault` resource.

| Name                         | Type     | Default              | Allowed                                   | Notes |
| ---------------------------- | -------- | -------------------- | ----------------------------------------- | ----- |
| `locationKeyVault`           | `string` | location             |                                           | |
| `resourceGroupNameKeyVault`  | `string` | `resourceGroupName`  |                                           | |
| `nameKeyVault`               | `string` | `name`               |                                           | |
| `newOrExistingKeyVault`      | `string` | `newOrExisting`      | `@allowed([ 'new', 'existing', 'none' ])` | Optional |
| `isZoneRedundantKeyVault`    | `bool`   | `isZoneRedundant`    |                                           | Optional |
| `virtualNetworkName`KeyVault | `string` | `virtualNetworkName` |                                           | Optional |
| `subnetNameKeyVault`         | `string` | `subnetName`         |                                           | Optional |
| `tagsKeyVault`               | `object` | `tags`               |                                           | Optional |


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

## Virtual Network with Subnet
```bicep
@description('Specifies the name of the existing virtual network.')
param virtualNetworkName string

@description('Specifies the name of the existing subnet.')
param subnetName string
```

## Tags
```bicep
@description('Specifies the resource tags.')
param tags object
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
## base-template.bicep
```bicep
@description('Deployment Location')
param location string
  
@description('Resource Group Name')
param resourceGroupName string = resourceGroup().name

@description('Deployment Name')
param name string = uniqueString(resourceGroup().id, subscription().id)

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing', 'none' ])
param newOrExisting string = 'none'

// Optional Parameters
// @description('Enable Zonal Redunancy for supported regions (skipped for unsupported regions)')
// param isZoneRedundant bool = true

var configuration = {
  location: location
  resourceGroupName: resourceGroupName
  name: name
  newOrExisting: newOrExisting
  // isZoneRedundant: isZoneRedundant
}

module nestedModlue 'nested-template.bicep' = if( newOrExisting != 'none' )  {
  name: 'nestedModule'
  scope: resourceGroup(resourceGroupName)
  params: {
    location: configuration.location
    resourceGroupName: configuration.resourceGroupName
    name: configuration.name
    newOrExisting: configuration.newOrExisting
    // isZoneRedundant: isZoneRedundant
  }
}

@description('Deployed Location')
output location string = location

@description('Deployed Resource Group Name')
output resourceGroupName string = resourceGroupName

@description('Deployed Name')
output name string = name

@description('Deployed new or existing resource')
output newOrExisting string = newOrExisting

// @description('Zone Redundancy')
// output isZoneRedundant string = isZoneRedundant

@description('Deployment Configuration')
output configuration object = newOrExisting != 'none' ? configuration : {}
```

## nested-module.bicep
```bicep
@description('Deployment Location')
param location string
  
@description('Resource Group Name')
param resourceGroupName string = resourceGroup().name

@description('Deployment Name')
param name string = uniqueString(resourceGroup().id, subscription().id)

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'

@description('Storage Account Location')
param locationStorage string = location

@description('Resource Group Name')
param resourceGroupStorageAccountName string = resourceGroupName

@description('Deployment Name')
param nameStorageAccount string = 'store${name}'

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing' ])
param newOrExistingStorageAccount string = newOrExisting

param propertiesStorageAccount object = {}
// ...Additional Resource Parameters

var configuration = {
  location: location
  resourceGroupName: resourceGroupName
  name: name
  newOrExisting: newOrExisting
  resources: {
    storageAccount: {
      location: locationStorage
      resourceGroupName: resourceGroupStorageAccountName
      name: nameStorageAccount
      newOrExisting: newOrExistingStorageAccount
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = if (configuration.resources.storageAccount.newOrExisting == 'new' ) {
  name: configuration.resources.storageAccount.name
  location: configuration.resources.storageAccount.location
  properties: propertiesStorageAccount
}

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = if (configuration.resources.storageAccount.newOrExisting == 'existing' ) {
  name: configuration.resources.storageAccount.name
}
// ...Additional Resource Declarations

@description('Deployment Configuration')
output configuration object = configuration

@description('Deployed Location')
output location string = location

@description('Deployed Resource Group Name')
output resourceGroupName string = resourceGroupName

@description('Deployed Name')
output name string = name

@description('Deployed new or existing resource')
output newOrExisting string = newOrExisting

@description('Deployed Location')
output locationStorageAccount string = locationStorage

@description('Resource Group Name of Storage Account')
output resourceGroupStorageAccountName string = resourceGroupStorageAccountName

@description('Storage Account Id')
output idStorageAccount string = newOrExisting == 'new' ? storageAccount.id : existingStorageAccount.id

@description('Storage Account Name')
output nameStorageAccount string = newOrExisting == 'new' ? storageAccount.name : existingStorageAccount.name

@description('Deployed new or existing resource')
output newOrExistingStorageAccount string = newOrExistingStorageAccount

//...Additional Resource Outputs

```
