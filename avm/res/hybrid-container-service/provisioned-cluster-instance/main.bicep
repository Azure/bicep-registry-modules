metadata name = 'Hybrid Container Service Provisioned Cluster Instance'
metadata description = 'Deploy a provisioned cluster instance.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the provisioned cluster instance.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

//
// Add your parameters here
//

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.[[REPLACE WITH TELEMETRY IDENTIFIER]].${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

//
// Add your resources here
//

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

// @description('The resource ID of the resource.')
// output resourceId string = <Resource>.id

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//

@description('Optional. The name of the secret in the key vault that contains the SSH private key PEM.')
param sshPrivateKeyPemSecretName string = 'AksArcAgentSshPrivateKeyPem'

@description('Optional. The name of the secret in the key vault that contains the SSH public key.')
param sshPublicKeySecretName string = 'AksArcAgentSshPublicKey'

@description('Conditional. The key vault name.')
param keyVaultName string = ''

@description('Conditional. The SSH public key that will be used to access the kubernetes cluster nodes. If not specified, a new SSH key pair will be generated.')
param sshPublicKey string = ''

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource generateSSHKey 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (empty(sshPublicKey)) {
  name: 'generateSSHKey'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
  }
  properties: {
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    scriptContent: '''
      $key = [System.Security.Cryptography.RSA]::Create(4096)

      $privateKeyBytes = $key.ExportRSAPrivateKey()
      $privateKeyPem = "-----BEGIN RSA PRIVATE KEY-----`n"
      $privateKeyPem += [Convert]::ToBase64String($privateKeyBytes, [System.Base64FormattingOptions]::InsertLineBreaks)
      $privateKeyPem += "`n-----END RSA PRIVATE KEY-----"

      $publicKeyBytes = $key.ExportRSAPublicKey()
      $publicKeyPem = "-----BEGIN PUBLIC KEY-----`n"
      $publicKeyPem += [Convert]::ToBase64String($publicKeyBytes, [System.Base64FormattingOptions]::InsertLineBreaks)
      $publicKeyPem += "`n-----END PUBLIC KEY-----"

      $DeploymentScriptOutputs = @{}
      $DeploymentScriptOutputs['publicKey'] = $publicKeyPem
      $DeploymentScriptOutputs['privateKey'] = $privateKeyPem
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

@description('Required. The extended location name.')
param extendedLocationName string

@description('Required. The id of the Custom location that used to create hybrid aks.')
param customLocationId string

@description('Optional. Indicates whether the resource is exported.')
param isExported bool = false

@description('Optional. The Kubernetes version for the cluster.')
param kubernetesVersion string = ''

@description('Optional. Agent pool configuration.')
param agentPoolProfiles array = [
  {
    name: '${name}-nodepool1'
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
param controlPlaneIP string = ''

@description('Optional. The CIDR range for the pods in the kubernetes cluster.')
param podCidr string = '10.244.0.0/16'

@description('Optional. Azure Hybrid Benefit configuration.')
param azureHybridBenefit string = ''

@description('Optional. Enable or disable NFS CSI driver')
param nfsCsiDriverEnabled bool = true

@description('Optional. Enable or disable SMB CSI driver')
param smbCsiDriverEnabled bool = true

@description('Optional. The identity type for the cluster. Allowed values: "SystemAssigned", "None"')
@allowed([
  'SystemAssigned'
  'None'
])
param identityType string = 'SystemAssigned'

@description('Optional. Tags for the cluster resource')
param connectClustersTags object = {}

@description('Optional. The Azure AD tenant ID')
param aadTenantId string = ''

@description('Optional. The Azure AD admin group object IDs')
param aadAdminGroupObjectIds array = []

@description('Optional. Enable Azure RBAC')
param enableAzureRBAC bool = false

@description('Optional. Enable automatic agent upgrades')
@allowed([
  'Enabled'
  'Disabled'
])
param agentAutoUpgrade string = 'Enabled'

@description('Optional. Enable OIDC issuer')
param oidcIssuerEnabled bool = false

@description('Optional. Enable workload identity')
param workloadIdentityEnabled bool = false

module connectedCluster '../../kubernetes/connected-clusters/main.bicep' = {
  name: 'connectedCluster'
  params: {
    name: name
    location: location
    enableTelemetry: enableTelemetry
    identityType: identityType
    tags: connectClustersTags
    aadTenantId: aadTenantId
    aadAdminGroupObjectIds: aadAdminGroupObjectIds
    enableAzureRBAC: enableAzureRBAC
    agentAutoUpgrade: agentAutoUpgrade
    oidcIssuerEnabled: oidcIssuerEnabled
    workloadIdentityEnabled: workloadIdentityEnabled
  }
}

resource waitAksVhdReady 'Microsoft.Resources/deploymentScripts@2020-10-01' = if (!isExported) {
  name: 'waitAksVhdReady'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '7.0'
    scriptContent: loadTextContent('readiness.ps1')
    arguments: '-customLocationResourceId ${customLocationId} -kubernetesVersion ${empty(kubernetesVersion) ? '[PLACEHOLDER]' : kubernetesVersion} -osSku ${agentPoolProfiles[0].osSKU}'
    timeout: 'PT1H'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
    forceUpdateTag: resourceGroup().name
  }
}

resource provisionedCluster 'Microsoft.HybridContainerService/provisionedClusterInstances@2024-01-01' = {
  name: name
  dependsOn: [
    waitAksVhdReady
  ]
  extendedLocation: {
    name: extendedLocationName
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
    kubernetesVersion: kubernetesVersion
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
