metadata name = 'Using only defaults.'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acalzamin'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

// ============== //
// Test Execution //
// ============== //

var certificateName = 'appgwcert'

module testEnvironment '../../modules/testenvrg.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-testenv-${serviceShort}'
  params: {
    certificateName: certificateName
    certificateSubjectName: 'acahello.demoapp.com'
  }
}

resource envKeyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  scope: resourceGroup(testEnvironment.outputs.resourceGroupName)
  name: testEnvironment.outputs.keyVaultName
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    workloadName: serviceShort
    tags: {
      environment: 'test'
    }
    location: resourceLocation
    vmSize: 'Standard_B1s'
    vmAdminUsername: 'vmadmin'
    vmAdminPassword: password
    vmLinuxSshAuthorizedKey: testEnvironment.outputs.sshKey
    vmAuthenticationType: 'sshPublicKey'
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
    applicationGatewayCertificateKeyName: certificateName
    base64Certificate: envKeyVault.getSecret(testEnvironment.outputs.certificateSecureUrl)
  }
}

output testDeploymentOutputs object = testDeployment.outputs
