function Publish-ToPublicBicepRegistry {


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [secureString] $PublicRegistryServer
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'Get-ModulesToPublish.ps1')
    . (Join-Path $PSScriptRoot 'Get-ModulesMissingFromPrivateBicepRegistry.ps1')
    . (Join-Path $PSScriptRoot 'Publish-ModuleToPrivateBicepRegistry.ps1')

    $modulesToPublish = @()

    ################################
    ##   Get modules to publish   ##
    ################################

    $functionInput = @{
        TemplateFilePath = $TemplateFilePath
    }

    Write-Verbose "Invoke task with" -Verbose
    Write-Verbose ($functionInput | ConvertTo-Json | Out-String) -Verbose

    # Get the modified child resources
    $modulesToPublish += Get-ModulesToPublish @functionInput -Verbose

    #############################
    ##   Get missing modules   ##
    #############################
    # Add all modules that don't exist in the target location
    $missingInputObject = @{
        TemplateFilePath    = $TemplateFilePath
        BicepRegistryName   = 'avmtemptesting-acr'
        BicepRegistryRgName = 'avmtemptesting-rg'
    }

    Write-Verbose "Invoke Get-ModulesMissingFromPrivateBicepRegistry with" -Verbose
    Write-Verbose ($missingInputObject | ConvertTo-Json | Out-String) -Verbose

    $missingModules = Get-ModulesMissingFromPrivateBicepRegistry @missingInputObject

    foreach ($missingModule in $missingModules) {
        if ($modulesToPublish.TemplateFilePath -notcontains $missingModule.TemplateFilePath) {
            $modulesToPublish += $missingModule
        }
    }

    #################
    ##   Publish   ##
    #################
    foreach ($moduleToPublish in $modulesToPublish) {
        $RelPath = (($moduleToPublish.TemplateFilePath).Split('/modules/')[-1]).Split('/main.')[0]
        Write-Output "::group::$(' - [{0}] [{1}]' -f $RelPath, $moduleToPublish.Version)"

        $functionInput = @{
            TemplateFilePath        = $moduleToPublish.TemplateFilePath
            BicepRegistryName       = 'avmtemptestingacr'
            BicepRegistryRgName     = 'avmtemptesting-rg'
            BicepRegistryRgLocation = 'WestEurope'
            ModuleVersion           = $moduleToPublish.Version
        }

        Write-Verbose "Invoke task with" -Verbose
        Write-Verbose ($functionInput | ConvertTo-Json | Out-String) -Verbose

        Publish-ModuleToPrivateBicepRegistry @functionInput -Verbose


        $targetVersion = '' # "${{ steps.parse-tag.outputs.version }}"
        $moduleFilePath = '' # ${{ steps.parse-tag.outputs.module_path }}
        $jsonTemplateFilePath = Join-Path (Split-Path $moduleToPublish.TemplateFilePath -Parent) 'main.json'
        $plainPublicRegistryServer = ConvertFrom-SecureString $PublicRegistryServer -AsPlainText
        $publishingTargetPath = "br:{0}/public/bicep/{1}:{2}" -f $plainPublicRegistryServer, $moduleFilePath, $targetVersion
        $documentationUri = '' # "${{ steps.parse-tag.outputs.documentation_uri }}"

        # THIS would publish to the public registry
        # bicep publish $jsonTemplateFilePath --target $publishingTargetPath --documentationUri $documentationUri --force
    }

}