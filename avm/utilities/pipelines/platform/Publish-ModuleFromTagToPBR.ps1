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
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')

    # 1. Extract information from the tag
    $targetVersion = Split-Path $ModuleReleaseTagName -Leaf
    Write-Verbose "Version: [$targetVersion]" -Verbose
    $moduleRelativeFolderPath = $ModuleReleaseTagName -replace "\/$targetVersion$", ''
    Write-Verbose "Module: [$moduleRelativeFolderPath]" -Verbose
    $moduleFolderPath = Join-Path $RepoRoot $moduleRelativeFolderPath
    $moduleBicepFilePath = Join-Path $moduleFolderPath 'main.bicep'
    Write-Verbose "Determined Bicep template path [$moduleBicepFilePath]"

    # 2. Get the documentation link
    $documentationUri = Get-ModuleReadmeLink -TagName $ModuleReleaseTagName -ModuleFolderPath $moduleFolderPath
    Write-Verbose "Determined documentation URI [$documentationUri]"

    # 3. Replace telemetry version value (in Bicep)
    $tokenConfiguration = @{
        FilePathList   = @($moduleBicepFilePath)
        AbsoluteTokens = @{
            '-..--..-' = $targetVersion
        }
    }
    Write-Verbose "Convert Tokens Input:`n $($tokenConfiguration | ConvertTo-Json -Depth 10)" -Verbose
    $null = Convert-TokensInFileList @tokenConfiguration

    # Double-check that tokens are correctly replaced
    $templateContent = Get-Content -Path $moduleBicepFilePath
    $incorrectLines = @()
    for ($index = 0; $index -lt $templateContent.Count; $index++) {
        if ($templateContent[$index] -match '-..--..-') {
            $incorrectLines += ('You have the token [{0}] in line [{1}] of file [{2}]. Please seek advice from the AVM team.' -f $matches[0], ($index + 1), $moduleBicepFilePath)
        }
    }
    if ($incorrectLines) {
        throw ($incorrectLines | ConvertTo-Json)
    }

    ###################
    ## 4.  Publish   ##
    ###################
    $plainPublicRegistryServer = ConvertFrom-SecureString $PublicRegistryServer -AsPlainText

    $publishInput = @(
        $moduleBicepFilePath
        '--target', ('br:{0}/public/bicep/{1}:{2}' -f $plainPublicRegistryServer, $moduleRelativeFolderPath, $targetVersion)
        '--documentationUri', $documentationUri
        '--with-source'
        '--force'
    )

    Write-Verbose "Publish Input:`n $($publishInput | ConvertTo-Json -Depth 10)" -Verbose

    if ($PSCmdlet.ShouldProcess("Module of tag [$ModuleReleaseTagName]", 'Publish')) {
        bicep publish @publishInput
    }

    return @{
        version             = $targetVersion
        publishedModuleName = $moduleRelativeFolderPath
        gitTagName          = $ModuleReleaseTagName
    }
}
