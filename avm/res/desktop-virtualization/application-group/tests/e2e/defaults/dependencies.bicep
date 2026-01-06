@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Host Pool to create.')
param hostPoolName string

#disable-next-line use-recent-api-versions
resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-03-01-preview' = {
  name: hostPoolName
  location: location
  properties: {
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
  }
}

@description('The name of the created Host Pool.')
output hostPoolName string = hostPool.name
