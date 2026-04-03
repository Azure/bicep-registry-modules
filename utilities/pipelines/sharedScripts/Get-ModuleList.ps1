<#
.SYNOPSIS
Retrieve a filtered list of AVM module folders.

.DESCRIPTION
Scans a given root path for Bicep modules (folders containing a main.bicep file) and returns them filtered by the requested characteristics.
Filters can be combined: -Scope controls hierarchy (All/TopLevel/Child), -IsOrphaned limits to orphaned modules, -IsVersioned limits to versioned or not-versioned modules.

.PARAMETER Path
Mandatory. The absolute path to scan for modules (e.g. 'C:/repo/avm/res', 'C:/repo/avm/ptn', 'C:/repo/avm/res/storage/storage-account').

.PARAMETER Scope
Optional. Controls the hierarchy filter:
- 'All'      : (Default) Return every folder that contains a main.bicep.
- 'TopLevel' : Return only the first-level modules (depth 4: avm/<type>/<provider>/<resource>).
- 'Child'    : Return only child modules nested under the given -Path (excludes the root module itself).

.PARAMETER IsOrphaned
Optional. If set, filter by orphaned status:
- -IsOrphaned         : Only return modules that contain an ORPHANED.md file.
- -IsOrphaned:$false  : Only return modules that do NOT contain an ORPHANED.md file.

.PARAMETER IsVersioned
Optional. If set, filter by versioning status:
- -IsVersioned         : Only return modules that contain a version.json file.
- -IsVersioned:$false  : Only return modules that do NOT contain a version.json file.

.PARAMETER RepoRoot
Optional. The repository root path. Defaults to the repo root relative to this script.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res'

Get all modules under avm/res.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -Scope 'TopLevel'

Get only first-level, i.e. parent, modules (e.g. avm/res/storage/storage-account, not its children).

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -IsOrphaned

Get all orphaned modules (those with an ORPHANED.md file).

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res/storage/storage-account' -Scope 'Child'

Get all child (nested) modules under the storage-account module.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -Scope 'Child' -IsVersioned

Get all versioned child modules (those with a version.json file).

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -IsVersioned:$false

Get all modules that do NOT have a version.json file.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -Scope 'TopLevel' -IsOrphaned -IsVersioned

Get all orphaned, versioned, top-level modules.
#>
function Get-ModuleList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $Path = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('All', 'TopLevel', 'Child')]
        [string] $Scope = 'All',

        [Parameter(Mandatory = $false)]
        [Nullable[bool]] $IsOrphaned,

        [Parameter(Mandatory = $false)]
        [Nullable[bool]] $IsVersioned
    )

    # Discover all module folders (i.e., containing a main.bicep) and convert to module names (e.g., avm/res/storage/storage-account)
    $modules = Get-ChildItem -Path $Path -Filter 'main.bicep' -Recurse -File | ForEach-Object {
        (($_.Directory.FullName -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
    }

    $modules = $modules | Where-Object {
        (($Scope -eq 'TopLevel') ? (($_ -split '/').Count -eq 4) : (($Scope -eq 'Child') ? (($_ -split '/').Count -gt 4) : $true)) -and
        ($IsOrphaned -ne $null ? ($IsOrphaned -eq (Test-Path (Join-Path $RepoRoot $_ 'ORPHANED.md'))) : $true) -and
        ($IsVersioned -ne $null ? ($IsVersioned -eq (Test-Path (Join-Path $RepoRoot $_ 'version.json'))) : $true)
    }
    return $modules
}
