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
param serviceShort string = 'ashcmin'
param switchlessStorageConfig bool
param hciNodeCount int
param hciISODownloadURL string
param clusterWitnessStorageAccountName string
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''
param keyVaultName string
param namePrefix string

var deploymentUsername = 'deployUser'
var localAdminUsername = 'admin-hci'
var clusterNodeNames = ['hcinode1', 'hcinode2']
var domainOUPath = 'OU=HCI,DC=hci,DC=local'
var hciHostAssignPublicIp = false
var keyVaultDiagnosticStorageAccountName = 'dep${take('${deploymentPrefix}${serviceShort}${take(uniqueString(resourceGroup().id,resourceGroup().location),6)}',17)}kvd'

var arcNodeResourceIds = [
  for (nodeName, index) in clusterNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)
]

var tenantId = subscription().tenantId

module hciHostDeployment '../../../../../../utilities/e2e-template-assets/templates/azure-stack-hci/modules/azureStackHCIHost/hciHostDeployment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy-${location}-${deploymentPrefix}'
  params: {
    hciHostAssignPublicIp: hciHostAssignPublicIp
    domainOUPath: domainOUPath
    deployProxy: false
    hciISODownloadURL: hciISODownloadURL
    hciNodeCount: hciNodeCount
    hostVMSize: 'Standard_E16bds_v5'
    localAdminPassword: localAdminPassword
    location: location
    switchlessStorageConfig: switchlessStorageConfig
    namingPrefix: 'dep-${serviceShort}${namePrefix}'
  }
}

module hciClusterPreqs '../../../../../../utilities/e2e-template-assets/templates/azure-stack-hci/modules/azureStackHCIClusterPreqs/ashciPrereqs.bicep' = {
  dependsOn: [
    hciHostDeployment
  ]
  name: '${uniqueString(deployment().name, location)}-test-hciclusterreqs-${serviceShort}'
  params: {
    location: location
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    arcNodeResourceIds: arcNodeResourceIds
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    keyVaultDiagnosticStorageAccountName: keyVaultDiagnosticStorageAccountName
    deploymentUsername: deploymentUsername
    deploymentUserPassword: deploymentUserPassword
    hciResourceProviderObjectId: hciResourceProviderObjectId
    keyVaultName: keyVaultName
    localAdminPassword: localAdminPassword
    localAdminUsername: localAdminUsername
    logsRetentionInDays: logsRetentionInDays
    softDeleteRetentionDays: softDeleteRetentionDays
    tenantId: tenantId
    vnetSubnetId: hciHostDeployment.outputs.vnetSubnetId
  }
}
