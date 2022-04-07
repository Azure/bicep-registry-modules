param location string = resourceGroup().location
param akvName string =  'akvtest${uniqueString(resourceGroup().id)}'

var KeyvaultSecretsOfficerRoleDefinitionId='b86a8fe4-44ce-4948-aee5-eccb2c155cd7'

//Prerequisites
resource akv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: akvName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableSoftDelete: false
    accessPolicies: []
  }
}

//Test 1. Just a single certificate, no AppGw
var certName = 'myapp'
module akvCertSingle '../main.bicep' = {
  name: 'akvCertSingle'
  params: {
    rbacRolesNeeded: array(KeyvaultSecretsOfficerRoleDefinitionId)
    akvName: akv.name
    location: location
    certNames: array(certName)
  }
}

//Test 2. Array of certificates, no AppGw
var certNames = [
  'myapp'
  'myotherapp'
]
module akvCertMultiple '../main.bicep' = {
  name: 'akvCertMultiple'
  params: {
    rbacRolesNeeded: array(KeyvaultSecretsOfficerRoleDefinitionId)
    akvName: akv.name
    location: location
    certNames: certNames
  }
}

/*
AppGw tests
*/

//Prerequisites
var agwName = 'agw-${uniqueString(resourceGroup().id)}'
var appgwResourceId = resourceId('Microsoft.Network/applicationGateways', '${agwName}')

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vnet-${uniqueString(resourceGroup().id)}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'agw'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource agw 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: agwName
  location: location
  properties: {
      sku: {
        capacity: 1
        tier: 'Standard_v2'
        name: 'Standard_v2'
      }
      gatewayIPConfigurations: [
        {
          name: 'besubnet'
          properties: {
            subnet: {
              id: vnet.properties.subnets[0].id
            }
          }
        }
      ]
      frontendIPConfigurations: array({
        properties: {
          publicIPAddress: {
            id: '${appgwpip.id}'
          }
        }
        name: 'appGatewayFrontendIP'
      })
      frontendPorts: [
        {
          name: 'appGatewayFrontendPort'
          properties: {
            port: 80
          }
        }
      ]
      backendAddressPools: [
        {
          name: 'defaultaddresspool'
        }
      ]
      backendHttpSettingsCollection: [
        {
          name: 'defaulthttpsetting'
          properties: {
            port: 80
            protocol: 'Http'
            cookieBasedAffinity: 'Disabled'
            requestTimeout: 30
            pickHostNameFromBackendAddress: true
          }
        }
      ]
      httpListeners: [
        {
          name: 'hlisten'
          properties: {
            frontendIPConfiguration: {
              id: '${appgwResourceId}/frontendIPConfigurations/appGatewayFrontendIP'
            }
            frontendPort: {
              id: '${appgwResourceId}/frontendPorts/appGatewayFrontendPort'
            }
            protocol: 'Http'
          }
        }
      ]
      requestRoutingRules: [
        {
          name: 'appGwRoutingRuleName'
          properties: {
            ruleType: 'Basic'
            httpListener: {
              id: '${appgwResourceId}/httpListeners/hlisten'
            }
            backendAddressPool: {
              id: '${appgwResourceId}/backendAddressPools/defaultaddresspool'
            }
            backendHttpSettings: {
              id: '${appgwResourceId}/backendHttpSettingsCollection/defaulthttpsetting'
            }
          }
        }
      ]
  }
}

resource appgwpip 'Microsoft.Network/publicIPAddresses@2020-07-01' = {
  name: 'pip-${agwName}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

//Test 3. AppGw Single FrontEnd Cert
module AgwSingleAkvCert '../main.bicep' = {
  name: 'AgwSingleAkvCert'
  params: {
    rbacRolesNeeded: array(KeyvaultSecretsOfficerRoleDefinitionId)
    akvName: akv.name
    agwName: agw.name
    location: location
    certNames: array(certName)
    agwCertType: 'ssl-cert'
  }
}

//Test 4. AppGw Multi FrontEnd Cert
module AgwMultiAkvFeCert '../main.bicep' = {
  name: 'AgwMultiAkvFeCert'
  params: {
    rbacRolesNeeded: array(KeyvaultSecretsOfficerRoleDefinitionId)
    akvName: akv.name
    agwName: agw.name
    location: location
    certNames: certNames
    agwCertType: 'ssl-cert'
  }
}
