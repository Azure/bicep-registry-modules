metadata name = 'Registration Assignment'
metadata description = 'Create a registration assignment.'
metadata category = 'Managed Services'

@description('Required. The ID of the registration definition.')
param registrationDefinitionId string

@description('Required. The ID of the registration assignment.')
param registrationAssignmentId string

resource registrationAssignment 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: registrationAssignmentId
  properties: {
    registrationDefinitionId: registrationDefinitionId
  }
}

@description('The name of the registration assignment.')
output name string = registrationAssignment.name

@description('The resource ID of the registration assignment.')
output resourceId string = registrationAssignment.id
