param(
    [array] $moduleFolderPaths,
    [string] $repoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '../../../../../..')).Path
)

BeforeDiscovery {
    . (Join-Path $repoRootPath 'utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1')
    $template = Get-Content (Join-Path $PSScriptRoot '../../main.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 200
    $bindings = @(Get-SecureParameterForwarding -Template $template -ModulePath 'avm/res/compute/virtual-machine-scale-set')
    $cases = @(foreach ($binding in $bindings) {
        $skipReason = ''
        if ($binding.Deployment -eq '/vmss_customScriptExtension' -and
            $binding.Target -eq 'protectedSettings' -and $binding.SinkType -eq 'secureObject' -and
            $binding.Source -eq '' -and $binding.Status -eq 'Unsupported' -and
            $binding.ExpressionHash -eq '03D8A390D82E8A2539A58F2039C7488823F1AC49EC3C3490AFDCCD843D558A2A') {
            $skipReason = 'The custom-script protectedSettings union/projection is outside the bounded forwarding grammar; the hash pins only this expression, not its security.'
        }
        if ($binding.Deployment -eq '/vmss_azureMonitorAgentExtension' -and
            $binding.Target -eq 'protectedSettings' -and $binding.SinkType -eq 'secureObject' -and
            $binding.Source -eq '' -and $binding.Status -eq 'Unsupported' -and
            $binding.ExpressionHash -eq '18B23E606BECF2D0207F84CF632ABC0264D1A38B8586A1627A6D1B340D8DD76C') {
            $skipReason = 'The Azure Monitor protectedSettings conditional is outside the bounded forwarding grammar; the hash pins only this expression, not its security.'
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
