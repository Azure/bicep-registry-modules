targetScope = 'managementGroup'

// ------------------
//    PARAMETERS
// ------------------
@description('The ID of the subscription to deploy the spoke resources to.')
param subscriptionId string

@description('The name of the resource group to deploy the spoke resources to.')
param spokeResourceGroupName string

@description('The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environment string

@description('The location where the resources will be created. This needs to be the same region as the spoke.')
param location string = deployment().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('The FQDN of the Application Gateawy. Must match the TLS certificate.')
param applicationGatewayFqdn string

@description('The existing subnet resource ID to use for Application Gateway.')
param applicationGatewaySubnetId string

@description('The FQDN of the primary backend endpoint.')
param applicationGatewayPrimaryBackendEndFqdn string

@description('The path to use for Application Gateway\'s backend health probe.')
param appGatewayBackendHealthProbePath string = '/'

@description('The base64 encoded certificate to use for Application Gateway certificate. If this is provided, the certificate will be added to the Key Vault.')
param base64Certificate string = ''

@description('The name of the certificate key to use for Application Gateway certificate.')
param applicationGatewayCertificateKeyName string

@description('The resource ID of the exsiting Log Analytics workload for diagnostic settngs, or nothing if you don\'t need any.')
param applicationGatewayLogAnalyticsId string = ''

@description('The resource ID of the existing Key Vault which contains Application Gateway\'s cert.')
param keyVaultId string

@description('Optional, default value is true. If true, any resources that support AZ will be deployed in all three AZ. However if the selected region is not supporting AZ, this parameter needs to be set to false.')
param deployZoneRedundantResources bool = true

@description('Optional. DDoS protection mode for the Public IP of the Application Gateway. See https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison#skus')
param enableDdosProtection bool = false

// ------------------
// VARIABLES
// ------------------

var keyVaultIdTokens = split(keyVaultId, '/')

@description('The subscription ID of the existing Key Vault.')
var keyVaultSubscriptionId = keyVaultIdTokens[2]

@description('The name of the resource group containing the existing Key Vault.')
var keyVaultResourceGroupName = keyVaultIdTokens[4]

@description('The name of the existing Key Vault.')
var keyVaultName = keyVaultIdTokens[8]

// ------------------
// RESOURCES
// ------------------

@description('User-configured naming rules')
module naming '../naming/naming.module.bicep' = {
  name: take('06-sharedNamingDeployment-${deployment().name}', 64)
  scope: resourceGroup(subscriptionId, spokeResourceGroupName)
  params: {
    uniqueId: uniqueString(spokeResourceGroupName)
    environment: environment
    workloadName: workloadName
    location: location
  }
}

// TODO: Check if this is required if enableApplicationCertificate is false
@description('A user-assigned managed identity that enables Application Gateway to access Key Vault for its TLS certs.')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.2.1' = {
  name: take('appGwUserAssignedIdentity-Deployment-${uniqueString(spokeResourceGroupName)}', 64)
  scope: resourceGroup(subscriptionId, spokeResourceGroupName)
  params: {
    name: naming.outputs.resourcesNames.applicationGatewayUserAssignedIdentity
    location: location
    tags: tags
  }
}

// => Key Vault User Assigned Identity, Secret & Role Assignement for certificate
// As of today, App Gateway does not supports  "System Managed Identity" for Key Vault
// https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#key-vault-secrets-user

// => Certificates (supports only 1 for now)

// @description('Adds the PFX file into Azure Key Vault for consumption by Application Gateway.')
module appGatewayAddCertificates 'app-gateway-cert.bicep' = if (!empty(base64Certificate)) {
  name: take('appGatewayAddCertificates-Deployment-${uniqueString(spokeResourceGroupName)}', 64)
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName)
  params: {
    keyVaultName: keyVaultName
    appGatewayCertificateData: base64Certificate
    appGatewayCertificateKeyName: applicationGatewayCertificateKeyName
    appGatewayUserAssignedIdentityPrincipalId: userAssignedIdentity.outputs.principalId
  }
}

module applicationGatewayPublicIp 'br/public:avm/res/network/public-ip-address:0.4.1' = {
  name: take('applicationGatewayPublicIp-Deployment-${uniqueString(spokeResourceGroupName)}', 64)
  scope: resourceGroup(subscriptionId, spokeResourceGroupName)
  params: {
    location: location
    name: naming.outputs.resourcesNames.applicationGatewayPip
    tags: tags
    skuName: 'Standard'
    publicIPAllocationMethod: 'Static'
    ddosSettings: enableDdosProtection
      ? {
          protectionMode: 'Enabled'
        }
      : null
    zones: (deployZoneRedundantResources)
      ? [
          1
          2
          3
        ]
      : []
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'publicIpDiagnosticSettings'
        workspaceResourceId: applicationGatewayLogAnalyticsId
      }
    ]
  }
}

@description('The Application Gateway.')
module applicationGateway 'br/public:avm/res/network/application-gateway:0.1.0' = {
  name: take('applicationGateway-Deployment-${uniqueString(spokeResourceGroupName)}', 64)
  scope: resourceGroup(subscriptionId, spokeResourceGroupName)
  params: {
    // Required parameters
    name: naming.outputs.resourcesNames.applicationGateway
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'acaServiceBackend'
        properties: {
          backendAddresses: [
            {
              fqdn: applicationGatewayPrimaryBackendEndFqdn
            }
          ]
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
          probe: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/probes',
              naming.outputs.resourcesNames.applicationGateway,
              'webProbe'
            )
          }
        }
      }
    ]
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        workspaceResourceId: applicationGatewayLogAnalyticsId
      }
    ]
    enableHttp2: true
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: applicationGatewayPublicIp.outputs.resourceId
          }
        }
      }
    ]
    frontendPorts: (!empty(base64Certificate))
      ? [
          {
            name: 'port_443'
            properties: {
              port: 443
            }
          }
          {
            name: 'port_80'
            properties: {
              port: 80
            }
          }
        ]
      : [
          {
            name: 'port_80'
            properties: {
              port: 80
            }
          }
        ]
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
    httpListeners: (empty(base64Certificate))
      ? [
          {
            name: 'httpListener'
            properties: {
              frontendIPConfiguration: {
                #disable-next-line use-resource-id-functions
                id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/frontendIPConfigurations/appGwPublicFrontendIp'
              }
              frontendPort: {
                #disable-next-line use-resource-id-functions
                id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/frontendPorts/port_80'
              }
              protocol: 'Http'
              hostnames: []
              requireServerNameIndication: false
            }
          }
        ]
      : [
          {
            name: 'httpsListener'
            properties: {
              frontendIPConfiguration: {
                #disable-next-line use-resource-id-functions
                id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/frontendIPConfigurations/appGwPublicFrontendIp'
              }
              frontendPort: {
                #disable-next-line use-resource-id-functions
                id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/frontendPorts/port_443'
              }
              protocol: 'Https'
              sslCertificate: {
                #disable-next-line use-resource-id-functions
                id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/sslCertificates/${applicationGatewayFqdn}'
              }
              hostnames: []
              requireServerNameIndication: false
            }
          }
        ]
    location: location
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    probes: [
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
    requestRoutingRules: [
      {
        name: 'routingRules'
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/httpListeners/httpListener'
          }
          backendAddressPool: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/backendAddressPools/acaServiceBackend'
          }
          backendHttpSettings: {
            #disable-next-line use-resource-id-functions
            id: '${resourceId('Microsoft.Network/applicationGateways', naming.outputs.resourcesNames.applicationGateway)}/backendHttpSettingsCollection/https'
          }
        }
      }
    ]
    sku: 'WAF_v2'
    sslCertificates: (!empty(base64Certificate))
      ? [
          {
            name: applicationGatewayFqdn
            properties: {
              keyVaultSecretId: appGatewayAddCertificates.outputs.SecretUri
            }
          }
        ]
      : []
    tags: tags
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Prevention'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
      disabledRuleGroups: []
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
    }
    sslPolicyType: 'Predefined'
    sslPolicyName: 'AppGwSslPolicy20220101'
    zones: [
      '1'
      '2'
      '3'
    ]
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The FQDN of the Azure Application Gateway.')
output applicationGatewayFqdn string = applicationGatewayFqdn

@description('The public IP address of the Azure Application Gateway.')
output applicationGatewayPublicIp string = applicationGatewayPublicIp.outputs.ipAddress
