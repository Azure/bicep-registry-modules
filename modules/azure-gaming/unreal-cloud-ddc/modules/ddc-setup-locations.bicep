param aksName string
@description('Deployment Location Specs')
param locationSpecs array

param resourceGroupName string = resourceGroup().name
param publicIpName string
param keyVaultName string
param servicePrincipalClientID string
param workerServicePrincipalClientID string = servicePrincipalClientID
param hostname string
param certificateName string

param managedIdentityPrefix string = 'id-ddc-storage-'

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

param azureTenantID string = subscription().tenantId
param keyVaultTenantID string = subscription().tenantId
param loginTenantID string = subscription().tenantId

@description('Delete old ref records no longer in use across the entire system')
param CleanOldRefRecords bool = true

@description('Delete old blobs that are no longer referenced by any ref - this runs in each region to cleanup that regions blob stores')
param CleanOldBlobs bool = true

param helmVersion string = 'latest'
param helmChart string
param helmName string
param helmNamespace string
param siteName string
param imageVersion string

@description('Set to false to deploy from as an ARM template for debugging') 
param isApp bool = true

@description('Array of ddc namespaces to replicate if there are secondary regions') 
param namespacesToReplicate array = []

module ddcSetup 'ddc-umbrella.bicep' = [for (spec, index) in locationSpecs: {
  name: 'helmInstall-ddc-${uniqueString(spec.location, resourceGroup().id, deployment().name)}'
  params: {
    aksName: aksName
    location: spec.location
    resourceGroupName: resourceGroupName
    keyVaultName: take('${spec.location}-${keyVaultName}', 24)
    servicePrincipalClientID: servicePrincipalClientID
    workerServicePrincipalClientID: workerServicePrincipalClientID
    hostname: hostname
    locationHostname: spec.fullLocationHostName
    replicationSourceHostname: spec.fullSourceLocationHostName
    certificateName: certificateName
    locationCertificateName: spec.locationCertName
    keyVaultTenantID: keyVaultTenantID
    loginTenantID: loginTenantID
    enableWorker: (length(locationSpecs) > 1)
    CleanOldRefRecords: (locationSpecs[0].location == spec.location) ? CleanOldRefRecords : false
    CleanOldBlobs: CleanOldBlobs
    namespacesToReplicate: namespacesToReplicate
    helmVersion: helmVersion
    helmChart: helmChart
    helmName: helmName
    helmNamespace: helmNamespace
    siteName: siteName
    imageVersion: imageVersion
  }
}]

module configAKS 'ContainerService/configure-aks.bicep' = [for (spec, index) in locationSpecs: {
  name: 'configAKS-${uniqueString(spec.location, resourceGroup().id, deployment().name)}'
  params: {
    location: spec.location
    aksName: '${aksName}-${take(spec.location, 8)}'
    additionalCharts: [ ddcSetup[index].outputs.helmChart ]
    staticIP: '${publicIpName}-${spec.location}'
    azureTenantID: azureTenantID
    useExistingManagedIdentity: useExistingManagedIdentity
    managedIdentityName: '${managedIdentityPrefix}${spec.location}'
    existingManagedIdentitySubId: existingManagedIdentitySubId
    existingManagedIdentityResourceGroupName: existingManagedIdentityResourceGroupName
    isApp: isApp
  }
}]
