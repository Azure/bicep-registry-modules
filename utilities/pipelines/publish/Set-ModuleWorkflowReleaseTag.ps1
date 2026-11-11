function Invoke-ModuleWorkflowGitLsRemote {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Remote,

        [Parameter(Mandatory)]
        [string] $Pattern,

        [Parameter()]
        [ValidateRange(1, 10)]
        [int] $RetryCount = 3,

        [Parameter()]
        [ValidateRange(0, 30)]
        [int] $RetryDelaySeconds = 2
    )

    $lastOutput = @()
    for ($attempt = 1; $attempt -le $RetryCount; $attempt++) {
        $lastOutput = @(& git ls-remote --tags $Remote $Pattern 2>&1 | ForEach-Object { $_.ToString() })
        if ($LASTEXITCODE -eq 0) {
            return $lastOutput
        }

        if ($attempt -lt $RetryCount) {
            Start-Sleep -Seconds ($RetryDelaySeconds * $attempt)
        }
    }

    $errorDetails = ($lastOutput -join [Environment]::NewLine).Trim()
    throw "Failed to query release tags matching [$Pattern] from [$Remote] after [$RetryCount] attempts. Git output: $errorDetails"
}

function ConvertTo-ModuleWorkflowRemoteTag {

    [CmdletBinding()]
    param (
        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $Reference
    )

    $tags = @{}
    foreach ($line in $Reference) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($line -notmatch '^([0-9a-fA-F]{40,64})\s+(.+)$') {
            continue
        }

        $commit = $matches[1]
        $ref = $matches[2]
        $isPeeled = $ref.EndsWith('^{}')
        $baseRef = $isPeeled ? $ref.Substring(0, $ref.Length - 3) : $ref
        if (-not $tags.ContainsKey($baseRef)) {
            $tags[$baseRef] = @{
                direct = $null
                peeled = $null
            }
        }

        $tags[$baseRef][$isPeeled ? 'peeled' : 'direct'] = $commit
    }

    return @(
        $tags.GetEnumerator() | ForEach-Object {
            [pscustomobject]@{
                name   = $_.Key -replace '^refs/tags/', ''
                commit = $_.Value.peeled ?? $_.Value.direct
            }
        }
    )
}

function Get-ModuleWorkflowTemplatesToPublish {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory)]
        [string] $RepoRoot,

        [Parameter(Mandatory)]
        [string] $TargetCommit,

        [Parameter()]
        [string] $BaseCommit,

        [Parameter()]
        [switch] $Force,

        [Parameter()]
        [switch] $IncludeAllVersionedModules
    )

    $templateFiles = @()
    if ($IncludeAllVersionedModules) {
        $templateFiles = @(
            Get-ChildItem -Path $ModuleFolderPath -Recurse -Filter 'main.json' -File |
            Where-Object { Test-Path -Path (Join-Path -Path $_.Directory.FullName -ChildPath 'version.json') } |
            Select-Object -ExpandProperty FullName
        )
    } else {
        $effectiveBaseCommit = $BaseCommit
        if ([string]::IsNullOrWhiteSpace($effectiveBaseCommit)) {
            $effectiveBaseCommit = git rev-parse "$TargetCommit^" 2>$null
            if ($LASTEXITCODE -ne 0) {
                $effectiveBaseCommit = $null
            }
        }

        if ($effectiveBaseCommit) {
            $moduleRelativePath = [System.IO.Path]::GetRelativePath($RepoRoot, $ModuleFolderPath).Replace('\', '/')
            $changedPaths = @(
                git diff --name-only --diff-filter=ACMRT $effectiveBaseCommit $TargetCommit -- $moduleRelativePath
            )
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to identify publishable changes between [$effectiveBaseCommit] and [$TargetCommit]."
            }

            foreach ($changedPath in $changedPaths) {
                if ((Split-Path -Path $changedPath -Leaf) -notin @('main.json', 'version.json')) {
                    continue
                }

                $changedFilePath = Join-Path -Path $RepoRoot -ChildPath $changedPath
                if (-not (Test-Path -Path $changedFilePath)) {
                    continue
                }

                $changedModuleFolderPath = Split-Path -Path $changedFilePath -Parent
                $templateFilePath = Join-Path -Path $changedModuleFolderPath -ChildPath 'main.json'
                $versionFilePath = Join-Path -Path $changedModuleFolderPath -ChildPath 'version.json'
                if ((Test-Path -Path $templateFilePath) -and (Test-Path -Path $versionFilePath)) {
                    $templateFiles += $templateFilePath
                }
            }
        }
    }

    if ($Force) {
        $topTemplateFilePath = Join-Path -Path $ModuleFolderPath -ChildPath 'main.json'
        $topVersionFilePath = Join-Path -Path $ModuleFolderPath -ChildPath 'version.json'
        if (-not (Test-Path -Path $topTemplateFilePath)) {
            throw "No compiled module template found at [$topTemplateFilePath]."
        }
        if (-not (Test-Path -Path $topVersionFilePath)) {
            throw "No version file found at [$topVersionFilePath]."
        }

        $templateFiles += $topTemplateFilePath
    }

    return @(
        $templateFiles |
        Select-Object -Unique |
        Sort-Object -Property Length -Descending
    )
}

function Get-ModuleWorkflowTargetVersion {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory)]
        [string] $RepoRoot,

        [Parameter(Mandatory)]
        [string] $TargetCommit,

        [Parameter()]
        [string] $BaseCommit,

        [Parameter()]
        [AllowEmptyCollection()]
        [object[]] $RemoteTag = @()
    )

    $versionFilePath = Join-Path -Path $ModuleFolderPath -ChildPath 'version.json'
    $majorMinorVersion = (Get-Content -Path $versionFilePath -Raw | ConvertFrom-Json).version
    if ($majorMinorVersion -notmatch '^\d+\.\d+$') {
        throw "Version [$majorMinorVersion] in [$versionFilePath] is not in MAJOR.MINOR format."
    }

    $effectiveBaseCommit = $BaseCommit
    if ([string]::IsNullOrWhiteSpace($effectiveBaseCommit)) {
        $effectiveBaseCommit = git rev-parse "$TargetCommit^" 2>$null
        if ($LASTEXITCODE -ne 0) {
            $effectiveBaseCommit = $null
        }
    }

    $versionChanged = $false
    if ($effectiveBaseCommit) {
        $relativeVersionFilePath = [System.IO.Path]::GetRelativePath($RepoRoot, $versionFilePath).Replace('\', '/')
        $previousVersionContent = git show "${effectiveBaseCommit}:$relativeVersionFilePath" 2>$null
        if ($LASTEXITCODE -ne 0) {
            $versionChanged = $true
        } else {
            $previousVersion = ($previousVersionContent | ConvertFrom-Json).version
            $versionChanged = $previousVersion -ne $majorMinorVersion
        }
    }

    if ($versionChanged) {
        return "$majorMinorVersion.0"
    }

    $patchVersions = @(
        $RemoteTag |
        Where-Object { $null -ne $_ -and -not [string]::IsNullOrWhiteSpace($_.name) } |
        ForEach-Object {
            $tagVersion = Split-Path -Path $_.name -Leaf
            if ($tagVersion -match ('^{0}\.(\d+)$' -f [regex]::Escape($majorMinorVersion))) {
                [int] $matches[1]
            }
        }
    )

    $patchVersion = $patchVersions.Count -eq 0 ? 0 : (($patchVersions | Measure-Object -Maximum).Maximum + 1)
    return "$majorMinorVersion.$patchVersion"
}

function New-ModuleWorkflowReleaseTag {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory)]
        [string] $TargetVersion,

        [Parameter(Mandatory)]
        [string] $TargetCommit
    )

    $moduleRelativeFolderPath = (($ModuleFolderPath -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
    $tagName = "$moduleRelativeFolderPath/$TargetVersion"
    if (-not (git check-ref-format --normalize $tagName)) {
        throw "Tag [$tagName] is not well formatted."
    }

    $existingTags = ConvertTo-ModuleWorkflowRemoteTag -Reference @(
        Invoke-ModuleWorkflowGitLsRemote -Remote origin -Pattern "$tagName*"
    ) | Where-Object { $_.name -eq $tagName }
    if ($existingTags) {
        if ($existingTags.commit -contains $TargetCommit) {
            Write-Verbose "Tag [$tagName] already exists at the target commit." -Verbose
            return $tagName
        }

        throw "Tag [$tagName] already exists at a different commit."
    }

    if ($PSCmdlet.ShouldProcess("release tag [$tagName] at commit [$TargetCommit]", 'Create and publish')) {
        git tag $tagName $TargetCommit
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create local tag [$tagName]."
        }

        git push origin "refs/tags/${tagName}:refs/tags/${tagName}"
        if ($LASTEXITCODE -eq 0) {
            return $tagName
        }

        $concurrentTags = ConvertTo-ModuleWorkflowRemoteTag -Reference @(
            Invoke-ModuleWorkflowGitLsRemote -Remote origin -Pattern "$tagName*"
        ) | Where-Object { $_.name -eq $tagName }
        if ($concurrentTags.commit -contains $TargetCommit) {
            Write-Verbose "Tag [$tagName] was concurrently published at the target commit." -Verbose
            return $tagName
        }

        throw "Failed to publish tag [$tagName]."
    }

    return $null
}

function Set-ModuleWorkflowReleaseTag {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter()]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName,

        [Parameter()]
        [string] $BaseCommit,

        [Parameter()]
        [string] $TargetCommit = 'HEAD',

        [Parameter()]
        [switch] $Force,

        [Parameter()]
        [switch] $IncludeAllVersionedModules
    )

    $resolvedTargetCommit = git rev-parse $TargetCommit
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to resolve target commit [$TargetCommit]."
    }
    if (-not [string]::IsNullOrWhiteSpace($BaseCommit)) {
        git cat-file -e "${BaseCommit}^{commit}" 2>$null
        if ($LASTEXITCODE -ne 0) {
            git fetch --no-tags origin $BaseCommit 2>$null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to fetch base commit [$BaseCommit]."
            }
            git cat-file -e "${BaseCommit}^{commit}" 2>$null
            if ($LASTEXITCODE -ne 0) {
                throw "Base commit [$BaseCommit] is unavailable after fetching it."
            }
        }
    }

    $topModuleFolderPath = Split-Path -Path $TemplateFilePath -Parent
    $templatesToPublish = Get-ModuleWorkflowTemplatesToPublish `
        -ModuleFolderPath $topModuleFolderPath `
        -RepoRoot $RepoRoot `
        -BaseCommit $BaseCommit `
        -TargetCommit $resolvedTargetCommit `
        -Force:$Force `
        -IncludeAllVersionedModules:$IncludeAllVersionedModules

    $result = [ordered]@{}
    foreach ($templateToPublish in $templatesToPublish) {
        $moduleFolderPath = Split-Path -Path $templateToPublish -Parent
        $moduleFolderRelativePath = [System.IO.Path]::GetRelativePath($RepoRoot, $moduleFolderPath).Replace('\', '/')
        $publishedModuleName = $moduleFolderRelativePath
        $majorMinorVersion = (Get-Content -Path (Join-Path -Path $moduleFolderPath -ChildPath 'version.json') -Raw | ConvertFrom-Json).version
        $remoteTags = ConvertTo-ModuleWorkflowRemoteTag -Reference @(
            Invoke-ModuleWorkflowGitLsRemote -Remote origin -Pattern "$publishedModuleName/$majorMinorVersion.*"
        )

        $validRemoteTags = @(
            $remoteTags | Where-Object {
                (Split-Path -Path $_.name -Leaf) -match ('^{0}\.\d+$' -f [regex]::Escape($majorMinorVersion))
            }
        )
        $existingTagAtTarget = $validRemoteTags |
        Where-Object { $_.commit -eq $resolvedTargetCommit } |
        Sort-Object -Property { [version](Split-Path -Path $_.name -Leaf) } -Descending |
        Select-Object -First 1

        if ($existingTagAtTarget) {
            $targetVersion = Split-Path -Path $existingTagAtTarget.name -Leaf
            $result[$moduleFolderRelativePath] = @{
                version             = $targetVersion
                publishedModuleName = $publishedModuleName
                gitTagName          = $existingTagAtTarget.name
            }
            continue
        }

        $targetVersion = Get-ModuleWorkflowTargetVersion `
            -ModuleFolderPath $moduleFolderPath `
            -RepoRoot $RepoRoot `
            -BaseCommit $BaseCommit `
            -TargetCommit $resolvedTargetCommit `
            -RemoteTag $validRemoteTags

        $targetTagName = "$publishedModuleName/$targetVersion"
        $conflictingTargetTag = $validRemoteTags |
        Where-Object { $_.name -eq $targetTagName -and $_.commit -ne $resolvedTargetCommit } |
        Select-Object -First 1
        if ($conflictingTargetTag) {
            throw "Tag [$targetTagName] already exists at a different commit."
        }

        $gitTagName = $null
        if ($PSCmdlet.ShouldProcess("release tag for module [$moduleFolderRelativePath] with version [$targetVersion]", 'Create')) {
            $gitTagName = New-ModuleWorkflowReleaseTag `
                -ModuleFolderPath $moduleFolderPath `
                -TargetVersion $targetVersion `
                -TargetCommit $resolvedTargetCommit
        }

        $result[$moduleFolderRelativePath] = @{
            version             = $targetVersion
            publishedModuleName = $publishedModuleName
            gitTagName          = $gitTagName
        }
    }

    return $result
}
