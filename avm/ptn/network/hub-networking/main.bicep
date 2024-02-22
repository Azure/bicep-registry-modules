metadata name = 'Hub Networking'
metadata description = 'This module is designed to simplify the creation of multi-region hub networks in Azure. It will create a number of virtual networks and subnets, and optionally peer them together in a mesh topology with routing.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

//
// Add your parameters here
//

@description('Optional. Enable/Disable Bastion Host.')
param enableBastionHost bool = false

@description('Optional. A map of the hub virtual networks to create.')
param hub_virtual_networks object = {}

// ============== //
// Resources      //
// ============== //

module bastionHost 'br/public:avm/res/network/bastion-host:0.1.1' = if (enableBastionHost) {
  name: '${uniqueString(deployment().name, location)}-${name}-bastion'
  params: {
    // Required parameters
    name: name
    vNetId: '<vNetId>'
    // Non-required parameters
    bastionSubnetPublicIpResourceId: '<bastionSubnetPublicIpResourceId>'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableCopyPaste: true
    enableFileCopy: false
    enableIpConnect: false
    enableShareableLink: false
    location: '<location>'
    scaleUnits: 4
    skuName: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}

module hubVirtualNetwork 'br/public:avm/res/network/virtual-network:0.1.1' = [for hub in items(hub_virtual_networks): {
  name: '${uniqueString(deployment().name, location)}-${hub.value.name}'
  params: {
    // Required parameters
    name: hub.value.name
    addressPrefixes: hub.value.addressPrefixes
    // Non-required parameters
    ddosProtectionPlanResourceId: hub.value.ddosProtectionPlanId
    diagnosticSettings: hub.value.diagnosticSettings
    dnsServers: hub.value.dnsServers
    enableTelemetry: hub.value.enableTelemetry
    flowTimeoutInMinutes: hub.value.flowTimeoutInMinutes
    location: hub.value.location
    lock: hub.value.lock
    peerings: hub.value.peerings
    roleAssignments: hub.value.roleAssignments
    subnets: hub.value.subnets
    tags: hub.value.tags
    vnetEncryption: hub.value.vnetEncryption
    vnetEncryptionEnforcement: hub.value.vnetEncryptionEnforcement
  }

}]

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.network-hubspoke.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
