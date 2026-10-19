targetScope = 'resourceGroup'

@description('Required. The name of the newly deployed container registry.')
param containerRegistryName string

@description('Required. The login server of the newly deployed container registry.')
param containerRegistryLoginServer string

@description('Required. The name of the newly deployed Key Vault.')
param keyVaultName string

@description('Required. The name of the deployment script storage account.')
param storageAccountName string

@description('Required. The deployment subnet resource ID with private registry and vault connectivity.')
param deploymentSubnetResourceId string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Enable deployment telemetry.')
param enableTelemetry bool = true

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: containerRegistryName
}

resource vault 'Microsoft.KeyVault/vaults@2026-02-01' existing = {
  name: keyVaultName
}

resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: storageAccountName
}

var signerName = '${uniqueString(resourceGroup().id)}-image-signer'
var signerResourceId = resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', signerName)

module signer 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = {
  name: 'image-signer-${uniqueString(resourceGroup().id)}'
  params: {
    name: signerName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

var registryRoles = [
  '577a9874-89fd-4f24-9dbd-b5034d0ad23a' // Container Registry Data Importer and Data Reader
  '8311e382-0749-4cb8-b61a-304f252e45ec' // AcrPush
  'c8d4ff99-41c3-41a8-9f60-21dfdad59608' // AcrQuarantineWriter
]

resource registryPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in registryRoles: {
    name: guid(registry.id, signerResourceId, role)
    scope: registry
    properties: {
      principalId: signer.outputs.principalId
      principalType: 'ServicePrincipal'
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role)
    }
  }
]

var vaultRoles = [
  'a4417e6f-fecd-4de8-b567-7b0420556985' // Key Vault Certificates Officer
  '12338af0-0e69-4776-bea7-57ae8d297424' // Key Vault Crypto User
]

resource vaultPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in vaultRoles: {
    name: guid(vault.id, signerResourceId, role)
    scope: vault
    properties: {
      principalId: signer.outputs.principalId
      principalType: 'ServicePrincipal'
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role)
    }
  }
]

resource storagePermission 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storage.id, signerResourceId, '69566ab7-960f-475b-8e7c-b3118f30c6bd')
  scope: storage
  properties: {
    principalId: signer.outputs.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '69566ab7-960f-475b-8e7c-b3118f30c6bd'
    )
  }
}

var runScript = '''
$ErrorActionPreference = 'Stop'
$directory = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $directory
$env:XDG_CONFIG_HOME = $directory
$env:DOCKER_CONFIG = Join-Path $directory 'docker'
try {
    $executable = Initialize-NotationTools -Directory $directory
    $DeploymentScriptOutputs = Publish-VerifiedContainerImage -Executable $executable -Directory $directory `
        -RegistryName $env:REGISTRY_NAME -ResourceGroupName $env:RESOURCE_GROUP_NAME `
        -LoginServer $env:REGISTRY_LOGIN_SERVER -VaultName $env:KEY_VAULT_NAME
} finally {
    [System.IO.Directory]::Delete($directory, $true)
}
'''

module verifiedImage 'br/public:avm/res/resources/deployment-script:0.5.2' = {
  name: 'verify-sample-image-${uniqueString(resourceGroup().id)}'
  dependsOn: [
    registryPermissions
    vaultPermissions
    storagePermission
  ]
  params: {
    name: 'verify-sample-image-${uniqueString(resourceGroup().id)}'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    kind: 'AzurePowerShell'
    azPowerShellVersion: '16.4'
    managedIdentities: {
      userAssignedResourceIds: [
        signer.outputs.resourceId
      ]
    }
    environmentVariables: [
      { name: 'AZURE_CLIENT_ID', value: signer.outputs.clientId }
      { name: 'REGISTRY_NAME', value: containerRegistryName }
      { name: 'REGISTRY_LOGIN_SERVER', value: containerRegistryLoginServer }
      { name: 'RESOURCE_GROUP_NAME', value: resourceGroup().name }
      { name: 'KEY_VAULT_NAME', value: keyVaultName }
    ]
    scriptContent: '${loadTextContent('../../scripts/Invoke-VerifiedContainerImage.ps1')}\n${runScript}'
    subnetResourceIds: [
      deploymentSubnetResourceId
    ]
    storageAccountResourceId: storage.id
    cleanupPreference: 'Always'
    timeout: 'PT30M'
  }
}

@description('The immutable image reference released only after strict Notation verification.')
output image string = verifiedImage.outputs.outputs.image

@description('The newly produced OCI signature digest.')
output signatureDigest string = verifiedImage.outputs.outputs.signatureDigest

@description('The public sample publisher certificate. Its private signing key remains in Key Vault.')
output certificateBase64 string = verifiedImage.outputs.outputs.certificateBase64

@description('The exact trusted X.509 publisher identity.')
output certificateSubject string = verifiedImage.outputs.outputs.certificateSubject

@description('Whether strict Notation verification succeeded.')
output strictVerification bool = verifiedImage.outputs.outputs.strictVerification

@description('The resource ID of the scoped image signing managed identity.')
output signerResourceId string = signer.outputs.resourceId

@description('The client ID of the scoped image signing managed identity.')
output signerClientId string = signer.outputs.clientId
