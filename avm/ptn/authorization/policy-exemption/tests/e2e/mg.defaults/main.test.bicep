targetScope = 'managementGroup'
metadata name = 'Policy Exemptions (Management Group scope)'
metadata description = 'This module deploys a Policy Exemption at a Management Group scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apemgmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //

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
  }
}
