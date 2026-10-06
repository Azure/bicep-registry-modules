param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Deployment submission and cleanup runtime integration' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'New-TemplateDeployment.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'Initialize-DeploymentRemoval.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Get-DeploymentTargetResourceList.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-CIParameterMap.ps1')
        $actionPath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $actionPath -Raw)
        $environmentNames = @('GITHUB_WORKSPACE', 'GITHUB_OUTPUT', 'AVM_CI_VARIABLES', 'AVM_CI_SECRETS', 'CI_KEY_VAULT_NAME')
        $subscriptionId = '11111111-1111-1111-1111-111111111111'
        $resourceGroupId = "/subscriptions/$subscriptionId/resourceGroups/dep-fixture-rg"
        $resourceIds = @(
            $resourceGroupId
            "$resourceGroupId/providers/Microsoft.Compute/diskEncryptionSets/dep-fixture-des"
            "$resourceGroupId/providers/Microsoft.KeyVault/vaults/dep-fixture-kv"
            "$resourceGroupId/providers/Microsoft.KeyVault/vaults/dep-fixture-kv/keys/encryptionKey"
            "$resourceGroupId/providers/Microsoft.KeyVault/vaults/dep-fixture-kv/providers/Microsoft.Authorization/roleAssignments/kv-reader"
            "$resourceGroupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-fixture-msi"
            "$resourceGroupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-fixture-msi/providers/Microsoft.Authorization/roleAssignments/msi-reader"
            "$resourceGroupId/providers/Microsoft.Network/virtualNetworks/dep-fixture-vnet"
            "$resourceGroupId/providers/Microsoft.Storage/storageAccounts/depfixturestorage"
        )
        $script:fixtureResourceIds = $resourceIds

        function Set-TestTemplateScope {
            param([string] $Scope = 'subscription')
            $schemas = @{
                resourcegroup   = 'deploymentTemplate'
                subscription    = 'subscriptionDeploymentTemplate'
                managementgroup = 'managementGroupDeploymentTemplate'
                tenant          = 'tenantDeploymentTemplate'
            }
            @{
                '$schema'  = "https://schema.management.azure.com/schemas/2019-08-01/$($schemas[$Scope]).json#"
                parameters = @{
                    resourceLocation = @{ type = 'string' }
                    baseTime         = @{ type = 'string' }
                    adminSecret      = @{ type = 'secureString' }
                }
            } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        }

        function New-TestPreflightError {
            param([string] $Name, [string] $Format = 'Az')
            $message = "The template deployment '$Name' is not valid according to the validation procedure. The following resource provider(s) - 'Microsoft.Storage/storageAccounts (2025-01-01)' reported preflight validation errors. See inner errors for details."
            $record = [System.Management.Automation.ErrorRecord]::new(
                [System.InvalidOperationException]::new("21:07:10 - Error: Code=InvalidTemplateDeployment; Message=$message"),
                'DeploymentSubmissionFailed',
                [System.Management.Automation.ErrorCategory]::InvalidOperation,
                $null
            )
            if ($Format -eq 'Json') {
                $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new(
                    (@{ error = @{
                            code    = 'InvalidTemplateDeployment'
                            message = $message
                            details = @(@{ code = 'StorageAccountAlreadyTaken'; message = 'The name is already taken.' })
                        }
                    } | ConvertTo-Json -Depth 5 -Compress)
                )
            } elseif ($Format -eq 'AzErrorDetails') {
                $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($record.Exception.Message)
            }
            return $record
        }

        function New-TestOperationsResponse {
            param([string[]] $Ids = @(), [string[]] $ReadIds = @())
            $operations = @(
                foreach ($id in $Ids) {
                    @{ properties = @{ provisioningOperation = 'Create'; targetResource = @{ id = $id } } }
                }
                foreach ($id in $ReadIds) {
                    @{ properties = @{ provisioningOperation = 'Read'; targetResource = @{ id = $id } } }
                }
            )
            return @{ StatusCode = 200; Content = (@{ value = $operations } | ConvertTo-Json -Depth 6 -Compress) }
        }

        function Get-TestRequestTimeout {
            param([string] $Format = 'Direct')
            $timeout = [System.Threading.Tasks.TaskCanceledException]::new(
                'The request was canceled due to the configured HttpClient.Timeout of 100 seconds elapsing.',
                [System.TimeoutException]::new('The operation was canceled.', [System.Threading.Tasks.TaskCanceledException]::new('The operation was canceled.'))
            )
            $record = [System.Management.Automation.ErrorRecord]::new(
                $timeout, 'HttpClientTimeout', [System.Management.Automation.ErrorCategory]::OperationStopped, $null
            )
            switch ($Format) {
                'Direct' { return $timeout }
                'InnerException' { return [System.InvalidOperationException]::new($timeout.Message, $timeout) }
                'ErrorRecord' { return $record }
                'RuntimeException' { return [System.Management.Automation.RuntimeException]::new($timeout.Message, $null, $record) }
                'WriteError' {
                    try {
                        Write-Error -ErrorRecord $record -ErrorAction Stop
                    } catch {
                        return $_
                    }
                }
                default { throw "Unknown timeout fixture format [$Format]." }
            }
        }

        function Invoke-TestSubmission {
            param([string] $Name, [string] $ResourceLocation, [string] $BaseTime, [securestring] $AdminSecret)
            $script:attemptNames.Add($Name)
            $script:attemptRegions.Add($ResourceLocation)
            $script:attemptBaseTimes.Add($BaseTime)
            ConvertFrom-SecureString -SecureString $AdminSecret -AsPlainText | Should -Be 'test-only-secret-not-for-logs'
            switch ($script:outcomes[$script:attemptNames.Count - 1]) {
                'Preflight' { throw (New-TestPreflightError -Name $Name -Format $script:preflightFormat) }
                'PartialFailure' {
                    throw "21:06:59 - The deployment '$Name' failed with error(s). (Code: DeploymentFailed) Inner error: StorageAccountAlreadyTaken. InvalidTemplateDeployment: reported preflight validation errors."
                }
                'DetailedFailure' { throw ($script:detailedFailureMessage -f $Name) }
                'FailedResult' { return @{ ProvisioningState = 'Failed'; Outputs = @{} } }
                'NoResult' { return }
                'Running' { return @{ ProvisioningState = 'Running'; Outputs = @{} } }
                'MissingState' { return @{ Outputs = @{} } }
                'Unknown' { throw 'The submission outcome is unknown: connection interrupted.' }
                'RequestTimeout' { throw (Get-TestRequestTimeout -Format $script:timeoutFormat) }
                'EmptyTimeout' { throw [System.Threading.Tasks.TaskCanceledException]::new('', (Get-TestRequestTimeout).InnerException) }
                'TransportFailure' { throw [System.Net.Http.HttpRequestException]::new('The submission outcome is unknown: connection interrupted.') }
                'AuthenticationFailure' {
                    throw [System.UnauthorizedAccessException]::new('The submission outcome is unknown: authentication failed. (Code: DeploymentFailed)')
                }
                'Cancelled' { throw [System.OperationCanceledException]::new('Deployment cancelled') }
                'TaskCancelled' { throw [System.Threading.Tasks.TaskCanceledException]::new('Deployment cancelled') }
                'TimeoutWordingOnly' {
                    throw [System.OperationCanceledException]::new('The request was canceled due to the configured HttpClient.Timeout of 100 seconds elapsing.')
                }
                'WrappedCancellation' {
                    throw [System.InvalidOperationException]::new('Submission stopped', [System.OperationCanceledException]::new('Deployment cancelled'))
                }
                'RecordCancellation' {
                    $record = [System.Management.Automation.ErrorRecord]::new(
                        [System.OperationCanceledException]::new('Deployment cancelled'),
                        'Cancelled', [System.Management.Automation.ErrorCategory]::OperationStopped, $null
                    )
                    throw [System.Management.Automation.RuntimeException]::new('Submission stopped', $null, $record)
                }
                'MixedCancellation' {
                    throw [System.AggregateException]::new(
                        [System.Exception[]] @((Get-TestRequestTimeout), [System.OperationCanceledException]::new('Deployment cancelled'))
                    )
                }
                'Succeeded' { return @{ ProvisioningState = 'Succeeded'; Outputs = @{} } }
                default { throw 'Unexpected extra deployment attempt.' }
            }
        }

        function Get-TestActionScript {
            param([string] $Name, [hashtable] $Outputs = @{})
            $stepScript = ($action.runs.steps | Where-Object { $_.name -eq $Name }).with.inlineScript
            $stepScript = $stepScript.Replace(
                'Join-Path $env:GITHUB_WORKSPACE ''${{ inputs.templateFilePath }}''',
                "'{0}'" -f $templatePath.Replace("'", "''")
            )
            $values = @{
                '${{ inputs.deploymentMetadataLocation }}'                          = 'WestEurope'
                '${{ inputs.managementGroupId }}'                                   = 'test-management-group'
                '${{ inputs.modulePath }}'                                          = 'avm/res/retry-test/widget'
                '${{ inputs.customLocation }}'                                      = 'swedencentral'
                '${{ inputs.removeDeployment }}'                                    = 'true'
                '${{ steps.replace-tokens.outputs.resourceLocation }}'              = ''
                '${{ steps.get-test-subscription.outputs.subscriptionId }}'         = $subscriptionId
                '${{ steps.deploy_step.outputs.remainingDeploymentNames }}'         = $Outputs.remainingDeploymentNames ?? ''
                '${{ steps.deploy_step.outputs.deploymentNames }}'                  = $Outputs.deploymentNames ?? ''
                '${{ steps.deploy_step.outputs.preflightRejectedDeploymentNames }}' = $Outputs.preflightRejectedDeploymentNames ?? ''
                '${{ steps.deploy_step.outputs.pendingDeletionDeploymentIds }}'     = $Outputs.pendingDeletionDeploymentIds ?? ''
            }
            foreach ($key in $values.Keys) {
                $stepScript = $stepScript.Replace($key, $values[$key])
            }
            $stepScript | Should -Not -Match '\$\{\{'
            return $stepScript
        }

        function Invoke-TestActionStep {
            param(
                [string] $Name, [hashtable] $Outputs = @{}, [string] $JobStatus = 'failure',
                [string] $RemoveDeployment = 'true', [string] $SkipDeployment = 'false'
            )
            if ($Name -eq 'Remove deployed resources') {
                $condition = ($action.runs.steps | Where-Object { $_.name -eq $Name }).if
                $condition = $condition.Replace('${{', '').Replace('}}', '').
                Replace('success()', '$($JobStatus -eq ''success'')').Replace('failure()', '$($JobStatus -eq ''failure'')').
                Replace('inputs.removeDeployment', '$RemoveDeployment').Replace('env.skip_deployment_ci', '$SkipDeployment').
                Replace('steps.deploy_step.outputs.deploymentNames', '$deploymentNames').
                Replace('&&', '-and').Replace('||', '-or').Replace('!=', '-ne').Replace('==', '-eq')
                $conditionScript = [scriptblock]::Create("param(`$JobStatus, `$RemoveDeployment, `$SkipDeployment, `$deploymentNames) $condition")
                if (-not (. $conditionScript $JobStatus $RemoveDeployment $SkipDeployment ($Outputs.deploymentNames ?? ''))) { return }
            }
            $stepScript = Get-TestActionScript -Name $Name -Outputs $Outputs
            Clear-Content -LiteralPath $env:GITHUB_OUTPUT
            . ([scriptblock]::Create($stepScript))
        }

        function Get-TestStepOutput {
            $outputs = @{}
            foreach ($line in (Get-Content -LiteralPath $env:GITHUB_OUTPUT)) {
                $name, $value = $line.Split('=', 2)
                $outputs[$name] = $value
            }
            return $outputs
        }

        function Set-AzContext {
            [CmdletBinding()]
            param([string] $Subscription)
            throw 'Unexpected Azure context change.'
        }
        function Get-AzContext {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure context lookup.'
        }
        function Get-AzDeployment {
            [CmdletBinding()]
            param([string] $Name, [object] $DefaultProfile)
            throw 'Unexpected Azure deployment status lookup.'
        }
        function Get-AzResourceGroupDeployment {
            [CmdletBinding()]
            param([string] $Name, [string] $ResourceGroupName, [object] $DefaultProfile)
            throw 'Unexpected Azure deployment status lookup.'
        }
        function Get-AzManagementGroupDeployment {
            [CmdletBinding()]
            param([string] $Name, [string] $ManagementGroupId, [object] $DefaultProfile)
            throw 'Unexpected Azure deployment status lookup.'
        }
        function Get-AzTenantDeployment {
            [CmdletBinding()]
            param([string] $Name, [object] $DefaultProfile)
            throw 'Unexpected Azure deployment status lookup.'
        }
        function New-AzSubscriptionDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure deployment.'
        }
        function Test-AzSubscriptionDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure validation.'
        }
        function New-AzResourceGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $ResourceGroupName, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure deployment.'
        }
        function New-AzManagementGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $ManagementGroupId, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure deployment.'
        }
        function New-AzTenantDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure deployment.'
        }
        function Get-AzResourceGroup {
            [CmdletBinding()]
            param([string] $Name)
            throw 'Unexpected Azure resource group lookup.'
        }
        function Get-AzDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName)
            throw 'Unexpected Azure deployment error lookup.'
        }
        function Get-AzResourceGroupDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName, [string] $ResourceGroupName)
            throw 'Unexpected Azure deployment error lookup.'
        }
        function Get-AzManagementGroupDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName, [string] $ManagementGroupId)
            throw 'Unexpected Azure deployment error lookup.'
        }
        function Get-AzTenantDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName)
            throw 'Unexpected Azure deployment error lookup.'
        }
        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param([string] $Method, [string] $Path)
            throw 'Unexpected Azure REST request.'
        }
        function Get-AzResourceLock {
            [CmdletBinding()]
            param([string] $Scope)
            throw 'Unexpected Azure lock lookup.'
        }
        function Remove-AzResource {
            [CmdletBinding()]
            param([string] $ResourceId, [switch] $Force)
            throw 'Unexpected Azure resource removal.'
        }
        function Get-AzDiskEncryptionSet {
            [CmdletBinding()]
            param([string] $Name, [string] $ResourceGroupName)
            throw 'Unexpected Azure disk encryption set lookup.'
        }
        function Remove-AzKeyVaultAccessPolicy {
            [CmdletBinding()]
            param([string] $VaultName, [string] $ObjectId)
            throw 'Unexpected Azure access policy removal.'
        }
        function Get-AzRoleAssignment {
            [CmdletBinding()]
            param([string] $Scope)
            throw 'Unexpected Azure role lookup.'
        }
        function Remove-AzRoleAssignment {
            [CmdletBinding()]
            param([Parameter(ValueFromPipeline)] [object] $InputObject)
            process { throw 'Unexpected Azure role removal.' }
        }
        function Get-AzKeyVault {
            [CmdletBinding()]
            param([switch] $InRemovedState)
            throw 'Unexpected Azure vault lookup.'
        }
        function Remove-AzKeyVault {
            [CmdletBinding()]
            param([string] $ResourceId, [switch] $InRemovedState, [switch] $Force, [string] $Location)
            throw 'Unexpected Azure vault purge.'
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            Remove-Item -LiteralPath "Env:\$name" -ErrorAction SilentlyContinue
        }
        $env:GITHUB_WORKSPACE = $repoRootPath
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'step-output.txt'
        $null = New-Item -Path $env:GITHUB_OUTPUT -ItemType File -Force
        $env:AVM_CI_VARIABLES = '{}'
        $env:AVM_CI_SECRETS = '{"CI_ADMIN_SECRET":"test-only-secret-not-for-logs"}'
        $null = New-Item -Path (Join-Path $TestDrive 'max') -ItemType Directory -Force
        $templatePath = Join-Path $TestDrive 'max' 'main.test.json'
        Set-TestTemplateScope
        $script:outcomes = @('PartialFailure', 'Preflight', 'Preflight')
        $script:detailedFailureMessage = "08:33:53 - The deployment '{0}' failed with error(s). Showing 1 out of 1 error(s). Status Message: " +
        'At least one resource deployment operation failed. Please list deployment operations for details. Please see https://aka.ms/arm-deployment-operations for usage details. (Code: DeploymentFailed) - ' +
        'The deployment request failed because it would bring the total number of vCores to 4, which exceeds the limit of 0 allowed for the requested hardware family in your subscription. (Code:ProvisioningDisabled)'
        $script:preflightFormat = 'Az'
        $script:timeoutFormat = 'Direct'
        $script:attemptNames = [System.Collections.Generic.List[string]]::new()
        $script:attemptRegions = [System.Collections.Generic.List[string]]::new()
        $script:attemptBaseTimes = [System.Collections.Generic.List[string]]::new()
        $script:lookupNames = [System.Collections.Generic.List[string]]::new()
        $script:lookupPaths = [System.Collections.Generic.List[string]]::new()
        $script:removedIds = [System.Collections.Generic.List[string]]::new()
        $script:operationOverrides = @{}
        $secureParameters = Get-CIParameterMap -TemplateParameters @{ adminSecret = @{ type = 'secureString' } } -GitHubSecrets $env:AVM_CI_SECRETS
        $deploymentInput = @{
            TemplateFilePath           = $templatePath
            RepoRoot                   = $repoRootPath
            DeploymentMetadataLocation = 'WestEurope'
            SubscriptionId             = $subscriptionId
            ManagementGroupId          = 'test-management-group'
            ResourceGroupName          = 'dep-fixture-rg'
            DoNotThrow                 = $true
            AdditionalParameters       = @{
                resourceLocation = 'swedencentral'
                baseTime         = '2026-09-28 21:00:00Z'
                adminSecret      = $secureParameters.adminSecret
            }
        }

        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock Start-Sleep {}
        Mock Set-AzContext {}
        Mock Get-AzContext { @{ Subscription = @{ Id = $subscriptionId } } }
        Mock Get-AzDeployment {}
        Mock Get-AzResourceGroupDeployment {}
        Mock Get-AzManagementGroupDeployment {}
        Mock Get-AzTenantDeployment {}
        Mock Get-AzResourceGroup { @{ ResourceId = $resourceGroupId } }
        Mock New-AzSubscriptionDeployment { Invoke-TestSubmission $DeploymentName $resourceLocation $baseTime $adminSecret }
        Mock Test-AzSubscriptionDeployment {}
        Mock New-AzResourceGroupDeployment { Invoke-TestSubmission $DeploymentName $resourceLocation $baseTime $adminSecret }
        Mock New-AzManagementGroupDeployment { Invoke-TestSubmission $DeploymentName $resourceLocation $baseTime $adminSecret }
        Mock New-AzTenantDeployment { Invoke-TestSubmission $DeploymentName $resourceLocation $baseTime $adminSecret }
        Mock Get-AzDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = 'DeploymentFailed: StorageAccountAlreadyTaken' } }
        Mock Get-AzResourceGroupDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = 'DeploymentFailed: StorageAccountAlreadyTaken' } }
        Mock Get-AzManagementGroupDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = 'DeploymentFailed: StorageAccountAlreadyTaken' } }
        Mock Get-AzTenantDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = 'DeploymentFailed: StorageAccountAlreadyTaken' } }
        Mock Invoke-AzRestMethod {
            $Method | Should -Be 'GET'
            $Path | Should -Match '/providers/Microsoft.Resources/deployments/(?<name>[^/]+)/operations\?api-version=2021-04-01$'
            $name = [regex]::Match($Path, '/deployments/([^/]+)/operations').Groups[1].Value
            $script:lookupNames.Add($name)
            $script:lookupPaths.Add($Path)
            if ($script:operationOverrides.ContainsKey($name)) {
                $response = $script:operationOverrides[$name]
                if ($response -is [System.Exception] -or $response -is [System.Management.Automation.ErrorRecord]) { throw $response }
                return $response
            }
            if ($name -eq 'fixture-dependencies') {
                return New-TestOperationsResponse -Ids $script:fixtureResourceIds[1..8] -ReadIds '/subscriptions/other/resourceGroups/existing/providers/Microsoft.Storage/storageAccounts/notowned'
            }
            if ($name -match '-t1-') {
                return New-TestOperationsResponse -Ids @($resourceGroupId, "$resourceGroupId/providers/Microsoft.Resources/deployments/fixture-dependencies")
            }
            return @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound","message":"No deployment record."}}' }
        }
        Mock Get-AzResourceLock {}
        Mock Remove-AzResource { $script:removedIds.Add($ResourceId) }
        Mock Get-AzDiskEncryptionSet {
            @{ ActiveKey = @{ SourceVault = @{ Id = $script:fixtureResourceIds[2] } }; Identity = @{ PrincipalId = 'test-des-identity' } }
        }
        Mock Remove-AzKeyVaultAccessPolicy {}
        Mock Get-AzRoleAssignment {
            $script:fixtureResourceIds | Where-Object { $_ -like "$Scope/providers/Microsoft.Authorization/roleAssignments/*" } |
                ForEach-Object { @{ RoleAssignmentId = $_ } }
        }
        Mock Remove-AzRoleAssignment { $script:removedIds.Add($InputObject.RoleAssignmentId) }
        Mock Get-AzKeyVault { @{ ResourceId = $script:fixtureResourceIds[2]; EnablePurgeProtection = $true } }
        Mock Remove-AzKeyVault { throw 'A purge-protected fixture vault must not be purged.' }
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'Cleans t1 partial resources after <failure> without waiting for uncreated t2/t3 using <format> rejection errors and actual action outputs' -ForEach @(
        @{ failure = 'PartialFailure'; format = 'Az' }
        @{ failure = 'PartialFailure'; format = 'Json' }
        @{ failure = 'PartialFailure'; format = 'AzErrorDetails' }
        @{ failure = 'DetailedFailure'; format = 'Az' }
    ) {
        $script:outcomes[0] = $failure
        $script:preflightFormat = $format
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*InvalidTemplateDeployment*'
        $outputs = Get-TestStepOutput
        @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames)
        @($outputs.preflightRejectedDeploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames[1..2])
        @($script:attemptRegions) | Should -Be @('swedencentral', 'swedencentral', 'swedencentral')
        @($script:attemptBaseTimes | Select-Object -Unique).Count | Should -Be 1

        $messages = Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs 3>&1 4>&1

        foreach ($id in $resourceIds) {
            ($messages | Out-String) | Should -Match ([regex]::Escape("- Remove [$id]"))
            @($script:removedIds | Where-Object { $id -eq $_ -or $id.StartsWith("$_/") }).Count | Should -BeGreaterThan 0
        }
        $script:removedIds | Should -Contain $resourceIds[5]
        @($script:removedIds | Where-Object { -not $_.StartsWith($resourceGroupId) }).Count | Should -Be 0
        @($script:lookupNames | Where-Object { $_ -eq $script:attemptNames[1] }).Count | Should -Be 1
        @($script:lookupNames | Where-Object { $_ -eq $script:attemptNames[2] }).Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 5 }
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
        Should -Invoke Remove-AzKeyVault -Times 0 -Exactly
        ($messages | Out-String) | Should -Not -Match 'test-only-secret-not-for-logs'
    }

    It 'Retries detailed Azure failures within <limit> total attempts without changing parameters' -ForEach @(
        @{ limit = 1 }, @{ limit = 2 }, @{ limit = 3 }
    ) {
        $script:outcomes = @('DetailedFailure', 'DetailedFailure', 'DetailedFailure', 'Succeeded')

        $result = New-TemplateDeployment @deploymentInput -RetryLimit $limit

        $result.Exception | Should -Be ($script:detailedFailureMessage -f $script:attemptNames[-1])
        @($result.DeploymentNames) | Should -Be @($script:attemptNames)
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        $script:attemptNames.Count | Should -Be $limit
        @($script:attemptNames | Select-Object -Unique).Count | Should -Be $limit
        @($script:attemptRegions) | Should -Be (@('swedencentral') * $limit)
        @($script:attemptBaseTimes | Select-Object -Unique).Count | Should -Be 1
        Should -Invoke New-AzSubscriptionDeployment -Times $limit -Exactly -ParameterFilter { $Location -eq 'WestEurope' }
        Should -Invoke Set-AzContext -Times $limit -Exactly -ParameterFilter { $Subscription -eq $subscriptionId }
        Should -Invoke Start-Sleep -Times ($limit - 1) -Exactly -ParameterFilter { $Seconds -eq 5 }
    }

    It 'Retries a detailed terminal failure and returns the later successful attempt' {
        $script:outcomes = @('DetailedFailure', 'Succeeded')

        $result = New-TemplateDeployment @deploymentInput

        $result.ContainsKey('Exception') | Should -BeFalse
        $result.ContainsKey('DeploymentOutput') | Should -BeTrue
        @($result.DeploymentNames) | Should -Be @($script:attemptNames)
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        $script:attemptNames.Count | Should -Be 2
        @($script:attemptRegions) | Should -Be @('swedencentral', 'swedencentral')
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
    }

    It 'Does not retry a failure message with <reason>' -ForEach @(
        @{ reason = 'a different deployment name'; match = "'{0}'"; replacement = "'another-deployment'" }
        @{ reason = 'an unknown-outcome prefix'; match = '08:33:53 - '; replacement = 'The submission outcome is unknown: ' }
        @{ reason = 'an in-progress state'; match = 'failed with error(s).'; replacement = 'is still running.' }
        @{ reason = 'only a nested DeploymentFailed code'; match = '(Code: DeploymentFailed)'; replacement = '(Code: Unknown) Nested error: (Code: DeploymentFailed)' }
        @{ reason = 'a failure code on an unrelated line'; match = ' (Code: DeploymentFailed)'; replacement = "`n(Code: DeploymentFailed)" }
    ) {
        $script:detailedFailureMessage = $script:detailedFailureMessage.Replace($match, $replacement)
        $script:outcomes = @('DetailedFailure', 'Succeeded')

        $result = New-TemplateDeployment @deploymentInput

        $result.Exception | Should -Be ($script:detailedFailureMessage -f $script:attemptNames[0])
        @($result.DeploymentNames) | Should -Be @($script:attemptNames)
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        $script:attemptNames.Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Still cleans a marked preflight attempt when its record exists' {
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $extraResource = "$resourceGroupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-late-created"
        $script:operationOverrides[$script:attemptNames[1]] = New-TestOperationsResponse -Ids $extraResource

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        $script:removedIds | Should -Contain $extraResource
        $script:removedIds | Should -Contain $resourceIds[5]
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Preserves failed-but-created deployments and rejection metadata at <scope> scope' -ForEach @(
        @{ scope = 'resourcegroup'; pathPrefix = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/dep-fixture-rg' }
        @{ scope = 'subscription'; pathPrefix = '/subscriptions/11111111-1111-1111-1111-111111111111' }
        @{ scope = 'managementgroup'; pathPrefix = '/providers/Microsoft.Management/managementGroups/test-management-group' }
        @{ scope = 'tenant'; pathPrefix = '' }
    ) {
        Set-TestTemplateScope -Scope $scope
        $script:outcomes[0] = 'FailedResult'
        $result = New-TemplateDeployment @deploymentInput
        $result.Exception | Should -Match 'InvalidTemplateDeployment'
        $result.DeploymentNames.Count | Should -Be 3
        $result.PreflightRejectedDeploymentNames | Should -Be @($script:attemptNames[1..2])

        Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames $result.DeploymentNames `
            -PreflightRejectedDeploymentNames $result.PreflightRejectedDeploymentNames -SubscriptionId $subscriptionId `
            -ResourceGroupName 'dep-fixture-rg' -ManagementGroupId 'test-management-group'

        $script:lookupPaths | Should -Contain "$pathPrefix/providers/Microsoft.Resources/deployments/$($script:attemptNames[0])/operations?api-version=2021-04-01"
        $script:removedIds | Should -Contain $resourceIds[5]
        if ($scope -eq 'managementgroup') {
            Should -Invoke Get-AzManagementGroupDeploymentOperation -Times 1 -Exactly -ParameterFilter { $ManagementGroupId -eq 'test-management-group' }
        }
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Retains rejection metadata if a later submission succeeds' {
        $script:outcomes = @('Preflight', 'Succeeded')
        $result = New-TemplateDeployment @deploymentInput
        $result.ContainsKey('Exception') | Should -BeFalse
        $result.DeploymentNames | Should -Be @($script:attemptNames)
        @($result.PreflightRejectedDeploymentNames) | Should -Be @($script:attemptNames[0])
    }

    It 'Fails but emits the accepted name and reaches actual cleanup on a <format> HTTP timeout' -ForEach @(
        @{ format = 'Direct' }, @{ format = 'InnerException' }, @{ format = 'ErrorRecord' }
        @{ format = 'RuntimeException' }, @{ format = 'WriteError' }
    ) {
        $script:outcomes = @('RequestTimeout')
        $script:timeoutFormat = $format

        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*HttpClient.Timeout*'

        $outputs = Get-TestStepOutput
        $outputs.deploymentNames | Should -Match '^\["[^"]+"\]$'
        @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames)
        $outputs.preflightRejectedDeploymentNames | Should -Be '[]'
        $outputs.deploymentOutput | Should -BeExactly 'null'
        $script:attemptNames.Count | Should -Be 1
        @($script:attemptRegions) | Should -Be @('swedencentral')
        $script:lookupNames.Count | Should -Be 0

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        @($script:lookupNames) | Should -Be @($script:attemptNames[0], 'fixture-dependencies')
        $script:removedIds | Should -Contain $resourceIds[5]
        @($script:removedIds | Where-Object { -not $_.StartsWith($resourceGroupId) }).Count | Should -Be 0
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Retains an earlier partial attempt when the next submission times out without replaying it' {
        $script:outcomes = @('PartialFailure', 'RequestTimeout')
        $script:timeoutFormat = 'RuntimeException'

        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*HttpClient.Timeout*'
        $outputs = Get-TestStepOutput
        @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames)
        $outputs.preflightRejectedDeploymentNames | Should -Be '[]'
        $script:attemptNames.Count | Should -Be 2
        $extraResource = "$resourceGroupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-timeout-created"
        $script:operationOverrides[$script:attemptNames[1]] = New-TestOperationsResponse -Ids $extraResource

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        $script:removedIds | Should -Contain $resourceIds[5]
        $script:removedIds | Should -Contain $extraResource
        @($script:lookupNames) | Should -Be @($script:attemptNames[0], 'fixture-dependencies', $script:attemptNames[1])
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Keeps prior preflight metadata separate from an accepted timeout attempt' {
        $script:outcomes = @('Preflight', 'RequestTimeout')
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*HttpClient.Timeout*'
        $outputs = Get-TestStepOutput
        @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames)
        @($outputs.preflightRejectedDeploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames[0])
        $script:operationOverrides[$script:attemptNames[0]] = @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound"}}' }
        $script:operationOverrides[$script:attemptNames[1]] = New-TestOperationsResponse -Ids $resourceIds[5]

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        @($script:removedIds) | Should -Be @($resourceIds[5])
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Does not treat an absent timeout attempt as a preflight rejection' {
        $script:outcomes = @('RequestTimeout')
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*HttpClient.Timeout*'
        $outputs = Get-TestStepOutput
        $script:operationOverrides[$script:attemptNames[0]] = @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound"}}' }

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*No deployment for the deployment name(s)*'

        $script:lookupNames.Count | Should -Be 40
        $script:removedIds.Count | Should -Be 0
        Should -Invoke Start-Sleep -Times 39 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Still throws a timeout without retrying for callers not using DoNotThrow' {
        $script:outcomes = @('RequestTimeout')
        $deploymentInput.DoNotThrow = $false

        { New-TemplateDeployment @deploymentInput } | Should -Throw '*HttpClient.Timeout*'

        $script:attemptNames.Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Preserves timeout ownership and reports failed recovery when the original message is empty' {
        $script:outcomes = @('EmptyTimeout')
        Mock Get-AzDeploymentOperation { throw (Get-TestRequestTimeout) }

        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*Status recovery*'
        $outputs = Get-TestStepOutput
        @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames)
        $script:attemptNames.Count | Should -Be 1
        Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        $script:removedIds | Should -Contain $resourceIds[5]
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Preserves timeout ownership and strict cleanup at <scope> scope' -ForEach @(
        @{ scope = 'resourcegroup'; pathPrefix = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/dep-fixture-rg' }
        @{ scope = 'subscription'; pathPrefix = '/subscriptions/11111111-1111-1111-1111-111111111111' }
        @{ scope = 'managementgroup'; pathPrefix = '/providers/Microsoft.Management/managementGroups/test-management-group' }
        @{ scope = 'tenant'; pathPrefix = '' }
    ) {
        Set-TestTemplateScope -Scope $scope
        $script:outcomes = @('RequestTimeout')
        $result = New-TemplateDeployment @deploymentInput

        $result.Exception | Should -Match 'HttpClient.Timeout'
        @($result.DeploymentNames) | Should -Be @($script:attemptNames)
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        $script:attemptNames.Count | Should -Be 1

        Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames $result.DeploymentNames `
            -SubscriptionId $subscriptionId -ResourceGroupName 'dep-fixture-rg' -ManagementGroupId 'test-management-group'

        $script:lookupPaths | Should -Contain "$pathPrefix/providers/Microsoft.Resources/deployments/$($script:attemptNames[0])/operations?api-version=2021-04-01"
        $script:removedIds | Should -Contain $resourceIds[5]
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    Context 'Read-only recovery after a submitted request timeout' {
        BeforeAll {
            function Get-TestDeploymentStatus {
                param([string] $Name, [string] $Scope, [object] $Profile, [string] $Target)
                $script:statusReads.Add(@{ Name = $Name; Scope = $Scope; Profile = $Profile; Target = $Target })
                $state = $script:statusStates[$script:statusReads.Count - 1]
                switch ($state) {
                    'Timeout' { throw (Get-TestRequestTimeout) }
                    'Authentication' { throw [System.UnauthorizedAccessException]::new('Status read authentication failed.') }
                    'Transport' { throw [System.Net.Http.HttpRequestException]::new('Status read connection failed.') }
                    'NotFound' { throw 'DeploymentNotFound: the original deployment was not found.' }
                    'Cancelled' { throw [System.OperationCanceledException]::new('Status read cancelled.') }
                    'TaskCancelled' { throw [System.Threading.Tasks.TaskCanceledException]::new('Status read cancelled.') }
                    'TimeoutWordingOnly' {
                        throw [System.OperationCanceledException]::new('HttpClient.Timeout of 100 seconds elapsing.')
                    }
                    'Missing' { return }
                    'MissingState' { return @{ DeploymentName = $Name } }
                    'Mismatched' { return @{ DeploymentName = 'another-deployment'; ProvisioningState = 'Failed' } }
                    'Ambiguous' {
                        return @(
                            @{ DeploymentName = $Name; ProvisioningState = 'Succeeded' }
                            @{ DeploymentName = $Name; ProvisioningState = 'Failed' }
                        )
                    }
                    default {
                        if ([string]::IsNullOrEmpty($state)) { throw 'Unexpected extra deployment status read.' }
                        return @{
                            DeploymentName    = $Name
                            ProvisioningState = $state
                            Outputs           = @{ recovered = @{ type = 'string'; value = 'ready' } }
                        }
                    }
                }
            }
        }

        BeforeEach {
            $script:outcomes = @('RequestTimeout')
            $script:statusStates = @('Running', 'Succeeded')
            $script:statusReads = [System.Collections.Generic.List[hashtable]]::new()
            $script:recoveryClock = [datetime]::new(2026, 10, 2, 10, 40, 39, [DateTimeKind]::Utc)
            $script:selectedContext = [pscustomobject]@{
                Subscription = @{ Id = $subscriptionId }
                Tenant       = @{ Id = '22222222-2222-2222-2222-222222222222' }
                Account      = @{ Id = 'fixture-account' }
            }
            Mock Get-Date {
                if ($Format) { return $script:recoveryClock.ToString($Format) }
                return $script:recoveryClock
            }
            Mock Start-Sleep { $script:recoveryClock = $script:recoveryClock.AddSeconds($Seconds) }
            Mock Get-AzContext { $script:selectedContext }
            Mock Get-AzDeployment {
                Get-TestDeploymentStatus -Name $Name -Scope 'subscription' -Profile $DefaultProfile
            }
            Mock Get-AzResourceGroupDeployment {
                Get-TestDeploymentStatus -Name $Name -Scope 'resourcegroup' -Profile $DefaultProfile -Target $ResourceGroupName
            }
            Mock Get-AzManagementGroupDeployment {
                Get-TestDeploymentStatus -Name $Name -Scope 'managementgroup' -Profile $DefaultProfile -Target $ManagementGroupId
            }
            Mock Get-AzTenantDeployment {
                Get-TestDeploymentStatus -Name $Name -Scope 'tenant' -Profile $DefaultProfile
            }
            Mock Get-ErrorMessageForScope { 'The vCore quota was exceeded. (Code:ProvisioningDisabled)' }
        }

        It 'Recovers Running to Succeeded at <scope> scope without changing the original target or inputs' -ForEach @(
            @{ scope = 'resourcegroup'; target = 'dep-fixture-rg'; command = 'New-AzResourceGroupDeployment' }
            @{ scope = 'subscription'; target = ''; command = 'New-AzSubscriptionDeployment' }
            @{ scope = 'managementgroup'; target = 'test-management-group'; command = 'New-AzManagementGroupDeployment' }
            @{ scope = 'tenant'; target = ''; command = 'New-AzTenantDeployment' }
        ) {
            Set-TestTemplateScope -Scope $scope
            $result = New-TemplateDeployment @deploymentInput

            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentOutput.recovered.value | Should -BeExactly 'ready'
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $script:attemptNames.Count | Should -Be 1
            @($script:attemptRegions) | Should -Be @('swedencentral')
            @($script:attemptBaseTimes) | Should -Be @($deploymentInput.AdditionalParameters.baseTime)
            $script:statusReads.Count | Should -Be 2
            foreach ($read in $script:statusReads) {
                $read.Name | Should -BeExactly $script:attemptNames[0]
                $read.Scope | Should -BeExactly $scope
                $read.Target | Should -BeExactly $target
                [object]::ReferenceEquals($read.Profile, $script:selectedContext) | Should -BeTrue
            }
            Should -Invoke $command -Times 1 -Exactly -ParameterFilter {
                $TemplateFile -eq $templatePath -and $resourceLocation -eq 'swedencentral' -and
                ($ResourceGroupName -eq 'dep-fixture-rg' -or $Location -eq 'WestEurope')
            }
            Should -Invoke Get-AzContext -Times 1 -Exactly
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Returns an already successful deployment after a <format> timeout' -ForEach @(
            @{ format = 'Direct' }, @{ format = 'InnerException' }, @{ format = 'ErrorRecord' }
            @{ format = 'RuntimeException' }, @{ format = 'WriteError' }
        ) {
            $script:timeoutFormat = $format
            $script:statusStates = @('Succeeded')
            $deploymentInput.DoNotThrow = $false
            $result = New-TemplateDeployment @deploymentInput
            $result.DeploymentOutput.recovered.value | Should -BeExactly 'ready'
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Observes recognized active states without submitting a replacement' {
            $script:statusStates = @('Accepted', 'Running', 'Creating', 'Updating', 'Succeeded')
            $result = New-TemplateDeployment @deploymentInput
            $result.ContainsKey('Exception') | Should -BeFalse
            $script:statusReads.Count | Should -Be 5
            $script:attemptNames.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 4 -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Tolerates bounded status-read timeouts and resets their counter after a successful read' -ForEach @(
            @{ states = @('Timeout', 'Succeeded') }
            @{ states = @('Timeout', 'Timeout', 'Succeeded') }
            @{ states = @('Timeout', 'Timeout', 'Running', 'Timeout', 'Timeout', 'Succeeded') }
        ) {
            $script:statusStates = $states
            $result = New-TemplateDeployment @deploymentInput
            $result.ContainsKey('Exception') | Should -BeFalse
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be $states.Count
            Should -Invoke Start-Sleep -Times ($states.Count - 1) -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Stops after three consecutive status-read timeouts and retains ownership and the original error' {
            $script:statusStates = @('Timeout', 'Timeout', 'Timeout', 'Succeeded')
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Match 'three consecutive request timeouts'
            $result.Exception | Should -Match 'HttpClient.Timeout of 100 seconds'
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 3
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 15 }
            Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }

        It 'Stops observation after the 60-minute recovery window without resubmitting' {
            Mock Start-Sleep { $script:recoveryClock = $script:recoveryClock.AddMinutes(60) }
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Match '3600-second recovery window'
            $result.Exception | Should -Match 'HttpClient.Timeout'
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 1
        }

        It 'Fails explicitly on <state> without interpreting it as a failed deployment' -ForEach @(
            @{ state = 'Missing'; message = 'exactly the original deployment' }
            @{ state = 'MissingState'; message = 'unsupported recovery state' }
            @{ state = 'Mismatched'; message = 'exactly the original deployment' }
            @{ state = 'Ambiguous'; message = 'exactly the original deployment' }
            @{ state = 'NotFound'; message = 'DeploymentNotFound' }
            @{ state = 'Authentication'; message = 'authentication failed' }
            @{ state = 'Transport'; message = 'connection failed' }
            @{ state = 'Unknown'; message = 'unsupported recovery state' }
            @{ state = 'Canceled'; message = 'unsupported recovery state' }
        ) {
            $script:statusStates = @($state)
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Match $message
            $result.Exception | Should -Match 'HttpClient.Timeout'
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Rejects a <kind> context before querying deployment status' -ForEach @(
            @{ kind = 'missing' }, @{ kind = 'different subscription' }
        ) {
            if ($kind -eq 'missing') {
                $script:selectedContext = $null
            } else {
                $script:selectedContext.Subscription.Id = '33333333-3333-3333-3333-333333333333'
            }
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Match 'Azure context does not match'
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 0
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Accepts an equivalent canonical subscription ID without changing context' {
            $deploymentInput.SubscriptionId = "{$subscriptionId}"
            $script:statusStates = @('Succeeded')
            $result = New-TemplateDeployment @deploymentInput
            $result.ContainsKey('Exception') | Should -BeFalse
            $script:statusReads.Count | Should -Be 1
            [object]::ReferenceEquals($script:statusReads[0].Profile, $script:selectedContext) | Should -BeTrue
            Should -Invoke Set-AzContext -Times 1 -Exactly -ParameterFilter { $Subscription -eq "{$subscriptionId}" }
        }

        It 'Propagates a <state> status read without submitting again' -ForEach @(
            @{ state = 'Cancelled' }, @{ state = 'TaskCancelled' }, @{ state = 'TimeoutWordingOnly' }
        ) {
            $script:statusStates = @($state)
            { New-TemplateDeployment @deploymentInput } | Should -Throw
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Uses only the existing <limit>-attempt bound after observation confirms Failed' -ForEach @(
            @{ limit = 1 }, @{ limit = 2 }, @{ limit = 3 }
        ) {
            $deploymentInput.RetryLimit = $limit
            $script:outcomes = @('RequestTimeout', 'RequestTimeout', 'RequestTimeout', 'Succeeded')
            $script:statusStates = @('Failed', 'Failed', 'Failed')
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Match 'confirmed Failed during timeout recovery'
            $result.Exception | Should -Match 'HttpClient.Timeout'
            $result.Exception | Should -Match 'vCore quota was exceeded.*ProvisioningDisabled'
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $script:attemptNames.Count | Should -Be $limit
            $script:statusReads.Count | Should -Be $limit
            @($script:attemptRegions | Select-Object -Unique) | Should -Be @('swedencentral')
            @($script:attemptBaseTimes | Select-Object -Unique).Count | Should -Be 1
            Should -Invoke Start-Sleep -Times ($limit - 1) -Exactly -ParameterFilter { $Seconds -eq 5 }
            Should -Invoke Get-ErrorMessageForScope -Times $limit -Exactly -ParameterFilter {
                $DeploymentScope -eq 'subscription' -and $DeploymentName -in $script:attemptNames
            }
        }

        It 'Retains confirmed failure and both errors when operation details cannot be read' -ForEach @(
            @{ exception = [System.UnauthorizedAccessException]::new('Operation detail authentication failed.') }
            @{ exception = [System.Net.Http.HttpRequestException]::new('Operation detail connection failed.') }
            @{ exception = [System.TimeoutException]::new('Operation detail request timed out.') }
        ) {
            $script:detailException = $exception
            Mock Get-ErrorMessageForScope { throw $script:detailException }
            $script:statusStates = @('Failed')
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Match 'confirmed Failed.*failure details could not be read'
            $result.Exception | Should -Match 'HttpClient.Timeout'
            $result.Exception | Should -Match ([regex]::Escape($exception.Message))
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Propagates cancellation during operation detail lookup without another attempt' {
            Mock Get-ErrorMessageForScope { throw [System.OperationCanceledException]::new('Operation detail lookup cancelled.') }
            $script:statusStates = @('Failed')
            { New-TemplateDeployment @deploymentInput } | Should -Throw '*Operation detail lookup cancelled*'
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Allows a successful normal retry only after observation confirms Failed' {
            $script:outcomes = @('RequestTimeout', 'Succeeded')
            $script:statusStates = @('Failed')
            $result = New-TemplateDeployment @deploymentInput
            $result.ContainsKey('Exception') | Should -BeFalse
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            $script:attemptNames.Count | Should -Be 2
            $script:statusReads.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }

        It 'Retains earlier attempts and reaches actual cleanup after successful recovery' {
            $script:outcomes = @('PartialFailure', 'RequestTimeout')
            Invoke-TestActionStep -Name 'Deploy template file'
            $outputs = Get-TestStepOutput
            ($outputs.deploymentOutput | ConvertFrom-Json).recovered.value | Should -BeExactly 'ready'
            @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames)
            $outputs.preflightRejectedDeploymentNames | Should -BeExactly '[]'
            $script:attemptNames.Count | Should -Be 2
            $extraResource = "$resourceGroupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-recovered"
            $script:operationOverrides[$script:attemptNames[1]] = New-TestOperationsResponse -Ids $extraResource

            Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs -JobStatus 'success'

            $script:removedIds | Should -Contain $resourceIds[5]
            $script:removedIds | Should -Contain $extraResource
            @($script:lookupNames) | Should -Be @($script:attemptNames[0], 'fixture-dependencies', $script:attemptNames[1])
        }

        It 'Retains earlier preflight metadata when recovery succeeds' {
            $script:outcomes = @('Preflight', 'RequestTimeout')
            $script:statusStates = @('Succeeded')
            $result = New-TemplateDeployment @deploymentInput
            $result.ContainsKey('Exception') | Should -BeFalse
            @($result.DeploymentNames) | Should -Be @($script:attemptNames)
            @($result.PreflightRejectedDeploymentNames) | Should -Be @($script:attemptNames[0])
            $script:attemptNames.Count | Should -Be 2
        }

        It 'Does not recover a timeout before submission starts' {
            Mock Set-AzContext { throw (Get-TestRequestTimeout) }
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Match 'HttpClient.Timeout'
            $result.DeploymentNames.Count | Should -Be 0
            $script:attemptNames.Count | Should -Be 0
            $script:statusReads.Count | Should -Be 0
            Should -Invoke Get-AzContext -Times 0 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Does not add recovery to <outcome> submission outcomes' -ForEach @(
            @{ outcome = 'NoResult' }, @{ outcome = 'Running' }, @{ outcome = 'MissingState' }
            @{ outcome = 'Unknown' }, @{ outcome = 'TransportFailure' }, @{ outcome = 'AuthenticationFailure' }
        ) {
            $script:outcomes = @($outcome)
            $result = New-TemplateDeployment @deploymentInput
            $result.Exception | Should -Not -BeNullOrEmpty
            $script:attemptNames.Count | Should -Be 1
            $script:statusReads.Count | Should -Be 0
            Should -Invoke Get-AzContext -Times 0 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Does not submit or observe under WhatIf' {
            New-TemplateDeployment @deploymentInput -WhatIf
            $script:attemptNames.Count | Should -Be 0
            $script:statusReads.Count | Should -Be 0
            Should -Invoke Get-AzContext -Times 0 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }
    }

    It 'Passes a single rejected attempt as a JSON array and cleans its successful retry' {
        $script:outcomes = @('Preflight', 'Succeeded')
        Invoke-TestActionStep -Name 'Deploy template file'
        $outputs = Get-TestStepOutput
        $outputs.preflightRejectedDeploymentNames | Should -Match '^\["[^"]+"\]$'
        @($outputs.preflightRejectedDeploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames[0])
        $script:operationOverrides[$script:attemptNames[0]] = @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound"}}' }
        $script:operationOverrides[$script:attemptNames[1]] = New-TestOperationsResponse -Ids $resourceIds[5]

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        @($script:removedIds) | Should -Be @($resourceIds[5])
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Keeps backward-compatible callers strict when rejection metadata is absent' {
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $outputs.Remove('preflightRejectedDeploymentNames')

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*No deployment for the deployment name(s)*'

        $script:removedIds | Should -Contain $resourceIds[5]
        @($script:lookupNames | Where-Object { $_ -eq $script:attemptNames[1] }).Count | Should -Be 40
        Should -Invoke Start-Sleep -Times 39 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Fails when required names remain unresolved even with zero resolved resources' {
        $script:outcomes = @('Succeeded')
        Invoke-TestActionStep -Name 'Deploy template file'
        $outputs = Get-TestStepOutput
        $script:operationOverrides[$script:attemptNames[0]] = @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound"}}' }

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*No deployment for the deployment name(s)*'

        $script:removedIds.Count | Should -Be 0
        @($script:lookupNames).Count | Should -Be 40
        Should -Invoke Start-Sleep -Times 39 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Accepts a genuinely empty resolved deployment' {
        $script:outcomes = @('Succeeded')
        $messages = Invoke-TestActionStep -Name 'Deploy template file' 4>&1
        $outputs = Get-TestStepOutput
        $outputs.preflightRejectedDeploymentNames | Should -Be '[]'
        ($messages | Out-String) | Should -Not -Match 'test-only-secret-not-for-logs'
        $script:operationOverrides[$script:attemptNames[0]] = New-TestOperationsResponse

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        $script:removedIds.Count | Should -Be 0
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Preserves bounded eventual-consistency retries for an accepted deployment' {
        $script:lookupCount = 0
        Mock Invoke-AzRestMethod {
            $script:lookupCount++
            if ($script:lookupCount -lt 3) {
                return @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound"}}' }
            }
            New-TestOperationsResponse -Ids $resourceIds[1]
        }

        $result = Get-DeploymentTargetResourceList -DeploymentNames 'accepted' -Scope subscription -SearchRetryLimit 3

        $result.resourcesToRemove | Should -Be $resourceIds[1]
        $result.resolveError | Should -BeNullOrEmpty
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Cleans known resources but fails without absence retries on <failure>' -ForEach @(
        @{ failure = 'unclassified 404'; response = @{ StatusCode = 404; Content = '{"error":{"code":"NotFound"}}' }; errorText = '*HTTP*404*error*NotFound*' }
        @{ failure = 'authentication'; response = @{ StatusCode = 401; Content = '{"error":{"code":"InvalidAuthenticationToken"}}' }; errorText = '*InvalidAuthenticationToken*' }
        @{ failure = 'permission denial'; response = @{ StatusCode = 403; Content = '{"error":{"code":"AuthorizationFailed"}}' }; errorText = '*AuthorizationFailed*' }
        @{ failure = 'service failure'; response = @{ StatusCode = 503; Content = '{"error":{"code":"ServiceUnavailable"}}' }; errorText = '*ServiceUnavailable*' }
        @{ failure = 'transport exception'; response = [System.Net.Http.HttpRequestException]::new('Connection interrupted'); errorText = '*Connection interrupted*' }
        @{ failure = 'expired credential'; response = [System.UnauthorizedAccessException]::new('ClientAssertionCredential expired'); errorText = '*ClientAssertionCredential expired*' }
        @{ failure = 'invalid success payload'; response = @{ StatusCode = 200; Content = '{}' }; errorText = '*Invalid deployment operations response*' }
    ) {
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $script:operationOverrides[$script:attemptNames[1]] = $response

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw $errorText

        $script:removedIds | Should -Contain $resourceIds[5]
        @($script:lookupNames | Where-Object { $_ -eq $script:attemptNames[1] }).Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Does not suppress a lookup failure when no resources resolve' {
        $script:outcomes = @('Succeeded')
        Invoke-TestActionStep -Name 'Deploy template file'
        $outputs = Get-TestStepOutput
        $script:operationOverrides[$script:attemptNames[0]] = @{ StatusCode = 403; Content = '{"error":{"code":"AuthorizationFailed"}}' }

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*AuthorizationFailed*'

        Should -Invoke Start-Sleep -Times 0 -Exactly
        $script:removedIds.Count | Should -Be 0
    }

    It 'Does not mistake nested authentication failure for an absent nested deployment' {
        $script:operationOverrides['fixture-dependencies'] = @{ StatusCode = 403; Content = '{"error":{"code":"AuthorizationFailed"}}' }
        $result = Get-DeploymentTargetResourceList -DeploymentNames 'partial-t1-attempt' -Scope subscription
        $result.resolveError | Should -Match 'AuthorizationFailed'
        $result.resourcesToRemove | Should -Contain $resourceGroupId
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Cleans already discovered parent resources before reporting a nested lookup failure' {
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $script:operationOverrides['fixture-dependencies'] = @{ StatusCode = 403; Content = '{"error":{"code":"AuthorizationFailed"}}' }

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*AuthorizationFailed*'

        $script:removedIds | Should -Contain $resourceGroupId
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Preserves known targets and reports a <format> discovery timeout at <target>' -ForEach @(
        @{ format = 'Direct'; target = 'later-attempt' }
        @{ format = 'ErrorRecord'; target = 'later-attempt' }
        @{ format = 'RuntimeException'; target = 'later-attempt' }
        @{ format = 'Direct'; target = 'nested-deployment' }
        @{ format = 'RuntimeException'; target = 'nested-deployment' }
    ) {
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $name = $target -eq 'later-attempt' ? $script:attemptNames[1] : 'fixture-dependencies'
        $script:operationOverrides[$name] = Get-TestRequestTimeout -Format $format

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*HttpClient.Timeout*'

        $script:removedIds | Should -Contain $resourceGroupId
        $script:lookupNames | Should -Contain $script:attemptNames[2]
        @($script:lookupNames | Where-Object { $_ -eq $name }).Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Reports a discovery timeout with no known targets instead of returning successful cleanup' {
        $script:outcomes = @('Succeeded')
        Invoke-TestActionStep -Name 'Deploy template file'
        $outputs = Get-TestStepOutput
        $script:operationOverrides[$script:attemptNames[0]] = Get-TestRequestTimeout

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*HttpClient.Timeout*'

        $script:removedIds.Count | Should -Be 0
        $script:lookupNames.Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Does not suppress a <target> timeout carrying a DeploymentNotFound error ID' -ForEach @(
        @{ target = 'later-attempt' }, @{ target = 'nested-deployment' }
    ) {
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $name = $target -eq 'later-attempt' ? $script:attemptNames[1] : 'fixture-dependencies'
        $script:operationOverrides[$name] = [System.Management.Automation.ErrorRecord]::new(
            (Get-TestRequestTimeout), 'DeploymentNotFound', [System.Management.Automation.ErrorCategory]::ObjectNotFound, $null
        )

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw '*HttpClient.Timeout*'

        $script:removedIds | Should -Contain $resourceGroupId
        @($script:lookupNames | Where-Object { $_ -eq $name }).Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Only accepts explicit ResourceGroupNotFound as an already removed resource group' {
        Mock Invoke-AzRestMethod { @{ StatusCode = 404; Content = '{"error":{"code":"ResourceGroupNotFound"}}' } }
        $result = Get-DeploymentTargetResourceList -DeploymentNames 'accepted' -Scope resourcegroup -ResourceGroupName 'dep-fixture-rg'
        $result.resolveError | Should -BeNullOrEmpty
        @($result.resourcesToRemove).Count | Should -Be 0
        $wrongScope = Get-DeploymentTargetResourceList -DeploymentNames 'accepted' -Scope subscription
        $wrongScope.resolveError | Should -Match 'ResourceGroupNotFound'
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Rejects metadata referring to a deployment name outside this cleanup' {
        {
            Get-DeploymentTargetResourceList -DeploymentNames 'owned' -PreflightRejectedDeploymentNames 'not-owned' -Scope subscription
        } | Should -Throw '*outside the supplied deployments*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Does not turn DeploymentFailed with nested preflight or storage errors into rejection evidence' {
        $preflight = New-TestPreflightError -Name 'owned' -Format Json
        $nestedError = $preflight.ErrorDetails.Message | ConvertFrom-Json
        $preflight.ErrorDetails = [System.Management.Automation.ErrorDetails]::new(
            (@{ error = @{ code = 'DeploymentFailed'; details = @($nestedError.error) } } | ConvertTo-Json -Depth 10)
        )
        Test-DeploymentPreflightRejection -ErrorRecord $preflight -DeploymentName 'owned' | Should -BeFalse
        $plainFailure = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new("DeploymentFailed: $($preflight.Exception.Message)"),
            'DeploymentFailed', [System.Management.Automation.ErrorCategory]::InvalidResult, $null
        )
        Test-DeploymentPreflightRejection -ErrorRecord $plainFailure -DeploymentName 'owned' | Should -BeFalse
    }

    It 'Does not trust a preflight message for a different deployment' {
        Test-DeploymentPreflightRejection -ErrorRecord (New-TestPreflightError -Name 'other') -DeploymentName 'owned' | Should -BeFalse
    }

    It 'Rejects preflight classification for HTTP <status> even with a matching payload' -ForEach @(
        @{ status = 401 }, @{ status = 403 }, @{ status = 404 }, @{ status = 429 }, @{ status = 500 }
    ) {
        $record = New-TestPreflightError -Name 'owned' -Format Json
        $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
        Test-DeploymentPreflightRejection -ErrorRecord $record -DeploymentName 'owned' | Should -BeFalse
    }

    It 'Keeps malformed and contradictory rejection metadata unclassified' -ForEach @(
        @{ payload = '{"error":' }
        @{ payload = '{"code":"InvalidTemplateDeployment","Code":"DeploymentFailed"}' }
        @{ payload = '{"error":{"code":"InvalidTemplateDeployment"},"code":"DeploymentFailed"}' }
    ) {
        $record = New-TestPreflightError -Name 'owned'
        $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($payload)
        Test-DeploymentPreflightRejection -ErrorRecord $record -DeploymentName 'owned' | Should -BeFalse
    }

    It 'Does not classify a matching payload wrapped in <exceptionType> as a rejection' -ForEach @(
        @{ exceptionType = 'System.UnauthorizedAccessException' }
        @{ exceptionType = 'System.Net.Http.HttpRequestException' }
        @{ exceptionType = 'System.TimeoutException' }
        @{ exceptionType = 'System.OperationCanceledException' }
        @{ exceptionType = 'System.Management.Automation.PipelineStoppedException' }
    ) {
        $preflight = New-TestPreflightError -Name 'owned' -Format Json
        $inner = New-Object -TypeName $exceptionType -ArgumentList 'The outcome is unknown.'
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Submission failed', $inner),
            'SubmissionFailed', [System.Management.Automation.ErrorCategory]::NotSpecified, $null
        )
        $record.ErrorDetails = $preflight.ErrorDetails
        Test-DeploymentPreflightRejection -ErrorRecord $record -DeploymentName 'owned' | Should -BeFalse
    }

    It 'Unwraps a PowerShell ErrorRecord without using its message to classify a timeout' {
        $inner = Get-TestRequestTimeout -Format ErrorRecord
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.Management.Automation.RuntimeException]::new('Submission failed', $null, $inner),
            'WrappedError', [System.Management.Automation.ErrorCategory]::InvalidOperation, $null
        )
        $record.ErrorDetails = (New-TestPreflightError -Name 'owned' -Format Json).ErrorDetails

        Get-DeploymentErrorKind -ErrorRecord $record | Should -Be 'Timeout'
        Test-DeploymentPreflightRejection -ErrorRecord $record -DeploymentName 'owned' | Should -BeFalse
    }

    It 'Preserves ambiguous <outcome> submission outcomes for strict cleanup' -ForEach @(
        @{ outcome = 'Unknown' }, @{ outcome = 'NoResult' }, @{ outcome = 'TransportFailure' }
        @{ outcome = 'Running' }, @{ outcome = 'MissingState' }, @{ outcome = 'AuthenticationFailure' }
    ) {
        $script:outcomes = @($outcome, $outcome, $outcome)
        $result = New-TemplateDeployment @deploymentInput
        $result.Exception | Should -Match 'outcome is unknown'
        $result.DeploymentNames.Count | Should -Be 1
        $script:attemptNames.Count | Should -Be 1
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Does not classify a context failure as a submitted preflight rejection' {
        Mock Set-AzContext { Write-Error 'Authentication failed while selecting the subscription.' }
        $result = New-TemplateDeployment @deploymentInput
        $result.Exception | Should -Match 'Authentication failed'
        $result.DeploymentNames.Count | Should -Be 0
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        $script:attemptNames.Count | Should -Be 0
    }

    It 'Does not emit cleanup ownership or discover resources when context selection fails before submission' {
        Mock Set-AzContext { throw [System.Net.Http.HttpRequestException]::new('Context selection failed before submission.') }

        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*Context selection failed*'
        $outputs = Get-TestStepOutput
        $outputs.deploymentNames | Should -BeExactly ''
        $outputs.preflightRejectedDeploymentNames | Should -Be '[]'
        $script:attemptNames.Count | Should -Be 0

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        Should -Invoke Get-AzContext -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        $script:removedIds.Count | Should -Be 0
    }

    It 'Keeps only the earlier submitted name when context selection fails before a retry' {
        $script:outcomes = @('PartialFailure')
        Mock Set-AzContext {
            if ($script:attemptNames.Count -gt 0) {
                throw [System.Net.Http.HttpRequestException]::new('Context selection failed before the next submission.')
            }
        }

        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*Context selection failed*'
        $outputs = Get-TestStepOutput
        @($outputs.deploymentNames | ConvertFrom-Json) | Should -Be @($script:attemptNames)
        $script:attemptNames.Count | Should -Be 1
        Mock Set-AzContext {}

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs

        @($script:lookupNames) | Should -Be @($script:attemptNames[0], 'fixture-dependencies')
        $script:removedIds | Should -Contain $resourceIds[5]
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Propagates <outcome> without another deployment attempt' -ForEach @(
        @{ outcome = 'Cancelled' }, @{ outcome = 'WrappedCancellation' }
        @{ outcome = 'TaskCancelled' }, @{ outcome = 'TimeoutWordingOnly' }
        @{ outcome = 'RecordCancellation' }, @{ outcome = 'MixedCancellation' }
    ) {
        $script:outcomes = @($outcome)
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $outputs.ContainsKey('deploymentNames') | Should -BeFalse
        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs
        $script:attemptNames.Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        $script:removedIds.Count | Should -Be 0
    }

    It 'Stops the actual deployment action on PipelineStoppedException during <phase> without retrying or emitting cleanup outputs' -ForEach @(
        @{ phase = 'submission' }, @{ phase = 'recovery' }
    ) {
        $trace = [System.Collections.Generic.List[string]]::new()
        $pipeline = [powershell]::Create()
        try {
            $null = $pipeline.AddScript(@'
param($ActionScript, $Trace, $Phase)
function Set-AzContext {
    [CmdletBinding()]
    param([string] $Subscription)
    $Trace.Add('context')
}
function New-AzSubscriptionDeployment {
    [CmdletBinding()]
    param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
    $Trace.Add('submit')
    if ($Phase -eq 'recovery') {
        throw [System.TimeoutException]::new('Mock request timeout')
    }
    throw [System.Management.Automation.PipelineStoppedException]::new('Mock pipeline cancellation')
}
function Test-AzSubscriptionDeployment {
    [CmdletBinding()]
    param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
    $Trace.Add('validate')
}
function Get-AzContext {
    [CmdletBinding()]
    param()
    $Trace.Add('read-context')
    return @{ Subscription = @{ Id = '11111111-1111-1111-1111-111111111111' } }
}
function Get-AzDeployment {
    [CmdletBinding()]
    param([string] $Name, [object] $DefaultProfile)
    $Trace.Add('read-status')
    throw [System.Management.Automation.PipelineStoppedException]::new('Mock polling cancellation')
}
function Get-AzResourceGroupDeployment { throw 'Unexpected resource group status read.' }
function Get-AzManagementGroupDeployment { throw 'Unexpected management group status read.' }
function Get-AzTenantDeployment { throw 'Unexpected tenant status read.' }
function Start-Sleep {
    param([int] $Seconds)
    $Trace.Add('retry')
}
. ([scriptblock]::Create($ActionScript))
$Trace.Add('returned')
'@).AddArgument((Get-TestActionScript -Name 'Deploy template file')).AddArgument($trace).AddArgument($phase)
            $null = $pipeline.Invoke()

            $pipeline.InvocationStateInfo.State | Should -Be 'Stopped'
            $pipeline.InvocationStateInfo.Reason | Should -BeOfType [System.Management.Automation.PipelineStoppedException]
            if ($phase -eq 'recovery') {
                @($trace) | Should -Be @('context', 'validate', 'context', 'submit', 'read-context', 'read-status')
            } else {
                @($trace) | Should -Be @('context', 'validate', 'context', 'submit')
            }
            (Get-TestStepOutput).ContainsKey('deploymentNames') | Should -BeFalse
        } finally {
            $pipeline.Dispose()
        }
    }

    It 'Propagates cleanup cancellation without retries or resource removal' -ForEach @(
        @{ exception = [System.OperationCanceledException]::new('Cleanup cancelled') }
        @{ exception = [System.InvalidOperationException]::new('Cleanup stopped', [System.Management.Automation.PipelineStoppedException]::new('Pipeline cancelled')) }
        @{ exception = [System.Threading.Tasks.TaskCanceledException]::new('Cleanup cancelled') }
        @{ exception = [System.TimeoutException]::new('Request deadline', [System.Management.Automation.PipelineStoppedException]::new('Pipeline cancelled')) }
    ) {
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw
        $outputs = Get-TestStepOutput
        $script:operationOverrides[$script:attemptNames[1]] = $exception

        { Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs } | Should -Throw

        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
        $script:removedIds.Count | Should -Be 0
        $script:lookupNames | Should -Not -Contain $script:attemptNames[2]
    }

    It 'Honors the actual cleanup condition for <condition>' -ForEach @(
        @{ condition = 'cancelled job'; jobStatus = 'cancelled'; removeDeployment = 'true'; skipDeployment = 'false' }
        @{ condition = 'retained resources'; jobStatus = 'failure'; removeDeployment = 'false'; skipDeployment = 'false' }
        @{ condition = 'ignored deployment'; jobStatus = 'failure'; removeDeployment = 'true'; skipDeployment = 'true' }
    ) {
        $script:outcomes = @('RequestTimeout')
        { Invoke-TestActionStep -Name 'Deploy template file' } | Should -Throw '*HttpClient.Timeout*'
        $outputs = Get-TestStepOutput
        @($outputs.deploymentNames | ConvertFrom-Json).Count | Should -Be 1
        Should -Invoke Get-AzContext -Times 1 -Exactly

        Invoke-TestActionStep -Name 'Remove deployed resources' -Outputs $outputs -JobStatus $jobStatus `
            -RemoveDeployment $removeDeployment -SkipDeployment $skipDeployment

        Should -Invoke Get-AzContext -Times 1 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        $script:removedIds.Count | Should -Be 0
    }

    It 'Rejects a total deployment attempt limit of <limit>' -ForEach @(@{ limit = 0 }, @{ limit = 4 }) {
        { New-TemplateDeployment @deploymentInput -RetryLimit $limit } | Should -Throw
        $script:attemptNames.Count | Should -Be 0
    }

    It 'Keeps the existing cleanup retention and cancellation condition' {
        $cleanup = $action.runs.steps | Where-Object { $_.name -eq 'Remove deployed resources' }
        $cleanup.if | Should -Be '${{ (success() || failure()) && inputs.removeDeployment == ''true'' && steps.deploy_step.outputs.deploymentNames != '''' && env.skip_deployment_ci == ''false'' }}'
    }
}
