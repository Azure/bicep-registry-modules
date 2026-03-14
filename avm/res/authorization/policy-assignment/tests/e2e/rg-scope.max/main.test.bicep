targetScope = 'subscription'

metadata name = 'Using large parameter set (Resource Group scope)'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.policyassignments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rapargmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = '#_subscriptionId_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: az.resourceGroup(subscriptionId, resourceGroupName)
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
  dependsOn: [
    resourceGroup
  ]
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../rg-scope/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  scope: resourceGroup
  params: {
    name: '${namePrefix}${serviceShort}001'
    //Configure Azure Defender for SQL agents on virtual machines
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    definitionVersion: '1.*.*-preview'
    description: '[Description] Policy Assignment at the subscription scope'
    displayName: '[Display Name] Policy Assignment at the subscription scope'
    enforcementMode: 'DoNotEnforce'
    location: resourceLocation
    additionalResourceGroupResourceIDsToAssignRbacTo: [
      resourceGroup.id
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
      '${resourceGroup.id}/providers/Microsoft.Network/virtualNetworks/myVnet'
    ]
    parameters: {
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
      effect: {
        value: 'DeployIfNotExists'
      }
    }
    roleDefinitionIds: [
      '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
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
    managedIdentities: {
      userAssignedResourceId: nestedDependencies.outputs.managedIdentityResourceId
    }
  }
}
