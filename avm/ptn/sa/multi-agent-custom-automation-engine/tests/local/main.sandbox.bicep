module testDeployment '../../main.bicep' = {
  name: 'test-macae-sandbox'
  params: {
    solutionPrefix: 'macaesbx004'
    solutionLocation: 'australiaeast'
    logAnalyticsWorkspaceConfiguration: {
      dataRetentionInDays: 30
    }
    applicationInsightsConfiguration: {
      retentionInDays: 30
    }
    virtualNetworkConfiguration: {
      enabled: false
    }
    aiFoundryStorageAccountConfiguration: {
      sku: 'Standard_LRS'
    }
    webServerFarmConfiguration: {
      skuCapacity: 1
      skuName: 'B2'
    }
  }
}
