targetScope = 'subscription'

@description('Required. The resource group created by this fixture.')
param resourceGroupName string

@description('Required. The registry name in this fixture.')
param registryName string

@description('Required. The registry login server in this fixture.')
param registryLoginServer string

@description('Required. The vault name in this fixture.')
param vaultName string

@description('Required. The native sample signing and verification outputs.')
param sampleVerification object

@description('Optional. Resource location.')
param location string

var runTests = '''
$ErrorActionPreference = 'Stop'
$directory = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $directory
$env:XDG_CONFIG_HOME = $directory
$env:DOCKER_CONFIG = Join-Path $directory 'docker'
try {
    $executable = Initialize-NotationTools -Directory $directory
    $DeploymentScriptOutputs = Test-NotationImageVerification -Executable $executable -Directory $directory `
        -RegistryName $env:REGISTRY_NAME -ResourceGroupName $env:RESOURCE_GROUP_NAME `
        -LoginServer $env:REGISTRY_LOGIN_SERVER -VaultName $env:KEY_VAULT_NAME `
        -TrustedImage $env:TRUSTED_IMAGE -TrustedSignatureDigest $env:TRUSTED_SIGNATURE_DIGEST `
        -TrustedCertificate ([Convert]::FromBase64String($env:TRUSTED_CERTIFICATE)) -TrustedSubject $env:TRUSTED_SUBJECT
} finally {
    [System.IO.Directory]::Delete($directory, $true)
}
'''

module verification 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: 'test-signature-rejection-${uniqueString(subscription().id, resourceGroupName)}'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: 'test-signature-rejection-${uniqueString(subscription().id, resourceGroupName)}'
    location: location
    kind: 'AzurePowerShell'
    azPowerShellVersion: '16.2'
    managedIdentities: {
      userAssignedResourceIds: [
        sampleVerification.signerResourceId
      ]
    }
    environmentVariables: [
      { name: 'AZURE_CLIENT_ID', value: sampleVerification.signerClientId }
      { name: 'REGISTRY_NAME', value: registryName }
      { name: 'REGISTRY_LOGIN_SERVER', value: registryLoginServer }
      { name: 'RESOURCE_GROUP_NAME', value: resourceGroupName }
      { name: 'KEY_VAULT_NAME', value: vaultName }
      { name: 'TRUSTED_IMAGE', value: sampleVerification.image }
      { name: 'TRUSTED_SIGNATURE_DIGEST', value: sampleVerification.signatureDigest }
      { name: 'TRUSTED_CERTIFICATE', value: sampleVerification.certificateBase64 }
      { name: 'TRUSTED_SUBJECT', value: sampleVerification.certificateSubject }
    ]
    scriptContent: '${loadTextContent('../../../scripts/Invoke-VerifiedContainerImage.ps1')}\n${loadTextContent('Test-NotationImageVerification.ps1')}\n${runTests}'
    subnetResourceIds: [
      sampleVerification.deploymentSubnetResourceId
    ]
    storageAccountResourceId: resourceId(
      resourceGroupName,
      'Microsoft.Storage/storageAccounts',
      sampleVerification.storageAccountName
    )
    cleanupPreference: 'Always'
    timeout: 'PT30M'
  }
}

@description('Native strict verification success and three independently exercised rejection cases.')
output results object = verification.outputs.outputs
