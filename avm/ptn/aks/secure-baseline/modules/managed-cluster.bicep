metadata name = 'AKS Managed Cluster'
metadata description = 'Deploys the AKS managed cluster, system pool, and optional manually managed user pools.'

@description('Required. The name of the AKS managed cluster.')
param clusterName string

@description('Required. The Azure region in which to deploy the AKS managed cluster.')
param location string

@description('Required. The availability zones used by the AKS system node pool.')
param availabilityZones (1 | 2 | 3)[]

@description('Required. The VM SKU used by the AKS system node pool.')
param systemPoolVmSku string

@description('Required. The minimum node count for the AKS system node pool.')
param minSystemNodeCount int

@description('Required. Controls workload node provisioning.')
param nodeProvisioningMode ('Auto' | 'Manual')

@description('Required. The number of user node pools created in Manual mode.')
param numberOfUserPools int

@description('Required. The VM SKU used by user node pools in Manual mode.')
param nodePoolVmSku string

@description('Required. The availability zones used by user node pools in Manual mode.')
param nodePoolZones (1 | 2 | 3)[]

@description('Required. The minimum node count for each user node pool in Manual mode.')
param minUserNodeCount int

@description('Required. The tenant ID used by AKS Microsoft Entra integration.')
param tenantID string

@description('Optional. An SSH public key for Linux node access.')
@secure()
param sshPublicKey string?

@description('Required. The LocalDNS mode applied to every AKS node pool.')
param localDNSMode ('Preferred' | 'Required' | 'Disabled')

@description('Required. The Image Cleaner scan interval in hours.')
param imageCleanerIntervalHours int

@description('Required. The maintenance window start time in HH:mm format.')
param maintenanceWindowStartTime string

@description('Required. The maintenance window UTC offset in +HH:mm or -HH:mm format.')
param maintenanceWindowUTCOffset string

@description('Required. The AKS Istio revision to enable.')
param istioRev string

@description('Required. The resource ID of the AKS user-assigned managed identity.')
param clusterIdentityResourceId string

@description('Required. The client ID of the AKS user-assigned managed identity.')
param clusterIdentityClientId string

@description('Required. The principal ID of the AKS user-assigned managed identity.')
param clusterIdentityPrincipalId string

@description('Required. The resource ID of the AKS node subnet.')
param aksSubnetResourceId string

@description('Optional. Tags supplied by the module consumer.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable/Disable usage telemetry for the referenced AVM module.')
param enableTelemetry bool = true

var nodeResourceGroupName = 'rg-nodes-${clusterName}'
var dnsPrefix = 'dns-${clusterName}'
var kubernetesVersion = '1.34'
var maxNodesPerPool = 5
var enableClusterAutoscaler = nodeProvisioningMode == 'Manual'
var userAgentPoolProfiles = [
  for index in range(0, numberOfUserPools): {
    name: 'userpool${index}'
    count: minUserNodeCount
    vmSize: nodePoolVmSku
    osType: 'Linux'
    osSKU: 'AzureLinux3'
    type: 'VirtualMachineScaleSets'
    mode: 'User'
    enableAutoScaling: true
    minCount: minUserNodeCount
    maxCount: maxNodesPerPool
    maxPods: 110
    osDiskSizeGB: 128
    availabilityZones: nodePoolZones
    enableFIPS: true
    vnetSubnetResourceId: aksSubnetResourceId
    localDNSProfile: {
      mode: localDNSMode
    }
    upgradeSettings: {
      maxSurge: '33%'
      maxUnavailable: '0'
    }
  }
]

var managedClusterResourceId = resourceId('Microsoft.ContainerService/managedClusters', clusterName)

module managedCluster 'br/public:avm/res/container-service/managed-cluster:0.14.0' = {
  name: '${uniqueString(managedClusterResourceId, location)}-ManagedCluster'
  params: {
    name: clusterName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    nodeResourceGroup: nodeResourceGroupName
    skuName: 'Base'
    skuTier: 'Standard'
    managedIdentities: {
      userAssignedResourceIds: [
        clusterIdentityResourceId
      ]
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: clusterIdentityResourceId
        clientId: clusterIdentityClientId
        objectId: clusterIdentityPrincipalId
      }
    }
    aadProfile: {
      managed: true
      enableAzureRBAC: true
      tenantID: tenantID
    }
    enableRBAC: true
    disableLocalAccounts: true
    linuxProfile: sshPublicKey != null
      ? {
          adminUsername: 'azureuser'
          ssh: {
            publicKeys: [
              {
                keyData: sshPublicKey!
              }
            ]
          }
        }
      : null
    primaryAgentPoolProfiles: [
      {
        name: 'systempool'
        count: minSystemNodeCount
        vmSize: systemPoolVmSku
        osType: 'Linux'
        osSKU: 'AzureLinux3'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
        enableAutoScaling: enableClusterAutoscaler
        minCount: enableClusterAutoscaler ? minSystemNodeCount : null
        maxCount: enableClusterAutoscaler ? maxNodesPerPool : null
        maxPods: 110
        osDiskSizeGB: 128
        availabilityZones: availabilityZones
        enableFIPS: true
        nodeTaints: [
          'CriticalAddonsOnly=true:NoSchedule'
        ]
        vnetSubnetResourceId: aksSubnetResourceId
        localDNSProfile: {
          mode: localDNSMode
        }
        upgradeSettings: {
          maxSurge: '33%'
          maxUnavailable: '0'
        }
      }
    ]
    agentPools: nodeProvisioningMode == 'Manual' ? userAgentPoolProfiles : null
    nodeProvisioningProfile: {
      mode: nodeProvisioningMode
    }
    autoScalerProfile: enableClusterAutoscaler
      ? {
          'balance-similar-node-groups': 'true'
        }
      : null
    autoUpgradeProfile: {
      upgradeChannel: 'Patch'
      nodeOSUpgradeChannel: 'NodeImage'
    }
    maintenanceConfigurations: [
      {
        name: 'aksManagedAutoUpgradeSchedule'
        maintenanceWindow: {
          durationHours: 12
          schedule: {
            weekly: {
              dayOfWeek: 'Sunday'
              intervalWeeks: 1
            }
          }
          startTime: maintenanceWindowStartTime
          utcOffset: maintenanceWindowUTCOffset
        }
      }
      {
        name: 'aksManagedNodeOSUpgradeSchedule'
        maintenanceWindow: {
          durationHours: 12
          schedule: {
            weekly: {
              dayOfWeek: 'Sunday'
              intervalWeeks: 1
            }
          }
          startTime: maintenanceWindowStartTime
          utcOffset: maintenanceWindowUTCOffset
        }
      }
    ]
    advancedNetworking: {
      enabled: true
    }
    networkPlugin: 'azure'
    networkPluginMode: 'overlay'
    networkPolicy: 'cilium'
    networkDataplane: 'cilium'
    outboundType: 'userAssignedNATGateway'
    ipFamilies: [
      'IPv4'
    ]
    podCidrs: [
      '10.244.0.0/16'
    ]
    serviceCidrs: [
      '192.168.0.0/16'
    ]
    dnsServiceIP: '192.168.0.10'
    azurePolicyEnabled: true
    enableOidcIssuerProfile: true
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
      imageCleaner: {
        enabled: true
        intervalHours: imageCleanerIntervalHours
      }
    }
    workloadAutoScalerProfile: {
      keda: {
        enabled: true
      }
      verticalPodAutoscaler: {
        enabled: true
      }
    }
    enableStorageProfileDiskCSIDriver: true
    enableStorageProfileFileCSIDriver: true
    enableStorageProfileSnapshotController: true
    serviceMeshProfile: {
      mode: 'Istio'
      istio: {
        components: {
          ingressGateways: [
            {
              enabled: true
              mode: 'External'
            }
            {
              enabled: true
              mode: 'Internal'
            }
          ]
        }
        revisions: [
          istioRev
        ]
      }
    }
    omsAgentEnabled: false
  }
}

@description('The name of the deployed AKS cluster.')
output name string = managedCluster.outputs.name

@description('The resource ID of the deployed AKS cluster.')
output resourceId string = managedCluster.outputs.resourceId

@description('The control plane FQDN of the deployed AKS cluster.')
output controlPlaneFqdn string = managedCluster.outputs.controlPlaneFQDN

@description('The OIDC issuer URL of the deployed AKS cluster.')
output oidcIssuerUrl string? = managedCluster.outputs.?oidcIssuerUrl
