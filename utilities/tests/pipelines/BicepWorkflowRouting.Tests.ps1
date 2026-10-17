param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeDiscovery {
    $reservations = Get-Content -LiteralPath (Join-Path $RepoRootPath '.reserved-test-subscriptions.json') -Raw |
        ConvertFrom-Json -AsHashtable
    $reservedModules = @(
        foreach ($modulePath in ($reservations.Keys | Sort-Object)) {
            if ($reservations[$modulePath] -cne 'General') {
                @{ ModulePath = $modulePath }
            }
        }
    )
    if ($reservedModules.Count -eq 0) {
        throw 'No reserved module callers were discovered.'
    }
    $activationCases = @(
        foreach ($selection in @(
                @{ Name = 'empty'; Shared = $false; Local = $false }
                @{ Name = 'ordinary'; Shared = $true; Local = $false }
                @{ Name = 'reserved'; Shared = $false; Local = $true }
                @{ Name = 'mixed'; Shared = $true; Local = $true }
            )) {
            foreach ($event in @(
                    @{ Name = 'push'; EventName = 'push'; Internal = $true; PublishOnly = $false }
                    @{ Name = 'internal PR'; EventName = 'pull_request'; Internal = $true; PublishOnly = $false }
                    @{ Name = 'fork PR'; EventName = 'pull_request'; Internal = $false; PublishOnly = $false }
                    @{ Name = 'manual validation'; EventName = 'workflow_dispatch'; Internal = $true; PublishOnly = $false }
                    @{ Name = 'publish only'; EventName = 'workflow_dispatch'; Internal = $true; PublishOnly = $true }
                )) {
                @{
                    CaseName = "$($event.Name), $($selection.Name)"
                    EventName = $event.EventName
                    Internal = $event.Internal
                    PublishOnly = $event.PublishOnly
                    HasShared = $selection.Shared
                    HasLocal = $selection.Local
                }
            }
        }
    )
}

Describe 'Generic module matrix partition' {
    BeforeAll {
        $workflow = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'avm.module.yml') -Raw
        )
        $partition = $workflow.jobs.job_initialize_pipeline.steps | Where-Object id -EQ 'partition-module-matrix'
        $partitionScript = [scriptblock]::Create($partition.run)
        $environmentVariables = @('GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'MODULE_MATRIX')
        $reservationJson = Get-Content -LiteralPath (Join-Path $RepoRootPath '.reserved-test-subscriptions.json') -Raw
        $configuredRoots = @((ConvertFrom-Json $reservationJson -AsHashtable).Keys | Sort-Object)

        function New-TestMatrixEntry {
            param([string] $ModulePath)

            return [ordered]@{
                modulePath = $ModulePath
                moduleTestFilePaths = '[{"path":"tests/e2e/defaults/main.test.bicep","name":"defaults","e2eIgnore":false}]'
                psRuleModuleTestFilePaths = '[{"path":"tests/e2e/waf-aligned/main.test.bicep","name":"waf-aligned"}]'
            }
        }

        function Invoke-TestPartition {
            param([object[]] $Entries = @())

            $env:MODULE_MATRIX = ConvertTo-Json -InputObject @{ include = $Entries } -Depth 100 -Compress
            . $partitionScript
            $values = @{}
            foreach ($line in Get-Content -LiteralPath $env:GITHUB_OUTPUT) {
                $key, $value = $line.Split('=', 2)
                $values.Add($key, $value)
            }
            @($values.Keys | Sort-Object) | Should -Be @(
                'hasLocalModules', 'hasSharedModules', 'localModuleMatrix', 'sharedModuleMatrix'
            )
            return $values
        }

        function Test-RouteCondition {
            param(
                [string] $Condition, [string] $EventName, [bool] $Internal,
                [bool] $PublishOnly, [bool] $HasShared, [bool] $HasLocal
            )

            $expression = $Condition.Replace('${{', '').Replace('}}', '').
                Replace('github.event.pull_request.head.repo.full_name == github.repository', '$Internal').
                Replace('github.event.pull_request.head.repo.full_name != github.repository', '(-not $Internal)').
                Replace('github.event_name', '$EventName').
                Replace('inputs.publishOnly', '$PublishOnly').
                Replace("needs.job_initialize_pipeline.outputs.hasSharedModules == 'true'", '$HasShared').
                Replace("needs.job_initialize_pipeline.outputs.hasLocalModules == 'true'", '$HasLocal').
                Replace("needs.job_initialize_pipeline.outputs.hasModules == 'true'", '($HasShared -or $HasLocal)').
                Replace('&&', '-and').Replace('||', '-or').Replace('==', '-eq').Replace('!', '-not ')
            return [bool] (. ([scriptblock]::Create($expression)))
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($environmentVariable in $environmentVariables) {
            $savedEnvironment[$environmentVariable] = [Environment]::GetEnvironmentVariable($environmentVariable)
        }
        $fixtureRoot = Join-Path $TestDrive 'repository'
        $scripts = Join-Path $fixtureRoot 'utilities' 'pipelines' 'sharedScripts'
        $null = New-Item -Path $scripts -ItemType Directory -Force
        Copy-Item -LiteralPath (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionTag.ps1') -Destination $scripts
        $reservationPath = Join-Path $fixtureRoot '.reserved-test-subscriptions.json'
        Set-Content -LiteralPath $reservationPath -Value $reservationJson
        $env:GITHUB_WORKSPACE = $fixtureRoot
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'partition-output.txt'
        Set-Content -LiteralPath $env:GITHUB_OUTPUT -Value '' -NoNewline
    }

    AfterEach {
        foreach ($environmentVariable in $environmentVariables) {
            [Environment]::SetEnvironmentVariable($environmentVariable, $savedEnvironment[$environmentVariable])
        }
    }

    It 'keeps the shared initializer read-only and supplies only the selected matrix as step data' {
        $workflow.jobs.job_initialize_pipeline.permissions.Count | Should -Be 1
        $workflow.jobs.job_initialize_pipeline.permissions.contents | Should -Be 'read'
        @($partition.env.Keys) | Should -Be @('MODULE_MATRIX')
        $partition.env.MODULE_MATRIX | Should -Be '${{ steps.get-module-matrix.outputs.moduleMatrix }}'
        $partition.run | Should -Match 'Get-TestSubscriptionTag -ModulePath'
        $partition.run | Should -Not -Match 'VALIDATE_|AZURE_CREDENTIALS|Connect-Az|az login'
    }

    It 'preserves data, overrides, permissions and gates across the <Route> job pair' -ForEach @(
        @{ Route = 'preview'; File = 'avm.template.module.preview.yml' }
        @{ Route = 'publish'; File = 'avm.template.module.publish.yml' }
    ) {
        $shared = $workflow.jobs["call_module_$Route"]
        $local = $workflow.jobs["call_module_${Route}_local"]
        $local.uses | Should -Be "./.github/workflows/$File"
        $local.if | Should -Be ($shared.if.Replace('hasSharedModules', 'hasLocalModules'))
        $local.strategy.matrix | Should -Be ($shared.strategy.matrix.Replace('hasSharedModules', 'hasLocalModules').Replace('sharedModuleMatrix', 'localModuleMatrix'))
        $shared.if | Should -Not -Match '\bmatrix\.'
        $local.if | Should -Not -Match '\bmatrix\.'
        $shared.strategy.'fail-fast' | Should -BeFalse
        $local.strategy.'fail-fast' | Should -BeFalse
        $shared.ContainsKey('concurrency') | Should -BeFalse
        $local.ContainsKey('concurrency') | Should -BeFalse
        $local.needs | Should -Be $shared.needs
        $local.secrets | Should -Be 'inherit'
        ($local.permissions | ConvertTo-Json -Compress) | Should -Be ($shared.permissions | ConvertTo-Json -Compress)
        $sharedInputs = $shared.with | ConvertTo-Json -Depth 20 | ConvertFrom-Json -AsHashtable
        $sharedInputs.Remove('tools-ref')
        $sharedInputs.Remove('avm-authoring-version')
        @($local.with.Keys | Sort-Object) | Should -Be @($sharedInputs.Keys | Sort-Object)
        foreach ($inputKey in $sharedInputs.Keys) {
            $local.with[$inputKey] | Should -BeExactly $sharedInputs[$inputKey]
        }
    }

    It 'activates exactly the intended routes for <CaseName>' -ForEach $activationCases {
        $context = @{
            EventName = $EventName
            Internal = $Internal
            PublishOnly = $PublishOnly
            HasShared = $HasShared
            HasLocal = $HasLocal
        }
        $preview = $EventName -eq 'push' -or ($EventName -eq 'pull_request' -and $Internal)
        $manual = $EventName -eq 'workflow_dispatch' -and -not $PublishOnly
        Test-RouteCondition -Condition $workflow.jobs.call_module_preview.if @context | Should -Be ($preview -and $HasShared)
        Test-RouteCondition -Condition $workflow.jobs.call_module_preview_local.if @context | Should -Be ($preview -and $HasLocal)
        Test-RouteCondition -Condition $workflow.jobs.call_module_publish.if @context | Should -Be ($manual -and $HasShared)
        Test-RouteCondition -Condition $workflow.jobs.call_module_publish_local.if @context | Should -Be ($manual -and $HasLocal)
        Test-RouteCondition -Condition $workflow.jobs.call_module_fork_static.if @context |
            Should -Be ($EventName -eq 'pull_request' -and -not $Internal -and ($HasShared -or $HasLocal))
        Test-RouteCondition -Condition $workflow.jobs.call_module_publish_only.if @context |
            Should -Be ($EventName -eq 'workflow_dispatch' -and $PublishOnly -and ($HasShared -or $HasLocal))
    }

    It 'preserves an empty selection as two empty matrices rather than selecting all modules' {
        $result = Invoke-TestPartition

        $result.hasSharedModules | Should -BeExactly 'false'
        $result.hasLocalModules | Should -BeExactly 'false'
        $result.sharedModuleMatrix | Should -BeExactly '{"include":[]}'
        $result.localModuleMatrix | Should -BeExactly '{"include":[]}'
    }

    It 'partitions ordinary-only selections without altering their records or order' {
        $entries = @(
            New-TestMatrixEntry 'avm/res/network/route-table'
            New-TestMatrixEntry 'avm/res/storage/storage-account'
        )
        $result = Invoke-TestPartition -Entries $entries

        $result.hasSharedModules | Should -BeExactly 'true'
        $result.hasLocalModules | Should -BeExactly 'false'
        $result.localModuleMatrix | Should -BeExactly '{"include":[]}'
        $result.sharedModuleMatrix | Should -BeExactly (
            ConvertTo-Json -InputObject @{ include = $entries } -Depth 100 -Compress
        )
    }

    It 'retains reserved caller <ModulePath> exactly once in the local matrix' -ForEach $reservedModules {
        $entry = New-TestMatrixEntry $ModulePath
        $result = Invoke-TestPartition -Entries @($entry)

        $result.hasSharedModules | Should -BeExactly 'false'
        $result.hasLocalModules | Should -BeExactly 'true'
        $result.sharedModuleMatrix | Should -BeExactly '{"include":[]}'
        $result.localModuleMatrix | Should -BeExactly (
            ConvertTo-Json -InputObject @{ include = @($entry) } -Depth 100 -Compress
        )
    }

    It 'preserves all reserved selections without placing any in the shared matrix' {
        $entries = @($configuredRoots | ForEach-Object { New-TestMatrixEntry $_ })
        $result = Invoke-TestPartition -Entries $entries
        $local = ConvertFrom-Json $result.localModuleMatrix -AsHashtable

        $result.hasSharedModules | Should -BeExactly 'false'
        $result.hasLocalModules | Should -BeExactly 'true'
        $result.sharedModuleMatrix | Should -BeExactly '{"include":[]}'
        @($local.include.modulePath) | Should -Be $configuredRoots
    }

    It 'partitions a mixed selection exclusively and preserves every entry and test override' {
        $generalFirst = New-TestMatrixEntry 'avm/res/network/route-table'
        $generalLast = New-TestMatrixEntry 'avm/res/storage/storage-account'
        $reserved = @($configuredRoots | ForEach-Object { New-TestMatrixEntry $_ })
        $reserved[0].moduleTestFilePaths = '[{"path":"tests/e2e/custom/main.test.bicep","name":"custom","e2eIgnore":true}]'
        $reserved[0].psRuleModuleTestFilePaths = '[]'
        $result = Invoke-TestPartition -Entries (@($generalFirst) + $reserved + @($generalLast))
        $sharedMatrix = ConvertFrom-Json $result.sharedModuleMatrix -AsHashtable
        $localMatrix = ConvertFrom-Json $result.localModuleMatrix -AsHashtable

        $result.hasSharedModules | Should -BeExactly 'true'
        $result.hasLocalModules | Should -BeExactly 'true'
        $result.sharedModuleMatrix | Should -BeExactly (
            ConvertTo-Json -InputObject @{ include = @($generalFirst, $generalLast) } -Depth 100 -Compress
        )
        $result.localModuleMatrix | Should -BeExactly (
            ConvertTo-Json -InputObject @{ include = $reserved } -Depth 100 -Compress
        )
        @($sharedMatrix.include.modulePath | Where-Object { $_ -in $localMatrix.include.modulePath }).Count | Should -Be 0
        ($sharedMatrix.include.Count + $localMatrix.include.Count) | Should -Be ($reserved.Count + 2)
    }

    It 'uses exact paths at any root depth without inheriting a parent reservation' {
        $deepRoot = 'avm/ptn/platform/deep/solution'
        @{ $deepRoot = 'Azure Local' } | ConvertTo-Json | Set-Content -LiteralPath $reservationPath
        $entries = @(
            New-TestMatrixEntry "$deepRoot/child"
            New-TestMatrixEntry "$deepRoot-other"
            New-TestMatrixEntry $deepRoot
        )
        $result = Invoke-TestPartition -Entries $entries

        @((ConvertFrom-Json $result.sharedModuleMatrix -AsHashtable).include.modulePath) |
            Should -Be @("$deepRoot/child", "$deepRoot-other")
        @((ConvertFrom-Json $result.localModuleMatrix -AsHashtable).include.modulePath) |
            Should -Be @($deepRoot)
    }

    It 'treats reservation tags case-sensitively instead of borrowing the General route' {
        '{"avm/res/network/route-table":"general"}' | Set-Content -LiteralPath $reservationPath
        $result = Invoke-TestPartition -Entries @(New-TestMatrixEntry 'avm/res/network/route-table')

        $result.hasSharedModules | Should -BeExactly 'false'
        $result.hasLocalModules | Should -BeExactly 'true'
    }

    It 'rejects <Kind> before emitting any partition outputs' -ForEach @(
        @{ Kind = 'invalid JSON'; Json = '{' }
        @{ Kind = 'a null matrix'; Json = 'null' }
        @{ Kind = 'a root array'; Json = '[{"include":[]}]' }
        @{ Kind = 'missing include'; Json = '{}' }
        @{ Kind = 'a null include'; Json = '{"include":null}' }
        @{ Kind = 'an object include'; Json = '{"include":{"modulePath":"avm/res/network/route-table"}}' }
        @{ Kind = 'unhandled matrix axes'; Json = '{"include":[],"exclude":[]}' }
        @{ Kind = 'a null entry'; Json = '{"include":[null]}' }
        @{ Kind = 'a string entry'; Json = '{"include":["avm/res/network/route-table"]}' }
        @{ Kind = 'a missing module path'; Json = '{"include":[{}]}' }
        @{ Kind = 'a non-string module path'; Json = '{"include":[{"modulePath":7}]}' }
        @{ Kind = 'a noncanonical module path'; Json = '{"include":[{"modulePath":"avm/res/Network/route-table"}]}' }
        @{ Kind = 'a late invalid entry'; Json = '{"include":[{"modulePath":"avm/res/network/route-table"},{"modulePath":"../escape"}]}' }
    ) {
        $env:MODULE_MATRIX = $Json

        { . $partitionScript } | Should -Throw

        (Get-Item -LiteralPath $env:GITHUB_OUTPUT).Length | Should -Be 0
    }

    It 'fails closed on <Kind> reservations without silently selecting the shared route' -ForEach @(
        @{ Kind = 'missing'; Json = $null }
        @{ Kind = 'malformed'; Json = '{' }
        @{ Kind = 'an invalid unrelated tag'; Json = '{"avm/res/unrelated/module":true}' }
        @{ Kind = 'duplicate module keys'; Json = '{"avm/res/unrelated/module":"General","avm/res/unrelated/module":"Azure Local"}' }
    ) {
        if ($Kind -eq 'missing') {
            $fixture = Get-Item -LiteralPath $reservationPath -Force
            $fixture.PSIsContainer | Should -BeFalse
            if ($IsWindows) { $fixture.Attributes = $fixture.Attributes -bor [IO.FileAttributes]::Hidden }
            (Get-Item -LiteralPath $reservationPath -Force).Attributes.HasFlag([IO.FileAttributes]::Hidden) | Should -BeTrue
            Remove-Item -LiteralPath $reservationPath -Force
            Test-Path -LiteralPath $reservationPath | Should -BeFalse
        } else {
            Set-Content -LiteralPath $reservationPath -Value $Json
        }

        { Invoke-TestPartition -Entries @(New-TestMatrixEntry 'avm/res/network/route-table') } | Should -Throw

        (Get-Item -LiteralPath $env:GITHUB_OUTPUT).Length | Should -Be 0
    }
}
