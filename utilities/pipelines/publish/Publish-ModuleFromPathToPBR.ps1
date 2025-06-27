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
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    # Load used functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModulesToPublish.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleTargetVersion.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'New-ModuleReleaseTag.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleReadmeLink.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-BRMRepositoryName.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')

    $topModuleFolderPath = Split-Path $TemplateFilePath -Parent

    $resultSet = [ordered]@{}

    # 1. Get list of all modules qualifying for publishing (updated and versioned) and order them by length, so that child modules are processed first
    $modulesToPublishList = Get-ModulesToPublish -ModuleFolderPath $topModuleFolderPath | Sort-Object -Property Length -Descending

    # If no module qualifies for publishing, return
    if (-not $modulesToPublishList) {
        Write-Verbose "No changes detected for any module in $topModuleFolderPath. Skipping publishing." -Verbose
    }

    # 2. Iterate on the modules qualifying for publishing
    foreach ($moduleToPublish in $modulesToPublishList) {

        $moduleFolderPath = Split-Path -Path $moduleToPublish -Parent
        $moduleBicepFilePath = Join-Path $moduleFolderPath 'main.bicep'
        $moduleFolderRelativePath = ($moduleFolderPath -replace ('{0}[\/|\\]' -f [Regex]::Escape($repoRoot)), '') -replace '\\', '/'

        Write-Verbose "### Module:  $moduleFolderRelativePath" -Verbose

        # 3. Calculate the version that we would publish with
        $targetVersion = Get-ModuleTargetVersion -ModuleFolderPath $moduleFolderPath

        # 4. Get Target Published Module Name
        $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $moduleBicepFilePath

        # 5.Create release tag
        $gitTagName = New-ModuleReleaseTag -ModuleFolderPath $moduleFolderPath -TargetVersion $targetVersion

        # 6. Get the documentation link
        $documentationUri = Get-ModuleReadmeLink -TagName $gitTagName -ModuleFolderPath $moduleFolderPath

        # 7. Replace telemetry version value (in Bicep)
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
        ## 8.  Publish   ##
        ###################
        $plainPublicRegistryServer = ConvertFrom-SecureString $PublicRegistryServer -AsPlainText

        $publishInput = @(
            $moduleBicepFilePath
            '--target', ('br:{0}/public/bicep/{1}:{2}' -f $plainPublicRegistryServer, $publishedModuleName, $targetVersion)
            '--documentation-uri', $documentationUri
            '--with-source'
            '--force'
        )
        # TODO move to its own task to show that as skipped if no file qualifies for new version
        Write-Verbose "Publish Input:`n $($publishInput | ConvertTo-Json -Depth 10)" -Verbose

        bicep publish @publishInput

        $resultSet[$moduleFolderRelativePath] = @{
            version             = $targetVersion
            publishedModuleName = $publishedModuleName
            gitTagName          = $gitTagName
        }
    }

    return $resultSet
}
