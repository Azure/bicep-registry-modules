targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------
@description('Required. The resource names definition')
param resourcesNames object

@description('The location where the resources will be created. This needs to be the same region as the spoke.')
param location string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Defines whether to enable telemetry for the modules deployment.')
param enableTelemetry bool

@description('The FQDN of the Application Gateawy. Must match the TLS certificate.')
param applicationGatewayFqdn string

@description('The existing subnet resource ID to use for Application Gateway.')
param applicationGatewaySubnetId string

@description('The FQDN of the primary backend endpoint.')
param applicationGatewayPrimaryBackendEndFqdn string

@description('The path to use for Application Gateway\'s backend health probe.')
param appGatewayBackendHealthProbePath string = '/'

@description('The base64 encoded certificate to use for Application Gateway certificate. If this is provided, the certificate will be added to the Key Vault.')
@secure()
param base64Certificate string = ''

@description('The name of the certificate key to use for Application Gateway certificate.')
param applicationGatewayCertificateKeyName string

@description('The resource ID of the exsiting Log Analytics workload for diagnostic settngs, or nothing if you don\'t need any.')
param applicationGatewayLogAnalyticsId string = ''

@description('The resource ID of the existing Key Vault which contains Application Gateway\'s cert.')
param keyVaultId string

@description('The name of the storage account where a deployment script will be stored.')
param storageAccountName string

@description('The subnet resource ID of the subnet where the deployment script is going to be deployed.')
param deploymentSubnetResourceId string

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

// TODO: Check if this is required if enableApplicationCertificate is false
@description('A user-assigned managed identity that enables Application Gateway to access Key Vault for its TLS certs.')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: take('appGwUserAssignedIdentity-Deployment-${uniqueString(resourcesNames.resourceGroup)}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: resourcesNames.applicationGatewayUserAssignedIdentity
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// => Key Vault User Assigned Identity, Secret & Role Assignement for certificate
// As of today, App Gateway does not supports  "System Managed Identity" for Key Vault
// https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#key-vault-secrets-user

// => Certificates (supports only 1 for now)

// @description('Adds the certificate into Azure Key Vault for consumption by Application Gateway.')
module appGatewayAddCertificates 'app-gateway-cert.bicep' = {
  name: take('appGatewayAddCertificates-Deployment-${uniqueString(resourcesNames.resourceGroup)}', 64)
  scope: resourceGroup(keyVaultSubscriptionId, keyVaultResourceGroupName)
  params: {
    location: location
    tags: tags
    keyVaultName: keyVaultName
    storageAccountName: storageAccountName
    deploymentSubnetResourceId: deploymentSubnetResourceId
    appGatewayCertificateData: base64Certificate
    appGatewayCertificateKeyName: applicationGatewayCertificateKeyName
    appGatewayUserAssignedIdentityPrincipalId: userAssignedIdentity.outputs.principalId
  }
}

module applicationGatewayPublicIp 'br/public:avm/res/network/public-ip-address:0.7.1' = {
  name: take('applicationGatewayPublicIp-Deployment-${uniqueString(resourcesNames.resourceGroup)}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    location: location
    name: resourcesNames.applicationGatewayPip
    tags: tags
    enableTelemetry: enableTelemetry
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
module applicationGateway 'br/public:avm/res/network/application-gateway:0.5.1' = {
  name: take('applicationGateway-Deployment-${uniqueString(resourcesNames.resourceGroup)}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    // Required parameters
    name: resourcesNames.applicationGateway
    enableTelemetry: enableTelemetry
    // Non-required parameters
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
    frontendPorts: [
      {
        name: 'port_443'
        properties: {
          port: 443
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
      : null
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
    sku: 'WAF_v2'
    sslCertificates: [
      {
        name: resourcesNames.workloadCertificate
        properties: {
          keyVaultSecretId: appGatewayAddCertificates.outputs.SecretUri
        }
      }
    ]
    tags: tags
    firewallPolicyResourceId: appGwWafPolicy.outputs.resourceId
    sslPolicyType: 'Predefined'
    sslPolicyName: 'AppGwSslPolicy20220101'
    zones: [
      '1'
      '2'
      '3'
    ]
  }
}

module appGwWafPolicy 'br/public:avm/res/network/application-gateway-web-application-firewall-policy:0.2.0' = {
  name: take('appGwWafPolicy-Deployment-${uniqueString(resourcesNames.resourceGroup)}', 64)
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    name: '${resourcesNames.applicationGateway}Policy001'
    location: location
    enableTelemetry: enableTelemetry
    policySettings: {
      fileUploadLimitInMb: 10
      state: 'Enabled'
      mode: 'Prevention'
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
          ruleGroupOverrides: []
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '0.1'
        }
      ]
    }
    tags: tags
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the Azure Application Gateway.')
output applicationGatewayResourceId string = applicationGateway.outputs.resourceId

@description('The FQDN of the Azure Application Gateway.')
output applicationGatewayFqdn string = applicationGatewayFqdn

@description('The public IP address of the Azure Application Gateway.')
output applicationGatewayPublicIp string = applicationGatewayPublicIp.outputs.ipAddress
