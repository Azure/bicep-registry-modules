param location string = resourceGroup().location
param akvName string =  'akvtest${uniqueString(resourceGroup().id)}'

var kvRbacRoles = [
  //'b86a8fe4-44ce-4948-aee5-eccb2c155cd7' //secrets officer
  'a4417e6f-fecd-4de8-b567-7b0420556985' //certificate officer
  //'14b46e9e-c2b7-41b4-b07b-48a6ebf60603' //Crypto officer
]

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
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

//Test 1. Just a single certificate, no AppGw
// var certName = 'myapp'
// module akvCertSingle '../main.bicep' = {
//   name: 'akvCertSingle'
//   params: {
//     rbacRolesNeededOnKV: kvRbacRoles
//     rbacRolesNeededOnAppGw: []
//     akvName: akv.name
//     location: location
//     certNames: array(certName)
//     retention: 'PT1H'
//   }
// }

// //Test 2. Array of certificates, no AppGw
// var certNames = [
//   'myapp'
//   'myotherapp'
// ]
// module akvCertMultiple '../main.bicep' = {
//   name: 'akvCertMultiple'
//   params: {
//     rbacRolesNeededOnKV: kvRbacRoles
//     rbacRolesNeededOnAppGw: []
//     akvName: akv.name
//     location: location
//     certNames: certNames
//     retention: 'PT1H'
//   }
// }

/*
AppGw tests
*/

//Prerequisites
var agwName = 'agw-${uniqueString(resourceGroup().id)}'
var appgwResourceId = resourceId('Microsoft.Network/applicationGateways', '${agwName}')
var appgwSubnetAddress = '10.0.1.0/24'

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
          addressPrefix: appgwSubnetAddress
        }
      }
    ]
  }
}

resource agwId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'id-${agwName}'
  location: location
}

var keyVaultSecretsUserRole = resourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
resource kvAppGwSecretsUserRole 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  scope: akv
  name: '${guid(agw.id, agwId.id, akv.id, keyVaultSecretsUserRole)}'
  properties: {
    roleDefinitionId: keyVaultSecretsUserRole
    principalType: 'ServicePrincipal'
    principalId: agwId.properties.principalId
  }
}

resource agw 'Microsoft.Network/applicationGateways@2021-05-01' = {
  name: agwName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${agwId.id}': {}
    }
  }
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
    rbacRolesNeededOnKV: kvRbacRoles
    akvName: akv.name
    agwName: agw.name
    location: location
    certNames: array('appGwSingleSSL')
    agwCertType: 'ssl-cert'
    agwIdName: agwId.name
    managedIdentityName: 'id-justtesting1'
  }
}

// //Test 4. AppGw Multi FrontEnd Cert
// module AgwMultiAkvFeCert '../main.bicep' = {
//   name: 'AgwMultiAkvFeCert'
//   params: {
//     rbacRolesNeededOnKV: kvRbacRoles
//     akvName: akv.name
//     agwName: agw.name
//     location: location
//     certNames: certNames
//     agwCertType: 'ssl-cert'
//   }
// }
