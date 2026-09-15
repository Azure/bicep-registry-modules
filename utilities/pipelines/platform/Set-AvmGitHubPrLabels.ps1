<#
.SYNOPSIS
Checks new PRs and adds labels, depending if module owner can approve, or core team is needed

.DESCRIPTION
Uses changed module paths and indexed individual owners to select reviewers. Tooling, cross-module, orphaned, and self-owned changes require the core team.

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
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmCsvData.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AvmModuleOwnerLogin.ps1')

    $sanitizedPrUrl = $PrUrl.Replace('api.', '').Replace('repos/', '').Replace('pulls/', 'pull/')
    $pr = gh pr view $sanitizedPrUrl --json 'author,number,url,isDraft,reviewRequests' --repo $Repo | ConvertFrom-Json -Depth 100
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

    $moduleNames = @()
    $needsCoreTeam = @($pr.reviewRequests | Where-Object {
            $_.slug -eq 'azure-verified-modules-tooling-contributors' -or $_.name -eq 'azure-verified-modules-tooling-contributors'
        }).Count -gt 0
    foreach ($filePath in $changedFilePaths) {
        if ($filePath -like '*avm.core.team.tests.ps1' -or $filePath -like '*.e2eignore') {
            $needsCoreTeam = $true
        }
        if ($filePath -match '^(avm/(res|ptn|utl)/[^/]+/[^/]+)/') {
            $moduleNames += $matches[1]
        } else {
            $needsCoreTeam = $true
        }
    }
    $moduleNames = @($moduleNames | Sort-Object -Unique)
    $needsCoreTeam = $needsCoreTeam -or $moduleNames.Count -ne 1
    $moduleIndexes = @{}
    $reviewerLogins = @()
    $hasOrphanedModule = $false

    foreach ($moduleName in $moduleNames) {
        $moduleType = ($moduleName -split '/')[1]
        if (-not $moduleIndexes.ContainsKey($moduleType)) {
            $indexName = switch ($moduleType) {
                'res' { 'Bicep-Resource' }
                'ptn' { 'Bicep-Pattern' }
                'utl' { 'Bicep-Utility' }
            }
            $moduleIndexes[$moduleType] = @(Get-AvmCsvData -ModuleIndex $indexName)
        }
        $matchingModules = @($moduleIndexes[$moduleType] | Where-Object { $_.ModuleName -eq $moduleName })
        if ($matchingModules.Count -gt 1) {
            throw [System.IO.InvalidDataException]::new("Multiple index entries found for module [$moduleName].")
        }
        $module = $matchingModules.Count -eq 1 ? $matchingModules[0] : $null
        if ($null -eq $module) {
            Write-Warning "Module [$moduleName] is not in the index. Routing to the core team."
            $needsCoreTeam = $true
        } elseif ($module.ModuleStatus -eq 'Orphaned') {
            $hasOrphanedModule = $true
            $needsCoreTeam = $true
        } elseif (-not $needsCoreTeam) {
            $reviewerLogins = @(Get-AvmModuleOwnerLogin -ModuleName $moduleName -ModuleIndexData $moduleIndexes[$moduleType] | Where-Object { $_ -ne $pr.author.login })
            $needsCoreTeam = $reviewerLogins.Count -eq 0
        }
    }

    $label = $needsCoreTeam ? 'Needs: Core Team :genie:' : 'Needs: Module Owner :mega:'
    $editArguments = @('pr', 'edit', $pr.url, '--add-label', $label, '--repo', $Repo)
    if ($hasOrphanedModule) {
        $editArguments += @('--add-label', 'Status: Module Orphaned :yellow_circle:')
    }
    if (-not $needsCoreTeam) {
        $newReviewers = @($reviewerLogins | Where-Object { $pr.reviewRequests.login -notcontains $_ })
        if ($newReviewers.Count -gt 0) {
            $editArguments += @('--add-reviewer', ($newReviewers -join ','))
        }
    }
    $null = gh @editArguments
    if ($LASTEXITCODE -ne 0) {
        throw "Unable to update reviewer routing for pull request [$($pr.url)]."
    }
}
