targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-network.applicationgateway-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nagmin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    publicIPName: 'dep-${namePrefix}-pip-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      // You parameters go here
      name: '${namePrefix}${serviceShort}001'
      zones: [
        '1'
        '2'
        '3'
      ]
      location: resourceLocation
      gatewayIPConfigurations: [
        {
          name: 'publicIPConfig1'
          publicIPAddressId: nestedDependencies.outputs.publicIPResourceId
          subnetId: nestedDependencies.outputs.defaultSubnetResourceId
        }
      ]
      frontendIPConfigurations: [
        {
          name: 'frontendIPConfig1'
          privateIPAddress: nestedDependencies.outputs.publicIPResourceId
        }
      ]
      frontendPorts: [
        {
          name: 'frontendPort1'
          port: 80
        }
      ]
      backendAddressPools: [
        {
          name: 'backendAddressPool1'
          backendAddresses: [
            {
              fqdn: 'www.contoso.com'
            }
          ]
        }
      ]
      httpListeners: [
        {
          name: 'httpListener1'
          frontendIPConfigurationId: nestedDependencies.outputs.publicIPResourceId
          frontendPortId: nestedDependencies.outputs.publicIPResourceId
          protocol: 'Http'
        }
      ]
      requestRoutingRules: [
        {
          name: 'requestRoutingRule1'
          ruleType: 'Basic'
          httpListenerId: nestedDependencies.outputs.publicIPResourceId
          backendAddressPoolId: nestedDependencies.outputs.publicIPResourceId
          backendHttpSettingsId: nestedDependencies.outputs.publicIPResourceId
        }
      ]
      probes: [
        {
          name: 'probe1'
          protocol: 'Http'
          host: 'www.contoso.com'
          path: '/health'
        }
      ]
      backendHttpSettingsCollection: [
        {
          name: 'backendHttpSettings1'
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 20
          probeId: nestedDependencies.outputs.publicIPResourceId
        }
      ]
      urlPathMaps: [
        {
          name: 'urlPathMap1'
          defaultBackendAddressPoolId: nestedDependencies.outputs.publicIPResourceId
          defaultBackendHttpSettingsId: nestedDependencies.outputs.publicIPResourceId
          defaultRedirectConfigurationId: nestedDependencies.outputs.publicIPResourceId
          defaultRewriteRuleSetId: nestedDependencies.outputs.publicIPResourceId
          defaultUrlRedirectConfigurationId: nestedDependencies.outputs.publicIPResourceId
          defaultUrlRewriteRuleSetId: nestedDependencies.outputs.publicIPResourceId
          pathRules: [
            {
              name: 'pathRule1'
              paths: [
                '/path1'
              ]
              backendAddressPoolId: nestedDependencies.outputs.publicIPResourceId
              backendHttpSettingsId: nestedDependencies.outputs.publicIPResourceId
              redirectConfigurationId: nestedDependencies.outputs.publicIPResourceId
              rewriteRuleSetId: nestedDependencies.outputs.publicIPResourceId
              urlRedirectConfigurationId: nestedDependencies.outputs.publicIPResourceId
              urlRewriteRuleSetId: nestedDependencies.outputs.publicIPResourceId
            }
          ]
        }
      ]
      sslCertificates: [
        {
          name: 'sslCertificate1'
          data: 'base64-encoded-certificate'
          password: 'password'
        }
      ]
      redirectConfigurations: [
        {
          name: 'redirectConfiguration1'
          redirectType: 'Permanent'
          targetUrl: 'https://www.contoso.com'
        }
      ]
      rewriteRuleSets: [
        {
          name: 'rewriteRuleSet1'
          rules: [
            {
              name: 'rewriteRule1'
              actionSet: [
                {
                  actionType: 'Redirect'
                  redirectConfigurationId: nestedDependencies.outputs.publicIPResourceId
                }
              ]
              conditions: [
                {
                  matchValue: 'www.contoso.com'
                  operator: 'Equals'
                  matchType: 'Host'
                }
              ]
            }
          ]
        }
      ]
    }
  }
]
