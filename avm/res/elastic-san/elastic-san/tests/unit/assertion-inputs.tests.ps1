param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName,
    [array] $moduleFolderPaths
)

Describe 'Elastic SAN assertion inputs' {
    BeforeAll {
        $helperPath = Join-Path $repoRootPath 'avm' 'res' 'elastic-san' 'elastic-san' 'tests' 'e2e' 'common.tests.ps1'
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($helperPath, [ref] $tokens, [ref] $parseErrors)
        if ($parseErrors) { throw 'Could not parse the Elastic SAN test helpers.' }
        $dnsLoops = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.ForEachStatementAst] -and
                    $node.Variable.VariablePath.UserPath -eq 'dnsConfig'
                }, $true))
        if ($dnsLoops.Count -ne 1) { throw 'Expected one custom DNS configuration loop.' }
        $dnsAssertions = [scriptblock]::Create($dnsLoops[0].Extent.Text)
        $helper = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                    $node.Name -eq 'Test-VerifyElasticSAN'
                }, $true))
        if ($helper.Count -ne 1) { throw 'Expected one Elastic SAN verification helper.' }
        $metricParameter = @($helper[0].Parameters | Where-Object Name -Match 'MetricCategoryName')
        $metricStatements = @($helper[0].Body.EndBlock.Statements | Where-Object {
                $_.Extent.Text -match 'Test-VerifyDiagSettings'
            })
        if ($metricParameter.Count -ne 1 -or $metricStatements.Count -ne 1) {
            throw 'Expected an explicit metric parameter and diagnostic assertion.'
        }
        $metricAssertions = [scriptblock]::Create(
            "param($($metricParameter[0].Extent.Text))`n$($metricStatements[0].Extent.Text)")
        function Test-VerifyDiagSettings($ResourceId, $DiagName, $LogAnalyticsWorkspaceResourceId, $MetricCategoryName) {
            return $MetricCategoryName
        }
    }

    It 'Checks the real custom DNS assertions for <scenario>' -ForEach @(
        @{ scenario = 'empty configuration array'; accepted = $true }
        @{ scenario = 'one configuration'; accepted = $true }
        @{ scenario = 'nullable FQDN'; accepted = $true }
        @{ scenario = 'multiple configurations'; accepted = $true }
        @{ scenario = 'empty FQDN'; accepted = $false }
        @{ scenario = 'missing IP addresses'; accepted = $false }
        @{ scenario = 'invalid second configuration'; accepted = $false }
    ) {
        Set-StrictMode -Version 3.0
        $configuration = [pscustomobject]@{ fqdn = 'volume.example.test'; ipAddresses = @('10.0.0.4') }
        $configurations = @($configuration)
        switch ($scenario) {
            'empty configuration array' { $configurations = @() }
            'nullable FQDN' { $configuration.fqdn = $null }
            'multiple configurations' {
                $configurations += [pscustomobject]@{ fqdn = 'other.example.test'; ipAddresses = @('10.0.0.5') }
            }
            'empty FQDN' { $configuration.fqdn = '' }
            'missing IP addresses' { $configuration.ipAddresses = @() }
            'invalid second configuration' {
                $configurations += [pscustomobject]@{ fqdn = 'other.example.test'; ipAddresses = @('') }
            }
        }
        $PrivateEndpoints = @([pscustomobject]@{ customDnsConfigs = $configurations })
        $i = 0
        if ($accepted) {
            { . $dnsAssertions } | Should -Not -Throw
        } else {
            { . $dnsAssertions } | Should -Throw
        }
    }

    It 'Uses the real <scenario> metric input without an ambient TestOutput variable' -ForEach @(
        @{ scenario = 'default'; explicit = $false; expected = 'AllMetrics' }
        @{ scenario = 'explicit'; explicit = $true; expected = 'CustomMetric' }
    ) {
        Set-StrictMode -Version 3.0
        $LogAnalyticsWorkspaceResourceId = 'workspace-id'
        $esan = [pscustomobject]@{ Id = 'elastic-san-id' }
        $actual = if ($explicit) {
            . $metricAssertions -MetricCategoryName $expected
        } else {
            . $metricAssertions
        }
        $actual | Should -Be $expected
    }
}
