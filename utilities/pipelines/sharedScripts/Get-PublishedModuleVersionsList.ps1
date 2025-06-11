<#
.SYNOPSIS
Get all published versions of a module

.DESCRIPTION
Get a list of tags from a container registry repository. The tags are sorted in ascending order.

.PARAMETER ModuleType
Mandatory. The module type of the module. (`ptn`|`res`|`utl`)

.PARAMETER ModuleName
Mandatory. The module name of the module. (e.g., `vault/key-vault`, `network/virtual-network`, `network/virtual-network/subnet`)

.EXAMPLE
Get-PublishedModuleVersionsList -ModuleType 'res' -ModuleName 'vault/key-vault'

Returns the module versions for module `avm/res/vault/key-vault`. E.g., `@(0.1.0, 0.1.1, (...))`

#>

function Get-PublishedModuleVersionsList {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string] $ModuleType,

        [Parameter(Mandatory = $true)]
        [string] $ModuleName
    )

    $tagListUrl = 'https://mcr.microsoft.com/v2/bicep/avm/{0}/{1}/tags/list' -f $ModuleType, $ModuleName
    Write-Verbose "Getting available tags at '$tagListUrl'..." -Verbose
    try {
        $tagListResponse = Invoke-RestMethod -Uri $tagListUrl
    } catch {
        Write-Error "Error occurred while accessing URL: $tagListUrl"
        Write-Error "Error message: $($_.Exception.Message)"
        throw $_.Exception
    }
    $publishedTags = $tagListResponse.tags | Sort-Object { [Version]$_ } -Culture 'en-US'
    Write-Verbose "  Found tags: $($publishedTags -join ', ')" -Verbose
    return $publishedTags
}
