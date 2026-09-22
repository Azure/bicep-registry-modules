<#
.SYNOPSIS
Resolves the owners declared in a module's metadata.json file, including inherited child-module ownership.

.DESCRIPTION
Returns the owner handles declared for a module. Child modules do not declare owners themselves, so the lookup walks up the folder tree until a metadata.json file with a non-empty owners array is found, stopping at the top-level module folder. Individual owners are returned as bare GitHub logins, teams as '<organization>/<team-slug>'. An empty result means the module is orphaned.

When SourceRepo and SourceRef are provided, metadata is read from that commit through the GitHub contents API so that modules added or updated by a pull request are resolved correctly. Metadata read this way is treated as untrusted data and is never executed; handles are validated before use. The checked-out copy is used as a fallback whenever the remote lookup returns nothing.

.PARAMETER ModulePath
Mandatory. The repository-relative module folder, for example 'avm/res/storage/storage-account' or 'avm/res/storage/storage-account/blob-service/container'.

.PARAMETER RepoRoot
Mandatory. Path to the root of the repository.

.PARAMETER SourceRepo
Optional. The repository to read metadata from, with the structure '<owner>/<repositoryName>'. Defaults to the checked-out copy only.

.PARAMETER SourceRef
Optional. The commit SHA to read metadata from. Required when SourceRepo is provided.

.EXAMPLE
Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account/blob-service' -RepoRoot 'C:\repos\bicep-registry-modules'

.EXAMPLE
Get-AvmModuleMetadataOwner -ModulePath 'avm/res/storage/storage-account' -RepoRoot $repoRoot -SourceRepo 'contributor/bicep-registry-modules' -SourceRef '0f1e2d3c4b5a69788796a5b4c3d2e1f00f1e2d3c'
#>
function Get-AvmModuleMetadataOwner {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath,

        [Parameter(Mandatory)]
        [string] $RepoRoot,

        [Parameter()]
        [string] $SourceRepo,

        [Parameter()]
        [string] $SourceRef
    )

    $segments = @($ModulePath.Trim('/') -split '/')
    if ($segments.Count -lt 4 -or $segments[0] -cne 'avm' -or $segments[1] -cnotin @('res', 'ptn', 'utl')) {
        throw [System.IO.InvalidDataException]::new("Invalid module path [$ModulePath].")
    }

    $useRemoteSource = -not [string]::IsNullOrWhiteSpace($SourceRepo) -and -not [string]::IsNullOrWhiteSpace($SourceRef)
    if ($useRemoteSource -and ($SourceRepo -cnotmatch '^[A-Za-z0-9-]+/[\w.-]+$' -or $SourceRef -cnotmatch '^[0-9a-f]{7,40}$')) {
        throw [System.IO.InvalidDataException]::new("Invalid metadata source [$SourceRepo@$SourceRef].")
    }

    $individualPattern = '^(?=.{1,39}$)[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$'
    $teamPattern = '^@[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*/[a-z0-9]+(?:-[a-z0-9]+)*$'

    # Child modules inherit ownership, so walk up to the top-level module folder until owners are declared.
    for ($depth = $segments.Count; $depth -ge 4; $depth--) {
        $metadataPath = $segments[0..($depth - 1)] -join '/'
        $metadataPath = "$metadataPath/metadata.json"
        $metadataContent = $null
        $metadataSource = $metadataPath

        if ($useRemoteSource) {
            $metadataContent = gh api "repos/$SourceRepo/contents/$metadataPath`?ref=$SourceRef" --jq '.content | @base64d' 2>$null
            if ($LASTEXITCODE -ne 0) {
                $metadataContent = $null
            } else {
                $metadataSource = "$SourceRepo@$SourceRef`:$metadataPath"
            }
            $global:LASTEXITCODE = 0
        }

        if ($null -eq $metadataContent) {
            $metadataFilePath = Join-Path $RepoRoot ($metadataPath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
            if (-not (Test-Path -Path $metadataFilePath -PathType 'Leaf')) {
                continue
            }
            $metadataContent = Get-Content -Path $metadataFilePath -Raw
            $metadataSource = $metadataFilePath
        }

        try {
            $metadata = ($metadataContent | Out-String) | ConvertFrom-Json
        } catch {
            throw [System.IO.InvalidDataException]::new("Unable to read module metadata [$metadataSource]. $($_.Exception.Message)")
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
                throw [System.IO.InvalidDataException]::new("Invalid owner handle [$owner] in [$metadataSource].")
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
