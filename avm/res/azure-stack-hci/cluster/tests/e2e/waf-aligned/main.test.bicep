targetScope = 'subscription'

metadata name = 'Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned'
metadata description = 'This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster WAF aligned.'

@description('Optional. Location for all resources.')
param location string = deployment().location

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-azure-stack-hci.cluster-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashc2nwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminAndDeploymentUserPass string = newGuid()

@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''

@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentSPObjectId string = ''

@description('Required. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentServicePrincipalSecret string = ''

@description('Required. The service principal ID of the Azure Stack HCI Resource Provider in this tenant.')
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'southeastasia'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-nestedDependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterName: '${namePrefix}${serviceShort}001'
    clusterWitnessStorageAccountName: 'dep${namePrefix}wst${serviceShort}'
    customLocationName: 'dep-${namePrefix}${serviceShort}-location'
    keyVaultDiagnosticStorageAccountName: 'dep${namePrefix}st${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'

    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    deploymentUserPassword: localAdminAndDeploymentUserPass
    hciResourceProviderObjectId: hciResourceProviderObjectId
    localAdminPassword: localAdminAndDeploymentUserPass
    location: enforcedLocation
  }
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustermodule-${serviceShort}'
  scope: resourceGroup
  params: {
    name: nestedDependencies.outputs.clusterName
    customLocationName: nestedDependencies.outputs.customLocationName
    clusterNodeNames: nestedDependencies.outputs.clusterNodeNames
    clusterWitnessStorageAccountName: nestedDependencies.outputs.clusterWitnessStorageAccountName
    defaultGateway: '172.20.0.1'
    deploymentPrefix: 'a${take(uniqueString(namePrefix, serviceShort), 7)}' // ensure deployment prefix starts with a letter to match '^(?=.{1,8}$)([a-zA-Z])(\-?[a-zA-Z\d])*$'
    dnsServers: ['172.20.0.1']
    domainFqdn: 'hci.local'
    domainOUPath: nestedDependencies.outputs.domainOUPath
    startingIPAddress: '172.20.0.2'
    endingIPAddress: '172.20.0.7'
    enableStorageAutoIp: true
    keyVaultName: nestedDependencies.outputs.keyVaultName
    networkIntents: [
      {
        adapter: ['mgmt']
        name: 'management'
        overrideAdapterProperty: true
        adapterPropertyOverrides: {
          jumboPacket: '9014'
          networkDirect: 'Disabled'
          networkDirectTechnology: 'iWARP'
        }
        overrideQosPolicy: false
        qosPolicyOverrides: {
          bandwidthPercentage_SMB: '50'
          priorityValue8021Action_Cluster: '7'
          priorityValue8021Action_SMB: '3'
        }
        overrideVirtualSwitchConfiguration: false
        virtualSwitchConfigurationOverrides: {
          enableIov: 'true'
          loadBalancingAlgorithm: 'Dynamic'
        }
        trafficType: ['Management']
      }
      {
        adapter: ['comp0', 'comp1']
        name: 'compute'
        overrideAdapterProperty: true
        adapterPropertyOverrides: {
          jumboPacket: '9014'
          networkDirect: 'Disabled'
          networkDirectTechnology: 'iWARP'
        }
        overrideQosPolicy: false
        qosPolicyOverrides: {
          bandwidthPercentage_SMB: '50'
          priorityValue8021Action_Cluster: '7'
          priorityValue8021Action_SMB: '3'
        }
        overrideVirtualSwitchConfiguration: false
        virtualSwitchConfigurationOverrides: {
          enableIov: 'true'
          loadBalancingAlgorithm: 'Dynamic'
        }
        trafficType: ['Compute']
      }
      {
        adapter: ['smb0', 'smb1']
        name: 'storage'
        overrideAdapterProperty: true
        adapterPropertyOverrides: {
          jumboPacket: '9014'
          networkDirect: 'Disabled'
          networkDirectTechnology: 'iWARP'
        }
        overrideQosPolicy: true
        qosPolicyOverrides: {
          bandwidthPercentage_SMB: '50'
          priorityValue8021Action_Cluster: '7'
          priorityValue8021Action_SMB: '3'
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
        adapterName: 'smb0'
        vlan: '711'
      }
      {
        adapterName: 'smb1'
        vlan: '712'
      }
    ]
    subnetMask: '255.255.255.0'
  }
}
