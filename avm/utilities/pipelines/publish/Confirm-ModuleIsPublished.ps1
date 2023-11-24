<#
.SYNOPSIS
Check if a module in a given path is published in a given version

.DESCRIPTION
Check if a module in a given path is published in a given version. Tries to find the module for a maximum of 6 minutes.

.PARAMETER Version
Mandatory. The version of the module to check for. For example: '0.2.0'

.PARAMETER ModulePath
Mandatory. The path of the module to check for. For example: 'avm/res/key-vault/vault'

.EXAMPLE
Confirm-ModuleIsPublished -Version '0.2.0' -ModulePath 'avm/res/key-vault/vault' -Verbose

Check if module 'key-vault/vault' has been published with version '0.2.0
#>
function Confirm-ModuleIsPublished {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $ModulePath
    )

    $catalogUrl = 'https://mcr.microsoft.com/v2/_catalog'
    $time_limit_seconds = 3600
    $end_time = (Get-Date).AddSeconds($time_limit_seconds)
    $retry_seconds = 5


    while ($true) {
        $catalogContentRaw = (Invoke-WebRequest -Uri $catalogUrl -UseBasicParsing).Content
        $bicepCatalogContent = ($catalogContentRaw | ConvertFrom-Json).repositories | Select-String 'bicep/'
        Write-Verbose ("Bicep modules found in MCR catalog:`n{0}" -f ($bicepCatalogContent | Out-String))

        if ($bicepCatalogContent -match "bicep/$ModulePath") {
            Write-Verbose "Passed: Found module [$ModulePath] in the MCR catalog" -Verbose
            break
        } else {
            Write-Error "Error: Module [$ModulePath] is not in the MCR catalog. Retrying in [$retry_seconds] seconds"
            Start-Sleep -Seconds $retry_seconds
        }

        if ((Get-Date) -ge $end_time) {
            throw "Time limit reached. Failed to validate publish of module in path [$ModulePath] within the specified time."
        }
    }

    while ($true) {
        $existingTagsUrl = "https://mcr.microsoft.com/v2/bicep/$ModulePath/tags/list"
        $tagsContentRaw = (Invoke-WebRequest -Uri $existingTagsUrl -UseBasicParsing).Content
        $tagsContent = ($tagsContentRaw | ConvertFrom-Json).tags

        Write-Verbose ("Tags for module in path [$ModulePath] found in MCR catalog:`n{0}" -f ($tagsContent | Out-String))

        if ($tagsContent -match $Version) {
            Write-Host "Passed: Found new tag [$Version] for published module"
            break
        } else {
            Write-Host "Error: Could not find new tag [$Version] for published module. Retrying in [$retry_seconds] seconds"
            Start-Sleep -Seconds $retry_seconds
        }

        if ((Get-Date) -ge $end_time) {
            Write-Host 'Time limit reached. Failed to validate publish within the specified time.'
            exit 1
        }
    }
}
