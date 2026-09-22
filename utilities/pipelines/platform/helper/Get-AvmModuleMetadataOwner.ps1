<#
.SYNOPSIS
Resolves the owners declared in a module's metadata.json file, including inherited child-module ownership.

.DESCRIPTION
Returns the owner handles declared for a module. Child modules do not declare owners themselves, so the lookup walks up the folder tree until a metadata.json file with a non-empty owners array is found, stopping at the top-level module folder. Individual owners are returned as bare GitHub logins, teams as '<organization>/<team-slug>'. An empty result means the module is orphaned.

.PARAMETER ModulePath
Mandatory. The repository-relative module folder, for example 'avm/res/storage/storage-account' or 'avm/res/storage/storage-account/blob-service/container'.

.PARAMETER RepoRoot
Mandatory. Path to the root of the repository.

.EXAMPLE
Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account/blob-service' -RepoRoot 'C:\repos\bicep-registry-modules'
#>
function Get-AvmModuleMetadataOwner {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath,

        [Parameter(Mandatory)]
        [string] $RepoRoot
    )

    $segments = @($ModulePath.Trim('/') -split '/')
    if ($segments.Count -lt 4 -or $segments[0] -cne 'avm' -or $segments[1] -cnotin @('res', 'ptn', 'utl')) {
        throw [System.IO.InvalidDataException]::new("Invalid module path [$ModulePath].")
    }

    $individualPattern = '^(?=.{1,39}$)[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$'
    $teamPattern = '^@[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*/[a-z0-9]+(?:-[a-z0-9]+)*$'

    # Child modules inherit ownership, so walk up to the top-level module folder until owners are declared.
    for ($depth = $segments.Count; $depth -ge 4; $depth--) {
        $metadataFilePath = Join-Path $RepoRoot ($segments[0..($depth - 1)] -join [System.IO.Path]::DirectorySeparatorChar) 'metadata.json'
        if (-not (Test-Path -Path $metadataFilePath -PathType 'Leaf')) {
            continue
        }

        try {
            $metadata = Get-Content -Path $metadataFilePath -Raw | ConvertFrom-Json
        } catch {
            throw [System.IO.InvalidDataException]::new("Unable to read module metadata [$metadataFilePath]. $($_.Exception.Message)")
        }

        $owners = @()
        foreach ($owner in @($metadata.owners)) {
            if ([string]::IsNullOrWhiteSpace($owner)) {
                continue
            }

            $handle = ([string] $owner).Trim()
            if ($handle -cmatch $teamPattern) {
                $handle = $handle.Substring(1)
            } elseif ($handle -cnotmatch $individualPattern) {
                throw [System.IO.InvalidDataException]::new("Invalid owner handle [$owner] in [$metadataFilePath].")
            }

            if ($owners -notcontains $handle) {
                $owners += $handle
            }
        }

        if ($owners.Count -gt 0) {
            return $owners
        }
    }

    return @()
}
