@export()
@description('Values to establish private networking for resources that support creating private endpoints.')
type resourcePrivateNetworkingType = {
  @description('Required. The Resource ID of the subnet to establish the Private Endpoint(s).')
  privateEndpointSubnetId: string

  @description('Required. The Resource ID of an existing Private DNS Zone Resource to link to the virtual network.')
  privateDnsZoneId: string
}
