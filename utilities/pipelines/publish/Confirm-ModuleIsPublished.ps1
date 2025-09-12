<#
.SYNOPSIS
Check if a module in a given path is published in a given version

.DESCRIPTION
Check if a module in a given path is published in a given version. Tries to find the module & version for a maximum of 60 minutes.

.PARAMETER Version
Mandatory. The version of the module to check for. For example: '0.2.0'

.PARAMETER PublishedModuleName
Mandatory. The path of the module to check for. For example: 'avm/res/key-vault/vault'

.PARAMETER GitTagName
Mandatory. The tag name of the module's git tag to check for. For example: 'avm/res/event-hub/namespace/0.2.0'

.PARAMETER ValidationMethod
Optional. Define how a successful publish should be validated.
- Oras: A tool to restore repositories directly from a registry endpoint (default)
- Catalogue: A method to ping the MCR data, that is, the Tags-Lists

Note: The 'Catalogue' validation method may take longer to complete than the 'Oras' method.

.EXAMPLE
Confirm-ModuleIsPublished -Version '0.2.0' -PublishedModuleName 'avm/res/key-vault/vault' -Verbose

Check if module 'key-vault/vault' has been published with version '0.2.0 using Oras, the default validation method

.EXAMPLE
Confirm-ModuleIsPublished -Version '0.2.0' -PublishedModuleName 'avm/res/key-vault/vault' -ValidationMethod 'Catalogue' -Verbose

Check if module 'key-vault/vault' has been published with version '0.2.0 using the 'Catalogue' validation method
#>
function Confirm-ModuleIsPublished {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $PublishedModuleName,

        [Parameter(Mandatory)]
        [string] $GitTagName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Oras', 'Catalogue')]
        [string] $ValidationMethod = 'Oras'
    )

    #######################################
    ##   Confirm module tag is created   ##
    #######################################
    $existingTag = git ls-remote --tags origin $GitTagName
    if (-not $existingTag) {
        throw "Tag [$GitTagName] was not successfully created. Please review."
    } else {
        Write-Verbose "Passed: Found Git tag [$GitTagName]" -Verbose
    }

    switch ($ValidationMethod) {
        'Oras' {

            $time_limit_seconds = 1800 # 30 minutes
            $end_time = (Get-Date).AddSeconds($time_limit_seconds)
            $retry_seconds = 60
            $index = 0

            $registryReference = 'mcr.microsoft.com/bicep/{0}:{1}' -f $PublishedModuleName, $version
            while ($true) {
                $index++

                oras pull $registryReference --format 'json' 2>$null

                if (Test-Path (Join-Path -Path $PWD 'Compiled ARM template')) {
                    # Checking if the file "Compiled ARM template" returned by the oras cmdlet is valid
                    # Rename the file to "main.json", import it and check it has the property $schema
                    $null = Rename-Item 'Compiled ARM template' 'main.json'
                    $template = Get-Content 'main.json' | ConvertFrom-Json -AsHashtable
                    if ($template.Keys -notcontains '$schema') {
                        throw "Pulled invalid template for [$registryReference]"
                    }

                    Write-Verbose "Passed: Found module [$PublishedModuleName] in the MCR catalog" -Verbose
                    break
                } else {
                    Write-Warning "Warning: Module [$PublishedModuleName] is not in the MCR. Retrying in [$retry_seconds] seconds [$index/$($time_limit_seconds/$retry_seconds)]"
                    Start-Sleep -Seconds $retry_seconds
                }

                if ((Get-Date) -ge $end_time) {
                    throw "Time limit reached. Failed to validate publish of module in path [$PublishedModuleName] within the specified time."
                }
            }
            break
        }
        'Catalogue' {
            $baseUrl = 'https://mcr.microsoft.com/v2'
            $catalogUrl = "$baseUrl/_catalog"
            $moduleVersionsUrl = "$baseUrl/bicep/$PublishedModuleName/tags/list"

            $time_limit_seconds = 3600 # 1h
            $end_time = (Get-Date).AddSeconds($time_limit_seconds)
            $retry_seconds = 60
            $index = 0

            #####################################
            ##   Confirm module is published   ##
            #####################################
            Write-Verbose "Invoking WebRequest for [$catalogUrl] to fetch modules" -Verbose
            while ($true) {
                $index++

                try {
                    $catalogContentRaw = (Invoke-WebRequest -Uri $catalogUrl -UseBasicParsing).Content
                    $bicepCatalogContent = ($catalogContentRaw | ConvertFrom-Json).repositories | Select-String 'bicep/'
                } catch {
                    Write-Warning ('WebRequest failed: {0}' -f $_.Exception.Message)
                }

                Write-Verbose ("Bicep modules found in MCR catalog:`n{0}" -f ($bicepCatalogContent | Out-String))

                if ($bicepCatalogContent -match "bicep/$PublishedModuleName") {
                    Write-Verbose "Passed: Found module [$PublishedModuleName] in the MCR catalog" -Verbose
                    break
                } else {
                    Write-Warning "Warning: Module [$PublishedModuleName] is not in the MCR catalog. Retrying in [$retry_seconds] seconds [$index/$($time_limit_seconds/$retry_seconds)]"
                    Start-Sleep -Seconds $retry_seconds
                }

                if ((Get-Date) -ge $end_time) {
                    throw "Time limit reached. Failed to validate publish of module in path [$PublishedModuleName] within the specified time."
                }
            }

            #############################################
            ##   Confirm module version is published   ##
            #############################################
            Write-Verbose "Invoking WebRequest for [$moduleVersionsUrl] to fetch modules versions" -Verbose
            while ($true) {
                $index++

                try {
                    $tagsContentRaw = (Invoke-WebRequest -Uri $moduleVersionsUrl -UseBasicParsing).Content
                    $tagsContent = ($tagsContentRaw | ConvertFrom-Json).tags
                } catch {
                    Write-Warning ('WebRequest failed: {0}' -f $_.Exception.Message)
                }

                Write-Verbose ("Tags for module in path [$PublishedModuleName] found in MCR catalog:`n{0}" -f ($tagsContent | Out-String))

                if ($tagsContent -match $Version) {
                    Write-Verbose "Passed: Found new tag [$Version] for published module" -Verbose
                    break
                } else {
                    Write-Warning "Warning: Could not find new tag [$Version] for published module. Retrying in [$retry_seconds] seconds [$index/$($time_limit_seconds/$retry_seconds)]"
                    Start-Sleep -Seconds $retry_seconds
                }

                if ((Get-Date) -ge $end_time) {
                    throw "Time limit reached. Failed to validate published version of module in path [$PublishedModuleName] within the specified time."
                }
            }
        }
    }
}
