param location string

@description('Storage account to store the deployment script and upload the zip file to.')
param storageAccountName string

@description('Blob service of the storage account. If not exist, create.')
param blobServiceName string = 'default'

@description('Name of the container where the zip file is uploaded to. If not exist, create.')
param containerName string

var filename = 'functionapp.zip'
var zipfile = loadFileAsBase64('../functionapp.zip')

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: blobServiceName
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: containerName
  parent: blobService
  properties: {
    publicAccess: 'Blob'
  }
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
    scriptContent: 'echo "${zipfile}" | base64 -d > ${filename} && az storage blob upload -f ${filename} -c ${containerName} -n ${filename} && az storage blob list --container-name ${containerName} | jq -c \'{filename: .[] | select(.name=="${filename}").name}\' > $AZ_SCRIPTS_OUTPUT_PATH'
  }
}

@description('URI of the function app source code zip file.')
output zipFileUri string = '${storageAccount.properties.primaryEndpoints.blob}${containerName}/${filename}'

@description('True if the zip file is found in the storage account.')
output isFileUploaded bool = length(uploadFunctionZip.properties.outputs.filename) > 0
