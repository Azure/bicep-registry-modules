<#
.SYNOPSIS
Requests reviews from the module owners declared in metadata.json and labels the pull request accordingly.

.DESCRIPTION
Maps the files changed by a pull request to their top-level AVM modules and requests a review from the individuals and teams listed in each module's metadata.json file. Modules without declared owners fall back to the shared module owners team. Approval rights are governed by repository permissions, not by this function.

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
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    # Loading helper functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmModuleMetadataOwner.ps1')

    $fallbackTeam = 'Azure/azure-verified-modules-module-owners'

    $sanitizedPrUrl = $PrUrl.Replace('api.', '').Replace('repos/', '').Replace('pulls/', 'pull/')
    $pr = gh pr view $sanitizedPrUrl --json 'author,number,url,isDraft,reviewRequests,reviews' --repo $Repo | ConvertFrom-Json -Depth 100
    if ($LASTEXITCODE -ne 0 -or $null -eq $pr.number) {
        throw "Unable to retrieve pull request [$sanitizedPrUrl]."
    }
    if ($pr.isDraft) {
        Write-Verbose "Skipping reviewer routing for draft pull request [$($pr.url)]."
        return
    }

    $changedFilePaths = @(gh api --paginate "repos/$Repo/pulls/$($pr.number)/files?per_page=100" --jq '.[] | .filename, (.previous_filename // empty)')
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to retrieve changed files for pull request [$($pr.url)]."
    }

    $moduleFolderPaths = @()
    $needsCoreTeam = $false
    foreach ($filePath in $changedFilePaths) {
        if ($filePath -like '*avm.core.team.tests.ps1' -or $filePath -like '*.e2eignore') {
            $needsCoreTeam = $true
        }
        if ($filePath -match '^avm/(res|ptn|utl)/[^/]+/[^/]+(/.*)?/[^/]+$') {
            $moduleFolderPaths += $filePath -replace '/[^/]+$', ''
        } else {
            $needsCoreTeam = $true
        }
    }
    $moduleFolderPaths = @($moduleFolderPaths | Sort-Object -Unique)

    $ownerHandles = @()
    $hasOrphanedModule = $false
    foreach ($moduleFolderPath in $moduleFolderPaths) {
        $moduleOwners = @(Get-AvmModuleMetadataOwner -ModulePath $moduleFolderPath -RepoRoot $RepoRoot)
        if ($moduleOwners.Count -eq 0) {
            Write-Warning "Module [$moduleFolderPath] does not declare any owners. Notifying [$fallbackTeam] instead."
            $hasOrphanedModule = $true
            $moduleOwners = @($fallbackTeam)
        }
        $ownerHandles += $moduleOwners
    }
    $ownerHandles = @($ownerHandles | Sort-Object -Unique)

    $requestedLogins = @($pr.reviewRequests | Where-Object { $_.login } | ForEach-Object { $_.login })
    $requestedTeamSlugs = @($pr.reviewRequests | Where-Object { -not $_.login } | ForEach-Object { if ($_.slug) { $_.slug } else { $_.name } })
    $reviewedLogins = @($pr.reviews.author | Where-Object { $_.login } | ForEach-Object { $_.login })

    $newReviewers = @($ownerHandles | Where-Object {
            if ($_.Contains('/')) {
                return $requestedTeamSlugs -notcontains ($_ -split '/')[-1]
            }
            return $_ -ne $pr.author.login -and $requestedLogins -notcontains $_ -and $reviewedLogins -notcontains $_
        })

    $label = ($needsCoreTeam -or $hasOrphanedModule) ? 'Needs: Core Team :genie:' : 'Needs: Module Owner :mega:'
    $editArguments = @('pr', 'edit', $pr.url, '--add-label', $label, '--repo', $Repo)
    if ($hasOrphanedModule) {
        $editArguments += @('--add-label', 'Status: Module Orphaned :yellow_circle:')
    }
    if ($newReviewers.Count -gt 0) {
        $editArguments += @('--add-reviewer', ($newReviewers -join ','))
    }
    $null = gh @editArguments
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to update reviewer routing for pull request [$($pr.url)]."
    }
}
