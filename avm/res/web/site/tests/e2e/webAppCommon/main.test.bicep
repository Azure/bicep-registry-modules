targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-web.sites-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'wswa'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-[[namePrefix]]-vnet-${serviceShort}'
    managedIdentityName: 'dep-[[namePrefix]]-msi-${serviceShort}'
    serverFarmName: 'dep-[[namePrefix]]-sf-${serviceShort}'
    relayNamespaceName: 'dep-[[namePrefix]]-ns-${serviceShort}'
    hybridConnectionName: 'dep-[[namePrefix]]-hc-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../.shared/.templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    kind: 'app'
    serverFarmResourceId: nestedDependencies.outputs.serverFarmResourceId
    diagnosticSettings: [
      {
        name: 'customSetting'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
        eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
        workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      }
    ]
    httpsOnly: true
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    slots: [
      {
        name: 'slot1'
        diagnosticSettings: [
          {
            name: 'customSetting'
            eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
            eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
            storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
            workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
          }
        ]
        privateEndpoints: [
          {
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
            privateDnsZoneResourceIds: [

              nestedDependencies.outputs.privateDNSZoneResourceId

            ]
            tags: {
              'hidden-title': 'This is visible in the resource name'
              Environment: 'Non-Prod'
              Role: 'DeploymentValidation'
            }
          }
        ]
        basicPublishingCredentialsPolicies: [
          {
            name: 'ftp'
            allow: false
          }
          {
            name: 'scm'
            allow: false
          }
        ]
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        siteConfig: {
          alwaysOn: true
          metadata: [
            {
              name: 'CURRENT_STACK'
              value: 'dotnetcore'
            }
          ]
        }
        hybridConnectionRelays: [
          {
            resourceId: nestedDependencies.outputs.hybridConnectionResourceId
            sendKeyName: 'defaultSender'
          }
        ]
      }
      {
        name: 'slot2'
        basicPublishingCredentialsPolicies: [
          {
            name: 'ftp'
          }
          {
            name: 'scm'
          }
        ]
      }
    ]
    privateEndpoints: [
      {
        subnetResourceId: nestedDependencies.outputs.subnetResourceId
        privateDnsZoneResourceIds: [
          nestedDependencies.outputs.privateDNSZoneResourceId
        ]
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Owner'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
        principalId: nestedDependencies.outputs.managedIdentityPrincipalId
        principalType: 'ServicePrincipal'
      }
    ]
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    basicPublishingCredentialsPolicies: [
      {
        name: 'ftp'
        allow: false
      }
      {
        name: 'scm'
        allow: false
      }

    ]
    hybridConnectionRelays: [
      {
        resourceId: nestedDependencies.outputs.hybridConnectionResourceId
        sendKeyName: 'defaultSender'
      }
    ]
    scmSiteAlsoStopped: true
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
    publicNetworkAccess: 'Disabled'
  }
}]
