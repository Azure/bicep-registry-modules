using './main.bicep'

// Required Parameters

param name = readEnvironmentVariable('AZURE_ENV_NAME')
param location = readEnvironmentVariable('AZURE_LOCATION')
param adminPassword = readEnvironmentVariable('AZURE_VM_ADMIN_PASSWORD')
param adminUsername = readEnvironmentVariable('AZURE_VM_ADMIN_USERNAME')

// Optional Parameters

param tags = {}
param resourceGroupName = readEnvironmentVariable('AZURE_RESOURCE_GROUP_NAME', '')
param vmSku = readEnvironmentVariable('AZURE_VM_SKU', 'Standard_D2s_v3')
param vmZone = int(readEnvironmentVariable('AZURE_VM_ZONE', '1'))
param storageAccountName  = readEnvironmentVariable('AZURE_STORAGE_ACCOUNT_NAME', '')
param managedIdentityName = readEnvironmentVariable('AZURE_MANAGED_IDENTITY_NAME', '')
param hubManagedIdentityName = readEnvironmentVariable('AZURE_HUB_MANAGED_IDENTITY_NAME', '')
param cognitiveKind = readEnvironmentVariable('AZURE_COGNITIVE_KIND', 'AIServices')
param cognitiveAccountName = readEnvironmentVariable('AZURE_COGNITIVE_ACCOUNT_NAME', 'OpenAI')
param searchServiceName = readEnvironmentVariable('AZURE_SEARCH_SERVICE_NAME', '')
