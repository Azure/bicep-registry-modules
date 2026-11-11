param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Deployment cleanup response contracts' {
    BeforeAll {
        . (Join-Path -Path $RepoRootPath -ChildPath 'utilities' -AdditionalChildPath 'pipelines', 'sharedScripts', 'Get-DeploymentErrorKind.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-DeploymentOperationAtScope.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Remove-Deployment.ps1')

        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param ([string] $Method, [string] $Path)
            throw "Unexpected ARM request [$Method $Path]."
        }

        function Get-AzContext {
            [CmdletBinding()]
            param ()
            throw 'Unexpected context lookup.'
        }

        function New-ContractResponse {
            param ([int] $StatusCode = 200, [object] $Content = @{})
            @{
                StatusCode = $StatusCode
                Content    = ConvertTo-Json -InputObject $Content -Depth 20 -Compress
            }
        }

        function Get-ContractTimeout {
            param ([string] $Format = 'Direct')
            $timeout = [System.Threading.Tasks.TaskCanceledException]::new(
                'The request was canceled due to the configured HttpClient.Timeout of 100 seconds elapsing.',
                [System.TimeoutException]::new('The operation was canceled.', [System.Threading.Tasks.TaskCanceledException]::new(
                        'The operation was canceled.', $null, [System.Threading.CancellationToken]::new($true)
                    )),
                [System.Threading.CancellationToken]::new($true)
            )
            $record = [System.Management.Automation.ErrorRecord]::new(
                $timeout, 'HttpClientTimeout', [System.Management.Automation.ErrorCategory]::OperationStopped, 'original-read'
            )
            $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Original timeout details.')
            switch ($Format) {
                'Direct' { return $record }
                'InnerException' {
                    return [System.Management.Automation.ErrorRecord]::new(
                        [System.InvalidOperationException]::new('Read failed.', $timeout),
                        'WrappedTimeout', [System.Management.Automation.ErrorCategory]::InvalidOperation, 'original-read'
                    )
                }
                'RuntimeException' {
                    return [System.Management.Automation.ErrorRecord]::new(
                        [System.Management.Automation.RuntimeException]::new('Read stopped.', $null, $record),
                        'WrappedTimeout', [System.Management.Automation.ErrorCategory]::InvalidOperation, 'original-read'
                    )
                }
                'Aggregate' {
                    return [System.Management.Automation.ErrorRecord]::new(
                        [System.AggregateException]::new([System.Exception[]] @($timeout)),
                        'WrappedTimeout', [System.Management.Automation.ErrorCategory]::InvalidOperation, 'original-read'
                    )
                }
            }
        }
    }

    BeforeEach {
        $script:deploymentId = '/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/owned'
        $script:reads = 0
        Mock Invoke-WebRequest { throw 'Unexpected network access.' }
        Mock Invoke-RestMethod { throw 'Unexpected network access.' }
        Mock Start-Sleep {}
        Mock Get-AzContext { @{ Environment = @{ ResourceManagerUrl = 'https://management.azure.com/' } } }
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'DELETE') { return New-ContractResponse -StatusCode 202 }
            New-ContractResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
        }
    }

    Context 'Accepted history deletion' {
        It 'Waits for confirmed absence after Deleting at <scope> scope' -ForEach @(
            @{ scope = 'subscription'; prefix = '/subscriptions/11111111-1111-1111-1111-111111111111' }
            @{ scope = 'resourcegroup'; prefix = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/owned' }
            @{ scope = 'managementgroup'; prefix = '/providers/Microsoft.Management/managementGroups/owned' }
            @{ scope = 'tenant'; prefix = '' }
        ) {
            $script:deploymentId = "$prefix/providers/Microsoft.Resources/deployments/owned"
            Mock Invoke-AzRestMethod {
                $Path | Should -Be "$script:deploymentId`?api-version=2021-04-01"
                if ($Method -eq 'DELETE') { return New-ContractResponse -StatusCode 202 }
                if (++$script:reads -eq 1) {
                    return New-ContractResponse -Content @{
                        id = $script:deploymentId.ToUpperInvariant()
                        properties = @{ provisioningState = 'Deleting' }
                    }
                }
                New-ContractResponse -StatusCode 404 -Content @{
                    error = @{ code = 'DeploymentNotFound'; target = $script:deploymentId }
                }
            }

            Complete-DeploymentRemoval -DeploymentIds $script:deploymentId -DeploymentNamesById @{ $script:deploymentId = 'owned' }

            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly -ParameterFilter { $Method -eq 'GET' }
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Keeps deletion pending when Deleting exhausts the existing confirmation budget' {
            Mock Invoke-AzRestMethod {
                if ($Method -eq 'DELETE') { return New-ContractResponse -StatusCode 202 }
                New-ContractResponse -Content @{ id = $script:deploymentId; properties = @{ provisioningState = 'Deleting' } }
            }
            $failure = $null
            try {
                Complete-DeploymentRemoval -DeploymentIds $script:deploymentId -DeploymentNamesById @{ $script:deploymentId = 'owned' }
            } catch {
                $failure = $_
            }

            $failure.Exception.Message | Should -BeLike '*still exists after cleanup*'
            $failure.Exception.Data['PendingDeletionDeploymentIds'] | Should -Be @($script:deploymentId)
            $failure.Exception.Data['RemovedDeploymentNames'] | Should -BeNullOrEmpty
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
            Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly -ParameterFilter { $Method -eq 'GET' }
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Does not accept Deleting outside accepted history deletion confirmation' {
            Mock Invoke-AzRestMethod {
                New-ContractResponse -Content @{ id = $script:deploymentId; properties = @{ provisioningState = 'Deleting' } }
            }

            { Test-CleanupResourceAbsent -ResourceId $script:deploymentId } | Should -Throw '*Cannot confirm removal*'

            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Rejects <kind> without polling an uncertain deletion' -ForEach @(
            @{ kind = 'another identity'; change = 'id'; value = '/providers/Microsoft.Resources/deployments/another' }
            @{ kind = 'an array identity'; change = 'id'; value = @('/providers/Microsoft.Resources/deployments/owned') }
            @{ kind = 'a missing identity'; change = 'id'; value = $null }
            @{ kind = 'an array state'; change = 'state'; value = @('Deleting') }
            @{ kind = 'a missing state'; change = 'state'; value = $null }
            @{ kind = 'an unknown state'; change = 'state'; value = 'UnknownState' }
            @{ kind = 'a running deployment'; change = 'state'; value = 'Running' }
            @{ kind = 'an accepted deployment'; change = 'state'; value = 'Accepted' }
            @{ kind = 'a canceled deployment'; change = 'state'; value = 'Canceled' }
            @{ kind = 'an error beside a matching identity'; change = 'error'; value = @{ code = 'AuthorizationFailed' } }
            @{ kind = 'an array body'; change = 'body'; value = $null }
            @{ kind = 'an array properties object'; change = 'properties'; value = $null }
            @{ kind = 'HTTP 403 with a matching body'; change = 'status'; value = 403 }
            @{ kind = 'HTTP 202 without absence proof'; change = 'status'; value = 202 }
            @{ kind = 'HTTP 204 without absence proof'; change = 'status'; value = 204 }
        ) {
            $script:body = @{ id = $script:deploymentId; properties = @{ provisioningState = 'Deleting' } }
            $script:status = 200
            switch ($change) {
                'id' { $script:body.id = $value }
                'state' { $script:body.properties.provisioningState = $value }
                'error' { $script:body.error = $value }
                'body' { $script:body = @($script:body) }
                'properties' { $script:body.properties = @($script:body.properties) }
                'status' { $script:status = $value }
            }
            Mock Invoke-AzRestMethod {
                if ($Method -eq 'DELETE') { return New-ContractResponse -StatusCode 202 }
                New-ContractResponse -StatusCode $script:status -Content $script:body
            }

            { Complete-DeploymentRemoval -DeploymentIds $script:deploymentId } | Should -Throw '*Cannot confirm removal*'

            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' }
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Reports rejected response shape and state without logging deployment payloads' {
            Mock Invoke-AzRestMethod {
                New-ContractResponse -Content @{
                    id = $script:deploymentId
                    properties = @{
                        provisioningState = 'UnknownState'
                        parameters = @{ password = @{ value = 'parameter-secret' } }
                        outputs = @{ signedUri = @{ value = 'https://example.invalid/blob?sig=output-secret' } }
                    }
                    error = @{ code = 'UnexpectedError'; message = 'provider-secret' }
                }
            }
            $failure = $null
            try {
                Wait-DeploymentRecordRemoval -DeploymentId $script:deploymentId
            } catch {
                $failure = $_
            }

            $failure.Exception.Message | Should -Match 'HTTP \[200\]'
            $failure.Exception.Message | Should -Match 'PSCustomObject'
            $failure.Exception.Message | Should -Match 'provisioningState.*UnknownState'
            $failure.Exception.Message | Should -Match 'UnexpectedError'
            $failure.Exception.Message | Should -Not -Match 'parameter-secret|output-secret|provider-secret'
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Fails closed for malformed JSON without echoing its content' {
            Mock Invoke-AzRestMethod { @{ StatusCode = 200; Content = 'not-json-with-secret' } }
            $failure = $null
            try {
                Wait-DeploymentRecordRemoval -DeploymentId $script:deploymentId
            } catch {
                $failure = $_
            }

            $failure.Exception.Message | Should -Match 'Cannot confirm removal.*HTTP \[200\].*invalid JSON'
            $failure.Exception.Message | Should -Not -Match 'not-json-with-secret'
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }
    }

    Context 'Extension-aware operation discovery' {
        It 'Uses the extension-aware API and exact template proof across pages at <scope> scope' -ForEach @(
            @{ scope = 'subscription'; schema = 'subscriptionDeploymentTemplate' }
            @{ scope = 'resourcegroup'; schema = 'deploymentTemplate' }
            @{ scope = 'managementgroup'; schema = 'managementGroupDeploymentTemplate' }
            @{ scope = 'tenant'; schema = 'tenantDeploymentTemplate' }
        ) {
            $inputObject = @{
                Name = 'owned'
                Scope = $scope
                SubscriptionId = '11111111-1111-1111-1111-111111111111'
                ResourceGroupName = 'owned'
                ManagementGroupId = 'owned'
                IncludeAllOperations = $true
                RequireCompleteRemoval = $true
            }
            $script:deploymentId = Get-DeploymentResourceId -Name $inputObject.Name -Scope $scope `
                -SubscriptionId $inputObject.SubscriptionId -ResourceGroupName 'owned' -ManagementGroupId 'owned'
            $script:operationsPath = "$script:deploymentId/operations"
            $script:export = @{
                template = @{
                    '$schema' = "https://schema.management.azure.com/schemas/2019-08-01/$schema.json#"
                    languageVersion = '2.0'
                    imports = @{ graph = @{ provider = 'MicrosoftGraph'; version = '1.0.0' } }
                    resources = @{
                        existingPrincipal = @{ existing = $true; import = 'graph'; type = 'Microsoft.Graph/servicePrincipals@v1.0' }
                    }
                }

            }
            Mock Invoke-AzRestMethod {
                if ($Method -eq 'POST') {
                    $Path | Should -Be "$script:deploymentId/exportTemplate?api-version=2025-04-01"
                    return New-ContractResponse -Content $script:export
                }
                if ($Path -eq "$script:operationsPath`?api-version=2025-04-01") {
                    return New-ContractResponse -Content @{
                        value = @(@{ properties = @{
                                    provisioningOperation = 'Create'
                                    provisioningState = 'Succeeded'
                                    targetResource = @{ id = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/owned' }
                                } })
                        nextLink = "https://management.azure.com$script:operationsPath`?api-version=2025-04-01&`$skiptoken=next"
                    }
                }
                $target = @{ symbolicName = 'existingPrincipal' }
                if ($Path -eq "$script:operationsPath`?api-version=2025-04-01&`$skiptoken=next") {
                    $target.resourceType = 'Microsoft.Graph/servicePrincipals@v1.0'
                    $target.extension = @{ name = 'MicrosoftGraph'; alias = 'graph'; version = '1.0.0' }
                } else {
                    $Path | Should -Be "$script:operationsPath`?api-version=2021-04-01"
                }
                New-ContractResponse -Content @{ value = @(@{ properties = @{
                                provisioningOperation = 'Create'
                                provisioningState = 'Succeeded'
                                targetResource = $target
                            } }) }
            }

            $operations = Get-DeploymentOperationAtScope @inputObject

            $operations.Count | Should -Be 2
            $operations[1].targetResource.resourceType | Should -BeExactly 'Microsoft.Graph/servicePrincipals@v1.0'
            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly -ParameterFilter { $Method -eq 'GET' }
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }
    }

    Context 'Bounded idempotent operation reads' -Tag 'DeploymentReadRecovery' {
        BeforeEach {
            $script:readFailure = Get-ContractTimeout
            $script:readInput = @{
                Name = 'owned'
                Scope = 'subscription'
                SubscriptionId = '11111111-1111-1111-1111-111111111111'
                IncludeAllOperations = $true
                RequireCompleteRemoval = $true
            }
        }

        It 'Retries a <format> HttpClient timeout on the same operation page only' -ForEach @(
            @{ format = 'Direct' }, @{ format = 'InnerException' }
            @{ format = 'RuntimeException' }, @{ format = 'Aggregate' }
        ) {
            $script:readFailure = Get-ContractTimeout -Format $format
            Mock Invoke-AzRestMethod {
                $Method | Should -BeExactly 'GET'
                $Path | Should -BeExactly "$script:deploymentId/operations?api-version=2025-04-01"
                if (++$script:reads -lt 3) { throw $script:readFailure }
                New-ContractResponse -Content @{ value = @(@{ properties = @{
                                provisioningOperation = 'Create'
                                provisioningState = 'Succeeded'
                                targetResource = @{ id = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/owned' }
                            } }) }
            }

            $operations = Get-DeploymentOperationAtScope @script:readInput

            $operations.Count | Should -Be 1
            $operations[0].targetResource.id | Should -BeExactly '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/owned'
            Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }

        It 'Resumes only the timed-out page without duplicating already discovered targets' {
            $resolved = [System.Collections.Generic.List[string]]::new()
            Mock Invoke-AzRestMethod {
                if ($Path -notmatch 'skiptoken') {
                    return New-ContractResponse -Content @{
                        value = @(@{ properties = @{
                                    provisioningOperation = 'Create'
                                    provisioningState = 'Succeeded'
                                    targetResource = @{ id = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/owned' }
                                } })
                        nextLink = "https://management.azure.com$script:deploymentId/operations?api-version=2025-04-01&`$skiptoken=next"
                    }
                }
                if (++$script:reads -eq 1) { throw $script:readFailure }
                New-ContractResponse -Content @{ value = @() }
            }

            $operations = Get-DeploymentOperationAtScope @script:readInput -ResolvedResourceIds $resolved

            $operations.Count | Should -Be 1
            $resolved.Count | Should -Be 1
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path -notmatch 'skiptoken' }
            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly -ParameterFilter { $Path -match 'skiptoken' }
            Should -Invoke Start-Sleep -Times 1 -Exactly
        }

        It 'Rethrows the original final ErrorRecord after exactly three reads' {
            Mock Invoke-AzRestMethod { throw $script:readFailure }
            $failure = $null
            try {
                Get-DeploymentOperationAtScope @script:readInput
            } catch {
                $failure = $_
            }

            [object]::ReferenceEquals($failure.Exception, $script:readFailure.Exception) | Should -BeTrue
            $failure.FullyQualifiedErrorId | Should -Match '^HttpClientTimeout'
            $failure.TargetObject | Should -BeExactly 'original-read'
            $failure.ErrorDetails.Message | Should -BeExactly 'Original timeout details.'
            Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly
            Should -Invoke Start-Sleep -Times 2 -Exactly
        }

        It 'Discards any partial output from a timed-out page' {
            Mock Invoke-AzRestMethod {
                if (++$script:reads -eq 1) {
                    New-ContractResponse -Content @{ value = @(@{ properties = @{
                                    provisioningOperation = 'Create'
                                    provisioningState = 'Succeeded'
                                    targetResource = @{ id = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/partial' }
                                } }) }
                    throw $script:readFailure
                }
                New-ContractResponse -Content @{ value = @() }
            }
            $resolved = [System.Collections.Generic.List[string]]::new()

            $operations = Get-DeploymentOperationAtScope @script:readInput -ResolvedResourceIds $resolved

            $operations.Count | Should -Be 0
            $resolved.Count | Should -Be 0
            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly
        }

        It 'Does not retry a timed-out history DELETE or claim removal' {
            Mock Invoke-AzRestMethod { throw $script:readFailure }
            $failure = $null
            try {
                Complete-DeploymentRemoval -DeploymentIds $script:deploymentId
            } catch {
                $failure = $_
            }

            $failure.Exception.Message | Should -Match 'HttpClient.Timeout'
            $failure.Exception.Data['RemovedDeploymentNames'] | Should -BeNullOrEmpty
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'GET' }
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Rejects an ambiguous HTTP status after a recovered timeout' {
            Mock Invoke-AzRestMethod {
                if (++$script:reads -eq 1) { throw $script:readFailure }
                @{ StatusCode = @(200); Content = '{"value":[]}' }
            }

            { Get-DeploymentOperationAtScope @script:readInput } | Should -Throw

            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly
            Should -Invoke Start-Sleep -Times 1 -Exactly
        }

        It 'Does not replay a template-export POST after recovering an operation-page timeout' {
            Mock Invoke-AzRestMethod {
                if ($Method -eq 'POST' -or ++$script:reads -eq 1) { throw $script:readFailure }
                New-ContractResponse -Content @{ value = @(@{ properties = @{
                                provisioningOperation = 'Create'
                                provisioningState = 'Succeeded'
                                targetResource = @{
                                    resourceType = 'Microsoft.Graph/servicePrincipals@v1.0'
                                    symbolicName = 'existingPrincipal'
                                    extension = @{ name = 'MicrosoftGraph'; alias = 'graph'; version = '1.0.0' }
                                }
                            } }) }
            }

            { Get-DeploymentOperationAtScope @script:readInput } | Should -Throw '*HttpClient.Timeout*'

            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly -ParameterFilter { $Method -eq 'GET' }
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }

        It 'Does not retry <kind> even when other evidence suggests a timeout' -ForEach @(
            @{ kind = 'caller cancellation' }
            @{ kind = 'timeout wording without a typed deadline' }
            @{ kind = 'mixed cancellation' }
            @{ kind = 'mixed permission failure' }
            @{ kind = 'mixed unknown failure' }
            @{ kind = 'authentication category' }
            @{ kind = 'nested authentication category' }
            @{ kind = 'cancellation in a separate runtime error record' }
            @{ kind = 'unknown failure in a separate runtime error record' }
            @{ kind = 'HTTP 401' }
            @{ kind = 'HTTP 403' }
            @{ kind = 'HTTP 404' }
            @{ kind = 'malformed HTTP status' }
            @{ kind = 'transport error' }
        ) {
            $exception = $script:readFailure.Exception
            $category = [System.Management.Automation.ErrorCategory]::OperationStopped
            switch ($kind) {
                'caller cancellation' {
                    $exception = [System.Threading.Tasks.TaskCanceledException]::new(
                        'Caller cancelled.', $null, [System.Threading.CancellationToken]::new($true)
                    )
                }
                'timeout wording without a typed deadline' {
                    $exception = [System.OperationCanceledException]::new($exception.Message)
                }
                'mixed cancellation' {
                    $exception = [System.AggregateException]::new([System.Exception[]] @(
                            $exception, [System.OperationCanceledException]::new('Caller cancelled.')
                        ))
                }
                'mixed permission failure' {
                    $exception = [System.AggregateException]::new([System.Exception[]] @(
                            $exception, [System.UnauthorizedAccessException]::new('Access denied.')
                        ))
                }
                'mixed unknown failure' {
                    $exception = [System.AggregateException]::new([System.Exception[]] @(
                            $exception, [System.InvalidOperationException]::new('Unknown read failure.')
                        ))
                }
                'authentication category' { $category = [System.Management.Automation.ErrorCategory]::AuthenticationError }
                'nested authentication category' {
                    $inner = [System.Management.Automation.ErrorRecord]::new(
                        $exception, 'AuthenticationFailed', [System.Management.Automation.ErrorCategory]::AuthenticationError, $null
                    )
                    $exception = [System.Management.Automation.RuntimeException]::new('Read failed.', $null, $inner)
                }
                { $_ -like '*separate runtime error record' } {
                    $cause = $kind.StartsWith('cancellation') ?
                    [System.OperationCanceledException]::new('Caller cancelled.') :
                    [System.InvalidOperationException]::new('Unknown read failure.')
                    $inner = [System.Management.Automation.ErrorRecord]::new(
                        $cause, 'IndependentFailure', [System.Management.Automation.ErrorCategory]::InvalidOperation, $null
                    )
                    $exception = [System.Management.Automation.RuntimeException]::new('Read failed.', $exception, $inner)
                }
                'transport error' { $exception = [System.Net.Http.HttpRequestException]::new('Connection failed.') }
                default {
                    $status = $kind -eq 'malformed HTTP status' ? 'unknown' : [int] $kind.Split(' ')[1]
                    $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
                }
            }
            $script:readFailure = [System.Management.Automation.ErrorRecord]::new($exception, 'ReadFailed', $category, 'original-read')
            Mock Invoke-AzRestMethod { throw $script:readFailure }

            { Get-DeploymentOperationAtScope @script:readInput } | Should -Throw

            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
            if ($kind -eq 'cancellation in a separate runtime error record') {
                Get-DeploymentErrorKind -ErrorRecord $script:readFailure | Should -BeExactly 'Cancellation'
            }
        }

        It 'Does not reinterpret an HTTP <status> response as a request timeout' -ForEach @(
            @{ status = 403 }, @{ status = 404 }, @{ status = 408 }, @{ status = 429 }, @{ status = 500 }
        ) {
            Mock Invoke-AzRestMethod {
                New-ContractResponse -StatusCode $status -Content @{
                    error = @{ code = 'Unknown'; message = 'HttpClient.Timeout of 100 seconds elapsing.' }
                }
            }

            { Get-DeploymentOperationAtScope @script:readInput } | Should -Throw

            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Rejects malformed or mixed pages after a recovered timeout: <body>' -ForEach @(
            @{ body = '{"value":' }
            @{ body = '{"value":[],"Value":[]}' }
            @{ body = '{"value":null}' }
            @{ body = '{"value":[],"error":{"code":"AuthorizationFailed"}}' }
            @{ body = '{"value":[],"code":"UnknownFailure"}' }
            @{ body = '{"value":[],"nextLink":"https://management.azure.com/providers/Microsoft.Resources/deployments/other/operations?api-version=2025-04-01"}' }
        ) {
            Mock Invoke-AzRestMethod {
                if (++$script:reads -eq 1) { throw $script:readFailure }
                @{ StatusCode = 200; Content = $body }
            }

            { Get-DeploymentOperationAtScope @script:readInput } | Should -Throw

            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly
            Should -Invoke Start-Sleep -Times 1 -Exactly
        }
    }
}
