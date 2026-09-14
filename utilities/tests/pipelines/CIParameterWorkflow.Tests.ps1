param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'CI parameter workflow integration' {

    BeforeAll {
        $workflows = @{}
        foreach ($workflowName in @('avm.template.module', 'avm.template.module.preview', 'avm.template.module.publish')) {
            $workflowPath = Join-Path $repoRootPath '.github' 'workflows' "$workflowName.yml"
            $workflows[$workflowName] = ConvertFrom-Yaml -Yaml (Get-Content -Path $workflowPath -Raw)
        }
        $actionPath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -Path $actionPath -Raw)
        $environmentNames = @('GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'AVM_CI_VARIABLES', 'AVM_CI_SECRETS', 'CI_KEY_VAULT_NAME')

        function Test-TemplateDeployment {
            [CmdletBinding()]
            param(
                [string] $TemplateFilePath, [string] $DeploymentMetadataLocation,
                [string] $SubscriptionId, [string] $ManagementGroupId,
                [string] $RepoRoot, [hashtable] $AdditionalParameters
            )
            throw 'Unexpected deployment validation.'
        }
        function New-TemplateDeployment {
            [CmdletBinding()]
            param(
                [string] $TemplateFilePath, [string] $DeploymentMetadataLocation,
                [string] $SubscriptionId, [string] $ManagementGroupId,
                [string] $RepoRoot, [hashtable] $AdditionalParameters, [bool] $DoNotThrow
            )
            throw 'Unexpected deployment.'
        }

        function Get-TestStepScript {
            param([string] $StepName, [string] $TemplatePath)

            $script = ($action.runs.steps | Where-Object { $_.name -eq $StepName }).with.inlineScript
            # Keep mocks in place instead of loading the real Azure deployment functions.
            $script = $script -replace "(?m)^.*\. \(Join-Path.*'resourceDeployment'.*\)\r?\n", ''
            $script = $script.Replace(
                'Join-Path $env:GITHUB_WORKSPACE ''${{ inputs.templateFilePath }}''',
                "'{0}'" -f $TemplatePath.Replace("'", "''")
            )
            $script = $script.Replace('${{ inputs.deploymentMetadataLocation }}', 'westeurope')
            $script = $script.Replace('${{ inputs.managementGroupId }}', '')
            $script = $script.Replace('${{ steps.get-test-subscription.outputs.subscriptionId }}', '11111111-1111-1111-1111-111111111111')
            $script = $script.Replace('${{ steps.get-resource-location.outputs.resourceLocation }}', 'westus')
            return [scriptblock]::Create($script)
        }
    }

    BeforeEach {
        $savedExitCode = $global:LASTEXITCODE
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            [Environment]::SetEnvironmentVariable($name, $null)
        }
        $env:GITHUB_WORKSPACE = $repoRootPath
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'output.txt'
        $env:AVM_CI_VARIABLES = '{"CI_ADMINMEMBERSSECRET":"variable-value","CI_RESOURCE_LOCATION":"eastus","CI__RESOURCELOCATION":"unused-region","CI__RESOURCE_NAME":"literal-name"}'
        $env:AVM_CI_SECRETS = '{"CI__ADMINMEMBERSSECRET":"shadowed-secret-value","CI_ADMIN_MEMBERS_SECRET":"secret-value","CI__SECURECONFIG":"{\"password\":\"nested-secret-value\"}"}'

        $templatePath = Join-Path $TestDrive 'template.json'
        @{
            parameters = @{
                adminMembersSecret = @{ type = 'secureString' }
                secureConfig       = @{ type = 'secureObject' }
                resourceLocation   = @{ type = 'string' }
                resource_name      = @{ type = 'string' }
                baseTime           = @{ type = 'string' }
            }
        } | ConvertTo-Json -Depth 5 | Set-Content -Path $templatePath
        $bicepPath = Join-Path $TestDrive 'template.bicep'
        @'
@secure()
param adminMembersSecret string
@secure()
type testConfig = {
  password: string
}
param secureConfig testConfig
param resourceLocation string
param resource_name string
param baseTime string

@secure()
output configuredParameters object = {
  adminMembersSecret: adminMembersSecret
  secureConfig: secureConfig
  resourceLocation: resourceLocation
  resource_name: resource_name
  baseTime: baseTime
}
'@ | Set-Content -Path $bicepPath

        Mock Test-TemplateDeployment {}
        Mock New-TemplateDeployment { @{ deploymentNames = @('test-deployment'); deploymentOutput = @{} } }
    }

    AfterEach {
        $global:LASTEXITCODE = $savedExitCode
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'Reads resolved contexts inside the environment job for <workflowName>' -ForEach @(
        @{ workflowName = 'avm.template.module' }
        @{ workflowName = 'avm.template.module.preview' }
        @{ workflowName = 'avm.template.module.publish' }
    ) {
        $workflow = $workflows[$workflowName]
        $deployment = $workflow.jobs.job_module_deploy_validation
        $step = $deployment.steps | Where-Object { $_.uses -eq './.github/actions/templates/avm-validateModuleDeployment' }

        $deployment.environment | Should -Be 'avm-validation'
        $step.with.githubVariables | Should -Be '${{ toJSON(vars) }}'
        $step.with.githubSecrets | Should -Be '${{ toJSON(secrets) }}'
        $workflow.env.CI_KEY_VAULT_NAME | Should -Be '${{ vars.CI_KEY_VAULT_NAME }}'
        @($workflow.env.Keys) | Should -Not -Contain 'AVM_CI_SECRETS'
        @($deployment.env.Keys) | Should -Not -Contain 'AVM_CI_SECRETS'
    }

    It 'Only exposes context payloads as environment data to validation and deployment steps' {
        $action.inputs.githubVariables.default | Should -Be '{}'
        $action.inputs.githubSecrets.default | Should -Be '{}'
        $stepsWithSecrets = @($action.runs.steps | Where-Object { $_.env -and $_.env.ContainsKey('AVM_CI_SECRETS') })
        $stepsWithSecrets.Count | Should -Be 2
        foreach ($step in $stepsWithSecrets) {
            $step.name | Should -BeIn @('Validate template file', 'Deploy template file')
            $step.env.AVM_CI_VARIABLES | Should -Be '${{ inputs.githubVariables }}'
            $step.env.AVM_CI_SECRETS | Should -Be '${{ inputs.githubSecrets }}'
            $step.with.inlineScript | Should -Not -Match '\$\{\{\s*inputs\.github(Secrets|Variables)'
            $step.with.inlineScript | Should -Not -Match 'GITHUB_ENV'
        }
    }

    It 'Warns about legacy vault support without exposing the vault name or values' {
        $step = $action.runs.steps | Where-Object { $_.name -eq 'Warn about CI Key Vault deprecation' }

        $step.if | Should -Be "env.skip_deployment_ci == 'false' && env.CI_KEY_VAULT_NAME != ''"
        $messages = @(. ([scriptblock]::Create($step.run)))
        $messages | Should -Match '^::warning'
        $messages | Should -Match 'support may be removed'
        $messages | Should -Match 'GitHub Actions secrets or variables'
    }

    It 'Passes <format> parameters to <stepName> without modifying the template or logging values' -ForEach @(
        @{ stepName = 'Validate template file'; commandName = 'Test-TemplateDeployment'; format = 'JSON' }
        @{ stepName = 'Deploy template file'; commandName = 'New-TemplateDeployment'; format = 'JSON' }
        @{ stepName = 'Validate template file'; commandName = 'Test-TemplateDeployment'; format = 'Bicep' }
        @{ stepName = 'Deploy template file'; commandName = 'New-TemplateDeployment'; format = 'Bicep' }
    ) {
        $path = $format -eq 'Bicep' ? $bicepPath : $templatePath
        $before = Get-Content -Path $path -Raw
        $script = Get-TestStepScript -StepName $stepName -TemplatePath $path

        $messages = @(. $script 4>&1)

        Should -Invoke $commandName -Times 1 -Exactly -ParameterFilter {
            $AdditionalParameters.adminMembersSecret -is [securestring] -and
            (ConvertFrom-SecureString -SecureString $AdditionalParameters.adminMembersSecret -AsPlainText) -eq 'secret-value' -and
            $AdditionalParameters.secureConfig.password -eq 'nested-secret-value' -and
            $AdditionalParameters.resourceLocation -eq 'eastus' -and
            $AdditionalParameters.resource_name -eq 'literal-name' -and
            -not [string]::IsNullOrEmpty($AdditionalParameters.baseTime)
        }
        ($messages | Out-String) | Should -Not -Match 'secret-value|nested-secret-value|variable-value'
        Get-Content -Path $path -Raw | Should -BeExactly $before
    }

    It 'Stops <stepName> when Bicep compilation fails' -ForEach @(
        @{ stepName = 'Validate template file'; commandName = 'Test-TemplateDeployment' }
        @{ stepName = 'Deploy template file'; commandName = 'New-TemplateDeployment' }
    ) {
        Mock bicep { $global:LASTEXITCODE = 1; return '{"parameters":{}}' }
        $script = Get-TestStepScript -StepName $stepName -TemplatePath $bicepPath

        { . $script } | Should -Throw '*Failed to compile the test template*'
        Should -Invoke $commandName -Times 0 -Exactly
    }
}
