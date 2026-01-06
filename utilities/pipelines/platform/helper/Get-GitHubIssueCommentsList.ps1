<#
.SYNOPSIS
Get a list of all comments of a given issue

.DESCRIPTION
Get a list of all comments of a given issue

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub / Azure DevOps. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository to fetch the comments from.

.PARAMETER IssueNumber
Optional. The issue number to get the comments for. If not provided, all comments for the repository will be returned.

.PARAMETER SinceWhen
Optional. Only show comments created since this date. Format: YYYY-MM-DDTHH:MM:SSZ

.EXAMPLE
Get-GitHubIssueCommentsList -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -IssueNumber '1234'

Get all comments of the issue 1234 of the repository 'Azure/bicep-registry-modules'

.EXAMPLE
Get-GitHubIssueCommentsList-RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules'

Get all comments of the repository 'Azure/bicep-registry-modules' using the GitHub CLI for authentication

.EXAMPLE
Get-GitHubIssueCommentsList -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -IssueNumber '1234' -SinceWhen (Get-Date).ToString('yyyy-MM-ddT00:00:00Z')

Get all comments of the issue 1234 of the repository 'Azure/bicep-registry-modules' that were created today
#>
function Get-GitHubIssueCommentsList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [string] $IssueNumber,

        [Parameter(Mandatory = $false)]
        [string] $SinceWhen
    )

    $allComments = @()

    $page = 1
    do {
        $queryParameters = @(
            'per_page=100',
            "page=$page"
        )
        if (-not [String]::IsNullOrEmpty($SinceWhen)) {
            $queryParameters += "since=$SinceWhen"
        }
        $queryParameters = $queryParameters -join '&'

        $queryUrl = "/repos/$RepositoryOwner/$RepositoryName/issues{0}/comments?$queryParameters" -f ($IssueNumber ? "/$IssueNumber" : '')
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

        $allComments += $response

        $page++
    } while ($response)

    return $allComments
}
