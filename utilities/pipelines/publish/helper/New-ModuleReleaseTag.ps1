<#
.SYNOPSIS
Create and publish a new release tag.

.DESCRIPTION
Create and publish a new release tag for the specified module.

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER TargetVersion
Mandatory. Target version of the module to be published.

.EXAMPLE
New-ModuleReleaseTag -ModuleFolderPath 'C:\avm\res\key-vault\vault' -TargetVersion '1.0.0'

Creates 'avm/res/key-vault/vault/1.0.0' release tag
#>

. (Join-Path $PSScriptRoot 'New-ModuleReleaseTagReference.ps1')

function New-ModuleReleaseTag {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $true)]
        [string] $TargetVersion
    )

    $ModuleRelativeFolderPath = (($ModuleFolderPath -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'

    # 1 Build Tag
    $tagName = '{0}/{1}' -f $ModuleRelativeFolderPath, $TargetVersion
    Write-Verbose "Target release tag: [$tagName]" -Verbose

    # 2 Check tag format
    $wellFormattedTag = git check-ref-format --normalize $tagName
    if (-not $wellFormattedTag) {
        throw "Tag [$tagName] is not well formatted."
    }

    # 3 Resolve target commit
    $targetCommit = git rev-parse HEAD
    if ($LASTEXITCODE -ne 0) {
        throw 'Failed to resolve the target commit for the release tag.'
    }

    # 4 Create remote tag
    Write-Verbose "Publishing release tag: [$tagName]" -Verbose
    New-ModuleReleaseTagReference -TagName $tagName -TargetCommit $targetCommit

    # 5 Return tag
    return $tagName
}
