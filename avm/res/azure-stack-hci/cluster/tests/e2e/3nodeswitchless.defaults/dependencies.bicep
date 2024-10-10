@minLength(4)
@maxLength(8)
param deploymentPrefix string
param deploymentUsername string
@secure()
param deploymentUserPassword string
param localAdminUsername string
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
param clusterNodeNames array
param softDeleteRetentionDays int = 30
@minValue(0)
@maxValue(365)
param logsRetentionInDays int = 30
param vnetSubnetId string
param serviceShort string = 'ashcmin'
param switchlessStorageConfig bool
param hciNodeCount int
param hciVHDXDownloadURL string
param hciISODownloadURL string
param clusterWitnessStorageAccountName string
param keyVaultDiagnosticStorageAccountName string
param keyVaultName string
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''

var arcNodeResourceIds = [
  for (nodeName, index) in clusterNodeNames: resourceId('Microsoft.HybridCompute/machines', nodeName)
]

var tenantId = subscription().tenantId

module hciHostDeployment '../../../../../../utilities/e2e-template-assets/templates/azure-stack-hci/modules/azureStackHCIHost/hciHostDeployment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-hcihostdeploy-${location}-${deploymentPrefix}'
  params: {
    deploymentUsername: deploymentUsername
    hciISODownloadURL: hciISODownloadURL
    hciNodeCount: hciNodeCount
    hostVMSize: 'Standard_E32bds_v5'
    hciVHDXDownloadURL: hciVHDXDownloadURL
    localAdminPassword: localAdminPassword
    location: location
    switchlessStorageConfig: switchlessStorageConfig
    vnetSubnetID: vnetSubnetId
  }
}

// MICROSOFT GRAPH RESOURCES in Bicep are in preview and break the AVM end-to-end tests
// module microsoftGraphResources '../../../../../../utilities/e2e-template-assets/templates/azure-stack-hci/modules/microsoftGraphResources/main.bicep' = if (hciResourceProviderObjectId == null) {
//   name: '${uniqueString(deployment().name, location)}-test-arbappreg-${serviceShort}'
//   params: {}
// }

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
