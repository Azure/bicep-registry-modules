<#
.SYNOPSIS
Publish module to Public Bicep Registry.

.DESCRIPTION
Publish module to Public Bicep Registry.
Checks if module qualifies for publishing.
Calculates the target module version based on version.json file and existing published release tags.
Creates and publishes release tag.
Retrieves module readme url.

.PARAMETER TemplateFilePath
Mandatory. The path to the deployment file

.PARAMETER PublicRegistryServer
Mandatory. The public registry server.

.EXAMPLE
Publish-ModuleFromPathToPBR -TemplateFilePath 'C:\avm\res\key-vault\vault\main.bicep -PublicRegistryServer '<secureString>'

#>
function Publish-ModuleFromPathToPBR {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)]
    [string] $TemplateFilePath,

    [Parameter(Mandatory = $true)]
    [secureString] $PublicRegistryServer
  )

  # Load used functions
  . (Join-Path $PSScriptRoot 'helper' 'Get-ModulesToPublish.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleTargetVersion.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-BRMRepositoryName.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'New-ModuleReleaseTag.ps1')
  . (Join-Path $PSScriptRoot 'helper' 'Get-ModuleReadmeLink.ps1')
  . (Join-Path (Split-Path $PSScriptRoot -Parent) 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')

  $moduleFolderPath = Split-Path $TemplateFilePath -Parent
  $moduleJsonFilePath = Join-Path $moduleFolderPath 'main.json'

  # 1. Test if module qualifies for publishing
  if (-not (Get-ModulesToPublish -ModuleFolderPath $moduleFolderPath)) {
    Write-Verbose "No changes detected. Skipping publishing" -Verbose
    return
  }

  # 2. Calculate the version that we would publish with
  $targetVersion = Get-ModuleTargetVersion -ModuleFolderPath $moduleFolderPath

  # 3. Get Target Published Module Name
  $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $TemplateFilePath

  # 4.Create release tag
  $tagName = New-ModuleReleaseTag -ModuleFolderPath $moduleFolderPath -TargetVersion $targetVersion

  # 5. Get the documentation link
  $documentationUri = Get-ModuleReadmeLink -TagName $tagName -ModuleFolderPath $moduleFolderPath

  # 6. Replace telemetry version value (in JSON)
  $tokenConfiguration = @{
    FilePathList = @($moduleJsonFilePath)
    Tokens       = @{
      'moduleVersion' = $targetVersion
    }
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
  # TODO move to its own task to show that as skipped if no file qualifies for new version
  bicep publish @publishInput
}
