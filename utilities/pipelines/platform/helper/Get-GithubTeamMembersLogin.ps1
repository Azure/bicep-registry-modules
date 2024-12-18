<#
.SYNOPSIS
Gets the login name of all team members for a given GitHub team

.DESCRIPTION
Gets the login name of all team members for a given GitHub team

.PARAMETER OrgName
Mandatory. The name of the GitHub organization

.PARAMETER TeamName
Mandatory. The name of the GitHub team (from that organization)

.EXAMPLE
Get-GithubTeamMembersLogin -OrgName 'Azure' -TeamName 'avm-core-team-technical-bicep'

.NOTES
Needs to run under a context with the permissions to read organisations directory
#>
function Get-GithubTeamMembersLogin {
    param (
        [Parameter(Mandatory = $true)]
        [string] $OrgName,

        [Parameter(Mandatory = $true)]
        [string] $TeamName
    )

    $teamMembers = (gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' /orgs/$OrgName/teams/$TeamName/members) | ConvertFrom-Json -Depth 100

    return $teamMembers | Select-Object -ExpandProperty login
}
