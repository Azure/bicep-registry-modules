targetScope = 'managementGroup'
metadata name = 'Policy Exemptions (Management Group scope)'
metadata description = 'This module deploys a Policy Exemption at a Management Group scope using common parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apemgmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The policy definition ID to assign the policy to.')
param policyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: 'audit-vm-managed-disks'
  scope: managementGroup()
  properties: {
    metadata: {
      assignedBy: 'Bicep'
    }
    policyDefinitionId: policyDefinitionID
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
    expiresOn: '2024-11-14T20:46:13Z'
    location: resourceLocation
    managementGroupId: 'alz-landingzones'
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
