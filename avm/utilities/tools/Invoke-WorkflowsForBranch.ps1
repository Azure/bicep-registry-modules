#region helper functions

<#
.SYNOPSIS
Invoke a given GitHub workflow

.DESCRIPTION
Invoke a given GitHub workflow

.PARAMETER PersonalAccessToken
Mandatory. The GitHub PAT to leverage when interacting with the GitHub API.

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository to trigger the workflows in.

.PARAMETER WorkflowFileName
Mandatory. The name of the workflow to trigger

.PARAMETER TargetBranch
Optional. The branch to trigger the pipeline for.

.PARAMETER WorkflowInputs
Optional. Input parameters to pass into the pipeline. Must match the names of the runtime parameters in the yaml file(s)

.EXAMPLE
Invoke-GitHubWorkflow -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -WorkflowFileName 'avm.res.analysis-services.servers.yml' -TargetBranch 'main' -WorkflowInputs @{ staticValidation = 'true'; deploymentValidation = 'true'; removeDeployment = 'true' }

Trigger the workflow 'avm.res.analysis-services.servers.yml' with branch 'main' in repository 'Azure/bicep-registry-modules'.
#>
function Invoke-GitHubWorkflow {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [hashtable] $WorkflowInputs = @{},

        [Parameter(Mandatory = $true)]
        [string] $WorkflowFileName,

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = 'main'
    )

    $requestInputObject = @{
        Method  = 'POST'
        Uri     = "https://api.github.com/repos/$RepositoryOwner/$RepositoryName/actions/workflows/$WorkflowFileName/dispatches"
        Headers = @{
            Authorization = "Bearer $PersonalAccessToken"
        }
        Body    = @{
            ref    = $TargetBranch
            inputs = $WorkflowInputs
        } | ConvertTo-Json
    }
    if ($PSCmdlet.ShouldProcess("GitHub workflow [$WorkflowFileName] for branch [$TargetBranch]", 'Invoke')) {
        try {
            $response = Invoke-RestMethod @requestInputObject -Verbose:$false
        } catch {
            Write-Error ("Request failed for [$WorkflowFileName]. Response: [{0}]" -f $_.ErrorDetails)
            return $false
        }
        if ($response) {
            Write-Error "Request failed. Response: [$response]"
            return $false
        }
    }

    return $true
}

<#
.SYNOPSIS
Get a list of all GitHub module workflows

.DESCRIPTION
Get a list of all GitHub module workflows. Does not return all properties but only the relevant ones.

.PARAMETER PersonalAccessToken
Mandatory. The GitHub PAT to leverage when interacting with the GitHub API.

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository to fetch the workflows from.

.PARAMETER Filter
Optional. A filter to apply when fetching the workflows. By default we fetch all module workflows (avm.res.*).

.EXAMPLE
Get-GitHubModuleWorkflowList -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules'

Get all module workflows from repository 'Azure/bicep-registry-modules'
#>
function Get-GitHubModuleWorkflowList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [string] $Filter = 'avm.res.*'
    )

    $allWorkflows = @()
    $page = 1
    do {
        $requestInputObject = @{
            Method  = 'GET'
            Uri     = "https://api.github.com/repos/$RepositoryOwner/$RepositoryName/actions/workflows?per_page=100&page=$page"
            Headers = @{
                Authorization = "Bearer $PersonalAccessToken"
            }
        }
        $response = Invoke-RestMethod @requestInputObject

        if (-not $response.workflows) {
            Write-Error "Request failed. Reponse: [$response]"
        }

        $allWorkflows += $response.workflows | Select-Object -Property @('id', 'name', 'path', 'badge_url') | Where-Object { (Split-Path $_.path -Leaf) -like $Filter }

        $expectedPages = [math]::ceiling($response.total_count / 100)
        $page++
    } while ($page -le $expectedPages)

    return $allWorkflows
}
#endregion

<#
.SYNOPSIS
Trigger all pipelines for GitHub

.DESCRIPTION
Trigger all workflows for the given GitHub repository. By default, pipelines are filtered to AVM module pipelines.

.PARAMETER PersonalAccessToken
Mandatory. The PAT to use to interact with either GitHub / Azure DevOps.

.PARAMETER TargetBranch
Optional. The branch to run the pipelines for (e.g. `main`). Defaults to currently checked-out branch.

.PARAMETER PipelineFilter
Optional. The pipeline files to filter down to. By default only files with a name that starts with 'avm.res.*' are considered. E.g. 'avm.res.*'.

.PARAMETER SkipPipelineBadges
Optional. Specify to disable the output of generated pipeline status badges for the given pipeline configuration.

.PARAMETER RepositoryOwner
Optional. The GitHub organization to run the workfows in.

.PARAMETER RepositoryName
Optional. The GitHub repository to run the workfows in.

.PARAMETER WorkflowInputs
Optional. The inputs to pass into the workflows. Defaults to only run static validation.

.PARAMETER InvokeForDiff
Optional. Trigger workflows only for those who's module files have changed (based on diff of branch to main)

.EXAMPLE
Invoke-WorkflowsForBranch -PersonalAccessToken '<Placeholder>' -TargetBranch 'feature/branch' -PipelineFilter 'avm.res.*' -WorkflowInputs @{ staticValidation = 'true'; deploymentValidation = 'true'; removeDeployment = 'true' }

Run all GitHub workflows that start with'avm.res.*' using branch 'feature/branch'. Also returns all GitHub status badges.

.EXAMPLE
Invoke-WorkflowsForBranch -PersonalAccessToken '<Placeholder>' -TargetBranch 'feature/branch' -PipelineFilter 'avm.res.*' -WorkflowInputs @{ staticValidation = 'true'; deploymentValidation = 'true'; removeDeployment = 'true' } -WhatIf

Only simulate the triggering of all GitHub workflows that start with'avm.res.*' using branch 'feature/branch'. Hence ONLY returns all GitHub status badges.

.EXAMPLE
Invoke-WorkflowsForBranch -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'MyFork'

Only simulate the triggering of all GitHub workflows of project [MyFork/bicep-registry-modules] that start with'avm.res.*', using the current locally checked out branch. Also returns all GitHub status badges.
#>
function Invoke-WorkflowsForBranch {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $false)]
        [string] $TargetBranch = (git branch --show-current),

        [Parameter(Mandatory = $false)]
        [string] $PipelineFilter = 'avm.res.*',

        [Parameter(Mandatory = $false)]
        [switch] $InvokeForDiff,

        [Parameter(Mandatory = $false)]
        [switch] $SkipPipelineBadges,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryOwner = 'Azure',

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName = 'bicep-registry-modules',

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName,

        [Parameter(Mandatory = $false)]
        [hashtable] $WorkflowInputs = @{
            staticValidation     = 'true'
            deploymentValidation = 'false'
            removeDeployment     = 'false'
        }
    )

    $baseInputObject = @{
        PersonalAccessToken = $PersonalAccessToken
        RepositoryOwner     = $RepositoryOwner
        RepositoryName      = $RepositoryName
    }

    Write-Verbose 'Fetching current GitHub workflows' -Verbose
    $workflows = Get-GitHubModuleWorkflowList @baseInputObject -Filter $PipelineFilter
    Write-Verbose ("Fetched [{0}] workflows" -f $workflows.Count) -Verbose

    if ($InvokeForDiff) {
        # Load used function
        . (Join-Path $RepoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-PipelineFileName.ps1')

        # Get diff
        $diff = git diff 'main' --name-only

        # Identify pipeline names
        $pipelineNames = [System.Collections.ArrayList]@()
        $pipelineNames = $diff | ForEach-Object {
            $folderPath = Split-Path $_ -Parent
            $pipelineFileName = Get-PipelineFileName -ResourceIdentifier $folderPath
            if ($pipelineFileName -match $PipelineFilter) {
                $pipelineFileName
            }
        } | Select-Object -Unique

        # Filter workflows
        $workflows = $workflows | Where-Object { $pipelineNames -contains (Split-Path $_.path -Leaf) }

        Write-Verbose ("As per 'diff', filtered workflows down to [{0}]" -f $workflows.Count)
    }


    $gitHubWorkflowBadges = [System.Collections.ArrayList]@()

    Write-Verbose "Triggering GitHub workflows for branch [$TargetBranch]" -Verbose
    foreach ($workflow in $workflows) {

        $workflowFileName = Split-Path $Workflow.path -Leaf

        if ($PSCmdlet.ShouldProcess("GitHub workflow [$workflowFileName] for branch [$TargetBranch]", 'Invoke')) {
            $null = Invoke-GitHubWorkflow @baseInputObject -TargetBranch $TargetBranch -WorkflowFileName $workflowFileName -WorkflowInputs $WorkflowInputs
        }

        # Generate pipeline badges
        if (-not $SkipPipelineBadges) {
            $encodedBranch = [uri]::EscapeDataString($TargetBranch)
            $workflowUrl = "https://github.com/$RepositoryOwner/$RepositoryName/actions/workflows/$workflowFileName"
            $gitHubWorkflowBadges += "[![$($workflow.name)]($workflowUrl/badge.svg?branch=$encodedBranch&event=workflow_dispatch)]($workflowUrl)"
        }
    }

    if ($gitHubWorkflowBadges.Count -gt 0) {
        Write-Verbose 'GitHub Workflow Badges' -Verbose
        Write-Verbose '======================' -Verbose
        Write-Verbose ($gitHubWorkflowBadges | Sort-Object | Out-String) -Verbose
    }
}