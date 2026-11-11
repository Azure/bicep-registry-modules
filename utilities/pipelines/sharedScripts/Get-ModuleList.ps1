<#
.SYNOPSIS
Retrieve a filtered list of AVM modules.

.DESCRIPTION
Scans a given root path for Bicep modules (folders containing a main.bicep file) and returns them filtered by the requested characteristics.
Filters can be combined: -Scope controls hierarchy (All/TopLevel/Child), -IsOrphaned filters by root ownership, -IsVersioned limits to versioned or not-versioned modules.

.PARAMETER RepoRoot
Optional. The repository root path used to resolve module metadata and version files. Defaults to the repository root relative to this script.

.PARAMETER Path
Optional. The absolute path to scan for modules (e.g. 'C:/repo/avm/res', 'C:/repo/avm/ptn', 'C:/repo/avm/res/storage/storage-account'). Defaults to RepoRoot.

.PARAMETER Scope
Optional. Controls the hierarchy filter:
- 'All'      : (Default) Return every folder that contains a main.bicep.
- 'TopLevel' : Return only the first-level modules (depth 4: avm/<type>/<provider>/<resource>).
- 'Child'    : Return only child modules nested under the given -Path (excludes the root module itself).

.PARAMETER IsOrphaned
Optional. If set, filter by ownership in the module family's root metadata.json:
- `-IsOrphaned $true`   : Only return modules whose root has an empty owners array.
- `-IsOrphaned $false`  : Only return modules whose root has at least one individual or team owner.
Children and grandchildren inherit root ownership. Missing or invalid root metadata is an error.
Requires Avm.Authoring for offline metadata validation; no public module index is queried.
This ownership filter does not determine publication or deprecation status in the public catalog.

.PARAMETER IsVersioned
Optional. If set, filter by versioning status:
- `-IsVersioned $true`   : Only return modules that contain a version.json file.
- `-IsVersioned $false`  : Only return modules that do NOT contain a version.json file.

.PARAMETER HasChildren
Optional. If set, filter by whether a module has nested child modules (subfolders containing a main.bicep file):
- `-HasChildren $true`  : Only return modules that contain at least one nested module.
- `-HasChildren $false` : Only return modules that do NOT contain any nested modules.

.EXAMPLE
Get-ModuleList

Get all modules under the repository root.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -Scope 'TopLevel'

Get only first-level, i.e. parent, modules (e.g. avm/res/storage/storage-account, not its children) in the specified path.

.EXAMPLE
Get-ModuleList -IsOrphaned:$true

Get all modules whose family root has no owners in metadata.json.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res/storage/storage-account' -Scope 'Child'

Get all child (nested) modules under the storage-account module.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -Scope 'Child' -IsVersioned $false

Get all child resource modules that do NOT have a version.json file.

.EXAMPLE
Get-ModuleList -Path 'C:/repo/avm/res' -Scope 'TopLevel' -IsOrphaned:$true -IsVersioned $true

Get all ownerless, versioned, top-level modules in the specified path.
#>
function Get-ModuleList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [string] $Path = $RepoRoot,

        [Parameter(Mandatory = $false)]
        [ValidateSet('All', 'TopLevel', 'Child')]
        [string] $Scope = 'All',

        [Parameter(Mandatory = $false)]
        [Nullable[bool]] $IsOrphaned,

        [Parameter(Mandatory = $false)]
        [Nullable[bool]] $IsVersioned,

        [Parameter(Mandatory = $false)]
        [Nullable[bool]] $HasChildren
    )

    Write-verbose ("Repository root: " + $RepoRoot) -Verbose

    # Discover all module folders (i.e., containing a main.bicep) and convert to module names (e.g., avm/res/storage/storage-account)
    $modules = Get-ChildItem -Path $Path -Filter 'main.bicep' -Recurse -File | ForEach-Object {
        (($_.Directory.FullName -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
    }

    $modules = $modules | Where-Object {
        (($Scope -eq 'TopLevel') ? (($_ -split '/').Count -eq 4) : (($Scope -eq 'Child') ? (($_ -split '/').Count -gt 4) : $true)) -and
        ($null -ne $IsVersioned ? ($IsVersioned -eq (Test-Path (Join-Path $RepoRoot $_ 'version.json'))) : $true) -and
        ($null -ne $HasChildren ? ($HasChildren -eq (Test-Path (Join-Path $RepoRoot $_ '*' 'main.bicep'))) : $true)
    }

    if ($null -ne $IsOrphaned) {
        Import-Module -Name 'Avm.Authoring' -ErrorAction Stop
        $orphanedRoots = @{}
        $modules = $modules | Where-Object {
            $rootModuleName = ($_ -split '/')[0..3] -join '/'
            if (-not $orphanedRoots.ContainsKey($rootModuleName)) {
                $moduleType = @{ res = 'resource'; ptn = 'pattern'; utl = 'utility' }[($rootModuleName -split '/')[1]]
                $metadataResult = Test-AvmModuleMetadata -Path (Join-Path $RepoRoot $rootModuleName) -Ecosystem bicep -ModuleType $moduleType -SkipModuleVersionCheck -ErrorAction Stop
                if ($metadataResult.Status -ne 'pass') {
                    $issueSummary = ($metadataResult.Issues | ForEach-Object { "[$($_.Code)] $($_.Message)" }) -join '; '
                    throw [System.IO.InvalidDataException]::new("Invalid metadata.json for module family [$rootModuleName]: $issueSummary")
                }
                $orphanedRoots[$rootModuleName] = $metadataResult.Metadata.owners.Count -eq 0
            }
            $IsOrphaned -eq $orphanedRoots[$rootModuleName]
        }
    }

    return $modules
}
