// ============================================================================
// FinOps Hub - Managed Exports Pipelines
// ============================================================================
// Creates ADF pipelines for automated Cost Management export management.
// These pipelines read scopes from settings.json and configure exports automatically.
//
// ONLY deployed when billingAccountType supports exports (EA/MCA/MPA).
// PAYGO/CSP tenants should use the test data scripts instead.
//
// Reference: https://github.com/microsoft/finops-toolkit/tree/main/src/templates/finops-hub/modules/Microsoft.CostManagement/ManagedExports
// ============================================================================

targetScope = 'resourceGroup'

// ============================================================================
// PARAMETERS
// ============================================================================

@description('Required. Name of the Data Factory.')
param dataFactoryName string

@description('Required. Name of the storage account.')
param storageAccountName string

@description('Optional. Name of the integration runtime to use.')
#disable-next-line no-unused-params // Reserved for future managed VNet support
param integrationRuntimeName string = ''

@description('Optional. FinOps toolkit version.')
param ftkVersion string = '0.7.0'

@description('Required. Hub name for export naming.')
param hubName string

// ============================================================================
// VARIABLES
// ============================================================================

var CONFIG = 'config'
#disable-next-line no-unused-vars // Used in export path generation
var MSEXPORTS = 'msexports'

// Cost Management API version
var exportsApiVersion = '2023-07-01-preview'

// Hub annotations for tracking
var hubAnnotations = ['FinOps Hub', 'ftk-version-${ftkVersion}', 'ManagedExports']

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
// DATASETS
// ============================================================================

// Config dataset for reading settings.json
resource dataset_config 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${CONFIG}_json'
  parent: dataFactory
  properties: {
    type: 'Json'
    linkedServiceName: {
      referenceName: storageAccountName
      type: 'LinkedServiceReference'
    }
    parameters: {
      fileName: {
        type: 'String'
        defaultValue: 'settings.json'
      }
      folderPath: {
        type: 'String'
        defaultValue: CONFIG
      }
    }
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().fileName'
          type: 'Expression'
        }
        folderPath: {
          value: '@dataset().folderPath'
          type: 'Expression'
        }
        fileSystem: CONFIG
      }
    }
    annotations: hubAnnotations
  }
}

// ============================================================================
// PIPELINES - Managed Exports
// ============================================================================

//----------------------------------------------------------------------------
// config_ConfigureExports pipeline
// Triggered by config_SettingsUpdated trigger when settings.json is modified
// Creates Cost Management exports for each scope in the settings file
//----------------------------------------------------------------------------
resource pipeline_ConfigureExports 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${CONFIG}_ConfigureExports'
  parent: dataFactory
  properties: {
    description: 'Reads scopes from settings.json and creates/updates Cost Management exports for each scope. Only works with EA/MCA/MPA billing accounts.'
    activities: [
      {
        // Step 1: Read settings.json to get scopes
        name: 'Get Config'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '0.00:05:00'
          retry: 2
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
          dataset: {
            referenceName: dataset_config.name
            type: 'DatasetReference'
            parameters: {
              fileName: 'settings.json'
              folderPath: CONFIG
            }
          }
        }
      }
      {
        // Step 2: Check if deployment mode supports exports
        name: 'Check Export Support'
        type: 'IfCondition'
        dependsOn: [
          {
            activity: 'Get Config'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          expression: {
            value: '@and(not(empty(activity(\'Get Config\').output.firstRow.deployment.billingType)), or(or(equals(activity(\'Get Config\').output.firstRow.deployment.billingType, \'ea\'), equals(activity(\'Get Config\').output.firstRow.deployment.billingType, \'mca\')), equals(activity(\'Get Config\').output.firstRow.deployment.billingType, \'mpa\')))'
            type: 'Expression'
          }
          ifTrueActivities: [
            {
              // Step 3: Set scopes array
              name: 'Set Scopes'
              type: 'SetVariable'
              dependsOn: []
              policy: {
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                variableName: 'scopesArray'
                value: {
                  value: '@if(equals(string(activity(\'Get Config\').output.firstRow.scopes), \'[]\'), json(\'[]\'), activity(\'Get Config\').output.firstRow.scopes)'
                  type: 'Expression'
                }
              }
            }
            {
              // Step 4: Iterate through each scope
              name: 'ForEach Scope'
              type: 'ForEach'
              dependsOn: [
                {
                  activity: 'Set Scopes'
                  dependencyConditions: ['Succeeded']
                }
              ]
              userProperties: []
              typeProperties: {
                items: {
                  value: '@variables(\'scopesArray\')'
                  type: 'Expression'
                }
                isSequential: true
                activities: [
                  {
                    // Step 5: Create daily FOCUS cost export
                    name: 'Create Daily Cost Export'
                    type: 'WebActivity'
                    dependsOn: []
                    policy: {
                      timeout: '0.00:05:00'
                      retry: 2
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      url: {
                        value: '@concat(environment().resourceManager, item().scope, \'/providers/Microsoft.CostManagement/exports/${hubName}-daily-focuscost?api-version=${exportsApiVersion}\')'
                        type: 'Expression'
                      }
                      method: 'PUT'
                      body: {
                        value: '@json(concat(\'{"properties":{"schedule":{"status":"Active","recurrence":"Daily","recurrencePeriod":{"from":"\', formatDateTime(utcNow(), \'yyyy-MM-dd\'), \'T00:00:00Z","to":"2099-12-31T23:59:59Z"}},"format":"Parquet","deliveryInfo":{"destination":{"resourceId":"${storageAccount.id}","container":"${MSEXPORTS}","rootFolderPath":"\', replace(item().scope, \'/providers/Microsoft.Billing/\', \'\'), \'"}},"definition":{"type":"FocusCost","timeframe":"MonthToDate","dataSet":{"granularity":"Daily"}},"partitionData":true}}\'))'
                        type: 'Expression'
                      }
                      headers: {
                        'x-ms-command-name': 'FinOpsToolkit.Hubs.config_ConfigureExports.DailyCost@${ftkVersion}'
                        ClientType: 'FinOpsToolkit.Hubs@${ftkVersion}'
                      }
                      authentication: {
                        type: 'MSI'
                        resource: {
                          value: '@environment().resourceManager'
                          type: 'Expression'
                        }
                      }
                    }
                  }
                  {
                    // Step 6: Create monthly FOCUS cost export (previous month)
                    name: 'Create Monthly Cost Export'
                    type: 'WebActivity'
                    dependsOn: [
                      {
                        activity: 'Create Daily Cost Export'
                        dependencyConditions: ['Succeeded']
                      }
                    ]
                    policy: {
                      timeout: '0.00:05:00'
                      retry: 2
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      url: {
                        value: '@concat(environment().resourceManager, item().scope, \'/providers/Microsoft.CostManagement/exports/${hubName}-monthly-focuscost?api-version=${exportsApiVersion}\')'
                        type: 'Expression'
                      }
                      method: 'PUT'
                      body: {
                        value: '@json(concat(\'{"properties":{"schedule":{"status":"Active","recurrence":"Monthly","recurrencePeriod":{"from":"\', formatDateTime(utcNow(), \'yyyy-MM-dd\'), \'T00:00:00Z","to":"2099-12-31T23:59:59Z"}},"format":"Parquet","deliveryInfo":{"destination":{"resourceId":"${storageAccount.id}","container":"${MSEXPORTS}","rootFolderPath":"\', replace(item().scope, \'/providers/Microsoft.Billing/\', \'\'), \'"}},"definition":{"type":"FocusCost","timeframe":"TheLastMonth","dataSet":{"granularity":"Daily"}},"partitionData":true}}\'))'
                        type: 'Expression'
                      }
                      headers: {
                        'x-ms-command-name': 'FinOpsToolkit.Hubs.config_ConfigureExports.MonthlyCost@${ftkVersion}'
                        ClientType: 'FinOpsToolkit.Hubs@${ftkVersion}'
                      }
                      authentication: {
                        type: 'MSI'
                        resource: {
                          value: '@environment().resourceManager'
                          type: 'Expression'
                        }
                      }
                    }
                  }
                  {
                    // Step 7: Trigger daily export to get initial data
                    name: 'Run Daily Export'
                    type: 'WebActivity'
                    dependsOn: [
                      {
                        activity: 'Create Monthly Cost Export'
                        dependencyConditions: ['Succeeded']
                      }
                    ]
                    policy: {
                      timeout: '0.00:05:00'
                      retry: 2
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      url: {
                        value: '@concat(environment().resourceManager, item().scope, \'/providers/Microsoft.CostManagement/exports/${hubName}-daily-focuscost/run?api-version=${exportsApiVersion}\')'
                        type: 'Expression'
                      }
                      method: 'POST'
                      body: ' '
                      headers: {
                        'x-ms-command-name': 'FinOpsToolkit.Hubs.config_ConfigureExports.RunExport@${ftkVersion}'
                        ClientType: 'FinOpsToolkit.Hubs@${ftkVersion}'
                      }
                      authentication: {
                        type: 'MSI'
                        resource: {
                          value: '@environment().resourceManager'
                          type: 'Expression'
                        }
                      }
                    }
                  }
                ]
              }
            }
          ]
          ifFalseActivities: [
            {
              // Log that exports are not supported for this billing type
              name: 'Log Skipped'
              type: 'SetVariable'
              dependsOn: []
              policy: {
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                variableName: 'skippedReason'
                value: {
                  value: '@concat(\'Export configuration skipped: Billing type \', coalesce(activity(\'Get Config\').output.firstRow.deployment.billingType, \'unknown\'), \' does not support managed exports. Use Demo mode with test data scripts.\')'
                  type: 'Expression'
                }
              }
            }
          ]
        }
      }
    ]
    concurrency: 1
    variables: {
      scopesArray: {
        type: 'Array'
      }
      skippedReason: {
        type: 'String'
      }
    }
    annotations: hubAnnotations
  }
}

//----------------------------------------------------------------------------
// config_RunExportJobs pipeline
// Manually trigger to run all configured exports
//----------------------------------------------------------------------------
resource pipeline_RunExportJobs 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${CONFIG}_RunExportJobs'
  parent: dataFactory
  properties: {
    description: 'Runs all Cost Management exports configured for this hub. Reads scopes from settings.json.'
    activities: [
      {
        name: 'Get Config'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '0.00:05:00'
          retry: 2
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
          dataset: {
            referenceName: dataset_config.name
            type: 'DatasetReference'
            parameters: {
              fileName: 'settings.json'
              folderPath: CONFIG
            }
          }
        }
      }
      {
        name: 'Set Scopes'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Get Config'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'scopesArray'
          value: {
            value: '@if(equals(string(activity(\'Get Config\').output.firstRow.scopes), \'[]\'), json(\'[]\'), activity(\'Get Config\').output.firstRow.scopes)'
            type: 'Expression'
          }
        }
      }
      {
        name: 'ForEach Scope'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Set Scopes'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@variables(\'scopesArray\')'
            type: 'Expression'
          }
          isSequential: false
          activities: [
            {
              name: 'Run Daily Export'
              type: 'WebActivity'
              dependsOn: []
              policy: {
                timeout: '0.00:05:00'
                retry: 2
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                url: {
                  value: '@concat(environment().resourceManager, item().scope, \'/providers/Microsoft.CostManagement/exports/${hubName}-daily-focuscost/run?api-version=${exportsApiVersion}\')'
                  type: 'Expression'
                }
                method: 'POST'
                body: ' '
                headers: {
                  'x-ms-command-name': 'FinOpsToolkit.Hubs.config_RunExportJobs@${ftkVersion}'
                  ClientType: 'FinOpsToolkit.Hubs@${ftkVersion}'
                }
                authentication: {
                  type: 'MSI'
                  resource: {
                    value: '@environment().resourceManager'
                    type: 'Expression'
                  }
                }
              }
            }
          ]
        }
      }
    ]
    concurrency: 1
    variables: {
      scopesArray: {
        type: 'Array'
      }
    }
    annotations: hubAnnotations
  }
}

//----------------------------------------------------------------------------
// config_RunBackfillJob pipeline
// Manually trigger to backfill historical data
//----------------------------------------------------------------------------
resource pipeline_RunBackfillJob 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${CONFIG}_RunBackfillJob'
  parent: dataFactory
  properties: {
    description: 'Runs exports for a specific date range to backfill historical data. Specify start and end dates as parameters.'
    parameters: {
      StartDate: {
        type: 'String'
        defaultValue: ''
      }
      EndDate: {
        type: 'String'
        defaultValue: ''
      }
      MonthsToBackfill: {
        type: 'Int'
        defaultValue: 3
      }
    }
    activities: [
      {
        name: 'Get Config'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '0.00:05:00'
          retry: 2
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
          dataset: {
            referenceName: dataset_config.name
            type: 'DatasetReference'
            parameters: {
              fileName: 'settings.json'
              folderPath: CONFIG
            }
          }
        }
      }
      {
        name: 'Calculate Backfill Range'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Get Config'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'startDate'
          value: {
            value: '@if(empty(pipeline().parameters.StartDate), formatDateTime(addToTime(utcNow(), -pipeline().parameters.MonthsToBackfill, \'Month\'), \'yyyy-MM-01\'), pipeline().parameters.StartDate)'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Set End Date'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Calculate Backfill Range'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'endDate'
          value: {
            value: '@if(empty(pipeline().parameters.EndDate), formatDateTime(utcNow(), \'yyyy-MM-dd\'), pipeline().parameters.EndDate)'
            type: 'Expression'
          }
        }
      }
      {
        name: 'Set Scopes'
        type: 'SetVariable'
        dependsOn: [
          {
            activity: 'Set End Date'
            dependencyConditions: ['Succeeded']
          }
        ]
        policy: {
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          variableName: 'scopesArray'
          value: {
            value: '@if(equals(string(activity(\'Get Config\').output.firstRow.scopes), \'[]\'), json(\'[]\'), activity(\'Get Config\').output.firstRow.scopes)'
            type: 'Expression'
          }
        }
      }
      {
        name: 'ForEach Scope'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Set Scopes'
            dependencyConditions: ['Succeeded']
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@variables(\'scopesArray\')'
            type: 'Expression'
          }
          isSequential: true
          activities: [
            {
              name: 'Run Backfill Export'
              type: 'WebActivity'
              dependsOn: []
              policy: {
                timeout: '0.00:10:00'
                retry: 2
                retryIntervalInSeconds: 60
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                url: {
                  value: '@concat(environment().resourceManager, item().scope, \'/providers/Microsoft.CostManagement/exports/${hubName}-daily-focuscost/run?api-version=${exportsApiVersion}\')'
                  type: 'Expression'
                }
                method: 'POST'
                body: {
                  value: '@json(concat(\'{"timePeriod":{"from":"\', variables(\'startDate\'), \'T00:00:00Z","to":"\', variables(\'endDate\'), \'T23:59:59Z"}}\'))'
                  type: 'Expression'
                }
                headers: {
                  'x-ms-command-name': 'FinOpsToolkit.Hubs.config_RunBackfillJob@${ftkVersion}'
                  ClientType: 'FinOpsToolkit.Hubs@${ftkVersion}'
                  'Content-Type': 'application/json'
                }
                authentication: {
                  type: 'MSI'
                  resource: {
                    value: '@environment().resourceManager'
                    type: 'Expression'
                  }
                }
              }
            }
          ]
        }
      }
    ]
    concurrency: 1
    variables: {
      scopesArray: {
        type: 'Array'
      }
      startDate: {
        type: 'String'
      }
      endDate: {
        type: 'String'
      }
    }
    annotations: hubAnnotations
  }
}

// ============================================================================
// TRIGGERS
// ============================================================================

//----------------------------------------------------------------------------
// config_SettingsUpdated trigger
// Fires when settings.json is created or modified
//----------------------------------------------------------------------------
resource trigger_SettingsUpdated 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  name: '${CONFIG}_SettingsUpdated'
  parent: dataFactory
  properties: {
    type: 'BlobEventsTrigger'
    typeProperties: {
      blobPathBeginsWith: '/${CONFIG}/blobs/'
      blobPathEndsWith: 'settings.json'
      ignoreEmptyBlobs: true
      scope: storageAccount.id
      events: [
        'Microsoft.Storage.BlobCreated'
        'Microsoft.Storage.BlobRenamed'
      ]
    }
    pipelines: [
      {
        pipelineReference: {
          referenceName: pipeline_ConfigureExports.name
          type: 'PipelineReference'
        }
        parameters: {}
      }
    ]
    annotations: hubAnnotations
  }
}

//----------------------------------------------------------------------------
// config_DailySchedule trigger
// Runs exports daily to capture new costs
//----------------------------------------------------------------------------
resource trigger_DailySchedule 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  name: '${CONFIG}_DailySchedule'
  parent: dataFactory
  properties: {
    type: 'ScheduleTrigger'
    typeProperties: {
      recurrence: {
        frequency: 'Day'
        interval: 1
        startTime: '2024-01-01T06:00:00Z'
        timeZone: 'UTC'
      }
    }
    pipelines: [
      {
        pipelineReference: {
          referenceName: pipeline_RunExportJobs.name
          type: 'PipelineReference'
        }
        parameters: {}
      }
    ]
    annotations: hubAnnotations
  }
}

// ============================================================================
// OUTPUTS
// ============================================================================

@description('List of managed exports pipeline names.')
output pipelineNames array = [
  pipeline_ConfigureExports.name
  pipeline_RunExportJobs.name
  pipeline_RunBackfillJob.name
]

@description('List of managed exports trigger names.')
output triggerNames array = [
  trigger_SettingsUpdated.name
  trigger_DailySchedule.name
]
