<#
.SYNOPSIS
Calculates the module target patch version.

.DESCRIPTION
Calculates the module target patch version.
Gets all published release tags for a given module and major.minor.
Resets patch version if no tag exists with same major.minor.
Bumps patch version otherwise.

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER MajMinVersion
Mandatory. Module "MAJOR.MINOR" version.

.EXAMPLE
# Note: The latest published release tag is "avm/res/key-vault/vault/0.1.6"
Get-ModuleTargetPatchVersion -ModuleFolderPath 'C:\avm\res\key-vault\vault' -MajMinVersion '0.1'

Returns 7

.EXAMPLE
# Note: No published release tag for "C:\avm\res\key-vault\vault" module with "major.minon" version "0.2"
Get-ModuleTargetPatchVersion -ModuleFolderPath 'C:\avm\res\key-vault\vault' -MajMinVersion '0.2'

Returns 0
#>

function Get-ModuleTargetPatchVersion {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $true)]
        [string] $MajMinVersion
    )

    $ModuleRelativeFolderPath = (($ModuleFolderPath -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'

    # Get all released module tags (using upstream specifically to work in forks)
    $existingTagList = git ls-remote --tag origin "$ModuleRelativeFolderPath/$MajMinVersion*"
    if ( $existingTagList.count -eq 0 ) {
        # If first module tag, reset patch
        Write-Verbose "No existing tag for module [$ModuleRelativeFolderPath] starting with version [$MajMinVersion]" -Verbose
        Write-Verbose 'Setting patch version to 0' -Verbose
        $patch = 0
    } else {
        # Otherwise get latest patch
        $patchList = $existingTagList | ForEach-Object { [int](($_ -split '\.')[-1]) }
        $latestPatch = ($patchList | Measure-Object -Maximum).Maximum
        $latestTag = "$ModuleRelativeFolderPath/$MajMinVersion.$latestPatch"
        Write-Verbose "Latest tag is [$latestTag]." -Verbose
        Write-Verbose 'Checking if latest tag commit is already corresponding to the current commit.' -Verbose

        $currentCommit = git rev-parse HEAD
        $latestTagCommit = git rev-list -n 1 $latestTag

        if ($currentCommit -eq $latestTagCommit) {
            # Return latest patch (we're likely in a rerun)
            Write-Warning 'The latest tag commit corresponds to the current commit. Publishing will be skipped.' -Verbose
            $patch = $latestPatch
        } else {
            # Increase patch count
            Write-Verbose 'The latest tag commit does not correspond to the current commit. Bumping patch.' -Verbose
            $patch = $latestPatch + 1
        }
    }

    # Return PATCH
    return $patch
}
