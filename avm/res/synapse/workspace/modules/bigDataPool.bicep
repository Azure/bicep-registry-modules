// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. The name of the Big Data Pool.')
param name string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. The kind of nodes that the Big Data pool provides.')
@allowed([
  'HardwareAcceleratedFPGA'
  'HardwareAcceleratedGPU'
  'MemoryOptimized'
  'None'
])
param nodeSizeFamily string = 'MemoryOptimized'

@allowed([
  'Large'
  'Medium'
  'None'
  'Small'
  'XLarge'
  'XXLarge'
  'XXXLarge'
])
@description('Required. The level of compute power that each node in the Big Data pool has.')
param nodeSize string

@description('Optional. Auto-scaling properties.')
param autoScale autoScaleType?

@description('Optional. The number of nodes in the Big Data pool if Auto-scaling is disabled.')
@minValue(3)
@maxValue(200)
param nodeCount int = 3

@description('Optional. Dynamic Executor Allocation.')
param dynamicExecutorAllocation dynamicExecutorAllocationType?

@description('Optional. Synapse workspace Big Data Pools Auto-pausing delay in minutes (5-10080). Disabled if value not provided. 10,080 equals 7 days in minutes.')
@minValue(-1)
@maxValue(10080) // 7 days in minutes
param autoPauseDelayInMinutes int = -1

@description('Optional. The Apache Spark version.')
@allowed([
  '3.4'
  '3.5'
])
param sparkVersion string = '3.4'

@description('Optional. Spark configuration file to specify additional properties.')
param sparkConfigProperties sparkConfigPropertiesType?

@description('Optional. Whether session level packages enabled. Disabled if value not provided.')
param sessionLevelPackagesEnabled bool = false

@description('Optional. The cache size.')
@minValue(0)
@maxValue(100)
param cacheSize int = 50

@description('Optional. The default folder where Spark logs will be written.')
param defaultSparkLogFolder string?

@description('Optional. Whether Auto-tune is Enabled or not. Disabled if value not provided.')
param autotuneEnabled bool = false

@description('Optional. Whether Compute Isolation is enabled or not. Disabled if value not provided.')
param computeIsolationEnabled bool = false

@description('Optional. The Spark events folder.')
param sparkEventsFolder string?

@description('Optional. Library version requirements. Must only be set on an update (the pool must already exist).')
param libraryRequirements libraryRequirementsType?

@description('Optional. List of custom libraries/packages associated with the spark pool. Must only be set on an update (the pool must already exist).')
param customLibraries customLibraryType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01'>.tags?

// ================ //
// Resources        //
// ================ //

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource bigDataPool 'Microsoft.Synapse/workspaces/bigDataPools@2021-06-01' = {
  name: name
  parent: workspace
  location: location
  tags: tags
  properties: {
    nodeSizeFamily: nodeSizeFamily
    nodeSize: nodeSize
    autoScale: !empty(autoScale)
      ? {
          enabled: true
          minNodeCount: autoScale.?minNodeCount
          maxNodeCount: autoScale.?maxNodeCount
        }
      : {
          enabled: false
        }
    nodeCount: empty(autoScale) ? nodeCount : null
    dynamicExecutorAllocation: !empty(dynamicExecutorAllocation)
      ? {
          enabled: true
          minExecutors: dynamicExecutorAllocation.?minExecutors
          maxExecutors: dynamicExecutorAllocation.?maxExecutors
        }
      : {
          enabled: false
        }
    autoPause: autoPauseDelayInMinutes != -1
      ? {
          enabled: true
          delayInMinutes: autoPauseDelayInMinutes < 5 ? 5 : autoPauseDelayInMinutes // Minimum 5 minutes
        }
      : {
          enabled: false
        }
    sparkVersion: sparkVersion
    sparkConfigProperties: sparkConfigProperties
    sessionLevelPackagesEnabled: sessionLevelPackagesEnabled
    cacheSize: cacheSize
    defaultSparkLogFolder: defaultSparkLogFolder
    isAutotuneEnabled: autotuneEnabled
    isComputeIsolationEnabled: computeIsolationEnabled
    sparkEventsFolder: sparkEventsFolder
    libraryRequirements: libraryRequirements
    customLibraries: customLibraries
  }
}

// =============== //
//   Outputs       //
// =============== //

@description('The name of the deployed Big Data Pool.')
output name string = bigDataPool.name

@description('The resource ID of the deployed Big Data Pool.')
output resourceId string = bigDataPool.id

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The synapse workspace Big Data Pools Auto-scaling properties.')
type autoScaleType = {
  @description('Required. Synapse workspace Big Data Pools Auto-scaling maximum node count.')
  @minValue(3)
  @maxValue(200)
  maxNodeCount: int

  @description('Required. Synapse workspace Big Data Pools Auto-scaling minimum node count.')
  @minValue(3)
  @maxValue(200)
  minNodeCount: int
}

@export()
@description('The synapse workspace Big Data Pools Dynamic Executor Allocation properties.')
type dynamicExecutorAllocationType = {
  @description('Required. Synapse workspace Big Data Pools Dynamic Executor Allocation minimum executors.')
  @minValue(1)
  @maxValue(10)
  minExecutors: int

  @description('Required. Synapse workspace Big Data Pools Dynamic Executor Allocation maximum executors (maxNodeCount-1).')
  @minValue(1)
  @maxValue(10)
  maxExecutors: int
}

@export()
@description('The synapse workspace Big Data Pools Spark configuration file properties.')
type sparkConfigPropertiesType = {
  @description('Required. The configuration type.')
  configurationType: ('Artifact' | 'File')

  @description('Required. The configuration content.')
  content: string

  @description('Required. The configuration filename.')
  filename: string
}

@export()
@description('The synapse workspace Big Data Pools library version requirements.')
type libraryRequirementsType = {
  @description('Required. The library requirements (e.g. contents of a requirements.txt file).')
  content: string

  @description('Required. The filename of the library requirements file.')
  filename: string
}

@export()
@description('The synapse workspace Big Data Pools custom library/package info.')
type customLibraryType = {
  @description('Optional. Storage blob container name.')
  containerName: string?

  @description('Optional. Name of the library.')
  name: string?

  @description('Optional. Storage blob path of library.')
  path: string?

  @description('Optional. Type of the library (e.g. \'whl\', \'jar\').')
  type: string?
}
