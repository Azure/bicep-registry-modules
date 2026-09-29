param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Regional validation workflow runtime integration' {
    BeforeAll {
        $actionPath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $actionPath -Raw)
        $environmentNames = @(
            'TEMP', 'GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'AVM_CI_VARIABLES', 'AVM_CI_SECRETS', 'CI_KEY_VAULT_NAME',
            'localToken_resourceLocation'
        )

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
        function Set-AzContext {
            [CmdletBinding()]
            param([string] $Subscription)
            throw 'Unexpected Azure context change.'
        }
        function Test-AzSubscriptionDeployment {
            [CmdletBinding()]
            param(
                [string] $TemplateFile, [string] $DeploymentName, [string] $Location,
                [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret
            )
            throw 'Unexpected Azure validation.'
        }
        function New-AzSubscriptionDeployment {
            [CmdletBinding()]
            param(
                [string] $TemplateFile, [string] $DeploymentName, [string] $Location,
                [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret
            )
            throw 'Unexpected Azure deployment.'
        }
        function Initialize-DeploymentRemoval {
            [CmdletBinding()]
            param([string] $TemplateFilePath, [string[]] $DeploymentNames, [string] $ManagementGroupId, [string] $SubscriptionId)
            throw 'Unexpected Azure cleanup.'
        }

        function Get-StepOutput {
            $outputs = @{}
            foreach ($line in (Get-Content -LiteralPath $env:GITHUB_OUTPUT)) {
                if (-not [string]::IsNullOrWhiteSpace($line)) {
                    $name, $value = $line.Split('=', 2)
                    $outputs[$name] = $value
                }
            }
            return $outputs
        }

        function Invoke-DeploymentStep {
            param([string] $Name, [hashtable] $Outputs = @{}, [string] $CustomLocation = '', [string] $CustomTokensInput = '')

            $step = $action.runs.steps | Where-Object { $_.name -eq $Name }
            $script = $step.with.inlineScript
            if ($Name -eq 'Remove deployed resources') {
                $script = $script -replace "(?m)^.*\. \(Join-Path.*'resourceRemoval'.*\)\r?\n", ''
            }
            $script = $script.Replace(
                'Join-Path $env:GITHUB_WORKSPACE ''${{ inputs.templateFilePath }}''',
                "'{0}'" -f $templatePath.Replace("'", "''")
            )
            $values = @{
                '${{ inputs.modulePath }}'                                  = 'avm/res/dev-test-lab/lab'
                '${{ inputs.customLocation }}'                              = $CustomLocation
                '${{ inputs.customTokens }}'                                = $CustomTokensInput
                '${{  inputs.customTokens }}'                               = $CustomTokensInput
                '${{ inputs.managementGroupId }}'                           = 'test-management-group'
                '${{ inputs.deploymentMetadataLocation }}'                  = 'WestEurope'
                '${{ env.VALIDATE_TENANT_ID }}'                             = 'test-tenant'
                '${{ env.TOKEN_NAMEPREFIX }}'                               = 'testprefix'
                '${{ steps.get-test-subscription.outputs.subscriptionId }}' = '11111111-1111-1111-1111-111111111111'
                '${{ steps.replace-tokens.outputs.resourceLocation }}'      = $Outputs.tokenLocation ?? ''
                '${{ steps.validate-template.outputs.resourceLocation }}'   = $Outputs.validatedLocation ?? ''
                '${{ steps.deploy_step.outputs.deploymentNames }}'          = $Outputs.deploymentNames ?? ''
            }
            foreach ($key in $values.Keys) {
                $script = $script.Replace($key, $values[$key])
            }
            $script | Should -Not -Match '\$\{\{'
            Clear-Content -LiteralPath $env:GITHUB_OUTPUT
            . ([scriptblock]::Create($script))
        }

        function Invoke-ValidationAndDeployment {
            param([string] $CustomLocation = '', [string] $CustomTokensInput = '')
            $null = Invoke-DeploymentStep -Name 'Replace tokens in template file' -CustomTokensInput $CustomTokensInput
            $tokenLocation = (Get-StepOutput).resourceLocation
            $null = Invoke-DeploymentStep -Name 'Validate template file' -CustomLocation $CustomLocation -Outputs @{ tokenLocation = $tokenLocation }
            $validatedLocation = (Get-StepOutput).resourceLocation
            $null = Invoke-DeploymentStep -Name 'Deploy template file' -Outputs @{ validatedLocation = $validatedLocation }
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            Remove-Item -LiteralPath "Env:\$name" -ErrorAction SilentlyContinue
        }
        $env:TEMP = $TestDrive
        $env:GITHUB_WORKSPACE = $repoRootPath
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'step-output.txt'
        $null = New-Item -Path $env:GITHUB_OUTPUT -ItemType File -Force
        $env:AVM_CI_VARIABLES = '{}'
        $env:AVM_CI_SECRETS = '{"CI_ADMIN_SECRET":"secret-value-not-for-logs"}'
        '{"Microsoft.DevTestLab":{"labs":{}}}' | Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
        $templatePath = Join-Path $TestDrive 'main.test.json'
        @{
            '$schema'  = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            parameters = @{
                resourceLocation = @{ type = 'string' }
                baseTime         = @{ type = 'string' }
                adminSecret      = @{ type = 'secureString' }
            }
            variables  = @{
                regionToken       = '#_resourceLocation_#'
                subscriptionToken = '#_subscriptionId_#'
                unrelatedLiteral  = 'centralus'
            }
        } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        $script:validationRegions = [System.Collections.Generic.List[string]]::new()
        $script:deploymentRegions = [System.Collections.Generic.List[string]]::new()
        $script:deploymentTokens = [System.Collections.Generic.List[string]]::new()
        $script:deploymentNames = [System.Collections.Generic.List[string]]::new()
        $script:regionalFailure = @{
            Code    = 'InvalidTemplateDeployment'
            Details = @(@{ Code = 'RequestDisallowedByAzure'; Message = 'Region is not accepting new customers. See https://aka.ms/locationineligible.' })
        }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock Get-Random { 0 }
        Mock Start-Sleep {}
        Mock Get-AzResourceProvider {
            if ($ProviderNamespace) {
                @{ RegistrationState = 'NotRegistered'; ResourceTypes = @(
                        @{ ResourceTypeName = 'labs'; Locations = @('Central US', 'East US', 'Korea Central', 'West Europe') }
                    )
                }
            }
        }
        Mock Get-AzLocation {
            @(
                @{ Location = 'centralus'; DisplayName = 'Central US'; RegionCategory = 'Recommended'; PairedRegion = 'eastus2' }
                @{ Location = 'eastus'; DisplayName = 'East US'; RegionCategory = 'Recommended'; PairedRegion = 'westus' }
                @{ Location = 'koreacentral'; DisplayName = 'Korea Central'; RegionCategory = 'Recommended'; PairedRegion = 'koreasouth' }
                @{ Location = 'westeurope'; DisplayName = 'West Europe'; RegionCategory = 'Recommended'; PairedRegion = 'northeurope' }
            )
        }
        Mock Set-AzContext {}
        Mock Test-AzSubscriptionDeployment {
            $script:validationRegions.Add($resourceLocation)
            $Location | Should -BeExactly 'WestEurope'
            $content = Get-Content -LiteralPath $TemplateFile -Raw | ConvertFrom-Json
            $content.variables.regionToken | Should -Be $resourceLocation
            $content.variables.subscriptionToken | Should -Be '11111111-1111-1111-1111-111111111111'
            $content.variables.unrelatedLiteral | Should -Be 'centralus'
            ConvertFrom-SecureString -SecureString $adminSecret -AsPlainText | Should -Be 'secret-value-not-for-logs'
            if ($resourceLocation -eq 'centralus') { $script:regionalFailure }
        }
        Mock New-AzSubscriptionDeployment {
            $script:deploymentRegions.Add($resourceLocation)
            $script:deploymentNames.Add($DeploymentName)
            $content = Get-Content -LiteralPath $TemplateFile -Raw | ConvertFrom-Json
            $script:deploymentTokens.Add($content.variables.regionToken)
            ConvertFrom-SecureString -SecureString $adminSecret -AsPlainText | Should -Be 'secret-value-not-for-logs'
            $Location | Should -BeExactly 'WestEurope'
            @{
                ProvisioningState = 'Succeeded'
                Outputs           = @{ selectedRegion = @{ Type = 'String'; Value = $resourceLocation } }
            }
        }
        Mock Initialize-DeploymentRemoval {}
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            if ($null -eq $savedEnvironment[$name]) {
                Remove-Item -LiteralPath "Env:\$name" -ErrorAction SilentlyContinue
            } else {
                [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
            }
        }
    }

    It 'Recovers the observed validation failure and deploys with the validated parameters and token files' {
        $messages = Invoke-ValidationAndDeployment 3>&1 4>&1

        @($script:validationRegions) | Should -Be @('centralus', 'eastus')
        @($script:deploymentRegions) | Should -Be @('eastus')
        @($script:deploymentTokens) | Should -Be @('eastus')
        $outputs = Get-StepOutput
        ($outputs.deploymentOutput | ConvertFrom-Json).selectedRegion.value | Should -Be 'eastus'
        ($messages | Out-String) | Should -Not -Match 'secret-value-not-for-logs'
        Should -Invoke Get-AzResourceProvider -Times 2 -Exactly -ParameterFilter { $ProviderNamespace -eq 'Microsoft.DevTestLab' }
        Should -Invoke Set-AzContext -Times 3 -Exactly -ParameterFilter { $Subscription -eq '11111111-1111-1111-1111-111111111111' }

        $null = Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            $SubscriptionId -eq '11111111-1111-1111-1111-111111111111' -and
            $ManagementGroupId -eq 'test-management-group' -and
            $DeploymentNames.Count -eq 1 -and $DeploymentNames[0] -eq $script:deploymentNames[0]
        }
    }

    It 'Runs at most three existing same-region deployment attempts after regional validation, not per candidate' {
        Mock New-AzSubscriptionDeployment {
            $script:deploymentRegions.Add($resourceLocation)
            $script:deploymentNames.Add($DeploymentName)
            if ($script:deploymentRegions.Count -lt 3) { throw 'Deployment-stage regional capacity failure' }
            @{ ProvisioningState = 'Succeeded'; Outputs = @{} }
        }
        Invoke-ValidationAndDeployment

        @($script:validationRegions) | Should -Be @('centralus', 'eastus')
        @($script:deploymentRegions) | Should -Be @('eastus', 'eastus', 'eastus')
        @((Get-StepOutput).deploymentNames | ConvertFrom-Json).Count | Should -Be 3
        Should -Invoke Start-Sleep -Times 2 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 2 -Exactly
    }

    It 'Preserves deployment names for cleanup when all same-region deployment attempts fail' {
        Mock New-AzSubscriptionDeployment {
            $script:deploymentRegions.Add($resourceLocation)
            throw 'Deployment failure'
        }
        { Invoke-ValidationAndDeployment } | Should -Throw '*Deployment failure*'
        $outputs = Get-StepOutput
        @($outputs.deploymentNames | ConvertFrom-Json).Count | Should -Be 3
        @($script:deploymentRegions) | Should -Be @('eastus', 'eastus', 'eastus')
        $null = Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter { $DeploymentNames.Count -eq 3 }
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Never deploys after <failure> validation' -ForEach @(
        @{ failure = 'exhausted regional'; permanent = $false }
        @{ failure = 'permanent'; permanent = $true }
    ) {
        Mock Test-AzSubscriptionDeployment {
            if ($permanent) { @{ Code = 'AuthorizationFailed'; Message = 'Forbidden' } } else { $script:regionalFailure }
        }
        { Invoke-ValidationAndDeployment } | Should -Throw '*Template is not valid*'
        Should -Invoke Test-AzSubscriptionDeployment -Times ($permanent ? 1 : 3) -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
        (Get-StepOutput).ContainsKey('resourceLocation') | Should -BeFalse
    }

    It 'Propagates cleanup failure without validation or deployment retry' {
        Invoke-ValidationAndDeployment
        $outputs = Get-StepOutput
        Mock Initialize-DeploymentRemoval { throw 'Cleanup failed' }
        { Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*Cleanup failed*'
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Does not retry a cancelled deployment or start another regional validation' {
        Mock New-AzSubscriptionDeployment { throw [System.OperationCanceledException]::new('Deployment cancelled') }
        { Invoke-ValidationAndDeployment } | Should -Throw '*Deployment cancelled*'
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Keeps customLocation pinned through validation, deployment and token replacement' {
        Invoke-ValidationAndDeployment -CustomLocation 'eastus'
        @($script:validationRegions) | Should -Be @('eastus')
        @($script:deploymentRegions) | Should -Be @('eastus')
        @($script:deploymentTokens) | Should -Be @('eastus')
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'Preserves local resource-location tokens as pins instead of replacing them with a random region' {
        $env:localToken_resourceLocation = 'eastus'
        Invoke-ValidationAndDeployment
        @($script:validationRegions) | Should -Be @('eastus')
        @($script:deploymentTokens) | Should -Be @('eastus')
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'Preserves custom resource-location tokens as pins' {
        Invoke-ValidationAndDeployment -CustomTokensInput '{"resourceLocation":"eastus"}'
        @($script:validationRegions) | Should -Be @('eastus')
        @($script:deploymentTokens) | Should -Be @('eastus')
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'Refuses deployment without a successful validation output' {
        { Invoke-DeploymentStep -Name 'Deploy template file' } | Should -Throw '*validated resource location is missing*'
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Keeps cleanup and post-deployment tests outside regional retry with the existing retention condition' {
        $cleanup = $action.runs.steps | Where-Object { $_.name -eq 'Remove deployed resources' }
        $cleanup.if | Should -Be '${{ (success() || failure()) && inputs.removeDeployment == ''true'' && steps.deploy_step.outputs.deploymentNames != '''' && env.skip_deployment_ci == ''false'' }}'
        $deployment = $action.runs.steps | Where-Object { $_.name -eq 'Deploy template file' }
        $deployment.ContainsKey('continue-on-error') | Should -BeFalse
        @($action.runs.steps | Where-Object { $_.name -eq 'Run post-deployment Pester tests' }).Count | Should -Be 1
    }
}
