targetScope = 'managementGroup'
metadata name = 'Policy Assignments (Management Group scope)'
metadata description = 'This module deploys a Policy Assignment at a Management Group scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apamgmax'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. If not provided, will use the current scope for deployment.')
param subscriptionId string = '#_subscriptionId_#'

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    //Configure Azure Defender for SQL agents on virtual machines
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    description: '[Description] Policy Assignment at the management group scope'
    displayName: '[Display Name] Policy Assignment at the management group scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'SystemAssigned'
    location: resourceLocation
    managementGroupId: last(split(managementGroup().id, '/'))
    metadata: {
      category: 'Security'
      version: '1.0'
      assignedBy: 'Bicep'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/validation-rg'
    ]
    parameters: {
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
      effect: {
        value: 'Disabled'
      }
    }
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor role
    ]
    overrides: [
      {
        kind: 'policyEffect'
        value: 'Disabled'
        selectors: [
          {
            kind: 'policyDefinitionReferenceId'
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
          }
        ]
      }
    ]
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            kind: 'resourceType'
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
          }
          {
            kind: 'resourceLocation'
            in: [
              'westeurope'
            ]
          }
        ]
      }
    ]
  }
}
