<#
The below file tests the re-run automation in:
  utilities/tools/Invoke-WorkflowsFailedJobsReRun.ps1

It focuses on the hard-stop logic of Invoke-WorkflowsFailedJobsReRun:
- Only latest runs that are 'completed' + 'failure' are considered.
- A failed run is re-triggered only while its 'run_attempt' is below [MaxAttempts].
- A failed run that reached [MaxAttempts] (or more) is left alone (hard stop).
- Successful runs are never re-triggered.
- With -WhatIf the re-run is only simulated; the user is then prompted to apply, and
  -NonInteractive skips that prompt (assuming 'n', so nothing is applied).

The upstream GitHub-querying helpers (Get-GitHubModuleWorkflowList &
Get-GitHubModuleWorkflowLatestRun) and the re-run action
(Invoke-GitHubWorkflowRunFailedJobsReRun) are mocked so no network calls are made.
#>

param(
    [Parameter(Mandatory = $false)]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

$script:repoRootPath = $repoRootPath

Describe 'Test Invoke-WorkflowsFailedJobsReRun' {

    BeforeAll {
        # Set during the run phase so it is available to child It/BeforeEach blocks
        # (top-level assignments only run during Pester discovery).
        $script:repoRootPath = $repoRootPath

        . (Join-Path $repoRootPath 'utilities' 'tools' 'Invoke-WorkflowsFailedJobsReRun.ps1')
        # The GitHub-querying helpers are dot-sourced at runtime inside the function under test.
        # Import them here as well so Pester can resolve (and therefore mock) the command names.
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowList.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowLatestRun.ps1')
    }

    Context 'Hard stop based on run_attempt' {

        BeforeEach {
            # A single module workflow to analyze.
            Mock Get-GitHubModuleWorkflowList {
                return @(
                    @{ id = 111; name = 'avm.res.kusto.cluster'; path = '.github/workflows/avm.res.kusto.cluster.yml'; state = 'active' }
                )
            }
            # Capture-only mock so no actual re-run is performed.
            Mock Invoke-GitHubWorkflowRunFailedJobsReRun { return $true }
        }

        It 'Re-triggers a failed run below the attempt limit [run_attempt = <Attempt>]' -ForEach @(
            @{ Attempt = 1 }
            @{ Attempt = 2 }
        ) {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1001; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'failure'; run_attempt = $Attempt }
            }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3

            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 1 -Exactly -ParameterFilter { $RunId -eq 1001 }
        }

        It 'Does NOT re-trigger a failed run at/above the attempt limit [run_attempt = <Attempt>] (hard stop)' -ForEach @(
            @{ Attempt = 3 }
            @{ Attempt = 4 }
        ) {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1002; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'failure'; run_attempt = $Attempt }
            }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3

            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 0 -Exactly
        }

        It 'Does NOT re-trigger a successful run' {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1003; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'success'; run_attempt = 1 }
            }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3

            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 0 -Exactly
        }

        It 'Does NOT re-trigger an in-progress run' {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1004; name = 'avm.res.kusto.cluster'; status = 'in_progress'; conclusion = $null; run_attempt = 1 }
            }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3

            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 0 -Exactly
        }

        It 'Does NOT execute the re-run when -WhatIf is specified' {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1005; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'failure'; run_attempt = 1 }
            }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3 -WhatIf -NonInteractive

            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 0 -Exactly
        }

        It 'Applies the re-run when a -WhatIf preview is confirmed interactively (Read-Host y)' {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1007; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'failure'; run_attempt = 1 }
            }
            Mock Read-Host { return 'y' }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3 -WhatIf

            # The -WhatIf preview itself does not re-run; confirming with 'y' applies it exactly once.
            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 1 -Exactly -ParameterFilter { $RunId -eq 1007 }
            Should -Invoke Read-Host -Times 1 -Exactly
        }

        It 'Does NOT prompt or apply when -WhatIf is combined with -NonInteractive' {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1008; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'failure'; run_attempt = 1 }
            }
            Mock Read-Host { throw 'Read-Host should not be called in non-interactive mode' }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3 -WhatIf -NonInteractive

            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 0 -Exactly
            Should -Invoke Read-Host -Times 0 -Exactly
        }

        It 'Honors a custom -MaxAttempts (limit = 2 stops a run at run_attempt = 2)' {
            Mock Get-GitHubModuleWorkflowLatestRun {
                return @{ id = 1006; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'failure'; run_attempt = 2 }
            }

            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 2

            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 0 -Exactly
        }
    }

    Context 'Mixed set of workflows' {

        BeforeEach {
            # Three workflows: one to re-run, one hard-stopped, one already green.
            Mock Get-GitHubModuleWorkflowList {
                return @(
                    @{ id = 111; name = 'avm.res.kusto.cluster'; path = 'p1'; state = 'active' }
                    @{ id = 222; name = 'avm.res.network.azure-firewall'; path = 'p2'; state = 'active' }
                    @{ id = 333; name = 'avm.res.container-service.managed-cluster'; path = 'p3'; state = 'active' }
                )
            }
            Mock Invoke-GitHubWorkflowRunFailedJobsReRun { return $true }

            Mock Get-GitHubModuleWorkflowLatestRun -ParameterFilter { $WorkflowId -eq 111 } -MockWith {
                return @{ id = 5001; name = 'avm.res.kusto.cluster'; status = 'completed'; conclusion = 'failure'; run_attempt = 1 }
            }
            Mock Get-GitHubModuleWorkflowLatestRun -ParameterFilter { $WorkflowId -eq 222 } -MockWith {
                return @{ id = 5002; name = 'avm.res.network.azure-firewall'; status = 'completed'; conclusion = 'failure'; run_attempt = 3 }
            }
            Mock Get-GitHubModuleWorkflowLatestRun -ParameterFilter { $WorkflowId -eq 333 } -MockWith {
                return @{ id = 5003; name = 'avm.res.container-service.managed-cluster'; status = 'completed'; conclusion = 'success'; run_attempt = 1 }
            }
        }

        It 'Re-triggers only the failed run below the attempt limit' {
            Invoke-WorkflowsFailedJobsReRun -RepoRoot $script:repoRootPath -MaxAttempts 3

            # Exactly one re-run overall.
            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 1 -Exactly
            # ...and it is the run below the limit.
            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 1 -Exactly -ParameterFilter { $RunId -eq 5001 }
            # The hard-stopped run is never re-triggered.
            Should -Invoke Invoke-GitHubWorkflowRunFailedJobsReRun -Times 0 -Exactly -ParameterFilter { $RunId -eq 5002 }
        }
    }
}
