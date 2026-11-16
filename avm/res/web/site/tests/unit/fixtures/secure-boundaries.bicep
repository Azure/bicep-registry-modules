metadata description = 'Compile-only coverage for site and slot configuration boundaries. This fixture is not deployed.'

@secure()
param storageAccessKey string

@secure()
param configProperties object

@secure()
param retainedAppSettings object

param ordinarySetting string

// Exercise every credential contract, not just the leaves that were already marked secure.
var secretConfigs = [
  {
    name: 'azurestorageaccounts'
    properties: {
      // A storage mount may use a name that is also a web config property.
      alwaysOn: {
        accessKey: storageAccessKey
        accountName: 'boundarystorage'
        shareName: 'content'
        type: 'AzureFiles'
      }
    }
  }
  {
    name: 'web'
    properties: {
      alwaysOn: true
      appSettings: [
        {
          name: 'SECRET_SETTING'
          value: storageAccessKey
        }
      ]
      connectionStrings: [
        {
          name: 'database'
          connectionString: storageAccessKey
        }
      ]
      azureStorageAccounts: {
        content: {
          accessKey: storageAccessKey
        }
      }
      metadata: [
        {
          name: 'credential'
          value: storageAccessKey
        }
      ]
    }
  }
  {
    name: 'appsettings'
    retainCurrentAppSettings: true
    properties: {
      PUBLIC_SETTING: ordinarySetting
      SECRET_SETTING: storageAccessKey
    }
  }
  {
    name: 'authsettings'
    properties: {
      clientSecret: storageAccessKey
      facebookAppSecret: storageAccessKey
      gitHubClientSecret: storageAccessKey
      googleClientSecret: storageAccessKey
      microsoftAccountClientSecret: storageAccessKey
      twitterConsumerKey: storageAccessKey
      twitterConsumerSecret: storageAccessKey
      clientSecretSettingName: 'SECRET_SETTING'
    }
  }
  {
    name: 'authsettingsV2'
    properties: {
      identityProviders: {
        twitter: {
          registration: {
            consumerKey: storageAccessKey
            consumerSecretSettingName: 'SECRET_SETTING'
          }
        }
      }
    }
  }
  {
    name: 'backup'
    properties: {
      storageAccountUrl: storageAccessKey
      databases: [
        {
          connectionString: storageAccessKey
          databaseType: 'SqlAzure'
        }
      ]
    }
  }
  {
    name: 'connectionstrings'
    properties: {
      database: {
        type: 'SQLAzure'
        value: storageAccessKey
      }
    }
  }
  {
    name: 'logs'
    properties: {
      applicationLogs: {
        azureBlobStorage: {
          sasUrl: storageAccessKey
        }
        azureTableStorage: {
          sasUrl: storageAccessKey
        }
      }
      httpLogs: {
        azureBlobStorage: {
          sasUrl: storageAccessKey
        }
      }
    }
  }
  {
    name: 'metadata'
    properties: {
      credential: storageAccessKey
    }
  }
]

module site '../../../main.bicep' = {
  name: 'site-boundary'
  params: {
    name: 'boundary-site'
    kind: 'app'
    serverFarmResourceId: resourceId('Microsoft.Web/serverfarms', 'boundary-plan')
    configs: secretConfigs
    slots: [
      {
        name: 'staging'
        configs: secretConfigs
      }
    ]
  }
}

module slot '../../../slot/main.bicep' = {
  name: 'slot-boundary'
  params: {
    appName: 'boundary-site'
    name: 'standalone'
    kind: 'app'
    configs: secretConfigs
  }
}

module settingsDictionary '../../../slot/main.bicep' = {
  name: 'settings-dictionary-boundary'
  params: {
    appName: 'boundary-site'
    name: 'dictionary'
    kind: 'app'
    configs: [
      {
        name: 'appsettings'
        properties: retainedAppSettings
      }
      {
        name: 'metadata'
        properties: retainedAppSettings
      }
    ]
  }
}

module siteConfig '../../../config/main.bicep' = {
  name: 'direct-site-config-boundary'
  params: {
    appName: 'boundary-site'
    name: 'appsettings'
    properties: configProperties
    currentAppSettings: retainedAppSettings
  }
}

module slotConfig '../../../slot/config/main.bicep' = {
  name: 'direct-slot-config-boundary'
  params: {
    appName: 'boundary-site'
    slotName: 'staging'
    name: 'appsettings'
    properties: configProperties
    currentAppSettings: retainedAppSettings
  }
}
