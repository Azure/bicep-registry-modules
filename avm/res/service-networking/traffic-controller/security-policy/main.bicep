metadata name = 'Application Gateway for Containers Security Policy'
metadata description = 'This module deploys an Application Gateway for Containers Security Policy'

@description('Required. Name of the security policy to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent Application Gateway for Containers instance. Required if the template is used in a standalone deployment.')
param trafficControllerName string

@description('Required. The resource ID of the WAF Policy to associate with the security policy.')
param wafPolicyResourceId string

// ============== //
// Resources      //
// ============== //

resource trafficController 'Microsoft.ServiceNetworking/trafficControllers@2025-01-01' existing = {
  name: trafficControllerName
}

resource securityPolicy 'Microsoft.ServiceNetworking/trafficControllers/securityPolicies@2025-01-01' = {
  name: name
  parent: trafficController
  location: location
  properties: {
    wafPolicy: {
      id: wafPolicyResourceId
    }
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the security policy.')
output resourceId string = securityPolicy.id

@description('The name of the security policy.')
output name string = securityPolicy.name

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name
