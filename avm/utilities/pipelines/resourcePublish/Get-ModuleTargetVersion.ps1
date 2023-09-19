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
}