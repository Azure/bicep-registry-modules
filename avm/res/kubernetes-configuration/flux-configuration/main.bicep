metadata name = 'Kubernetes Configuration Flux Configurations'
metadata description = 'This module deploys a Kubernetes Configuration Flux Configuration.'

@description('Required. The name of the Flux Configuration.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The name of the AKS cluster that should be configured.')
param clusterName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'managedCluster'
  'connectedCluster'
])
@description('Optional. The type of cluster to configure. Choose between AKS managed cluster or Arc-enabled connected cluster.')
param clusterType string = 'managedCluster'

@description('Conditional. Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `Bucket`.')
param bucket resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.bucket?

@description('Optional. Key-value pairs of protected configuration settings for the configuration.')
@secure()
param configurationProtectedSettings resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.configurationProtectedSettings?

@description('Conditional. Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `GitRepository`.')
param gitRepository resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.gitRepository?

@description('Conditional. Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `OciRepository`.')
param ociRepository resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.ociRepository?

@description('Conditional. Parameters to reconcile to the GitRepository source kind type. Required if `sourceKind` is `AzureBlob`.')
param azureBlob resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.azureBlob?

@description('Required. Array of kustomizations used to reconcile the artifact pulled by the source type on the cluster.')
param kustomizations resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.kustomizations

@description('Required. The namespace to which this configuration is installed to. Maximum of 253 lower case alphanumeric characters, hyphen and period only.')
param namespace string

@description('Required. Scope at which the configuration will be installed.')
param scope resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.scope

@description('Required. Source Kind to pull the configuration data from.')
param sourceKind resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.sourceKind

@description('Optional. Reconciliation wait duration (ISO 8601 format).')
param reconciliationWaitDuration string?

@description('Optional. Whether this configuration should suspend its reconciliation of its kustomizations and sources.')
param suspend bool = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.kubernetesconfiguration-fluxconfig.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource managedCluster 'Microsoft.ContainerService/managedClusters@2025-04-01' existing = if (clusterType == 'managedCluster') {
  name: clusterName
}

// Arc-enabled Connected Cluster resource reference
resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = if (clusterType == 'connectedCluster') {
  name: clusterName
}

// Common flux configuration properties
var fluxConfigProperties = {
  scope: scope
  namespace: namespace
  sourceKind: sourceKind
  suspend: suspend
  reconciliationWaitDuration: reconciliationWaitDuration
  gitRepository: gitRepository
  azureBlob: azureBlob
  bucket: bucket
  configurationProtectedSettings: configurationProtectedSettings
  ociRepository: ociRepository
  kustomizations: kustomizations
}

resource fluxConfigurationManaged 'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01' = if (clusterType == 'managedCluster') {
  name: name
  scope: managedCluster
  properties: fluxConfigProperties
}

resource fluxConfigurationConnected 'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01' = if (clusterType == 'connectedCluster') {
  scope: connectedCluster
  name: name
  properties: fluxConfigProperties
}

@description('The name of the flux configuration.')
output name string = clusterType == 'managedCluster' ? fluxConfigurationManaged.name : fluxConfigurationConnected.name

@description('The resource ID of the flux configuration.')
output resourceId string = clusterType == 'managedCluster' ? fluxConfigurationManaged.id : fluxConfigurationConnected.id

@description('The name of the resource group the flux configuration was deployed into.')
output resourceGroupName string = resourceGroup().name
