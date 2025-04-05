targetScope = 'resourceGroup'

param location string
param tags object
param resourcesNames object
param userAssignedIdentityResourceId string
param applicationGatewayPrimaryBackendEndFqdn string = ''
param applicationGatewayPublicIpResourceId string
param firewallPolicyResourceId string
param applicationGatewaySubnetId string
param appGatewayBackendHealthProbePath string = '/'
param keyVaultCertUri string

resource applicationGateway 'Microsoft.Network/applicationGateways@2024-05-01' = {
  name: resourcesNames.applicationGateway
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityResourceId}': {}
    }
  }
  properties: {
    backendAddressPools: [
      {
        name: 'acaServiceBackend'
        properties: {
          backendAddresses: (!empty(applicationGatewayPrimaryBackendEndFqdn))
            ? [
                {
                  fqdn: applicationGatewayPrimaryBackendEndFqdn
                }
              ]
            : null
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'https'
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          requestTimeout: 20
          probe: (!empty(applicationGatewayPrimaryBackendEndFqdn))
            ? {
                id: resourceId(
                  'Microsoft.Network/applicationGateways/probes',
                  resourcesNames.applicationGateway,
                  'webProbe'
                )
              }
            : null
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: applicationGatewayPublicIpResourceId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_443'
        properties: {
          port: 443
        }
      }
    ]
    enableHttp2: true
    firewallPolicy: {
      id: firewallPolicyResourceId
    }
    sslPolicy: {
      minProtocolVersion: 'TLSv1_2'
      policyType: 'Custom'
      cipherSuites: [
        'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
        'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
      ]
    }
    forceFirewallPolicyAssociation: true
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: applicationGatewaySubnetId
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'httpsListener'
        properties: {
          frontendIPConfiguration: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', resourcesNames.applicationGateway)}/frontendIPConfigurations/appGwPublicFrontendIp'
          }
          frontendPort: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', resourcesNames.applicationGateway)}/frontendPorts/port_443'
          }
          protocol: 'Https'
          sslCertificate: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', resourcesNames.applicationGateway)}/sslCertificates/${resourcesNames.workloadCertificate}'
          }
          hostNames: []
          requireServerNameIndication: false
        }
      }
    ]
    probes: (!empty(applicationGatewayPrimaryBackendEndFqdn))
      ? [
          {
            name: 'webProbe'
            properties: {
              protocol: 'Https'
              host: applicationGatewayPrimaryBackendEndFqdn
              path: appGatewayBackendHealthProbePath
              interval: 30
              timeout: 30
              unhealthyThreshold: 3
              pickHostNameFromBackendHttpSettings: false
              minServers: 0
              match: {
                statusCodes: [
                  '200-499'
                ]
              }
            }
          }
        ]
      : []
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
      capacity: 3
    }
    requestRoutingRules: [
      {
        name: 'routingRules'
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', resourcesNames.applicationGateway)}/httpListeners/httpsListener'
          }
          backendAddressPool: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', resourcesNames.applicationGateway)}/backendAddressPools/acaServiceBackend'
          }
          backendHttpSettings: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', resourcesNames.applicationGateway)}/backendHttpSettingsCollection/https'
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: resourcesNames.workloadCertificate
        properties: {
          keyVaultSecretId: keyVaultCertUri
        }
      }
    ]
  }
  zones: [
    '1'
    '2'
    '3'
  ]
}

output applicationGatewayResourceId string = applicationGateway.id
