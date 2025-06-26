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

Returns the module versions for module `avm/res/vault/key-vault`. E.g., `@(0.1.0, 0.1.1, (...))`, `@()`

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
    for ($i = 0; $i -lt 5; $i++) {
        try {
            Write-Verbose "Getting available tags at '$tagListUrl' (attempt $($i + 1))..." -Verbose
            $tagListResponse = Invoke-RestMethod -Uri $tagListUrl
            $publishedTags = $tagListResponse.tags | Sort-Object { [Version]$_ } -Culture 'en-US'
            Write-Verbose "  Found tags: $($publishedTags -join ', ')" -Verbose
            return $publishedTags
        } catch {
            if ($i -eq 4) {
                if (Test-McrConnection) {
                    Write-Verbose "MCR connection test passed. New modules don't have a published version."
                    return @()
                }
                Write-Error 'Failed to get tags from MCR ($tagListUrl) after 5 attempts. Please check your network connection and try again.'
                Write-Error "Error message: $($_.Exception.Message)"
                throw $_.Exception
            }
            Start-Sleep -Seconds 5
        }
    }
}

<#
.SYNOPSIS
Test connectivity to the Microsoft Container Registry (MCR)

.DESCRIPTION
Tests the ability to connect to the Microsoft Container Registry (MCR) by sending a request to the root URL.

.PARAMETER None
No parameters are required for this function.

.OUTPUTS
Returns `$true` if the connection is successful, otherwise throws an error.

.EXAMPLE
Test-McrConnection

Tests the connection to MCR and returns `$true` if successful.
#>
function Test-McrConnection {
    [CmdletBinding()]
    param ()

    $testUrl = 'https://mcr.microsoft.com'
    Write-Verbose "Testing MCR connection at '$testUrl'..."
    try {
        Invoke-RestMethod -Uri $testUrl -TimeoutSec 5 | Out-Null
        Write-Verbose 'MCR connection test successful.' -Verbose
        return $true
    } catch {
        Write-Error 'Failed to connect to MCR. Please check your network connection and try again.'
        return $false
    }
}
