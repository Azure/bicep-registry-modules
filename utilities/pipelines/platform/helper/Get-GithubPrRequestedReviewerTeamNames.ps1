<#
.SYNOPSIS
Gets all requested reviewer names that are teams (not individual users) for a given GitHub pull request

.DESCRIPTION
Gets all requested reviewer names that are teams (not individual users) for a given GitHub pull request

.PARAMETER PrUrl
Mandatory. The GitHub pull request URL (for example https://github.com/Azure/bicep-registry-modules/pull/2540)

.EXAMPLE
Get-GithubPrRequestedReviewerTeamNames -PrUrl 'https://github.com/Azure/bicep-registry-modules/pull/2540'

.NOTES
Needs to run under a context with the permissions to read pull requests
#>
function Get-GithubPrRequestedReviewerTeamNames {
    param (
        [Parameter(Mandatory = $true)]
        [string] $PrUrl
    )

    $modifiedPrUrl = ($PrUrl.Replace('https://github.com', '/repos').Replace('/pull', '/pulls') + '/requested_reviewers')
    $reviewers = (gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' $modifiedPrUrl) | ConvertFrom-Json -Depth 100

    return $reviewers.teams | Select-Object -ExpandProperty name
}
