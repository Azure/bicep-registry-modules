targetScope = 'subscription'
metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-workspace-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dvwsmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = 'tx' //'#_namePrefix_#'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: location
    managedIdentityName: 'dvwsmax-managedidentity'
  }
}

module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: substring('dep${uniqueString(deployment().name, location)}${serviceShort}03', 0, 24)
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
    location: location
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: location
    applicationGroupReferences: []
    friendlyName: 'AVD Workspace'
    publicNetworkAccess: 'Disabled'
    diagnosticSettings: [
      {
        name: 'customSetting'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
        eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
        workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    privateEndpoints: [
      {
        service: 'feed'
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        ipConfigurations: [
          {
            name: 'myIPconfig-feed1'
            properties: {
              groupId: 'feed'
              memberName: 'web-r0'
              privateIPAddress: '10.0.0.10'
            }
          }
          {
            name: 'myIPconfig-feed2'
            properties: {
              groupId: 'feed'
              memberName: 'web-r1'
              privateIPAddress: '10.0.0.13'
            }
          }
        ]
        customDnsConfigs: [
          {
            fqdn: 'abc.workspace.com'
            ipAddresses: [
              '10.0.0.10'
              '10.0.0.13'
            ]
          }
        ]
      }
      {
        service: 'global'
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        ipConfigurations: [
          {
            name: 'myIPconfig-global'
            properties: {
              groupId: 'global'
              memberName: 'web'
              privateIPAddress: '10.0.0.11'
            }
          }
        ]
        customDnsConfigs: [
          {
            fqdn: 'abc.workspace.com'
            ipAddresses: [
              '10.0.0.11'
            ]
          }
        ]
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}]
