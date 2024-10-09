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

    # 3 Check tag not already existing
    $existingTag = git ls-remote --tags origin $tagName
    if ($existingTag) {
        Write-Verbose "Tag [$tagName] already exists" -Verbose
        return $tagName
    }


    # 3 Create local tag
    Write-Verbose "Creating release tag: [$tagName]" -Verbose
    git tag $tagName

    # 4 Publish release tag
    Write-Verbose "Publishing release tag: [$tagName]" -Verbose
    git push origin $tagName

    if ($LASTEXITCODE -ne 0) {
        throw 'Git Tag creation failed. Please review error log.'
    }

    # 5 Return tag
    return $tagName
}
