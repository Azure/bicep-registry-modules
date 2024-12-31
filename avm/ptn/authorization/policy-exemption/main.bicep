metadata name = 'Policy Exemptions (All scopes)'
metadata description = 'This module deploys a Policy Exemption at a Management Group, Subscription or Resource Group scope.'

targetScope = 'managementGroup'

@sys.description('Required. Specifies the name of the policy exemption. Maximum length is 24 characters for management group scope.')
@maxLength(24)
param name string

@sys.description('Optional. The option to validate whether the exemption is at or under the assignment scope.')
@allowed([
  'DoNotValidate'
  'Default'
])
param assignmentScopeValidation string = 'Default'

@sys.description('Optional. This message will be part of response in case of policy violation.')
param description string?

@sys.description('Optional. The display name of the policy exemption. Maximum length is 128 characters.')
@maxLength(128)
param displayName string?

@sys.description('Required. The policy exemption category.')
@allowed([
  'Mitigated'
  'Waiver'
])
param exemptionCategory string

@sys.description('Optional. The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption.')
@maxLength(20)
@minLength(20)
param expiresOn string?

@sys.description('Optional. The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param metadata object?

@sys.description('Required. Specifies the ID of the policy assignment that is being exempted.')
param policyAssignmentId string

@sys.description('Optional. The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyDefinitionReferenceIds string[]?

@sys.description('Optional. The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out Policy exemptions based on factors like resource location, resource type, or whether a resource has a location.')
param resourceSelectors array?

@sys.description('Optional. The Target Scope for the Policy. The name of the management group for the policy exemption. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. The Target Scope for the Policy. The subscription ID of the subscription for the policy exemption.')
param subscriptionId string?

@sys.description('Optional. The Target Scope for the Policy. The name of the resource group for the policy exemption.')
param resourceGroupName string?

@sys.description('Optional. Location for all Resources.')
param location string = deployment().location

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.authorization-policyexemption.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

module policyExemption_mg 'modules/management-group.bicep' = if (empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-PolicyExemption-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    name: name
    description: description
    displayName: displayName
    assignmentScopeValidation: assignmentScopeValidation
    exemptionCategory: exemptionCategory
    expiresOn: expiresOn
    metadata: metadata
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: policyDefinitionReferenceIds
    resourceSelectors: resourceSelectors
  }
}

module policyExemption_sub 'modules/subscription.bicep' = if (!empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-PolicyExemption-Sub-Module'
  scope: subscription(subscriptionId ?? '')
  params: {
    name: name
    description: description
    displayName: displayName
    assignmentScopeValidation: assignmentScopeValidation
    exemptionCategory: exemptionCategory
    expiresOn: expiresOn
    metadata: metadata
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: policyDefinitionReferenceIds
    resourceSelectors: resourceSelectors
  }
}

module policyExemption_rg 'modules/resource-group.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-PolicyExemption-RG-Module'
  scope: resourceGroup(subscriptionId ?? '', resourceGroupName ?? '')
  params: {
    name: name
    description: description
    displayName: displayName
    assignmentScopeValidation: assignmentScopeValidation
    exemptionCategory: exemptionCategory
    expiresOn: expiresOn
    metadata: metadata
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceIds: policyDefinitionReferenceIds
    resourceSelectors: resourceSelectors
  }
}

@sys.description('Policy Exemption Name.')
output name string = empty(subscriptionId) && empty(resourceGroupName)
  ? policyExemption_mg.outputs.name
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? policyExemption_sub.outputs.name
      : policyExemption_rg.outputs.name)

@sys.description('Policy Exemption resource ID.')
output resourceId string = empty(subscriptionId) && empty(resourceGroupName)
  ? policyExemption_mg.outputs.resourceId
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? policyExemption_sub.outputs.resourceId
      : policyExemption_rg.outputs.resourceId)
