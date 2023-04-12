@description('Deployment location.')
type AzureLocations = AzurePublicCloudLocations | AzureChinaCloudLocations | AzureUSGovernmentCloudLocations | AzureGermanCloudLocations

@description('Azure Public Deployment location.')
type AzurePublicCloudLocations = 'eastus' | 'eastus2' | 'westus' | 'westus2' | 'westcentralus' | 'westeurope' | 'southeastasia' | 'northeurope' | 'uksouth' | 'ukwest' | 'australiaeast' | 'australiasoutheast' | 'brazilsouth' | 'southindia' | 'centralindia' | 'westindia' | 'canadacentral' | 'canadaeast' | 'japaneast' | 'japanwest' | 'koreacentral' | 'koreasouth' | 'francecentral' | 'southafricanorth' | 'uaenorth' | 'switzerlandnorth' | 'germanywestcentral' | 'norwayeast'

@description('Azure China Deployment location.')
type AzureChinaCloudLocations = 'chinaeast' | 'chinaeast2' | 'chinanorth' | 'chinanorth2'

@description('Azure US Government Deployment location.')
type AzureUSGovernmentCloudLocations = 'usgovvirginia' | 'usgoviowa' | 'usgovarizona' | 'usgovtexas'

@description('Azure Germany Deployment location.')
type AzureGermanCloudLocations = 'germanynortheast' | 'germanycentral'

@maxLength(128)
type _tag_key = string

@maxLength(256)
type _tag_value = string

@description('Tags are a list of key-value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater than 128 characters and value no greater than 256 characters. For example, the default experience for a template type is set with "defaultExperience": "Cassandra". Current "defaultExperience" values also include "Table", "Graph", "DocumentDB", and "MongoDB".')
@maxLength(15)
type _tags = {
  'key': _tag_key
  'value': _tag_value
}[]
