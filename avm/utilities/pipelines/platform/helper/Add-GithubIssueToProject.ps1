<#
.SYNOPSIS
Adds an existing GitHub issue to an existing GitHub project (the new type, not the classic ones)

.DESCRIPTION
Adds an existing GitHub issue to an existing GitHub project (the new type, not the classic ones)

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER ProjectNumber
Mandatory. The GitHub project number (see last part of project URL, for example 538 for https://github.com/orgs/Azure/projects/538)

.PARAMETER IssueUrl
Mandatory. The URL of the GitHub issue, like 'https://github.com/Azure/bicep-registry-modules/issues/757'

.EXAMPLE
Add-GithubIssueToProject -Repo 'Azure/bicep-registry-modules' -ProjectNumber 538 -IssueUrl 'https://github.com/Azure/bicep-registry-modules/issues/757'

.NOTES
Needs to run under a context with the permissions to read/write organization projects
#>
function Add-GithubIssueToProject {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $true)]
        [int] $ProjectNumber,

        [Parameter(Mandatory = $true)]
        [string] $IssueUrl
    )

    $Organization = $Repo.Split('/')[0]

    $Project = gh api graphql -f query='
  query($organization: String! $number: Int!){
    organization(login: $organization){
      projectV2(number: $number) {
        id
      }
    }
  }' -f organization=$Organization -F number=$ProjectNumber | ConvertFrom-Json -Depth 10

    $ProjectId = $Project.data.organization.projectV2.id
    $IssueId = (gh issue view $IssueUrl.Replace('api.', '').Replace('repos/', '') --repo $Repo --json 'id' | ConvertFrom-Json -Depth 100).id

    gh api graphql -f query='
  mutation($project:ID!, $issue:ID!) {
    addProjectV2ItemById(input: {projectId: $project, contentId: $issue}) {
      item {
        id
      }
    }
  }' -f project=$ProjectId -f issue=$IssueId
}
