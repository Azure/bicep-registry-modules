<#
.SYNOPSIS
Create module release tag(s) for any updated & versioned module in a given path.

.DESCRIPTION
Create module release tag(s) for any updated & versioned module in a given path.
Checks if a module qualifies for a new release (updated and versioned).
Calculates the target module version based on the version.json file and existing published release tags.
Creates and pushes the release tag.

Note: This script only creates the git release tag(s). The actual publishing to the Public Bicep
Registry (bicep publish, telemetry token replacement, readme-link generation and MCR confirmation) is
performed by the Azure DevOps OneBranch pipelines that poll these tags. See the AME deploy migration to
ADO documentation (Workstream 5) in the Azure-Verified-Modules repository for details.

.PARAMETER TemplateFilePath
Mandatory. The path to the deployment file.

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.EXAMPLE
Set-ModuleReleaseTag -TemplateFilePath 'C:\avm\res\key-vault\vault\main.bicep'

Create the release tag(s) for the module in path 'key-vault/vault'.
#>
function Set-ModuleReleaseTag {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    # Load used functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModulesToPublish.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleTargetVersion.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'New-ModuleReleaseTag.ps1')
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-BRMRepositoryName.ps1')

    $topModuleFolderPath = Split-Path $TemplateFilePath -Parent

    $resultSet = [ordered]@{}

    # 1. Get list of all modules qualifying for publishing (updated and versioned) and order them by length, so that child modules are processed first
    $modulesToPublishList = Get-ModulesToPublish -ModuleFolderPath $topModuleFolderPath | Sort-Object -Property Length -Descending

    # If no module qualifies for publishing, return
    if (-not $modulesToPublishList) {
        Write-Verbose "No changes detected for any module in $topModuleFolderPath. Skipping tag creation." -Verbose
    }

    # 2. Iterate on the modules qualifying for publishing
    foreach ($moduleToPublish in $modulesToPublishList) {

        $moduleFolderPath = Split-Path -Path $moduleToPublish -Parent
        $moduleBicepFilePath = Join-Path $moduleFolderPath 'main.bicep'
        $moduleFolderRelativePath = [System.IO.Path]::GetRelativePath($RepoRoot, $moduleFolderPath).Replace('\', '/')

        Write-Verbose "### Module:  $moduleFolderRelativePath" -Verbose

        # 3. Calculate the version that we would publish with
        $targetVersion = Get-ModuleTargetVersion -ModuleFolderPath $moduleFolderPath

        # 4. Get Target Published Module Name
        $publishedModuleName = Get-BRMRepositoryName -TemplateFilePath $moduleBicepFilePath

        # 5. Create release tag
        $gitTagName = $null
        if ($PSCmdlet.ShouldProcess(('release tag for module [{0}] with version [{1}]' -f $moduleFolderRelativePath, $targetVersion), 'Create')) {
            $gitTagName = New-ModuleReleaseTag -ModuleFolderPath $moduleFolderPath -TargetVersion $targetVersion
        }

        $resultSet[$moduleFolderRelativePath] = @{
            version             = $targetVersion
            publishedModuleName = $publishedModuleName
            gitTagName          = $gitTagName
        }
    }

    return $resultSet
}
