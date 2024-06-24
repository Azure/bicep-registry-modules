metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'managementGroup'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'acalzamin'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

// ================= //
// Variables Section //
// ================= //
//The id of the subscription to create the Azure Container Apps deployment.'
var subscriptionId = 'ff6a9a5a-6711-42ba-a06e-8fa7c84e9f06'

// ============ //
// Dependencies //
// ============ //

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
    tags: {
      environment: 'test'
    }
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
    applicationGatewayCertificateKeyName: 'appgwcert'
    deploySampleApplication: true
  }
}

output testDeploymentOutputs object = testDeployment.outputs
