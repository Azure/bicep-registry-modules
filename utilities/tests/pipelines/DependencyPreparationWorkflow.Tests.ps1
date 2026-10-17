param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Dependency preparation deployment orchestration' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Invoke-TemplateDeploymentWithPreparation.ps1')

        function New-PreparationTestResult {
            param ([string] $Name)

            return @{
                deploymentNames                  = @($Name)
                remainingDeploymentNames         = @($Name)
                preflightRejectedDeploymentNames = @()
                pendingDeletionDeploymentIds     = @()
                DeploymentAttempts               = 1
                ResourceLocation                 = 'eastus'
                deploymentOutput                 = @{ secret = 'never-publish-this-value' }
            }
        }

        function Get-PreparationTestOutput {
            $values = @{}
            foreach ($line in (Get-Content -LiteralPath $outputPath)) {
                $parts = $line.Split('=', 2)
                $values[$parts[0]] = ConvertFrom-Json -InputObject $parts[1] -NoEnumerate
            }
            return $values
        }
    }

    BeforeEach {
        $outputPath = Join-Path $TestDrive 'github-output.txt'
        Set-Content -LiteralPath $outputPath -Value '' -NoNewline
        $templateParameters = @{
            dependenciesOnly = @{ type = 'bool'; defaultValue = $false }
            resourceLocation = @{ type = 'string' }
        }
        $retryInput = @{
            TemplateInput = @{
                TemplateFilePath           = 'fixture.test.bicep'
                DeploymentMetadataLocation = 'westeurope'
                SubscriptionId             = '11111111-1111-1111-1111-111111111111'
                ManagementGroupId          = 'selected-management-group'
                RepoRoot                   = $repoRootPath
                AdditionalParameters       = @{
                    baseTime         = '2026-10-17 01:23:45Z'
                    namePrefix       = 'selected-prefix'
                    resourceLocation = 'eastus'
                    adminSecret      = 'never-publish-this-value'
                }
            }
            ModuleRoot            = 'avm\res\net-app\net-app-account'
            CustomLocation        = 'eastus'
            TokenResourceLocation = 'eastus'
            RemoveDeployment      = $true
            DoNotThrow            = $true
            ProtectedResourceIds  = @('/subscriptions/selected/protected-resource')
        }
        $invokeInput = @{
            RetryInput           = $retryInput
            PreparationParameter = 'dependenciesOnly'
            TemplateParameters   = $templateParameters
            GitHubOutputPath     = $outputPath
        }
        $script:preparationResult = New-PreparationTestResult -Name 'preparation-root'
        $script:deploymentResult = New-PreparationTestResult -Name 'final-root'
        $script:calls = [System.Collections.Generic.List[object]]::new()
        $script:events = [System.Collections.Generic.List[string]]::new()
        Mock Invoke-TemplateDeploymentWithRetry {
            $script:calls.Add(@{
                    TemplateInput         = $TemplateInput
                    ModuleRoot            = $ModuleRoot
                    CustomLocation        = $CustomLocation
                    TokenResourceLocation = $TokenResourceLocation
                    RemoveDeployment      = $RemoveDeployment
                    DoNotThrow            = [bool] $DoNotThrow
                    ProtectedResourceIds  = $ProtectedResourceIds
                })
            if ($script:calls.Count -eq 1) {
                $script:events.Add('preparation')
                return $script:preparationResult
            }
            $published = Get-PreparationTestOutput
            $published.deploymentNames | Should -Be @('preparation-root')
            $script:events.Add('deployment')
            return $script:deploymentResult
        }
        Mock Start-Sleep {
            $published = Get-PreparationTestOutput
            $published.deploymentNames | Should -Be @('preparation-root')
            $published.remainingDeploymentNames | Should -Be @('preparation-root')
            $published.deploymentAttempts | Should -Be 1
            $script:events.Add('wait')
        }
    }

    It 'delegates without preparation or validation when no preparation parameter is supplied' {
        $result = Invoke-TemplateDeploymentWithPreparation -RetryInput $retryInput -GitHubOutputPath 'not-an-absolute-path'

        [object]::ReferenceEquals($result, $script:preparationResult) | Should -BeTrue
        [object]::ReferenceEquals($script:calls[0].TemplateInput, $retryInput.TemplateInput) | Should -BeTrue
        $script:calls[0].RemoveDeployment | Should -BeTrue
        $script:calls[0].DoNotThrow | Should -BeTrue
        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Get-Content -LiteralPath $outputPath -Raw | Should -BeNullOrEmpty
    }

    It 'preserves selected scope, location, naming and caller inputs across both phases' {
        $original = ConvertTo-Json -InputObject $retryInput -Depth 10
        $originalDefinitions = ConvertTo-Json -InputObject $templateParameters -Depth 10
        $result = Invoke-TemplateDeploymentWithPreparation @invokeInput

        $script:calls.Count | Should -Be 2
        foreach ($call in $script:calls) {
            $call.TemplateInput.SubscriptionId | Should -Be $retryInput.TemplateInput.SubscriptionId
            $call.TemplateInput.ManagementGroupId | Should -Be 'selected-management-group'
            $call.TemplateInput.DeploymentMetadataLocation | Should -Be 'westeurope'
            $call.TemplateInput.TemplateFilePath | Should -Be 'fixture.test.bicep'
            $call.TemplateInput.RepoRoot | Should -Be $repoRootPath
            $call.TemplateInput.AdditionalParameters.baseTime | Should -Be '2026-10-17 01:23:45Z'
            $call.TemplateInput.AdditionalParameters.namePrefix | Should -Be 'selected-prefix'
            $call.TemplateInput.AdditionalParameters.resourceLocation | Should -Be 'eastus'
            $call.CustomLocation | Should -Be 'eastus'
            $call.TokenResourceLocation | Should -Be 'eastus'
            $call.ModuleRoot | Should -Be $retryInput.ModuleRoot
            $call.ProtectedResourceIds | Should -Be $retryInput.ProtectedResourceIds
            [object]::ReferenceEquals($call.TemplateInput, $retryInput.TemplateInput) | Should -BeFalse
            [object]::ReferenceEquals($call.TemplateInput.AdditionalParameters, $retryInput.TemplateInput.AdditionalParameters) | Should -BeFalse
        }
        $script:calls[0].TemplateInput.AdditionalParameters.dependenciesOnly | Should -BeTrue
        $script:calls[1].TemplateInput.AdditionalParameters.dependenciesOnly | Should -BeFalse
        $script:calls[0].RemoveDeployment | Should -BeFalse
        $script:calls[1].RemoveDeployment | Should -BeTrue
        $script:events | Should -Be @('preparation', 'wait', 'deployment')
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
        (ConvertTo-Json -InputObject $retryInput -Depth 10) | Should -BeExactly $original
        (ConvertTo-Json -InputObject $templateParameters -Depth 10) | Should -BeExactly $originalDefinitions
        $result.deploymentNames | Should -Be @('preparation-root', 'final-root')
        [object]::ReferenceEquals($result.deploymentOutput, $script:deploymentResult.deploymentOutput) | Should -BeTrue
        $result.ResourceLocation | Should -Be 'eastus'
    }

    It 'keeps the caller retention and throwing settings for the final phase' {
        $retryInput.RemoveDeployment = $false
        $retryInput.DoNotThrow = $false

        $null = Invoke-TemplateDeploymentWithPreparation @invokeInput

        $script:calls[0].RemoveDeployment | Should -BeFalse
        $script:calls[0].DoNotThrow | Should -BeTrue
        $script:calls[1].RemoveDeployment | Should -BeFalse
        $script:calls[1].DoNotThrow | Should -BeFalse
    }

    It 'supports dictionary inputs without additional parameters and leaves their shape unchanged' {
        $retryInput.TemplateInput.Remove('AdditionalParameters')
        $invokeInput.RetryInput = [ordered] @{}
        foreach ($entry in $retryInput.GetEnumerator()) {
            $invokeInput.RetryInput[$entry.Key] = $entry.Value
        }

        $null = Invoke-TemplateDeploymentWithPreparation @invokeInput

        $script:calls[0].TemplateInput.AdditionalParameters.dependenciesOnly | Should -BeTrue
        $script:calls[1].TemplateInput.AdditionalParameters.dependenciesOnly | Should -BeFalse
        $retryInput.TemplateInput.ContainsKey('AdditionalParameters') | Should -BeFalse
    }

    It 'overrides a caller preparation value independently in each phase without mutation' {
        $retryInput.TemplateInput.AdditionalParameters.dependenciesOnly = $true

        $null = Invoke-TemplateDeploymentWithPreparation @invokeInput

        $script:calls[0].TemplateInput.AdditionalParameters.dependenciesOnly | Should -BeTrue
        $script:calls[1].TemplateInput.AdditionalParameters.dependenciesOnly | Should -BeFalse
        $retryInput.TemplateInput.AdditionalParameters.dependenciesOnly | Should -BeTrue
    }

    It 'pins an automatically selected preparation location for the real deployment' {
        $retryInput.CustomLocation = ''
        $retryInput.TokenResourceLocation = ''
        $retryInput.TemplateInput.AdditionalParameters.resourceLocation = ''

        $null = Invoke-TemplateDeploymentWithPreparation @invokeInput

        $script:calls[0].CustomLocation | Should -BeNullOrEmpty
        $script:calls[1].CustomLocation | Should -Be 'eastus'
        $retryInput.CustomLocation | Should -BeExactly ''
        $retryInput.TemplateInput.AdditionalParameters.resourceLocation | Should -BeExactly ''
    }

    It 'publishes only authoritative cleanup metadata before waiting or invoking the real phase' {
        $null = Invoke-TemplateDeploymentWithPreparation @invokeInput

        $published = Get-PreparationTestOutput
        @($published.Keys | Sort-Object) | Should -Be @(
            'deploymentAttempts', 'deploymentNames', 'pendingDeletionDeploymentIds',
            'preflightRejectedDeploymentNames', 'remainingDeploymentNames'
        )
        $published.preflightRejectedDeploymentNames | Should -HaveCount 0
        $published.pendingDeletionDeploymentIds | Should -HaveCount 0
        $content = Get-Content -LiteralPath $outputPath -Raw
        $content | Should -Not -Match 'never-publish-this-value|deploymentOutput|baseTime|adminSecret'
        $script:events | Should -Be @('preparation', 'wait', 'deployment')
    }

    It 'returns preparation failures with cleanup tracking and does not wait or run the real phase' {
        $script:preparationResult.exception = 'Preparation failed.'

        $result = Invoke-TemplateDeploymentWithPreparation @invokeInput

        [object]::ReferenceEquals($result, $script:preparationResult) | Should -BeTrue
        (Get-PreparationTestOutput).remainingDeploymentNames | Should -Be @('preparation-root')
        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'publishes preparation tracking before throwing when the caller requests throwing semantics' {
        $retryInput.DoNotThrow = $false
        $script:preparationResult.exception = 'Preparation failed.'

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*Preparation failed*'

        (Get-PreparationTestOutput).deploymentNames | Should -Be @('preparation-root')
        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'preserves the original preparation error record when throwing' {
        $retryInput.DoNotThrow = $false
        $script:preparationResult.exception = 'Preparation failed.'
        $script:preparationResult.ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Original preparation error.'),
            'PreparationFailed', [System.Management.Automation.ErrorCategory]::InvalidOperation, $null
        )

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*Original preparation error*'

        (Get-PreparationTestOutput).deploymentNames | Should -Be @('preparation-root')
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'uniquely merges every cleanup array and attempt count even after a final failure' {
        foreach ($name in @('deploymentNames', 'remainingDeploymentNames', 'preflightRejectedDeploymentNames', 'pendingDeletionDeploymentIds')) {
            $script:preparationResult[$name] = @('preparation-root', 'shared-root')
            $script:deploymentResult[$name] = @('shared-root', 'final-root')
        }
        $script:preparationResult.DeploymentAttempts = 2
        $script:deploymentResult.DeploymentAttempts = 3
        $script:deploymentResult.exception = 'Final deployment failed.'
        Mock Start-Sleep {}
        Mock Invoke-TemplateDeploymentWithRetry {
            if ($TemplateInput.AdditionalParameters.dependenciesOnly) { return $script:preparationResult }
            return $script:deploymentResult
        }

        $result = Invoke-TemplateDeploymentWithPreparation @invokeInput

        foreach ($name in @('deploymentNames', 'remainingDeploymentNames', 'preflightRejectedDeploymentNames', 'pendingDeletionDeploymentIds')) {
            $result[$name] | Should -Be @('preparation-root', 'shared-root', 'final-root')
            $script:deploymentResult[$name] | Should -Be @('shared-root', 'final-root')
        }
        $result.DeploymentAttempts | Should -Be 5
        $result.exception | Should -Be 'Final deployment failed.'
        $result.ResourceLocation | Should -Be 'eastus'
        [object]::ReferenceEquals($result.deploymentOutput, $script:deploymentResult.deploymentOutput) | Should -BeTrue
    }

    It 'retains published preparation tracking if the real coordinator throws unexpectedly' {
        Mock Invoke-TemplateDeploymentWithRetry {
            if ($TemplateInput.AdditionalParameters.dependenciesOnly) { return $script:preparationResult }
            throw 'Unexpected final failure.'
        }

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*Unexpected final failure*'

        (Get-PreparationTestOutput).deploymentNames | Should -Be @('preparation-root')
    }

    It 'does not suppress an unhandled preparation error' {
        Mock Invoke-TemplateDeploymentWithRetry { throw 'Unhandled preparation error.' }

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*Unhandled preparation error*'

        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'does not continue when cleanup output cannot be persisted' {
        Mock Add-Content { throw 'Output write failed.' }

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*Output write failed*'

        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'keeps preparation tracking when the runner wait fails and does not start the real phase' {
        Mock Start-Sleep { throw 'Runner wait interrupted.' }

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*Runner wait interrupted*'

        (Get-PreparationTestOutput).deploymentNames | Should -Be @('preparation-root')
        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
    }

    It 'rejects an invalid preparation declaration: <Label>' -ForEach @(
        @{ Label = 'missing'; Definition = $null }
        @{ Label = 'wrong type'; Definition = @{ type = 'string'; defaultValue = $false } }
        @{ Label = 'array type'; Definition = @{ type = @('bool'); defaultValue = $false } }
        @{ Label = 'missing default'; Definition = @{ type = 'bool' } }
        @{ Label = 'enabled default'; Definition = @{ type = 'bool'; defaultValue = $true } }
        @{ Label = 'string default'; Definition = @{ type = 'bool'; defaultValue = 'false' } }
    ) {
        $templateParameters.dependenciesOnly = $Definition

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*declared ARM bool*'

        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 0 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'rejects a GitHub output path that is <Label>' -ForEach @(
        @{ Label = 'relative'; Path = 'github-output.txt' }
        @{ Label = 'missing'; Path = '' }
        @{ Label = 'nonexistent'; Path = 'missing' }
        @{ Label = 'a directory'; Path = 'directory' }
    ) {
        $invokeInput.GitHubOutputPath = switch ($Path) {
            'missing' { Join-Path $TestDrive 'nonexistent.txt' }
            'directory' { $TestDrive }
            default { $Path }
        }

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*absolute path to an existing*'

        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 0 -Exactly
    }

    It 'fails closed for malformed preparation tracking: <Label>' -ForEach @(
        @{ Label = 'missing array'; Field = 'deploymentNames'; Value = $null }
        @{ Label = 'scalar array'; Field = 'remainingDeploymentNames'; Value = 'root' }
        @{ Label = 'null array entry'; Field = 'preflightRejectedDeploymentNames'; Value = @($null) }
        @{ Label = 'empty array entry'; Field = 'pendingDeletionDeploymentIds'; Value = @('') }
        @{ Label = 'non-string array entry'; Field = 'deploymentNames'; Value = @(42) }
        @{ Label = 'missing count'; Field = 'DeploymentAttempts'; Value = $null }
        @{ Label = 'negative count'; Field = 'DeploymentAttempts'; Value = -1 }
        @{ Label = 'string count'; Field = 'DeploymentAttempts'; Value = '1' }
    ) {
        if ($null -eq $Value) {
            $script:preparationResult.Remove($Field)
        } else {
            $script:preparationResult[$Field] = $Value
        }

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*authoritative*'

        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Get-Content -LiteralPath $outputPath -Raw | Should -BeNullOrEmpty
    }

    It 'fails closed when preparation returns no dictionary' {
        $script:preparationResult = 'not-a-result'

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*authoritative cleanup tracking*'

        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'fails closed when successful preparation omits the selected location' {
        $script:preparationResult.Remove('ResourceLocation')

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*selected resource location*'

        (Get-PreparationTestOutput).deploymentNames | Should -Be @('preparation-root')
        Should -Invoke Invoke-TemplateDeploymentWithRetry -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'fails closed for malformed final tracking without losing published preparation tracking' {
        $script:deploymentResult.remainingDeploymentNames = 'not-an-array'

        { Invoke-TemplateDeploymentWithPreparation @invokeInput } | Should -Throw '*authoritative cleanup tracking*'

        (Get-PreparationTestOutput).deploymentNames | Should -Be @('preparation-root')
    }
}
