Describe 'Private analytical workspace WAF dependencies' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'waf-aligned' 'main.test.bicep'
        $outputPath = Join-Path $TestDrive 'waf.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:template = Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $script:template.resources -is [System.Collections.IDictionary] ? @($script:template.resources.Values) : @($script:template.resources)
        $script:workspace = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -match 'replicatedLogAnalytics'
            })
        $script:tested = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and $_.copy.name -eq 'testDeployment'
            })
    }

    It 'Provides a workspace with a supported cross-region replica' {
        $script:workspace | Should -HaveCount 1
        $parameters = $script:workspace[0].properties.parameters
        $parameters.replication.value.enabled | Should -BeTrue
        $parameters.replication.value.location | Should -BeExactly 'germanywestcentral'
        $script:template.variables.enforcedLocation | Should -BeExactly 'northeurope'
        $parameters.dataRetention.value | Should -Be 35
        $parameters.dailyQuotaGb.value | Should -BeExactly '1'
    }

    It 'Exercises the existing-workspace path after the replicated dependency completes' {
        $script:tested | Should -HaveCount 1
        $module = $script:tested[0]
        $module.properties.parameters.logAnalyticsWorkspaceResourceId.value | Should -Match 'replicatedLogAnalytics'
        ($module.dependsOn -join ' ') | Should -Match 'replicatedLogAnalytics'
        $module.copy.mode | Should -BeExactly 'serial'
        $module.copy.batchSize | Should -Be 1
    }
}
