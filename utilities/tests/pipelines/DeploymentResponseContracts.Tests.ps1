param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Deployment cleanup response contracts' {
    BeforeAll {
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
}
