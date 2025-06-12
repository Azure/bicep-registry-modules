@description('Optional. The cluster deployment operations to execute. Defaults to "[Validate, Deploy]".')
@allowed([
  'Deploy'
  'Validate'
])
param deploymentOperations string[] = ['Validate', 'Deploy']

import { deploymentSettingsType } from '../main.bicep'
@description('Required. The deployment settings of the cluster.')
param deploymentSettings deploymentSettingsType

@description('Optional. Specify whether to use the shared key vault for the HCI cluster.')
param useSharedKeyVault bool = true

@description('Required. The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the \'Microsoft.AzureStackHCI\' provider was registered in the subscription.')
@secure()
param hciResourceProviderObjectId string

param clusterName string
param cloudId string

// if deployment operations requested, validation must be performed first so we reverse sort the array
var sortedDeploymentOperations = (!empty(deploymentOperations)) ? sort(deploymentOperations, (a, b) => a > b) : []

@batchSize(1)
module deploymentSetting '../deployment-setting/main.bicep' = [
  for deploymentOperation in sortedDeploymentOperations: if (!empty(deploymentOperation) && !empty(deploymentSettings)) {
    name: 'deploymentSettings-${deploymentOperation}'
    params: {
      cloudId: useSharedKeyVault ? cloudId : null
      clusterName: clusterName
      deploymentMode: deploymentOperation
      clusterNodeNames: deploymentSettings!.clusterNodeNames
      clusterWitnessStorageAccountName: deploymentSettings!.clusterWitnessStorageAccountName
      customLocationName: deploymentSettings!.customLocationName
      defaultGateway: deploymentSettings!.defaultGateway
      deploymentPrefix: deploymentSettings!.deploymentPrefix
      dnsServers: deploymentSettings!.dnsServers
      domainFqdn: deploymentSettings!.domainFqdn
      domainOUPath: deploymentSettings!.domainOUPath
      endingIPAddress: deploymentSettings!.endingIPAddress
      keyVaultName: deploymentSettings!.keyVaultName
      networkIntents: [
        for intent in deploymentSettings.networkIntents: {
          ...intent
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: intent.qosPolicyOverrides.bandwidthPercentageSMB
            priorityValue8021Action_Cluster: intent.qosPolicyOverrides.priorityValue8021ActionCluster
            priorityValue8021Action_SMB: intent.qosPolicyOverrides.priorityValue8021ActionSMB
          }
        }
      ]
      startingIPAddress: deploymentSettings!.startingIPAddress
      storageConnectivitySwitchless: deploymentSettings!.storageConnectivitySwitchless
      storageNetworks: deploymentSettings!.storageNetworks
      subnetMask: deploymentSettings!.subnetMask
      bitlockerBootVolume: deploymentSettings!.?bitlockerBootVolume
      bitlockerDataVolumes: deploymentSettings!.?bitlockerDataVolumes
      credentialGuardEnforced: deploymentSettings!.?credentialGuardEnforced
      driftControlEnforced: deploymentSettings!.?driftControlEnforced
      drtmProtection: deploymentSettings!.?drtmProtection
      enableStorageAutoIp: deploymentSettings!.?enableStorageAutoIp
      episodicDataUpload: deploymentSettings!.?episodicDataUpload
      hvciProtection: deploymentSettings!.?hvciProtection
      isEuropeanUnionLocation: deploymentSettings!.?isEuropeanUnionLocation
      sideChannelMitigationEnforced: deploymentSettings!.?sideChannelMitigationEnforced
      smbClusterEncryption: deploymentSettings!.?smbClusterEncryption
      smbSigningEnforced: deploymentSettings!.?smbSigningEnforced
      storageConfigurationMode: deploymentSettings!.?storageConfigurationMode
      streamingDataClient: deploymentSettings!.?streamingDataClient
      wdacEnforced: deploymentSettings!.?wdacEnforced
      hciResourceProviderObjectId: hciResourceProviderObjectId
    }
  }
]
