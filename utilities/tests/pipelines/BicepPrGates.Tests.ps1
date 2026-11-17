param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflowContent = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml') -Raw
    $workflow = $workflowContent | ConvertFrom-Yaml
    $moduleGateJob = $workflow.jobs.'module-gate'
    $moduleGate = [scriptblock]::Create($moduleGateJob.steps[0].run)
    $feedbackStep = $moduleGateJob.steps[1]
    $environmentNames = @('INITIALIZE_RESULT', 'HAS_MODULES', 'CHECK_RESULT', 'HAS_REQUIRED_MODULES',
        'REQUIRED_REQUESTED', 'REQUIRED_ERRORS', 'REQUIRE_E2E', 'GITHUB_OUTPUT', 'GITHUB_STEP_SUMMARY')

    function Invoke-ModuleGateChildProcess {
        param(
            [Parameter(Mandatory)]
            [string] $ScriptPath,
            [Parameter(Mandatory)]
            [scriptblock] $Script
        )

        [IO.File]::WriteAllText($ScriptPath, $Script.ToString())
        $output = & pwsh -NoLogo -NoProfile -File $ScriptPath 2>&1
        $exitCode = $LASTEXITCODE
        return [pscustomobject] @{
            ExitCode = $exitCode
            Output   = $output -join [Environment]::NewLine
        }
    }
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
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'gate-output.txt'
        $env:GITHUB_STEP_SUMMARY = Join-Path $TestDrive 'gate-summary.md'
        [IO.File]::WriteAllText($env:GITHUB_OUTPUT, '')
        [IO.File]::WriteAllText($env:GITHUB_STEP_SUMMARY, '')
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
        $result = Invoke-ModuleGateChildProcess -ScriptPath (Join-Path $TestDrive 'missing-label-gate.ps1') -Script $moduleGate
        $result.ExitCode | Should -Be 1
        $result.Output | Should -Match '::error title=Bicep E2E label required::'
        $result.Output | Should -Match '`PR: Run E2E Tests`'
        $result.Output | Should -Match '`PR: Run Optional E2E Tests`'
        Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw | Should -Match 'requiredLabelMissing=true'
        $summary = Get-Content -LiteralPath $env:GITHUB_STEP_SUMMARY -Raw
        $summary | Should -Match '## Bicep E2E tests need a label'
        $summary | Should -Match 'required scenarios only'
        $summary | Should -Match 'required and optional scenarios'
        $summary | Should -Match 'labels do not grant deployment credentials'
        $summary | Should -Match 'authorized same-repository release branch'
        $env:REQUIRED_REQUESTED = 'true'
        [IO.File]::WriteAllText($env:GITHUB_OUTPUT, '')
        [IO.File]::WriteAllText($env:GITHUB_STEP_SUMMARY, '')
        { & $moduleGate } | Should -Not -Throw
        Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw | Should -Match 'requiredLabelMissing=false'
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

    It 'publishes a sticky, non-fork PR comment with least privilege' {
        $moduleGateJob.permissions.Keys | Should -Be @('pull-requests')
        $moduleGateJob.permissions.'pull-requests' | Should -BeExactly 'write'
        $moduleGateJob.permissions.ContainsKey('contents') | Should -BeFalse
        $moduleGateJob.permissions.ContainsKey('issues') | Should -BeFalse
        $moduleGateJob.permissions.ContainsKey('id-token') | Should -BeFalse
        @($moduleGateJob.steps | Where-Object { $_.uses -like 'actions/checkout@*' }) | Should -BeNullOrEmpty
        $workflowContent.Contains('pull_request_target') | Should -BeFalse

        $feedbackStep.uses | Should -BeExactly 'actions/github-script@3a2844b7e9c422d3c10d287c895573f7108da1b3'
        $feedbackStep.ContainsKey('continue-on-error') | Should -BeFalse
        $feedbackStep.if | Should -Match 'always\(\).*pull_request.*head\.repo\.fork == false'
        $script = $feedbackStep.with.script
        $script | Should -Match 'github\.rest\.pulls\.get'
        $script | Should -Match 'pullRequest\.head\.sha'
        $script | Should -Match 'snapshotLabels'
        $script | Should -Match 'liveLabels'
        $headAndLabelGuardIndex = $script.IndexOf('if (livePullRequest.data.head.sha')
        $commentLookupIndex = $script.IndexOf('const comments = await github.paginate')
        $headAndLabelGuardIndex | Should -BeGreaterThan -1
        $headAndLabelGuardIndex | Should -BeLessThan $commentLookupIndex
        $script | Should -Match 'github\.rest\.issues\.listComments'
        $script | Should -Match 'github\.rest\.issues\.createComment'
        $script | Should -Match 'github\.rest\.issues\.updateComment'
        $script | Should -Match 'github-actions\[bot\]'
        $script | Should -Match 'error\.status !== 403'
        $script | Should -Match 'core\.warning'
        $script | Should -Match 'core\.summary'
        $script.Contains('<!-- avm-bicep-required-e2e-label-feedback -->') | Should -BeTrue
        $script.Contains('`PR: Run E2E Tests`') | Should -BeTrue
        $script.Contains('`PR: Run Optional E2E Tests`') | Should -BeTrue
        $script.Contains('to run required scenarios only') | Should -BeTrue
        $script.Contains('to run required and optional scenarios') | Should -BeTrue
        $script.Contains('Required Bicep E2E label requirement resolved') | Should -BeTrue
        $script.Contains('else if (existingComment)') | Should -BeTrue
    }
}
