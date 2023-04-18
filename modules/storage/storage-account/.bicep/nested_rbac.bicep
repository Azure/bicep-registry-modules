param description string = ''
param principalIds array
param principalType string = ''
param roleDefinitionIdOrName string
param resourceId string
param resourceType string = 'storageAccount'

var builtInRoleNames = {
  // Generic useful roles 
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')

  // Storage Account specific roles
  'Avere Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4f8fab4f-1852-4a58-a46a-8eaf358af14a')
  'Avere Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9')
  'Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e467623-bb1f-42f4-a55d-6e525e11384b')
  'Backup Operator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '00c29273-979b-4161-815c-10b084fb9324')
  'Backup Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a795c7a0-d4a2-40c1-ae25-d81f01202912')
  'Classic Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '86e8f5dc-a6e9-4c67-9d15-de283e8eac25')
  'Classic Storage Account Key Operator Service Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '985d6b00-f706-48f5-a6fe-d0ca12fb668d')
  'Data Box Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'add466c9-e687-43fc-8d98-dfcf8d720be5')
  'Data Box Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '028f4ed7-e2a9-465e-a8f4-9c0ffdfdc027')
  'Data Lake Analytics Developer': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '47b7735b-770e-4598-a7da-8b91488b4c88')
  'Elastic SAN Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '80dcbedb-47ef-405d-95bd-188a1b4ac406')
  'Elastic SAN Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'af6a70f8-3c9f-4105-acf1-d719e9fca4ca')
  'Elastic SAN Volume Group Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a8281131-f312-4f34-8d98-ae12be9f0d23')
  'Reader and Data Access': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c12c1c16-33a1-487b-954d-41c89c60f349')
  'Storage Account Backup Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1')
  'Storage Account Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')
  'Storage Account Key Operator Service Role': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '81a9662b-bebf-436f-a333-f67b29880f12')
  'Storage Blob Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  'Storage Blob Data Owner': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b')
  'Storage Blob Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1')
  'Storage Blob Delegator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'db58b8e5-c6ad-4a2a-8342-4190687cbf4a')
  'Storage File Data SMB Share Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb')
  'Storage File Data SMB Share Elevated Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a7264617-510b-434b-a828-9731dc254ea7')
  'Storage File Data SMB Share Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'aba4ae5f-2193-4029-9191-0cb91df5e314')
  'Storage Queue Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '974c5e8b-45b9-4653-ba55-5f855dd0fb88')
  'Storage Queue Data Message Processor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8a0f0c08-91a1-4084-bc3d-661d67233fed')
  'Storage Queue Data Message Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a')
  'Storage Queue Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '19e7f393-937e-4f77-808e-94535e297925')
  'Storage Table Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3')
  'Storage Table Data Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '76199698-9eea-4c19-bc75-cec21354c6b6')
}

resource storageResourceScope 'Microsoft.Storage/storageAccounts@2022-09-01' existing = if (resourceType == 'storageAccount') {
  name: last(split(resourceId, '/'))
}

resource containerResourceScope 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' existing = if (resourceType == 'blobContainer') {
  name: last(split(resourceId, '/'))
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
  name: guid(resourceType == 'blobContainer' ? containerResourceScope.id : storageResourceScope.id, principalId, roleDefinitionIdOrName)
  properties: {
    description: description
    roleDefinitionId: contains(builtInRoleNames, roleDefinitionIdOrName) ? builtInRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName
    principalId: principalId
    principalType: !empty(principalType) ? principalType : null
  }
  scope: resourceType == 'blobContainer' ? containerResourceScope : storageResourceScope
}]
