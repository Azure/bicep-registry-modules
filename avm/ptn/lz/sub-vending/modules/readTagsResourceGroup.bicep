@description('Optional. The name of the tags resource.')
param name string = 'default'

resource tags 'Microsoft.Resources/tags@2025-04-01' existing = {
  name: name
}

@description('Tags currently applied to the subscription level')
output existingTags object = tags.properties.?tags ?? {}
