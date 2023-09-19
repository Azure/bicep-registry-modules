<#
.SYNOPSIS
Calculates the module target SemVer version

.DESCRIPTION
Gets major and minor from version.json
Gets patch calling Get-ModuleTargetPatchVersion
Builds version as major.minor.patch

If new major/minor patch is 0

.PARAMETER ModuleRelativePath
Mandatory. The relative path of the module e.g. `avm/res/network/private-endpoint`

.EXAMPLE


#>

function Get-ModuleTargetVersion {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $ModuleRelativePath
    )

    # 1. Check if [version.json] file version property was updated (compare with previous head)
    # IF so, we reset the patch/bug version back to 0
    # ELSE we call Get-ModuleTargetPatchVersion to get the next patch/bug version

    # 2. Concat the version elements

    # 3. Return the version
}