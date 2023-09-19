<#
.SYNOPSIS
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a repository in the given Container Registry

.DESCRIPTION
Get a list of all modules (path & version) in the given TemplatePath that do not exist as a repository in the given Container Registry

.PARAMETER TemplateFilePath
Mandatory. The Template File Path to process

.PARAMETER BicepRegistryName
Mandatory. The name of the Container Registry to search in

.PARAMETER BicepRegistryRgName
Mandatory. The name of Resource Group the Container Registry is located it.

.PARAMETER PublishLatest
Optional. Publish an absolute latest version.
Note: This version may include breaking changes and is not recommended for production environments

.EXAMPLE
Get-ModulesMissingFromPrivateBicepRegistry -TemplateFilePath 'avm\compute\virtual-machine\main.bicep' -BicepRegistryName 'adpsxxazacrx001' -BicepRegistryRgName 'artifacts-rg'

Check if either the Virtual Machine module or any of its children (e.g. 'extension') is missing in the Container Registry 'adpsxxazacrx001' of Resource Group 'artifacts-rg'

Returns for example:
Name                           Value
----                           -----
Version                        0.4.0
TemplateFilePath               avm\compute\virtual-machine\extension\main.bicep
#>
function Get-ModulesMissingFromPrivateBicepRegistry {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $BicepRegistryName,

        [Parameter(Mandatory = $true)]
        [string] $BicepRegistryRgName
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load used functions
        . (Join-Path $PSScriptRoot 'Get-PrivateRegistryRepositoryName.ps1')
    }

    process {
        # Get all children, bicep templates only
        $availableModuleTemplatePaths = (Get-ChildItem -Path (Split-Path $TemplateFilePath) -Recurse -Include @('main.bicep')).FullName
        $availableModuleTemplatePaths = $availableModuleTemplatePaths | Sort-Object

        if (-not (Get-AzContainerRegistry -Name $BicepRegistryName -ResourceGroupName $BicepRegistryRgName -ErrorAction 'SilentlyContinue')) {
            $missingTemplatePaths = $availableModuleTemplatePaths
        }
        else {
            # Test all children against ACR
            $missingTemplatePaths = @()
            foreach ($templatePath in $availableModuleTemplatePaths) {

                # Get a valid Container Registry name
                $moduleRegistryIdentifier = Get-PrivateRegistryRepositoryName -TemplateFilePath $templatePath

                $null = Get-AzContainerRegistryTag -RepositoryName $moduleRegistryIdentifier -RegistryName $BicepRegistryName -ErrorAction 'SilentlyContinue' -ErrorVariable 'result'

                if ($result.Exception.Response.StatusCode -eq 'NotFound' -or $result.Exception.Status -eq '404') {
                    $missingTemplatePaths += $templatePath
                }
            }
        }

        # Collect any that are not part of the ACR, fetch their version and return the result array
        $modulesToPublish = @()
        foreach ($missingTemplatePath in $missingTemplatePaths) {
            $moduleVersionsToPublish = @(
                # Patch version
                @{
                    TemplateFilePath = $missingTemplatePath
                    Version          = '{0}.0' -f (Get-Content (Join-Path (Split-Path $missingTemplatePath) 'version.json') -Raw | ConvertFrom-Json).version
                }
            )

            $modulesToPublish += $moduleVersionsToPublish
            Write-Verbose ('Missing module [{0}] will be considered for publishing with version(s) [{1}]' -f $missingTemplatePath, ($moduleVersionsToPublish.Version -join ', ')) -Verbose
        }

        if ($modulesToPublish.count -eq 0) {
            Write-Verbose 'No modules missing in the target environment' -Verbose
        }

        return $modulesToPublish
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
