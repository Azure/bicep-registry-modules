param ([string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName)

Describe 'HCI image build job handoffs' {
    BeforeAll {
        $buildScript = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci' 'Invoke-HciHostImageBuild.ps1'
        . (Join-Path (Split-Path $buildScript) 'HciImageOperation.ps1')
        function Get-AzContext { throw 'Unexpected Azure context lookup.' }
        function Set-AzContext { param ($SubscriptionId) }
        function New-AzSubscriptionDeployment { param ($Name, $Location, $TemplateFile, $TemplateParameterObject) }
        function Invoke-AzRestMethod { param ($Method, $Path) }
        function New-Response($Content, $StatusCode = 200, $Headers = @{}) {
            $response = [System.Net.Http.HttpResponseMessage]::new()
            try {
                foreach ($entry in $Headers.GetEnumerator()) {
                    $response.Headers.Add($entry.Key, [string[]] $entry.Value)
                }
                [pscustomobject] @{ StatusCode = $StatusCode; Content = $Content | ConvertTo-Json -Depth 20; Headers = $response.Headers }
            } finally {
                $response.Dispose()
            }
        }
    }

    BeforeEach {
        $script:now = [datetimeoffset] '2026-10-01T10:00:00Z'
        $script:templateExists = $false
        $script:published = $false
        $script:runStart = $script:now.AddDays(-1)
        $script:runState = 'Succeeded'
        $script:operationState = 'InProgress'
        $script:omitOperationHeader = $false
        $script:operationHeaderName = 'Azure-AsyncOperation'
        $script:replicaState = 'Completed'
        $script:postStatus = 202
        $script:postRunState = 'Running'
        $script:retryAfter = 15
        $script:includeDifferentLocation = $false
        $script:inputs = @{
            AssetBaseUri = 'https://example.test/pinned-assets'
            SubscriptionId = '11111111-1111-1111-1111-111111111111'
            ResourceGroupName = 'rg-avm-ci-azure-local-image'
            GalleryName = 'galavmciazurelocal'
            StagingResourceGroupName = 'rg-avm-ci-azure-local-image-build'
            ImageBuilderIdentityName = 'id-avm-ci-azure-local-image-builder'
            CreateResourceGroup = $false
            UseScopedContributorRole = $true
            Tags = @{ lifecycle = 'tenant-persistent'; 'avm-owner' = 'Azure/bicep-registry-modules' }
        }
        $script:operationPath = "/subscriptions/$($inputs.SubscriptionId)/providers/Microsoft.VirtualMachineImages/locations/southeastasia/operations/22222222-2222-2222-2222-222222222222?api-version=2025-10-01"
        $script:operationHeaderValues = @("https://management.azure.com$script:operationPath")
        Mock Get-Date { $script:now }
        Mock Start-Sleep { param ($Seconds) $script:now = $script:now.AddSeconds($Seconds) }
        Mock Set-AzContext {}
        Mock New-AzSubscriptionDeployment {
            $script:templateExists = $true
            [pscustomobject] @{ ProvisioningState = 'Succeeded' }
        }
        Mock Invoke-HciImageOperationRequest {
            if ($Method -eq 'POST') {
                $script:runStart = $script:now
                $script:runState = $script:postRunState
                $response = @{ StatusCode = $script:postStatus; RetryAfterSeconds = $script:retryAfter }
                if (-not $script:omitOperationHeader) {
                    if (@($script:operationHeaderValues).Count -ne 1 -or -not $script:operationHeaderValues[0]) {
                        throw 'The header is ambiguous; outcome is uncertain.'
                    }
                    $response[$script:operationHeaderName] = ConvertTo-SecureString $script:operationHeaderValues[0] -AsPlainText -Force
                }
                if ($script:includeDifferentLocation) {
                    $response.Location = ConvertTo-SecureString "$($script:operationHeaderValues[0])&t=t&c=c&s=other-private-signature&h=h" -AsPlainText -Force
                }
                return $response
            }
            ([pscredential]::new('operation', $Uri).GetNetworkCredential().Password) | Should -BeExactly $script:operationHeaderValues[0]
            return @{
                StatusCode = 200
                RetryAfterSeconds = $script:retryAfter
                Body = ConvertTo-SecureString (@{ status = $script:operationState } | ConvertTo-Json) -AsPlainText -Force
            }
        }
        Mock Invoke-AzRestMethod {
            if ($Method -ne 'GET') { throw 'Unexpected write during image observation.' }
            if ($Path -like '*/versions/*') {
                if (-not $script:published) { return New-Response @{} 404 }
                return New-Response @{
                    properties = @{
                        provisioningState = 'Succeeded'
                        publishingProfile = @{ excludeFromLatest = $false; targetRegions = @(@{ name = 'southeastasia' }) }
                        replicationStatus = @{ summary = @(@{ region = 'southeastasia'; state = $script:replicaState }) }
                    }
                }
            }
            if (-not $script:templateExists) { return New-Response @{} 404 }
            New-Response @{
                location = 'southeastasia'
                properties = @{ lastRunStatus = @{ startTime = $script:runStart.ToString('o'); runState = $script:runState } }
            }
        }
    }

    It 'Starts once with explicit owned targets, scoped permissions, tags and an immutable operation receipt from <headerName>' -ForEach @(
        @{ headerName = 'Azure-AsyncOperation' }
        @{ headerName = 'azure-asyncoperation' }
    ) {
        $script:operationHeaderName = $headerName
        $deadline = $script:now.AddMinutes(570)
        $result = . $buildScript @inputs -Operation Start -BuildDeadlineUtc $deadline
        $receipt = ConvertFrom-HciPrivateJson -Value $result.OperationReceipt

        $result.BuildStatus | Should -Be 'Running'
        $result.BuildStarted | Should -BeTrue
        ([datetimeoffset] $receipt.deadline).ToUniversalTime().ToString('o') | Should -Be $deadline.ToString('o')
        $result.OperationReceipt | Should -BeOfType [securestring]
        $receipt.operationUri | Should -BeExactly $script:operationHeaderValues[0]
        ([datetimeoffset] $receipt.observedRunStartTime).ToUniversalTime().ToString('o') | Should -Be $script:runStart.ToString('o')
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter {
            $TemplateParameterObject.createResourceGroup -eq $false -and
            $TemplateParameterObject.useScopedContributorRole -eq $true -and
            $TemplateParameterObject.resourceGroupName -eq 'rg-avm-ci-azure-local-image' -and
            $TemplateParameterObject.stagingResourceGroupName -eq 'rg-avm-ci-azure-local-image-build' -and
            $TemplateParameterObject.tags.lifecycle -eq 'tenant-persistent'
        }
    }

    It 'Observes the same operation across bounded jobs without resetting its deadline or resubmitting' {
        $started = . $buildScript @inputs -Operation Start
        $first = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt -ObservationTimeoutInMinutes 1
        $second = . $buildScript @inputs -Operation Observe -OperationReceipt $first.OperationReceipt -ObservationTimeoutInMinutes 1

        $first.BuildStatus | Should -Be 'Running'
        $second.BuildStatus | Should -Be 'Running'
        foreach ($result in @($first, $second)) {
            $result.BuildStarted | Should -BeFalse
            $actual = ConvertFrom-HciPrivateJson -Value $result.OperationReceipt
            $original = ConvertFrom-HciPrivateJson -Value $started.OperationReceipt
            $actual.deadline | Should -Be $original.deadline
            $actual.operationUri | Should -BeExactly $original.operationUri
            $actual.observedRunStartTime | Should -Be $original.observedRunStartTime
        }
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Requires the recorded operation, same template run and completed replicas before succeeding' {
        $started = . $buildScript @inputs -Operation Start
        $script:operationState = 'Succeeded'
        $script:runState = 'Succeeded'
        $script:published = $true

        $result = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt -ObservationTimeoutInMinutes 1

        $result.BuildStatus | Should -Be 'Succeeded'
        $result.BuildStarted | Should -BeFalse
        $result.OperationReceipt.Length | Should -Be 0
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Rejects <change> rather than accepting or replacing a different operation' -ForEach @(
        @{ change = 'a changed run'; kind = 'run' }
        @{ change = 'a failed operation'; kind = 'failed' }
        @{ change = 'a failed replica'; kind = 'replica' }
        @{ change = 'a receipt for another subscription'; kind = 'subscription' }
        @{ change = 'an unrelated operation path'; kind = 'path' }
        @{ change = 'an unobserved run identity'; kind = 'identity' }
    ) {
        $started = . $buildScript @inputs -Operation Start
        $receipt = ConvertFrom-HciPrivateJson -Value $started.OperationReceipt
        $script:operationState = 'Succeeded'
        $script:runState = 'Succeeded'
        $script:published = $true
        switch ($kind) {
            run { $script:runStart = $script:runStart.AddSeconds(1) }
            failed { $script:operationState = 'Failed' }
            replica { $script:replicaState = 'Failed' }
            subscription { $receipt.imageTemplateResourceId = $receipt.imageTemplateResourceId.Replace('11111111', '33333333') }
            path { $receipt.operationUri = 'https://management.azure.com/providers/Microsoft.Authorization/operations?api-version=2024-02-01' }
            identity { $receipt.observedRunStartTime = [datetimeoffset]::MinValue.ToString('o') }
        }
        $changed = ConvertTo-SecureString ($receipt | ConvertTo-Json -Depth 5 -Compress) -AsPlainText -Force
        { . $buildScript @inputs -Operation Observe -OperationReceipt $changed } | Should -Throw
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Exhausts the original overall deadline across jobs instead of extending it' {
        $started = . $buildScript @inputs -Operation Start -BuildDeadlineUtc $script:now.AddMinutes(2)
        $pending = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt -ObservationTimeoutInMinutes 1
        { . $buildScript @inputs -Operation Observe -OperationReceipt $pending.OperationReceipt -ObservationTimeoutInMinutes 1 } |
            Should -Throw '*Timed out*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Does not submit after resource provisioning exhausts the original deadline' {
        Mock New-AzSubscriptionDeployment {
            $script:templateExists = $true
            $script:now = $script:now.AddMinutes(3)
            [pscustomobject] @{ ProvisioningState = 'Succeeded' }
        }
        { . $buildScript @inputs -Operation Start -BuildDeadlineUtc $script:now.AddMinutes(2) } |
            Should -Throw '*before image submission*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 0 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Does not adopt an active build without its original receipt' {
        $null = . $buildScript @inputs -Operation Start
        { . $buildScript @inputs -Operation Start } | Should -Throw '*cannot adopt or resubmit*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Reports an uncertain submission when the operation header is missing' {
        $script:omitOperationHeader = $true
        { . $buildScript @inputs -Operation Start } | Should -Throw '*outcome is uncertain*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Reports an uncertain submission for <change> without accepting another operation' -ForEach @(
        @{ change = 'an empty operation header'; kind = 'empty' }
        @{ change = 'multiple operation header values'; kind = 'multiple' }
        @{ change = 'an HTTP operation URI'; kind = 'scheme' }
        @{ change = 'an untrusted operation host'; kind = 'host' }
        @{ change = 'another subscription'; kind = 'subscription' }
        @{ change = 'another build region'; kind = 'region' }
        @{ change = 'another operation route'; kind = 'route' }
        @{ change = 'another API version'; kind = 'version' }
        @{ change = 'URI credentials'; kind = 'userinfo' }
        @{ change = 'a URI fragment'; kind = 'fragment' }
    ) {
        $validHeader = $script:operationHeaderValues[0]
        $script:operationHeaderValues = switch ($kind) {
            empty { '' }
            multiple { @($validHeader, $validHeader) }
            scheme { $validHeader.Replace('https:', 'http:') }
            host { $validHeader.Replace('management.azure.com', 'example.test') }
            subscription { $validHeader.Replace('11111111', '33333333') }
            region { $validHeader.Replace('/southeastasia/', '/australiaeast/') }
            route { $validHeader.Replace('/operations/', '/operationResults/') }
            version { $validHeader.Replace('2025-10-01', '2022-07-01') }
            userinfo { $validHeader.Replace('https://', 'https://unexpected@') }
            fragment { "$validHeader#unexpected" }
        }
        { . $buildScript @inputs -Operation Start } | Should -Throw '*outcome is uncertain*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Preserves a signed URI longer than 4096 characters across jobs without public output' {
        $script:operationHeaderValues = @("$($script:operationHeaderValues[0])&t=opaque-time&c=$('a' * 4300)&s=opaque-signature&h=opaque-hash")
        $started = . $buildScript @inputs -Operation Start
        $before = ConvertFrom-HciPrivateJson -Value $started.OperationReceipt
        $before.operationUri.Length | Should -BeGreaterThan 4096
        ($started | Out-String) | Should -Not -Match 'opaque-signature'
        $pending = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt -ObservationTimeoutInMinutes 1
        $after = ConvertFrom-HciPrivateJson -Value $pending.OperationReceipt
        $after.operationUri | Should -BeExactly $script:operationHeaderValues[0]
        $after.operationUriHash | Should -BeExactly $before.operationUriHash
    }

    It 'Always chooses Azure-AsyncOperation over a differently signed Location' {
        $script:includeDifferentLocation = $true
        $started = . $buildScript @inputs -Operation Start
        $receipt = ConvertFrom-HciPrivateJson -Value $started.OperationReceipt
        $receipt.operationUri | Should -BeExactly $script:operationHeaderValues[0]
        $null = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt -ObservationTimeoutInMinutes 1
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Carries a later Retry-After boundary across jobs without changing the accepted receipt' {
        $started = . $buildScript @inputs -Operation Start
        $originalHash = Get-HciImageOperationHash -OperationUri $started.OperationReceipt
        $script:retryAfter = 120
        $first = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt -ObservationTimeoutInMinutes 1
        $nextPoll = [datetimeoffset] $first.PollNotBeforeUtc
        $nextPoll | Should -Be $script:now.AddSeconds(120)
        $second = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt `
            -PollNotBeforeUtc $first.PollNotBeforeUtc -ObservationTimeoutInMinutes 1
        $second.BuildStatus | Should -Be 'Running'
        ([datetimeoffset] $second.PollNotBeforeUtc) | Should -Be $nextPoll
        Get-HciImageOperationHash -OperationUri $started.OperationReceipt | Should -Be $originalHash
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' }
        $script:now = $nextPoll
        $null = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt `
            -PollNotBeforeUtc $first.PollNotBeforeUtc -ObservationTimeoutInMinutes 1
        Should -Invoke Invoke-HciImageOperationRequest -Times 2 -Exactly -ParameterFilter { $Method -eq 'GET' }
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Rejects a Retry-After handoff earlier than the accepted receipt' {
        $started = . $buildScript @inputs -Operation Start
        { . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt `
                -PollNotBeforeUtc $script:now.ToString('o') } | Should -Throw '*boundary moved backwards*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 0 -Exactly -ParameterFilter { $Method -eq 'GET' }
    }

    It 'Normalizes Retry-After handoffs to UTC before control-tag readback' {
        $script:now = [datetimeoffset] '2026-10-01T10:00:00+05:30'
        $started = . $buildScript @inputs -Operation Start
        $started.PollNotBeforeUtc | Should -BeExactly $script:now.ToUniversalTime().AddSeconds(15).ToString('o')
    }

    It 'Rejects changed signed query bytes even when the endpoint remains valid' {
        $script:operationHeaderValues = @("$($script:operationHeaderValues[0])&t=t&c=c&s=original-signature&h=h")
        $started = . $buildScript @inputs -Operation Start
        $receipt = ConvertFrom-HciPrivateJson -Value $started.OperationReceipt
        $receipt.operationUri = $receipt.operationUri.Replace('original-signature', 'changed-signature')
        $changed = ConvertTo-SecureString ($receipt | ConvertTo-Json -Depth 5 -Compress) -AsPlainText -Force
        { . $buildScript @inputs -Operation Observe -OperationReceipt $changed } | Should -Throw '*exact URI changed*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 0 -Exactly -ParameterFilter { $Method -eq 'GET' }
    }

    It 'Handles documented synchronous HTTP <code> only with a completed new run and immutable replicas' -ForEach @(
        @{ code = 200 }, @{ code = 204 }
    ) {
        $script:postStatus = $code
        $script:postRunState = 'Succeeded'
        $script:omitOperationHeader = $true
        $started = . $buildScript @inputs -Operation Start
        $receipt = ConvertFrom-HciPrivateJson -Value $started.OperationReceipt
        $receipt.completionMode | Should -BeExactly 'Synchronous'
        $receipt.operationUri | Should -BeNullOrEmpty
        $started.BuildStatus | Should -BeExactly 'Running'
        $script:published = $true
        $result = . $buildScript @inputs -Operation Observe -OperationReceipt $started.OperationReceipt -ObservationTimeoutInMinutes 1
        $result.BuildStatus | Should -BeExactly 'Succeeded'
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
        Should -Invoke Invoke-HciImageOperationRequest -Times 0 -Exactly -ParameterFilter { $Method -eq 'GET' }
    }

    It 'Does not treat synchronous HTTP success with an unfinished run as ready' {
        $script:postStatus = 204
        $script:omitOperationHeader = $true
        { . $buildScript @inputs -Operation Start } | Should -Throw '*did not identify a completed new run*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Rejects undocumented HTTP 201 without retrying submission' {
        $script:postStatus = 201
        { . $buildScript @inputs -Operation Start } | Should -Throw '*HTTP *201*Do not resubmit*'
        Should -Invoke Invoke-HciImageOperationRequest -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }
}
