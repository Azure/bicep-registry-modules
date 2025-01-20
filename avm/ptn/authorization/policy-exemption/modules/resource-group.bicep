metadata name = 'Policy Exemptions (Resource Group scope)'
metadata description = 'This module deploys a policy exemption at a Resource Group scope.'

targetScope = 'resourceGroup'

@sys.description('Required. Specifies the name of the policy exemption. Maximum length is 64 characters for resource group scope.')
@maxLength(64)
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

resource policyExemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: name
  properties: {
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

@sys.description('Policy exemption name.')
output name string = policyExemption.name

@sys.description('Policy exemption resource ID.')
output resourceId string = policyExemption.id
