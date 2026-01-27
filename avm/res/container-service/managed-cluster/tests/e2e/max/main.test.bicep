targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled to test maximum parameter coverage.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    privateDnsZoneName: 'privatelink.${resourceLocation}.azmk8s.io'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    applicationGatewayName: 'dep-${namePrefix}-agw-${serviceShort}'
    publicIPName: 'dep-${namePrefix}-pip-${serviceShort}'
    publicIPAKSName: 'dep-${namePrefix}-pip-aks-${serviceShort}'
    diskEncryptionSetName: 'dep-${namePrefix}-des-${serviceShort}'
    // Adding base time to make the name unique as purge protection is enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    sshDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    sshKeyName: 'dep-${namePrefix}-ssh-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
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

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      apiServerAccessProfile: {
        enablePrivateCluster: true
        privateDNSZone: nestedDependencies.outputs.privateDnsZoneResourceId
        enableVnetIntegration: true
        subnetId: nestedDependencies.outputs.apiServerSubnetResourceId
      }
      primaryAgentPoolProfiles: [
        {
          name: 'systempool'
          availabilityZones: [
            1
            2
          ]
          count: 1
          mode: 'System'
          osDiskType: 'Managed'
          osDiskSizeGB: 128
          osType: 'Linux'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_DS2_v2'
          enableAutoScaling: true
          minCount: 1
          maxCount: 3
          maxPods: 50
          nodeTaints: ['CriticalAddonsOnly=true:NoSchedule']
          vnetSubnetResourceId: '${nestedDependencies.outputs.vNetResourceId}/subnets/defaultSubnet'
          upgradeSettings: {
            maxSurge: '33%'
            drainTimeoutInMinutes: 30
            nodeSoakDurationInMinutes: 0
          }
          powerState: {
            code: 'Running'
          }
        }
      ]
      agentPools: [
        {
          availabilityZones: [
            1
          ]
          count: 1
          name: 'userpool1'
          nodeLabels: {
            environment: 'dev'
            workload: 'general'
          }
          osDiskType: 'Ephemeral'
          osDiskSizeGB: 30
          osType: 'Linux'
          scaleSetPriority: 'Regular'
          type: 'VirtualMachineScaleSets'
          vmSize: 'Standard_D2s_v3'
          vnetSubnetResourceId: '${nestedDependencies.outputs.vNetResourceId}/subnets/defaultSubnet'
          enableAutoScaling: true
          maxCount: 2
          maxPods: 30
          minCount: 1
          minPods: 0
          mode: 'User'
          nodeTaints: []
          scaleSetEvictionPolicy: 'Delete'
          upgradeSettings: {
            maxSurge: '50%'
            drainTimeoutInMinutes: 30
            nodeSoakDurationInMinutes: 0
          }
          kubeletConfig: {
            cpuManagerPolicy: 'static'
            cpuCfsQuota: true
            cpuCfsQuotaPeriod: '100ms'
            imageGcHighThreshold: 85
            imageGcLowThreshold: 80
            topologyManagerPolicy: 'best-effort'
            allowedUnsafeSysctls: ['net.core.somaxconn']
            failSwapOn: false
            containerLogMaxSizeMB: 50
            containerLogMaxFiles: 5
            podMaxPids: 100
          }
          powerState: {
            code: 'Running'
          }
        }
      ]
      autoUpgradeProfile: {
        upgradeChannel: 'stable'
        nodeOSUpgradeChannel: 'NodeImage'
      }
      maintenanceConfigurations: [
        {
          name: 'aksManagedAutoUpgradeSchedule'
          maintenanceWindow: {
            schedule: {
              weekly: {
                intervalWeeks: 1
                dayOfWeek: 'Sunday'
              }
            }
            durationHours: 4
            utcOffset: '+00:00'
            startDate: '2024-07-15'
            startTime: '00:00'
          }
        }
        {
          name: 'aksManagedNodeOSUpgradeSchedule'
          maintenanceWindow: {
            schedule: {
              weekly: {
                intervalWeeks: 1
                dayOfWeek: 'Saturday'
              }
            }
            durationHours: 6
            utcOffset: '+00:00'
            startDate: '2024-07-15'
            startTime: '02:00'
          }
        }
      ]
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      skuTier: 'Standard'
      dnsServiceIP: '10.10.200.10'
      serviceCidr: '10.10.200.0/24'
      networkPluginMode: 'overlay'
      networkDataplane: 'azure'
      podCidr: '10.244.0.0/16'
      loadBalancerSku: 'standard'
      backendPoolType: 'NodeIPConfiguration'
      outboundType: 'loadBalancer'
      managedOutboundIPCount: 2
      allocatedOutboundPorts: 0
      idleTimeoutInMinutes: 30
      outboundPublicIPResourceIds: [
        nestedDependencies.outputs.publicIPAKSResourceId
      ]
      publicNetworkAccess: 'Disabled'
      skuName: 'Base'
      linuxProfile: {
        adminUsername: 'azureuser'
        ssh: {
          publicKeys: [
            {
              keyData: nestedDependencies.outputs.SSHKeyPublicKey
            }
          ]
        }
      }
      aadProfile: {
        enableAzureRBAC: true
        managed: true
        tenantID: tenant().tenantId
      }
      enableRBAC: true
      disableLocalAccounts: true
      nodeProvisioningProfile: {
        mode: 'Manual'
      }
      nodeResourceGroup: '${resourceGroup.name}-aks-nodes'
      nodeResourceGroupProfile: {
        restrictionLevel: 'ReadOnly'
      }
      podIdentityProfile: {
        enabled: false
      }
      enableOidcIssuerProfile: true
      costAnalysisEnabled: true
      httpApplicationRoutingEnabled: false
      webApplicationRoutingEnabled: true
      defaultIngressControllerType: 'Internal'
      enableDnsZoneContributorRoleAssignment: true
      ingressApplicationGatewayEnabled: true
      appGatewayResourceId: nestedDependencies.outputs.applicationGatewayResourceId
      aciConnectorLinuxEnabled: false
      azurePolicyEnabled: true
      azurePolicyVersion: 'v2'
      openServiceMeshEnabled: false
      kubeDashboardEnabled: false
      enableKeyvaultSecretsProvider: true
      enableSecretRotation: true
      autoScalerProfile: {
        'balance-similar-node-groups': 'false'
        'daemonset-eviction-for-empty-nodes': false
        'daemonset-eviction-for-occupied-nodes': true
        expander: 'random'
        'ignore-daemonsets-utilization': false
        'max-empty-bulk-delete': '10'
        'max-graceful-termination-sec': '600'
        'max-node-provision-time': '15m'
        'max-total-unready-percentage': '45'
        'new-pod-scale-up-delay': '0s'
        'ok-total-unready-count': '3'
        'scale-down-delay-after-add': '10m'
        'scale-down-delay-after-delete': '20s'
        'scale-down-delay-after-failure': '3m'
        'scale-down-unneeded-time': '10m'
        'scale-down-unready-time': '20m'
        'scale-down-utilization-threshold': '0.5'
        'scan-interval': '10s'
        'skip-nodes-with-local-storage': 'true'
        'skip-nodes-with-system-pods': 'true'
      }
      workloadAutoScalerProfile: {
        keda: {
          enabled: true
        }
        verticalPodAutoscaler: {
          enabled: true
        }
      }
      enableStorageProfileBlobCSIDriver: true
      enableStorageProfileDiskCSIDriver: true
      enableStorageProfileFileCSIDriver: true
      enableStorageProfileSnapshotController: true
      supportPlan: 'KubernetesOfficial'
      securityProfile: {
        defender: {
          logAnalyticsWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
          securityMonitoring: {
            enabled: true
          }
        }
        imageCleaner: {
          enabled: true
          intervalHours: 48
        }
      }
      omsAgentEnabled: true
      omsAgentUseAADAuth: true
      monitoringWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      identityProfile: {
        kubeletidentity: {
          resourceId: nestedDependencies.outputs.managedIdentityResourceId
        }
      }
      // Azure Monitor Profile (omit to satisfy current API schema)
      serviceMeshProfile: {
        mode: 'Disabled'
      }
      aiToolchainOperatorProfile: {
        enabled: false
      }
      upgradeSettings: {
        overrideSettings: {
          forceUpgrade: false
          until: '2025-12-31T23:59:59Z'
        }
      }
      diskEncryptionSetResourceId: nestedDependencies.outputs.diskEncryptionSetResourceId
      diagnosticSettings: [
        {
          name: 'customSetting'
          logCategoriesAndGroups: [
            {
              category: 'kube-apiserver'
            }
            {
              category: 'kube-controller-manager'
            }
            {
              category: 'kube-scheduler'
            }
            {
              category: 'kube-audit'
            }
            {
              category: 'kube-audit-admin'
            }
            {
              category: 'guard'
            }
            {
              category: 'cluster-autoscaler'
            }
            {
              category: 'cloud-controller-manager'
            }
            {
              category: 'csi-azuredisk-controller'
            }
            {
              category: 'csi-azurefile-controller'
            }
            {
              category: 'csi-snapshot-controller'
            }
          ]
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
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          name: guid('Owner assignment ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'Azure Kubernetes Service RBAC Cluster Admin'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
