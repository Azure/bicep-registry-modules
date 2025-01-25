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

@description('Optional. Configuration settings that are sensitive, as name-value pairs for configuring this extension.')
@secure()
param configurationProtectedSettings object?

@description('Optional. Configuration settings, as name-value pairs for configuring this extension.')
param configurationSettings object?

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
param fluxConfigurations array?

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

resource managedCluster 'Microsoft.ContainerService/managedClusters@2022-07-01' existing = {
  name: clusterName
}

resource extension 'Microsoft.KubernetesConfiguration/extensions@2022-03-01' = {
  name: name
  scope: managedCluster
  properties: {
    autoUpgradeMinorVersion: !empty(version) ? false : true
    configurationProtectedSettings: configurationProtectedSettings
    configurationSettings: configurationSettings
    extensionType: extensionType
    releaseTrain: releaseTrain
    scope: {
      cluster: !empty(releaseNamespace ?? '')
        ? {
            releaseNamespace: releaseNamespace
          }
        : null
      namespace: !empty(targetNamespace ?? '')
        ? {
            targetNamespace: targetNamespace
          }
        : null
    }
    version: version
  }
}

module fluxConfiguration 'br/public:avm/res/kubernetes-configuration/flux-configuration:0.3.1' = [
  for (fluxConfiguration, index) in (fluxConfigurations ?? []): {
    name: '${uniqueString(deployment().name, location)}-ManagedCluster-FluxConfiguration${index}'
    params: {
      enableTelemetry: fluxConfiguration.?enableTelemetry ?? enableTelemetry
      clusterName: managedCluster.name
      scope: fluxConfiguration.scope
      namespace: fluxConfiguration.namespace
      sourceKind: contains(fluxConfiguration, 'gitRepository') ? 'GitRepository' : 'Bucket'
      name: fluxConfiguration.?name ?? toLower('${managedCluster.name}-fluxconfiguration${index}')
      bucket: fluxConfiguration.?bucket
      configurationProtectedSettings: fluxConfiguration.?configurationProtectedSettings
      gitRepository: fluxConfiguration.?gitRepository
      kustomizations: fluxConfiguration.kustomizations
      suspend: fluxConfiguration.?suspend
    }
    dependsOn: [
      extension
    ]
  }
]

@description('The name of the extension.')
output name string = extension.name

@description('The resource ID of the extension.')
output resourceId string = extension.id

@description('The name of the resource group the extension was deployed into.')
output resourceGroupName string = resourceGroup().name
