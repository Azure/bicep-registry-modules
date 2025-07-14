<#
.SYNOPSIS
Get current and previous major and minor version, if different.

.DESCRIPTION
Get current and previous major and minor version, if different.
Retrieves target Major.Minor from module version.json and compares with values from the previous git head.
If the version did not change, the function will return null.

.PARAMETER VersionFilePath
Mandatory. Path to the module version.json file.

.EXAMPLE
# Note: "version" value is "0.1" and was not updated in the last commit
Get-ModuleVersionChange -VersionFilePath 'C:\avm\res\key-vault\vault\version.json'

Returns null

.EXAMPLE
# Note:"version" value is updated from "0.1" to "0.2" in the last commit
Get-ModuleVersionChange -VersionFilePath 'C:\avm\res\key-vault\vault\version.json'

Name                           Value
----                           -----
oldVersion                     0.1
newVersion                     0.2

#>
function Get-ModuleVersionChange {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $VersionFilePath
    )

    # The diff will be empty, if the version.json file was not updated
    $CurrentBranch = Get-GitBranchName
    if ($CurrentBranch -eq 'main') {
        Write-Verbose 'Gathering modified files of main vs upstream main-1' -Verbose
        $Diff = git diff --name-only --diff-filter=AM 'origin/main^' 'main' | Out-String
    } else {
        Write-Verbose 'Gathering modified files between current branch and upstream main' -Verbose
        $Diff = git diff --name-only --diff-filter=AM 'origin/main' | Out-String
    }

    if ($diff -match '\-\s*"version":\s*"([0-9]{1})\.([0-9]{1})".*') {
        $oldVersion = (New-Object System.Version($matches[1], $matches[2]))
    }

    if ($diff -match '\+\s*"version":\s*"([0-9]{1})\.([0-9]{1})".*') {
        $newVersion = (New-Object System.Version($matches[1], $matches[2]))
    }

    if ($newVersion -lt $oldVersion) {
        Write-Warning -Message '  The new version is smaller than the old version'
    } elseif ($newVersion -eq $oldVersion) {
        Write-Verbose '  The new version equals the old version' -Verbose
    } else {
        Write-Verbose '  The new version is greater than the old version' -Verbose
    }

    if (-not [String]::IsNullOrEmpty($newVersion) -and -not [String]::IsNullOrEmpty($oldVersion)) {
        return @{
            newVersion = $newVersion
            oldVersion = $oldVersion
        }
    }
}
