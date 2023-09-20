function Publish-ModuleFromTagToPBR {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleReleaseTagName,

        [Parameter(Mandatory = $true)]
        [secureString] $PublicRegistryServer
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'helper' 'Test-ModuleQualifiesForPublish.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleTargetVersion.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-BRMRepositoryName.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Set-ModuleReleaseTag.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleReadmeLink.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Publish-ModuleToPrivateBicepRegistry.ps1')

    $moduleFolderPath = Split-Path $TemplateFilePath -Parent
    $moduleJsonFilePath = Join-Path $moduleFolderPath 'main.json'

    # 1. Test if module qualifies for publishing
    if (-not (Test-ModuleQualifiesForPublish -moduleFolderPath $moduleFolderPath)) {
        Write-Verbose "No changes detected. Skipping publishing" -Verbose
        return
    }

    # 2. Calculate the version that we would publish with
    $targetVersion = Get-ModuleTargetVersion -moduleFolderPath $moduleFolderPath

    # 3. Get Target Published Module Name
    $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $TemplateFilePath

    # 4.Create release tag
    Set-ModuleReleaseTag -moduleFolderPath $moduleFolderPath

    # 5. Get the documentation link
    $documentationUri = Get-ModuleReadmeLink -moduleFolderPath $moduleFolderPath

    # 6. Replace telemetry version value (in JSON)
    $tokenConfiguration = @{
        FilePathList = @($moduleJsonFilePath)
        Tokens       = @{
            'moduleVersion' = $targetVersion
        }
        TokenPrefix  = '[['
        TokenSuffix  = ']]'
    }
    $null = Convert-TokensInFileList @tokenConfiguration

    ###################
    ## 7.  Publish   ##
    ###################
    $plainPublicRegistryServer = ConvertFrom-SecureString $PublicRegistryServer -AsPlainText

    $publishInput = @(
        $moduleJsonFilePath
        '--target', ("br:{0}/public/bicep/{1}:{2}" -f $plainPublicRegistryServer, $publishedModuleName, $targetVersion)
        '--documentationUri', $documentationUri
        '--force'
    )
    # bicep publish @publishInput
}
