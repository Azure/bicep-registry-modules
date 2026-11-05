Describe 'Synapse Spark library fixture' {
    BeforeAll {
        $fixture = Join-Path $PSScriptRoot '..\e2e\bigdatapool\main.test.bicep'
        $compiledPath = Join-Path $TestDrive 'bigdatapool.json'
        $diagnostics = bicep build $fixture --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }

        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $deployments = @($template.resources | Where-Object {
                $_.properties.parameters -is [System.Collections.IDictionary] -and
                $_.properties.parameters.Contains('bigDataPools')
            })
        if ($deployments.Count -ne 1) { throw 'Expected one repeated workspace test deployment.' }
        $script:synapseDeployment = $deployments[0]
        $script:synapsePools = @($script:synapseDeployment.properties.parameters.bigDataPools.value)
    }

    It 'Explicitly selects the supported runtime for pool <index>' -ForEach @(
        @{ index = 0 }
        @{ index = 1 }
    ) {
        $script:synapsePools.Count | Should -Be 2
        $script:synapsePools[$index].sparkVersion | Should -BeExactly '3.5'
    }

    It 'Keeps the library installation and scaling scenario enabled' {
        $script:synapsePools[0].libraryRequirements.filename | Should -BeExactly 'requirements.txt'
        $script:synapsePools[0].libraryRequirements.content | Should -BeExactly "numpy==1.26.4`npandas==2.2.3"
        $script:synapsePools[0].sessionLevelPackagesEnabled | Should -BeTrue
        $script:synapsePools[0].autoScale.minNodeCount | Should -Be 3
        $script:synapsePools[0].autoScale.maxNodeCount | Should -Be 5
        $script:synapsePools[0].dynamicExecutorAllocation.minExecutors | Should -Be 1
        $script:synapsePools[0].dynamicExecutorAllocation.maxExecutors | Should -Be 4
    }

    It 'Keeps a separate pool without libraries' {
        $script:synapsePools[1].Contains('libraryRequirements') | Should -BeFalse
        $script:synapsePools[1].nodeSizeFamily | Should -BeExactly 'MemoryOptimized'
        $script:synapsePools[1].nodeSize | Should -BeExactly 'Small'
    }

    It 'Preserves sequential initial and repeat deployments' {
        $script:synapseDeployment.copy.mode | Should -BeExactly 'serial'
        $script:synapseDeployment.copy.batchSize | Should -Be 1
        $script:synapseDeployment.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
    }

    Context 'Workspace name' {
        BeforeAll {
            $source = Get-Content -LiteralPath $fixture -Raw
            $nameMatch = [regex]::Match($source, '(?s)module testDeployment.*?params:\s*\{\s*name:\s*(?<expression>[^\r\n]+)')
            if (-not $nameMatch.Success) { throw 'Missing Spark fixture workspace name expression.' }
            $script:sparkFixtureTemplate = $template
            $script:sparkNameScenarios = @(
                @{}
                @{ Subscription = '00000000-0000-4000-8000-000000000002' }
                @{ Group = 'fixture-two' }
                @{ Root = 'attempt-two' }
                @{ Location = 'norwayeast' }
                @{ Prefix = ('g' * 100); Service = ('s' * 100 + 'a') }
                @{ Prefix = ('g' * 100); Service = ('s' * 100 + 'b') }
                @{ Prefix = ('g' * 100 + 'b'); Service = ('s' * 100 + 'a') }
                @{ Prefix = ''; Service = '' }
                @{ Prefix = ('a' * 27) }
                @{ Prefix = ('a' * 28) }
                @{ Prefix = ('a' * 29) }
            )
            $parameterSource = @('using none')
            for ($index = 0; $index -lt $script:sparkNameScenarios.Count; $index++) {
                $scenario = $script:sparkNameScenarios[$index]
                $subscription = $scenario.Subscription ?? '00000000-0000-4000-8000-000000000001'
                $group = $scenario.Group ?? 'fixture-one'
                $root = $scenario.Root ?? 'attempt-one'
                $location = $scenario.Location ?? 'polandcentral'
                $prefix = $scenario.Prefix ?? 'gci'
                $service = $scenario.Service ?? $template.parameters.serviceShort.defaultValue
                foreach ($iteration in @('init', 'idem')) {
                    $expression = $nameMatch.Groups['expression'].Value.Trim().
                    Replace('resourceGroup.id', "'/subscriptions/$subscription/resourceGroups/$group'").
                    Replace('subscription().subscriptionId', "'$subscription'").
                    Replace('resourceGroupName', "'$group'").
                    Replace('deployment().name', "'$root'").
                    Replace('deployment().location', "'$location'").
                    Replace('resourceLocation', "'$location'").
                    Replace('enforcedLocation', "'$location'").
                    Replace('namePrefix', "'$prefix'").
                    Replace('serviceShort', "'$service'").
                    Replace('iteration', "'$iteration'")
                    $parameterSource += "param workspace${index}${iteration} = $expression"
                }
            }
            $parameterPath = Join-Path $TestDrive 'spark-workspace-names.bicepparam'
            $parameterOutput = Join-Path $TestDrive 'spark-workspace-names.json'
            $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $script:sparkWorkspaceNames = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        }

        It 'Separates otherwise identical workspaces in different subscriptions' {
            $script:sparkWorkspaceNames.workspace0init.value | Should -Not -Be $script:sparkWorkspaceNames.workspace1init.value
        }

        It 'Separates otherwise identical workspaces in different resource groups' {
            $script:sparkWorkspaceNames.workspace0init.value | Should -Not -Be $script:sparkWorkspaceNames.workspace2init.value
        }

        It 'Keeps the name stable across root attempts, regions and serial init/idem' {
            $script:sparkWorkspaceNames.workspace0init.value | Should -BeExactly $script:sparkWorkspaceNames.workspace3init.value
            $script:sparkWorkspaceNames.workspace0init.value | Should -BeExactly $script:sparkWorkspaceNames.workspace4init.value
            for ($index = 0; $index -lt $script:sparkNameScenarios.Count; $index++) {
                $script:sparkWorkspaceNames["workspace${index}init"].value |
                    Should -BeExactly $script:sparkWorkspaceNames["workspace${index}idem"].value
            }
        }

        It 'Meets the 1-50 character workspace naming rules' {
            foreach ($entry in $script:sparkWorkspaceNames.Values) {
                $entry.value | Should -Match '^[a-z0-9](?:[a-z0-9-]{0,48}[a-z0-9])?$'
                $entry.value | Should -Not -Match '-ondemand'
            }
        }

        It 'Keeps full prefix and service inputs distinct in the suffix after truncation' {
            $first = $script:sparkWorkspaceNames.workspace5init.value
            foreach ($index in @(6, 7)) {
                $other = $script:sparkWorkspaceNames["workspace${index}init"].value
                $first.Substring(0, 36) | Should -BeExactly $other.Substring(0, 36)
                $first.Substring($first.Length - 13) | Should -Not -Be $other.Substring($other.Length - 13)
            }
        }

        It 'Preserves the bounded base for <boundary>' -ForEach @(
            @{ boundary = 'empty prefix and service inputs'; index = 8; length = 17; visibleBase = '001' }
            @{ boundary = 'a 35-character base'; index = 9; length = 49; visibleBase = ('a' * 27 + 'swbdp001') }
            @{ boundary = 'a 36-character base'; index = 10; length = 50; visibleBase = ('a' * 28 + 'swbdp001') }
            @{ boundary = 'a 37-character base'; index = 11; length = 50; visibleBase = ('a' * 29 + 'swbdp00') }
        ) {
            $name = $script:sparkWorkspaceNames["workspace${index}init"].value
            $name.Length | Should -Be $length
            $name | Should -Match ('^' + [regex]::Escape($visibleBase) + '-[a-z0-9]{13}$')
        }

        It 'Forwards the scope-qualified name to the actual tested workspace' {
            $name = $script:synapseDeployment.properties.parameters.name.value
            $name | Should -Match 'uniqueString\('
            $name | Should -Match "subscriptionResourceId\('Microsoft.Resources/resourceGroups', parameters\('resourceGroupName'\)\)"
            $name | Should -Match "parameters\('namePrefix'\)"
            $name | Should -Match "parameters\('serviceShort'\)"
            $resources = $script:synapseDeployment.properties.template.resources
            $resources = $resources -is [System.Collections.IDictionary] ? @($resources.Values) : @($resources)
            $workspaces = @($resources | Where-Object type -EQ 'Microsoft.Synapse/workspaces')
            $workspaces.Count | Should -Be 1
            $workspaces[0].name | Should -BeExactly "[parameters('name')]"
        }

        It 'Preserves the Spark capacity pin and scoped storage dependencies' {
            $script:sparkFixtureTemplate.variables.enforcedLocation | Should -BeExactly 'polandcentral'
            $resources = $script:sparkFixtureTemplate.resources
            $resources = $resources -is [System.Collections.IDictionary] ? @($resources.Values) : @($resources)
            $group = @($resources | Where-Object type -EQ 'Microsoft.Resources/resourceGroups')[0]
            $group.location | Should -BeExactly "[variables('enforcedLocation')]"
            $dependencies = @($resources | Where-Object {
                    $_.properties.parameters -is [System.Collections.IDictionary] -and
                    $_.properties.parameters.Contains('storageAccountName')
                })[0]
            $dependencies.properties.parameters.location.value | Should -BeExactly "[variables('enforcedLocation')]"
            $dependencies.properties.parameters.storageAccountName.value | Should -Match 'uniqueString\('
            $dependencies.properties.parameters.storageAccountName.value | Should -Match "parameters\('resourceGroupName'\)"
            $script:synapseDeployment.properties.parameters.defaultDataLakeStorageAccountResourceId.value |
                Should -Match '\.outputs\.storageAccountResourceId\.value'
            $script:synapseDeployment.properties.parameters.defaultDataLakeStorageFilesystem.value |
                Should -Match '\.outputs\.storageContainerName\.value'
        }
    }
}
