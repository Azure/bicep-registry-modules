param (
    [array] $moduleFolderPaths = @((Get-Item $PSScriptRoot).Parent.Parent.FullName),

    [string] $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities/pipelines/sharedScripts/helper/Build-ViaRPC.ps1')

    $modulePath = Join-Path ($moduleFolderPaths | Sort-Object | Select-Object -First 1) 'main.bicep'
    $compiled = Build-ViaRPC -BicepFilePath $modulePath -PassThru -ErrorAction Stop
    $template = $compiled[$modulePath] | ConvertFrom-Json -AsHashtable
    $fileService = $template.resources.storageAccount_fileServices.properties.template
    $shareDeployment = $fileService.resources.fileServices_shares
    $shareTemplate = $shareDeployment.properties.template

    # Evaluate the production expression with mock account metadata, rather than copying its logic into the test.
    $source = Get-Content (Join-Path (Split-Path $modulePath) 'file-service/main.bicep') -Raw
    $defaultDeclaration = [regex]::Match($source, '(?ms)^var defaultShareAccessTier = .*?(?=\r?\n\r?\n)').Value
    $defaultDeclaration | Should -Not -BeNullOrEmpty
    $tierExpression = [regex]::Match($source, '(?m)^      accessTier: (.+)').Groups[1].Value.Trim()
    $tierExpression | Should -Not -BeNullOrEmpty

    function Get-TestAccessTier {
        param ($kind, $sku, $explicitTier)

        $fixture = Join-Path $TestDrive 'access-tier.bicepparam'
        $tierProperty = $explicitTier ? "accessTier: '$explicitTier'" : ''
        Set-Content -Path $fixture -Value @"
using none
var storageAccount = {
  kind: '$kind'
  sku: { name: '$sku' }
}
var share = {
  name: 'profiles'
  $tierProperty
}
$defaultDeclaration
#disable-next-line BCP053
param accessTier = $tierExpression
"@
        $result = bicep build-params $fixture --stdout | ConvertFrom-Json -AsHashtable
        $LASTEXITCODE | Should -Be 0
        $parameters = $result.parametersJson | ConvertFrom-Json -AsHashtable
        $parameters.parameters.ContainsKey('accessTier') | Should -BeTrue
        return $parameters.parameters.accessTier.value
    }
}

Describe 'File share access tier defaults' {
    It 'defaults <kind> / <sku> to <expected>' -TestCases @(
        @{ kind = 'FileStorage'; sku = 'StandardV2_ZRS'; expected = $null }
        @{ kind = 'FileStorage'; sku = 'StandardV2_LRS'; expected = $null }
        @{ kind = 'FileStorage'; sku = 'StandardV2_GRS'; expected = $null }
        @{ kind = 'FileStorage'; sku = 'StandardV2_GZRS'; expected = $null }
        @{ kind = 'FileStorage'; sku = 'PremiumV2_LRS'; expected = $null }
        @{ kind = 'FileStorage'; sku = 'PremiumV2_ZRS'; expected = $null }
        @{ kind = 'FileStorage'; sku = 'Premium_LRS'; expected = 'Premium' }
        @{ kind = 'FileStorage'; sku = 'Premium_ZRS'; expected = 'Premium' }
        @{ kind = 'StorageV2'; sku = 'Standard_LRS'; expected = 'TransactionOptimized' }
        @{ kind = 'StorageV2'; sku = 'Standard_ZRS'; expected = 'TransactionOptimized' }
        @{ kind = 'Storage'; sku = 'Standard_GRS'; expected = 'TransactionOptimized' }
        @{ kind = 'BlobStorage'; sku = 'Standard_LRS'; expected = 'TransactionOptimized' }
        @{ kind = 'BlockBlobStorage'; sku = 'Premium_LRS'; expected = 'TransactionOptimized' }
    ) {
        param ($kind, $sku, $expected)

        Get-TestAccessTier -kind $kind -sku $sku | Should -BeExactly $expected
    }

    It 'preserves an explicit <tier> tier on <sku>' -TestCases @(
        @{ kind = 'StorageV2'; sku = 'Standard_LRS'; tier = 'Hot' }
        @{ kind = 'StorageV2'; sku = 'Standard_ZRS'; tier = 'Cool' }
        @{ kind = 'StorageV2'; sku = 'Standard_GRS'; tier = 'TransactionOptimized' }
        @{ kind = 'FileStorage'; sku = 'Premium_LRS'; tier = 'Premium' }
        @{ kind = 'FileStorage'; sku = 'StandardV2_ZRS'; tier = 'Hot' }
        @{ kind = 'FileStorage'; sku = 'PremiumV2_LRS'; tier = 'Premium' }
    ) {
        param ($kind, $sku, $tier)

        # Passing a tier through does not mean Azure supports that tier for the selected SKU.
        Get-TestAccessTier -kind $kind -sku $sku -explicitTier $tier | Should -BeExactly $tier
    }

    It 'passes caller tiers through before applying the default' {
        $shareDeployment.properties.parameters.accessTier.value | Should -BeLikeExactly "[[]coalesce(tryGet(*, 'accessTier'), *"
        $shareTemplate.parameters.accessTier.nullable | Should -BeTrue
        $shareTemplate.resources.fileShare.properties.accessTier | Should -BeExactly "[parameters('accessTier')]"
    }

    It 'covers StandardV2 ZRS and LRS shares without explicit tiers in the deployment example' {
        $fixture = Join-Path (Split-Path $modulePath) 'tests/e2e/standard-file-share/main.test.bicep'
        $compiledFixture = Build-ViaRPC -BicepFilePath $fixture -PassThru -ErrorAction Stop
        $fixtureTemplate = $compiledFixture[$fixture] | ConvertFrom-Json -AsHashtable
        $deployments = @($fixtureTemplate.resources.testDeployment, $fixtureTemplate.resources.testDeploymentLrs)

        $deployments.properties.parameters.skuName.value | Should -Be @('StandardV2_ZRS', 'StandardV2_LRS')
        foreach ($deployment in $deployments) {
            $deployment.properties.parameters.kind.value | Should -BeExactly 'FileStorage'
            $shares = $deployment.properties.parameters.fileServices.value.shares
            $shares.Count | Should -Be 1
            $shares[0].name | Should -BeExactly 'profiles'
            $shares[0].ContainsKey('accessTier') | Should -BeFalse
        }
        $deployments[0].properties.parameters.azureFilesIdentityBasedAuthentication.value.directoryServiceOptions | Should -BeExactly 'AADKERB'
    }
}
