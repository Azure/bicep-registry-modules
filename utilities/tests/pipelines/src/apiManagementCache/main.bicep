import { cacheType } from '../../../../../avm/res/api-management/service/main.bicep'

@description('A cache supplied by the caller, with a secure connection string leaf.')
param suppliedCache cacheType

var caches = [
  suppliedCache
  {
    name: 'westeurope'
    connectionString: 'cache.example:6380,ssl=True'
    useFromLocation: 'westeurope'
  }
  {
    name: 'eastus'
    connectionString: '{{cache-connection-string}}'
    useFromLocation: 'eastus'
  }
]

module parentCaller '../../../../../avm/res/api-management/service/main.bicep' = {
  name: 'parent-caller'
  params: {
    name: 'cache-test-service'
    publisherEmail: 'test@example.com'
    publisherName: 'Cache test'
    caches: caches
  }
}

module childCaller '../../../../../avm/res/api-management/service/cache/main.bicep' = [
  for (cache, index) in caches: {
    name: 'child-caller-${index}'
    params: {
      apiManagementServiceName: 'cache-test-service'
      name: cache.name
      connectionString: cache.connectionString
      useFromLocation: cache.useFromLocation
    }
  }
]
