<#
.SYNOPSIS
Get all published versions of a module

.DESCRIPTION
Get a list of tags from a container registry repository. The tags are sorted in ascending order.

.PARAMETER TagListUrl
Mandatory. The tag list url of a container registry.

.EXAMPLE
Get-ModulePublishedVersions TagListUrl 'https://mcr.microsoft.com/v2/bicep/avm/$moduleType/$moduleFolderName/tags/list'

Returns [0.1.0, 0.1.1, 0.1.2, 0.2.0, 0.2.1, 1.0.0, 1.1.0, 1.1.0]

#>

function Get-ModulePublishedVersions {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TagListUrl
    )

    # Load used functions
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleVersionChange.ps1')
    . (Join-Path (Get-Item -Path $PSScriptRoot).FullName 'Get-ModuleTargetPatchVersion.ps1')

    Write-Verbose "  Getting available tags at '$TagListUrl'..." -Verbose
    try {
        $tagListResponse = Invoke-RestMethod -Uri $TagListUrl
    } catch {
        Write-Error "Error occurred while accessing URL: $TagListUrl"
        Write-Error "Error message: $($_.Exception.Message)"
        throw $_.Exception
    }
    $publishedTags = $tagListResponse.tags | Sort-Object -Culture 'en-US'
    return $publishedTags
}
