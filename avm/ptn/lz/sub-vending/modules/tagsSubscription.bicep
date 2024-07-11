targetScope = 'subscription'

@description('Optional. Tags for the resource group. If not provided, removes existing tags.')
param tags object = {}

@description('Optional. The name of the tags resource.')
param name string = 'default'

@description('Optional. Instead of overwriting the existing tags, combine them with the new tags.')
param onlyUpdate bool = false

module readTags 'readTagsSubscription.bicep' = if (onlyUpdate) {
  name: '${deployment().name}-ReadTags'
}

var newTags = (onlyUpdate) ? union(readTags.outputs.existingTags, tags) : tags

resource tag 'Microsoft.Resources/tags@2019-10-01' = {
  name: name
  properties: {
    tags: newTags
  }
}

@description('The name of the tags resource.')
output name string = tag.name

@description('The applied tags.')
output tags object = newTags

@description('The resource ID of the applied tags.')
output resourceId string = tag.id
