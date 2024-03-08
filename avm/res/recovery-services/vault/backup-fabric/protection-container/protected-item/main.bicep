metadata name = 'Recovery Service Vaults Protection Container Protected Item'
metadata description = 'This module deploys a Recovery Services Vault Protection Container Protected Item.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the resource.')
param name string

@description('Conditional. Name of the Azure Recovery Service Vault Protection Container. Required if the template is used in a standalone deployment.')
param protectionContainerName string

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'AzureFileShareProtectedItem'
  'AzureVmWorkloadSAPAseDatabase'
  'AzureVmWorkloadSAPHanaDatabase'
  'AzureVmWorkloadSQLDatabase'
  'DPMProtectedItem'
  'GenericProtectedItem'
  'MabFileFolderProtectedItem'
  'Microsoft.ClassicCompute/virtualMachines'
  'Microsoft.Compute/virtualMachines'
  'Microsoft.Sql/servers/databases'
])
@description('Required. The backup item type.')
param protectedItemType string

@description('Required. ID of the backup policy with which this item is backed up.')
param policyId string

@description('Required. Resource ID of the resource to back up.')
param sourceResourceId string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource protectedItem 'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems@2023-01-01' = {
  name: '${recoveryVaultName}/Azure/${protectionContainerName}/${name}'
  location: location
  properties: {
    protectedItemType: any(protectedItemType)
    policyId: policyId
    sourceResourceId: sourceResourceId
  }
}

@description('The name of the Resource Group the protected item was created in.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the protected item.')
output resourceId string = protectedItem.id

@description('The Name of the protected item.')
output name string = protectedItem.name
