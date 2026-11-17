param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflow = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml') -Raw |
        ConvertFrom-Yaml
    $staticGate = [scriptblock]::Create($workflow.jobs.'static-gate'.steps[0].run)
    $e2eGate = [scriptblock]::Create($workflow.jobs.'required-e2e-gate'.steps[0].run)
    $environmentNames = @('INITIALIZE_RESULT', 'HAS_MODULES', 'CHECK_RESULT', 'HAS_REQUIRED_MODULES',
        'REQUIRED_REQUESTED', 'REQUIRED_ERRORS', 'REQUIRED_RESULT')
}

Describe 'Required Bicep PR gates' {
    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in $environmentNames) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
        }
        $env:INITIALIZE_RESULT = 'success'
        $env:HAS_MODULES = 'true'
        $env:CHECK_RESULT = 'success'
        $env:HAS_REQUIRED_MODULES = 'true'
        $env:REQUIRED_REQUESTED = 'true'
        $env:REQUIRED_ERRORS = '[]'
        $env:REQUIRED_RESULT = 'success'
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'requires static checks to succeed for changed modules' {
        { & $staticGate } | Should -Not -Throw
        $env:CHECK_RESULT = 'skipped'
        { & $staticGate } | Should -Throw
        $env:HAS_MODULES = 'false'
        { & $staticGate } | Should -Not -Throw
        $env:INITIALIZE_RESULT = 'failure'
        { & $staticGate } | Should -Throw
    }

    It 'requires requested and successful E2E tests for applicable modules' {
        { & $e2eGate } | Should -Not -Throw
        $env:REQUIRED_REQUESTED = 'false'
        { & $e2eGate } | Should -Throw '*PR: Run E2E Tests*'
        $env:REQUIRED_REQUESTED = 'true'
        $env:REQUIRED_RESULT = 'skipped'
        { & $e2eGate } | Should -Throw
        $env:REQUIRED_RESULT = 'success'
        $env:REQUIRED_ERRORS = '["missing defaults"]'
        { & $e2eGate } | Should -Throw '*missing*'
    }

    It 'passes without applicable modules but fails closed on initialization errors' {
        $env:HAS_REQUIRED_MODULES = 'false'
        $env:REQUIRED_REQUESTED = 'false'
        $env:REQUIRED_RESULT = 'skipped'
        { & $e2eGate } | Should -Not -Throw
        $env:INITIALIZE_RESULT = 'failure'
        { & $e2eGate } | Should -Throw
        $env:INITIALIZE_RESULT = 'success'
        $env:HAS_REQUIRED_MODULES = ''
        { & $e2eGate } | Should -Throw
    }
}
