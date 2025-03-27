targetScope = 'managementGroup'

@description('Optional. Policy definitions to create on the management group.')
param managementGroupCustomPolicyDefinitions policyDefinitionType[]?

resource mgCustomPolicyDefinitions 'Microsoft.Authorization/policyDefinitions@2025-01-01' = [
  for (polDef, index) in (managementGroupCustomPolicyDefinitions ?? []): {
    name: polDef.name
    properties: {
      description: polDef.properties.description
      displayName: polDef.properties.displayName
      metadata: polDef.properties.metadata
      mode: polDef.properties.mode
      parameters: polDef.properties.parameters
      policyType: polDef.properties.policyType
      policyRule: polDef.properties.policyRule
      version: polDef.properties.version
    }
  }
]

@export()
@description('A type for policy definitions.')
type policyDefinitionType = {
  @maxLength(128)
  @description('Required. Specifies the name of the policy definition. Maximum length is 128 characters for management group scope.')
  name: string

  @description('Required. The properties of the policy definition.')
  properties: resourceInput<'Microsoft.Authorization/policyDefinitions@2025-01-01'>.properties
}
