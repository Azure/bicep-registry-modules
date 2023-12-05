<#
.SYNOPSIS
Check if a module in a given path is published in a given version

.DESCRIPTION
Check if a module in a given path is published in a given version. Tries to find the module & version for a maximum of 60 minutes.

.PARAMETER Version
Mandatory. The version of the module to check for. For example: '0.2.0'

.PARAMETER PublishedModuleName
Mandatory. The path of the module to check for. For example: 'avm/res/key-vault/vault'

.EXAMPLE
Confirm-ModuleIsPublished -Version '0.2.0' -PublishedModuleName 'avm/res/key-vault/vault' -Verbose

Check if module 'key-vault/vault' has been published with version '0.2.0
#>
function Confirm-ModuleIsPublished {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $PublishedModuleName
    )

    $baseUrl = 'https://mcr.microsoft.com/v2'
    $catalogUrl = "$baseUrl/_catalog"
    $moduleVersionsUrl = "$baseUrl/bicep/$PublishedModuleName/tags/list"

    $time_limit_seconds = 3600 # 1h
    $end_time = (Get-Date).AddSeconds($time_limit_seconds)
    $retry_seconds = 5

    #####################################
    ##   Confirm module is published   ##
    #####################################
    while ($true) {
        $catalogContentRaw = (Invoke-WebRequest -Uri $catalogUrl -UseBasicParsing).Content
        $bicepCatalogContent = ($catalogContentRaw | ConvertFrom-Json).repositories | Select-String 'bicep/'
        Write-Verbose ("Bicep modules found in MCR catalog:`n{0}" -f ($bicepCatalogContent | Out-String))

        if ($bicepCatalogContent -match "bicep/$PublishedModuleName") {
            Write-Verbose "Passed: Found module [$PublishedModuleName] in the MCR catalog" -Verbose
            break
        } else {
            Write-Warning "Warning: Module [$PublishedModuleName] is not in the MCR catalog. Retrying in [$retry_seconds] seconds"
            Start-Sleep -Seconds $retry_seconds
        }

        if ((Get-Date) -ge $end_time) {
            throw "Time limit reached. Failed to validate publish of module in path [$PublishedModuleName] within the specified time."
        }
    }

    #############################################
    ##   Confirm module version is published   ##
    #############################################
    while ($true) {
        $tagsContentRaw = (Invoke-WebRequest -Uri $moduleVersionsUrl -UseBasicParsing).Content
        $tagsContent = ($tagsContentRaw | ConvertFrom-Json).tags

        Write-Verbose ("Tags for module in path [$PublishedModuleName] found in MCR catalog:`n{0}" -f ($tagsContent | Out-String))

        if ($tagsContent -match $Version) {
            Write-Host "Passed: Found new tag [$Version] for published module"
            break
        } else {
            Write-Warning "Warning: Could not find new tag [$Version] for published module. Retrying in [$retry_seconds] seconds"
            Start-Sleep -Seconds $retry_seconds
        }

        if ((Get-Date) -ge $end_time) {
            Write-Host 'Time limit reached. Failed to validate publish within the specified time.'
            exit 1
        }
    }
}
