<#
.SYNOPSIS
Update the CHANGELOG.md with a new version entry for a single specified module.

.DESCRIPTION
Update the specified module CHANGELOG.md with a new version entry. Pass in the changes and breaking changes, that will be added.

.PARAMETER Changes
Mandatory. The changes that will be added to the changelog. Use `\n` to separate multiple changes and start each change with a `-` to create a bullet point.

.PARAMETER BreakingChanges
Optional. The breaking changes that will be added to the changelog. Use `\n` to separate multiple breaking changes and start each change with a `-` to create a bullet point.

.PARAMETER moduleFolderPath
Mandatory. The path to the module folder where the CHANGELOG.md is located. This should be the path to the module's root folder, e.g. 'avm/res/network/virtual-network

.PARAMETER RepoRoot
Optional. The root path of the repository. Defaults to the parent folder of the script's location

.EXAMPLE
Set-ChangelogEntry -Changes '- Added new feature X\n- Fixed bug Y\n- And Z' -BreakingChanges '- Removed feature A' -ModuleFolderPath 'avm/res/network/virtual-network'

Adds a new version entry to the CHANGELOG.md of all modified modules with the specified changes and breaking changes.

#>
function Set-ChangelogEntry {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Changes,

        [Parameter(Mandatory = $false)]
        [string] $BreakingChanges = '- None',

        [Parameter(Mandatory = $true)]
        [string] $moduleFolderPath,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.FullName
    )

    Write-Verbose "Processing module: $moduleFolderPath"
    $changelogPath = Join-Path -Path $moduleFolderPath 'CHANGELOG.md'
    if (-not (Test-Path $changelogPath)) {
        Write-Error "CHANGELOG.md does not exist for module: $moduleFolderPath"
        continue
    }

    # get the module version for the Changelog entry
    if ((Get-ModulesToPublish -ModuleFolderPath $moduleFolderPath) -ge 1) {
        # the module will be published
        $moduleVersion = Get-ModuleTargetVersion -ModuleFolderPath $moduleFolderPath
    } else {
        # the module will not be published
        return
    }

    # add the new version entry to the changelog
    $newChangelogEntry = @(
        '',
        ('## {0}' -f $moduleVersion),
        '',
        '### Changes',
        '',
        ($Changes.Trim() -split '\\n'),
        '',
        '### Breaking Changes',
        '',
        ($BreakingChanges.Trim() -split '\\n')
    )
    $changelogContent = Get-Content -Path $changelogPath
    $newChangelogContent = $changelogContent[0..2] + $newChangelogEntry + $changelogContent[3..($changelogContent.Count - 1)]
    if ($PSCmdlet.ShouldProcess("File in path [$changelogPath]", 'Overwrite')) {
        Set-Content -Path $changelogPath -Value $newChangelogContent -Force -Encoding 'utf8'
    }
    Write-Verbose "File [$changelogPath] updated"
}


<#
.SYNOPSIS
Update the CHANGELOG.md with a new version entry in bulk, for all updated modules qualifying for publishing.

.DESCRIPTION
Update the CHANGELOG.md with a new version entry. The entry will only be added for changed modules that will be published. Pass in the changes and breaking changes, that will be added.

.PARAMETER Changes
Mandatory. The changes that will be added to the changelog. Use `\n` to separate multiple changes and start each change with a `-` to create a bullet point.

.PARAMETER BreakingChanges
Optional. The breaking changes that will be added to the changelog. Use `\n` to separate multiple breaking changes and start each change with a `-` to create a bullet point.

.PARAMETER RepoRoot
Optional. The root path of the repository. Defaults to the parent folder of the script's location

.EXAMPLE
Set-ChangelogEntryOnModules -Changes '- Added new feature X\n- Fixed bug Y\n- And Z' -BreakingChanges '- Removed feature A'

Adds a new version entry to the CHANGELOG.md of all modified modules with the specified changes and breaking changes.

#>
function Set-ChangelogEntryOnModules {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Changes,

        [Parameter(Mandatory = $false)]
        [string] $BreakingChanges = '- None',

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.FullName
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModulesToPublish.ps1')
        . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleTargetVersion.ps1')

        $originalLocation = Get-Location
        Set-Location $RepoRoot
    }

    process {
        $modifiedModules = Get-ModifiedFileList | Where-Object { $_ -match 'avm[\/|\\](res|ptn|utl)[\/|\\].*' } | ForEach-Object { Split-Path $_ -Parent } | Sort-Object -Unique

        foreach ($moduleFolderPath in $modifiedModules) {
            Set-ChangelogEntry -Changes $Changes -BreakingChanges $BreakingChanges -RepoRoot $RepoRoot -moduleFolderPath $moduleFolderPath
        }
    }

    end {
        Set-Location $originalLocation
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
