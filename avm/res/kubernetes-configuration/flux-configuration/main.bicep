metadata name = 'Kubernetes Configuration Flux Configurations'
metadata description = 'This module deploys a Kubernetes Configuration Flux Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Flux Configuration.')
param name string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. The name of the AKS cluster that should be configured.')
param clusterName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Parameters to reconcile to the GitRepository source kind type.')
param bucket object = {}

@description('Optional. Key-value pairs of protected configuration settings for the configuration.')
@secure()
param configurationProtectedSettings object = {}

@description('Optional. Parameters to reconcile to the GitRepository source kind type.')
param gitRepository object = {}

@description('Optional. Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster.')
param kustomizations object = {}

@description('Required. The namespace to which this configuration is installed to. Maximum of 253 lower case alphanumeric characters, hyphen and period only.')
param namespace string

@allowed([
  'cluster'
  'namespace'
])
@description('Required. Scope at which the configuration will be installed.')
param scope string

@allowed([
  'Bucket'
  'GitRepository'
])
@description('Required. Source Kind to pull the configuration data from.')
param sourceKind string

@description('Optional. Whether this configuration should suspend its reconciliation of its kustomizations and sources.')
param suspend bool = false

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

resource managedCluster 'Microsoft.ContainerService/managedClusters@2022-07-01' existing = {
  name: clusterName
}

resource fluxConfiguration 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01' = {
  name: name
  scope: managedCluster
  properties: {
    bucket: !empty(bucket) ? bucket : null
    configurationProtectedSettings: !empty(configurationProtectedSettings) ? configurationProtectedSettings : {}
    gitRepository: !empty(gitRepository) ? gitRepository : null
    kustomizations: !empty(kustomizations) ? kustomizations : {}
    namespace: namespace
    scope: scope
    sourceKind: sourceKind
    suspend: suspend
  }
}

@description('The name of the flux configuration.')
output name string = fluxConfiguration.name

@description('The resource ID of the flux configuration.')
output resourceId string = fluxConfiguration.id

@description('The name of the resource group the flux configuration was deployed into.')
output resourceGroupName string = resourceGroup().name
