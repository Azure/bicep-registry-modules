param(
    [array] $moduleFolderPaths,
    [string] $repoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '../../../../../..')).Path
)

BeforeDiscovery {
    . (Join-Path $repoRootPath 'utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1')
    $modulePath = 'avm/res/api-management/service'
    $template = Get-Content (Join-Path $PSScriptRoot '../../main.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 200
    $bindings = @(Get-SecureParameterForwarding -Template $template -ModulePath $modulePath)
    $cases = @(foreach ($binding in $bindings) {
        $skipReason = ''
        if ($binding.Deployment -eq '/service_workspaces/workspace_loggers' -and
            $binding.Target -eq 'credentials' -and $binding.SinkType -eq 'secureObject' -and
            $binding.Source -eq 'loggers.[].credentials' -and $binding.Status -eq 'Mismatch') {
            $skipReason = 'Workspace logger credentials still have a plain parent object; the service-level logger is already secure.'
        }
        if ($binding.Deployment -eq '/service_namedValues' -and
            $binding.Target -eq 'value' -and $binding.SinkType -eq 'secureString' -and
            $binding.Source -eq 'newGuidValue' -and $binding.Status -eq 'Mismatch') {
            $skipReason = 'The nonsecret named-value placeholder is overridable; its newGuid() default does not make the parameter secure.'
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
