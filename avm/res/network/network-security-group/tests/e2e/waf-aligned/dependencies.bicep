@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Application Security Group to create.')
param applicationSecurityGroupName string

resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2023-04-01' = {
  name: applicationSecurityGroupName
  location: location
}

@description('The resource ID of the created Application Security Group.')
output applicationSecurityGroupResourceId string = applicationSecurityGroup.id
