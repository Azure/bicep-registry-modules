function Publish-ModuleFromPathToPBR {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string] $TemplateFilePath,

    [Parameter(Mandatory = $true)]
    [secureString] $PublicRegistryServer
  )

  # Load used functions
  . (Join-Path $PSScriptRoot 'helper' 'Test-ModuleQualifiesForPublish.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleTargetVersion.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-BRMRepositoryName.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'New-ModuleReleaseTag.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleReadmeLink.ps1')

  $moduleFolderPath = Split-Path $TemplateFilePath -Parent
  $moduleJsonFilePath = Join-Path $moduleFolderPath 'main.json'

<<<<<<< HEAD
    # 1. Test if module qualifies for publishing
    if (-not (Test-ModuleQualifiesForPublish -ModuleFolderPath $moduleFolderPath)) {
        Write-Verbose "No changes detected. Skipping publishing" -Verbose
        return
=======
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
  $tagName = New-ModuleReleaseTag -ModuleRelativeFolderPath $moduleRelativeFolderPath -TargetVersion $targetVersion

  # 5. Get the documentation link
  $documentationUri = Get-ModuleReadmeLink -TagName $tagName -ModuleRelativeFolderPath $moduleRelativeFolderPath

  # 6. Replace telemetry version value (in JSON)
  $tokenConfiguration = @{
    FilePathList = @($moduleJsonFilePath)
    Tokens       = @{
      'moduleVersion' = $targetVersion
>>>>>>> 5c6008414f381dd3a5a500006621d277859abb04
    }
    TokenPrefix  = '[['
    TokenSuffix  = ']]'
  }
  $null = Convert-TokensInFileList @tokenConfiguration

<<<<<<< HEAD
    # 2. Calculate the version that we would publish with
    $targetVersion = Get-ModuleTargetVersion -ModuleFolderPath $moduleFolderPath

    # 3. Get Target Published Module Name
    $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $TemplateFilePath

    # 4.Create release tag
    Set-ModuleReleaseTag -ModuleFolderPath $moduleFolderPath

    # 5. Get the documentation link
    $documentationUri = Get-ModuleReadmeLink -ModuleFolderPath $moduleFolderPath

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
=======
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
>>>>>>> 5c6008414f381dd3a5a500006621d277859abb04
}
