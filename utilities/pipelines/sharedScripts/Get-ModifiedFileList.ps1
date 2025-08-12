<#
.SYNOPSIS
Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.

.EXAMPLE
Get-ModifiedFileList

    Directory: .utilities\pipelines\publish

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          08.12.2021    15:50           7133 Script.ps1

Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.
#>
function Get-ModifiedFileList {

    git remote add 'upstream' 'https://github.com/Azure/bicep-registry-modules.git' 2>$null # Add remote source if not already added
    git fetch 'upstream' 'main' -q # Fetch the latest changes from upstream main
    $currentBranch = Get-GitBranchName
    $inUpstream = (git remote get-url origin) -match '\/Azure\/' # If in upstream the value would be [https://github.com/Azure/bicep-registry-modules.git]

    # Note: Fetches only the name of the modified files
    if ($inUpstream -and $currentBranch -eq 'main') {
        Write-Verbose 'Currently in upstream [main]. Fetching changes against [main^-1].' -Verbose
        $diff = git diff --name-only --diff-filter=AM 'upstream/main^'
    } else {
        Write-Verbose ('{0} Fetching changes against upstream [main]' -f ($inUpstream ? "Currently in upstream [$currentBranch]." : 'Currently in a fork.')) -Verbose
        $diff = git diff --name-only --diff-filter=AM 'upstream/main'
    }

    $modifiedFiles = $diff | Get-Item -Force

    return $modifiedFiles
}
