#region helper functions
<#
.SYNOPSIS
Get the name of the current checked out branch.

.DESCRIPTION
Get the name of the current checked out branch. If git cannot find it, best effort based on environment variables is used.

.EXAMPLE
Get-CurrentBranch

Get the name of the current checked out branch.
#>
function Get-GitBranchName {
    [CmdletBinding()]
    param ()

    # Get branch name from Git
    $BranchName = git branch --show-current

    # If git could not get name, try GitHub variable
    if ([string]::IsNullOrEmpty($BranchName) -and (Test-Path env:GITHUB_REF_NAME)) {
        $BranchName = $env:GITHUB_REF_NAME
    }

    return $BranchName
}

#endregion

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

    $currentBranch = Get-GitBranchName
    $inUpstream = (git remote get-url origin) -match '\/Azure\/' # If in upstream the value would be [https://github.com/Azure/bicep-registry-modules.git]
    $currentCommit = (git log -1 --format=%H).Substring(0, 7) # Get the current commit

    if ($inUpstream -and $currentBranch -eq 'main') {
        Write-Verbose 'Currently in the upstream branch [main].' -Verbose
        # Get the current and previous commit
        $compareWithCommit = (git log -2 --format=%H)[1].Substring(0, 7) # Takes the second item of revision range -2
        Write-Verbose ('Fetching changes of current commit [{0}] against the previous commit [{1}].' -f $currentCommit, $compareWithCommit) -Verbose
    } else {
        Write-Verbose ("{0} branch [$currentBranch]" -f ($inUpstream ? 'Currently in the upstream' : 'Currently in the fork')) -Verbose

        Write-Debug 'Adding upstream repository reference'
        git remote add 'upstream' 'https://github.com/Azure/bicep-registry-modules.git' 2>$null # Add remote source if not already added
        Write-Debug 'Fetching latest changes from [upstream]'
        git fetch 'upstream' 'main' -q # Fetch the latest changes from upstream main
        Start-Sleep 5 # Wait for git to finish adding the remote

        $compareWithCommit = git rev-parse --short=7 'upstream/main' # Get main's latest commit in upstream

        Write-Verbose ('Fetching changes of current commit [{0}] against upstream [main] [{1}]' -f $currentCommit, $compareWithCommit) -Verbose
    }

    $diffInput = @(
        '--diff-filter=AM',
        ($PathOnly ? '--name-only' : $null),
        $currentCommit,
        $compareWithCommit,
        $PathFilter
    ) | Where-Object { $_ }
    $modifiedFiles = git diff $diffInput

    if ($PathOnly) {
        # Returns only the paths of the changed files, not the changes themselves
        return $modifiedFiles | Get-Item -Force -ErrorAction 'SilentlyContinue' # Silently continue to ignore files that were removed
    }

    return $modifiedFiles
}
