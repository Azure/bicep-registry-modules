targetScope = 'managementGroup'

metadata name = 'Policy Remediation (Subscription scope)'
metadata description = 'This module runs a Policy remediation task at subscription scope using minimal parameters.'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@sys.description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pirsubmin'

@sys.description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Subscription ID of the target subscription.')
param subscriptionId string = '#_subscriptionId_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================

module policySetAssignments 'br/public:avm/ptn/authorization/policy-assignment:0.1.0' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-policySetAssignment-sub'
  params: {
    name: 'dep-${namePrefix}-psa-${serviceShort}'
    subscriptionId: subscriptionId
    location: resourceLocation
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/12794019-7a00-42cf-95c2-882eed337cc8'
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    subscriptionId: subscriptionId
    policyAssignmentId: policySetAssignments.outputs.resourceId
    policyDefinitionReferenceId: 'Prerequisite_DeployExtensionWindows'
  }
}
