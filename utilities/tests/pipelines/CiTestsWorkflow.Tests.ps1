param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    Import-Module powershell-yaml -ErrorAction Stop
    $workflowPath = Join-Path $RepoRootPath '.github' 'workflows' 'platform.ci-tests.yml'
    $workflowContent = Get-Content -LiteralPath $workflowPath -Raw
    $workflow = $workflowContent | ConvertFrom-Yaml
    $testCiContent = Get-Content -LiteralPath (
        Join-Path $RepoRootPath 'utilities' 'tests' 'Test-CI.ps1'
    ) -Raw
    . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'Set-PesterGitHubOutput.ps1')
}

Describe 'Platform CI utility test workflow' {
    It 'runs before merge when files covered by the utility suite change' {
        $workflow.on.pull_request.types | Should -Be @('opened', 'reopened', 'synchronize')
        $workflow.on.pull_request.paths | Should -Contain '.github/**'
        $workflow.on.pull_request.paths | Should -Contain 'utilities/**'
        $workflow.on.pull_request.paths | Should -Contain 'avm/**'
        $workflow.on.pull_request.paths | Should -Contain 'bicepconfig.json'
        $workflow.on.ContainsKey('pull_request_target') | Should -BeFalse
        $workflow.permissions.contents | Should -BeExactly 'read'
    }

    It 'retains only manual and pull request coverage' {
        $workflow.on.ContainsKey('push') | Should -BeFalse
        $workflow.on.ContainsKey('schedule') | Should -BeFalse
        $workflow.on.ContainsKey('workflow_dispatch') | Should -BeTrue
        $workflow.jobs.'job_run_tests'.steps[2].uses |
            Should -BeExactly 'azure/powershell@53dd145408794f7e80f97cfcca04155c85234709'
    }

    It 'keeps registry fixture compilation restorable and handles symbolic Bicep resources' {
        $registryTest = Get-Content -LiteralPath (
            Join-Path $RepoRootPath 'utilities' 'tests' 'pipelines' 'RegistryReplicationRegion.Tests.ps1'
        ) -Raw
        $labTest = Get-Content -LiteralPath (
            Join-Path $RepoRootPath 'utilities' 'tests' 'pipelines' 'LabFixtureNaming.Tests.ps1'
        ) -Raw
        $registryTest | Should -Not -Match 'bicep build .*--no-restore'
        $labTest | Should -Match 'System\.Collections\.IDictionary'
    }

    It 'omits passed-test detail from the large CI summary' {
        $testCiContent | Should -Match 'ExcludePassedTests\s*=\s*\$true'
        $passedTest = [pscustomobject] @{
            StandardOutput = @{}
            ExpandedName = 'Passing fixture test'
        }
        $results = [pscustomobject] @{
            TotalCount  = 1
            Passed      = @($passedTest)
            Failed      = @()
            Skipped     = @()
        }
        $summaryPath = Join-Path $TestDrive 'summary.md'

        Set-PesterGitHubOutput -PesterTestResults $results -OutputFilePath $summaryPath -ExcludePassedTests

        $summary = Get-Content -LiteralPath $summaryPath -Raw
        $summary | Should -Match 'Passed test details omitted'
        $summary | Should -Not -Match 'Passing fixture test'
    }
}
