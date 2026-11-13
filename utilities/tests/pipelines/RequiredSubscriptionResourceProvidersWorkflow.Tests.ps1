param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Required subscription resource provider workflow integration' {
    BeforeAll {
        $actionPath = Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $actionPath -Raw)
        $registrationStep = $action.runs.steps | Where-Object { $_.id -eq 'register-required-resource-providers' }
        $featureStep = $action.runs.steps | Where-Object { $_.id -eq 'register-required-features' }
        $environmentNames = @('GITHUB_WORKSPACE', 'MODULE_PATH', 'SELECTED_SUBSCRIPTION_ID', 'SELECTED_TENANT_ID')
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
        $env:MODULE_PATH = 'avm/res/example/module'
        $env:SELECTED_SUBSCRIPTION_ID = '11111111-1111-4111-8111-111111111111'
        $env:SELECTED_TENANT_ID = '22222222-2222-4222-8222-222222222222'
        $script:registrationInputs = $null
        $script:failRegistration = $false
        $script:failFeature = $false
        $script:events = [System.Collections.Generic.List[string]]::new()
        $stub = @'
function Register-RequiredSubscriptionResourceProvider {
    [CmdletBinding()]
    param ([string] $RepoRootPath, [string] $ModulePath, [string] $SubscriptionId, [string] $TenantId)
    $script:events.Add('providers')
    $script:registrationInputs = @{
        RepoRootPath = $RepoRootPath
        ModulePath = $ModulePath
        SubscriptionId = $SubscriptionId
        TenantId = $TenantId
    }
    if ($script:failRegistration) { throw 'Synthetic provider registration failure' }
}
'@
        Set-Content -LiteralPath (Join-Path $helperFolder 'Register-RequiredSubscriptionResourceProvider.ps1') -Value $stub
        $featureStub = @'
function Register-RequiredSubscriptionFeature {
    [CmdletBinding()]
    param ([string] $RepoRootPath, [string] $ModulePath, [string] $SubscriptionId, [string] $TenantId)
    $script:events.Add('features')
    if ($script:failFeature) { throw 'Synthetic feature registration failure' }
}
'@
        Set-Content -LiteralPath (Join-Path $helperFolder 'Register-RequiredSubscriptionFeature.ps1') -Value $featureStub
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'Places exactly one provider step immediately after features and before any validation or deployment' {
        $steps = @($action.runs.steps)
        @($steps | Where-Object { $_.id -eq 'register-required-resource-providers' }).Count | Should -Be 1
        $registrationIndex = [array]::IndexOf($steps, $registrationStep)
        $registrationIndex | Should -Be ([array]::IndexOf($steps, $featureStep) + 1)
        $selectionStep = $steps | Where-Object { $_.id -eq 'get-test-subscription' }
        $logins = @($steps | Where-Object { $_.uses -like 'azure/login@*' })
        $registrationIndex | Should -BeGreaterThan ([array]::IndexOf($steps, $selectionStep))
        $registrationIndex | Should -BeGreaterThan ([array]::IndexOf($steps, $logins[0]))
        $registrationIndex | Should -BeLessThan ([array]::IndexOf($steps, $logins[1]))
        foreach ($subsequent in @($steps | Where-Object { $_.id -in @('replace-tokens', 'deploy_step') -or $_.name -eq 'Validate template file' })) {
            $registrationIndex | Should -BeLessThan ([array]::IndexOf($steps, $subsequent))
        }
    }

    It 'Runs only after successful login and features when deployment is enabled' {
        $registrationStep.if | Should -Be "env.skip_deployment_ci == 'false'"
        $registrationStep.shell | Should -Be 'pwsh'
        $registrationStep.ContainsKey('continue-on-error') | Should -BeFalse
        $registrationStep.run | Should -Match '\$ErrorActionPreference = ''Stop'''
        $registrationStep.run | Should -Not -Match 'catch|always\(\)|Set-AzContext|az account set|unregister|--consent|--accept'
        $registrationStep.run | Should -Not -Match '\$\{\{'
    }

    It 'Binds to the selected job subscription and the same login tenant' {
        $registrationStep.env.MODULE_PATH | Should -Be '${{ inputs.modulePath }}'
        $registrationStep.env.SELECTED_SUBSCRIPTION_ID | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
        $registrationStep.env.SELECTED_TENANT_ID | Should -Be '${{ env.VALIDATE_TENANT_ID }}'
        $login = @($action.runs.steps | Where-Object { $_.uses -like 'azure/login@*' })[0]
        $login.with.'subscription-id' | Should -Be $registrationStep.env.SELECTED_SUBSCRIPTION_ID
        $login.with.'tenant-id' | Should -Be $registrationStep.env.SELECTED_TENANT_ID

        . ([scriptblock]::Create($registrationStep.run))

        $script:registrationInputs.RepoRootPath | Should -BeExactly $env:GITHUB_WORKSPACE
        $script:registrationInputs.ModulePath | Should -BeExactly $env:MODULE_PATH
        $script:registrationInputs.SubscriptionId | Should -BeExactly $env:SELECTED_SUBSCRIPTION_ID
        $script:registrationInputs.TenantId | Should -BeExactly $env:SELECTED_TENANT_ID
    }

    It 'Preserves module input as data instead of executable script' {
        $env:MODULE_PATH = 'avm/res/example/module; throw "injected"'

        . ([scriptblock]::Create($registrationStep.run))

        $script:registrationInputs.ModulePath | Should -BeExactly $env:MODULE_PATH
    }

    It 'Completes features before invoking providers in the actual step scripts' {
        . ([scriptblock]::Create($featureStep.run))
        . ([scriptblock]::Create($registrationStep.run))

        @($script:events) | Should -Be @('features', 'providers')
    }

    It 'Propagates a provider failure before subsequent validation' {
        $script:failRegistration = $true
        $scriptText = $registrationStep.run + "`n" + '$script:events.Add(''validation'')'

        { . ([scriptblock]::Create($scriptText)) } | Should -Throw '*Synthetic provider registration failure*'
        @($script:events) | Should -Be @('providers')
    }

    It 'Does not continue past failed features into provider registration' {
        $script:failFeature = $true
        $scriptText = $featureStep.run + "`n" + $registrationStep.run

        { . ([scriptblock]::Create($scriptText)) } | Should -Throw '*Synthetic feature registration failure*'
        @($script:events) | Should -Be @('features')
    }

    It 'Documents both root maps without conflating features and providers' {
        $action.inputs.modulePath.description | Should -Match '\.required-features\.json'
        $action.inputs.modulePath.description | Should -Match '\.required-resource-providers\.json'
        $action.inputs.modulePath.description | Should -Match 'provider namespaces'
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
            ($workflow.jobs[$jobName] | ConvertTo-Json -Depth 20) | Should -Not -Match 'Register-RequiredSubscriptionResourceProvider|avm-validateModuleDeployment'
        }

        $deployment = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'avm.template.module.deployment.yml') -Raw)
        $deploymentStep = $deployment.jobs.job_module_deploy_validation.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }
        $deploymentStep.if | Should -Be '${{ !fromJson(inputs.testCase).e2eIgnore }}'
        $deploymentStep.with.modulePath | Should -Be '${{ inputs.modulePath }}'
    }
}
