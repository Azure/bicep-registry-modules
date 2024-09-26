#region helper functions
<#
.SYNOPSIS
Get a list of all GitHub module workflows

.DESCRIPTION
Get a list of all GitHub module workflows. Does not return all properties but only the relevant ones.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub / Azure DevOps. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository to fetch the workflows from.

.PARAMETER IncludeDisabled
Optional. Set if you want to also include disabled workflows in the result.

.PARAMETER Filter
Optional. A regex filter to apply when fetching the workflows. By default we fetch all module workflows.

.EXAMPLE
Get-GitHubModuleWorkflowList -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules'

Get all module workflows from repository 'Azure/bicep-registry-modules'
#>
function Get-GitHubModuleWorkflowList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [switch] $IncludeDisabled,

        [Parameter(Mandatory = $false)]
        [string] $Filter = 'avm\.(?:res|ptn|utl)'
    )

    $allWorkflows = @()

    $page = 1
    do {
        $queryUrl = "/repos/$RepositoryOwner/$RepositoryName/actions/workflows?per_page=100&page=$page"
        if ($PersonalAccessToken) {
            # Using PAT
            $requestInputObject = @{
                Method  = 'GET'
                Uri     = "https://api.github.com$queryUrl"
                Headers = @{
                    Authorization = "Bearer $PersonalAccessToken"
                }
            }
            $response = Invoke-RestMethod @requestInputObject
        } else {
            # Using GH API instead of 'gh workflow list' to get all results instead of just the first few
            $requestInputObject = @(
                '-H', 'Accept: application/vnd.github+json',
                '-H', 'X-GitHub-Api-Version: 2022-11-28',
                $queryUrl
            )
            $response = (gh api @requestInputObject | ConvertFrom-Json)
        }

        if (-not $response.workflows) {
            Write-Error "Request failed. Reponse: [$response]"
        }

        $allWorkflows += $response.workflows | Select-Object -Property @('id', 'name', 'path', 'badge_url', 'state') | Where-Object {
            $_.name -match $Filter -and
            ($IncludeDisabled ? $true : $_.state -eq 'active')
        }

        $expectedPages = [math]::ceiling($response.total_count / 100)
        $page++
    } while ($page -le $expectedPages)

    return $allWorkflows
}


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
        [int] $TotalNumberOfWorkflows
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
Get the latest run of a GitHub workflow for a given branch.

.DESCRIPTION
Get the latest run of a GitHub workflow for a given branch.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER RepositoryOwner
Optional. The GitHub organization the workfows are located in.

.PARAMETER RepositoryName
Optional. The GitHub repository the workfows are located in.

.PARAMETER WorkflowId
Required. The ID of the workflow to get the latest run for.

.PARAMETER TargetBranch
Optional. The branch to get the latest run for. Defaults to 'main'.

.EXAMPLE
Get-GitHubModuleWorkflowLatestRun -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -WorkflowId '447791597'

Get the latest workflow run of the repository [Azure/bicep-registry-modules] for a workflow with id '447791597', filtered to the 'main' branch.
#>
function Get-GitHubModuleWorkflowLatestRun {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $WorkflowId,

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = 'main'
    )

    $queryUrl = "/repos/$RepositoryOwner/$RepositoryName/actions/workflows/$WorkflowId/runs?branch=$TargetBranch&per_page=1"
    if ($PersonalAccessToken) {
        # Using PAT
        $requestInputObject = @{
            Method  = 'GET'
            Uri     = "https://api.github.com$queryUrl"
            Headers = @{
                Authorization = "Bearer $PersonalAccessToken"
            }
        }
        $response = Invoke-RestMethod @requestInputObject
    } else {
        # Using GH API instead of 'gh workflow list' to get all results instead of just the first few
        $requestInputObject = @(
            '-H', 'Accept: application/vnd.github+json',
            '-H', 'X-GitHub-Api-Version: 2022-11-28',
            $queryUrl
        )
        $response = (gh api @requestInputObject | ConvertFrom-Json)
    }

    if (-not $response.workflow_runs) {
        Write-Error "Request failed. Reponse: [$response]"
    }

    return $response.workflow_runs | Select-Object -Property @('id', 'name', 'path', 'status', 'head_branch', 'created_at', 'run_number', 'run_attempt', 'conclusion')
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
        [string] $RepositoryName = 'bicep-registry-modules'
    )

    $baseInputObject = @{
        RepositoryOwner = $RepositoryOwner
        RepositoryName  = $RepositoryName
    }
    if ($PersonalAccessToken) {
        $baseInputObject['PersonalAccessToken'] = @{
            PersonalAccessToken = $PersonalAccessToken
        }
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
    foreach ($workflow in $workflows) {

        $percentageComplete = [math]::Round(($currentCount / $totalCount) * 100)
        Write-Progress -Activity ('Analyzing workflow [{0}]' -f $workflow.name) -Status "$percentageComplete% complete" -PercentComplete $percentageComplete
        # Get relevant runs
        $latestBranchRun = Get-GitHubModuleWorkflowLatestRun @baseInputObject -WorkflowId $workflow.id -TargetBranch $TargetBranch

        if ($latestBranchRun.status -eq 'completed' -and $latestBranchRun.conclusion -eq 'failure') {
            $runsToReTrigger += $latestBranchRun
        }
        $currentCount++
    }

    ##############################
    #   Re-trigger failed runs   #
    ##############################
    $reRunInputObject = @{
        RestInputObject        = $baseInputObject
        RunsToReTrigger        = $runsToReTrigger
        TotalNumberOfWorkflows = $workflows.Count
    }
    $null = Invoke-ReRun @reRunInputObject -WhatIf:$WhatIfPreference

    # Enable the user to execute the invocation if the whatif looked good
    if ($WhatIfPreference) {
        do {
            $userInput = Read-Host -Prompt 'Should apply (y/n)?'
        }
        while ($userInput -notin @('y', 'n'))

        switch ($userInput) {
            'y' {
                $null = Invoke-ReRun @reRunInputObject -WhatIf:$false
            }
            'n' { return }
        }
    }

    Write-Verbose 'Re-triggerung complete' -Verbose
}
