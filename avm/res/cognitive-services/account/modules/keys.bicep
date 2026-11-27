@description('Required. The name of the Cognitive Services account.')
param accountName string

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2025-06-01' existing = {
  name: accountName
}

@secure()
@description('The primary access key.')
output primaryKey string = cognitiveService.listKeys().key1

@secure()
@description('The secondary access key.')
output secondaryKey string = cognitiveService.listKeys().key2
