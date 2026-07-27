#region helper functions
<#
.SYNOPSIS
Invoke the re-run for a given set of workflow runs.

.DESCRIPTION
Invoke the re-run for a given set of workflow runs.

.PARAMETER RestInputObject
Mandatory. The REST parameters to use for the re-run. Must contain the 'RepositoryOwner' and 'RepositoryName' keys and may contain the 'PersonalAccessToken' key.

.PARAMETER RunsToReTrigger
Manadatory. The workflow runs to re-trigger.

.PARAMETER TotalNumberOfWorkflows
Mandatory. The total number of workflows to re-trigger.

.PARAMETER TargetBranch
Optional. The branch the runs belong to. Only used for logging. Defaults to 'main'.

.EXAMPLE
Invoke-ReRun -RestInputObject @{ RepositoryOwner = 'Azure'; RepositoryName = 'bicep-registry-modules' } -RunsToReTrigger @(@{ id = 123; name = 'keyvaultworkflow'}) -TotalNumberOfWorkflows 123

Re-run the failed jobs for all provided runs in the repository [Azure/bicep-registry-modules].
#>
function Invoke-ReRun {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $RestInputObject,

        [Parameter(Mandatory)]
        [object[]] $RunsToReTrigger,

        [Parameter(Mandatory)]
        [int] $TotalNumberOfWorkflows,

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = 'main'
    )

    $totalCount = $RunsToReTrigger.Count
    $currentCount = 1
    Write-Verbose ('Runs to re-run failed jobs for [{0}/{1}]' -f $RunsToReTrigger.Count, $TotalNumberOfWorkflows) -Verbose
    foreach ($run in $RunsToReTrigger) {
        $percentageComplete = [math]::Round(($currentCount / $totalCount) * 100)
        Write-Progress -Activity ('Re-running failed jobs for workflow [{0}]' -f $run.name) -Status "$percentageComplete% complete" -PercentComplete $percentageComplete

        if ($PSCmdlet.ShouldProcess(("Re-run of failed jobs for GitHub workflow [{0}] for branch [$TargetBranch]" -f $run.name), 'Invoke')) {
            $null = Invoke-GitHubWorkflowRunFailedJobsReRun @RestInputObject -RunId $run.id
        }
        $currentCount++
    }
}

<#
.SYNOPSIS
Invoke the 'Rerun failed jobs' action for a given GitHub workflow run.

.DESCRIPTION
Invoke the 'Rerun failed jobs' action for a given GitHub workflow run.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER RepositoryOwner
Optional. The GitHub organization to run the workfows in.

.PARAMETER RepositoryName
Optional. The GitHub repository to run the workfows in.

.PARAMETER RunId
Mandatory. The ID of the run to re-run the failed jobs for.

.EXAMPLE
Invoke-GitHubWorkflowRunFailedJobsReRun -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -RunId '447791597'

Re-run the failed jobs for the GitHub workflow run with ID '447791597' in the repository [Azure/bicep-registry-modules].
#>
function Invoke-GitHubWorkflowRunFailedJobsReRun {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $RunId
    )


    $queryUrl = "/repos/$RepositoryOwner/$RepositoryName/actions/runs/$RunId/rerun-failed-jobs"
    if ($PersonalAccessToken) {
        # Using PAT
        $requestInputObject = @{
            Method  = 'POST'
            Uri     = "https://api.github.com$queryUrl"
            Headers = @{
                Authorization = "Bearer $PersonalAccessToken"
            }
        }
        $response = Invoke-RestMethod @requestInputObject
    } else {
        # Using GH API instead of 'gh workflow list' to get all results instead of just the first few
        $requestInputObject = @(
            '--method', 'POST',
            '-H', 'Accept: application/vnd.github+json',
            '-H', 'X-GitHub-Api-Version: 2022-11-28',
            $queryUrl
        )
        $response = (gh api @requestInputObject | ConvertFrom-Json)
    }

    if ("$response") {
        # If successfull, the response will be an empty custom object. Must be casted to string
        Write-Error "Request failed. Response: [$response]"
        return $false
    }

    return $true
}
#endregion

<#
.SYNOPSIS
Re-runs all failed jobs across all workflows for a given GitHub repository.

.DESCRIPTION
Re-runs all failed jobs across all workflows for a given GitHub repository.
By default, pipelines are filtered to AVM module pipelines & the main branch.
Currently running workflows are excluded.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER TargetBranch
Optional. The branch to run the pipelines for (e.g. `main`). Defaults to 'main'.

.PARAMETER PipelineFilter
Optional. The pipeline files to filter down to (regex).

.PARAMETER RepositoryOwner
Optional. The GitHub organization to run the workfows in.

.PARAMETER RepositoryName
Optional. The GitHub repository to run the workfows in.

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.PARAMETER MaxAttempts
Optional. The maximum number of attempts (GitHub 'run_attempt') a failed run may have before it is no longer re-triggered (hard stop). Defaults to 3.

.PARAMETER NonInteractive
Optional. Skips the interactive 'Should apply (y/n)?' confirmation that is shown after a -WhatIf preview, assuming 'n' (do not apply). Intended for automated / non-interactive contexts such as the scheduled re-run workflow's dry-run, so the run stays a pure simulation and never blocks on Read-Host.

.EXAMPLE
Invoke-WorkflowsFailedJobsReRun -PersonalAccessToken '<Placeholder>' -TargetBranch 'feature/branch' -PipelineFilter 'avm\.(?:res|ptn|utl)'

Run the failed jobs for all GitHub workflows that match 'avm\.(?:res|ptn|utl)' using branch 'feature/branch'.

.EXAMPLE
Invoke-WorkflowsFailedJobsReRun -PersonalAccessToken '<Placeholder>' -TargetBranch 'feature/branch' -PipelineFilter 'avm\.(?:res|ptn|utl)' -WhatIf

Only simulate the triggering of the failed jobs for all failed GitHub workflows that match 'avm\.(?:res|ptn|utl)' using branch 'feature/branch'.

.EXAMPLE
Invoke-WorkflowsFailedJobsReRun -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'MyFork'

Only simulate the triggering of the failed jobs of all GitHub workflows of project [MyFork/bicep-registry-modules] that start with'avm.res.res|ptn|utl', using the main branch & PAT.

.EXAMPLE
Invoke-WorkflowsFailedJobsReRun -RepositoryOwner 'MyFork'

Only simulate the triggering of the failed jobs of all GitHub workflows of project [MyFork/bicep-registry-modules] that start with'avm.res.res|ptn|utl', using the main branch & your current GH CLI login.
#>
function Invoke-WorkflowsFailedJobsReRun {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = 'main',

        [Parameter(Mandatory = $false)]
        [string] $PipelineFilter = 'avm\.(?:res|ptn|utl)',

        [Parameter(Mandatory = $false)]
        [string] $RepositoryOwner = 'Azure',

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName = 'bicep-registry-modules',

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [int] $MaxAttempts = 3,

        [Parameter(Mandatory = $false)]
        [switch] $NonInteractive
    )

    # Load helper functions
    . (Join-Path $repoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowList.ps1')
    . (Join-Path $repoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubModuleWorkflowLatestRun.ps1')

    $baseInputObject = @{
        RepositoryOwner = $RepositoryOwner
        RepositoryName  = $RepositoryName
    }
    if ($PersonalAccessToken) {
        $baseInputObject['PersonalAccessToken'] = $PersonalAccessToken
    }
    #####################################
    #    Get all workflows for branch   #
    #####################################
    Write-Verbose 'Fetching current GitHub workflows' -Verbose
    $workflows = Get-GitHubModuleWorkflowList @baseInputObject -Filter $PipelineFilter
    Write-Verbose ('Fetched [{0}] workflows' -f $workflows.Count) -Verbose


    ######################################################
    #   Analyze latest run of each workflow for branch   #
    ######################################################
    $totalCount = $workflows.Count
    $currentCount = 1
    $runsToReTrigger = [System.Collections.ArrayList]@()
    $hardStoppedRuns = [System.Collections.ArrayList]@()
    foreach ($workflow in $workflows) {

        $percentageComplete = [math]::Round(($currentCount / $totalCount) * 100)
        Write-Progress -Activity ('Analyzing workflow [{0}]' -f $workflow.name) -Status "$percentageComplete% complete" -PercentComplete $percentageComplete
        # Get relevant runs
        $latestBranchRun = Get-GitHubModuleWorkflowLatestRun @baseInputObject -WorkflowId $workflow.id -TargetBranch $TargetBranch

        if ($latestBranchRun.status -eq 'completed' -and $latestBranchRun.conclusion -eq 'failure') {
            if ($latestBranchRun.run_attempt -ge $MaxAttempts) {
                # Hard stop: skip runs that have already been attempted [MaxAttempts] times or more.
                # 'run_attempt' is the number of times the run has been started (1 on the first run),
                # so a run still failing after [MaxAttempts] attempts is left alone for manual investigation.
                Write-Verbose ('Hard stop for workflow [{0}]: run [{1}] already at attempt [{2}] (>= [{3}]). Skipping re-run.' -f $workflow.name, $latestBranchRun.id, $latestBranchRun.run_attempt, $MaxAttempts) -Verbose
                $null = $hardStoppedRuns.Add($latestBranchRun)
            } else {
                $null = $runsToReTrigger.Add($latestBranchRun)
            }
        }
        $currentCount++
    }

    ##############################
    #   Re-trigger failed runs   #
    ##############################
    # Only invoke the re-run when there is at least one run to trigger. 'Invoke-ReRun'
    # has a mandatory [object[]] parameter that rejects an empty array, and on a healthy
    # branch (all runs green or already hard-stopped) there is frequently nothing to do.
    if ($runsToReTrigger.Count -gt 0) {
        $reRunInputObject = @{
            RestInputObject        = $baseInputObject
            RunsToReTrigger        = $runsToReTrigger
            TotalNumberOfWorkflows = $workflows.Count
            TargetBranch           = $TargetBranch
        }
        # With -WhatIf the re-runs are only simulated (logged); without it they are executed.
        $null = Invoke-ReRun @reRunInputObject -WhatIf:$WhatIfPreference

        # After a -WhatIf preview, offer to apply the same (already analyzed) set of runs
        # without repeating the (potentially slow) analysis. -NonInteractive skips the
        # prompt for automated contexts (e.g. the scheduled workflow's dry-run), assuming
        # 'n' so the run stays a pure simulation and never blocks on Read-Host.
        if ($WhatIfPreference) {
            if ($NonInteractive) {
                $userInput = 'n'
            } else {
                do {
                    $userInput = Read-Host -Prompt 'Should apply (y/n)?'
                } while ($userInput -notin @('y', 'n'))
            }

            switch ($userInput) {
                'y' { $null = Invoke-ReRun @reRunInputObject -WhatIf:$false }
                'n' { return }
            }
        }
    } else {
        Write-Verbose 'No failed runs to re-trigger.' -Verbose
    }

    ##########################
    #   Re-trigger summary    #
    ##########################
    if ($WhatIfPreference) {
        $reRunState = 'that would be re-triggered'
    } else {
        $reRunState = 're-triggered'
    }
    Write-Verbose ('Re-run summary for branch [{0}]:' -f $TargetBranch) -Verbose
    Write-Verbose ('  Workflows analyzed: [{0}]' -f $workflows.Count) -Verbose
    Write-Verbose ('  Failed runs {0}: [{1}]' -f $reRunState, $runsToReTrigger.Count) -Verbose
    Write-Verbose ('  Skipped by hard stop (>= [{0}] attempts): [{1}]' -f $MaxAttempts, $hardStoppedRuns.Count) -Verbose
    if ($hardStoppedRuns.Count -gt 0) {
        Write-Verbose ('  Hard-stopped workflows: {0}' -f (($hardStoppedRuns | ForEach-Object { $_.name }) -join ', ')) -Verbose
    }

    Write-Verbose 'Re-triggering complete' -Verbose
}
