<#
.SYNOPSIS
Get all published versions of a module

.DESCRIPTION
Get a list of tags from a container registry repository. The tags are sorted in ascending order.

.PARAMETER TagListUrl
Mandatory. The tag list url of a container registry.

.EXAMPLE
Get-PublishedModuleVersionsList TagListUrl 'https://mcr.microsoft.com/v2/bicep/avm/res/vault/key-vault/tags/list'

Returns the module versions for module `avm/res/vault/key-vault`. E.g., `@(0.1.0, 0.1.1, (...))`

#>

function Get-PublishedModuleVersionsList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TagListUrl
    )

    Write-Verbose "Getting available tags at '$TagListUrl'..." -Verbose
    try {
        $tagListResponse = Invoke-RestMethod -Uri $TagListUrl
    } catch {
        Write-Error "Error occurred while accessing URL: $TagListUrl"
        Write-Error "Error message: $($_.Exception.Message)"
        throw $_.Exception
    }
    $publishedTags = $tagListResponse.tags | Sort-Object -Culture 'en-US'
    Write-Verbose "  Found tags: $($publishedTags -join ', ')" -Verbose
    return $publishedTags
}
