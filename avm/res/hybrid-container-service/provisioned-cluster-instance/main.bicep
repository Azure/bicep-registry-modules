metadata name = 'Hybrid Container Service Provisioned Cluster Instance'
metadata description = 'Deploy a provisioned cluster instance.'

@description('Required. The name of the provisioned cluster instance.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The name of the secret in the key vault that contains the SSH private key PEM.')
param sshPrivateKeyPemSecretName string = 'AksArcAgentSshPrivateKeyPem'

@description('Optional. The name of the secret in the key vault that contains the SSH public key.')
param sshPublicKeySecretName string = 'AksArcAgentSshPublicKey'

@description('Conditional. The name of the key vault. The key vault name. Required if no existing SSH keys.')
param keyVaultName string?

@description('Required. The id of the Custom location that used to create hybrid aks.')
param customLocationId string

@description('Optional. The Kubernetes version for the cluster.')
param kubernetesVersion string?

@description('Optional. The agent pool properties for the provisioned cluster.')
param agentPoolProfiles agentPoolProfilesType = [
  {
    name: 'nodepool1'
    count: 1
    enableAutoScaling: false
    maxCount: 5
    minCount: 1
    maxPods: 110
    nodeLabels: {}
    nodeTaints: []
    osSKU: 'CBLMariner'
    osType: 'Linux'
    vmSize: 'Standard_A4_v2'
  }
]

@description('Optional. The storage configuration profile for the provisioned cluster.')
param storageProfile storageProfileType = {
  nfsCsiDriver: {
    enabled: true
  }
  smbCsiDriver: {
    enabled: true
  }
}

@description('Optional. The network configuration profile for the provisioned cluster.')
param networkProfile networkProfileType = {
  podCidr: '10.244.0.0/16'
  networkPolicy: 'calico'
  loadBalancerProfile: {
    // acctest0002 network only supports a LoadBalancer count of 0
    count: 0
  }
}

@description('Optional. The profile for Linux VMs in the provisioned cluster.')
param linuxProfile linuxProfileType?

@description('Optional. The license profile of the provisioned cluster.')
param licenseProfile licenseProfileType = { azureHybridBenefit: 'False' }

@description('Optional. The profile for control plane of the provisioned cluster.')
param controlPlane controlPlaneType = {
  count: 1
  vmSize: 'Standard_A4_v2'
  controlPlaneEndpoint: {
    hostIP: null
  }
}

@description('Required. The profile for the underlying cloud infrastructure provider for the provisioned cluster.')
param cloudProviderProfile cloudProviderProfileType

@description('Optional. Tags for the cluster resource.')
param connectClustersTags object = {}

@description('Optional. The Azure AD tenant ID.')
param tenantId string?

@description('Optional. The Azure AD admin group object IDs.')
param aadAdminGroupObjectIds array = []

@description('Optional. Enable Azure RBAC.')
param enableAzureRBAC bool = false

@description('Optional. Enable automatic agent upgrades.')
@allowed([
  'Enabled'
  'Disabled'
])
param agentAutoUpgrade string = 'Enabled'

@description('Optional. Enable OIDC issuer.')
param oidcIssuerEnabled bool = false

@description('Optional. Enable workload identity.')
param workloadIdentityEnabled bool = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.hybcontsvc-provclustinst.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (empty(linuxProfile) && !empty(keyVaultName)) {
  name: keyVaultName!
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'temp'
  location: location
  tags: tags
}

resource generateSSHKey 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (empty(linuxProfile)) {
  name: 'generateSSHKey'
  location: location
  tags: tags
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    scriptContent: '''
      # Create temp directory in a known location
      $tempDir = "/tmp/sshkeys"
      New-Item -ItemType Directory -Path $tempDir -Force
      Set-Location $tempDir
      # Generate SSH key pair using ssh-keygen
      ssh-keygen -t rsa -b 4096 -f ./key -N '""' -q
      # Read the generated keys
      $publicKey = Get-Content -Path "./key.pub" -Raw
      $privateKey = Get-Content -Path "./key" -Raw
      # Clean up temp files
      Remove-Item -Path "./key*" -Force
      Remove-Item -Path $tempDir -Force -Recurse
      # Set output
      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['publicKey'] = $publicKey
      $DeploymentScriptOutputs['privateKey'] = $privateKey
    '''
  }
}

resource sshPublicKeyPem 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (empty(linuxProfile)) {
  parent: kv
  name: sshPublicKeySecretName
  properties: {
    value: generateSSHKey.properties.outputs.publicKey
  }
}

resource sshPrivateKeyPem 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (empty(linuxProfile)) {
  parent: kv
  name: sshPrivateKeyPemSecretName
  properties: {
    value: generateSSHKey.properties.outputs.privateKey
  }
}

var enableReferencedModulesTelemetry = false

module connectedCluster 'br/public:avm/res/kubernetes/connected-cluster:0.1.0' = {
  name: 'connectedCluster'
  params: {
    name: name
    location: location
    enableTelemetry: enableReferencedModulesTelemetry
    tags: connectClustersTags
    tenantId: tenantId
    aadAdminGroupObjectIds: aadAdminGroupObjectIds
    enableAzureRBAC: enableAzureRBAC
    agentAutoUpgrade: agentAutoUpgrade
    oidcIssuerEnabled: oidcIssuerEnabled
    workloadIdentityEnabled: workloadIdentityEnabled
  }
}

resource existingCluster 'Microsoft.Kubernetes/connectedClusters@2024-07-15-preview' existing = {
  name: name
}

resource provisionedCluster 'Microsoft.HybridContainerService/provisionedClusterInstances@2024-01-01' = {
  scope: existingCluster
  name: 'default'
  dependsOn: [
    connectedCluster
    sshPublicKeyPem
  ]
  extendedLocation: {
    name: customLocationId
    type: 'CustomLocation'
  }
  properties: {
    agentPoolProfiles: agentPoolProfiles
    cloudProviderProfile: cloudProviderProfile
    clusterVMAccessProfile: {}
    controlPlane: controlPlane
    kubernetesVersion: kubernetesVersion ?? ''
    licenseProfile: licenseProfile
    linuxProfile: linuxProfile ?? {
      ssh: {
        publicKeys: [
          {
            keyData: generateSSHKey.properties.outputs.publicKey
          }
        ]
      }
    }
    networkProfile: networkProfile
    storageProfile: storageProfile
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the Aks Arc.')
output name string = provisionedCluster.name

@description('The ID of the Aks Arc.')
output resourceId string = provisionedCluster.id

@description('The resource group of the Aks Arc.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type for agent pool profiles configuration.')
type agentPoolProfilesType = {
  @description('Required. The number of nodes for the pool.')
  count: int
  @description('Required. Whether to enable auto-scaling for the pool.')
  enableAutoScaling: bool
  @description('Required. The maximum number of nodes for auto-scaling.')
  maxCount: int
  @description('Required. The minimum number of nodes for auto-scaling.')
  minCount: int
  @description('Required. The maximum number of pods per node.')
  maxPods: int
  @description('Required. The name of the agent pool.')
  name: string
  @description('Required. The node labels to be applied to nodes in the pool.')
  nodeLabels: { *: string }
  @description('Required. The taints to be applied to nodes in the pool.')
  nodeTaints: string[]
  @description('Required. The OS SKU for the nodes.')
  osSKU: string
  @description('Required. The OS type for the nodes.')
  osType: string
  @description('Required. The VM size for the nodes.')
  vmSize: string
}[]

@export()
@description('The type for cloud provider profile configuration.')
type cloudProviderProfileType = {
  @description('Required. The infrastructure network profile configuration.')
  infraNetworkProfile: {
    @description('Required. The list of virtual network subnet IDs.')
    vnetSubnetIds: string[]
  }
}

@export()
@description('The type for control plane configuration.')
type controlPlaneType = {
  @description('Required. The control plane endpoint configuration.')
  controlPlaneEndpoint: {
    @description('Optional. The host IP address of the control plane endpoint.')
    hostIP: string?
  }
  @description('Required. The number of control plane nodes.')
  count: int
  @description('Required. The VM size for control plane nodes.')
  vmSize: string
}

@export()
@description('The type for license profile configuration.')
type licenseProfileType = {
  @description('Required. Azure Hybrid Benefit configuration.')
  azureHybridBenefit: 'False' | 'NotApplicable' | 'True'
}

@export()
@description('The type for Linux profile configuration.')
type linuxProfileType = {
  @description('Required. SSH configuration for Linux nodes.')
  ssh: {
    @description('Required. SSH public keys configuration.')
    publicKeys: [
      {
        @description('Required. The SSH public key data.')
        keyData: string
      }
    ]
  }
}

@export()
@description('The type for network profile configuration.')
type networkProfileType = {
  @description('Required. Load balancer profile configuration.')
  loadBalancerProfile: {
    @description('Required. The number of load balancers. Must be 0 as for now.')
    count: int
  }
  @description('Required. The network policy to use.')
  networkPolicy: string
  @description('Required. The CIDR range for the pods in the kubernetes cluster.')
  podCidr: string
}

@export()
@description('The type for storage profile configuration.')
type storageProfileType = {
  @description('Required. NFS CSI driver configuration.')
  nfsCsiDriver: {
    @description('Required. Whether the NFS CSI driver is enabled.')
    enabled: bool
  }
  @description('Required. SMB CSI driver configuration.')
  smbCsiDriver: {
    @description('Required. Whether the SMB CSI driver is enabled.')
    enabled: bool
  }
}
