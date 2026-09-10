<#
.SYNOPSIS
Resolves individual module owners from the Bicep module index, including inherited child-module ownership.

.PARAMETER ModuleName
Mandatory. The module name, for example 'avm/res/storage/storage-account'.

.PARAMETER ModuleIndexData
Mandatory. The module index entries containing individual owner handles and parent-module references.
#>
function Get-AvmModuleOwnerLogin {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleName,

        [Parameter(Mandatory)]
        [object[]] $ModuleIndexData
    )

    $currentModuleName = $ModuleName
    while ($true) {
        $matchingModules = @($ModuleIndexData | Where-Object { $_.ModuleName -eq $currentModuleName })
        if ($matchingModules.Count -ne 1) {
            throw [System.IO.InvalidDataException]::new("Expected one index entry for module [$currentModuleName] while resolving owners of [$ModuleName], found [$($matchingModules.Count)].")
        }

        $module = $matchingModules[0]
        if ($module.ModuleStatus -eq 'Orphaned') {
            return @()
        }

        $ownerLogins = @()
        foreach ($value in @($module.PrimaryModuleOwnerGHHandle, $module.SecondaryModuleOwnerGHHandle)) {
            if ([string]::IsNullOrWhiteSpace($value)) {
                continue
            }

            $login = $value.Trim() -replace '^@', ''
            if ($login -notmatch '^(?=.{1,39}$)[a-zA-Z0-9]+(?:-[a-zA-Z0-9]+)*$') {
                throw [System.IO.InvalidDataException]::new("Invalid owner handle [$value] for module [$currentModuleName].")
            }
            if ($ownerLogins -notcontains $login) {
                $ownerLogins += $login
            }
        }

        if ($ownerLogins.Count -gt 0) {
            return $ownerLogins
        }

        if (($currentModuleName -split '/').Count -le 4) {
            throw [System.IO.InvalidDataException]::new("No individual owners are defined for module [$currentModuleName].")
        }

        $parentModuleName = $module.ParentModule
        if ([string]::IsNullOrWhiteSpace($parentModuleName)) {
            $parentModuleName = $currentModuleName.Substring(0, $currentModuleName.LastIndexOf('/'))
        }
        if (-not $currentModuleName.StartsWith("$parentModuleName/", [System.StringComparison]::OrdinalIgnoreCase)) {
            throw [System.IO.InvalidDataException]::new("Invalid parent module [$parentModuleName] for module [$currentModuleName].")
        }
        $currentModuleName = $parentModuleName
    }
}
