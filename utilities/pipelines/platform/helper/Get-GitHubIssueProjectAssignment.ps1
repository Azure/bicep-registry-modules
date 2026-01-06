<#
.SYNOPSIS
Get all project assignments of a given issue

.DESCRIPTION
Get all project assignments of a given issue

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository.

.PARAMETER IssueNumber
Mandatory. The GitHub issue number (see last part of project URL, for example 538 for https://github.com/Azure/bicep-registry-modules/issues/538)

.EXAMPLE
Get-GitHubIssueProjectAssignment -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -IssueNumber 5900

Get the project assignments of issue 5900.

Returns, for example,
title               number url
-----               ------ ---
AVM - Module Issues    566 https://github.com/orgs/Azure/projects/566

.NOTES
Only fetches the first 50 assignments
You can locally log into the required scope via `gh auth login --scopes read:project`
#>
function Get-GitHubIssueProjectAssignment {
    param (
        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [string] $IssueNumber
    )

    $query = @"
query {
  repository(owner: `"$RepositoryOwner`", name: `"$RepositoryName`") {
    issue(number: $IssueNumber) {
      projectItems(first: 50) {
        nodes {
          project {
            title
            number
            url
          }
        }
      }
    }
  }
}
"@

    return (gh api graphql -f query=$query | ConvertFrom-Json).data.repository.issue.projectItems.nodes.project
}
