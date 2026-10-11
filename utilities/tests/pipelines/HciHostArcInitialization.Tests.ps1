param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'HCI host Arc initialization' {
    BeforeAll {
        $scriptRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci' 'azureStackHCIHost' 'scripts'
        $scripts = @{}
        foreach ($file in @('hciHostStage6.ps1', 'hciHostStage7.ps1')) {
            $parseErrors = $null
            $tokens = $null
            $scripts[$file] = [System.Management.Automation.Language.Parser]::ParseFile(
                (Join-Path $scriptRoot $file), [ref] $tokens, [ref] $parseErrors
            )
            if ($parseErrors.Count -gt 0) { throw ($parseErrors.Message -join '; ') }
        }
        foreach ($name in @('Wait-HciArcInitializationJob', 'Wait-HciArcNodeIdentity', 'Get-HciEdgeDevice', 'Initialize-HciEdgeDevice')) {
            $functionAst = @($scripts.Values | ForEach-Object {
                $_.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq $name
                }, $true)
            })
            if ($functionAst.Count -ne 1) { throw "Expected exactly one $name definition." }
            . ([scriptblock]::Create($functionAst[0].Extent.Text))
        }

        function log { param([string] $message) }
        function Get-VM { throw 'Unexpected Hyper-V request.' }
        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param([string] $Method, [string] $Path, [string] $Payload)
            throw 'Unexpected Azure call.'
        }

        $machineId = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test-rg/providers/Microsoft.HybridCompute/machines/hcinode1'
        $edgePath = "$machineId/providers/Microsoft.AzureStackHCI/edgeDevices/default?api-version=2024-04-01"
    }

    It 'Creates only the default HCI edge device and accepts HTTP <Status>' -TestCases @(
        @{ Status = 200 }
        @{ Status = 201 }
        @{ Status = 202 }
    ) {
        param($Status)
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{ StatusCode = 404; Content = '{"error":{"code":"ResourceNotFound"}}' }
        } -ParameterFilter { $Method -eq 'GET' }
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{ StatusCode = $Status; Content = '' }
        } -ParameterFilter { $Method -eq 'PUT' }

        Initialize-HciEdgeDevice -MachineResourceId $machineId

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq $edgePath
        }
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            if ($Method -ne 'PUT' -or $Path -ne $edgePath) { return $false }
            $body = $Payload | ConvertFrom-Json -AsHashtable
            $body.Count -eq 2 -and $body.kind -eq 'HCI' -and $body.properties.Count -eq 0
        }
    }

    It 'Does not rewrite an existing edge device in state <State>' -TestCases @(
        @{ State = 'Succeeded' }
        @{ State = 'Creating' }
        @{ State = 'Updating' }
    ) {
        param($State)
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{
                StatusCode = 200
                Content = @{ kind = 'HCI'; properties = @{ provisioningState = $State } } | ConvertTo-Json -Compress
            }
        }

        Initialize-HciEdgeDevice -MachineResourceId $machineId

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' }
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Fails closed on an existing edge device in state <State>' -TestCases @(
        @{ State = 'Failed' }
        @{ State = 'Canceled' }
    ) {
        param($State)
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{
                StatusCode = 200
                Content = @{ kind = 'HCI'; properties = @{ provisioningState = $State } } | ConvertTo-Json -Compress
            }
        }

        { Initialize-HciEdgeDevice -MachineResourceId $machineId } | Should -Throw "*state '$State'*"
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Does not replace an edge device of another kind' {
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{ StatusCode = 200; Content = '{"kind":"Other","properties":{}}' }
        }
        { Initialize-HciEdgeDevice -MachineResourceId $machineId } | Should -Throw '*not an HCI edge device*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Does not turn read HTTP <Status> into a create request' -TestCases @(
        @{ Status = 403 }
        @{ Status = 429 }
        @{ Status = 500 }
    ) {
        param($Status)
        Mock Invoke-AzRestMethod { [pscustomobject] @{ StatusCode = $Status; Content = 'read failed' } }
        { Initialize-HciEdgeDevice -MachineResourceId $machineId } | Should -Throw "*HTTP $Status*"
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Surfaces failed edge-device creation instead of waiting for missing extensions' {
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{ StatusCode = 404; Content = '' }
        } -ParameterFilter { $Method -eq 'GET' }
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{ StatusCode = 403; Content = 'AuthorizationFailed' }
        } -ParameterFilter { $Method -eq 'PUT' }
        { Initialize-HciEdgeDevice -MachineResourceId $machineId } | Should -Throw '*HTTP 403*AuthorizationFailed*'
    }

    It 'Reports asynchronous provider failure without repeating the creation request' {
        $script:edgeReads = 0
        Mock Invoke-AzRestMethod {
            $script:edgeReads++
            if ($script:edgeReads -eq 1) { return [pscustomobject] @{ StatusCode = 404; Content = '' } }
            [pscustomobject] @{
                StatusCode = 200
                Content = '{"kind":"HCI","properties":{"provisioningState":"Failed","reportedProperties":{"extensionProfile":{"extensions":[{"extensionName":"LcmController","state":"Failed","errorDetails":[{"exception":"AuthorizationFailed: Microsoft.HybridCompute/machines/extensions/read"}]}]}}}}'
            }
        } -ParameterFilter { $Method -eq 'GET' }
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{ StatusCode = 202; Content = '' }
        } -ParameterFilter { $Method -eq 'PUT' }

        Initialize-HciEdgeDevice -MachineResourceId $machineId
        { Get-HciEdgeDevice -MachineResourceId $machineId } |
            Should -Throw '*AuthorizationFailed*Microsoft.HybridCompute/machines/extensions/read*'
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Treats an unpropagated edge-device read as pending without creating it again' {
        Mock Invoke-AzRestMethod { [pscustomobject] @{ StatusCode = 404; Content = '' } }
        Get-HciEdgeDevice -MachineResourceId $machineId | Should -BeNullOrEmpty
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'PUT' }
    }

    It 'Removes credentials from provider failure diagnostics' {
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{
                StatusCode = 200
                Content = '{"kind":"HCI","properties":{"provisioningState":"Failed","reportedProperties":{"extensionProfile":{"extensions":[{"errorDetails":[{"exception":"AuthorizationFailed eyJfake.payload.signature https://example.invalid/package?sig=test-secret&sv=1"}]}]}}}}'
            }
        }
        $message = try { Get-HciEdgeDevice -MachineResourceId $machineId; '' } catch { $_.Exception.Message }
        $message | Should -Match 'AuthorizationFailed'
        $message | Should -Not -Match 'eyJfake|test-secret'
    }

    It 'Initializes each discovered machine before the extension-wait loop' {
        $script:initializedMachines = @()
        Mock Initialize-HciEdgeDevice { $script:initializedMachines += $MachineResourceId }
        $arcMachines = @(
            [pscustomobject] @{ Id = $machineId }
            [pscustomobject] @{ Id = $machineId.Replace('hcinode1', 'hcinode2') }
        )
        $loop = $scripts['hciHostStage7.ps1'].Find({
            param($node)
            $node -is [System.Management.Automation.Language.ForEachStatementAst] -and
                $node.Body.Extent.Text -match 'Initialize-HciEdgeDevice'
        }, $true)
        $loop | Should -Not -BeNullOrEmpty
        . ([scriptblock]::Create($loop.Extent.Text))
        $script:initializedMachines | Should -Be @($arcMachines.Id)
        $loop.Extent.StartOffset | Should -BeLessThan (
            $scripts['hciHostStage7.ps1'].Extent.Text.IndexOf("log 'Waiting up to two hours")
        )
    }

    It 'Uses the installed initialization command rather than a removed module name' {
        $source = $scripts['hciHostStage6.ps1'].Extent.Text
        $source | Should -Not -Match 'Import-Module\s+AzsHCI\.ARCinstaller'
        $source | Should -Match 'Get-Command Invoke-AzStackHciArcInitialization -ErrorAction Stop'
    }

    It 'Waits for both the Arc resource and a valid identity before returning' {
        $script:nodeReads = 0
        Mock Start-Sleep {}
        Mock Invoke-AzRestMethod {
            $script:nodeReads++
            if ($script:nodeReads -eq 1) { return @{ StatusCode = 404; Content = '' } }
            $identity = if ($script:nodeReads -eq 2) { @{} } else { @{ principalId = '22222222-2222-2222-2222-222222222222' } }
            @{
                StatusCode = 200
                Content = @{ id = $machineId; identity = $identity } | ConvertTo-Json -Depth 5
            }
        }

        Wait-HciArcNodeIdentity -MachineResourceId $machineId -MaximumAttempts 3 -RetryDelaySeconds 0

        Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq "$machineId`?api-version=2026-07-15"
        }
        Should -Invoke Start-Sleep -Times 2 -Exactly
    }

    It 'Does not accept an absent Arc resource or an empty identity after bounded readback' -ForEach @(
        @{ Status = 404; ContentKind = 'missing' }
        @{ Status = 200; ContentKind = 'empty' }
        @{ Status = 200; ContentKind = 'zero-guid' }
    ) {
        Mock Start-Sleep {}
        Mock Invoke-AzRestMethod {
            @{
                StatusCode = $Status
                Content = @{
                    id = $machineId
                    identity = @{ principalId = $(if ($ContentKind -eq 'zero-guid') { [guid]::Empty.ToString() } else { '' }) }
                } | ConvertTo-Json -Depth 5
            }
        }

        { Wait-HciArcNodeIdentity -MachineResourceId $machineId -MaximumAttempts 3 -RetryDelaySeconds 0 } |
            Should -Throw '*not available with a valid managed identity after 3 checks*'
        Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly
        Should -Invoke Start-Sleep -Times 2 -Exactly
    }

    It 'Fails promptly when Arc identity readback is unauthorized or mismatched' -ForEach @(
        @{ Status = 403; ResourceId = 'irrelevant'; Expected = '*HTTP 403*' }
        @{ Status = 200; ResourceId = '/subscriptions/other/resourceGroups/other/providers/Microsoft.HybridCompute/machines/other'; Expected = '*unexpected resource*' }
    ) {
        Mock Invoke-AzRestMethod {
            @{ StatusCode = $Status; Content = (@{ id = $ResourceId } | ConvertTo-Json) }
        }
        Mock Start-Sleep {}
        { Wait-HciArcNodeIdentity -MachineResourceId $machineId -MaximumAttempts 3 -RetryDelaySeconds 0 } |
            Should -Throw $Expected
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Confirms each lowercase Arc reference identity after the actual initialization jobs complete' {
        $script:verifiedNodes = @()
        Mock Get-VM { @([pscustomobject] @{ Name = 'hciNode1' }, [pscustomobject] @{ Name = 'hciNode2' }) }
        Mock Wait-HciArcNodeIdentity { $script:verifiedNodes += $MachineResourceId }
        $subscriptionId = '11111111-1111-1111-1111-111111111111'
        $resourceGroupName = 'test-rg'
        $loop = $scripts['hciHostStage6.ps1'].Find({
            param($node)
            $node -is [System.Management.Automation.Language.ForEachStatementAst] -and
                $node.Body.Extent.Text -match 'Wait-HciArcNodeIdentity'
        }, $true)
        $loop | Should -Not -BeNullOrEmpty
        $jobWait = $scripts['hciHostStage6.ps1'].Find({
            param($node)
            $node -is [System.Management.Automation.Language.CommandAst] -and
                $node.GetCommandName() -eq 'Wait-HciArcInitializationJob'
        }, $true)
        $jobWait.Extent.StartOffset | Should -BeLessThan $loop.Extent.StartOffset
        . ([scriptblock]::Create($loop.Extent.Text))
        $script:verifiedNodes | Should -Be @($machineId, $machineId.Replace('hcinode1', 'hcinode2'))
    }

    Context 'Real PowerShell job completion' {
        BeforeEach { $testJobs = @() }
        AfterEach {
            foreach ($job in $testJobs) {
                if ($job.State -notin @('Completed', 'Failed', 'Stopped')) { Stop-Job -Job $job }
                Remove-Job -Job $job -Force
            }
        }

        It 'Receives all output only after successful completion' {
            $testJobs = @(Start-Job { 'node initialized' })
            { Wait-HciArcInitializationJob -Job $testJobs -TimeoutSeconds 15 } | Should -Not -Throw
            $testJobs[0].State | Should -Be 'Completed'
        }

        It 'Fails when any node job fails' {
            $testJobs = @(
                Start-Job { 'node initialized' }
                Start-Job { throw 'synthetic Arc failure' }
            )
            { Wait-HciArcInitializationJob -Job $testJobs -TimeoutSeconds 15 } | Should -Throw '*synthetic Arc failure*'
        }

        It 'Does not treat a timed-out running job as successful' {
            $testJobs = @(Start-Job { Start-Sleep -Seconds 30 })
            { Wait-HciArcInitializationJob -Job $testJobs -TimeoutSeconds 1 } |
                Should -Throw '*did not complete successfully*'
        }

        It 'Surfaces a nonterminating remote error even when the job state is Completed' {
            $testJobs = @(Start-Job {
                Write-Error 'synthetic nonterminating Arc error' -ErrorAction Continue
                'completed after error'
            })
            { Wait-HciArcInitializationJob -Job $testJobs -TimeoutSeconds 15 } |
                Should -Throw '*synthetic nonterminating Arc error*'
        }
    }
}
