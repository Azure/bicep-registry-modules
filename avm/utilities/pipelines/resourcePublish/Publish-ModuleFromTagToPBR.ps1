function Publish-ModuleFromTagToPBR {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string] $ModuleReleaseTagName,

    [Parameter(Mandatory = $true)]
    [secureString] $PublicRegistryServer
  )

  # Load used functions
  . (Join-Path $PSScriptRoot 'helper' 'Get-BRMRepositoryName.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleReadmeLink.ps1')
  . (Join-Path $PSScriptRoot '..' 'tokensReplacement' 'Convert-TokensInFileList.ps1')

  # TODO: Diff in between tag & tag^-1 to find modules to publish?

  # ModuleReleaseTagName = 'avm/res/key-vault/vault/0.6.10'
  # 1. Find tag as per function input
  $repositoryRoot = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent
  $targetVersion = Split-Path $ModuleReleaseTagName -Leaf
  $moduleRelativeFolderPath = $ModuleReleaseTagName -replace "\/$targetVersion$", ''
  $moduleFolderPath = Join-Path $repositoryRoot $moduleRelativeFolderPath
  $moduleJsonFilePath = Join-Path $moduleFolderPath 'main.json'


  # 2. Get Target Published Module Name
  $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $moduleJsonFilePath

  # 3. Get the documentation link
  $documentationUri = Get-ModuleReadmeLink -TagName $ModuleReleaseTagName -ModuleRelativeFolderPath $moduleRelativeFolderPath

  # 4. Replace telemetry version value (in JSON)
  $tokenConfiguration = @{
    FilePathList = @($moduleJsonFilePath)
    Tokens       = @{
      'moduleVersion' = $targetVersion
    }
    TokenPrefix  = '#_'
    TokenSuffix  = '_#'
  }
  $null = Convert-TokensInFileList @tokenConfiguration

  ###################
  ## 5.  Publish   ##
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