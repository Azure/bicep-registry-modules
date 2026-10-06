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
}
