metadata name = 'Kubernetes Configuration Extensions'
metadata description = 'This module deploys a Kubernetes Configuration Extension.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Flux Configuration.')
param name string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. The name of the AKS cluster that should be configured.')
param clusterName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Configuration settings that are sensitive, as name-value pairs for configuring this extension.')
@secure()
param configurationProtectedSettings object = {}

@description('Optional. Configuration settings, as name-value pairs for configuring this extension.')
param configurationSettings object = {}

@description('Required. Type of the Extension, of which this resource is an instance of. It must be one of the Extension Types registered with Microsoft.KubernetesConfiguration by the Extension publisher.')
param extensionType string

@description('Optional. ReleaseTrain this extension participates in for auto-upgrade (e.g. Stable, Preview, etc.) - only if autoUpgradeMinorVersion is "true".')
param releaseTrain string = 'Stable'

@description('Optional. Namespace where the extension Release must be placed, for a Cluster scoped extension. If this namespace does not exist, it will be created.')
param releaseNamespace string = ''

@description('Optional. Namespace where the extension will be created for an Namespace scoped extension. If this namespace does not exist, it will be created.')
param targetNamespace string = ''

@description('Optional. Version of the extension for this extension, if it is "pinned" to a specific version.')
param version string = ''

@description('Optional. A list of flux configuraitons.')
param fluxConfigurations array = []

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

resource extension 'Microsoft.KubernetesConfiguration/extensions@2022-03-01' = {
  name: name
  scope: managedCluster
  properties: {
    autoUpgradeMinorVersion: !empty(version) ? false : true
    configurationProtectedSettings: !empty(configurationProtectedSettings) ? configurationProtectedSettings : {}
    configurationSettings: !empty(configurationSettings) ? configurationSettings : {}
    extensionType: extensionType
    releaseTrain: !empty(releaseTrain) ? releaseTrain : null
    scope: {
      cluster: !empty(releaseNamespace) ? {
        releaseNamespace: releaseNamespace
      } : null
      namespace: !empty(targetNamespace) ? {
        targetNamespace: targetNamespace
      } : null
    }
    version: !empty(version) ? version : null
  }
}

module fluxConfiguration '../../kubernetes-configuration/flux-configuration/main.bicep' = [for (fluxConfiguration, index) in fluxConfigurations: {
  name: '${uniqueString(deployment().name, location)}-ManagedCluster-FluxConfiguration${index}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    clusterName: managedCluster.name
    scope: fluxConfiguration.scope
    namespace: fluxConfiguration.namespace
    sourceKind: contains(fluxConfiguration, 'gitRepository') ? 'GitRepository' : 'Bucket'
    name: contains(fluxConfiguration, 'name') ? fluxConfiguration.name : toLower('${managedCluster.name}-fluxconfiguration${index}')
    bucket: contains(fluxConfiguration, 'bucket') ? fluxConfiguration.bucket : {}
    configurationProtectedSettings: contains(fluxConfiguration, 'configurationProtectedSettings') ? fluxConfiguration.configurationProtectedSettings : {}
    gitRepository: contains(fluxConfiguration, 'gitRepository') ? fluxConfiguration.gitRepository : {}
    kustomizations: contains(fluxConfiguration, 'kustomizations') ? fluxConfiguration.kustomizations : {}
    suspend: contains(fluxConfiguration, 'suspend') ? fluxConfiguration.suspend : false
  }
  dependsOn: [
    extension
  ]
}]

@description('The name of the extension.')
output name string = extension.name

@description('The resource ID of the extension.')
output resourceId string = extension.id

@description('The name of the resource group the extension was deployed into.')
output resourceGroupName string = resourceGroup().name
