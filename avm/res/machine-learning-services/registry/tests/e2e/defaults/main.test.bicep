
targetScope = 'subscription'

metadata name = 'Using only defaults for AML Registry'
metadata description = 'This test deploys the AML Registry module with the minimum required parameters and mocked values.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-amlregistry-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment.')
param serviceShort string = 'amlreg'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = 'test'

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    scope: resourceGroup
    params: {
      registryName: 'dep-${namePrefix}-amlreg001'
      location: resourceLocation
      discoveryUrl: 'https://mockregistry.${resourceLocation}.azureml.ms'
      mlFlowRegistryUri: 'https://mockregistry.${resourceLocation}.azureml.ms/mlflow'
      intellectualPropertyPublisher: 'Contoso'
      managedResourceGroupId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-mrg'
      identityType: 'UserAssigned'
      userAssignedIdentityId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mock-identity'
      publicNetworkAccess: 'Enabled'
      acrAccountName: 'dep-${namePrefix}-acr-${serviceShort}'
      acrAccountSku: 'Standard'
      acrResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.ContainerRegistry/registries/dep-${namePrefix}-acr-${serviceShort}'
      storageAccountName: 'dep-${namePrefix}-stg-${serviceShort}'
      storageAccountType: 'Standard_LRS'
      storageAccountHnsEnabled: true
      allowBlobPublicAccess: false
      storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Storage/storageAccounts/dep-${namePrefix}-stg-${serviceShort}'
      subnetArmId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/virtualNetworks/mock-vnet/subnets/default'
      privateEndpointConnectionId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mock-rg/providers/Microsoft.Network/privateEndpoints/mock-pe'
      provisioningState: 'Succeeded'
      privateLinkStatus: 'Approved'
      privateLinkDescription: 'Test connection'
      actionsRequired: 'None'
    }
  }
]
