metadata name = 'Unreal Cloud DDC'
metadata description = 'Unreal Cloud DDC for Unreal Engine game development.'
metadata owner = 'amiedansby'

//  Parameters
@description('Deployment Location')
param location string

@description('Secondary Deployment Locations')
param secondaryLocations array = []

@description('New or Existing Kubernentes Resources')
@allowed([ 'new', 'existing' ])
param newOrExistingKubernetes string = 'new'

@description('Name of Kubernetes Resource')
param aksName string = 'ddc-storage-${take(uniqueString(resourceGroup().id), 6)}'

@description('Number of Kubernetes Nodes')
param agentPoolCount int = 3

@description('Name of Kubernetes Agent Pool')
param agentPoolName string = 'k8agent'

@description('Virtual Machine Skew for Kubernetes')
param vmSize string = 'Standard_L16s_v2'

@description('Hostname of Deployment')
param hostname string = 'deploy1.ddc-storage.gaming.azure.com'

@description('If not empty, use the given existing DNS Zone for DNS entries and use shortHostname instead of hostname.')
param dnsZoneName string = ''

@description('If dnsZoneName is specified, its resource group must specified as well, since it is not expected to be part of the deployment resource group.')
param dnsZoneResourceGroupName string = ''

@description('Short hostname of deployment if dnsZoneName is specified')
param shortHostname string = 'ddc'

@description('Enable to configure certificate. Default: true')
param enableCert bool = true

@description('Unknown, Self, or {IssuerName} for certificate signing')
param certificateIssuer string = 'Self'

@description('Certificate Issuer Provider')
param issuerProvider string = ''

@description('Running this template requires roleAssignment permission on the Resource Group, which require an Owner role. Set this to false to deploy some of the resources')
param assignRole bool = true

@description('Enable Zonal Redunancy for supported regions')
param isZoneRedundant bool = true

@description('Create new or use existing Storage Account.')
@allowed([ 'new', 'existing' ])
param newOrExistingStorageAccount string = 'new'

@description('Name of Storage Account resource')
param storageAccountName string = 'ddc${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Name of Storage Account Resource Group')
param storageResourceGroupName string = resourceGroup().name

@description('Create new or use existing Key Vault')
@allowed([ 'new', 'existing' ])
param newOrExistingKeyVault string = 'new'

@description('Name of Key Vault resource')
param keyVaultName string = take('ddcKeyVault${uniqueString(resourceGroup().id, subscription().subscriptionId, location)}', 24)

@description('Create new or use existing Public IP resource')
@allowed([ 'new', 'existing' ])
param newOrExistingPublicIp string = 'new'

@description('Name of Public IP Resource')
param publicIpName string = 'ddcPublicIP${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Create new or use existing Traffic Manager Profile.')
@allowed([ 'new', 'existing' ])
param newOrExistingTrafficManager string = 'new'

@description('New or existing Traffic Manager Profile.')
param trafficManagerName string = 'traffic-mp-${uniqueString(resourceGroup().id)}'
@description('Relative DNS name for the traffic manager profile, must be globally unique.')
param trafficManagerDnsName string = 'tmp-${uniqueString(resourceGroup().id, subscription().id)}'

@description('Create new or use existing CosmosDB for Cassandra.')
@allowed([ 'new', 'existing' ])
param newOrExistingCosmosDB string = 'new'

@description('Name of Cosmos DB resource.')
param cosmosDBName string = 'ddc-db-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('Name of Cosmos DB Resource Group.')
param cosmosDBRG string = resourceGroup().name

@description('Application Managed Identity ID')
param servicePrincipalClientID string = ''

@description('Worker Managed Identity ID, required for geo-replication.')
param workerServicePrincipalClientID string = ''

@description('Worker Managed Identity Secret, which will be stored in Key Vault, and is required for geo-replication.')
@secure()
param workerServicePrincipalSecret string = ''

@description('Name of Certificate (Default certificate is self-signed)')
param certificateName string = 'unreal-cloud-ddc-cert'

@description('Set to true to agree to the terms and conditions of the Epic Games EULA found here: https://store.epicgames.com/en-US/eula')
param epicEULA bool = false

@description('Active Directory Tennat ID')
param azureTenantID string = subscription().tenantId

@description('Tenant ID for Key Vault')
param keyVaultTenantID string = azureTenantID

@description('Tenant ID for Authentication')
param loginTenantID string = azureTenantID

@description('Delete old ref records no longer in use across the entire system')
param CleanOldRefRecords bool = true

@description('Delete old blobs that are no longer referenced by any ref - this runs in each region to cleanup that regions blob stores')
param CleanOldBlobs bool = true

@secure()
@description('Connection String of User Provided Cassandra Database')
param cassandraConnectionString string = ''

@description('Connection Strings of User Provided Storage Accounts')
param storageConnectionStrings array = []

@description('Version of the image to deploy')
param imageVersion string = '0.38.1'

@description('Name of the Helm chart to deploy')
param helmChart string

@description('Helm Chart Version')
param helmVersion string = '0.2.3'

@description('Name of the Helm release')
param helmName string = 'myhordetest'

@description('Namespace of the Helm release')
param helmNamespace string = 'horde-tests'

@description('Name of the site')
param siteName string = 'ddc-${location}'

@description('Prefix of Managed Identity used during deployment')
param managedIdentityPrefix string = 'id-ddc-storage-'

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('Set to false to deploy from as an ARM template for debugging')
param isApp bool = true

@description('Set tags to apply to Key Vault resources')
param keyVaultTags object = {}

@description('Array of ddc namespaces to replicate if there are secondary regions')
param namespacesToReplicate array = []

@description('If new or existing, this will enable container insights on the AKS cluster. If new, will create one log analytics workspace per location')
@allowed([ 'new', 'existing', 'none' ])
param newOrExistingWorkspaceForContainerInsights string = 'none'

@description('The name of the log analytics workspace to use for container insights')
param logAnalyticsWorkspaceName string = 'law-ddc-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'

@description('The resource group corresponding to an existing logAnalyticsWorkspaceName')
param existingLogAnalyticsWorkspaceResourceGroupName string = ''

var nodeLabels = 'horde-storage'

var useDnsZone = (dnsZoneName != '') && (dnsZoneResourceGroupName != '')
var fullHostname = useDnsZone ? '${shortHostname}.${dnsZoneName}' : hostname

var newOrExisting = {
  new: 'new'
  existing: 'existing'
}

//  Resources
resource partnercenter 'Microsoft.Resources/deployments@2021-04-01' = {
  name: 'pid-7837dd60-4ba8-419a-a26f-237bbe170773-partnercenter'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

var enableTrafficManager = newOrExistingTrafficManager != 'none'

// Traffic Manager Profile

module trafficManager 'modules/network/trafficManagerProfiles.bicep' = if (enableTrafficManager) {
  name: 'trafficManager-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    name: trafficManagerName
    newOrExisting: newOrExistingTrafficManager
    trafficManagerDnsName: trafficManagerDnsName
  }
}

var trafficManagerNameForEndpoints = enableTrafficManager ? trafficManager.outputs.name : ''

var enableContainerInsights = (newOrExistingWorkspaceForContainerInsights != 'none')

// Log Analytics Workspace

module logAnalytics 'modules/insights/logAnalytics.bicep' = if (enableContainerInsights) {
  name: 'logAnalytics-${uniqueString(location, resourceGroup().id, deployment().name)}'
  params: {
    workspaceName: logAnalyticsWorkspaceName
    location: location
    newOrExistingWorkspace: newOrExisting[newOrExistingWorkspaceForContainerInsights]
    existingLogAnalyticsWorkspaceResourceGroupName: existingLogAnalyticsWorkspaceResourceGroupName
  }
}

var logAnalyticsWorkspaceResourceId = enableContainerInsights ? logAnalytics.outputs.workspaceId : ''

var allLocations = concat([ location ], secondaryLocations)

// Compute "source" locations for replication.
// Forms a cycle so that a given region replaces from only one other location.
var lastLocationIndex = length(allLocations) - 1
var sourceLocations = [for (location, index) in allLocations: (index > 0) ? allLocations[index - 1] : allLocations[lastLocationIndex]]

// Prepare a number of properties for each location
var locationSpecs = [for (location, index) in allLocations: {
  location: location
  sourceLocation: sourceLocations[index]
  locationCertName: '${certificateName}-${location}'
  fullLocationHostName: '${location}.${fullHostname}'
  fullSourceLocationHostName: '${sourceLocations[index]}.${fullHostname}'
}]

module allRegionalResources 'modules/resources.bicep' = [for (location, index) in allLocations: if (epicEULA) {
  name: guid(keyVaultName, publicIpName, cosmosDBName, storageAccountName, location)
  dependsOn: [
    trafficManager
  ]
  params: {
    location: location
    newOrExistingKubernetes: newOrExistingKubernetes
    newOrExistingKeyVault: newOrExistingKeyVault
    newOrExistingPublicIp: newOrExistingPublicIp
    newOrExistingStorageAccount: newOrExistingStorageAccount
    kubernetesParams: {
      name: '${aksName}-${take(location, 8)}'
      agentPoolCount: agentPoolCount
      agentPoolName: agentPoolName
      vmSize: vmSize
      clusterUserName: 'id-${aksName}-${location}'
      nodeLabels: nodeLabels
    }
    keyVaultName: take('${location}-${keyVaultName}', 24)
    keyVaultTags: keyVaultTags
    publicIpName: '${publicIpName}-${location}'
    trafficManagerNameForEndpoints: trafficManagerNameForEndpoints
    storageAccountName: '${take(location, 8)}${storageAccountName}'
    storageResourceGroupName: storageResourceGroupName
    storageSecretName: 'ddc-storage-connection-string'
    assignRole: assignRole
    isZoneRedundant: isZoneRedundant
    subject: 'system:serviceaccount:horde-tests:workload-identity-sa'
    storageAccountSecret: newOrExistingStorageAccount == 'existing' ? storageConnectionStrings[index] : ''
    useDnsZone: useDnsZone
    dnsZoneName: dnsZoneName
    dnsZoneResourceGroupName: dnsZoneResourceGroupName
    dnsRecordNameSuffix: shortHostname
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
  }
}]

module kvCert 'br/public:deployment-scripts/create-kv-certificate:3.0.1' = [for spec in locationSpecs: if (assignRole && enableCert) {
  name: 'akvCert-${spec.location}'
  dependsOn: [
    allRegionalResources
  ]
  params: {
    akvName: take('${spec.location}-${keyVaultName}', 24)
    location: spec.location
    certificateNames: [ certificateName, spec.locationCertName ]
    certificateCommonNames: [ fullHostname, spec.fullLocationHostName ]
    issuerName: certificateIssuer
    issuerProvider: issuerProvider
    useExistingManagedIdentity: useExistingManagedIdentity
    managedIdentityName: '${managedIdentityPrefix}${spec.location}'
    rbacRolesNeededOnKV: '00482a5a-887f-4fb3-b363-3b7fe8e74483' // Key Vault Admin
    isCrossTenant: isApp
  }
}]

module buildApp 'modules/keyvault/vaults/secrets.bicep' = [for location in union([ location ], secondaryLocations): if (assignRole && epicEULA && workerServicePrincipalSecret != '') {
  name: 'build-app-${location}-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'
  dependsOn: [
    allRegionalResources
  ]
  params: {
    keyVaultName: take('${location}-${keyVaultName}', 24)
    secrets: [ { secretName: 'build-app-secret', secretValue: workerServicePrincipalSecret } ]
  }
}]

module cosmosDB 'modules/documentDB/databaseAccounts.bicep' = if (newOrExistingCosmosDB == 'new') {
  name: 'cosmosDB-${uniqueString(location, resourceGroup().id, deployment().name)}-key'
  dependsOn: [
    allRegionalResources
  ]
  params: {
    location: location
    secondaryLocations: secondaryLocations
    name: cosmosDBName
    newOrExisting: newOrExistingCosmosDB
    cosmosDBRG: cosmosDBRG
  }
}

module cassandraKeys 'modules/keyvault/vaults/secrets.bicep' = [for location in union([ location ], secondaryLocations): if (assignRole && epicEULA) {
  name: 'cassandra-keys-${location}-${uniqueString(resourceGroup().id, subscription().subscriptionId)}'
  dependsOn: [
    cosmosDB
  ]
  params: {
    keyVaultName: take('${location}-${keyVaultName}', 24)
    secrets: [ { secretName: 'ddc-db-connection-string', secretValue: newOrExistingCosmosDB == 'new' ? cosmosDB.outputs.cassandraConnectionString : cassandraConnectionString } ]
  }
}]

module setuplocations 'modules/ddc-setup-locations.bicep' = if (assignRole && epicEULA) {
  name: 'setup-ddc-${location}'
  dependsOn: [
    cassandraKeys
    kvCert
  ]
  params: {
    aksName: aksName
    locationSpecs: locationSpecs
    resourceGroupName: resourceGroup().name
    publicIpName: publicIpName
    keyVaultName: keyVaultName
    servicePrincipalClientID: servicePrincipalClientID
    workerServicePrincipalClientID: workerServicePrincipalClientID
    hostname: fullHostname
    certificateName: certificateName
    azureTenantID: azureTenantID
    keyVaultTenantID: keyVaultTenantID
    loginTenantID: loginTenantID
    CleanOldRefRecords: CleanOldRefRecords
    CleanOldBlobs: CleanOldBlobs
    helmVersion: helmVersion
    helmChart: helmChart
    helmName: helmName
    helmNamespace: helmNamespace
    siteName: siteName
    imageVersion: imageVersion
    useExistingManagedIdentity: enableCert // If created, Reuse ID from Cert
    managedIdentityPrefix: managedIdentityPrefix
    existingManagedIdentitySubId: existingManagedIdentitySubId
    existingManagedIdentityResourceGroupName: existingManagedIdentityResourceGroupName
    isApp: isApp
    namespacesToReplicate: namespacesToReplicate
  }
}

// Add CNAME record for traffic manager only after all regional resources are created
module dnsRecords 'modules/network/dnsZoneCnameRecord.bicep' = if (useDnsZone) {
  name: 'dns-${uniqueString(dnsZoneName, resourceGroup().id, deployment().name)}'
  scope: resourceGroup(dnsZoneResourceGroupName)
  dependsOn: [
    trafficManager
    allRegionalResources
  ]
  params: {
    dnsZoneName: dnsZoneName
    recordName: shortHostname
    targetFQDN: trafficManager.outputs.fqdn
  }
}

// End

@description('Name of Cosmos DB resource')
output cosmosDBName string = cosmosDBName

@description('New or Existing Cosmos DB resource')
output newOrExistingCosmosDB string = newOrExistingCosmosDB
