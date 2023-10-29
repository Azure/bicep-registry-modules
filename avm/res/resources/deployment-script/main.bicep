metadata name = 'Deployment Scripts'
metadata description = 'This module deploys Deployment Scripts.'
metadata owner = 'Azure/module-maintainers'

param location string = resourceGroup().location
resource akv 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: 'akv'
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
  }
}
