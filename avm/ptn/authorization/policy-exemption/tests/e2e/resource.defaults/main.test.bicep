targetScope = 'managementGroup'
metadata name = 'Policy Exemption (Resource)'
metadata description = 'This module deploys a Policy Exemption at a resource scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aperesmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The target scope for the policy exemption. If not provided, will use the current scope for deployment.')
param subscriptionId string = '#_subscriptionId_#'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-authorization.policyexemptions-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

// ============== //
// Test Execution //
// ============== //

module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.3' = {
  scope: subscription('${subscriptionId}')
  name: '${uniqueString(deployment().name, resourceLocation)}-resourceGroup'
  params: {
    name: resourceGroupName
    location: resourceLocation
  }
}

module virtualNetwork './dependencies.bicep' = {
  scope: az.resourceGroup(subscriptionId, resourceGroupName)
  name: '${uniqueString(deployment().name, resourceLocation)}-vnet'
  params: {
    location: resourceLocation
    virtualNetworkName: 'vnet-${namePrefix}-${serviceShort}'
  }
}

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2025-03-01' existing = {
  name: '06a78e20-9358-41c9-923c-fb736d382a4d'
  scope: tenant()
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2025-03-01' = {
  name: 'audit-vm-managed-disks'
  scope: managementGroup()
  properties: {
    metadata: {
      assignedBy: 'Bicep'
    }
    policyDefinitionId: policyDefinition.id
    description: '  This policy audits VMs that do not use managed disks'
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
    resourceId: virtualNetwork.outputs.vnetResourceId
  }
}
