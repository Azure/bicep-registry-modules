param ([string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName)

Describe 'Shared Azure Local Kubernetes node-image readiness' {
    BeforeAll {
        $scriptPath = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci' 'Initialize-KubernetesVersionReadiness.ps1'
        function Get-AzAccessToken { param ([switch] $AsSecureString) }
        function New-Catalog([object] $Ready = $true, [string] $State = 'Succeeded') {
            @{
                properties = @{
                    provisioningState = $State
                    values = @(@{
                            version = '1.32'
                            isPreview = $false
                            patchVersions = @{
                                '1.32.5' = @{ readiness = @(@{ osType = 'Linux'; osSku = 'CBLMariner'; ready = $true }) }
                                '1.32.6' = @{ readiness = @(@{ osType = 'Linux'; osSku = 'CBLMariner'; ready = $Ready; errorMessage = 'Image still importing' }) }
                            }
                        })
                }
            }
        }
        function New-Response($Body, $Status = 200, $Headers = @{}) {
            [pscustomobject] @{ StatusCode = $Status; Content = $Body | ConvertTo-Json -Depth 20; Headers = $Headers }
        }
    }
    BeforeEach {
        $script:requests = [System.Collections.Generic.List[string]]::new()
        $script:responses = [System.Collections.Generic.Queue[object]]::new()
        $customLocationId = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/foundation/providers/Microsoft.ExtendedLocation/customLocations/ci'
        Mock Get-AzAccessToken { [pscustomobject] @{ Token = (ConvertTo-SecureString 'offline-placeholder' -AsPlainText -Force) } }
        Mock Start-Sleep {}
        Mock Invoke-WebRequest {
            $script:requests.Add("$Method $Uri")
            if ($script:responses.Count -eq 0) { throw 'Unexpected readiness request.' }
            $script:responses.Dequeue()
        }
    }

    It 'Refreshes cached readiness non-destructively and returns the highest stable Linux/CBLMariner version' {
        $script:responses.Enqueue((New-Response (New-Catalog)))
        $script:responses.Enqueue((New-Response (New-Catalog) 201))
        $script:responses.Enqueue((New-Response (New-Catalog)))
        . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 3
        $DeploymentScriptOutputs.kubernetesVersion | Should -Be '1.32.6'
        $script:requests.Count | Should -Be 3
        @($script:requests | Where-Object { $_ -like 'DELETE *' }).Count | Should -Be 0
        @($script:requests | Where-Object { $_ -like 'PUT *' }).Count | Should -Be 1
    }

    It 'Requires an actual Boolean readiness value instead of <value>' -ForEach @(
        @{ value = 'true' }
        @{ value = 1 }
        @{ value = $null }
    ) {
        $script:responses.Enqueue((New-Response (New-Catalog)))
        $script:responses.Enqueue((New-Response (New-Catalog) 201))
        $script:responses.Enqueue((New-Response (New-Catalog -Ready $value)))
        { . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 3 } | Should -Throw '*Boolean Linux/CBLMariner*'
    }

    It 'Throws on exhausted false readiness rather than returning empty success' {
        $script:responses.Enqueue((New-Response (New-Catalog -Ready $false)))
        $script:responses.Enqueue((New-Response (New-Catalog -Ready $false) 201))
        $script:responses.Enqueue((New-Response (New-Catalog -Ready $false)))
        { . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 2 } | Should -Throw '*exhausted 2 attempts*'
    }

    It 'Observes an existing pending refresh without competing PUT requests' {
        $script:responses.Enqueue((New-Response (New-Catalog -State 'Updating')))
        $script:responses.Enqueue((New-Response (New-Catalog)))
        . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 2
        $DeploymentScriptOutputs.kubernetesVersion | Should -Be '1.32.6'
        @($script:requests | Where-Object { $_ -like 'PUT *' }).Count | Should -Be 0
    }

    It 'Waits for the same asynchronous refresh operation before evaluating image readiness' {
        $expectedOperationUri = 'https://management.azure.com/providers/Microsoft.HybridContainerService/locations/southeastasia/operations/offline'
        $script:responses.Enqueue((New-Response (New-Catalog)))
        $script:responses.Enqueue((New-Response (New-Catalog -State Updating) 201 @{ 'Azure-AsyncOperation' = $expectedOperationUri }))
        $script:responses.Enqueue((New-Response @{ status = 'InProgress' }))
        $script:responses.Enqueue((New-Response @{ status = 'Succeeded' }))
        $script:responses.Enqueue((New-Response (New-Catalog)))
        . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 4
        @($script:requests | Where-Object { $_ -eq "GET $expectedOperationUri" }).Count | Should -Be 2
        $DeploymentScriptOutputs.kubernetesVersion | Should -Be '1.32.6'
    }

    It 'Rejects terminal and unknown refresh states <state>' -ForEach @(
        @{ state = 'Failed' }
        @{ state = 'Canceled' }
        @{ state = 'Unknown' }
    ) {
        $script:responses.Enqueue((New-Response (New-Catalog -State $state)))
        { . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 2 } | Should -Throw
    }

    It 'Rejects a cross-host asynchronous-operation endpoint' {
        $script:responses.Enqueue((New-Response (New-Catalog)))
        $script:responses.Enqueue((New-Response (New-Catalog -State Updating) 201 @{ 'Azure-AsyncOperation' = 'https://example.invalid/operation' }))
        { . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 2 } | Should -Throw '*invalid Azure-AsyncOperation URI*'
    }

    It 'Rejects duplicate readiness records and unsupported explicit versions' {
        $catalog = New-Catalog
        $catalog.properties.values[0].patchVersions['1.32.6'].readiness += @{ osType = 'Linux'; osSku = 'CBLMariner'; ready = $true }
        $script:responses.Enqueue((New-Response (New-Catalog -State Updating)))
        $script:responses.Enqueue((New-Response $catalog))
        { . $scriptPath -CustomLocationResourceId $customLocationId -RetryInterval 0 -MaxRetryCount 2 } | Should -Throw '*exactly one Boolean*'
        $script:responses.Enqueue((New-Response (New-Catalog -State Updating)))
        $script:responses.Enqueue((New-Response (New-Catalog)))
        { . $scriptPath -CustomLocationResourceId $customLocationId -KubernetesVersion '1.29.4' -RetryInterval 0 -MaxRetryCount 2 } | Should -Throw '*unsupported*'
    }
}
