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

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.policyassignments-${serviceShort}-rg'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. If not provided, will use the current scope for deployment.')
param subscriptionId string = '#_subscriptionId_#'

// ============ //
// Dependencies //
// ============ //

resource additionalMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  scope: tenant()
  name: '${uniqueString(deployment().name)}-additional-mg'
}

module additionalRsg 'br/public:avm/res/resources/resource-group:0.4.0' = {
  scope: subscription(subscriptionId)
  name: '${uniqueString(deployment().name, resourceLocation)}-resourceGroup'
  params: {
    name: resourceGroupName
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    //Configure Azure Defender for SQL agents on virtual machines
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    definitionVersion: '1.*.*-preview'
    description: '[Description] Policy Assignment at the management group scope'
    displayName: '[Display Name] Policy Assignment at the management group scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'SystemAssigned'
    location: resourceLocation
    managementGroupId: last(split(managementGroup().id, '/'))
    additionalManagementGroupsIDsToAssignRbacTo: [
      additionalMg.name
    ]
    additionalSubscriptionIDsToAssignRbacTo: [
      subscriptionId
    ]
    additionalResourceGroupResourceIDsToAssignRbacTo: [
      additionalRsg.outputs.resourceId
    ]
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
      additionalRsg.outputs.resourceId
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
