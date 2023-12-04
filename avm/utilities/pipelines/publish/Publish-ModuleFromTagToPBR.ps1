function Publish-ModuleFromTagToPBR {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string] $ModuleReleaseTagName,

    [Parameter(Mandatory = $true)]
    [secureString] $PublicRegistryServer
  )

  # Load used functions
  . (Join-Path (Split-Path $PSScriptRoot) 'sharedScripts' 'Get-BRMRepositoryName.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleReadmeLink.ps1')
  . (Join-Path (Split-Path $PSScriptRoot -Parent) 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')

  # TODO: Diff in between tag & tag^-1 to find modules to publish?

  # 1. Find tag as per function input
  $repositoryRoot = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.Parent
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
    FilePathList   = @($moduleJsonFilePath)
    AbsoluteTokens = @{
      '-..--..-' = $targetVersion
    }
  }
  $null = Convert-TokensInFileList @tokenConfiguration

  # Double-check that tokens are correctly replaced
  $templateContent = Get-Content -Path $moduleJsonFilePath
  $incorrectLines = @()
  for ($index = 0; $index -lt $templateContent.Count; $index++) {
    if ($templateContent[$index] -match '-..--..-') {
      $incorrectLines += ('You have the token [{0}] in line [{1}] of file [{2}]. Please seek advice from the AVM team.' -f $matches[0], ($index + 1), $moduleJsonFilePath)
    }
  }
  if ($incorrectLines) {
    throw ($incorrectLines | ConvertTo-Json)
  }

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
