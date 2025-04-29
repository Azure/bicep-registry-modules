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
        return @{}
    }

    return $response.workflow_runs | Select-Object -Property @('id', 'name', 'path', 'status', 'head_branch', 'created_at', 'run_number', 'run_attempt', 'conclusion', 'url')
}
