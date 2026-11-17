param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflow = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml') -Raw |
        ConvertFrom-Yaml
    $moduleGate = [scriptblock]::Create($workflow.jobs.'module-gate'.steps[0].run)
    $environmentNames = @('INITIALIZE_RESULT', 'HAS_MODULES', 'CHECK_RESULT', 'HAS_REQUIRED_MODULES',
        'REQUIRED_REQUESTED', 'REQUIRED_ERRORS', 'REQUIRE_E2E')
}

Describe 'Required Bicep PR gate' {
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
        $env:REQUIRE_E2E = 'true'
    }

    AfterEach {
        foreach ($name in $environmentNames) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'requires module checks to succeed for changed modules' {
        { & $moduleGate } | Should -Not -Throw
        $env:CHECK_RESULT = 'skipped'
        { & $moduleGate } | Should -Throw
        $env:HAS_MODULES = 'false'
        { & $moduleGate } | Should -Not -Throw
        $env:INITIALIZE_RESULT = 'failure'
        { & $moduleGate } | Should -Throw
    }

    It 'requires requested and successful E2E tests for applicable modules' {
        { & $moduleGate } | Should -Not -Throw
        $env:REQUIRED_REQUESTED = 'false'
        { & $moduleGate } | Should -Throw '*PR: Run E2E Tests or PR: Run Optional E2E Tests*'
        $env:REQUIRED_REQUESTED = 'true'
        $env:CHECK_RESULT = 'skipped'
        { & $moduleGate } | Should -Throw
        $env:CHECK_RESULT = 'success'
        $env:REQUIRED_ERRORS = '["ignored defaults"]'
        { & $moduleGate } | Should -Throw '*ignored*'
    }

    It 'fails when a selected optional test or another module check fails' {
        $env:CHECK_RESULT = 'failure'
        { & $moduleGate } | Should -Throw '*selected E2E*'
        $env:HAS_REQUIRED_MODULES = 'false'
        $env:REQUIRED_REQUESTED = 'false'
        { & $moduleGate } | Should -Throw '*selected E2E*'
    }

    It 'does not require the label when no required scenarios exist' {
        $env:HAS_REQUIRED_MODULES = 'false'
        $env:REQUIRED_REQUESTED = 'false'
        { & $moduleGate } | Should -Not -Throw
    }

    It 'allows manual static-only checks without E2E enforcement' {
        $env:REQUIRE_E2E = 'false'
        $env:REQUIRED_REQUESTED = 'false'
        $env:REQUIRED_ERRORS = '["ignored defaults"]'
        { & $moduleGate } | Should -Not -Throw
        $env:CHECK_RESULT = 'failure'
        { & $moduleGate } | Should -Throw '*module checks did not succeed*'
    }

    It 'passes without applicable modules but fails closed on initialization errors' {
        $env:HAS_MODULES = 'false'
        $env:HAS_REQUIRED_MODULES = 'false'
        $env:REQUIRED_REQUESTED = 'false'
        $env:CHECK_RESULT = 'skipped'
        { & $moduleGate } | Should -Not -Throw
        $env:INITIALIZE_RESULT = 'failure'
        { & $moduleGate } | Should -Throw
        $env:INITIALIZE_RESULT = 'success'
        $env:HAS_REQUIRED_MODULES = ''
        { & $moduleGate } | Should -Throw
    }

    It 'fails closed for an invalid E2E selection' {
        $env:REQUIRED_REQUESTED = ''
        { & $moduleGate } | Should -Throw '*selection is invalid*'
        $env:REQUIRED_REQUESTED = 'true'
        $env:REQUIRE_E2E = ''
        { & $moduleGate } | Should -Throw '*enforcement selection is invalid*'
    }
}
