<#
.SYNOPSIS
Retrieve a filtered list of AVM module folders.

.DESCRIPTION
Scans a given root path for Bicep modules (folders containing a main.bicep file) and returns them filtered by the requested characteristics.
Filters can be combined: -Scope controls hierarchy (All/TopLevel/Child), -Orphaned limits to orphaned modules, -Versioned limits to versioned or not-versioned modules.

.PARAMETER Path
Mandatory. The root path to scan for modules, relative to the repository root (e.g. 'avm/res', 'avm/ptn', 'avm/res/storage/storage-account').

.PARAMETER Scope
Optional. Controls the hierarchy filter:
- 'All'      : (Default) Return every folder that contains a main.bicep.
- 'TopLevel' : Return only the first-level modules (depth 4: avm/<type>/<provider>/<resource>).
- 'Child'    : Return only child modules nested under the given -Path (excludes the root module itself).

.PARAMETER Orphaned
Optional. If set, filter by orphaned status:
- -Orphaned         : Only return modules that contain an ORPHANED.md file.
- -Orphaned:$false  : Only return modules that do NOT contain an ORPHANED.md file.

.PARAMETER Versioned
Optional. If set, filter by versioning status:
- -Versioned         : Only return modules that contain a version.json file.
- -Versioned:$false  : Only return modules that do NOT contain a version.json file.

.PARAMETER RepoRoot
Optional. The repository root path. Defaults to the repo root relative to this script.

.EXAMPLE
Get-ModuleList -Path 'avm/res'

Get all modules under avm/res.

.EXAMPLE
Get-ModuleList -Path 'avm/res' -Scope 'TopLevel'

Get only first-level, i.e. parent, modules (e.g. avm/res/storage/storage-account, not its children).

.EXAMPLE
Get-ModuleList -Path 'avm/res' -Orphaned

Get all orphaned modules (those with an ORPHANED.md file).

.EXAMPLE
Get-ModuleList -Path 'avm/res/storage/storage-account' -Scope 'Child'

Get all child (nested) modules under the storage-account module.

.EXAMPLE
Get-ModuleList -Path 'avm/res' -Scope 'Child' -Versioned

Get all versioned child modules (those with a version.json file).

.EXAMPLE
Get-ModuleList -Path 'avm/res' -Versioned:$false

Get all modules that do NOT have a version.json file.

.EXAMPLE
Get-ModuleList -Path 'avm/res' -Scope 'TopLevel' -Orphaned -Versioned

Get all orphaned, versioned, top-level modules.
#>
function Get-ModuleList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false)]
        [ValidateSet('All', 'TopLevel', 'Child')]
        [string] $Scope = 'All',

        [Parameter(Mandatory = $false)]
        [switch] $Orphaned,

        [Parameter(Mandatory = $false)]
        [switch] $Versioned,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    $absolutePath = Resolve-Path -Path (Join-Path $RepoRoot $Path) -ErrorAction Stop
    $repoRootNormalized = $RepoRoot -replace '[\\/]$', ''

    # Discover all module folders (i.e., containing a main.bicep) and convert to module names (e.g., avm/res/storage/storage-account)
    $modules = Get-ChildItem -Path $absolutePath -Filter 'main.bicep' -Recurse -File | ForEach-Object {
        $_.Directory.FullName -replace [regex]::Escape($repoRootNormalized), '' -replace '^[\\/]', '' -replace '\\', '/'
    }

    # Apply scope filter
    switch ($Scope) {
        'TopLevel' {
            $modules = $modules | Where-Object { ($_ -split '/').Count -eq 4 }
        }
        'Child' {
            $modules = $modules | Where-Object { ($_ -split '/').Count -gt 4 }
        }
    }

    # Apply orphaned filter
    if ($PSBoundParameters.ContainsKey('Orphaned')) {
        if ($Orphaned) {
            $modules = $modules | Where-Object {
                Test-Path (Join-Path $RepoRoot $_ 'ORPHANED.md')
            }
        } else {
            $modules = $modules | Where-Object {
                -not (Test-Path (Join-Path $RepoRoot $_ 'ORPHANED.md'))
            }
        }
    }

    # Apply versioned filter
    if ($PSBoundParameters.ContainsKey('Versioned')) {
        if ($Versioned) {
            $modules = $modules | Where-Object {
                Test-Path (Join-Path $RepoRoot $_ 'version.json')
            }
        } else {
            $modules = $modules | Where-Object {
                -not (Test-Path (Join-Path $RepoRoot $_ 'version.json'))
            }
        }
    }

    return $modules
}
