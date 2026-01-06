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

.NOTES
Needs to run under a context with the permissions to read/write organization projects
#>
function Add-GitHubIssueToProject {
    param (
        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $true)]
        [int] $ProjectNumber,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByUrl')]
        [string] $IssueUrl,

        [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
        [string] $IssueId
    )

    $Project = gh api graphql -f query='
  query($organization: String! $number: Int!){
    organization(login: $organization){
      projectV2(number: $number) {
        id
      }
    }
  }' -f organization=$RepositoryOwner -F number=$ProjectNumber | ConvertFrom-Json -Depth 10

    $ProjectId = $Project.data.organization.projectV2.id
    if ([String]::IsNullOrEmpty($IssueId)) {
        $IssueId = (gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --repo "$RepositoryOwner/$RepositoryName" --json 'id' | ConvertFrom-Json -Depth 100).id
    }

    $null = gh api graphql -f query='
  mutation($project:ID!, $issue:ID!) {
    addProjectV2ItemById(input: {projectId: $project, contentId: $issue}) {
      item {
        id
      }
    }
  }' -f project=$ProjectId -f issue=$IssueId
}
