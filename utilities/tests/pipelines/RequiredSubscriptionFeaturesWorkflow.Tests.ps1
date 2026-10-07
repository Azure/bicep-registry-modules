param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Required subscription feature workflow integration' {
    BeforeAll {
        $actionPath = Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $actionPath -Raw)
        $registrationStep = $action.runs.steps | Where-Object { $_.id -eq 'register-required-features' }
        $environmentNames = @('GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'MODULE_PATH', 'SELECTED_SUBSCRIPTION_ID', 'SELECTED_TENANT_ID', 'VALIDATE_TENANT_ID')
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            [Environment]::SetEnvironmentVariable($name, $null)
        }
        $env:GITHUB_WORKSPACE = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $helperFolder = Join-Path $env:GITHUB_WORKSPACE 'utilities' 'pipelines' 'sharedScripts'
        $null = New-Item -Path $helperFolder -ItemType Directory -Force
        $env:GITHUB_OUTPUT = Join-Path $env:GITHUB_WORKSPACE 'output.txt'
        $env:MODULE_PATH = 'avm/res/example/module'
        $env:SELECTED_SUBSCRIPTION_ID = '11111111-1111-4111-8111-111111111111'
        $env:SELECTED_TENANT_ID = '22222222-2222-4222-8222-222222222222'
        $script:registrationInputs = $null
        $script:failRegistration = $false
        $stub = @'
function Register-RequiredSubscriptionFeature {
    [CmdletBinding()]
    param ([string] $RepoRootPath, [string] $ModulePath, [string] $SubscriptionId, [string] $TenantId)
    $script:registrationInputs = @{
        RepoRootPath = $RepoRootPath
        ModulePath = $ModulePath
        SubscriptionId = $SubscriptionId
        TenantId = $TenantId
    }
    if ($script:failRegistration) { throw 'Synthetic feature registration failure' }
}
'@
        Set-Content -LiteralPath (Join-Path $helperFolder 'Register-RequiredSubscriptionFeature.ps1') -Value $stub
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'Places one success-only registration step between the deployment and post-deployment logins' {
        $steps = @($action.runs.steps)
        @($steps | Where-Object { $_.id -eq 'register-required-features' }).Count | Should -Be 1
        $registrationIndex = [array]::IndexOf($steps, $registrationStep)
        $logins = @($steps | Where-Object { $_.uses -like 'azure/login@*' })
        $logins.Count | Should -Be 2
        $registrationIndex | Should -BeGreaterThan ([array]::IndexOf($steps, $logins[0]))
        $registrationIndex | Should -BeLessThan ([array]::IndexOf($steps, $logins[1]))
        foreach ($subsequent in @($steps | Where-Object { $_.id -in @('replace-tokens', 'deploy_step') -or $_.name -eq 'Validate template file' })) {
            $registrationIndex | Should -BeLessThan ([array]::IndexOf($steps, $subsequent))
        }
        $registrationStep.if | Should -Be "env.skip_deployment_ci == 'false'"
        $registrationStep.shell | Should -Be 'pwsh'
        $registrationStep.ContainsKey('continue-on-error') | Should -BeFalse
        $registrationStep.run | Should -Not -Match 'catch|always\(\)|Set-AzContext|az account set'
    }

    It 'Uses one standard OIDC login per deployment phase without writing credentials to outputs' {
        $steps = @($action.runs.steps)
        $logins = @($steps | Where-Object { $_.uses -like 'azure/login@*' })
        $logins.Count | Should -Be 2
        foreach ($login in $logins) {
            $login.if | Should -Be "env.skip_deployment_ci == 'false'"
            $login.with.'client-id' | Should -Be '${{ env.VALIDATE_CLIENT_ID }}'
            $login.with.'tenant-id' | Should -Be '${{ env.VALIDATE_TENANT_ID }}'
            $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
            $login.with.ContainsKey('creds') | Should -BeFalse
        }

        $outputScripts = @(
            foreach ($step in $steps) {
                foreach ($script in @($step.run, $step.with.inlineScript)) {
                    if ($script -match '\$env:GITHUB_OUTPUT') {
                        $script
                    }
                }
            }
        )
        ($outputScripts -join "`n") | Should -Not -Match 'credential|clientSecret'
    }

    It 'Passes the exact module and selected subscription and tenant as environment data' {
        $registrationStep.env.MODULE_PATH | Should -Be '${{ inputs.modulePath }}'
        $registrationStep.env.SELECTED_SUBSCRIPTION_ID | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
        $registrationStep.env.SELECTED_TENANT_ID | Should -Be '${{ env.VALIDATE_TENANT_ID }}'
        $registrationStep.run | Should -Not -Match '\$\{\{'

        . ([scriptblock]::Create($registrationStep.run))

        $script:registrationInputs.RepoRootPath | Should -BeExactly $env:GITHUB_WORKSPACE
        $script:registrationInputs.ModulePath | Should -BeExactly $env:MODULE_PATH
        $script:registrationInputs.SubscriptionId | Should -BeExactly $env:SELECTED_SUBSCRIPTION_ID
        $script:registrationInputs.TenantId | Should -BeExactly $env:SELECTED_TENANT_ID
    }

    It 'Does not swallow a failed registration in the actual workflow script' {
        $script:failRegistration = $true

        { . ([scriptblock]::Create($registrationStep.run)) } | Should -Throw '*Synthetic feature registration failure*'
    }

    It 'Keeps registration confined to deployment jobs in <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        $workflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' "$workflowName.yml") -Raw)
        $workflow.jobs.job_module_deploy_validation.if | Should -Match "deploymentValidation == 'true'"
        $workflow.jobs.job_module_deploy_validation.uses | Should -Be './.github/workflows/avm.template.module.deployment.yml'
        foreach ($jobName in @('job_module_static_validation', 'job_psrule_must', 'job_psrule_opt')) {
            ($workflow.jobs[$jobName] | ConvertTo-Json -Depth 20) | Should -Not -Match 'Register-RequiredSubscriptionFeature|avm-validateModuleDeployment'
        }

        $deployment = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'avm.template.module.deployment.yml') -Raw)
        $deploymentStep = $deployment.jobs.job_module_deploy_validation.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }
        $deploymentStep.if | Should -Be '${{ !fromJson(inputs.testCase).e2eIgnore }}'
        $deploymentStep.with.modulePath | Should -Be '${{ inputs.modulePath }}'
    }
}
