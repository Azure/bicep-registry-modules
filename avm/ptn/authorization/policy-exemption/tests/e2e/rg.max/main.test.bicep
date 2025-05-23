targetScope = 'managementGroup'
metadata name = 'Policy Exemption (Resource Group)'
metadata description = 'This module deploys a Policy Exemption at a Resource Group scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apergmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The target scope for the policy exemption. If not provided, will use the current scope for deployment.')
param subscriptionId string = '#_subscriptionId_#'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.policyassignments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //
module resourceGroup 'br/public:avm/res/resources/resource-group:0.2.3' = {
  scope: subscription('${subscriptionId}')
  name: '${uniqueString(deployment().name, resourceLocation)}-resourceGroup'
  params: {
    name: resourceGroupName
    location: resourceLocation
  }
}

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2025-01-01' existing = {
  name: '06a78e20-9358-41c9-923c-fb736d382a4d'
  scope: tenant()
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: 'audit-vm-managed-disks'
  scope: managementGroup()
  properties: {
    metadata: {
      assignedBy: 'Bicep'
    }
    policyDefinitionId: policyDefinition.id
    description: ' 	This policy audits VMs that do not use managed disks'
    displayName: 'Audit VMs that do not use managed disks'
    enforcementMode: 'DoNotEnforce'
    nonComplianceMessages: [
      {
        message: 'Virtual machines should use managed disks'
      }
    ]
  }
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    exemptionCategory: 'Mitigated'
    policyAssignmentId: policyAssignment.id
    assignmentScopeValidation: 'Default'
    description: '[Description] Policy Exemption at the management group scope'
    displayName: '[DisplayName] Policy Exemption at the management group scope'
    enableTelemetry: true
    location: resourceLocation
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroup.outputs.name
    metadata: {
      category: 'Security'
      assignedBy: 'Bicep'
    }
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
