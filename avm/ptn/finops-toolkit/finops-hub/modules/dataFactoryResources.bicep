// ============================================================================
// FinOps Hub - Data Factory Resources
// ============================================================================
// Creates all Data Factory child resources: linked services, datasets, pipelines, triggers.
// Reference: https://github.com/microsoft/finops-toolkit/tree/main/src/templates/finops-hub
// ============================================================================

targetScope = 'resourceGroup'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Required. Name of the Data Factory.')
param dataFactoryName string

@description('Required. Name of the storage account.')
param storageAccountName string

@description('Required. Name of the Key Vault.')
param keyVaultName string

@description('Optional. Data Explorer cluster endpoint (for ADX deployments).')
param dataExplorerEndpoint string = ''

@description('Optional. Data Explorer cluster system-assigned managed identity principal ID.')
param dataExplorerPrincipalId string = ''

@description('Optional. Fabric eventhouse query URI (for Fabric deployments).')
param fabricQueryUri string = ''

@description('Optional. Name of the integration runtime to use. If using managed VNet, this should reference the managed IR.')
param integrationRuntimeName string = ''

@description('Optional. FinOps toolkit version.')
param ftkVersion string = '0.7.0'

@description('Optional. Billing account ID for MACC tracking. Required for MACC pipelines.')
param billingAccountId string = ''

// ============================================================================
// VARIABLES
// ============================================================================

var CONFIG = 'config'
var INGESTION = 'ingestion'
var MSEXPORTS = 'msexports'
var INGESTION_ID_SEPARATOR = '__'
var useDataExplorer = !empty(dataExplorerEndpoint)
var useFabric = !empty(fabricQueryUri)
var useAnalytics = useDataExplorer || useFabric
var dataExplorerUri = useDataExplorer ? dataExplorerEndpoint : (useFabric ? fabricQueryUri : '')

// Authentication method differs between ADX and Fabric
// ADX uses managed identity, Fabric uses impersonation
var ingestionAuthMethod = useFabric ? 'impersonate' : 'managed_identity=system'

// Annotations for tracking
var hubAnnotations = ['FinOps Hub', 'ftk-version-${ftkVersion}']

// Integration runtime configuration for managed VNet
var useIntegrationRuntime = !empty(integrationRuntimeName)
var connectViaProperty = useIntegrationRuntime ? {
  referenceName: integrationRuntimeName
  type: 'IntegrationRuntimeReference'
} : null

// MACC (Microsoft Azure Consumption Commitment) support
var useMacc = !empty(billingAccountId) && useAnalytics

// ============================================================================
// EXISTING RESOURCES
// ============================================================================

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
}

// ============================================================================
// LINKED SERVICES
// ============================================================================

// Storage Account linked service (ADLS Gen2)
resource linkedService_storage 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: storageAccountName
  parent: dataFactory
  properties: {
    type: 'AzureBlobFS'
    typeProperties: {
      url: 'https://${storageAccountName}.dfs.${environment().suffixes.storage}'
    }
    connectVia: connectViaProperty
    annotations: []
  }
}

// Key Vault linked service
resource linkedService_keyVault 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: keyVaultName
  parent: dataFactory
  properties: {
    type: 'AzureKeyVault'
    typeProperties: {
      baseUrl: 'https://${keyVaultName}${environment().suffixes.keyvaultDns}'
    }
    connectVia: connectViaProperty
    annotations: []
  }
}

// Data Explorer linked service (conditional)
// Uses system-assigned managed identity for authentication
resource linkedService_dataExplorer 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = if (useAnalytics) {
  name: 'dataExplorer'
  parent: dataFactory
  properties: {
    type: 'AzureDataExplorer'
    typeProperties: {
      endpoint: dataExplorerUri
      database: '@{linkedService().database}'
      // Managed identity authentication - no tenant/servicePrincipalId needed
      // ADF will use its system-assigned MI automatically
    }
    parameters: {
      database: {
        type: 'String'
        defaultValue: 'Ingestion'
      }
    }
    connectVia: connectViaProperty
    annotations: []
  }
}

// ============================================================================
// DATASETS
// ============================================================================

// Config dataset (JSON files in config container)
resource dataset_config 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: CONFIG
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'Json'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@{dataset().fileName}'
          type: 'Expression'
        }
        folderPath: {
          value: '@{dataset().folderPath}'
          type: 'Expression'
        }
        fileSystem: CONFIG
      }
    }
    parameters: {
      fileName: {
        type: 'String'
        defaultValue: 'settings.json'
      }
      folderPath: {
        type: 'String'
        defaultValue: ''
      }
    }
  }
}

// Ingestion dataset (Parquet files)
resource dataset_ingestion 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: INGESTION
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'Parquet'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@{dataset().blobPath}'
          type: 'Expression'
        }
        fileSystem: INGESTION
      }
    }
    parameters: {
      blobPath: {
        type: 'String'
      }
    }
    annotations: []
  }
}

// Ingestion files dataset (for listing files)
resource dataset_ingestion_files 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${INGESTION}_files'
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'Parquet'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileSystem: INGESTION
        folderPath: {
          value: '@dataset().folderPath'
          type: 'Expression'
        }
      }
    }
    parameters: {
      folderPath: {
        type: 'String'
      }
    }
    annotations: []
  }
}

// Ingestion manifest dataset
resource dataset_ingestion_manifest 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: 'ingestion_manifest'
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'Json'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@{dataset().fileName}'
          type: 'Expression'
        }
        folderPath: {
          value: '@{dataset().folderPath}'
          type: 'Expression'
        }
        fileSystem: INGESTION
      }
    }
    parameters: {
      fileName: {
        type: 'String'
        defaultValue: 'manifest.json'
      }
      folderPath: {
        type: 'String'
        defaultValue: INGESTION
      }
    }
    annotations: []
  }
}

// msexports manifest dataset
resource dataset_msexports_manifest 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: 'msexports_manifest'
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'Json'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@{dataset().fileName}'
          type: 'Expression'
        }
        folderPath: {
          value: '@{dataset().folderPath}'
          type: 'Expression'
        }
        fileSystem: MSEXPORTS
      }
    }
    parameters: {
      fileName: {
        type: 'String'
        defaultValue: 'manifest.json'
      }
      folderPath: {
        type: 'String'
        defaultValue: MSEXPORTS
      }
    }
    annotations: []
  }
}

// msexports dataset (CSV files)
resource dataset_msexports 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: replace('${MSEXPORTS}', '-', '_')
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        // Split blobPath into folderPath and fileName - blobPath contains full path like "subscriptions/.../file.csv"
        folderPath: {
          value: '@substring(dataset().blobPath, 0, lastIndexOf(dataset().blobPath, \'/\'))'
          type: 'Expression'
        }
        fileName: {
          value: '@substring(dataset().blobPath, add(lastIndexOf(dataset().blobPath, \'/\'), 1), sub(length(dataset().blobPath), add(lastIndexOf(dataset().blobPath, \'/\'), 1)))'
          type: 'Expression'
        }
        fileSystem: MSEXPORTS
      }
      columnDelimiter: ','
      escapeChar: '"'
      quoteChar: '"'
      firstRowAsHeader: true
    }
    parameters: {
      blobPath: {
        type: 'String'
      }
    }
  }
}

// msexports GZip dataset
resource dataset_msexports_gzip 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${MSEXPORTS}_gzip'
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        // Split blobPath into folderPath and fileName - blobPath contains full path like "subscriptions/.../file.csv.gz"
        folderPath: {
          value: '@substring(dataset().blobPath, 0, lastIndexOf(dataset().blobPath, \'/\'))'
          type: 'Expression'
        }
        fileName: {
          value: '@substring(dataset().blobPath, add(lastIndexOf(dataset().blobPath, \'/\'), 1), sub(length(dataset().blobPath), add(lastIndexOf(dataset().blobPath, \'/\'), 1)))'
          type: 'Expression'
        }
        fileSystem: MSEXPORTS
      }
      columnDelimiter: ','
      escapeChar: '"'
      quoteChar: '"'
      firstRowAsHeader: true
      compressionCodec: 'Gzip'
    }
    parameters: {
      blobPath: {
        type: 'String'
      }
    }
  }
}

// msexports Parquet dataset
resource dataset_msexports_parquet 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${MSEXPORTS}_parquet'
  parent: dataFactory
  properties: {
    linkedServiceName: {
      referenceName: linkedService_storage.name
      type: 'LinkedServiceReference'
    }
    type: 'Parquet'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        // Split blobPath into folderPath and fileName - blobPath contains full path like "subscriptions/.../file.parquet"
        folderPath: {
          value: '@substring(dataset().blobPath, 0, lastIndexOf(dataset().blobPath, \'/\'))'
          type: 'Expression'
        }
        fileName: {
          value: '@substring(dataset().blobPath, add(lastIndexOf(dataset().blobPath, \'/\'), 1), sub(length(dataset().blobPath), add(lastIndexOf(dataset().blobPath, \'/\'), 1)))'
          type: 'Expression'
        }
        fileSystem: MSEXPORTS
      }
    }
    parameters: {
      blobPath: {
        type: 'String'
      }
    }
  }
}

// ============================================================================
// PIPELINES
// ============================================================================

// msexports_ExecuteETL pipeline
// Triggered by msexports_ManifestAdded trigger when manifest.json is uploaded
resource pipeline_msexports_ExecuteETL 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${MSEXPORTS}_ExecuteETL'
  parent: dataFactory
  properties: {
    concurrency: 1
    activities: [
      {
        name: 'Wait'
        description: 'Wait for files to be fully available'
        type: 'Wait'
        dependsOn: []
        userProperties: []
        typeProperties: {
          waitTimeInSeconds: 60
        }
      }
      {
        name: 'Execute ETL'
        description: 'Run the msexports to ingestion ETL pipeline'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'Wait'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: pipeline_msexports_ETL_ingestion.name
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {
            folderPath: {
              // Strip container name from folderPath - Event Grid includes 'msexports/' prefix but dataset already has fileSystem set
              value: '@join(skip(array(split(pipeline().parameters.folderPath, \'/\')), 1), \'/\')'
              type: 'Expression'
            }
            fileName: {
              value: '@pipeline().parameters.fileName'
              type: 'Expression'
            }
          }
        }
      }
    ]
    parameters: {
      folderPath: { type: 'String' }
      fileName: { type: 'String' }
    }
    annotations: union(hubAnnotations, ['Cost Management Exports'])
  }
}

// msexports_ETL_ingestion pipeline
// Converts Cost Management exports to parquet and moves to ingestion container
resource pipeline_msexports_ETL_ingestion 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${MSEXPORTS}_ETL_${INGESTION}'
  parent: dataFactory
  properties: {
    activities: [
      {
        name: 'Read Manifest'
        description: 'Read the Cost Management export manifest'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'JsonSource'
            storeSettings: {
              type: 'AzureBlobFSReadSettings'
              recursive: false
              enablePartitionDiscovery: false
            }
            formatSettings: {
              type: 'JsonReadSettings'
            }
          }
          dataset: {
            referenceName: dataset_msexports_manifest.name
            type: 'DatasetReference'
            parameters: {
              fileName: {
                value: '@pipeline().parameters.fileName'
                type: 'Expression'
              }
              folderPath: {
                value: '@pipeline().parameters.folderPath'
                type: 'Expression'
              }
            }
          }
        }
      }
      {
        name: 'Set Export Scope'
        description: 'Extract the export scope from the manifest'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Read Manifest'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'scope'
          value: {
            value: '@if(contains(activity(\'Read Manifest\').output.firstRow, \'exportConfig\'), activity(\'Read Manifest\').output.firstRow.exportConfig.resourceId, \'\')'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Set Dataset Type'
        description: 'Extract the dataset type (FocusCost, ActualCost, etc.) from exportConfig.type'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Read Manifest'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'exportDatasetType'
          value: {
            // FIX: Use exportConfig.type (e.g., "FocusCost") instead of exportConfig.dataVersion (e.g., "1.0")
            value: '@if(contains(activity(\'Read Manifest\').output.firstRow, \'exportConfig\'), activity(\'Read Manifest\').output.firstRow.exportConfig.type, \'FocusCost\')'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Set Hub Dataset'
        description: 'Map export dataset type to hub folder name (FocusCost → Costs, PriceSheet → Prices, etc.)'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Set Dataset Type'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'hubDataset'
          value: {
            // Map Cost Management export types to FinOps Hub folder/table names:
            // FocusCost → Costs, PriceSheet → Prices, ReservationDetails → CommitmentDiscountUsage,
            // ReservationRecommendations → Recommendations, ReservationTransactions → Transactions
            value: '@if(equals(toLower(variables(\'exportDatasetType\')), \'focuscost\'), \'Costs\', if(equals(toLower(variables(\'exportDatasetType\')), \'pricesheet\'), \'Prices\', if(equals(toLower(variables(\'exportDatasetType\')), \'reservationdetails\'), \'CommitmentDiscountUsage\', if(equals(toLower(variables(\'exportDatasetType\')), \'reservationrecommendations\'), \'Recommendations\', if(equals(toLower(variables(\'exportDatasetType\')), \'reservationtransactions\'), \'Transactions\', if(equals(toLower(variables(\'exportDatasetType\')), \'actualcost\'), \'ActualCosts\', if(equals(toLower(variables(\'exportDatasetType\')), \'amortizedcost\'), \'AmortizedCosts\', toLower(variables(\'exportDatasetType\')))))))))'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Set Destination Folder'
        description: 'Build the destination folder path in ingestion container: {hubDataset}/{yyyy}/{mm}/{scope}'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Set Export Scope'
            dependencyConditions: ['Succeeded']
          }
          {
            activity: 'Set Hub Dataset'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'destinationFolder'
          value: {
            // FIX: Use hubDataset (e.g., "Costs") with yyyy/mm folder structure
            value: '@replace(concat(variables(\'hubDataset\'), \'/\', formatDateTime(utcNow(), \'yyyy\'), \'/\', formatDateTime(utcNow(), \'MM\'), \'/\', if(startsWith(variables(\'scope\'), \'/\'), substring(variables(\'scope\'), 1, sub(length(variables(\'scope\')), 1)), variables(\'scope\'))), \'//\', \'/\')'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Set Date'
        description: 'Extract the date from the manifest'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Read Manifest'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'date'
          value: {
            value: '@if(contains(activity(\'Read Manifest\').output.firstRow, \'runInfo\'), formatDateTime(activity(\'Read Manifest\').output.firstRow.runInfo.startDate, \'yyyyMMdd\'), formatDateTime(utcNow(), \'yyyyMMdd\'))'
            type: 'Expression'
          }
        }
      }
      {
        name: 'For Each Blob'
        description: 'Process each CSV/Parquet file in the export'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Set Destination Folder'
            dependencyConditions: ['Succeeded']
          }
          {
            activity: 'Set Date'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Read Manifest\').output.firstRow.blobs'
            type: 'Expression'
          }
          isSequential: false
          batchCount: 20
          activities: [
            {
              name: 'Convert to Ingestion'
              description: 'Convert and copy each file to ingestion container'
              type: 'ExecutePipeline'
              dependsOn: []
              policy: {
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: pipeline_msexports_ToIngestion.name
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {
                  blobPath: {
                    value: '@item().blobName'
                    type: 'Expression'
                  }
                  destinationFolder: {
                    value: '@variables(\'destinationFolder\')'
                    type: 'Expression'
                  }
                  destinationFile: {
                    value: '@last(array(split(replace(replace(item().blobName, \'.gz\', \'\'), \'.csv\', \'.parquet\'), \'/\')))'
                    type: 'Expression'
                  }
                  ingestionId: {
                    value: '@activity(\'Read Manifest\').output.firstRow.runInfo.runId'
                    type: 'Expression'
                  }
                }
              }
            }
          ]
        }
      }
      {
        name: 'Copy Manifest'
        description: 'Copy the manifest to ingestion container to trigger ADX ingestion'
        type: 'Copy'
        dependsOn: [
          {
            activity: 'For Each Blob'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'JsonSource'
            storeSettings: {
              type: 'AzureBlobFSReadSettings'
              recursive: true
              enablePartitionDiscovery: false
            }
            formatSettings: {
              type: 'JsonReadSettings'
            }
          }
          sink: {
            type: 'JsonSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
            }
            formatSettings: {
              type: 'JsonWriteSettings'
            }
          }
          enableStaging: false
        }
        inputs: [
          {
            referenceName: dataset_msexports_manifest.name
            type: 'DatasetReference'
            parameters: {
              fileName: 'manifest.json'
              folderPath: {
                value: '@pipeline().parameters.folderPath'
                type: 'Expression'
              }
            }
          }
        ]
        outputs: [
          {
            referenceName: dataset_ingestion_manifest.name
            type: 'DatasetReference'
            parameters: {
              fileName: 'manifest.json'
              folderPath: {
                // Don't prefix with INGESTION - the dataset already has fileSystem: ingestion
                value: '@variables(\'destinationFolder\')'
                type: 'Expression'
              }
            }
          }
        ]
      }
    ]
    parameters: {
      folderPath: { type: 'string' }
      fileName: { type: 'string' }
    }
    variables: {
      scope: { type: 'String' }
      exportDatasetType: { type: 'String' }
      hubDataset: { type: 'String' }
      destinationFolder: { type: 'String' }
      date: { type: 'String' }
    }
    annotations: ['FinOps Hub', 'Cost Management Exports', 'ETL']
  }
}

// msexports_ToIngestion pipeline - converts individual files
resource pipeline_msexports_ToIngestion 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${MSEXPORTS}_ToIngestion'
  parent: dataFactory
  properties: {
    activities: [
      {
        name: 'Get File Extension'
        description: 'Determine the file type to process'
        type: 'SetVariable'
        dependsOn: []
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'fileExtension'
          value: {
            value: '@if(endsWith(toLower(pipeline().parameters.blobPath), \'.gz\'), \'gz\', if(endsWith(toLower(pipeline().parameters.blobPath), \'.csv\'), \'csv\', if(endsWith(toLower(pipeline().parameters.blobPath), \'.parquet\'), \'parquet\', \'unknown\')))'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Set Destination Path'
        description: 'Build the destination file path with ingestion ID'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Get File Extension'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'destinationPath'
          value: {
            value: '@concat(pipeline().parameters.destinationFolder, \'/\', pipeline().parameters.ingestionId, \'${INGESTION_ID_SEPARATOR}\', pipeline().parameters.destinationFile)'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Switch On File Type'
        description: 'Handle different file formats'
        type: 'Switch'
        dependsOn: [
          {
            activity: 'Set Destination Path'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          on: {
            value: '@variables(\'fileExtension\')'
            type: 'Expression'
          }
          cases: [
            {
              value: 'csv'
              activities: [
                {
                  name: 'Convert CSV'
                  description: 'Convert CSV to Parquet'
                  type: 'Copy'
                  dependsOn: []
                  policy: {
                    timeout: '0.00:10:00'
                    retry: 0
                    retryIntervalInSeconds: 30
                    secureOutput: false
                    secureInput: false
                  }
                  userProperties: []
                  typeProperties: {
                    source: {
                      type: 'DelimitedTextSource'
                      storeSettings: {
                        type: 'AzureBlobFSReadSettings'
                        recursive: true
                        wildcardFileName: '*'
                        enablePartitionDiscovery: false
                      }
                      formatSettings: {
                        type: 'DelimitedTextReadSettings'
                      }
                    }
                    sink: {
                      type: 'ParquetSink'
                      storeSettings: {
                        type: 'AzureBlobFSWriteSettings'
                      }
                      formatSettings: {
                        type: 'ParquetWriteSettings'
                        fileExtension: '.parquet'
                      }
                    }
                    enableStaging: false
                    parallelCopies: 1
                    validateDataConsistency: false
                  }
                  inputs: [
                    {
                      referenceName: dataset_msexports.name
                      type: 'DatasetReference'
                      parameters: {
                        blobPath: {
                          value: '@pipeline().parameters.blobPath'
                          type: 'Expression'
                        }
                      }
                    }
                  ]
                  outputs: [
                    {
                      referenceName: dataset_ingestion.name
                      type: 'DatasetReference'
                      parameters: {
                        blobPath: {
                          value: '@variables(\'destinationPath\')'
                          type: 'Expression'
                        }
                      }
                    }
                  ]
                }
              ]
            }
            {
              value: 'gz'
              activities: [
                {
                  name: 'Convert GZip CSV'
                  description: 'Convert GZip CSV to Parquet'
                  type: 'Copy'
                  dependsOn: []
                  policy: {
                    timeout: '0.00:10:00'
                    retry: 0
                    retryIntervalInSeconds: 30
                    secureOutput: false
                    secureInput: false
                  }
                  userProperties: []
                  typeProperties: {
                    source: {
                      type: 'DelimitedTextSource'
                      storeSettings: {
                        type: 'AzureBlobFSReadSettings'
                        recursive: true
                        wildcardFileName: '*'
                        enablePartitionDiscovery: false
                      }
                      formatSettings: {
                        type: 'DelimitedTextReadSettings'
                      }
                    }
                    sink: {
                      type: 'ParquetSink'
                      storeSettings: {
                        type: 'AzureBlobFSWriteSettings'
                      }
                      formatSettings: {
                        type: 'ParquetWriteSettings'
                        fileExtension: '.parquet'
                      }
                    }
                    enableStaging: false
                    parallelCopies: 1
                    validateDataConsistency: false
                  }
                  inputs: [
                    {
                      referenceName: dataset_msexports_gzip.name
                      type: 'DatasetReference'
                      parameters: {
                        blobPath: {
                          value: '@pipeline().parameters.blobPath'
                          type: 'Expression'
                        }
                      }
                    }
                  ]
                  outputs: [
                    {
                      referenceName: dataset_ingestion.name
                      type: 'DatasetReference'
                      parameters: {
                        blobPath: {
                          value: '@variables(\'destinationPath\')'
                          type: 'Expression'
                        }
                      }
                    }
                  ]
                }
              ]
            }
            {
              value: 'parquet'
              activities: [
                {
                  name: 'Copy Parquet'
                  description: 'Copy Parquet file directly'
                  type: 'Copy'
                  dependsOn: []
                  policy: {
                    timeout: '0.00:05:00'
                    retry: 0
                    retryIntervalInSeconds: 30
                    secureOutput: false
                    secureInput: false
                  }
                  userProperties: []
                  typeProperties: {
                    source: {
                      type: 'ParquetSource'
                      storeSettings: {
                        type: 'AzureBlobFSReadSettings'
                        recursive: true
                        wildcardFileName: '*'
                        enablePartitionDiscovery: false
                      }
                      formatSettings: {
                        type: 'ParquetReadSettings'
                      }
                    }
                    sink: {
                      type: 'ParquetSink'
                      storeSettings: {
                        type: 'AzureBlobFSWriteSettings'
                      }
                      formatSettings: {
                        type: 'ParquetWriteSettings'
                        fileExtension: '.parquet'
                      }
                    }
                    enableStaging: false
                    parallelCopies: 1
                    validateDataConsistency: false
                  }
                  inputs: [
                    {
                      referenceName: dataset_msexports_parquet.name
                      type: 'DatasetReference'
                      parameters: {
                        blobPath: {
                          value: '@pipeline().parameters.blobPath'
                          type: 'Expression'
                        }
                      }
                    }
                  ]
                  outputs: [
                    {
                      referenceName: dataset_ingestion.name
                      type: 'DatasetReference'
                      parameters: {
                        blobPath: {
                          value: '@variables(\'destinationPath\')'
                          type: 'Expression'
                        }
                      }
                    }
                  ]
                }
              ]
            }
          ]
          defaultActivities: []
        }
      }
    ]
    parameters: {
      blobPath: { type: 'string' }
      destinationFolder: { type: 'string' }
      destinationFile: { type: 'string' }
      ingestionId: { type: 'string' }
    }
    variables: {
      fileExtension: { type: 'String' }
      destinationPath: { type: 'String' }
    }
    annotations: ['FinOps Hub', 'ETL', 'File Conversion']
  }
}

// ingestion_ExecuteETL pipeline (only for ADX/Fabric)
resource pipeline_ingestion_ExecuteETL 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = if (useAnalytics) {
  name: '${INGESTION}_ExecuteETL'
  parent: dataFactory
  properties: {
    concurrency: 1
    activities: [
      {
        name: 'Wait'
        description: 'Wait for files to be fully available'
        type: 'Wait'
        dependsOn: []
        userProperties: []
        typeProperties: {
          waitTimeInSeconds: 60
        }
      }
      {
        name: 'Set Container Folder Path'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Wait'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'containerFolderPath'
          value: {
            // Remove container name prefix from folderPath
            // Input:  ingestion/Costs/2026/01/subscriptions/.../export
            // Output: Costs/2026/01/subscriptions/.../export
            value: '@join(skip(array(split(pipeline().parameters.folderPath, \'/\')), 1), \'/\')'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Get Parquet Files'
        description: 'List all parquet files to ingest'
        type: 'GetMetadata'
        dependsOn: [
          {
            activity: 'Set Container Folder Path'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: dataset_ingestion_files.name
            type: 'DatasetReference'
            parameters: {
              folderPath: '@variables(\'containerFolderPath\')'
            }
          }
          fieldList: ['childItems']
          storeSettings: {
            type: 'AzureBlobFSReadSettings'
            enablePartitionDiscovery: false
          }
          formatSettings: {
            type: 'ParquetReadSettings'
          }
        }
      }
      {
        name: 'Filter Parquet Files'
        description: 'Filter to only parquet files'
        type: 'Filter'
        dependsOn: [
          {
            activity: 'Get Parquet Files'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get Parquet Files\').output.childItems'
            type: 'Expression'
          }
          condition: {
            value: '@and(equals(item().type, \'File\'), endsWith(item().name, \'.parquet\'))'
            type: 'Expression'
          }
        }
      }
      {
        name: 'For Each Parquet File'
        description: 'Ingest each parquet file to Data Explorer'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Filter Parquet Files'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Filter Parquet Files\').output.Value'
            type: 'Expression'
          }
          isSequential: false
          batchCount: 10
          activities: [
            {
              name: 'Execute ADX ETL'
              description: 'Run the ADX ingestion pipeline'
              type: 'ExecutePipeline'
              dependsOn: []
              policy: {
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: 'ingestion_ETL_dataExplorer'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {
                  folderPath: {
                    value: '@variables(\'containerFolderPath\')'
                    type: 'Expression'
                  }
                  fileName: {
                    value: '@item().name'
                    type: 'Expression'
                  }
                  table: {
                    // Get dataset name from first path segment (e.g., 'Costs') + '_raw' suffix
                    // containerFolderPath = 'Costs/2026/01/subscriptions/...' -> first element = 'Costs'
                    value: '@concat(first(split(variables(\'containerFolderPath\'), \'/\')), \'_raw\')'
                    type: 'Expression'
                  }
                }
              }
            }
          ]
        }
      }
    ]
    parameters: {
      folderPath: { type: 'string' }
    }
    variables: {
      containerFolderPath: { type: 'String' }
    }
    annotations: ['FinOps Hub', 'Data Explorer', 'Ingestion']
  }
}

// ingestion_ETL_dataExplorer pipeline (only for ADX/Fabric)
resource pipeline_ingestion_ETL_dataExplorer 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = if (useAnalytics) {
  name: '${INGESTION}_ETL_dataExplorer'
  parent: dataFactory
  properties: {
    activities: [
      // Step 1: Set managed identity policy (required before ingestion can use managed_identity=system)
      // This must run before the ingest command to ensure the ADX cluster's MI has NativeIngestion permission
      // Reference: FinOps Toolkit app.bicep - "Set ingestion policy in ADX" activity
      {
        name: 'Set Ingestion Policy'
        description: 'Configure ADX managed identity policy to allow NativeIngestion using the cluster system identity'
        type: 'AzureDataExplorerCommand'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        typeProperties: {
          // Set policy for the cluster system MI - this is what allows managed_identity=system to work
          // Must use the actual principal ID, not "system" string
          command: useDataExplorer
            ? '.alter-merge database Ingestion policy managed_identity ```[{ "ObjectId" : "${dataExplorerPrincipalId}", "AllowedUsages" : "NativeIngestion" }]```'
            : '.show database Ingestion policy managed_identity'  // Fabric doesn't need this, just do a no-op query
          commandTimeout: '00:20:00'
        }
        linkedServiceName: {
          referenceName: linkedService_dataExplorer.name
          type: 'LinkedServiceReference'
          parameters: {
            database: 'Ingestion'
          }
        }
      }
      // Step 2: Ingest the parquet file
      {
        name: 'Ingest to Data Explorer'
        description: 'Ingest parquet file into Data Explorer'
        type: 'AzureDataExplorerCommand'
        dependsOn: [
          {
            activity: 'Set Ingestion Policy'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        policy: {
          timeout: '0.12:00:00'
          retry: 2
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        typeProperties: {
          command: {
            // ADX uses managed_identity=system, Fabric uses impersonate
            // Uses ingestionMappingReference to map parquet columns to table schema (required)
            // Uses drop-by tags for deduplication (same pattern as FinOps Toolkit)
            value: '@concat(\'.ingest into table \', pipeline().parameters.table, \' ("abfss://${INGESTION}@${storageAccountName}.dfs.${environment().suffixes.storage}/\', pipeline().parameters.folderPath, \'/\', pipeline().parameters.fileName, \';${ingestionAuthMethod}") with (format="parquet", ingestionMappingReference="\', pipeline().parameters.table, \'_mapping", tags="[\\"drop-by:\', pipeline().parameters.folderPath, \'/\', pipeline().parameters.fileName, \'\\"]")\')'
            type: 'Expression'
          }
          commandTimeout: '01:00:00'
        }
        linkedServiceName: {
          referenceName: linkedService_dataExplorer.name
          type: 'LinkedServiceReference'
          parameters: {
            database: 'Ingestion'
          }
        }
      }
    ]
    parameters: {
      folderPath: { type: 'string' }
      fileName: { type: 'string' }
      table: { type: 'string' }
    }
    annotations: ['FinOps Hub', 'Data Explorer', 'KQL Ingestion']
  }
}

// ============================================================================
// MACC PIPELINES (Microsoft Azure Consumption Commitment)
// ============================================================================

// macc_FetchLots pipeline - Fetches MACC lot data from Azure Consumption API
resource pipeline_macc_FetchLots 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = if (useMacc) {
  name: 'macc_FetchLots'
  parent: dataFactory
  properties: {
    description: 'Fetches Microsoft Azure Consumption Commitment (MACC) lots from the Azure Consumption API and ingests into ADX.'
    activities: [
      {
        name: 'Fetch MACC Lots'
        description: 'Call Azure Consumption Lots API to get MACC data'
        type: 'WebActivity'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 2
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          url: 'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/@{pipeline().parameters.billingAccountId}/providers/Microsoft.Consumption/lots?api-version=2021-05-01&$filter=source%20eq%20%27ConsumptionCommitment%27'
          method: 'GET'
          authentication: {
            type: 'MSI'
            resource: 'https://management.azure.com/'
          }
        }
      }
      {
        name: 'For Each Lot'
        description: 'Process each MACC lot'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Fetch MACC Lots'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Fetch MACC Lots\').output.value'
            type: 'Expression'
          }
          isSequential: false
          batchCount: 10
          activities: [
            {
              name: 'Ingest Lot to ADX'
              description: 'Ingest MACC lot data into ADX'
              type: 'AzureDataExplorerCommand'
              dependsOn: []
              policy: {
                timeout: '0.12:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              typeProperties: {
                command: {
                  // Use .set-or-append with parse_json to ingest the lot data
                  // This avoids escape sequence issues with inline ingestion
                  value: '@concat(\'.set-or-append MACC_Lots_raw <| print LotId="\', item().name, \'", BillingAccountId="\', pipeline().parameters.billingAccountId, \'", BillingAccountName="", Status="\', item().properties.status, \'", PurchasedDate=todatetime("\', item().properties.purchasedDate, \'"), StartDate=todatetime("\', item().properties.startDate, \'"), ExpirationDate=todatetime("\', item().properties.expirationDate, \'"), OriginalAmount=\', item().properties.originalAmount.value, \', OriginalCurrency="\', item().properties.originalAmount.currency, \'", ClosedBalance=\', item().properties.closedBalance.value, \', ClosedBalanceCurrency="\', item().properties.closedBalance.currency, \'", ETag="", x_SourceName="Cost Management", x_SourceProvider="Microsoft", x_SourceType="ConsumptionLots", x_SourceVersion="2021-05-01"\')'
                  type: 'Expression'
                }
                commandTimeout: '00:20:00'
              }
              linkedServiceName: {
                referenceName: linkedService_dataExplorer.name
                type: 'LinkedServiceReference'
                parameters: {
                  database: 'Ingestion'
                }
              }
            }
          ]
        }
      }
    ]
    parameters: {
      billingAccountId: { 
        type: 'string'
        defaultValue: billingAccountId
      }
    }
    annotations: union(hubAnnotations, ['MACC', 'Consumption Commitment'])
  }
}

// macc_FetchEvents pipeline - Fetches MACC event data from Azure Consumption API
resource pipeline_macc_FetchEvents 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = if (useMacc) {
  name: 'macc_FetchEvents'
  parent: dataFactory
  properties: {
    description: 'Fetches Microsoft Azure Consumption Commitment (MACC) events from the Azure Consumption API and ingests into ADX.'
    activities: [
      {
        name: 'Fetch MACC Events'
        description: 'Call Azure Consumption Events API to get MACC decrement events'
        type: 'WebActivity'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 2
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          // Default to last 2 years of events
          url: '@concat(\'https://management.azure.com/providers/Microsoft.Billing/billingAccounts/\', pipeline().parameters.billingAccountId, \'/providers/Microsoft.Consumption/events?api-version=2021-05-01&startDate=\', pipeline().parameters.startDate, \'&endDate=\', pipeline().parameters.endDate, \'&$filter=lotsource%20eq%20%27ConsumptionCommitment%27\')'
          method: 'GET'
          authentication: {
            type: 'MSI'
            resource: 'https://management.azure.com/'
          }
        }
      }
      {
        name: 'For Each Event'
        description: 'Process each MACC event'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Fetch MACC Events'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Fetch MACC Events\').output.value'
            type: 'Expression'
          }
          isSequential: false
          batchCount: 10
          activities: [
            {
              name: 'Ingest Event to ADX'
              description: 'Ingest MACC event data into ADX'
              type: 'AzureDataExplorerCommand'
              dependsOn: []
              policy: {
                timeout: '0.12:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              typeProperties: {
                command: {
                  // Use .set-or-append with print to ingest the event data
                  // This avoids escape sequence issues with inline ingestion
                  value: '@concat(\'.set-or-append MACC_Events_raw <| print EventId="\', item().name, \'", BillingAccountId="\', pipeline().parameters.billingAccountId, \'", BillingProfileId="\', coalesce(item().properties.billingProfileId, \'\'), \'", BillingProfileDisplayName="\', coalesce(item().properties.billingProfileDisplayName, \'\'), \'", LotId="\', item().properties.lotId, \'", LotSource="\', item().properties.lotSource, \'", TransactionDate=todatetime("\', item().properties.transactionDate, \'"), Description="\', replace(item().properties.description, \'"\', \'\'), \'", EventType="\', item().properties.eventType, \'", InvoiceNumber="\', coalesce(item().properties.invoiceNumber, \'\'), \'", Charges=\', item().properties.charges.value, \', ChargesCurrency="\', item().properties.charges.currency, \'", ClosedBalance=\', item().properties.closedBalance.value, \', ClosedBalanceCurrency="\', item().properties.closedBalance.currency, \'", ETag="", x_SourceName="Cost Management", x_SourceProvider="Microsoft", x_SourceType="ConsumptionEvents", x_SourceVersion="2021-05-01"\')'
                  type: 'Expression'
                }
                commandTimeout: '00:20:00'
              }
              linkedServiceName: {
                referenceName: linkedService_dataExplorer.name
                type: 'LinkedServiceReference'
                parameters: {
                  database: 'Ingestion'
                }
              }
            }
          ]
        }
      }
    ]
    parameters: {
      billingAccountId: { 
        type: 'string'
        defaultValue: billingAccountId
      }
      startDate: {
        type: 'string'
        // Default to 2 years ago
        defaultValue: '@formatDateTime(addDays(utcNow(), -730), \'yyyy-MM-dd\')'
      }
      endDate: {
        type: 'string'
        // Default to today
        defaultValue: '@formatDateTime(utcNow(), \'yyyy-MM-dd\')'
      }
    }
    annotations: union(hubAnnotations, ['MACC', 'Consumption Commitment'])
  }
}

// macc_SyncAll pipeline - Master pipeline to sync all MACC data
resource pipeline_macc_SyncAll 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = if (useMacc) {
  name: 'macc_SyncAll'
  parent: dataFactory
  properties: {
    description: 'Syncs all MACC (Microsoft Azure Consumption Commitment) data - lots and events.'
    activities: [
      {
        name: 'Sync MACC Lots'
        description: 'Fetch and ingest MACC lot data'
        type: 'ExecutePipeline'
        dependsOn: []
        policy: {
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: pipeline_macc_FetchLots.name
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {
            billingAccountId: {
              value: '@pipeline().parameters.billingAccountId'
              type: 'Expression'
            }
          }
        }
      }
      {
        name: 'Sync MACC Events'
        description: 'Fetch and ingest MACC event data'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'Sync MACC Lots'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: pipeline_macc_FetchEvents.name
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {
            billingAccountId: {
              value: '@pipeline().parameters.billingAccountId'
              type: 'Expression'
            }
            startDate: {
              value: '@pipeline().parameters.startDate'
              type: 'Expression'
            }
            endDate: {
              value: '@pipeline().parameters.endDate'
              type: 'Expression'
            }
          }
        }
      }
    ]
    parameters: {
      billingAccountId: { 
        type: 'string'
        defaultValue: billingAccountId
      }
      startDate: {
        type: 'string'
        // Default to 2 years ago
        defaultValue: '@formatDateTime(addDays(utcNow(), -730), \'yyyy-MM-dd\')'
      }
      endDate: {
        type: 'string'
        // Default to today
        defaultValue: '@formatDateTime(utcNow(), \'yyyy-MM-dd\')'
      }
    }
    annotations: union(hubAnnotations, ['MACC', 'Consumption Commitment', 'Master Sync'])
  }
}

// ============================================================================
// TRIGGERS
// ============================================================================

// msexports_ManifestAdded trigger
resource trigger_msexports_ManifestAdded 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  name: '${MSEXPORTS}_ManifestAdded'
  parent: dataFactory
  properties: {
    annotations: []
    pipelines: [
      {
        pipelineReference: {
          referenceName: pipeline_msexports_ExecuteETL.name
          type: 'PipelineReference'
        }
        parameters: {
          folderPath: '@triggerBody().folderPath'
          fileName: '@triggerBody().fileName'
        }
      }
    ]
    type: 'BlobEventsTrigger'
    typeProperties: {
      blobPathBeginsWith: '/${MSEXPORTS}/blobs/'
      blobPathEndsWith: 'manifest.json'
      ignoreEmptyBlobs: true
      scope: storageAccount.id
      events: [
        'Microsoft.Storage.BlobCreated'
      ]
    }
  }
}

// ingestion_ManifestAdded trigger (only for ADX/Fabric)
resource trigger_ingestion_ManifestAdded 'Microsoft.DataFactory/factories/triggers@2018-06-01' = if (useAnalytics) {
  name: '${INGESTION}_ManifestAdded'
  parent: dataFactory
  // Note: Implicit dependency via pipeline_ingestion_ExecuteETL.name reference
  properties: {
    annotations: []
    pipelines: [
      {
        pipelineReference: {
          referenceName: pipeline_ingestion_ExecuteETL.name
          type: 'PipelineReference'
        }
        parameters: {
          folderPath: '@triggerBody().folderPath'
        }
      }
    ]
    type: 'BlobEventsTrigger'
    typeProperties: {
      blobPathBeginsWith: '/${INGESTION}/'
      blobPathEndsWith: 'manifest.json'
      ignoreEmptyBlobs: true
      scope: storageAccount.id
      events: [
        'Microsoft.Storage.BlobCreated'
      ]
    }
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('List of pipelines created.')
output pipelineNames array = useMacc ? [
  pipeline_msexports_ExecuteETL.name
  pipeline_msexports_ETL_ingestion.name
  pipeline_msexports_ToIngestion.name
  pipeline_ingestion_ExecuteETL.name
  pipeline_ingestion_ETL_dataExplorer.name
  pipeline_macc_FetchLots.name
  pipeline_macc_FetchEvents.name
  pipeline_macc_SyncAll.name
] : useAnalytics ? [
  pipeline_msexports_ExecuteETL.name
  pipeline_msexports_ETL_ingestion.name
  pipeline_msexports_ToIngestion.name
  pipeline_ingestion_ExecuteETL.name
  pipeline_ingestion_ETL_dataExplorer.name
] : [
  pipeline_msexports_ExecuteETL.name
  pipeline_msexports_ETL_ingestion.name
  pipeline_msexports_ToIngestion.name
]

@description('List of triggers created.')
output triggerNames array = useAnalytics ? [
  trigger_msexports_ManifestAdded.name
  trigger_ingestion_ManifestAdded.name
] : [
  trigger_msexports_ManifestAdded.name
]

@description('Analytics platform being used (adx, fabric, or none).')
output analyticsPlatform string = useDataExplorer ? 'adx' : (useFabric ? 'fabric' : 'none')

@description('Whether MACC pipelines are enabled.')
output maccEnabled bool = useMacc
