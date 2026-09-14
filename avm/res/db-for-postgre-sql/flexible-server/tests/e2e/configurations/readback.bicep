metadata name = 'Configuration read-back helper'
metadata description = 'Reads back the persisted value of static PostgreSQL flexible server configurations to validate that requested values are actually applied.'

@description('Required. The name of the parent PostgreSQL flexible server.')
param flexibleServerName string

@description('Required. The configurations to read back, including the value that was requested during deployment.')
param expectedConfigurations configurationType[]

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2025-08-01' existing = {
  name: flexibleServerName
}

resource configurations 'Microsoft.DBforPostgreSQL/flexibleServers/configurations@2025-08-01' existing = [
  for configuration in expectedConfigurations: {
    name: configuration.name
    parent: flexibleServer
  }
]

// Materialize the persisted-vs-requested comparison per configuration. A for-expression in an
// output body may index the resource collection, whereas variables and map/reduce lambdas may not.
@description('The requested vs. persisted value for each configuration, including whether they match.')
output results configurationResultType[] = [
  for (configuration, index) in expectedConfigurations: {
    name: configuration.name
    expectedValue: configuration.value
    actualValue: configurations[index].properties.value
    persisted: configurations[index].properties.value == configuration.value
  }
]

@export()
@description('The type describing an expected configuration and its requested value.')
type configurationType = {
  @description('Required. The name of the configuration (server parameter).')
  name: string

  @description('Required. The requested value of the configuration (server parameter).')
  value: string
}

@export()
@description('The type describing the read-back result for a single configuration.')
type configurationResultType = {
  @description('Required. The name of the configuration (server parameter).')
  name: string

  @description('Required. The value requested during deployment.')
  expectedValue: string

  @description('Required. The value currently persisted on the server.')
  actualValue: string

  @description('Required. Whether the persisted value matches the requested value.')
  persisted: bool
}
