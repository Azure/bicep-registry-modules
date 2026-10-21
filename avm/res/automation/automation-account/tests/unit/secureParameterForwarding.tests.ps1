param(
    [array] $moduleFolderPaths,
    [string] $repoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '../../../../../..')).Path
)

BeforeDiscovery {
    . (Join-Path $repoRootPath 'utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1')
    $template = Get-Content (Join-Path $PSScriptRoot '../../main.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 200
    $bindings = @(Get-SecureParameterForwarding -Template $template -ModulePath 'avm/res/automation/automation-account')
    $cases = @($bindings | ForEach-Object { @{ binding = $_ } })
}

Describe 'Secure parameter forwarding' {
    It 'Discovers secure child bindings' -TestCases @(@{ bindings = $bindings }) {
        param([object[]] $bindings)
        $bindings | Should -Not -BeNullOrEmpty -Because 'this opted-in module must exercise the analyzer'
    }

    It 'Preserves secure parent typing for <binding.Deployment> -> <binding.Target> (<binding.Source>)' -TestCases $cases {
        param([object] $binding)
        $binding.Status | Should -Not -BeIn @('Mismatch', 'Unsupported') -Because "the child requires $($binding.SinkType); secure the parent input or explicitly document an unsupported expression in this module's test"
    }
}
