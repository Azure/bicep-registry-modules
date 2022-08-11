param componentName string
param location string
param entityName string
param containerAppEnvName string

param createAzureServiceForComponent bool = true

param scopes array = []

var daprComponent = 'state.azure.cosmosdb'
var databaseKeyName = 'masterkey'
var databaseName = '${entityName}Db'
var databaseLocations = [
  {
    locationName: location
    failoverPriority: 0
    isZoneRedundant: false
  }
]

resource containerAppEnv 'Microsoft.App/managedEnvironments@2022-01-01-preview' existing = {
  name: containerAppEnvName
}

resource daprCosmos 'Microsoft.App/managedEnvironments/daprComponents@2022-03-01' = {
  name: componentName
  parent: containerAppEnv
  properties: {
    componentType: daprComponent
    version: 'v1'
    secrets: [
      {
        name: databaseKeyName
        value: dbAccount.listKeys().primaryMasterKey
      }
    ]
    metadata: [
      {
        name: 'url'
        value: dbAccount.properties.documentEndpoint
      }
      {
        name: 'database'
        value: databaseName
      }
      {
        name: 'collection'
        value: entityName
      }
      {
        name: databaseKeyName
        secretRef: databaseKeyName
      }
    ]
    scopes: scopes
  }
}

resource dbAccount 'Microsoft.DocumentDB/databaseAccounts@2022-05-15' = if(createAzureServiceForComponent) {
  name: 'cosmos-${componentName}-${uniqueString(resourceGroup().id, location)}'
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: databaseLocations
    databaseAccountOfferType: 'Standard'
  }
  
  resource db 'sqlDatabases' = {
    name: databaseName
    properties: {
      resource: {
        id: databaseName
      }
    }
    
    resource container 'containers' = {
      name: entityName
      properties: {
        resource: {
          id: entityName
          partitionKey: {
            paths: [
              '/partitionKey'
            ]
            kind: 'Hash'
          }
        }
        options: {
          autoscaleSettings: {
            maxThroughput: 4000
          }
        }
      }
    }
  }
}

