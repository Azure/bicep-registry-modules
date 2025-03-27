targetScope = 'managementGroup'

@description('Optional. Policy set definitions to create on the management group.')
param managementGroupCustomPolicySetDefinitions policySetDefinitionsType[]?

resource mgCustomPolicySetDefinitions 'Microsoft.Authorization/policySetDefinitions@2025-01-01' = [
  for (polSetDef, index) in (managementGroupCustomPolicySetDefinitions ?? []): {
    name: polSetDef.name
    properties: {
      description: polSetDef.properties.?description
      displayName: polSetDef.properties.?displayName
      metadata: polSetDef.properties.?metadata
      parameters: polSetDef.properties.?parameters
      policyType: polSetDef.properties.?policyType
      version: polSetDef.properties.?version
      policyDefinitions: [
        for polDef in polSetDef.properties.policyDefinitions: {
          policyDefinitionReferenceId: polDef.?policyDefinitionReferenceId
          policyDefinitionId: polDef.policyDefinitionId
          parameters: polDef.?parameters
          groupNames: polDef.?groupNames
          definitionVersion: polDef.?definitionVersion
        }
      ]
      policyDefinitionGroups: polSetDef.properties.?policyDefinitionGroups
    }
  }
]

@export()
@description('A type for policy set definitions.')
type policySetDefinitionsType = {
  @maxLength(128)
  @description('Required. Specifies the name of the policy set definition. Maximum length is 128 characters for management group scope.')
  name: string

  @description('Required. The properties of the policy set definition.')
  properties: resourceInput<'Microsoft.Authorization/policySetDefinitions@2025-01-01'>.properties
}
