BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'configurations' 'tests' 'configuration.tests.ps1'
    $parseErrors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile($fixturePath, [ref] $null, [ref] $parseErrors)
    if ($parseErrors.Count -gt 0) {
        throw "Unable to parse configuration persistence tests: $($parseErrors -join '; ')"
    }
    $setup = @($ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'BeforeAll'
            }, $true))
    $assertion = @($ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'It'
            }, $true))
    if ($setup.Count -ne 1 -or $assertion.Count -ne 1) {
        throw 'Expected one configuration persistence setup and one assertion.'
    }

    $TestInputData = @{
        DeploymentOutputs = @{
            serverResourceId = @{
                Value = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/owned/providers/Microsoft.DBforPostgreSQL/flexibleServers/owned'
            }
        }
    }
    . ($setup[0].CommandElements[-1].ScriptBlock.GetScriptBlock())
    $script:assertConfiguration = $assertion[0].CommandElements[-1].ScriptBlock.GetScriptBlock()

    function Invoke-AzRestMethod {
        [CmdletBinding()]
        param ([string] $Method, [string] $Path)
        throw "Unexpected ARM request [$Method $Path]."
    }
}

Describe 'PostgreSQL configuration persistence reads' {
    BeforeEach {
        $script:configurationPath = "$script:serverResourceId/configurations/max_connections?api-version=2025-08-01"
        $script:reads = 0
        $timeout = [System.Threading.Tasks.TaskCanceledException]::new(
            'The request was canceled due to the configured HttpClient.Timeout of 100 seconds elapsing.',
            [System.TimeoutException]::new('A task was canceled.', [System.Threading.Tasks.TaskCanceledException]::new())
        )
        $script:readError = [System.Management.Automation.ErrorRecord]::new(
            $timeout, 'HttpClientTimeout', [System.Management.Automation.ErrorCategory]::OperationStopped, $script:configurationPath
        )
        $script:readError.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Original configuration read timeout.')
        Mock Invoke-WebRequest { throw 'Unexpected network access.' }
        Mock Invoke-RestMethod { throw 'Unexpected network access.' }
        Mock Start-Sleep {}
        Mock Invoke-AzRestMethod { @{ StatusCode = 200; Content = '{"properties":{"value":"200"}}' } }
    }

    It 'Checks a successful response and requested value with one exact GET' {
        . $script:assertConfiguration -name 'max_connections' -value '200'

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq $script:configurationPath -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Retries only the timed-out configuration without repeating an earlier successful assertion' {
        $script:secondPath = "$script:serverResourceId/configurations/max_prepared_transactions?api-version=2025-08-01"
        Mock Invoke-AzRestMethod {
            $Method | Should -BeExactly 'GET'
            if ($Path -eq $script:configurationPath) {
                return @{ StatusCode = 200; Content = '{"properties":{"value":"200"}}' }
            }
            $Path | Should -BeExactly $script:secondPath
            if (++$script:reads -lt 3) { throw $script:readError }
            @{ StatusCode = 200; Content = '{"properties":{"value":"10"}}' }
        }

        . $script:assertConfiguration -name 'max_connections' -value '200'
        . $script:assertConfiguration -name 'max_prepared_transactions' -value '10'

        Should -Invoke Invoke-AzRestMethod -Times 4 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path -eq $script:configurationPath }
        Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly -ParameterFilter { $Path -eq $script:secondPath }
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 5 }
    }

    It 'Preserves the final timeout after exactly three GET attempts' {
        Mock Invoke-AzRestMethod { throw $script:readError }
        $failure = $null
        try {
            . $script:assertConfiguration -name 'max_connections' -value '200'
        } catch {
            $failure = $_
        }

        [object]::ReferenceEquals($failure.Exception, $script:readError.Exception) | Should -BeTrue
        $failure.FullyQualifiedErrorId | Should -Match '^HttpClientTimeout'
        $failure.TargetObject | Should -BeExactly $script:configurationPath
        $failure.ErrorDetails.Message | Should -BeExactly 'Original configuration read timeout.'
        Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq $script:configurationPath -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 5 }
    }

    It 'Makes a nonterminating cmdlet timeout eligible for the same bounded read recovery' {
        Mock Invoke-AzRestMethod {
            if (++$script:reads -eq 1) { Write-Error -ErrorRecord $script:readError }
            @{ StatusCode = 200; Content = '{"properties":{"value":"200"}}' }
        }

        . $script:assertConfiguration -name 'max_connections' -value '200'

        Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
    }

    It 'Does not retry a <kind> error' -ForEach @(
        @{ kind = 'permission' }
        @{ kind = 'cancellation' }
        @{ kind = 'transport' }
    ) {
        $script:terminalError = switch ($kind) {
            'permission' { [System.UnauthorizedAccessException]::new('Forbidden.', [System.TimeoutException]::new()) }
            'cancellation' { [System.Threading.Tasks.TaskCanceledException]::new('Canceled by caller.') }
            'transport' { [System.Net.Http.HttpRequestException]::new('Connection failed.') }
        }
        Mock Invoke-AzRestMethod { throw $script:terminalError }

        { . $script:assertConfiguration -name 'max_connections' -value '200' } |
            Should -Throw -ExpectedMessage "*$($script:terminalError.Message)*"

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Keeps an HTTP <status> response as a failed status assertion without another GET' -ForEach @(
        @{ status = 403 }
        @{ status = 404 }
        @{ status = 500 }
    ) {
        $script:responseStatus = $status
        Mock Invoke-AzRestMethod { @{ StatusCode = $script:responseStatus; Content = '{"properties":{"value":"200"}}' } }

        { . $script:assertConfiguration -name 'max_connections' -value '200' } |
            Should -Throw -ExpectedMessage '*must be retrievable after deployment*'

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Keeps an incorrect persisted value as a failed assertion without another GET' {
        Mock Invoke-AzRestMethod { @{ StatusCode = 200; Content = '{"properties":{"value":"199"}}' } }

        { . $script:assertConfiguration -name 'max_connections' -value '200' } |
            Should -Throw -ExpectedMessage '*must reflect the requested value after deployment*'

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Rejects unreadable configuration content without another GET' {
        Mock Invoke-AzRestMethod { @{ StatusCode = 200; Content = 'not json' } }

        { . $script:assertConfiguration -name 'max_connections' -value '200' } | Should -Throw

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }
}
