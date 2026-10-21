param(
    [array] $moduleFolderPaths,
    [string] $repoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '../../../../../..')).Path
)

BeforeDiscovery {
    . (Join-Path $repoRootPath 'utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1')
    $template = Get-Content (Join-Path $PSScriptRoot '../../main.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 200
    $bindings = @(Get-SecureParameterForwarding -Template $template -ModulePath 'avm/res/container-service/managed-cluster')
    $cases = @(foreach ($binding in $bindings) {
        $skipReason = ''
        if ($binding.Deployment -eq '/managedCluster_extension/fluxConfiguration' -and
            $binding.Target -eq 'configurationProtectedSettings' -and $binding.SinkType -eq 'secureObject' -and
            $binding.Source -eq 'fluxConfigurations.[].configurationProtectedSettings' -and $binding.Status -eq 'Mismatch') {
            $skipReason = 'The embedded extension is still 0.3.8; bump to 0.3.9 once published to get secure fluxConfigurationType settings.'
        }
        @{ binding = $binding; skipReason = $skipReason }
    })
}

Describe 'Secure parameter forwarding' {
    It 'Discovers secure child bindings' -TestCases @(@{ bindings = $bindings }) {
        param([object[]] $bindings)
        $bindings | Should -Not -BeNullOrEmpty -Because 'this opted-in module must exercise the analyzer'
    }

    Context '<binding.Deployment> -> <binding.Target> (<binding.Source>)' -ForEach $cases {
        It "Preserves secure parent typing$(if ($skipReason) { ": $skipReason" })" -Skip:([bool] $skipReason) {
            $binding.Status | Should -Not -BeIn @('Mismatch', 'Unsupported') -Because "the child requires $($binding.SinkType); secure the parent input or explicitly document an unsupported expression in this module's test"
        }
    }
}
