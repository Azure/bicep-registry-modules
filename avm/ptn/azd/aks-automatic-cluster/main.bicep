metadata name = 'Azd AKS Automatic Cluster'
metadata description = '''Creates an Azure Kubernetes Service (AKS) cluster with a system agent pool.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case'''

@description('Required. The name for the AKS managed cluster.')
param name string

@description('Optional. The Azure region/location for the AKS resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { aadProfileType } from 'br/public:avm/res/container-service/managed-cluster:0.5.3'
@description('Optional. Settigs for the Azure Active Directory integration.')
param aadProfile aadProfileType?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-aksautomaticcluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module aks 'br/public:avm/res/container-service/managed-cluster:0.5.3' = {
  name: '${uniqueString(deployment().name, location)}-managed-cluster'
  params: {
    name: name
    location: location
    autoNodeOsUpgradeProfileUpgradeChannel: 'NodeImage'
    disableLocalAccounts: true
    enableKeyvaultSecretsProvider: true
    enableSecretRotation: true
    kedaAddon: true
    kubernetesVersion: '1.28'
    maintenanceConfigurations: [
      {
        name: 'aksManagedAutoUpgradeSchedule'
        maintenanceWindow: {
          schedule: {
            daily: null
            weekly: {
              intervalWeeks: 1
              dayOfWeek: 'Sunday'
            }
            absoluteMonthly: null
            relativeMonthly: null
          }
          durationHours: 4
          utcOffset: '+00:00'
          startDate: '2024-07-03'
          startTime: '00:00'
        }
      }
    ]
    managedIdentities: {
      systemAssigned: true
    }
    nodeProvisioningProfileMode: 'Auto'
    nodeResourceGroupProfile: {
      restrictionLevel: 'ReadOnly'
    }
    outboundType: 'managedNATGateway'
    primaryAgentPoolProfiles: [
      {
        name: 'systempool'
        count: 3
        vmSize: 'Standard_DS4_v2'
        mode: 'System'
      }
    ]
    publicNetworkAccess: 'Enabled'
    skuName: 'Automatic'
    vpaAddon: true
    webApplicationRoutingEnabled: true
    aadProfile: aadProfile
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the AKS cluster were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource name of the AKS cluster.')
output clusterName string = aks.name

@description('The AKS cluster identity.')
output clusterIdentity object = {
  clientId: aks.outputs.kubeletIdentityClientId
  objectId: aks.outputs.kubeletIdentityObjectId
  resourceId: aks.outputs.kubeletIdentityResourceId
}
