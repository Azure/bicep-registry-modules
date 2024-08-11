<#
.SYNOPSIS
Checks new PRs and adds labels, depending if module owner can approve, or core team is needed

.DESCRIPTION
For the given PR, the "needs core team" label will be added, if the module is orphaned or the sole module owner is creating the PR

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.PARAMETER PrUrl
Mandatory. The URL of the GitHub pull request, like 'https://github.com/Azure/bicep-registry-modules/pull/2540'

.EXAMPLE
Set-AvmGitHubPrLabels -Repo 'Azure/bicep-registry-modules' -PrUrl 'https://github.com/Azure/bicep-registry-modules/pull/2540'

.NOTES
Will be triggered by the corresponding platform workflow
#>
function Set-AvmGitHubPrLabels {
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $true)]
        [string] $PrUrl,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'helper' 'Get-GithubPrRequestedReviewerTeamNames.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'helper' 'Get-GithubTeamMembersLogin.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')

    $sanitizedPrUrl = $PrUrl.Replace('api.', '').Replace('repos/', '').Replace('pulls/', 'pull/')
    $pr = gh pr view $sanitizedPrUrl --json 'author,title,url,body,comments' --repo $Repo | ConvertFrom-Json -Depth 100
    $allTeamNames = [array](Get-GithubPrRequestedReviewerTeamNames -PrUrl $pr.url)
    $teamNames = [array]($allTeamNames | Where-Object { $_ -ne 'bicep-admins' -and $_ -ne 'avm-core-team-technical-bicep' -and $_ -ne 'avm-module-reviewers-bicep' })

    if ($allTeamNames.Count -gt 0) {
        # core team is already assigned, no or more than one module reviewer team is assigned
        if ($allTeamNames.Contains('avm-core-team-technical-bicep') -or $teamNames.Count -eq 0 -or $teamNames.Count -gt 1) {
            gh pr edit $pr.url --add-label 'Needs: Core Team :genie:' --repo $Repo
        } else {
            $teamMembers = [array](Get-GithubTeamMembersLogin -OrgName $Repo.Split('/')[0] -TeamName $teamNames[0])

            # no members in module team or only one and that user submitted the PR
            if (($teamMembers.Count -eq 0) -or ($teamMembers.Count -eq 1 -and $teamMembers[0] -eq $pr.author.login)) {
                gh pr edit $pr.url --add-label 'Needs: Core Team :genie:' --repo $Repo
            } else {
                gh pr edit $pr.url --add-label 'Needs: Module Owner :mega:' --repo $Repo
            }

            # check for orphanded module
            $moduleName = $teamNames[0]
            $moduleIndex = $moduleName.StartsWith('avm-res') ? 'Bicep-Resource' : ($moduleName.StartsWith('avm-ptn') ? 'Bicep-Pattern' : 'Bicep-Utility')
            # get CSV data
            $modules = Get-AvmCsvData -ModuleIndex $moduleIndex

            foreach ($module in $modules) {
                if ($module.ModuleName.Replace('-', '').Replace('/', '-') -eq $moduleName) {
                    if ($module.ModuleStatus -eq 'Orphaned :eyes:') {
                        gh pr edit $pr.url --add-label 'Status: Module Orphaned :eyes:' --repo $Repo
                        break;
                    }
                }
            }
        }
    }
}
