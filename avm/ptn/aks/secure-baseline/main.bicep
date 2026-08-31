targetScope = 'subscription'

metadata name = 'AKS Secure Baseline'
metadata description = 'Deploys the complete AKS1P compliant IPv4 cluster foundation with separate prerequisite and cluster resource groups.'

@description('Required. The name of the AKS managed cluster. This value is also used as the base for dependent resource names.')
@minLength(1)
@maxLength(63)
param clusterName string

@description('Required. The service or team name used to derive shared global and subscription resource names. Use the same value for clusters that share prerequisites.')
@minLength(1)
@maxLength(40)
param serviceName string

@description('Optional. The Azure region for shared global resources such as the shell identity and optional container registry.')
param globalLocation string = 'eastus2'

@description('Optional. The Azure region for subscription prerequisites such as Key Vault, Network Security Perimeter, and SSH key generation.')
param subscriptionLocation string = globalLocation

@description('Required. The Azure region for the AKS cluster and all cluster-specific networking, identity, and Bastion resources.')
param clusterLocation string

@description('Optional. The resource group for global resources such as the shell identity and optional container registry.')
param globalResourceGroupName string = 'rg-secure-baseline-${serviceName}-global'

@description('Optional. The resource group for subscription resources such as Key Vault, Network Security Perimeter, and SSH key generation.')
param subscriptionResourceGroupName string = 'rg-secure-baseline-${serviceName}-sub'

@description('Optional. The resource group for the optional resource-deletion managed identity.')
param resourceDeletionIdentityResourceGroupName string = 'rg-secure-baseline-${serviceName}-delete-identity'

@description('Optional. The resource group for the AKS cluster and its cluster-specific identities, networking, and Bastion resources.')
param clusterResourceGroupName string = 'rg-${clusterName}'

@description('Optional. The availability zones used by the AKS system node pool and public IP prefixes.')
param availabilityZones (1 | 2 | 3)[] = [
  1
  2
]

@description('Optional. The VM SKU used by the AKS system node pool.')
param systemPoolVmSku string = 'Standard_D8ds_v5'

@description('Optional. The minimum node count for the AKS system node pool.')
@minValue(3)
@maxValue(100)
param minSystemNodeCount int = 3

@description('Optional. Controls workload node provisioning. Auto enables Node Auto Provisioning. Manual creates user node pools managed by Cluster Autoscaler.')
param nodeProvisioningMode ('Auto' | 'Manual') = 'Auto'

@description('Optional. The number of user node pools to create when nodeProvisioningMode is Manual.')
@minValue(1)
@maxValue(10)
param numberOfUserPools int = 1

@description('Optional. The VM SKU used by user node pools when nodeProvisioningMode is Manual.')
param nodePoolVmSku string = 'Standard_D8ds_v5'

@description('Optional. The availability zones used by user node pools when nodeProvisioningMode is Manual.')
param nodePoolZones (1 | 2 | 3)[] = [
  1
  2
]

@description('Optional. The minimum node count for each user node pool when nodeProvisioningMode is Manual.')
@minValue(1)
@maxValue(100)
param minUserNodeCount int = 3

@description('Optional. The address prefixes assigned to the virtual network.')
param vnetAddressPrefix string[] = [
  '10.0.0.0/8'
]

@description('Optional. The IPv4 address prefix assigned to the AKS node subnet.')
param subnetAddressPrefixipV4 string = '10.200.0.0/16'

@description('Optional. The IPv4 address prefix assigned to AzureBastionSubnet.')
param bastionSubnetAddressPrefix string = '10.250.0.0/26'

@description('Optional. A FirstPartyUsage service tag applied to the public IP prefixes. Leave empty when no service tag has been assigned.')
param serviceTag string = ''

@description('Optional. The SKU used by the NAT gateway and public IP prefixes.')
param networkSku ('Standard' | 'StandardV2') = 'Standard'

@description('Optional. The tenant ID used by AKS Microsoft Entra integration.')
param tenantID string = tenant().tenantId

@description('Optional. The name of a Key Vault to create in the prerequisite resource group. Ignored when keyVaultResourceId is supplied.')
@minLength(3)
@maxLength(24)
param keyVaultName string = 'kv-${take(toLower(replace(serviceName, '-', '')), 10)}-${take(uniqueString(subscription().id, serviceName), 6)}'

@description('Optional. The resource ID of an existing Key Vault to adopt without managing its configuration. Leave empty to create keyVaultName in the prerequisite resource group.')
param keyVaultResourceId string = ''

@description('Optional. Enable purge protection on a newly created Key Vault. Keep disabled for disposable test deployments; enable for production.')
param enableKeyVaultPurgeProtection bool = false

@description('Optional. The name of the shared user-assigned identity used to create or retrieve the SSH key pair.')
param sshKeyGenerationIdentityName string = 'id-${serviceName}-shell'

@description('Optional. Deploy the shared Azure Container Registry used by the AKS1P EV2 topology. It is not consumed directly by the IPv4 cluster.')
param deployContainerRegistry bool = false

@description('Optional. The name of the shared Azure Container Registry.')
@minLength(5)
@maxLength(50)
param containerRegistryName string = 'acr${take(toLower(replace(serviceName, '-', '')), 20)}${take(uniqueString(subscription().id, serviceName), 6)}'

@description('Optional. Deploy the resource-deletion identity and grant it Contributor at subscription scope. This is only needed by an external resource-deletion workflow.')
param deployResourceDeletionIdentity bool = false

@description('Optional. The name of the resource-deletion managed identity.')
param resourceDeletionIdentityName string = 'id-${serviceName}-resource-del-shell'

@description('Optional. Deploy a Network Security Perimeter and associate the new or existing Key Vault.')
param deployKeyVaultNetworkSecurityPerimeter bool = true

@description('Optional. The name of the shared Network Security Perimeter.')
param keyVaultNetworkSecurityPerimeterName string = 'nsp-${serviceName}'

@description('Optional. The Key Vault Network Security Perimeter association access mode.')
param keyVaultNetworkSecurityPerimeterAccessMode ('Enforced' | 'Audit' | 'Learning') = 'Learning'

@description('Optional. The name of the Key Vault secret that stores the SSH public key.')
param sshPublicKeySecretName string = 'sshkey-public'

@description('Optional. The name of the Key Vault secret that stores the SSH private key.')
param sshPrivateKeySecretName string = 'sshkey-private'

@description('Optional. An SSH public key for Linux node access. When omitted, the pattern creates or reuses a key pair in Key Vault.')
@secure()
param sshPublicKey string?

@description('Optional. Use sshPublicKey instead of creating or reusing the shared Key Vault SSH key pair.')
param useSuppliedSshPublicKey bool = false

@description('Optional. Deploy an Azure Bastion host and the required AzureBastionSubnet.')
param deployBastion bool = true

@description('Optional. The LocalDNS mode applied to every AKS node pool.')
param localDNSMode ('Preferred' | 'Required' | 'Disabled') = 'Preferred'

@description('Optional. The Image Cleaner scan interval in hours.')
@minValue(24)
param imageCleanerIntervalHours int = 168

@description('Optional. The maintenance window start time in HH:mm format.')
param maintenanceWindowStartTime string = '01:00'

@description('Optional. The maintenance window UTC offset in +HH:mm or -HH:mm format.')
param maintenanceWindowUTCOffset string = '-07:00'

@description('Optional. The AKS Istio revision to enable.')
param istioRev string = 'asm-1-28'

@description('Optional. Tags supplied by the module consumer and applied to resources that support tags. The module does not add tags of its own.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource globalResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: globalResourceGroupName
  location: globalLocation
  tags: tags
}

resource subscriptionResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: subscriptionResourceGroupName
  location: subscriptionLocation
  tags: tags
}

resource resourceDeletionIdentityResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = if (deployResourceDeletionIdentity) {
  name: resourceDeletionIdentityResourceGroupName
  location: globalLocation
  tags: tags
}

resource clusterResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: clusterResourceGroupName
  location: clusterLocation
  tags: tags
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.aks-securebaseline.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, globalLocation, subscriptionLocation, clusterLocation), 0, 4)}'
  location: globalLocation
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

module globalDeployment 'modules/global-resources.bicep' = {
  scope: globalResourceGroup
  name: '${uniqueString(deployment().name, globalLocation, serviceName)}-Global'
  params: {
    location: globalLocation
    sshKeyGenerationIdentityName: sshKeyGenerationIdentityName
    deployContainerRegistry: deployContainerRegistry
    containerRegistryName: containerRegistryName
    tags: tags
    enableTelemetry: enableTelemetry
  }
  dependsOn: [
    avmTelemetry
  ]
}

module subscriptionDeployment 'modules/prerequisites.bicep' = {
  scope: subscriptionResourceGroup
  name: '${uniqueString(deployment().name, subscriptionLocation, serviceName)}-Subscription'
  params: {
    serviceName: serviceName
    location: subscriptionLocation
    keyVaultName: keyVaultName
    keyVaultResourceId: keyVaultResourceId
    enableKeyVaultPurgeProtection: enableKeyVaultPurgeProtection
    shellIdentityResourceId: globalDeployment.outputs.shellIdentityResourceId
    shellIdentityPrincipalId: globalDeployment.outputs.shellIdentityPrincipalId
    deployKeyVaultNetworkSecurityPerimeter: deployKeyVaultNetworkSecurityPerimeter
    keyVaultNetworkSecurityPerimeterName: keyVaultNetworkSecurityPerimeterName
    keyVaultNetworkSecurityPerimeterAccessMode: keyVaultNetworkSecurityPerimeterAccessMode
    sshPublicKeySecretName: sshPublicKeySecretName
    sshPrivateKeySecretName: sshPrivateKeySecretName
    generateSshKey: !useSuppliedSshPublicKey
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module resourceDeletionIdentityDeployment 'modules/resource-deletion-identity.bicep' = if (deployResourceDeletionIdentity) {
  scope: resourceDeletionIdentityResourceGroup
  name: '${uniqueString(deployment().name, globalLocation, serviceName)}-ResourceDeletionIdentity'
  params: {
    location: globalLocation
    name: resourceDeletionIdentityName
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module clusterDeploymentWithGeneratedKey 'modules/deployment.bicep' = if (!useSuppliedSshPublicKey) {
  scope: clusterResourceGroup
  name: '${uniqueString(deployment().name, clusterLocation, clusterName)}-Cluster'
  params: {
    clusterName: clusterName
    location: clusterLocation
    availabilityZones: availabilityZones
    systemPoolVmSku: systemPoolVmSku
    minSystemNodeCount: minSystemNodeCount
    nodeProvisioningMode: nodeProvisioningMode
    numberOfUserPools: numberOfUserPools
    nodePoolVmSku: nodePoolVmSku
    nodePoolZones: nodePoolZones
    minUserNodeCount: minUserNodeCount
    vnetAddressPrefix: vnetAddressPrefix
    subnetAddressPrefixipV4: subnetAddressPrefixipV4
    bastionSubnetAddressPrefix: bastionSubnetAddressPrefix
    serviceTag: serviceTag
    networkSku: networkSku
    tenantID: tenantID
    sshPublicKey: subscriptionDeployment.outputs.sshPublicKey
    deployBastion: deployBastion
    localDNSMode: localDNSMode
    imageCleanerIntervalHours: imageCleanerIntervalHours
    maintenanceWindowStartTime: maintenanceWindowStartTime
    maintenanceWindowUTCOffset: maintenanceWindowUTCOffset
    istioRev: istioRev
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module clusterDeploymentWithSuppliedKey 'modules/deployment.bicep' = if (useSuppliedSshPublicKey) {
  scope: clusterResourceGroup
  name: '${uniqueString(deployment().name, clusterLocation, clusterName)}-Cluster'
  params: {
    clusterName: clusterName
    location: clusterLocation
    availabilityZones: availabilityZones
    systemPoolVmSku: systemPoolVmSku
    minSystemNodeCount: minSystemNodeCount
    nodeProvisioningMode: nodeProvisioningMode
    numberOfUserPools: numberOfUserPools
    nodePoolVmSku: nodePoolVmSku
    nodePoolZones: nodePoolZones
    minUserNodeCount: minUserNodeCount
    vnetAddressPrefix: vnetAddressPrefix
    subnetAddressPrefixipV4: subnetAddressPrefixipV4
    bastionSubnetAddressPrefix: bastionSubnetAddressPrefix
    serviceTag: serviceTag
    networkSku: networkSku
    tenantID: tenantID
    sshPublicKey: sshPublicKey!
    deployBastion: deployBastion
    localDNSMode: localDNSMode
    imageCleanerIntervalHours: imageCleanerIntervalHours
    maintenanceWindowStartTime: maintenanceWindowStartTime
    maintenanceWindowUTCOffset: maintenanceWindowUTCOffset
    istioRev: istioRev
    tags: tags
    enableTelemetry: enableTelemetry
  }
  dependsOn: [
    subscriptionDeployment
  ]
}

@description('The name of the deployed AKS cluster.')
output aksClusterName string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.aksClusterName
  : clusterDeploymentWithSuppliedKey!.outputs.aksClusterName

@description('The resource ID of the deployed AKS cluster.')
output aksClusterResourceId string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.aksClusterResourceId
  : clusterDeploymentWithSuppliedKey!.outputs.aksClusterResourceId

@description('The control plane FQDN of the deployed AKS cluster.')
output aksControlPlaneFqdn string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.aksControlPlaneFqdn
  : clusterDeploymentWithSuppliedKey!.outputs.aksControlPlaneFqdn

@description('The OIDC issuer URL of the deployed AKS cluster.')
output aksOidcIssuerUrl string? = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.?aksOidcIssuerUrl
  : clusterDeploymentWithSuppliedKey!.outputs.?aksOidcIssuerUrl

@description('The resource ID of the AKS cluster user-assigned managed identity.')
output clusterIdentityResourceId string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.clusterIdentityResourceId
  : clusterDeploymentWithSuppliedKey!.outputs.clusterIdentityResourceId

@description('The resource ID of the virtual network.')
output virtualNetworkResourceId string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.virtualNetworkResourceId
  : clusterDeploymentWithSuppliedKey!.outputs.virtualNetworkResourceId

@description('The resource ID of the AKS node subnet.')
output aksSubnetResourceId string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.aksSubnetResourceId
  : clusterDeploymentWithSuppliedKey!.outputs.aksSubnetResourceId

@description('The resource ID of the outbound NAT gateway.')
output natGatewayResourceId string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.natGatewayResourceId
  : clusterDeploymentWithSuppliedKey!.outputs.natGatewayResourceId

@description('The resource ID of the public IP prefix reserved for ingress.')
output ingressPublicIpPrefixResourceId string = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.ingressPublicIpPrefixResourceId
  : clusterDeploymentWithSuppliedKey!.outputs.ingressPublicIpPrefixResourceId

@description('The resource ID of the new or adopted Key Vault.')
output keyVaultResourceId string = subscriptionDeployment.outputs.keyVaultResourceId

@description('The name of the Key Vault secret containing the SSH public key.')
output sshPublicKeySecretName string = subscriptionDeployment.outputs.sshPublicKeySecretName

@description('The name of the Key Vault secret containing the SSH private key.')
output sshPrivateKeySecretName string = subscriptionDeployment.outputs.sshPrivateKeySecretName

@description('The resource ID of the Network Security Perimeter, when deployed.')
output keyVaultNetworkSecurityPerimeterResourceId string? = subscriptionDeployment.outputs.?keyVaultNetworkSecurityPerimeterResourceId

@description('The resource ID of the Azure Bastion host, when deployed.')
output bastionHostResourceId string? = !useSuppliedSshPublicKey
  ? clusterDeploymentWithGeneratedKey!.outputs.?bastionHostResourceId
  : clusterDeploymentWithSuppliedKey!.outputs.?bastionHostResourceId

@description('The resource group containing global resources.')
output globalResourceGroupName string = globalResourceGroup.name

@description('The resource group containing subscription prerequisites.')
output subscriptionResourceGroupName string = subscriptionResourceGroup.name

@description('The resource group containing the resource-deletion identity, when deployed.')
output resourceDeletionIdentityResourceGroupName string? = deployResourceDeletionIdentity
  ? resourceDeletionIdentityResourceGroup!.name
  : null

@description('The resource ID of the shared shell identity.')
output shellIdentityResourceId string = globalDeployment.outputs.shellIdentityResourceId

@description('The resource ID of the shared container registry, when deployed.')
output containerRegistryResourceId string? = deployContainerRegistry ? globalDeployment.outputs.?containerRegistryResourceId : null

@description('The resource ID of the resource-deletion identity, when deployed.')
output resourceDeletionIdentityResourceId string? = deployResourceDeletionIdentity
  ? resourceDeletionIdentityDeployment!.outputs.resourceId
  : null

@description('The resource group containing the AKS cluster and cluster-specific resources.')
output clusterResourceGroupName string = clusterResourceGroup.name
