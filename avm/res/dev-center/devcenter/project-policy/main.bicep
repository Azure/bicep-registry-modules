metadata name = 'Dev Center Project Policy'
metadata description = 'This module deploys a Dev Center Project Policy.'

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcentereName string

@description('Required. The name of the project policy.')
param name string

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' existing = {
  name: devcentereName
}

resource projectPolicy 'Microsoft.DevCenter/devcenters/projectPolicies@2025-02-01' = {
  parent: devcenter
  name: name
  properties: {
    resourcePolicies: [
      {
        action: 'string'
        filter: 'string'
        resources: 'string'
        resourceType: 'string'
      }
    ]
    scopes: [
      'string'
    ]
  }
}
