targetScope = 'subscription'

@description('Required. The name of the Resource Group.')
param resourceGroupName string

@description('Required. The location where all resources will be deployed.')
param location string = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

output resourceGroupName string = rg.name
