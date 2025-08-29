<#
.SYNOPSIS
Adds an existing GitHub issue to an existing GitHub project (the new type, not the classic ones)

.DESCRIPTION
Adds an existing GitHub issue to an existing GitHub project (the new type, not the classic ones)

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository.

.PARAMETER ProjectNumber
Mandatory. The GitHub project number (see last part of project URL, for example 538 for https://github.com/orgs/Azure/projects/538)

.PARAMETER IssueUrl
Condtional. The URL of the GitHub issue, like 'https://github.com/Azure/bicep-registry-modules/issues/757' . Required if IssueId is not specified.

.PARAMETER IssueId
Condtional. The GH issue ID, like '3154954746'. Note: This is not the same as the issue number. Required if IssueUrl is not specified.

.EXAMPLE
Add-GitHubIssueToProject -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -ProjectNumber 538 -IssueUrl 'https://github.com/Azure/bicep-registry-modules/issues/757'

Add the issue 757 to proejct 538.

.EXAMPLE
Add-GitHubIssueToProject -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules' -ProjectNumber 538 -IssueUrl 'https://github.com/Azure/bicep-registry-modules/issues/757'

.NOTES
Needs to run under a context with the permissions to read/write organization projects
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
