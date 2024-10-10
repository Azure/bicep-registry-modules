targetScope = 'managementGroup'
metadata name = 'Policy Assignments (Subscription)'
metadata description = 'This module deploys a Policy Assignment at a Subscription scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the management group to deploy for testing purposes.')
param policyAssignmentName string = 'audit-vm-managed-disks'

@description('Optional. The policy definition ID to assign the policy to.')
param policyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'

@description('Optional. The display name of the policy.')
param policyDisplayName string = 'Audit VM managed disks'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apesubmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: policyAssignmentName
  scope: managementGroup()
  properties: {
    policyDefinitionId: policyDefinitionID
    description: 'Policy assignment to resource group scope created with Bicep file'
    displayName: policyDisplayName
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
  }
}
