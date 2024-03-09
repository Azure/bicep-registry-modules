metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'managementGroup'

@description('Optional. The location to deploy resources to.')
param location string = 'uksouth'

@description('Optional. The subscription billing scope.')
param subscriptionBillingScope string

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'
//param namePrefix string = 'avmsb'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssamin'

module createSub '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    subscriptionAliasEnabled: true
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionAliasName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionDisplayName: 'sub-blzv-tests-${namePrefix}-${serviceShort}'
    subscriptionTags: {
      namePrefix: namePrefix
      serviceShort: serviceShort
    }
    subscriptionWorkload: 'Production'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    deploymentScriptResourceGroupName: 'rsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptManagedIdentityName: 'id-${location}-${namePrefix}-${serviceShort}'
    deploymentScriptName: 'ds-${location}${namePrefix}${serviceShort}'
    virtualNetworkEnabled: false
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        principalId: '7eca0dca-6701-46f1-b7b6-8b424dab50b3'
        definition: 'Reader'
        relativeScope: ''
      }
    ]
    deploymentScriptNetworkSecurityGroupName: 'nsg-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptVirtualNetworkName: 'vnet-${location}-ds-${namePrefix}-${serviceShort}'
    deploymentScriptStorageAccountName: 'stgds${namePrefix}${serviceShort}'
    deploymentScriptLocation: location
    virtualNetworkLocation: location
    resourceProviders: {
      'Microsoft.HybridCompute': [ 'ArcServerPrivateLinkPreview' ]
      'Microsoft.AVS': [ 'AzureServicesVm' ]
    }
  }
}

output createdSubId string = createSub.outputs.subscriptionId
