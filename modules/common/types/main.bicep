type AzureLocations = AzurePublicCloudLocations | AzureChinaCloudLocations | AzureUSGovernmentCloudLocations | AzureGermanCloudLocations

type AzurePublicCloudLocations = 'eastus' | 'eastus2' | 'westus' | 'westus2' | 'westcentralus' | 'westeurope' | 'southeastasia' | 'northeurope' | 'uksouth' | 'ukwest' | 'australiaeast' | 'australiasoutheast' | 'brazilsouth' | 'southindia' | 'centralindia' | 'westindia' | 'canadacentral' | 'canadaeast' | 'japaneast' | 'japanwest' | 'koreacentral' | 'koreasouth' | 'francecentral' | 'southafricanorth' | 'uaenorth' | 'switzerlandnorth' | 'germanywestcentral' | 'norwayeast'
type AzureChinaCloudLocations = 'chinaeast' | 'chinaeast2' | 'chinanorth' | 'chinanorth2'
type AzureUSGovernmentCloudLocations = 'usgovvirginia' | 'usgoviowa' | 'usgovarizona' | 'usgovtexas'
type AzureGermanCloudLocations = 'germanynortheast' | 'germanycentral'

module StorageAccount './modules/storage.bicep' = { name: 'StorageAccountTypes' }

module CosmosDB './modules/cosmosdb.bicep' = { name: 'CosmosDBTypes' }
