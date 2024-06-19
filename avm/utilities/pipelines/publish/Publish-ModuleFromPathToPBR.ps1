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

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Publish-ModuleFromPathToPBR -TemplateFilePath 'C:\avm\res\key-vault\vault\main.bicep -PublicRegistryServer (ConvertTo-SecureString 'myServer' -AsPlainText -Force)

Publish the module in path 'key-vault/vault' to the public registry server 'myServer'
#>
function Publish-ModuleFromPathToPBR {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [secureString] $PublicRegistryServer,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
    )

    # Load used functions
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModulesToPublish.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleTargetVersion.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'publish' 'helper' 'New-ModuleReleaseTag.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleReadmeLink.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'sharedScripts' 'Get-BRMRepositoryName.ps1')
    . (Join-Path $RepoRoot 'avm' 'utilities' 'pipelines' 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')

    $moduleFolderPath = Split-Path $TemplateFilePath -Parent
    $moduleBicepFilePath = Join-Path $moduleFolderPath 'main.bicep'

    # 1. Test if module qualifies for publishing
    if (-not (Get-ModulesToPublish -ModuleFolderPath $moduleFolderPath)) {
        Write-Verbose 'No changes detected. Skipping publishing' -Verbose
        return
    }

    # 2. Calculate the version that we would publish with
    $targetVersion = Get-ModuleTargetVersion -ModuleFolderPath $moduleFolderPath

    # 3. Get Target Published Module Name
    $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $TemplateFilePath

    # 4.Create release tag
    $gitTagName = New-ModuleReleaseTag -ModuleFolderPath $moduleFolderPath -TargetVersion $targetVersion

    # 5. Get the documentation link
    $documentationUri = Get-ModuleReadmeLink -TagName $gitTagName -ModuleFolderPath $moduleFolderPath

    # 6. Replace telemetry version value (in Bicep)
    $tokenConfiguration = @{
        FilePathList   = @($moduleBicepFilePath)
        AbsoluteTokens = @{
            '-..--..-' = $targetVersion
        }
    }
    Write-Verbose "Convert Tokens Input:`n $($tokenConfiguration | ConvertTo-Json -Depth 10)" -Verbose
    $null = Convert-TokensInFileList @tokenConfiguration

    # Double-check that tokens are correctly replaced
    $templateContent = bicep build $moduleBicepFilePath --stdout
    $incorrectLines = @()
    for ($index = 0; $index -lt $templateContent.Count; $index++) {
        if ($templateContent[$index] -match '\-\.\.-\-\.\.\-') {
            $incorrectLines += ('You have the token [{0}] in line [{1}] of the compiled Bicep file [{2}]. Please seek advice from the AVM team.' -f $matches[0], ($index + 1), $moduleBicepFilePath)
        }
    }
    if ($incorrectLines) {
        throw ($incorrectLines | ConvertTo-Json)
    }

    ###################
    ## 7.  Publish   ##
    ###################
    $plainPublicRegistryServer = ConvertFrom-SecureString $PublicRegistryServer -AsPlainText

    $publishInput = @(
        $moduleBicepFilePath
        '--target', ('br:{0}/public/bicep/{1}:{2}' -f $plainPublicRegistryServer, $publishedModuleName, $targetVersion)
        '--documentationUri', $documentationUri
        '--with-source'
        '--force'
    )
    # TODO move to its own task to show that as skipped if no file qualifies for new version
    Write-Verbose "Publish Input:`n $($publishInput | ConvertTo-Json -Depth 10)" -Verbose

    bicep publish @publishInput

    return @{
        version             = $targetVersion
        publishedModuleName = $publishedModuleName
        gitTagName          = $gitTagName
    }
}
