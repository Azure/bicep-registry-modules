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
        $selection = Get-ModuleDeploymentMatrix @matrixInput
        $matrix = $selection.testCases
        $shuffled = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)

        $selection.sharedScope | Should -BeFalse
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

        $matrix = (Get-ModuleDeploymentMatrix @matrixInput).testCases
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
        $first = (Get-ModuleDeploymentMatrix @matrixInput).testCases
        $reordered = @($subscriptions[2], $subscriptions[0], $subscriptions[1])
        $matrixInput.TestSubscriptionIds = ConvertTo-Json -InputObject $reordered -Compress
        $matrixInput.RandomSeed = 17
        $matrixInput.DisplaySubscriptionNames = $false

        $second = (Get-ModuleDeploymentMatrix @matrixInput).testCases

        ($first.concurrencyGroup | Sort-Object -Unique) | Should -Be ($second.concurrencyGroup | Sort-Object -Unique)
        foreach ($entry in $second) {
            $entry.subscriptionKey | Should -Be (Get-TestSubscriptionList -FallbackSubscriptionId $reordered[$entry.subscriptionIndex].id).key
        }
    }

    It 'Retains singleton selection for every test index' {
        $matrixInput.TestSubscriptionIds = ConvertTo-Json -InputObject @($subscriptions[1]) -Compress
        $matrix = (Get-ModuleDeploymentMatrix @matrixInput).testCases

        @($matrix.subscriptionIndex | Sort-Object -Unique) | Should -Be @(0)
        @($matrix.subscriptionName | Sort-Object -Unique) | Should -Be @('sub-avm-test-002')
        @($matrix.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 1
    }

    It 'Requests an additional shared lock without replacing subscription locks for a root <scope> test' -ForEach @(
        @{ scope = 'managementgroup' }
        @{ scope = 'tenant' }
    ) {
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[2].path)] = New-ScopeTemplate -Scope $scope
        $selection = Get-ModuleDeploymentMatrix @matrixInput
        $matrix = $selection.testCases

        $selection.sharedScope | Should -BeTrue
        @($matrix.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 3
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

        $selection = Get-ModuleDeploymentMatrix @matrixInput

        $selection.sharedScope | Should -BeTrue
        @($selection.testCases.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 3
    }

    It 'Keeps resource-group templates and nested resource-group deployments subscription-isolated' {
        $nested = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = (New-ScopeTemplate -Scope resourcegroup) }
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[0].path)] = New-ScopeTemplate -Scope resourcegroup
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[1].path)] = New-ScopeTemplate -Resources @($nested)

        $selection = Get-ModuleDeploymentMatrix @matrixInput
        $matrix = $selection.testCases

        $selection.sharedScope | Should -BeFalse
        @($matrix.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 3
        $matrix.concurrencyGroup | Should -Not -Contain 'avm-deploy-avm/res/example/module-shared'
    }

    It 'Requires an additional shared lock when an external linked template cannot be inspected' {
        $linked = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ templateLink = @{ uri = 'https://example.invalid/template.json' } }
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[1].path)] = New-ScopeTemplate -Resources @($linked)

        $selection = Get-ModuleDeploymentMatrix @matrixInput

        $selection.sharedScope | Should -BeTrue
        @($selection.testCases.concurrencyGroup | Sort-Object -Unique).Count | Should -Be 3
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
    }

    It 'Requires a shared lock for <expression> within a compiled module with <resourceFormat> resources' -ForEach @(
        @{ expression = '[variables(''$fxv#0'')]'; resourceFormat = 'array' }
        @{ expression = '[variables(''$fxv#0'')]'; resourceFormat = 'symbolic' }
        @{ expression = '[parameters(''nestedTemplate'')]'; resourceFormat = 'array' }
        @{ expression = '[parameters(''nestedTemplate'')]'; resourceFormat = 'symbolic' }
    ) {
        $nested = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = $expression }
        }
        $nestedResources = @($nested)
        if ($resourceFormat -eq 'symbolic') {
            $nestedResources = @{ nested = $nested }
        }
        $registryTemplate = New-ScopeTemplate -Scope resourcegroup -Resources $nestedResources
        $registryTemplate.variables = @{
            '$fxv#0' = (New-ScopeTemplate -Scope resourcegroup -Resources @(@{
                        type = 'Microsoft.Authorization/roleAssignments'
                        name = 'test-role-assignment'
                    }))
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[1].path)] =
            New-ScopeTemplate -Resources @{
                compiledModule = @{
                    type       = 'Microsoft.Resources/deployments'
                    properties = @{ template = $registryTemplate }
                }
            }

        $selection = Get-ModuleDeploymentMatrix @matrixInput
        $shuffled = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)

        $selection.sharedScope | Should -BeTrue
        $selection.testCases.Count | Should -Be $testFiles.Count
        foreach ($index in 0..7) {
            $subscription = $shuffled[$index % $shuffled.Count]
            $selection.testCases[$index].subscriptionKey | Should -BeExactly $subscription.key
            $selection.testCases[$index].concurrencyGroup | Should -BeExactly "avm-deploy-avm/res/example/module-$($subscription.key)"
        }
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
    }

    It 'Preserves invalid concrete schema errors when expression-based templates are also present' {
        $expressionTemplate = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = '[variables(''$fxv#0'')]' }
        }
        $invalidTemplate = @{
            type       = 'Microsoft.Resources/deployments'
            properties = @{ template = @{ '$schema' = 'https://example.invalid/unknown.json#' } }
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[0].path)] =
            New-ScopeTemplate -Resources @($expressionTemplate, $invalidTemplate)

        { Get-ModuleDeploymentMatrix @matrixInput } | Should -Throw '*non-supported ARM template schema*'
    }

    It 'Preserves round-robin positions around ignored tests without acquiring their deployment locks' {
        $testFiles[1].e2eIgnore = $true
        $shuffled = @(Get-TestSubscriptionList -TestSubscriptionIds $subscriptionJson -RandomSeed 12345)

        $matrix = (Get-ModuleDeploymentMatrix @matrixInput).testCases

        $matrix[1].e2eIgnore | Should -BeTrue
        $matrix[1].subscriptionKey | Should -BeNullOrEmpty
        $matrix[1].concurrencyGroup | Should -Be 'avm-deploy-avm/res/example/module-ignored'
        $matrix[2].subscriptionKey | Should -Be $shuffled[2].key
        Should -Invoke bicep -Times 7 -Exactly
    }

    It 'Does not require subscriptions or compile templates when all deployment tests are ignored' {
        $testFiles | ForEach-Object { $_.e2eIgnore = $true }
        $matrixInput.TestSubscriptionIds = ''
        $selection = Get-ModuleDeploymentMatrix @matrixInput
        $matrix = $selection.testCases

        $selection.sharedScope | Should -BeFalse
        $matrix.Count | Should -Be 8
        @($matrix.subscriptionName | Sort-Object -Unique) | Should -Be @('Deployment disabled')
        Should -Invoke bicep -Times 0 -Exactly
    }

    It 'Returns an empty matrix without subscription access when there are no tests' {
        $matrixInput.TestFilePaths = @()
        $matrixInput.TestSubscriptionIds = ''
        (Get-ModuleDeploymentMatrix @matrixInput).testCases.Count | Should -Be 0
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

    It 'Keeps identical inner keys across revisions that add, ignore or remove a <target> test' -ForEach @(
        @{ target = 'managementgroup' }
        @{ target = 'tenant' }
        @{ target = 'linked-template' }
    ) {
        $isolated = Get-ModuleDeploymentMatrix @matrixInput
        $keysBySubscription = @{}
        foreach ($entry in $isolated.testCases) {
            $keysBySubscription[$entry.subscriptionKey] = $entry.concurrencyGroup
        }
        $isolated.sharedScope | Should -BeFalse
        $keysBySubscription['bafde89c041e1756082b933aaf16cad8e65dec48de748479352f657e89dd6da5'] |
            Should -Be 'avm-deploy-avm/res/example/module-bafde89c041e1756082b933aaf16cad8e65dec48de748479352f657e89dd6da5'
        $sharedTemplate = if ($target -eq 'linked-template') {
            New-ScopeTemplate -Resources @(@{
                    type = 'Microsoft.Resources/deployments'
                    properties = @{ templateLink = @{ uri = 'https://example.invalid/template.json' } }
                })
        } else {
            New-ScopeTemplate -Scope $target
        }
        $script:compiledTemplates[(Join-Path $TestDrive $matrixInput.ModulePath $testFiles[2].path)] = $sharedTemplate
        $sharedRevision = Get-ModuleDeploymentMatrix @matrixInput
        $matrixInput.RandomSeed = 17
        $otherSharedRevision = Get-ModuleDeploymentMatrix @matrixInput
        $sharedRevision.sharedScope | Should -BeTrue
        $otherSharedRevision.sharedScope | Should -BeTrue

        $testFiles[2].e2eIgnore = $true
        $ignoredRevision = Get-ModuleDeploymentMatrix @matrixInput
        $ignoredRevision.sharedScope | Should -BeFalse
        $matrixInput.TestFilePaths = @($testFiles | Where-Object { $_.name -ne $testFiles[2].name })
        $removedRevision = Get-ModuleDeploymentMatrix @matrixInput
        $removedRevision.sharedScope | Should -BeFalse

        foreach ($revision in @($sharedRevision, $otherSharedRevision, $ignoredRevision, $removedRevision)) {
            foreach ($entry in ($revision.testCases | Where-Object { -not $_.e2eIgnore })) {
                $entry.concurrencyGroup | Should -BeExactly $keysBySubscription[$entry.subscriptionKey]
                $entry.concurrencyGroup | Should -Not -Be 'avm-deploy-avm/res/example/module-shared'
            }
        }
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
