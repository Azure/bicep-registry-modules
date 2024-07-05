targetScope = 'subscription'
metadata name = 'Using Azure CNI Network Plugin.'
metadata description = 'This instance deploys the module with Azure CNI network plugin .'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csmaz'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    managedIdentityKubeletIdentityName: 'dep-${namePrefix}-msiki-${serviceShort}'
    diskEncryptionSetName: 'dep-${namePrefix}-des-${serviceShort}'
    proximityPlacementGroupName: 'dep-${namePrefix}-ppg-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    dnsZoneName: 'dep-${namePrefix}-dns-${serviceShort}.com'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      primaryAgentPoolProfile: [
        {
          availabilityZones: [
            '3'
          ]
          count: 1
          enableAutoScaling: true
          maxCount: 3
          maxPods: 30
          minCount: 1
          mode: 'System'
          name: 'systempool'
          nodeTaints: [
            'CriticalAddonsOnly=true:NoSchedule'
          ]
          osDiskSizeGB: 0
          osType: 'Linux'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_DS2_v2'
          vnetSubnetID: nestedDependencies.outputs.subnetResourceIds[0]
        }
      ]
      agentPools: [
        {
          availabilityZones: [
            '3'
          ]
          count: 2
          enableAutoScaling: true
          maxCount: 3
          maxPods: 30
          minCount: 1
          minPods: 2
          mode: 'User'
          name: 'userpool1'
          nodeLabels: {}
          osDiskSizeGB: 128
          osType: 'Linux'
          scaleSetEvictionPolicy: 'Delete'
          scaleSetPriority: 'Regular'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_DS2_v2'
          vnetSubnetID: nestedDependencies.outputs.subnetResourceIds[1]
          proximityPlacementGroupResourceId: nestedDependencies.outputs.proximityPlacementGroupResourceId
        }
        {
          availabilityZones: [
            '3'
          ]
          count: 2
          enableAutoScaling: true
          maxCount: 3
          maxPods: 30
          minCount: 1
          minPods: 2
          mode: 'User'
          name: 'userpool2'
          nodeLabels: {}
          osDiskSizeGB: 128
          osType: 'Linux'
          scaleSetEvictionPolicy: 'Delete'
          scaleSetPriority: 'Regular'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_DS2_v2'
          vnetSubnetID: nestedDependencies.outputs.subnetResourceIds[2]
        }
      ]
      autoUpgradeProfileUpgradeChannel: 'stable'
      enableWorkloadIdentity: true
      enableOidcIssuerProfile: true
      networkPlugin: 'azure'
      networkDataplane: 'azure'
      networkPluginMode: 'overlay'
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      diskEncryptionSetResourceId: nestedDependencies.outputs.diskEncryptionSetResourceId
      openServiceMeshEnabled: true
      enableStorageProfileBlobCSIDriver: true
      enableStorageProfileDiskCSIDriver: true
      enableStorageProfileFileCSIDriver: true
      enableStorageProfileSnapshotController: true
      managedIdentities: {
        userAssignedResourcesIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      identityProfile: {
        kubeletidentity: {
          resourceId: nestedDependencies.outputs.managedIdentityKubeletIdentityResourceId
        }
      }
      omsAgentEnabled: true
      monitoringWorkspaceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
      enableAzureDefender: true
      enableKeyvaultSecretsProvider: true
      enablePodSecurityPolicy: false
      enableAzureMonitorProfileMetrics: true
      customerManagedKey: {
        keyName: nestedDependencies.outputs.keyVaultEncryptionKeyName
        keyVaultNetworkAccess: 'Public'
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      }
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
      fluxExtension: {
        configurationSettings: {
          'helm-controller.enabled': 'true'
          'source-controller.enabled': 'true'
          'kustomize-controller.enabled': 'true'
          'notification-controller.enabled': 'true'
          'image-automation-controller.enabled': 'false'
          'image-reflector-controller.enabled': 'false'
        }
        configurations: [
          {
            namespace: 'flux-system'
            scope: 'cluster'
            gitRepository: {
              repositoryRef: {
                branch: 'main'
              }
              sshKnownHosts: ''
              syncIntervalInSeconds: 300
              timeoutInSeconds: 180
              url: 'https://github.com/mspnp/aks-baseline'
            }
          }
          {
            namespace: 'flux-system-helm'
            scope: 'cluster'
            gitRepository: {
              repositoryRef: {
                branch: 'main'
              }
              sshKnownHosts: ''
              syncIntervalInSeconds: 300
              timeoutInSeconds: 180
              url: 'https://github.com/Azure/gitops-flux2-kustomize-helm-mt'
            }
            kustomizations: {
              infra: {
                path: './infrastructure'
                dependsOn: []
                timeoutInSeconds: 600
                syncIntervalInSeconds: 600
                validation: 'none'
                prune: true
              }
              apps: {
                path: './apps/staging'
                dependsOn: [
                  'infra'
                ]
                timeoutInSeconds: 600
                syncIntervalInSeconds: 600
                retryIntervalInSeconds: 120
                prune: true
              }
            }
          }
        ]
      }
    }
    dependsOn: [
      nestedDependencies
      diagnosticDependencies
    ]
  }
]
