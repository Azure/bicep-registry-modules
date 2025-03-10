param location string

@description('Required. The name of the storage account to create as a cluster witness.')
param clusterWitnessStorageAccountName string

@description('Required. The name of the storage account to be created to collect Key Vault diagnostic logs.')
param keyVaultDiagnosticStorageAccountName string

@description('Required. The name of the Azure Key Vault to create.')
param keyVaultName string

param softDeleteRetentionDays int = 30

@description('Optional. The number of days for the retention in days. A value of 0 will retain the events indefinitely.')
@minValue(0)
@maxValue(365)
param logsRetentionInDays int = 30

param tenantId string
@secure()
param hciResourceProviderObjectId string
param arcNodeResourceIds array
param deploymentUsername string = 'deployUser'
@secure()
param deploymentUserPassword string
param localAdminUsername string
@secure()
param localAdminPassword string
@secure()
param arbDeploymentAppId string
@secure()
param arbDeploymentSPObjectId string
@secure()
param arbDeploymentServicePrincipalSecret string
param vnetSubnetResourceId string?
param allowIPtoStorageAndKeyVault string?
param usingArcGW bool = false
param clusterName string?
param cloudId string?

// secret names for the Azure Key Vault - these cannot be changed.
var localAdminSecretName = (empty(cloudId)) ? 'LocalAdminCredential' : '${clusterName}-LocalAdminCredential-${cloudId}'
var domainAdminSecretName = (empty(cloudId))
  ? 'AzureStackLCMUserCredential'
  : '${clusterName}-AzureStackLCMUserCredential-${cloudId}'
var arbDeploymentServicePrincipalName = (empty(cloudId))
  ? 'DefaultARBApplication'
  : '${clusterName}-DefaultARBApplication-${cloudId}'
var storageWitnessName = (empty(cloudId)) ? 'WitnessStorageKey' : '${clusterName}-WitnessStorageKey-${cloudId}'

// create base64 encoded secret values to be stored in the Azure Key Vault
var deploymentUserSecretValue = base64('${deploymentUsername}:${deploymentUserPassword}')
var localAdminSecretValue = base64('${localAdminUsername}:${localAdminPassword}')
var arbDeploymentServicePrincipalValue = base64('${arbDeploymentAppId}:${arbDeploymentServicePrincipalSecret}')

var storageAccountType = 'Standard_ZRS'

var azureConnectedMachineResourceManagerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'f5819b54-e033-4d82-ac66-4fec3cbf3f4c'
)
var readerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
)
var azureStackHCIDeviceManagementRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '865ae368-6a45-4bd1-8fbf-0d5151f56fc1'
)
var keyVaultSecretUserRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '4633458b-17de-408a-b874-0445c86b69e6'
)

module ARBDeploymentSPNSubscriptionRoleAssignmnent 'ashciARBSPRoleAssignment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-arbroleassignment'
  scope: subscription()
  params: {
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
  }
}

resource diagnosticStorageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: keyVaultDiagnosticStorageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
  resource blobService 'blobServices' = {
    name: 'default'
    properties: {
      deleteRetentionPolicy: {
        enabled: true
        days: 7
      }
      containerDeleteRetentionPolicy: {
        enabled: true
        days: 7
      }
    }
  }
}

resource SPConnectedMachineResourceManagerRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(
    subscription().subscriptionId,
    hciResourceProviderObjectId,
    'ConnectedMachineResourceManagerRolePermissions',
    resourceGroup().id
  )
  scope: resourceGroup()
  properties: {
    roleDefinitionId: azureConnectedMachineResourceManagerRoleID
    principalId: hciResourceProviderObjectId
    principalType: 'ServicePrincipal'
    description: 'Created by Azure Stack HCI deployment template'
  }
}

resource NodeAzureConnectedMachineResourceManagerRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'azureConnectedMachineResourceManager',
      hciNode,
      resourceGroup().id
    )
    properties: {
      roleDefinitionId: azureConnectedMachineResourceManagerRoleID
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource NodeazureStackHCIDeviceManagementRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'azureStackHCIDeviceManagementRole',
      hciNode,
      resourceGroup().id
    )
    properties: {
      roleDefinitionId: azureStackHCIDeviceManagementRole
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource NodereaderRoleIDPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(subscription().subscriptionId, hciResourceProviderObjectId, 'reader', hciNode, resourceGroup().id)
    properties: {
      roleDefinitionId: readerRoleID
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource KeyVaultSecretsUserPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for hciNode in arcNodeResourceIds: {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'keyVaultSecretUser',
      hciNode,
      resourceGroup().id
    )
    properties: {
      roleDefinitionId: keyVaultSecretUserRoleID
      principalId: reference(hciNode, '2023-10-03-preview', 'Full').identity.principalId
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]
