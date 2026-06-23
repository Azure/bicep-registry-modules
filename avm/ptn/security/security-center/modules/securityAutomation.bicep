@sys.description('Required. The name of the security automation.')
param name string

@sys.description('Optional. Location for the resource.')
param location string = resourceGroup().location

@sys.description('Optional. Tags for the resource.')
param tags object?

@sys.description('Optional. Description of the security automation.')
param automationDescription string?

@sys.description('Optional. Whether the security automation is enabled.')
param isEnabled bool = true

@sys.description('Required. The scopes on which the automation logic is applied.')
param scopes array

@sys.description('Required. The source event types which evaluate the rules.')
param sources array

@sys.description('Required. The actions triggered when rules evaluate to true.')
param actions array

resource securityAutomation 'Microsoft.Security/automations@2023-12-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: automationDescription
    isEnabled: isEnabled
    scopes: scopes
    sources: sources
    actions: actions
  }
}

@sys.description('The resource ID of the security automation.')
output resourceId string = securityAutomation.id

@sys.description('The name of the security automation.')
output name string = securityAutomation.name
