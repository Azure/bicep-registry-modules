param location string
param storageAccountName string
param containerName string

var filename = 'functionapp.zip'
var zipfile = loadFileAsBase64('./data/functionapp.zip')

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource uploadFunctionZip 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'upload-zipfile'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.26.1'
    timeout: 'PT5M'
    retentionInterval: 'PT1H'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_ACCOUNT'
        value: storageAccountName
      }
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storageAccount.listKeys().keys[0].value
      }
    ]
    scriptContent: 'echo "${zipfile}" | base64 -d > ${filename} && az storage blob upload -f ${filename} -c ${containerName} -n ${filename}'
  }
}

@description('URI of the function app source code zip file.')
output zipFileUri string = '${storageAccount.properties.primaryEndpoints.blob}${containerName}/${filename}'
