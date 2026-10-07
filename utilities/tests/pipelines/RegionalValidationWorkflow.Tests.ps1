param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Regional validation workflow runtime integration' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Invoke-TemplateDeploymentWithRetry.ps1')
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
            param(
                [string] $TemplateFilePath, [string[]] $DeploymentNames, [string[]] $PreflightRejectedDeploymentNames,
                [string[]] $PendingDeletionDeploymentIds,
                [string] $ManagementGroupId, [string] $SubscriptionId, [string] $ResourceGroupName,
                [switch] $RequireCompleteRemoval, [switch] $RequireNoDeploymentScripts
            )
            throw 'Unexpected Azure cleanup.'
        }
        function Get-AzContext {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure context lookup.'
        }
        function Get-AzDeployment {
            [CmdletBinding()]
            param([string] $Name, [object] $DefaultProfile)
            throw 'Unexpected Azure deployment lookup.'
        }
        function Get-AzDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName)
            throw 'Unexpected Azure operation lookup.'
        }
        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param([string] $Method, [string] $Path)
            throw 'Unexpected Azure REST request.'
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
            $script = $script -replace "(?m)^.*\. \(Join-Path.*'resourceDeployment'.*\)\r?\n", ''
            if ($Name -eq 'Remove deployed resources') {
                $script = $script -replace "(?m)^.*\. \(Join-Path.*'resourceRemoval'.*\)\r?\n", ''
            }
            $script = $script.Replace(
                'Join-Path $env:GITHUB_WORKSPACE ''${{ inputs.templateFilePath }}''',
                "'{0}'" -f $templatePath.Replace("'", "''")
            )
            $values = @{
                '${{ inputs.modulePath }}'                                          = 'avm/res/retry-test/widget'
                '${{ inputs.customLocation }}'                                      = $CustomLocation
                '${{ inputs.removeDeployment }}'                                    = 'true'
                '${{ inputs.customTokens }}'                                        = $CustomTokensInput
                '${{  inputs.customTokens }}'                                       = $CustomTokensInput
                '${{ inputs.managementGroupId }}'                                   = 'test-management-group'
                '${{ inputs.deploymentMetadataLocation }}'                          = 'WestEurope'
                '${{ env.VALIDATE_TENANT_ID }}'                                     = 'test-tenant'
                '${{ env.TOKEN_NAMEPREFIX }}'                                       = 'testprefix'
                '${{ steps.get-test-subscription.outputs.subscriptionId }}'         = '11111111-1111-1111-1111-111111111111'
                '${{ steps.replace-tokens.outputs.resourceLocation }}'              = $Outputs.tokenLocation ?? ''
                '${{ steps.deploy_step.outputs.remainingDeploymentNames }}'         = $Outputs.remainingDeploymentNames ?? ''
                '${{ steps.deploy_step.outputs.deploymentNames }}'                  = $Outputs.deploymentNames ?? ''
                '${{ steps.deploy_step.outputs.preflightRejectedDeploymentNames }}' = $Outputs.preflightRejectedDeploymentNames ?? ''
                '${{ steps.deploy_step.outputs.pendingDeletionDeploymentIds }}'     = $Outputs.pendingDeletionDeploymentIds ?? ''
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
            $null = Invoke-DeploymentStep -Name 'Deploy template file' -CustomLocation $CustomLocation -Outputs @{ tokenLocation = $tokenLocation }
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
        '{"Microsoft.RetryTest":{"widgets":{}}}' | Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
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
        $script:operationError = @{ error = @{ code = 'InvalidTemplate'; message = 'Nonregional failure.' } }
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
                        @{ ResourceTypeName = 'widgets'; Locations = @('Central US', 'East US', 'Korea Central', 'West Europe') }
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
        Mock Get-AzContext { @{ Subscription = @{ Id = '11111111-1111-1111-1111-111111111111' } } }
        Mock Get-AzDeployment { @{ DeploymentName = $Name; ProvisioningState = 'Failed' } }
        Mock Get-AzDeploymentOperation {
            @{ ProvisioningState = 'Failed'; StatusMessage = 'Nonregional failure. (Code: InvalidTemplate)' }
        }
        Mock Invoke-AzRestMethod {
            $Method | Should -Be 'GET'
            $Path | Should -Match '^/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/[^/]+/operations\?api-version=2025-04-01$'
            @{
                StatusCode = 200
                Content    = ConvertTo-Json -Depth 10 -InputObject @{ value = @(
                        @{ properties = @{ provisioningState = 'Failed'; provisioningOperation = 'Create'; statusMessage = $script:operationError } }
                    )
                }
            }
        }
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
        Should -Invoke Get-AzResourceProvider -Times 2 -Exactly -ParameterFilter { $ProviderNamespace -eq 'Microsoft.RetryTest' }
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
            if ($script:deploymentRegions.Count -lt 3) {
                throw "The deployment '$DeploymentName' failed with error(s). (Code: DeploymentFailed) Inner error: Deployment-stage regional capacity failure"
            }
            @{ ProvisioningState = 'Succeeded'; Outputs = @{} }
        }
        Invoke-ValidationAndDeployment

        @($script:validationRegions) | Should -Be @('centralus', 'eastus')
        @($script:deploymentRegions) | Should -Be @('eastus', 'eastus', 'eastus')
        @((Get-StepOutput).deploymentNames | ConvertFrom-Json).Count | Should -Be 3
        Should -Invoke Start-Sleep -Times 2 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 2 -Exactly
    }

    It 'Cleans a late regional failure before validating another region and only leaves the new attempt for final cleanup' {
        $script:trace = [System.Collections.Generic.List[string]]::new()
        $script:baseTimes = [System.Collections.Generic.List[string]]::new()
        $script:clock = [datetime]::new(2026, 10, 3, 8, 51, 48)
        Mock Get-Date {
            $script:clock = $script:clock.AddSeconds(1)
            if ($Format) { $script:clock.ToString($Format) } else { $script:clock }
        }
        Mock Test-AzSubscriptionDeployment {
            $script:trace.Add("validate:$resourceLocation")
            $script:baseTimes.Add($baseTime)
            $script:validationRegions.Add($resourceLocation)
            ConvertFrom-SecureString -SecureString $adminSecret -AsPlainText | Should -Be 'secret-value-not-for-logs'
        }
        Mock New-AzSubscriptionDeployment {
            $script:trace.Add("deploy:$resourceLocation")
            $script:baseTimes.Add($baseTime)
            $script:deploymentRegions.Add($resourceLocation)
            $script:deploymentNames.Add($DeploymentName)
            $content = Get-Content -LiteralPath $TemplateFile -Raw | ConvertFrom-Json
            $content.variables.regionToken | Should -Be $resourceLocation
            $content.variables.subscriptionToken | Should -Be '11111111-1111-1111-1111-111111111111'
            ConvertFrom-SecureString -SecureString $adminSecret -AsPlainText | Should -Be 'secret-value-not-for-logs'
            if ($script:deploymentNames.Count -eq 1) {
                throw "08:51:48 - The deployment '$DeploymentName' failed with error(s). Status Message: Nested deployment preflight failed. (Code: InvalidTemplateDeployment) ExampleSku is unavailable in location centralus. (Code:SkuNotAvailable)"
            }
            @{ ProvisioningState = 'Succeeded'; Outputs = @{ selectedRegion = @{ Type = 'String'; Value = $resourceLocation } } }
        }
        $script:operationError = @{ error = @{ code = 'ResourceDeploymentFailure'; details = @(
                    @{ code = 'SkuNotAvailable'; message = 'ExampleSku is not available in location centralus.' }
                )
            }
        }
        Mock Initialize-DeploymentRemoval {
            if ($RequireCompleteRemoval) {
                $script:trace.Add('cleanup')
                $DeploymentNames | Should -Be @($script:deploymentNames[0])
                return @{ RemovedDeploymentNames = @($DeploymentNames) }
            }
        }

        $messages = Invoke-ValidationAndDeployment 3>&1 4>&1
        @($script:trace) | Should -Be @('validate:centralus', 'deploy:centralus', 'cleanup', 'validate:eastus', 'deploy:eastus')
        @($script:baseTimes | Select-Object -Unique).Count | Should -Be 1
        $script:baseTimes.Count | Should -Be 4
        ($messages | Out-String) | Should -Not -Match 'secret-value-not-for-logs'
        $outputs = Get-StepOutput
        @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:deploymentNames)
        @($outputs.remainingDeploymentNames | ConvertFrom-Json) | Should -Be @($script:deploymentNames[1])
        ($outputs.deploymentOutput | ConvertFrom-Json).selectedRegion.value | Should -Be 'eastus'
        $outputs.resourceLocation | Should -Be 'eastus'

        $null = Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter { $RequireCompleteRemoval }
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            -not $RequireCompleteRemoval -and $DeploymentNames.Count -eq 1 -and $DeploymentNames[0] -eq $script:deploymentNames[1]
        }
    }

    It 'Skips final removal when the failed attempt was cleaned but no new eligible region exists' {
        Mock Test-AzSubscriptionDeployment {}
        Mock Get-AzResourceProvider {
            if ($ProviderNamespace) {
                @{ RegistrationState = 'NotRegistered'; ResourceTypes = @(@{ ResourceTypeName = 'widgets'; Locations = @('Central US') }) }
            }
        }
        Mock New-AzSubscriptionDeployment {
            $script:deploymentNames.Add($DeploymentName)
            throw "The deployment '$DeploymentName' failed with error(s). (Code: InvalidTemplateDeployment) Regional capacity failure."
        }
        $script:operationError = @{ error = @{ code = 'SkuNotAvailable'; message = 'The SKU is not available in location centralus.' } }
        Mock Initialize-DeploymentRemoval { @{ RemovedDeploymentNames = @($DeploymentNames) } }

        { Invoke-ValidationAndDeployment } | Should -Throw '*Regional capacity failure*'
        $outputs = Get-StepOutput
        @($outputs.deploymentNames | ConvertFrom-Json).Count | Should -Be 1
        @($outputs.remainingDeploymentNames | ConvertFrom-Json).Count | Should -Be 0
        $null = Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter { $RequireCompleteRemoval }
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly -ParameterFilter { -not $RequireCompleteRemoval }
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Retains failed cleanup names for the final action instead of deploying again' {
        Mock Test-AzSubscriptionDeployment {}
        Mock New-AzSubscriptionDeployment {
            $script:deploymentNames.Add($DeploymentName)
            throw "The deployment '$DeploymentName' failed with error(s). (Code: InvalidTemplateDeployment) Regional capacity failure."
        }
        $script:operationError = @{ error = @{ code = 'SkuNotAvailable'; message = 'The SKU is not available in location centralus.' } }
        Mock Initialize-DeploymentRemoval {
            if ($RequireCompleteRemoval) { throw 'Removal still pending.' }
        }

        { Invoke-ValidationAndDeployment } | Should -Throw '*Removal still pending*'
        $outputs = Get-StepOutput
        @($outputs.remainingDeploymentNames | ConvertFrom-Json) | Should -Be @($script:deploymentNames)
        $null = Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter { $RequireCompleteRemoval }
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            -not $RequireCompleteRemoval -and $DeploymentNames.Count -eq 1 -and $DeploymentNames[0] -eq $script:deploymentNames[0]
        }
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Passes accepted history deletions to final cleanup without claiming the deployment was removed' -Tag 'HistoryRemoval' {
        Mock Test-AzSubscriptionDeployment {}
        Mock New-AzSubscriptionDeployment {
            $script:deploymentNames.Add($DeploymentName)
            throw "The deployment '$DeploymentName' failed with error(s). (Code: InvalidTemplateDeployment) Regional capacity failure."
        }
        $script:operationError = @{ error = @{ code = 'SkuNotAvailable'; message = 'The SKU is not available in location centralus.' } }
        Mock Initialize-DeploymentRemoval {
            if ($RequireCompleteRemoval) {
                $exception = [System.InvalidOperationException]::new('Deployment history deletion is still pending.')
                $exception.Data['PendingDeletionDeploymentIds'] = @(
                    "/subscriptions/$SubscriptionId/providers/Microsoft.Resources/deployments/$($DeploymentNames[0])"
                )
                throw $exception
            }
        }

        { Invoke-ValidationAndDeployment } | Should -Throw '*Regional capacity failure*'
        $outputs = Get-StepOutput
        $pendingId = "/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/$($script:deploymentNames[0])"
        @($outputs.pendingDeletionDeploymentIds | ConvertFrom-Json) | Should -Be @($pendingId)
        @($outputs.remainingDeploymentNames | ConvertFrom-Json) | Should -Be @($script:deploymentNames)
        $null = Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            -not $RequireCompleteRemoval -and $PendingDeletionDeploymentIds.Count -eq 1 -and
            $PendingDeletionDeploymentIds[0] -eq $pendingId -and $DeploymentNames[0] -eq $script:deploymentNames[0]
        }
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Rejects <kind> pending history output before final cleanup' -Tag 'HistoryRemoval' -ForEach @(
        @{ kind = 'a scalar'; pending = '"owned"'; remaining = '["owned"]' }
        @{ kind = 'an object'; pending = '{}'; remaining = '["owned"]' }
        @{ kind = 'a null ID'; pending = '[null]'; remaining = '["owned"]' }
        @{ kind = 'a blank ID'; pending = '[" "]'; remaining = '["owned"]' }
        @{ kind = 'an ownerless ID'; pending = '["/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/owned"]'; remaining = '[]' }
    ) {
        $outputs = @{
            deploymentNames = '["owned"]'
            remainingDeploymentNames = $remaining
            pendingDeletionDeploymentIds = $pending
        }
        { Invoke-DeploymentStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*pending*deletion*metadata*'
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
    }

    It 'Preserves deployment names for cleanup when all same-region deployment attempts fail' {
        Mock New-AzSubscriptionDeployment {
            $script:deploymentRegions.Add($resourceLocation)
            throw "The deployment '$DeploymentName' failed with error(s). (Code: DeploymentFailed) Inner error: Deployment failure"
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

    It 'Refuses deployment when the combined step cannot validate' {
        Mock Test-AzSubscriptionDeployment { @{ Code = 'InvalidTemplate'; Message = 'Validation failed' } }
        { Invoke-DeploymentStep -Name 'Deploy template file' } | Should -Throw '*Template is not valid*'
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
