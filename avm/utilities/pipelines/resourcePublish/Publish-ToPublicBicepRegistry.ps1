function Publish-ToPublicBicepRegistry {


    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [secureString] $PublicRegistryServer
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'Test-ModuleQualifiesForPublish.ps1')
    . (Join-Path $PSScriptRoot 'Get-ModuleTargetVersion.ps1')
    . (Join-Path $PSScriptRoot 'Get-BRMRepositoryName.ps1')
    . (Join-Path $PSScriptRoot 'Get-ModuleReadmeLink.ps1')
    . (Join-Path $PSScriptRoot 'Publish-ModuleToPrivateBicepRegistry.ps1')

    $moduleRelativePath = Split-Path $TemplateFilePath -Parent

    # 0. Get Modules to Publish
    # -> Is there a diff to head
    # -> Is there a diff to PBR
    if (-not (Test-ModuleQualifiesForPublish -ModuleRelativePath $moduleRelativePath)) {
        Write-Verbose "No changes detected. Skipping publishing" -Verbose
        return
    }

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

    #################
    ##   Publish   ##
    #################
    $publishInput = @(
        $jsonTemplateFilePath
        '--target', $publishingTargetPath
        '--documentationUri', $documentationUri
        '--force'
    )
    # bicep publish @publishInput
}