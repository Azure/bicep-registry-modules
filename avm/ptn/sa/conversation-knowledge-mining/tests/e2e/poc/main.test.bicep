targetScope = 'subscription'

metadata name = 'Using Proof of Concept parameter set'
metadata description = 'This module deploys the [Conversation Knowledge Mining Solution Accelerator](https://github.com/microsoft/Conversation-Knowledge-Mining-Solution-Accelerator) using the configuration for Proof of Concept scenarios'

// ========== //
// Parameters //
// ========== //
@sys.description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sa.ckm-${serviceShort}-rg'

@sys.description('Optional. The location to deploy resources to')
param resourceLocation string = deployment().location

@sys.description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ckmpoc'

@sys.description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================

//This variable contains the list of locations where AI services of type 'Microsoft.CognitiveServices/accounts' are allowed to be deployed. If the provided
var AIServicesAllowedLocations = [
  'Global'
  'Australia East'
  'Brazil South'
  'West US'
  'West US 2'
  'West Europe'
  'North Europe'
  'Southeast Asia'
  'East Asia'
  'West Central US'
  'South Central US'
  'East US'
  'East US 2'
  'Canada Central'
  'Japan East'
  'Central India'
  'UK South'
  'Japan West'
  'Korea Central'
  'France Central'
  'North Central US'
  'Central US'
  'South Africa North'
  'UAE North'
  'Sweden Central'
  'Switzerland North'
  'Switzerland West'
  'Germany West Central'
  'Norway East'
  'West US 3'
  'Jio India West'
  'Qatar Central'
  'Canada East'
  'Poland central'
  'South India'
  'Italy North'
  'Spain Central'
  'UK West'
  'Jio India Central'
]

var resourceGroupLocation = contains(AIServicesAllowedLocations, resourceLocation) ? resourceLocation : 'East US'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      environmentName: '${namePrefix}ckmpoc'
      contentUnderstandingLocation: 'West US'
    }
  }
]
