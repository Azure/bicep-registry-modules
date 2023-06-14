param location string = resourceGroup().location
param saname string = 'sa${uniqueString(resourceGroup().id)}'
param uaiName string = 'storageAccountOperator'
param roleInfoOperator object = {
  roleDefinitionId: '81a9662b-bebf-436f-a333-f67b29880f12'
  roleName: 'Storage Account Key Operator Service Role'
  description: 'Storage account key operator for User assigned identity'
}

param roleInfoContributor object = {
  roleDefinitionId: '17d1049b-9a84-46fb-8f53-869881c3d3ab'
}

resource UAI 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: uaiName
  location: location
}

module storageAccount 'br/public:storage/storage-account:1.0.1' = {
  name: saname
  params: {
    location: location
    name: saname
  }
}

// module call with all parameters
module roleAssignmentOperator '../main.bicep' = {
  name: take('roleAssignment-storage-accountKeyOperator', 64)
  params: {
    name: guid(UAI.properties.principalId, roleInfoOperator.roleDefinitionId, storageAccount.outputs.id)
    principalId: UAI.properties.principalId
    resourceId: storageAccount.outputs.id
    roleDefinitionId: roleInfoOperator.roleDefinitionId
    description: roleInfoOperator.description
    roleName: roleInfoOperator.roleName
    principalType: 'ServicePrincipal'
  }
}

// module call with only required parameters
module roleAssignmentContributor '../main.bicep' = {
  name: take('roleAssignment-storage-accountContributor', 64)
  params: {
    name: guid(UAI.properties.principalId, roleInfoContributor.roleDefinitionId, storageAccount.outputs.id)
    principalId: UAI.properties.principalId
    resourceId: storageAccount.outputs.id
    roleDefinitionId: roleInfoContributor.roleDefinitionId
  }
}

output roleAssignmentOperator string = roleAssignmentOperator.outputs.id
output roleAssignmentContributor string = roleAssignmentContributor.outputs.id
