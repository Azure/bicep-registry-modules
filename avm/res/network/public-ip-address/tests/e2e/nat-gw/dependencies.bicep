@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the NAT Gateway to create.')
param natGatewayName string

resource natGateway 'Microsoft.Network/natGateways@2025-01-01' = {
  name: natGatewayName
  location: location
}

@description('The principal ID of the created Managed Identity.')
output natGatewayId string = natGateway.id
