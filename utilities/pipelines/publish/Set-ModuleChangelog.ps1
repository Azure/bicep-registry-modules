function Set-ModuleChangelog {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName
    )

    # Load used functions
    . (Join-Path $RepoRoot 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModuleTargetVersion.ps1')

    Write-Verbose "Set-ModuleChangelog - ModulePath: $ModulePath" -Verbose
    Write-Verbose "Set-ModuleChangelog - RepoRoot: $RepoRoot" -Verbose

    $fullModulePath = Join-Path -Path $RepoRoot $ModulePath
    $changelogFilePath = Join-Path -Path $fullModulePath 'CHANGELOG.md'
    if (-not (Test-Path -Path $changelogFilePath)) {
        Write-Warning -Message "CHANGELOG.md file not found in $fullModulePath."
        return
    }

    # get new version
    $moduleVersion = Get-ModuleTargetVersion -ModuleFolderPath $fullModulePath
    Write-Verbose "The module's new version is: $moduleVersion" -Verbose

    # modify changelog content
    $changelogContent = Get-Content $changelogFilePath
    $changelogSection = $changelogContent | Where-Object { $_ -match '^##\s+unreleased' }
    if (!$changelogSection) {
        Write-Error -Message "'## unreleased' section not found in $changelogFilePath."
        return
    }
    Write-Verbose ('Setting the new version and date in the changelog file "{0}"' -f $changelogFilePath) -Verbose
    $newChangelogContent = $changelogContent -replace '^##\s+unreleased', ("## $moduleVersion - " + (Get-Date -Format 'yyyy-MM-dd'))
    Set-Content -Path $changelogFilePath -Value $newChangelogContent -Verbose

    # Update the changelog file and commit the changes
    Write-Verbose 'Updating and commiting the changelog file' -Verbose
    git config --global user.name 'github-actions[bot]'
    git config --global user.email 'github-actions[bot]@users.noreply.github.com'
    git add $changelogFilePath
    git commit -m "Updating CHANGELOG.md to version $moduleVersion" $changelogFilePath
    git push --verbose

    return @{
        version          = $moduleVersion
        changelogContent = $changelogContent
    }
}
