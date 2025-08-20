<#
.SYNOPSIS
Get modified files, or changes between the current commit and latest main (upstream) or upstream/main^ if you are on the upstream main branch.

.PARAMETER PathOnly
Optional. If specified, returns only the paths of the modified files.

.PARAMETER PathFilter
Optional. If specified, filters the modified files by the provided path pattern.

.EXAMPLE
Get-GitDiff -PathOnly

    Directory: .utilities\pipelines\publish

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          08.12.2021    15:50           7133 Script.ps1

Get modified files between the current commit and latest main (upstream) or upstream/main^ if you are on the upstream main branch.

.EXAMPLE
Get-GitDiff

diff --git a/file.ps1 b/file.ps1
index 8c3f2241..509ecadc 100644
--- a/file.ps1
+++ b/file.ps1
@@ -10,6 +10,9 @@ If the version did not change, the function will return null.
(...)

Get changes between the current commit and latest main (upstream) or upstream/main^ if you are on the upstream main branch.

.EXAMPLE
Get-GitDiff -PathOnly -PathFilter 'C:\utilities\pipelines\publish\helper'

    Directory: C:\utilities\pipelines\publish\helper

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---          12/08/2025    09:50           3364 fileA.ps1
-a---          12/08/2025    09:51           7106 fileB.ps1

Get only the paths of modified files in path 'C:\utilities\pipelines\publish\helper'.
#>
function Get-GitDiff {

    [CmdletBinding()]
    param (
        [Parameter()]
        [switch] $PathOnly,

        [Parameter()]
        [string] $PathFilter
    )

    # TODO: Must be updated to align with latest changes in main

    git remote add 'upstream' 'https://github.com/Azure/bicep-registry-modules.git' 2>$null # Add remote source if not already added
    git fetch 'upstream' 'main' -q # Fetch the latest changes from upstream main
    $currentBranch = Get-GitBranchName
    $inUpstream = (git remote get-url origin) -match '\/Azure\/' # If in upstream the value would be [https://github.com/Azure/bicep-registry-modules.git]

    if ($inUpstream -and $currentBranch -eq 'main') {
        Write-Verbose 'Currently in upstream [main]. Fetching changes against [main^-1].'
    } else {
        Write-Verbose ('{0} Fetching changes against upstream [main]' -f ($inUpstream ? "Currently in upstream [$currentBranch]." : 'Currently in a fork.'))
    }

    $diffInput = @(
        '--diff-filter=AM',
        ($PathOnly ? '--name-only' : $null),
        (($inUpstream -and $currentBranch -eq 'main') ? 'upstream/main^' : 'upstream/main'),
        $PathFilter
    ) | Where-Object { $_ }
    $diff = git diff $diffInput

    if ($PathOnly) {
        return $diff | Get-Item -Force # TODO: Should only run for added files. Otherwise we may get issues like: https://github.com/Azure/bicep-registry-modules/actions/runs/17100576210/job/48495769509#step:4:272
    }

    return $diff
}
