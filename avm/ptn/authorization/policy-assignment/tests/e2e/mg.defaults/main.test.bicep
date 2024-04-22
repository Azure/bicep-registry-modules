targetScope = 'managementGroup'
metadata name = 'Policy Assignments (Management Group scope)'
metadata description = 'This module deploys a Policy Assignment at a Management Group scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apamgmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    //Audit VMs that do not use managed disks
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    metadata: {
      assignedBy: 'Bicep'
    }
    location: resourceLocation
  }
}
