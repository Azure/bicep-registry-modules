<#
.SYNOPSIS
Publish a module based on the provided git tag

.DESCRIPTION
Publish a module based on the provided git tag

.PARAMETER ModuleReleaseTagName
Mandatory. The git tag to identify the module with & publish its code state of

.PARAMETER PublicRegistryServer
Mandatory. The public registry server.

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Publish-ModuleFromTagToPBR -ModuleReleaseTagName 'avm/res/key-vault/vault/0.3.0' -PublicRegistryServer (ConvertTo-SecureString 'myServer' -AsPlainText -Force)

Publish the module 'avm/res/key-vault/vault' of git tag 'avm/res/key-vault/vault/0.3.0' to the public registry server 'myServer'
#>
function Publish-ModuleFromTagToPBR {

  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $true)]
    [string] $ModuleReleaseTagName,

    [Parameter(Mandatory = $true)]
    [secureString] $PublicRegistryServer,

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
  )

  # Load used functions
  . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleReadmeLink.ps1')

  # 1. Extract information from the tag
  $targetVersion = Split-Path $ModuleReleaseTagName -Leaf
  $moduleRelativeFolderPath = $ModuleReleaseTagName -replace "\/$targetVersion$", ''
  $moduleFolderPath = Join-Path $repositoryRoot $moduleRelativeFolderPath
  $moduleJsonFilePath = Join-Path $moduleFolderPath 'main.json'
  Write-Verbose "Determined JSON template Path [$moduleJsonFilePath]"

  # 2. Get the documentation link
  $documentationUri = Get-ModuleReadmeLink -TagName $ModuleReleaseTagName -ModuleFolderPath $moduleFolderPath
  Write-Verbose "Determined documentation URI [$documentationUri]"

  ###################
  ## 3.  Publish   ##
  ###################
  $plainPublicRegistryServer = ConvertFrom-SecureString $PublicRegistryServer -AsPlainText

  $publishInput = @(
    $moduleJsonFilePath
    '--target', ("br:{0}/public/bicep/{1}:{2}" -f $plainPublicRegistryServer, $moduleRelativeFolderPath, $targetVersion)
    '--documentationUri', $documentationUri
    '--force'
  )

  Write-Verbose "Publish Input:`n $($publishInput | ConvertTo-Json -Depth 10)" -Verbose

  if ($PSCmdlet.ShouldProcess("Module of tag [$ModuleReleaseTagName]", "Publish")) {
    bicep publish @publishInput
  }
}
