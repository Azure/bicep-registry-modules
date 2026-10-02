param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Module deployment matrix' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleDeploymentMatrix.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionList.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')

        $subscriptions = @(
            @{ id = '11111111-1111-1111-1111-111111111111'; name = 'sub-avm-test-001' }
            @{ id = '22222222-2222-2222-2222-222222222222'; name = 'sub-avm-test-002' }
            @{ id = '33333333-3333-3333-3333-333333333333'; name = 'sub-avm-test-003' }
        )
        $subscriptionJson = ConvertTo-Json -InputObject $subscriptions -Compress

        function New-ScopeTemplate {
            param([string] $Scope = 'subscription', [object] $Resources = @())

            $schemas = @{
                resourcegroup   = 'deploymentTemplate.json'
                subscription    = 'subscriptionDeploymentTemplate.json'
                managementgroup = 'managementGroupDeploymentTemplate.json'
                tenant          = 'tenantDeploymentTemplate.json'
            }
            return @{
                '$schema' = "https://schema.management.azure.com/schemas/2019-08-01/$($schemas[$Scope])#"
                resources = $Resources
            }
        }
    }

    BeforeEach {
        $savedExitCode = $global:LASTEXITCODE
        $testFiles = @(0..7 | ForEach-Object {
                @{ path = "tests/e2e/case-$_/main.test.bicep"; name = "case-$_"; e2eIgnore = $false }
            })
        $matrixInput = @{
            ModulePath               = 'avm/res/example/module'
            TestFilePaths            = $testFiles
            TestSubscriptionIds      = $subscriptionJson
            RandomSeed               = 12345
            DisplaySubscriptionNames = $true
            RepoRoot                 = $TestDrive
        }
        $script:compiledTemplates = @{}
        foreach ($test in $testFiles) {
            $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $test.path)] = New-ScopeTemplate
        }
        Mock bicep {
            $global:LASTEXITCODE = 0
            ConvertTo-Json -InputObject $script:compiledTemplates[$args[1]] -Depth 40 -Compress
        }
        Mock Invoke-WebRequest { throw 'Unexpected network access.' }
        Mock Invoke-RestMethod { throw 'Unexpected network access.' }
    }

    AfterEach {
        $global:LASTEXITCODE = $savedExitCode
    }

    It 'Preselects the same seeded round-robin records and includes readable variable-backed names' {
        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)
        $shuffled = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)

        $matrix.Count | Should -Be $testFiles.Count
        foreach ($index in 0..7) {
            $selected = $shuffled[$index % $shuffled.Count]
            $matrix[$index].subscriptionIndex | Should -Be $selected.index
            $matrix[$index].subscriptionKey | Should -BeExactly $selected.key
            $matrix[$index].subscriptionName | Should -Be $selected.name
            $matrix[$index].path | Should -Be $testFiles[$index].path
            $matrix[$index].name | Should -Be $testFiles[$index].name
            $matrix[$index].concurrencyGroup | Should -Be "avm-deploy-avm/res/example/module-$($selected.key)"
        }
        @($matrix[0..2].concurrencyGroup | Sort-Object -Unique).Count | Should -Be 3
        $matrix[0].concurrencyGroup | Should -Be $matrix[3].concurrencyGroup
        Should -Invoke bicep -Times 8 -Exactly
    }

    It 'Produces secret-safe cross-job records for <configuration>' -ForEach @(
        @{ configuration = 'a secret-backed pool'; fallback = $false }
        @{ configuration = 'the legacy secret singleton'; fallback = $true }
    ) {
        $matrixInput.DisplaySubscriptionNames = $false
        if ($fallback) {
            $matrixInput.TestSubscriptionIds = ''
            $matrixInput.FallbackSubscriptionId = $subscriptions[0].id
        }

        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)
        $output = ConvertTo-Json -InputObject $matrix -Depth 10 -Compress
        foreach ($subscription in $subscriptions) {
            $output | Should -Not -Match ([regex]::Escape($subscription.id))
            $output | Should -Not -Match ([regex]::Escape($subscription.name))
        }
        foreach ($entry in $matrix) {
            $entry.subscriptionName | Should -Match '^Configured subscription \d+$'
            $entry.subscriptionKey | Should -Match '^[a-f0-9]{64}$'
        }
        if ($fallback) {
            @($matrix.subscriptionIndex | Sort-Object -Unique) | Should -Be @(0)
            @($matrix.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 1
        }
    }

    It 'Keeps subscription lock identities independent of pool order, shuffle, display names and configuration source' {
        $first = @(Get-ModuleDeploymentMatrix @matrixInput)
        $reordered = @($subscriptions[2], $subscriptions[0], $subscriptions[1])
        $matrixInput.TestSubscriptionIds = ConvertTo-Json -InputObject $reordered -Compress
        $matrixInput.RandomSeed = 17
        $matrixInput.DisplaySubscriptionNames = $false

        $second = @(Get-ModuleDeploymentMatrix @matrixInput)

        ($first.concurrencyGroup | Sort-Object -Unique) | Should -Be ($second.concurrencyGroup | Sort-Object -Unique)
        foreach ($entry in $second) {
            $entry.subscriptionKey | Should -Be (Get-TestSubscriptionList -FallbackSubscriptionId $reordered[$entry.subscriptionIndex].id).key
        }
    }

    It 'Retains singleton selection for every test index' {
        $matrixInput.TestSubscriptionIds = ConvertTo-Json -InputObject @($subscriptions[1]) -Compress
        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)

        @($matrix.subscriptionIndex | Sort-Object -Unique) | Should -Be @(0)
        @($matrix.subscriptionName | Sort-Object -Unique) | Should -Be @('sub-avm-test-002')
        @($matrix.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 1
    }

    It 'Shares the module lock for any root <scope> test' -ForEach @(
        @{ scope = 'managementgroup' }
        @{ scope = 'tenant' }
    ) {
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[2].path)] = New-ScopeTemplate -Scope $scope
        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)

        @($matrix.concurrencyGroup | Sort-Object -Unique) | Should -Be @('avm-deploy-avm/res/example/module-shared')
        @($matrix.subscriptionKey | Sort-Object -Unique).Count | Should -Be 3
    }

    It 'Finds nested <scope> deployments, including compiled registry modules and symbolic resources' -ForEach @(
        @{ scope = 'managementgroup' }
        @{ scope = 'tenant' }
    ) {
        $nested = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = (New-ScopeTemplate -Scope $scope) }
        }
        $outer = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = (New-ScopeTemplate -Scope resourcegroup -Resources @{ nested = $nested }) }
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[2].path)] =
            New-ScopeTemplate -Resources @{ compiledModule = $outer }

        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)

        @($matrix.concurrencyGroup | Sort-Object -Unique) | Should -Be @('avm-deploy-avm/res/example/module-shared')
    }

    It 'Keeps resource-group templates and nested resource-group deployments subscription-isolated' {
        $nested = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = (New-ScopeTemplate -Scope resourcegroup) }
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[0].path)] = New-ScopeTemplate -Scope resourcegroup
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[1].path)] = New-ScopeTemplate -Resources @($nested)

        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)

        @($matrix.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 3
        $matrix.concurrencyGroup | Should -Not -Contain 'avm-deploy-avm/res/example/module-shared'
    }

    It 'Conservatively shares locks when an external linked template cannot be inspected' {
        $linked = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ templateLink = @{ uri = 'https://example.invalid/template.json' } }
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[1].path)] = New-ScopeTemplate -Resources @($linked)

        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)

        @($matrix.concurrencyGroup | Sort-Object -Unique) | Should -Be @('avm-deploy-avm/res/example/module-shared')
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
    }

    It 'Preserves round-robin positions around ignored tests without acquiring their deployment locks' {
        $testFiles[1].e2eIgnore = $true
        $shuffled = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)

        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)

        $matrix[1].e2eIgnore | Should -BeTrue
        $matrix[1].subscriptionKey | Should -BeNullOrEmpty
        $matrix[1].concurrencyGroup | Should -Be 'avm-deploy-avm/res/example/module-ignored'
        $matrix[2].subscriptionKey | Should -Be $shuffled[2].key
        Should -Invoke bicep -Times 7 -Exactly
    }

    It 'Does not require subscriptions or compile templates when all deployment tests are ignored' {
        $testFiles | ForEach-Object { $_.e2eIgnore = $true }
        $matrixInput.TestSubscriptionIds = ''
        $matrix = @(Get-ModuleDeploymentMatrix @matrixInput)

        $matrix.Count | Should -Be 8
        @($matrix.subscriptionName | Sort-Object -Unique) | Should -Be @('Deployment disabled')
        Should -Invoke bicep -Times 0 -Exactly
    }

    It 'Returns an empty matrix without subscription access when there are no tests' {
        $matrixInput.TestFilePaths = @()
        $matrixInput.TestSubscriptionIds = ''
        @(Get-ModuleDeploymentMatrix @matrixInput).Count | Should -Be 0
        Should -Invoke bicep -Times 0 -Exactly
    }

    It 'Rejects malformed preferred subscription pools before compilation' -ForEach @(
        @{ pool = ' ' }
        @{ pool = '[invalid' }
        @{ pool = '[]' }
    ) {
        $matrixInput.TestSubscriptionIds = $pool
        $matrixInput.FallbackSubscriptionId = $subscriptions[0].id

        { Get-ModuleDeploymentMatrix @matrixInput } | Should -Throw
        Should -Invoke bicep -Times 0 -Exactly
    }

    It 'Fails without a matrix when scope discovery compilation fails' {
        Mock bicep {
            $global:LASTEXITCODE = 1
            '{"$schema":"https://schema.management.azure.com/schemas/2019-08-01/subscriptionDeploymentTemplate.json#"}'
        }

        { Get-ModuleDeploymentMatrix @matrixInput } | Should -Throw '*Failed to compile test template*'
    }

    It 'Rejects unknown nested schemas rather than assuming subscription isolation' {
        $nested = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = @{ '$schema' = 'https://example.invalid/unknown.json#' } }
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[0].path)] = New-ScopeTemplate -Resources @($nested)

        { Get-ModuleDeploymentMatrix @matrixInput } | Should -Throw '*non-supported ARM template schema*'
    }

    It 'Preserves file-based scope discovery while accepting compiled template content for <scope>' -ForEach @(
        @{ scope = 'resourcegroup' }
        @{ scope = 'subscription' }
        @{ scope = 'managementgroup' }
        @{ scope = 'tenant' }
    ) {
        $template = New-ScopeTemplate -Scope $scope
        $jsonPath = Join-Path $TestDrive 'scope.json'
        $bicepPath = Join-Path $TestDrive 'scope.bicep'
        ConvertTo-Json -InputObject $template -Depth 10 | Set-Content -Path $jsonPath
        "targetScope = '$scope'" | Set-Content -Path $bicepPath

        Get-ScopeOfTemplateFile -TemplateFileContent $template | Should -Be $scope
        Get-ScopeOfTemplateFile -TemplateFilePath $jsonPath | Should -Be $scope
        Get-ScopeOfTemplateFile -TemplateFilePath $bicepPath | Should -Be $scope
    }
}
