param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Offline e2e resource name validation' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'Test-E2eResourceNames.ps1')
        Copy-Item -LiteralPath (Join-Path $repoRootPath 'utilities' 'e2e-template-assets' 'functions' 'unique-resource-name.bicep') -Destination $TestDrive

        function Test-NamingFixture {
            param([string] $Source)

            $bicepPath = Join-Path $TestDrive 'main.bicep'
            $templatePath = Join-Path $TestDrive 'main.json'
            $Source | Set-Content -LiteralPath $bicepPath
            $diagnostics = bicep build $bicepPath --no-restore --outfile $templatePath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            Test-E2eResourceNames -TemplateFilePath $templatePath
        }

        $storageSource = @'
import { uniqueResourceName } from './unique-resource-name.bicep'
param namePrefix string = 'fixture'
param serviceShort string = 'storage'
param timestamp string = utcNow('yyyyMMddHHmmss')
param randomPart string = take(newGuid(), 8)
param discardedRandomPart string = take('constant${newGuid()}', 8)
param literalFunction string = concat('newGuid()', 'utcNow()')
var storageName = __NAME__
resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
  tags: { timestamp: timestamp }
}
'@
    }

    It 'Detects <caseName>' -ForEach @(
        @{ caseName = 'a literal'; expression = "'fixedstorage'"; count = 1 }
        @{ caseName = 'fixed prefix parameters'; expression = "'`${namePrefix}`${serviceShort}'"; count = 1 }
        @{ caseName = 'a hash of a fixed seed'; expression = "'st`${uniqueString('fixed')}'"; count = 1 }
        @{ caseName = 'a truncated-away hash'; expression = "take('fixedstorage`${uniqueString(resourceGroup().id)}', 12)"; count = 1 }
        @{ caseName = 'a scope-aware shared name'; expression = "uniqueResourceName('fixture', resourceGroup().id, 24)"; count = 0 }
        @{ caseName = 'a scope-aware native hash'; expression = "'st`${uniqueString(resourceGroup().id)}'"; count = 0 }
        @{ caseName = 'a time-based name'; expression = "'st`${uniqueString(timestamp)}'"; count = 0 }
        @{ caseName = 'a formatted date prefix'; expression = "'st`${take(timestamp, 8)}'"; count = 0 }
        @{ caseName = 'a random parameter default'; expression = "'st`${randomPart}'"; count = 0 }
        @{ caseName = 'discarded randomness in a parameter default'; expression = "'st`${discardedRandomPart}'"; count = 1 }
        @{ caseName = 'literal function names in a parameter default'; expression = "'st`${uniqueString(literalFunction)}'"; count = 1 }
    ) {
        $result = Test-NamingFixture -Source $storageSource.Replace('__NAME__', $expression)
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be $count
    }

    It 'Checks nested deployments, parameter forwarding and resource loops' {
        @'
param names array
resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = [for name in names: {
  name: name
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
}]
'@ | Set-Content -LiteralPath (Join-Path $TestDrive 'nested.bicep')
        $result = Test-NamingFixture -Source @'
targetScope = 'subscription'
resource group 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'fixture'
  location: 'eastus'
}
module nested 'nested.bicep' = {
  name: 'nested'
  scope: group
  params: { names: [ 'fixedstorage', 'st${uniqueString(group.id)}' ] }
}
'@
        $result.CheckedNames | Should -Be 2
        $result.Violations.Count | Should -Be 1
        $result.Violations[0].Name | Should -Be 'fixedstorage'
    }

    It 'Checks tenant-wide role assignment GUIDs: <caseName>' -ForEach @(
        @{ caseName = 'literal'; expression = "'11111111-aaaa-bbbb-cccc-111111111111'"; count = 1 }
        @{ caseName = 'fixed seed'; expression = "guid('fixed')"; count = 1 }
        @{ caseName = 'resource scope'; expression = "guid(storage.id, 'fixed')"; count = 0 }
    ) {
        $source = $storageSource.Replace('__NAME__', "uniqueResourceName('fixture', resourceGroup().id, 24)")
        $source += @'

resource assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: storage
  name: __ROLE_NAME__
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
    principalId: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
    principalType: 'ServicePrincipal'
  }
}
'@.Replace('__ROLE_NAME__', $expression)
        $result = Test-NamingFixture -Source $source
        $result.CheckedNames | Should -Be 2
        $result.Violations.Count | Should -Be $count
    }

    It 'Checks global properties without treating account names as global' {
        $result = Test-NamingFixture -Source @'
resource account 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: 'fixed-account'
  location: resourceGroup().location
  kind: 'OpenAI'
  sku: { name: 'S0' }
  properties: { customSubDomainName: 'fixed-subdomain' }
}
'@
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be 1
        $result.Violations[0].Property | Should -Be 'properties.customSubDomainName'
    }

    It 'Compares only the global child name, not its unique parent' {
        $result = Test-NamingFixture -Source @'
resource endpoint 'Microsoft.Cdn/profiles/afdEndpoints@2025-04-15' = {
  name: 'profile-${uniqueString(resourceGroup().id)}/fixedendpoint'
  location: 'global'
  properties: { enabledState: 'Enabled' }
}
'@
        $result.Violations.Count | Should -Be 1
        $result.Violations[0].Name | Should -Be 'fixedendpoint'
    }

    It 'Ignores false conditions, existing references and locally scoped names' {
        $result = Test-NamingFixture -Source @'
resource skipped 'Microsoft.Storage/storageAccounts@2025-01-01' = if (false) {
  name: 'fixedstorage'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
}
resource existingStorage 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  name: 'existingstorage'
}
resource existingSecret 'Microsoft.KeyVault/vaults/secrets@2024-11-01' existing = {
  name: 'existingvault/secret'
}
resource network 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: 'fixed-network'
  location: resourceGroup().location
  properties: { addressSpace: { addressPrefixes: ['10.0.0.0/16'] } }
}
output existingId string = existingStorage.id
'@
        $result.CheckedNames | Should -Be 0
        $result.Violations.Count | Should -Be 0
    }

    It 'Handles resource type casing' {
        $source = $storageSource.Replace('__NAME__', "'fixedstorage'").Replace('Microsoft.Storage/storageAccounts', 'microsoft.storage/storageaccounts')
        $result = Test-NamingFixture -Source $source
        $result.Violations.Count | Should -Be 1
    }

    It 'Respects Azure-generated DNS scopes: <scope>' -ForEach @(
        @{ scope = 'TenantReuse'; count = 1 }
        @{ scope = 'SubscriptionReuse'; count = 0 }
        @{ scope = 'ResourceGroupReuse'; count = 0 }
        @{ scope = 'NoReuse'; count = 0 }
    ) {
        $source = @'
resource ip 'Microsoft.Network/publicIPAddresses@2025-01-01' = {
  name: 'fixture'
  location: resourceGroup().location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'fixed-dns-label'
      domainNameLabelScope: '__SCOPE__'
    }
  }
}
'@.Replace('__SCOPE__', $scope)
        $result = Test-NamingFixture -Source $source
        $result.Violations.Count | Should -Be $count
    }

    It 'Checks resource names without resolving runtime secret payloads' {
        @'
param vaultName string
@secure()
param value string
resource vault 'Microsoft.KeyVault/vaults@2024-11-01' existing = { name: vaultName }
resource secret 'Microsoft.KeyVault/vaults/secrets@2024-11-01' = {
  parent: vault
  name: 'fixture'
  properties: { value: value }
}
'@ | Set-Content -LiteralPath (Join-Path $TestDrive 'secret.bicep')
        $result = Test-NamingFixture -Source @'
resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' existing = { name: 'existingstorage' }
resource vault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: 'fixedvault'
  location: resourceGroup().location
  properties: {
    tenantId: subscription().tenantId
    sku: { name: 'standard', family: 'A' }
  }
}
module secret 'secret.bicep' = {
  name: 'secret'
  params: { vaultName: vault.name, value: storage.listKeys().keys[0].value }
}
'@
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be 1
        $result.Violations[0].Name | Should -Be 'fixedvault'
    }

    It 'Checks both states of an unresolved RBAC reference: <condition>, nullable: <nullable>' -ForEach @(
        @{ condition = 'usesRbacAuthorization'; nullable = $false }
        @{ condition = '!usesRbacAuthorization'; nullable = $false }
        @{ condition = 'usesRbacAuthorization'; nullable = $true }
        @{ condition = '!usesRbacAuthorization'; nullable = $true }
    ) {
        @'
param usesRbacAuthorization bool = false
resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = if (__CONDITION__) {
  name: 'fixedstorage'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
}
'@.Replace('__CONDITION__', $condition) | Set-Content -LiteralPath (Join-Path $TestDrive 'rbac.bicep')
        $source = @'
resource vault 'Microsoft.KeyVault/vaults@2024-11-01' existing = { name: 'existingvault' }
module nested 'rbac.bicep' = {
  name: 'nested'
  params: { usesRbacAuthorization: vault.properties.enableRbacAuthorization! }
}
'@
        if ($nullable) {
            $source = $source.Replace('vault.properties.enableRbacAuthorization!', "true ? vault.properties.enableRbacAuthorization : true")
        }
        $result = Test-NamingFixture -Source $source
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be 1
    }

    It 'Uses constant external fixture IDs rather than making fixed names appear unique' {
        $result = Test-NamingFixture -Source @'
@secure()
param managedHSMResourceId string = ''
resource hsm 'Microsoft.KeyVault/managedHSMs@2024-11-01' existing = {
  scope: resourceGroup(split(managedHSMResourceId, '/')[2], split(managedHSMResourceId, '/')[4])
  name: last(split(managedHSMResourceId, '/'))
}
resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: 'st${uniqueString(hsm.id)}'
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
}
'@
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be 1
    }

    It 'Preserves name inputs from untyped resource-derived metadata' {
        $source = $storageSource.Replace('__NAME__', "'st`${uniqueString(metadata!.label)}'")
        $source += "`nparam metadata resourceInput<'Microsoft.Logic/integrationAccounts/assemblies@2019-05-01'>.properties.metadata? = { label: 'fixed' }"
        $result = Test-NamingFixture -Source $source
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be 1
    }

    It 'Does not treat runtime script placeholders as a source of uniqueness' {
        @'
param name string
resource storage 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: name
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
}
'@ | Set-Content -LiteralPath (Join-Path $TestDrive 'runtime.bicep')
        $result = Test-NamingFixture -Source @'
resource script 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'fixture'
  location: resourceGroup().location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '12.0'
    retentionInterval: 'P1D'
    scriptContent: 'throw "This offline fixture must never be deployed."'
  }
}
module nested 'runtime.bicep' = {
  name: 'nested'
  params: { name: 'st${uniqueString(script.properties.outputs.secretUrl)}' }
}
'@
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be 1
    }

    It 'Does not mistake the same tenant-level target for two conflicting assignments' {
        $result = Test-NamingFixture -Source @'
targetScope = 'tenant'
resource assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: '11111111-aaaa-bbbb-cccc-111111111111'
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
    principalId: 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
    principalType: 'ServicePrincipal'
  }
}
'@
        $result.CheckedNames | Should -Be 1
        $result.Violations.Count | Should -Be 0
    }

    It 'Propagates invalid template errors' {
        $templatePath = Join-Path $TestDrive 'invalid.json'
        '{"resources": ' | Set-Content -LiteralPath $templatePath
        { Test-E2eResourceNames -TemplateFilePath $templatePath } | Should -Throw
    }

    It 'Reports compilation failures without silently skipping the remaining templates' {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'Invoke-E2eResourceNameValidation.ps1')
        $invalidPath = Join-Path $TestDrive 'invalid.test.bicep'
        $validPath = Join-Path $TestDrive 'valid.test.bicep'
        $reportPath = Join-Path $TestDrive 'batch-results.json'
        'invalid Bicep' | Set-Content -LiteralPath $invalidPath
        $storageSource.Replace('__NAME__', "uniqueResourceName('fixture', resourceGroup().id, 24)") | Set-Content -LiteralPath $validPath

        { Invoke-E2eResourceNameValidation -TestFilePath @($invalidPath, $validPath) -ReportPath $reportPath } | Should -Throw '*1 of 2*'
        $results = @(Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json)
        $results.Count | Should -Be 2
        ($results | Where-Object TestFilePath -EQ $invalidPath).Error | Should -Match 'Bicep compilation failed'
        $valid = $results | Where-Object TestFilePath -EQ $validPath
        $valid.Error | Should -BeNullOrEmpty
        $valid.CheckedNames | Should -Be 1
        $valid.Violations.Count | Should -Be 0
    }

    It 'Fails the batch when a compiled template contains a colliding name' {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'Invoke-E2eResourceNameValidation.ps1')
        $path = Join-Path $TestDrive 'collision.test.bicep'
        $reportPath = Join-Path $TestDrive 'collision-results.json'
        $storageSource.Replace('__NAME__', "'fixedstorage'") | Set-Content -LiteralPath $path
        { Invoke-E2eResourceNameValidation -TestFilePath $path -ReportPath $reportPath } | Should -Throw '*1 of 1*'
        $results = @(Get-Content -LiteralPath $reportPath -Raw | ConvertFrom-Json)
        $results[0].Violations[0].Name | Should -Be 'fixedstorage'
    }
}
