metadata name = 'Load Balancer Backend Address Pools'
metadata description = 'This module deploys a Load Balancer Backend Address Pools.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent load balancer. Required if the template is used in a standalone deployment.')
param loadBalancerName string

@description('Required. The name of the backend address pool.')
param name string

@description('Optional. An array of backend addresses.')
param loadBalancerBackendAddresses array = []

@description('Optional. An array of gateway load balancer tunnel interfaces.')
param tunnelInterfaces array = []

@description('Optional. Amount of seconds Load Balancer waits for before sending RESET to client and backend address. if value is 0 then this property will be set to null. Subscription must register the feature Microsoft.Network/SLBAllowConnectionDraining before using this property.')
param drainPeriodInSeconds int = 0

@allowed([
  ''
  'Automatic'
  'Manual'
])
@description('Optional. Backend address synchronous mode for the backend pool.')
param syncMode string = ''

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' existing = {
  name: loadBalancerName
}

resource backendAddressPool 'Microsoft.Network/loadBalancers/backendAddressPools@2023-04-01' = {
  name: name
  properties: {
    loadBalancerBackendAddresses: loadBalancerBackendAddresses
    tunnelInterfaces: tunnelInterfaces
    drainPeriodInSeconds: drainPeriodInSeconds != 0 ? drainPeriodInSeconds : null
    syncMode: !empty(syncMode) ? syncMode : null
  }
  parent: loadBalancer
}

@description('The name of the backend address pool.')
output name string = backendAddressPool.name

@description('The resource ID of the backend address pool.')
output resourceId string = backendAddressPool.id

@description('The resource group the backend address pool was deployed into.')
output resourceGroupName string = resourceGroup().name
