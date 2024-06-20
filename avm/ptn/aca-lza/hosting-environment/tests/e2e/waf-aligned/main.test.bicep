metadata name = 'Using all the available options in WAF aligned values.'
metadata description = 'This instance deploys the module with the all the available parameters in WAF aligned values.'

targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //

@description('The id of the subscription to create the Azure Container Apps deployment.')
param subscriptionId string

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'acalzawaf'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //
module hubdeployment 'deploy.hub.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-hub-${serviceShort}'
  scope: subscription(subscriptionId)
  params: {
    location: resourceLocation
    tags: {
      environment: 'test'
    }
    vnetAddressPrefixes: ['10.0.0.0/24']
    azureFirewallSubnetAddressPrefix: '10.0.0.64/26'
    azureFirewallSubnetManagementAddressPrefix: '10.0.0.128/26'
    gatewaySubnetAddressPrefix: '10.0.0.0/27'
    bastionSubnetAddressPrefix: '10.0.0.192/26'
    workloadName: 'aca-lza'
  }
}

// General resources
// =================

// ============== //
// Test Execution //
// ============== //
module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    subscriptionId: subscriptionId
    workloadName: namePrefix
    hubVirtualNetworkResourceId: hubdeployment.outputs.hubVNetId
    networkApplianceIpAddress: hubdeployment.outputs.networkApplianceIpAddress
    tags: {
      environment: 'test'
    }
    environment: 'dev'
    location: resourceLocation
    vmSize: 'Standard_B1s'
    vmAdminUsername: 'vmadmin'
    vmAdminPassword: 'P@ssw0rd1234!'
    vmLinuxSshAuthorizedKey: ''
    vmAuthenticationType: 'password'
    vmJumpboxOSType: 'linux'
    vmJumpBoxSubnetAddressPrefix: '10.1.2.32/27'
    spokeVNetAddressPrefixes: [
      '10.1.0.0/22'
    ]
    spokeInfraSubnetAddressPrefix: '10.1.0.0/23'
    spokePrivateEndpointsSubnetAddressPrefix: '10.1.2.0/27'
    spokeApplicationGatewaySubnetAddressPrefix: '10.1.3.0/24'
    enableApplicationInsights: true
    enableDaprInstrumentation: false
    applicationGatewayFqdn: 'acahello.demoapp.com'
    base64Certificate: loadFileAsBase64('acahello.demoapp.com.pfx')
    applicationGatewayCertificateKeyName: 'appgwcert'
    deployZoneRedundantResources: true
    deployAzurePolicies: true
    exposeContainerAppsWith: 'applicationGateway'
    deploySampleApplication: true
    enableDdosProtection: true
  }
}

output testDeploymentOutputs object = testDeployment.outputs
