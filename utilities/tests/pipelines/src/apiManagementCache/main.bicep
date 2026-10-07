import { cacheType } from '../../../../../avm/res/api-management/service/main.bicep'

@description('A cache supplied by the caller, with a secure connection string leaf.')
param suppliedCache cacheType

// Intentionally plain caller-owned inputs, to guard compatibility with existing deployments.
param existingValue string
param existingCache existingCacheType
param existingCaches existingCacheType[]

type existingCacheType = {
  name: string
  connectionString: string
  useFromLocation: string
}

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
  {
    name: 'plain-string'
    connectionString: existingValue
    useFromLocation: 'default'
  }
  existingCache
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

module plainArrayParent '../../../../../avm/res/api-management/service/main.bicep' = {
  name: 'plain-array-parent'
  params: {
    name: 'cache-test-service'
    publisherEmail: 'test@example.com'
    publisherName: 'Cache test'
    caches: existingCaches
  }
}

module plainStringChild '../../../../../avm/res/api-management/service/cache/main.bicep' = {
  name: 'plain-string-child'
  params: {
    apiManagementServiceName: 'cache-test-service'
    name: 'plain-string'
    connectionString: existingValue
    useFromLocation: 'default'
  }
}

module nullCaches '../../../../../avm/res/api-management/service/main.bicep' = {
  name: 'null-caches'
  params: {
    name: 'cache-test-service'
    publisherEmail: 'test@example.com'
    publisherName: 'Cache test'
    caches: null
  }
}

module omittedCaches '../../../../../avm/res/api-management/service/main.bicep' = {
  name: 'omitted-caches'
  params: {
    name: 'cache-test-service'
    publisherEmail: 'test@example.com'
    publisherName: 'Cache test'
  }
}
