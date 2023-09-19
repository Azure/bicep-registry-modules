function Publish-ToPublicBicepRegistry {


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [secureString] $PublicRegistryServer
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'Get-ModuleTargetVersion.ps1')
    . (Join-Path $PSScriptRoot 'Get-BRMRepositoryName.ps1')
    . (Join-Path $PSScriptRoot 'Get-ModuleReadmeLink.ps1')
    . (Join-Path $PSScriptRoot 'Publish-ModuleToPrivateBicepRegistry.ps1')

    $moduleRelativePath = Split-Path $TemplateFilePath -Parent

    # 1. Get-ModuleTargetVersion
    $targetVersion = Get-ModuleTargetVersion -ModuleRelativePath $moduleRelativePath

    # 2. Get Target Published Module Name
    $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $TemplateFilePath

    # 3. Get-ModuleReadmeLink
    $documentationUri = Get-ModuleReadmeLink -ModuleRelativePath $moduleRelativePath

    # -2. Replace telemetry version value (in JSON)
    $tokenConfiguration = @{

    }
    $null = Convert-TokensInFileList @tokenConfiguration

    # -1. Publish
    $jsonTemplateFilePath = Join-Path $moduleRelativePath 'main.json'
    $plainPublicRegistryServer = ConvertFrom-SecureString $PublicRegistryServer -AsPlainText
    $publishingTargetPath = "br:{0}/public/bicep/{1}:{2}" -f $plainPublicRegistryServer, $publishedModuleName, $targetVersion

    # THIS would publish to the public registry
    $publishInput = @(
        $jsonTemplateFilePath
        '--target', $publishingTargetPath
        '--documentationUri', $documentationUri
        '--force'
    )
    # bicep publish @publishInput








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



    #################
    ##   Publish   ##
    #################
    foreach ($moduleToPublish in $modulesToPublish) {
        $RelPath = (($moduleToPublish.TemplateFilePath).Split('/modules/')[-1]).Split('/main.')[0]
        Write-Verbose (' - [{0}] [{1}]' -f $RelPath, $moduleToPublish.Version) -Verbose

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



    }

}