targetScope = 'subscription'

metadata name = 'Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned'
metadata description = 'This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster WAF aligned.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azurestackhci.cluster-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashclwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The password of the LCM deployment user and local administrator accounts.')
@secure()
param arbLocalAdminAndDeploymentUserPass string = ''

@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''

@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentSPObjectId string = ''

@description('Required. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentServicePrincipalSecret string = ''

@description('Required. The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the Microsoft.AzureStackHCI provider was registered in the subscription.')
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''

@description('Optional. The resource ID of a pre-baked Azure Compute Gallery image for the HCI host VM. Injected via CI-hciHostImageReferenceId secret.')
@secure()
#disable-next-line secure-parameter-default
param hciHostImageReferenceId string = ''

@description('Optional. The location to deploy resources into. Defaults to southeastasia. Can be overridden via the CI customLocation input when quota is unavailable.')
#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region is used as default in the AVM testing subscription
param enforcedLocation string = 'southeastasia'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/dependencies/dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-nestedDependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterName: '${namePrefix}${serviceShort}1'
    clusterWitnessStorageAccountName: 'dep${namePrefix}wst${serviceShort}'
    keyVaultDiagnosticStorageAccountName: 'dep${namePrefix}st${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    userAssignedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    maintenanceConfigurationAssignmentName: 'dep-${namePrefix}-mca-${serviceShort}'
    HCIHostVirtualMachineScaleSetName: 'dep-${namePrefix}-hvmss-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    networkInterfaceName: 'dep-${namePrefix}-mice-${serviceShort}'
    virtualMachineName: 'dep-${namePrefix}-vm-${serviceShort}'
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
    localAdminPassword: arbLocalAdminAndDeploymentUserPass
    diskNamePrefix: 'dep-${namePrefix}-dsk-${serviceShort}'
    waitDeploymentScriptPrefixName: 'dep-${namePrefix}-wds-${serviceShort}'
    hciHostImageReferenceId: hciHostImageReferenceId
    location: enforcedLocation
  }
}

// Note: Azure Stack HCI deploymentSettings does not support idempotent re-deployment.
// The API returns 'HciCluster is already registered, Unregister cluster to start re-deployment' on repeated deploys.
// Therefore, the standard 'idem' iteration is skipped for this module.
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustermodule-${serviceShort}'
    scope: resourceGroup
    params: {
      name: nestedDependencies.outputs.clusterName
      deploymentUser: 'deployUser'
      deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
      localAdminUser: 'Administrator'
      localAdminPassword: arbLocalAdminAndDeploymentUserPass
      servicePrincipalId: arbDeploymentAppId
      servicePrincipalSecret: arbDeploymentServicePrincipalSecret
      hciResourceProviderObjectId: hciResourceProviderObjectId
      deploymentSettings: {
        customLocationName: '${namePrefix}${serviceShort}-location'
        clusterNodeNames: nestedDependencies.outputs.clusterNodeNames
        clusterWitnessStorageAccountName: nestedDependencies.outputs.clusterWitnessStorageAccountName
        defaultGateway: '172.20.0.1'
        deploymentPrefix: 'a${take(uniqueString(namePrefix, serviceShort), 7)}' // ensure deployment prefix starts with a letter to match '^(?=.{1,8}$)([a-zA-Z])(\-?[a-zA-Z\d])*$'
        dnsServers: ['172.20.0.1']
        domainFqdn: 'hci.local'
        domainOUPath: nestedDependencies.outputs.domainOUPath
        startingIPAddress: '172.20.0.55'
        endingIPAddress: '172.20.0.65'
        enableStorageAutoIp: true
        keyVaultName: nestedDependencies.outputs.keyVaultName
        networkIntents: [
          {
            adapter: [
              'FABRIC'
              'FABRIC2'
            ]
            name: 'ManagementCompute'
            overrideAdapterProperty: true
            adapterPropertyOverrides: {
              jumboPacket: '9014'
              networkDirect: 'Disabled'
              networkDirectTechnology: 'iWARP'
            }
            overrideQosPolicy: false
            qosPolicyOverrides: {
              bandwidthPercentageSMB: '50'
              priorityValue8021ActionCluster: '7'
              priorityValue8021ActionSMB: '3'
            }
            overrideVirtualSwitchConfiguration: false
            virtualSwitchConfigurationOverrides: {
              enableIov: 'true'
              loadBalancingAlgorithm: 'Dynamic'
            }
            trafficType: [
              'Management'
              'Compute'
            ]
          }
          {
            adapter: [
              'StorageA'
              'StorageB'
            ]
            name: 'Storage'
            overrideAdapterProperty: true
            adapterPropertyOverrides: {
              jumboPacket: '9014'
              networkDirect: 'Disabled'
              networkDirectTechnology: 'iWARP'
            }
            overrideQosPolicy: true
            qosPolicyOverrides: {
              bandwidthPercentageSMB: '50'
              priorityValue8021ActionCluster: '7'
              priorityValue8021ActionSMB: '3'
            }
            overrideVirtualSwitchConfiguration: false
            virtualSwitchConfigurationOverrides: {
              enableIov: 'true'
              loadBalancingAlgorithm: 'Dynamic'
            }
            trafficType: ['Storage']
          }
        ]
        storageConnectivitySwitchless: false
        storageNetworks: [
          {
            name: 'Storage1Network'
            adapterName: 'StorageA'
            vlan: '711'
          }
          {
            name: 'Storage2Network'
            adapterName: 'StorageB'
            vlan: '712'
          }
        ]
        subnetMask: '255.255.255.0'
        driftControlEnforced: true
        smbSigningEnforced: true
        smbClusterEncryption: true
        sideChannelMitigationEnforced: true
        bitlockerBootVolume: true
        bitlockerDataVolumes: true
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
}
