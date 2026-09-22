<#
.SYNOPSIS
Requests reviews from the module owners declared in metadata.json and labels the pull request accordingly.

.DESCRIPTION
Maps the files changed by a pull request to their top-level AVM modules and requests a review from the individuals and teams listed in each module's metadata.json file. Modules without declared owners fall back to the shared module owners team. Approval rights are governed by repository permissions, not by this function.

Metadata is read from the pull request head so that modules added or updated by the pull request resolve to the intended owners. Only the metadata is read from the head; no pull request content is executed.

.PARAMETER Repo
Mandatory. The name of the respository to scan. Needs to have the structure "<owner>/<repositioryName>", like 'Azure/bicep-registry-modules/'

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.PARAMETER PrUrl
Optional. The URL of a single GitHub pull request to process, like 'https://github.com/Azure/bicep-registry-modules/pull/2540'. When omitted, every open pull request is processed.

.PARAMETER UpdatedWithinMinutes
Optional. Restricts a bulk run to pull requests updated within the given number of minutes. Ignored when PrUrl is supplied.

.EXAMPLE
Set-AvmGitHubPrLabels -Repo 'Azure/bicep-registry-modules' -PrUrl 'https://github.com/Azure/bicep-registry-modules/pull/2540'

.EXAMPLE
Set-AvmGitHubPrLabels -Repo 'Azure/bicep-registry-modules' -UpdatedWithinMinutes 30

.NOTES
Will be triggered by the corresponding platform workflow. Routing is idempotent, so reprocessing a pull request that has already been routed performs no updates.
#>
function Set-AvmGitHubPrLabels {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $false)]
        [string] $PrUrl,

        [Parameter(Mandatory = $false)]
        [int] $UpdatedWithinMinutes = 0,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    $fallbackTeam = 'Azure/azure-verified-modules-module-owners'
    $prFields = 'author,number,url,isDraft,reviewRequests,reviews,headRefOid,labels'

    if (-not [string]::IsNullOrWhiteSpace($PrUrl)) {
        $sanitizedPrUrl = $PrUrl.Replace('api.', '').Replace('repos/', '').Replace('pulls/', 'pull/')
        $pullRequests = @(gh pr view $sanitizedPrUrl --json $prFields --repo $Repo | ConvertFrom-Json -Depth 100)
        if ($LASTEXITCODE -ne 0 -or $pullRequests.Count -eq 0 -or $null -eq $pullRequests[0].number) {
            throw "Unable to retrieve pull request [$sanitizedPrUrl]."
        }
    } else {
        $pullRequests = @(gh pr list --repo $Repo --state 'open' --limit 500 --json "$prFields,updatedAt" | ConvertFrom-Json -Depth 100)
        if ($LASTEXITCODE -ne 0) {
            throw "Unable to retrieve the open pull requests of [$Repo]."
        }
        if ($UpdatedWithinMinutes -gt 0) {
            $cutoff = (Get-Date).ToUniversalTime().AddMinutes(-$UpdatedWithinMinutes)
            $pullRequests = @($pullRequests | Where-Object { $_.updatedAt -and ([datetime]$_.updatedAt).ToUniversalTime() -ge $cutoff })
        }
        Write-Verbose "Processing [$($pullRequests.Count)] open pull request(s)." -Verbose
    }

    $failures = @()
    foreach ($pr in $pullRequests) {
        try {
            Set-AvmGitHubPrLabelsForPr -Repo $Repo -RepoRoot $RepoRoot -PullRequest $pr -FallbackTeam $fallbackTeam
        } catch {
            # A single unroutable pull request must not stop the remaining ones on a scheduled run.
            $failures += "[$($pr.url)]: $($_.Exception.Message)"
            Write-Warning "Failed to route pull request [$($pr.url)]. $($_.Exception.Message)"
        }
    }

    if ($failures.Count -gt 0) {
        throw ($failures -join [System.Environment]::NewLine)
    }
}

function Set-AvmGitHubPrLabelsForPr {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Repo,

        [Parameter(Mandatory = $true)]
        [string] $RepoRoot,

        [Parameter(Mandatory = $true)]
        [object] $PullRequest,

        [Parameter(Mandatory = $true)]
        [string] $FallbackTeam
    )

    $pr = $PullRequest
    $fallbackTeam = $FallbackTeam

    # Loading helper functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmModuleMetadataOwner.ps1')

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

    # Fork commits are reachable through the base repository, which keeps this read within the scope
    # of the GitHub App installation token. The fork itself is not accessible to that token.
    $metadataSource = @{}
    if (-not [string]::IsNullOrWhiteSpace($pr.headRefOid)) {
        $metadataSource = @{
            SourceRepo = $Repo
            SourceRef  = $pr.headRefOid
        }
    }

    $ownerHandles = @()
    $hasOrphanedModule = $false
    foreach ($moduleFolderPath in $moduleFolderPaths) {
        $moduleOwners = @(Get-AvmModuleMetadataOwner -ModulePath $moduleFolderPath -RepoRoot $RepoRoot @metadataSource)
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

    $desiredLabels = @(($needsCoreTeam -or $hasOrphanedModule) ? 'Needs: Core Team :genie:' : 'Needs: Module Owner :mega:')
    if ($hasOrphanedModule) {
        $desiredLabels += 'Status: Module Orphaned :yellow_circle:'
    }
    $existingLabels = @($pr.labels | Where-Object { $_.name } | ForEach-Object { $_.name })
    $newLabels = @($desiredLabels | Where-Object { $existingLabels -notcontains $_ })

    # Only write when something actually changes, so that a reprocessed pull request is not
    # touched again. An unnecessary write would bump its updatedAt and keep it permanently
    # inside the scheduled lookback window.
    if ($newLabels.Count -eq 0 -and $newReviewers.Count -eq 0) {
        Write-Verbose "Pull request [$($pr.url)] is already routed. Skipping."
        return
    }

    $editArguments = @('pr', 'edit', $pr.url, '--repo', $Repo)
    foreach ($newLabel in $newLabels) {
        $editArguments += @('--add-label', $newLabel)
    }
    if ($newReviewers.Count -gt 0) {
        $editArguments += @('--add-reviewer', ($newReviewers -join ','))
    }
    if ($PSCmdlet.ShouldProcess("Labels [$($newLabels -join ', ')] and reviewers [$($newReviewers -join ', ')] on pull request [$($pr.url)]", 'Add')) {
        $null = gh @editArguments
        if ($LASTEXITCODE -ne 0) {
            throw "Unable to update reviewer routing for pull request [$($pr.url)]."
        }
    }
}
