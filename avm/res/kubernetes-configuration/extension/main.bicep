metadata name = 'Kubernetes Configuration Extensions'
metadata description = 'This module deploys a Kubernetes Configuration Extension.'

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

@description('Optional. Configuration settings that are sensitive, as name-value pairs for configuring this extension.')
@secure()
param configurationProtectedSettings resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.configurationProtectedSettings?

@description('Optional. Configuration settings, as name-value pairs for configuring this extension.')
param configurationSettings resourceInput<'Microsoft.KubernetesConfiguration/extensions@2024-11-01'>.properties.configurationSettings?

@description('Required. Type of the extension, of which this resource is an instance of. It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the extension publisher.')
param extensionType string

@description('Optional. ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is "true".')
param releaseTrain string?

@description('Optional. Namespace where the extension Release must be placed, for a Cluster scoped extension. If this namespace does not exist, it will be created.')
param releaseNamespace string?

@description('Optional. Namespace where the extension will be created for an Namespace scoped extension. If this namespace does not exist, it will be created.')
param targetNamespace string?

@description('Optional. Version of the extension for this extension, if it is "pinned" to a specific version.')
param version string?

@description('Optional. A list of flux configuraitons.')
param fluxConfigurations resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties[]?

var enableReferencedModulesTelemetry = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.kubernetesconfiguration-extension.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource managedCluster 'Microsoft.ContainerService/managedClusters@2025-05-01' existing = if (clusterType == 'managedCluster') {
  name: clusterName
}

// Arc-enabled Connected Cluster resource reference
resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = if (clusterType == 'connectedCluster') {
  name: clusterName
}

var extensionProperties = {
  autoUpgradeMinorVersion: !empty(version) ? false : true
  configurationProtectedSettings: configurationProtectedSettings
  configurationSettings: configurationSettings
  extensionType: extensionType
  releaseTrain: releaseTrain
  scope: {
    cluster: !empty(releaseNamespace)
      ? {
          releaseNamespace: releaseNamespace
        }
      : null
    namespace: !empty(targetNamespace)
      ? {
          targetNamespace: targetNamespace
        }
      : null
  }
  version: version
}

resource managedExtension 'Microsoft.KubernetesConfiguration/extensions@2024-11-01' = if (clusterType == 'managedCluster') {
  name: name
  scope: managedCluster
  properties: extensionProperties
}

resource connectedExtension 'Microsoft.KubernetesConfiguration/extensions@2024-11-01' = if (clusterType == 'connectedCluster') {
  name: name
  identity: {
    type: 'SystemAssigned'
  }
  scope: connectedCluster
  properties: extensionProperties
}

module fluxConfiguration 'br/public:avm/res/kubernetes-configuration/flux-configuration:0.3.8' = [
  for (fluxConfiguration, index) in (fluxConfigurations ?? []): {
    name: '${uniqueString(deployment().name, location)}-Cluster-FluxConfiguration${index}'
    params: {
      enableTelemetry: enableReferencedModulesTelemetry
      clusterName: clusterName
      scope: fluxConfiguration.scope
      namespace: fluxConfiguration.namespace
      clusterType: clusterType
      sourceKind: contains(fluxConfiguration, 'gitRepository') ? 'GitRepository' : 'Bucket'
      name: fluxConfiguration.?name ?? toLower('${clusterName}-fluxconfiguration${index}')
      bucket: fluxConfiguration.?bucket
      configurationProtectedSettings: fluxConfiguration.?configurationProtectedSettings
      gitRepository: fluxConfiguration.?gitRepository
      kustomizations: fluxConfiguration.kustomizations
      suspend: fluxConfiguration.?suspend
    }
    dependsOn: [
      managedExtension
      connectedExtension
    ]
  }
]

@description('The name of the extension.')
output name string = clusterType == 'managedCluster' ? managedExtension.name : connectedExtension.name

@description('The resource ID of the extension.')
output resourceId string = clusterType == 'managedCluster' ? managedExtension.id : connectedExtension.id

@description('The name of the resource group the extension was deployed into.')
output resourceGroupName string = resourceGroup().name
