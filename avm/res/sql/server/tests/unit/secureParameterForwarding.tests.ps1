param(
    [array] $moduleFolderPaths,
    [string] $repoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '../../../../../..')).Path
)

BeforeDiscovery {
    . (Join-Path $repoRootPath 'utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1')
    $template = Get-Content (Join-Path $PSScriptRoot '../../main.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 200
    $bindings = @(Get-SecureParameterForwarding -Template $template -ModulePath 'avm/res/sql/server')
    $cases = @(foreach ($binding in $bindings) {
        $skipReason = ''
        if ($binding.Deployment -eq '/secretsExport' -and
            $binding.Target -eq 'secretsToSet.[].value' -and $binding.SinkType -eq 'secureString' -and
            $binding.Source -eq '' -and $binding.Status -eq 'Unsupported' -and
            $binding.ExpressionHash -eq '828FF217A9A2C2CD75FD77A1FAD4675CFEF5FA87970D69BCFC189F59F9EDD064') {
            $skipReason = 'SQL secret export uses union/if/createObject/format projection outside the grammar; the hash pins only this expression, not its security.'
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
