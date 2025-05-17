metadata name = 'Dev Center Environment Type'
metadata description = 'This module deploys a Dev Center Environment Type.'

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcentereName string

@description('Required. The name of the environment type.')
param name string

@description('Optional. The display name of the environment type.')
param displayName string?

@description('Optional. Tags of the resource.')
param tags object?

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' existing = {
  name: devcentereName
}

resource environmentType 'Microsoft.DevCenter/devcenters/environmentTypes@2025-02-01' = {
  parent: devcenter
  name: name
  properties: {
    displayName: displayName
  }
  tags: tags
}
