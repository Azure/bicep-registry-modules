@minLength(4)
@maxLength(8)
param deploymentPrefix string
@secure()
param deploymentUserPassword string
@secure()
param localAdminPassword string
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentSPObjectId string = ''
@secure()
param arbDeploymentServicePrincipalSecret string = ''
param location string
param softDeleteRetentionDays int = 30
@minValue(0)
@maxValue(365)
param logsRetentionInDays int = 30
param serviceShort string
param clusterWitnessStorageAccountName string
param keyVaultDiagnosticStorageAccountName string
param keyVaultName string
param customLocationName string

@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''
param namePrefix string
param clusterName string

var clusterNodeNames = ['hcinode1', 'hcinode2']
var domainOUPath = 'OU=HCI,DC=hci,DC=local'

var tenantId = subscription().tenantId

module hciHostDeployment '../../e2e-assets/azureStackHCIHost/hciHostDeployment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy-${location}-${serviceShort}${namePrefix}'
  params: {
    hciHostAssignPublicIp: true
    domainOUPath: domainOUPath
    deployProxy: false
    hciISODownloadURL: 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
    hciNodeCount: length(clusterNodeNames)
    hostVMSize: 'Standard_E16bds_v5'
    localAdminPassword: localAdminPassword
    location: location
    switchlessStorageConfig: false
    namingPrefix: 'dep-${serviceShort}${namePrefix}'
  }
}

// create the HCI cluster resource - cloudId property is needed for KeyVault secret names
resource cluster 'Microsoft.AzureStackHCI/clusters@2024-04-01' = {
  name: clusterName
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  properties: {}
}

module hciClusterPreqs '../../e2e-assets/azureStackHCIClusterPreqs/ashciPrereqs.bicep' = {
  dependsOn: [
    hciHostDeployment
  ]
  name: '${uniqueString(deployment().name, location)}-test-hciclusterreqs-${serviceShort}${namePrefix}'
  params: {
    location: location
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    arcNodeResourceIds: [
      for (nodeName, index) in clusterNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)
    ]
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    keyVaultDiagnosticStorageAccountName: keyVaultDiagnosticStorageAccountName
    deploymentUsername: 'deployUser'
    deploymentUserPassword: deploymentUserPassword
    hciResourceProviderObjectId: hciResourceProviderObjectId
    keyVaultName: keyVaultName
    localAdminPassword: localAdminPassword
    localAdminUsername: 'admin-hci'
    logsRetentionInDays: logsRetentionInDays
    softDeleteRetentionDays: softDeleteRetentionDays
    tenantId: tenantId
    vnetSubnetId: hciHostDeployment.outputs.vnetSubnetId
    clusterName: clusterName
    cloudId: cluster.properties.cloudId
  }
}

output cluster object = cluster
output clusterName string = clusterName
output clusterNodeNames array = clusterNodeNames
output clusterWitnessStorageAccountName string = clusterWitnessStorageAccountName
output customLocationName string = customLocationName
output domainOUPath string = domainOUPath
output hciClusterPreqs object = hciClusterPreqs
output keyVaultName string = keyVaultName
