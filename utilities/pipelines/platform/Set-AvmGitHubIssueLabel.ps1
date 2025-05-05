<#
.SYNOPSIS
Checks issues if correct labels are applied

.DESCRIPTION
For all open AVM issue, assignment of the module owner or orphanend label assignment is checked and corrected.

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Set-AvmGitHubIssueLabel -Repo 'Azure/bicep-registry-modules'

.NOTES
Will be triggered by the workflow platform.set-avm-github-issue-label.yml
#>
function Set-AvmGitHubIssueLabel {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'Set-AvmGitHubIssueOwnerConfig.ps1')

    $issues = gh issue list --state open --limit 500 --label 'Type: AVM :a: :v: :m:' --json 'url' --repo $Repo | ConvertFrom-Json -Depth 100

    foreach ($issue in $issues) {
        try {
            Set-AvmGitHubIssueOwnerConfig -Repo $Repo -IssueUrl $issue.url
        } catch {
            Write-Error $_
        }
    }
}
