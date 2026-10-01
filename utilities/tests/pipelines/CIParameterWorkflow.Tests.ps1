param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'CI parameter workflow integration' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Test-TemplateDeploymentWithRetry.ps1')
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
        function Get-AzKeyVaultSecret {
            [CmdletBinding()]
            param([string] $VaultName, [string] $Name)
            throw 'Unexpected Key Vault access.'
        }
        function Get-AzResourceProvider {
            [CmdletBinding()]
            param([string[]] $ProviderNamespace)
            throw 'Unexpected Azure provider query.'
        }
        function Get-AzLocation {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure location query.'
        }

        function Get-TestStepScript {
            param([string] $StepName, [string] $TemplatePath, [string] $CustomLocation = '')

            $script = ($action.runs.steps | Where-Object { $_.name -eq $StepName }).with.inlineScript
            # Keep mocks in place instead of loading the real Azure deployment functions.
            $script = $script -replace "(?m)^.*\. \(Join-Path.*'resourceDeployment'.*\)\r?\n", ''
            $script = $script.Replace(
                'Join-Path $env:GITHUB_WORKSPACE ''${{ inputs.templateFilePath }}''',
                "'{0}'" -f $TemplatePath.Replace("'", "''")
            )
            $script = $script.Replace('${{ inputs.deploymentMetadataLocation }}', 'westeurope')
            $script = $script.Replace('${{ steps.get-test-subscription.outputs.managementGroupId }}', 'test-management-group')
            $script = $script.Replace('${{ steps.get-test-subscription.outputs.subscriptionId }}', '11111111-1111-1111-1111-111111111111')
            $script = $script.Replace('${{ inputs.modulePath }}', 'avm/res/dev-test-lab/lab')
            $script = $script.Replace('${{ inputs.customLocation }}', $CustomLocation)
            $script = $script.Replace('${{ steps.replace-tokens.outputs.resourceLocation }}', '')
            $script = $script.Replace('${{ steps.validate-template.outputs.resourceLocation }}', 'eastus')
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
        $env:CI_KEY_VAULT_NAME = 'unused-legacy-vault'

        $templatePath = Join-Path $TestDrive 'template.json'
        @{
            '$schema' = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            parameters = @{
                adminMembersSecret = @{ type = 'secureString' }
                secureConfig       = @{ type = 'secureObject' }
                resourceLocation   = @{ type = 'string' }
                resource_name      = @{ type = 'string' }
                baseTime           = @{ type = 'string' }
                legacyOnly         = @{ type = 'secureString' }
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
        Mock Get-AzKeyVaultSecret { throw 'CI must never access the legacy Key Vault.' }
        Mock Get-AzResourceProvider { throw 'Unexpected Azure provider query.' }
        Mock Get-AzLocation { throw 'Unexpected Azure location query.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
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
        @($workflow.env.Keys) | Should -Not -Contain 'CI_KEY_VAULT_NAME'
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

    It 'Removes the unreachable vault warning and every vault fallback from the action' {
        @($action.runs.steps.name) | Should -Not -Contain 'Warn about CI Key Vault deprecation'
        ($action | ConvertTo-Json -Depth 20) | Should -Not -Match 'CI_KEY_VAULT_NAME|KeyVaultName'
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
            -not $AdditionalParameters.ContainsKey('legacyOnly') -and
            -not [string]::IsNullOrEmpty($AdditionalParameters.baseTime)
        }
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
        ($messages | Out-String) | Should -Not -Match 'secret-value|nested-secret-value|variable-value'
        Get-Content -Path $path -Raw | Should -BeExactly $before
    }

    It 'Does not use the legacy vault when <stepName> has no GitHub CI parameters' -ForEach @(
        @{ stepName = 'Validate template file'; commandName = 'Test-TemplateDeployment' }
        @{ stepName = 'Deploy template file'; commandName = 'New-TemplateDeployment' }
    ) {
        $env:AVM_CI_VARIABLES = '{"CI_KEY_VAULT_NAME":"unused-legacy-vault"}'
        $env:AVM_CI_SECRETS = '{"AZURE_CREDENTIALS":"unused-legacy-credentials"}'
        $script = Get-TestStepScript -StepName $stepName -TemplatePath $templatePath -CustomLocation 'eastus'

        $null = . $script

        Should -Invoke $commandName -Times 1 -Exactly -ParameterFilter {
            -not $AdditionalParameters.ContainsKey('adminMembersSecret') -and
            -not $AdditionalParameters.ContainsKey('secureConfig') -and
            -not $AdditionalParameters.ContainsKey('legacyOnly')
        }
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
        Should -Invoke Get-AzLocation -Times 0 -Exactly
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
