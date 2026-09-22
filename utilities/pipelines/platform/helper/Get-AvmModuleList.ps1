<#
.SYNOPSIS
Lists the top-level AVM modules present in the repository.

.DESCRIPTION
Returns the repository-relative paths of all top-level module folders ('avm/<type>/<group>/<name>') that contain a metadata.json file, sorted alphabetically. Child modules are excluded.

.PARAMETER RepoRoot
Mandatory. Path to the root of the repository.

.PARAMETER ModuleType
Optional. Restricts the result to a single module type. One of 'res', 'ptn' or 'utl'.

.EXAMPLE
Get-AvmModuleList -RepoRoot 'C:\repos\bicep-registry-modules' -ModuleType 'res'
#>
function Get-AvmModuleList {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string] $RepoRoot,

        [Parameter()]
        [ValidateSet('res', 'ptn', 'utl')]
        [string] $ModuleType
    )

    $moduleTreePath = Join-Path $RepoRoot 'avm'
    if (-not (Test-Path -Path $moduleTreePath -PathType 'Container')) {
        throw [System.IO.InvalidDataException]::new("Unable to find the module tree [$moduleTreePath].")
    }

    $searchRoot = $ModuleType ? (Join-Path $moduleTreePath $ModuleType) : $moduleTreePath
    if (-not (Test-Path -Path $searchRoot -PathType 'Container')) {
        return @()
    }

    $rootPrefix = (Get-Item -Path $RepoRoot).FullName.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar

    $modulePaths = Get-ChildItem -Path $searchRoot -Recurse -Depth 3 -Filter 'metadata.json' -File | ForEach-Object {
        ($_.DirectoryName -replace [regex]::Escape($rootPrefix), '') -replace '\\', '/'
    }

    return @($modulePaths | Where-Object { ($_ -split '/').Count -eq 4 } | Sort-Object -Unique)
}
