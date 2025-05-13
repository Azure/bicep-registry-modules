<#
.SYNOPSIS
Get a list of all GitHub issues for a given repository.

.DESCRIPTION
Via the function's parameters you can filter the issues to your needs.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER RepositoryOwner
Optional. The GitHub organization the issues are located in.

.PARAMETER RepositoryName
Optional. The GitHub repository the issues are located in.

.PARAMETER State
Optional. Indicates the state of the issues to return.

.PARAMETER Assignee
Optional. Pass in `none` for issues with no assigned user, `*` for issues assigned to any user, or `all` for either.

.PARAMETER SortBy
Optional. What to sort results by.

.PARAMETER SortDirection
Optional. The direction to sort the results by.

.EXAMPLE
Get-GitHubIssueList -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules'

Get all issues from the repository [Azure/bicep-registry-modules] with the default parameters.
#>
function Get-GitHubIssueList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('open', 'closed', 'all')]
        [string] $State = 'open',

        [Parameter(Mandatory = $false)]
        [ValidateSet('*', 'none', 'all')]
        [string] $Assignee = 'all',

        [Parameter(Mandatory = $false)]
        [ValidateSet('created', 'updated', 'comments')]
        [string] $SortBy = 'created',

        [Parameter(Mandatory = $false)]
        [ValidateSet('asc', 'desc')]
        [string] $SortDirection = 'desc'
    )

    $allIssues = @()

    $page = 1
    do {
        $queryParameters = @(
            "sort=$SortBy",
            "direction=$SortDirection",
            "state=$State",
            'per_page=100',
            "page=$page"
        )
        if ($Assignee -ne 'all') {
            $queryParameters += "assignee=$Assignee"
        }
        $queryParameters = $queryParameters -join '&'
        $queryUrl = "/repos/$RepositoryOwner/$RepositoryName/issues?$queryParameters"
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
            $response = (gh api @requestInputObject | ConvertFrom-Json -AsHashtable)
        }

        $allIssues += $response | Where-Object {
            # In the API, PRs are considered issues too. See 'Note' at https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#get-an-issue
            $_.Keys -notcontains 'pull_request'
        }

        $page++
    } while ($response)

    return $allIssues
}
