metadata name = 'Hybrid Container Service Provisioned Cluster Instance'
metadata description = 'Deploy a provisioned cluster instance.'

@description('Required. The name of the provisioned cluster instance.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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

@description('Optional. The name of the secret in the key vault that contains the SSH private key PEM.')
param sshPrivateKeyPemSecretName string = 'AksArcAgentSshPrivateKeyPem'

@description('Optional. The name of the secret in the key vault that contains the SSH public key.')
param sshPublicKeySecretName string = 'AksArcAgentSshPublicKey'

@description('Conditional. The SSH public key that will be used to access the kubernetes cluster nodes. If not specified, a new SSH key pair will be generated. Required if no existing SSH keys.')
param sshPublicKey string?

@description('Conditional. The name of the key vault. The key vault name. Required if no existing SSH keys.')
param keyVaultName string?

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (empty(sshPublicKey) && !empty(keyVaultName)) {
  name: keyVaultName!
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'temp'
  location: location
}

resource generateSSHKey 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (empty(sshPublicKey)) {
  name: 'generateSSHKey'
  location: location
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

resource sshPublicKeyPem 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (empty(sshPublicKey)) {
  parent: kv
  name: sshPublicKeySecretName
  properties: {
    value: generateSSHKey.properties.outputs.publicKey
  }
}

resource sshPrivateKeyPem 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = if (empty(sshPublicKey)) {
  parent: kv
  name: sshPrivateKeyPemSecretName
  properties: {
    value: generateSSHKey.properties.outputs.privateKey
  }
}

var sshPublicKeyData = empty(sshPublicKey) ? generateSSHKey.properties.outputs.publicKey : sshPublicKey

@description('Required. The id of the Custom location that used to create hybrid aks.')
param customLocationId string

@description('Optional. The Kubernetes version for the cluster.')
param kubernetesVersion string?

@description('Optional. Agent pool configuration.')
param agentPoolProfiles array = [
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

@description('Required. The id of the logical network that the AKS nodes will be connected to.')
param logicalNetworkId string

@description('Optional. The number of control plane nodes.')
param controlPlaneCount int = 1

@description('Optional. The VM size for control plane nodes.')
param controlPlaneVmSize string = 'Standard_A4_v2'

@description('Optional. The host IP for control plane endpoint.')
param controlPlaneIP string?

@description('Optional. The CIDR range for the pods in the kubernetes cluster.')
param podCidr string = '10.244.0.0/16'

@description('Optional. Azure Hybrid Benefit configuration.')
@allowed([
  'False'
  'NotApplicable'
  'True'
])
param azureHybridBenefit string = 'False'

@description('Optional. Enable or disable NFS CSI driver.')
param nfsCsiDriverEnabled bool = true

@description('Optional. Enable or disable SMB CSI driver.')
param smbCsiDriverEnabled bool = true

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

var enableReferencedModulesTelemetry = false

module connectedCluster '../../kubernetes/connected-cluster/main.bicep' = {
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
    cloudProviderProfile: {
      infraNetworkProfile: {
        vnetSubnetIds: [
          logicalNetworkId
        ]
      }
    }
    clusterVMAccessProfile: {}
    controlPlane: {
      count: controlPlaneCount
      vmSize: controlPlaneVmSize
      controlPlaneEndpoint: {
        hostIP: controlPlaneIP
      }
    }
    kubernetesVersion: kubernetesVersion ?? ''
    licenseProfile: {
      azureHybridBenefit: azureHybridBenefit
    }
    linuxProfile: {
      ssh: {
        publicKeys: [
          {
            keyData: sshPublicKeyData
          }
        ]
      }
    }
    networkProfile: {
      podCidr: podCidr
      networkPolicy: 'calico'
      loadBalancerProfile: {
        // acctest0002 network only supports a LoadBalancer count of 0
        count: 0
      }
    }
    storageProfile: {
      nfsCsiDriver: {
        enabled: nfsCsiDriverEnabled
      }
      smbCsiDriver: {
        enabled: smbCsiDriverEnabled
      }
    }
  }
}

@description('The name of the Aks Arc.')
output name string = provisionedCluster.name

@description('The ID of the Aks Arc.')
output resourceId string = provisionedCluster.id

@description('The resource group of the Aks Arc.')
output resourceGroupName string = resourceGroup().name
