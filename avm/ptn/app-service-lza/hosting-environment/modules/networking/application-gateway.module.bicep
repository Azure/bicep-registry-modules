import {
  diagnosticSettingFullType
  lockType
  managedIdentityAllType
  roleAssignmentType
} from 'br/public:avm/utl/types/avm-common-types:0.7.0'

// NOTE: The resourceId() calls in this file are necessary for Application Gateway sub-resource
// self-references during creation, where symbolic names cannot be used.

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('Required. Name of the Application Gateway.')
param appGwName string

@description('Required. The resource ID of the subnet for the Application Gateway.')
param subnetResourceId string

@description('Required. The hostname of the web app backend.')
param backendHostName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags for all resources.')
param tags object = {}

@description('Optional. The SKU of the Application Gateway.')
@allowed([
  'Standard_v2'
  'WAF_v2'
])
param skuName string = 'WAF_v2'

@description('Optional. The capacity (instance count) of the Application Gateway.')
param capacity int = 2

@description('Optional. Minimum autoscale capacity. Set to -1 to disable autoscale.')
param autoscaleMinCapacity int = 2

@description('Optional. Maximum autoscale capacity. Set to -1 to disable autoscale.')
param autoscaleMaxCapacity int = 10

@description('Optional. The health probe path.')
param healthProbePath string = '/'

@description('Optional. Diagnostic Settings for the Application Gateway.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. The availability zones for the Application Gateway.')
param availabilityZones int[] = [1, 2, 3]

@description('Optional. Managed identities for the Application Gateway. Required for Key Vault-referenced SSL certificates.')
param managedIdentities managedIdentityAllType?

@description('Optional. SSL certificates for the Application Gateway. Required for HTTPS termination.')
param sslCertificates array?

@description('Optional. Trusted root certificates for end-to-end SSL with internal CA backends.')
param trustedRootCertificates array?

@description('Optional. The SSL policy type. Use "Custom" for custom cipher suites or "Predefined" for a named policy.')
@allowed(['Custom', 'CustomV2', 'Predefined'])
param sslPolicyType string?

@description('Optional. The predefined SSL policy name (e.g. "AppGwSslPolicy20220101S").')
param sslPolicyName string?

@description('Optional. The minimum TLS protocol version.')
@allowed(['TLSv1_2', 'TLSv1_3'])
param sslPolicyMinProtocolVersion string?

@description('Optional. SSL cipher suites for the Application Gateway when sslPolicyType is Custom.')
param sslPolicyCipherSuites string[] = []

@description('Optional. Specify the type of resource lock for the Application Gateway.')
param lock lockType?

@description('Optional. Role assignments for the Application Gateway.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Authentication certificates for backend auth.')
param authenticationCertificates array = []

@description('Optional. Custom error configurations for the Application Gateway.')
param customErrorConfigurations array = []

@description('Optional. Whether FIPS mode is enabled on the Application Gateway.')
param enableFips bool = false

@description('Optional. Whether HTTP/2 is enabled. Defaults to true.')
param enableHttp2 bool = true

@description('Optional. Whether request buffering is enabled.')
param enableRequestBuffering bool = false

@description('Optional. Whether response buffering is enabled.')
param enableResponseBuffering bool = false

@description('Optional. Load distribution policies for the Application Gateway.')
param loadDistributionPolicies array = []

@description('Optional. Private endpoints for the Application Gateway.')
param privateEndpoints array?

@description('Optional. Private link configurations for the Application Gateway.')
param privateLinkConfigurations array = []

@description('Optional. Redirect configurations for the Application Gateway.')
param redirectConfigurations array = []

@description('Optional. Rewrite rule sets for the Application Gateway.')
param rewriteRuleSets array = []

@description('Optional. SSL profiles for the Application Gateway.')
param sslProfiles array = []

@description('Optional. Trusted client certificates for mTLS.')
param trustedClientCertificates array = []

@description('Optional. URL path maps for path-based routing.')
param urlPathMaps array = []

@description('Optional. Backend settings collection (v2 configuration).')
param backendSettingsCollection array = []

@description('Optional. Listeners (v2 configuration).')
param listeners array = []

@description('Optional. Routing rules (v2 configuration).')
param routingRules array = []

@description('Optional. WAF policy mode. Only used when skuName is WAF_v2.')
@allowed([
  'Detection'
  'Prevention'
])
param wafMode string = 'Prevention'

// ======================== //
// Variables                //
// ======================== //

var appGwPublicIpName = 'pip-${appGwName}'
var backendPoolName = 'backendPool'
var backendHttpSettingsName = 'backendHttpSettings'
var frontendPortHttpName = 'frontendPort-http'
var frontendPortHttpsName = 'frontendPort-https'
var httpListenerName = 'httpListener'
var requestRoutingRuleName = 'routingRule'
var healthProbeName = 'healthProbe'
var frontendIpConfigName = 'appGwPublicFrontendIp'
var gatewayIpConfigName = 'appGwIpConfig'

var isWaf = skuName == 'WAF_v2'

// ============ //
// Dependencies //
// ============ //

module publicIp 'br/public:avm/res/network/public-ip-address:0.12.0' = {
  name: '${uniqueString(deployment().name, location)}-appgw-pip'
  params: {
    name: appGwPublicIpName
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    skuName: 'Standard'
    publicIPAllocationMethod: 'Static'
    availabilityZones: availabilityZones
  }
}

module wafPolicy 'br/public:avm/res/network/application-gateway-web-application-firewall-policy:0.3.0' = if (isWaf) {
  name: '${uniqueString(deployment().name, location)}-appgw-waf'
  params: {
    name: 'waf-${appGwName}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
        }
      ]
    }
    policySettings: {
      mode: wafMode
      state: 'Enabled'
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
    }
  }
}

module applicationGateway 'br/public:avm/res/network/application-gateway:0.9.0' = {
  name: '${uniqueString(deployment().name, location)}-appgw'
  params: {
    name: appGwName
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    sku: skuName
    capacity: capacity
    autoscaleMinCapacity: autoscaleMinCapacity
    autoscaleMaxCapacity: autoscaleMaxCapacity
    enableHttp2: enableHttp2
    enableFips: enableFips
    enableRequestBuffering: enableRequestBuffering
    enableResponseBuffering: enableResponseBuffering
    availabilityZones: availabilityZones
    diagnosticSettings: diagnosticSettings
    firewallPolicyResourceId: wafPolicy.?outputs.?resourceId
    lock: lock
    roleAssignments: roleAssignments
    managedIdentities: managedIdentities
    authenticationCertificates: authenticationCertificates
    customErrorConfigurations: customErrorConfigurations
    loadDistributionPolicies: loadDistributionPolicies
    privateEndpoints: privateEndpoints
    privateLinkConfigurations: privateLinkConfigurations
    redirectConfigurations: redirectConfigurations
    rewriteRuleSets: rewriteRuleSets
    sslProfiles: sslProfiles
    trustedClientCertificates: trustedClientCertificates
    urlPathMaps: urlPathMaps
    backendSettingsCollection: backendSettingsCollection
    listeners: listeners
    routingRules: routingRules
    sslCertificates: sslCertificates
    trustedRootCertificates: trustedRootCertificates
    sslPolicyType: sslPolicyType
    sslPolicyName: sslPolicyName ?? null
    sslPolicyMinProtocolVersion: sslPolicyMinProtocolVersion
    sslPolicyCipherSuites: !empty(sslPolicyCipherSuites) ? sslPolicyCipherSuites : null
    gatewayIPConfigurations: [
      {
        name: gatewayIpConfigName
        properties: {
          subnet: {
            id: subnetResourceId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIpConfigName
        properties: {
          publicIPAddress: {
            id: publicIp.outputs.resourceId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: frontendPortHttpName
        properties: {
          port: 80
        }
      }
      {
        name: frontendPortHttpsName
        properties: {
          port: 443
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
        properties: {
          backendAddresses: [
            {
              fqdn: backendHostName
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: backendHttpSettingsName
        properties: {
          port: 443
          protocol: 'Https'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          requestTimeout: 120
          probe: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/probes',
              appGwName,
              healthProbeName
            )
          }
        }
      }
    ]
    probes: [
      {
        name: healthProbeName
        properties: {
          protocol: 'Https'
          path: healthProbePath
          interval: 30
          timeout: 30
          unhealthyThreshold: 3
          pickHostNameFromBackendHttpSettings: true
          minServers: 0
          match: {
            statusCodes: [
              '200-399'
            ]
          }
        }
      }
    ]
    httpListeners: [
      {
        name: httpListenerName
        properties: {
          frontendIPConfiguration: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/frontendIPConfigurations',
              appGwName,
              frontendIpConfigName
            )
          }
          frontendPort: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/frontendPorts',
              appGwName,
              frontendPortHttpName
            )
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: requestRoutingRuleName
        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/httpListeners',
              appGwName,
              httpListenerName
            )
          }
          backendAddressPool: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/backendAddressPools',
              appGwName,
              backendPoolName
            )
          }
          backendHttpSettings: {
            id: resourceId(
              'Microsoft.Network/applicationGateways/backendHttpSettingsCollection',
              appGwName,
              backendHttpSettingsName
            )
          }
        }
      }
    ]
  }
}

// ======================== //
// Outputs                  //
// ======================== //

@description('The name of the Application Gateway.')
output appGwName string = applicationGateway.outputs.name

@description('The resource ID of the Application Gateway.')
output appGwResourceId string = applicationGateway.outputs.resourceId

@description('The public IP address of the Application Gateway.')
output appGwPublicIpAddress string = publicIp.outputs.ipAddress

@description('The resource group the Application Gateway was deployed into.')
output resourceGroupName string = resourceGroup().name
