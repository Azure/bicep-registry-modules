$script:preservedReadmes = @(
    @{ Path = 'avm/ptn/aca-lza/hosting-environment/modules/container-apps-environment/README.md'; Length = 3323; Sha256 = '52b01a41bcd80824358b3062038a8e57fb9c301d221c1923adb22a46ce69f29e' }
    @{ Path = 'avm/ptn/aca-lza/hosting-environment/modules/spoke/README.md'; Length = 3217; Sha256 = 'b00a9be3bcfe1a2babb20ce8ee3fdad96094601ecfc58c9199ed8297b5ef2864' }
    @{ Path = 'avm/ptn/aca-lza/hosting-environment/modules/supporting-services/README.md'; Length = 3632; Sha256 = 'fcf377212ed8602f6bec9e95a2d4ba832e9777b3be99f07c5d6c84f65a83cfd6' }
)

function Assert-AvmReadmePreservation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $RepoRootPath,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $SourceLessReadmes
    )

    if ($SourceLessReadmes.Count -ne $script:preservedReadmes.Count) {
        throw "Expected exactly three source-less READMEs, found [$($SourceLessReadmes.Count)]."
    }
    foreach ($policy in $script:preservedReadmes) {
        if (@($SourceLessReadmes -ceq $policy.Path).Count -ne 1) {
            throw "Source-less README coverage changed: [$($policy.Path)]."
        }
        $path = Join-Path $RepoRootPath $policy.Path
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "Preserved source-less README is missing: [$($policy.Path)]."
        }
        $file = Get-Item -LiteralPath $path -Force
        if ($file.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw "Preserved source-less README must be a regular file: [$($policy.Path)]."
        }
        foreach ($name in @('main.bicep', 'main.json', 'metadata.json')) {
            if (Test-Path -LiteralPath (Join-Path $file.DirectoryName $name)) {
                throw "Preserved README is no longer source-less: [$($policy.Path)] has [$name]."
            }
        }
        $bytes = [IO.File]::ReadAllBytes($file.FullName)
        $sha256 = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($bytes)).ToLowerInvariant()
        if ($bytes.LongLength -ne $policy.Length -or $sha256 -cne $policy.Sha256) {
            throw "Preserved source-less README bytes changed: [$($policy.Path)]."
        }
    }
}

function Get-AvmReadmeDriftInventory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $RepoRootPath
    )

    $root = (Resolve-Path -LiteralPath $RepoRootPath -ErrorAction Stop).ProviderPath
    $avmRoot = Join-Path $root 'avm'
    if (-not (Test-Path -LiteralPath $avmRoot -PathType Container)) {
        throw "AVM module folder is missing: [$avmRoot]."
    }

    $sources = @(Get-ChildItem -LiteralPath $avmRoot -Recurse -File -Force -Filter 'main.bicep')
    $readmes = @(Get-ChildItem -LiteralPath $avmRoot -Recurse -File -Force -Filter 'README.md')
    if ($sources.Count -ne 574 -or $readmes.Count -ne 577) {
        throw "README coverage changed: main.bicep=$($sources.Count), README.md=$($readmes.Count); expected 574 and 577."
    }
    foreach ($file in @($sources) + @($readmes)) {
        if ($file.Attributes -band [IO.FileAttributes]::ReparsePoint) {
            throw "README inventory contains a linked file: [$($file.FullName)]."
        }
    }

    $readmePaths = @($readmes | ForEach-Object {
            [IO.Path]::GetRelativePath($root, $_.FullName).Replace('\', '/')
        } | Sort-Object -CaseSensitive)
    $sourceReadmes = @($sources | ForEach-Object {
            ([IO.Path]::GetRelativePath($root, $_.FullName).Replace('\', '/') -replace 'main\.bicep$', 'README.md')
        } | Sort-Object -CaseSensitive)
    $sourceSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $readmeSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($path in $readmePaths) {
        if (-not $readmeSet.Add($path)) {
            throw "Duplicate README path: [$path]."
        }
    }
    foreach ($path in $sourceReadmes) {
        if (-not $sourceSet.Add($path) -or -not $readmeSet.Contains($path)) {
            throw "Source-backed README is missing or duplicated: [$path]."
        }
    }
    $sourceLessReadmes = @($readmePaths | Where-Object { -not $sourceSet.Contains($_) })
    Assert-AvmReadmePreservation -RepoRootPath $root -SourceLessReadmes $sourceLessReadmes

    [pscustomobject]@{
        Root               = $root
        SourceReadmes      = $sourceReadmes
        SourceLessReadmes  = $sourceLessReadmes
    }
}

function Get-AvmReadmeDriftSelection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $SourceReadmes,

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $ChangedFilePath = @(),

        [switch] $FullScan
    )

    $scopes = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $compileScopes = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($changedPath in $ChangedFilePath) {
        if ([string]::IsNullOrWhiteSpace($changedPath)) {
            throw 'Changed file paths must not be empty.'
        }
        $path = $changedPath.Replace('\', '/')
        if ($path.StartsWith('/') -or $path -match '^[a-zA-Z]:/' -or $path.Split('/') -contains '..') {
            throw "Changed file path must be repository-relative: [$changedPath]."
        }
        if ($path -ceq 'bicepconfig.json' -or $path -ceq 'avm-readme-v1.scriban' -or
            $path.EndsWith('/avm-readme-v1.scriban', [StringComparison]::Ordinal)) {
            $FullScan = $true
        }
        $segments = $path.Split('/')
        if ($segments.Count -lt 5 -or $segments[0] -cne 'avm' -or
            $segments[1] -cnotin @('res', 'ptn', 'utl')) {
            continue
        }
        $tail = $segments[4..($segments.Count - 1)] -join '/'
        if ($tail -cnotmatch '(^|/)(README(\.notes)?\.md|main\.(bicep|json)|metadata\.json)$' -and
            $tail -cnotmatch '(^|/)tests/e2e/') {
            continue
        }
        $moduleRoot = $segments[0..3] -join '/'
        $null = $scopes.Add($moduleRoot)
        if ($tail -cmatch '(^|/)main\.(bicep|json)$') {
            $null = $compileScopes.Add($moduleRoot)
        }
    }

    $scopePaths = if ($FullScan) { @('.') } else { @($scopes | Sort-Object -CaseSensitive) }
    $selectedReadmes = if ($FullScan) {
        @($SourceReadmes)
    } else {
        @($SourceReadmes | Where-Object {
                $path = $_
                @($scopePaths | Where-Object {
                        $path.StartsWith("$_/", [StringComparison]::Ordinal)
                    }).Count -gt 0
            })
    }
    [pscustomobject]@{
        Scopes         = @($scopePaths)
        CompileScopes  = @($compileScopes | Sort-Object -CaseSensitive)
        SourceReadmes  = @($selectedReadmes)
    }
}

function Test-AvmReadmeApprovedVaultDifference {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $RelativePath,

        [Parameter(Mandatory)]
        [byte[]] $CurrentBytes,

        [Parameter(Mandatory)]
        [byte[]] $GeneratedBytes
    )

    if ($RelativePath -cne 'avm/res/key-vault/vault/README.md' -or
        $CurrentBytes.LongLength -ne 94325 -or $GeneratedBytes.LongLength -ne 94557 -or
        [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($CurrentBytes)).ToLowerInvariant() -cne
        '72befb145543d707ba849143eccb8d4b17efe2b09385156e6a5cc1b7060d8e01') {
        return $false
    }
    $utf8 = [Text.UTF8Encoding]::new($false, $true)
    $lines = $utf8.GetString($CurrentBytes).Split([char]"`n")
    $insertions = [ordered]@{
        '182'  = @{ Anchor = '  "parameters": {'; Comment = '    // Required parameters' }
        '185'  = @{ Anchor = '    },'; Comment = '    // Non-required parameters' }
        '549'  = @{ Anchor = '  "parameters": {'; Comment = '    // Required parameters' }
        '552'  = @{ Anchor = '    },'; Comment = '    // Non-required parameters' }
        '1134' = @{ Anchor = '  "parameters": {'; Comment = '    // Required parameters' }
        '1137' = @{ Anchor = '    },'; Comment = '    // Non-required parameters' }
        '1347' = @{ Anchor = '  "parameters": {'; Comment = '    // Required parameters' }
        '1350' = @{ Anchor = '    },'; Comment = '    // Non-required parameters' }
    }
    foreach ($entry in $insertions.GetEnumerator()) {
        $index = [int]$entry.Key - 1
        if ($index -ge $lines.Length -or $lines[$index] -cne $entry.Value.Anchor) {
            return $false
        }
    }
    $allowed = [Text.StringBuilder]::new($lines.Length + $CurrentBytes.Length + 232)
    for ($index = 0; $index -lt $lines.Length; $index++) {
        if ($index -gt 0) {
            $null = $allowed.Append("`n")
        }
        $null = $allowed.Append($lines[$index])
        $lineNumber = ($index + 1).ToString([Globalization.CultureInfo]::InvariantCulture)
        if ($insertions.Contains($lineNumber)) {
            $null = $allowed.Append("`n").Append($insertions[$lineNumber].Comment)
        }
    }
    $expected = $utf8.GetBytes($allowed.ToString())
    return [Linq.Enumerable]::SequenceEqual([byte[]]$expected, [byte[]]$GeneratedBytes)
}

function Get-AvmReadmeCompiledJson {
    [CmdletBinding()]
    [OutputType([byte[]])]
    param(
        [Parameter(Mandatory)]
        [string] $SourcePath,

        [Parameter(Mandatory)]
        [string] $ToolPath
    )

    $outputPath = Join-Path ([IO.Path]::GetTempPath()) ("avm-readme-$([guid]::NewGuid().ToString('N')).json")
    try {
        $diagnostics = @(& $ToolPath build $SourcePath --outfile $outputPath 2>&1)
        if ($LASTEXITCODE -ne 0 -or -not [IO.File]::Exists($outputPath)) {
            throw "Bicep build failed for [$SourcePath] (exit $LASTEXITCODE): $($diagnostics -join [Environment]::NewLine)"
        }
        $bytes = [IO.File]::ReadAllBytes($outputPath)
        $utf8 = [Text.UTF8Encoding]::new($false, $true)
        $options = [Text.Json.JsonDocumentOptions]::new()
        $options.MaxDepth = 1024
        $document = [Text.Json.JsonDocument]::Parse($utf8.GetString($bytes), $options)
        try {
            $schema = [Text.Json.JsonElement]::new()
            $version = [Text.Json.JsonElement]::new()
            $resources = [Text.Json.JsonElement]::new()
            $root = $document.RootElement
            if ($root.ValueKind -ne [Text.Json.JsonValueKind]::Object -or
                -not $root.TryGetProperty('$schema', [ref]$schema) -or
                $schema.ValueKind -ne [Text.Json.JsonValueKind]::String -or
                [string]::IsNullOrWhiteSpace($schema.GetString()) -or
                -not $root.TryGetProperty('contentVersion', [ref]$version) -or
                $version.ValueKind -ne [Text.Json.JsonValueKind]::String -or
                [string]::IsNullOrWhiteSpace($version.GetString()) -or
                -not $root.TryGetProperty('resources', [ref]$resources) -or
                $resources.ValueKind -notin @([Text.Json.JsonValueKind]::Object, [Text.Json.JsonValueKind]::Array)) {
                throw "Bicep build returned invalid ARM JSON for [$SourcePath]."
            }
            if ($resources.ValueKind -eq [Text.Json.JsonValueKind]::Object) {
                $languageVersion = [Text.Json.JsonElement]::new()
                if (-not $root.TryGetProperty('languageVersion', [ref]$languageVersion) -or
                    $languageVersion.ValueKind -ne [Text.Json.JsonValueKind]::String -or
                    $languageVersion.GetString() -cne '2.0') {
                    throw "Bicep build returned invalid ARM JSON for [$SourcePath]."
                }
            }
        } finally {
            $document.Dispose()
        }
        return ,$bytes
    } finally {
        if ([IO.File]::Exists($outputPath)) {
            [IO.File]::Delete($outputPath)
        }
    }
}

function Update-AvmReadmeCompiledJson {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)]
        [pscustomobject] $Inventory,

        [Parameter(Mandatory)]
        [string[]] $CompileScopes
    )

    $tool = Get-AvmTool -Name 'bicep' -SkipModuleVersionCheck
    if ($tool.Status -ceq 'not-installed') {
        Install-AvmTool -Name 'bicep' -SkipModuleVersionCheck
        $tool = Get-AvmTool -Name 'bicep' -SkipModuleVersionCheck
    }
    if ($tool.Status -cne 'installed' -or
        -not (Test-Path -LiteralPath $tool.Path -PathType Leaf)) {
        throw 'The SHA-pinned Bicep CLI is unavailable; documentation cannot use PATH or an unverified compiler.'
    }

    $changes = [Collections.Generic.List[object]]::new()
    foreach ($readme in $Inventory.SourceReadmes) {
        if (@($CompileScopes | Where-Object {
                    $readme.StartsWith("$_/", [StringComparison]::Ordinal)
                }).Count -eq 0) {
            continue
        }
        $sourcePath = Join-Path $Inventory.Root ($readme -replace 'README\.md$', 'main.bicep')
        $jsonPath = Join-Path $Inventory.Root ($readme -replace 'README\.md$', 'main.json')
        $compiled = Get-AvmReadmeCompiledJson -SourcePath $sourcePath -ToolPath $tool.Path
        $current = if ([IO.File]::Exists($jsonPath)) { [IO.File]::ReadAllBytes($jsonPath) } else { $null }
        if ($null -eq $current -or
            -not [Linq.Enumerable]::SequenceEqual([byte[]]$current, [byte[]]$compiled)) {
            $changes.Add([pscustomobject]@{
                    Path     = $jsonPath
                    Relative = ($readme -replace 'README\.md$', 'main.json')
                    Bytes    = $compiled
                })
        }
    }
    if ($changes.Count -gt 0 -and
        -not $PSCmdlet.ShouldProcess(($changes.Relative -join ', '), 'Refresh compiled JSON in disposable checkout')) {
        throw 'Cannot validate source changes without refreshing compiled JSON.'
    }
    foreach ($change in $changes) {
        [IO.File]::WriteAllBytes($change.Path, $change.Bytes)
    }
    return @($changes | ForEach-Object { $_.Relative })
}

function ConvertTo-AvmReadmeRepoPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Scope,

        [Parameter(Mandatory)]
        [string] $RelativePath
    )

    $path = $RelativePath.Replace('\', '/')
    if ([string]::IsNullOrWhiteSpace($path) -or $path.StartsWith('/') -or
        $path -match '^[a-zA-Z]:/' -or $path.Split('/') -contains '..') {
        throw "The Bicep documentation tool returned an invalid relative path: [$RelativePath]."
    }
    if ($Scope -ceq '.') { return $path }
    return "$Scope/$path"
}

function Test-AvmReadmeDrift {
    <#
    .SYNOPSIS
    Validate generated Bicep README bytes without modifying READMEs.

    .DESCRIPTION
    Call only in a disposable checkout when changed Bicep source or main.json
    requires refreshing compiled JSON before checking README drift.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory)]
        [string] $RepoRootPath,

        [Parameter()]
        [AllowEmptyCollection()]
        [string[]] $ChangedFilePath = @(),

        [switch] $FullScan,

        [switch] $DisposableCheckout
    )

    Set-StrictMode -Version 3.0
    $ErrorActionPreference = 'Stop'
    $inventory = Get-AvmReadmeDriftInventory -RepoRootPath $RepoRootPath
    $selection = Get-AvmReadmeDriftSelection -SourceReadmes $inventory.SourceReadmes `
        -ChangedFilePath $ChangedFilePath -FullScan:$FullScan
    if ($selection.SourceReadmes.Count -eq 0) {
        return [pscustomobject]@{ Status = 'skipped'; FilesSelected = 0; FilesProcessed = 0 }
    }
    if ($selection.CompileScopes.Count -gt 0 -and -not $DisposableCheckout) {
        throw 'Source or main.json changes require -DisposableCheckout to refresh compiled JSON safely.'
    }
    $compiledDrift = @()
    if ($selection.CompileScopes.Count -gt 0) {
        if (-not $PSCmdlet.ShouldProcess(($selection.CompileScopes -join ', '), 'Refresh compiled JSON in disposable checkout')) {
            throw 'Cannot check source changes with -WhatIf: current compiled JSON is required for README validation.'
        }
        $compiledDrift = @(Update-AvmReadmeCompiledJson -Inventory $inventory -CompileScopes $selection.CompileScopes)
    }

    $readmeSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $processed = 0
    $vaultExceptions = 0
    foreach ($scope in $selection.Scopes) {
        $path = if ($scope -ceq '.') { $inventory.Root } else { Join-Path $inventory.Root $scope }
        $expected = @($selection.SourceReadmes | Where-Object {
                $scope -ceq '.' -or $_.StartsWith("$scope/", [StringComparison]::Ordinal)
            })
        $expectedNoSource = @($inventory.SourceLessReadmes | Where-Object {
                $scope -ceq '.' -or $_.StartsWith("$scope/", [StringComparison]::Ordinal)
            })
        $result = Invoke-AvmDocs -Path $path -Ecosystem bicep -CheckDrift `
            -IncludeRenderedContent -SkipModuleVersionCheck -WhatIf:$WhatIfPreference
        foreach ($name in @('Engine', 'Status', 'FilesSelected', 'FilesProcessed', 'NotRendered', 'Changed', 'Issues', 'GeneratedReadmes')) {
            if ($null -eq $result -or $null -eq $result.PSObject.Properties[$name]) {
                throw "Bicep documentation returned no [$name] for [$scope]."
            }
        }
        foreach ($name in @('NotRendered', 'Changed', 'Issues', 'GeneratedReadmes')) {
            if ($result.$name -isnot [array]) {
                throw "Bicep documentation returned a non-array [$name] for [$scope]."
            }
        }
        if ($result.Engine -cne 'bicep' -or $result.Status -cnotin @('pass', 'fail') -or
            $result.FilesSelected -isnot [int] -or $result.FilesProcessed -isnot [int] -or
            $result.FilesSelected -ne $expected.Count -or $result.FilesProcessed -ne $expected.Count -or
            @($result.Changed).Count -ne 0) {
            $details = @($result.Issues | ForEach-Object { "[$($_.Code)] $($_.Message)" }) -join '; '
            throw "Bicep documentation did not process every selected README for [$scope]: selected=$($result.FilesSelected), processed=$($result.FilesProcessed), expected=$($expected.Count), status=$($result.Status). $details"
        }

        $noSource = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($relative in $result.NotRendered) {
            $file = ConvertTo-AvmReadmeRepoPath -Scope $scope -RelativePath $relative
            if (-not $noSource.Add($file)) {
                throw "Bicep documentation reported a duplicate source-less README: [$file]."
            }
        }
        if ($noSource.Count -ne $expectedNoSource.Count -or
            @($expectedNoSource | Where-Object { -not $noSource.Contains($_) }).Count -ne 0) {
            throw "Source-less README coverage changed for [$scope]: $($noSource -join ', ')."
        }

        $expectedSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($file in $expected) { $null = $expectedSet.Add($file) }
        $vaultDrift = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($generated in $result.GeneratedReadmes) {
            $file = ConvertTo-AvmReadmeRepoPath -Scope $scope -RelativePath $generated.Path
            if (-not $expectedSet.Contains($file) -or -not $readmeSet.Add($file) -or
                $generated.Content -isnot [string]) {
                throw "Unexpected or incomplete generated README: [$file]."
            }
            $current = [IO.File]::ReadAllBytes((Join-Path $inventory.Root $file))
            $rendered = [Text.UTF8Encoding]::new($false, $true).GetBytes([string]$generated.Content)
            if (-not [Linq.Enumerable]::SequenceEqual([byte[]]$current, [byte[]]$rendered)) {
                if (-not (Test-AvmReadmeApprovedVaultDifference -RelativePath $file `
                            -CurrentBytes $current -GeneratedBytes $rendered)) {
                    throw "Generated README differs from checked-in bytes: [$file]."
                }
                $null = $vaultDrift.Add($file)
                $vaultExceptions++
            }
        }
        if (@($expected | Where-Object { -not $readmeSet.Contains($_) }).Count -ne 0) {
            throw "Bicep documentation omitted generated README(s) under [$scope]."
        }
        $issuePaths = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($issue in $result.Issues) {
            $file = ConvertTo-AvmReadmeRepoPath -Scope $scope -RelativePath $issue.File
            if ($issue.Severity -cne 'error' -or -not $issuePaths.Add($file) -or
                -not (($issue.Code -ceq 'avm.bicep.docs-no-source' -and $noSource.Contains($file)) -or
                    ($issue.Code -ceq 'avm.bicep.docs-stale' -and $vaultDrift.Contains($file)))) {
                throw "Bicep README validation failed for [$file]: [$($issue.Code)] $($issue.Message)"
            }
        }
        if ($issuePaths.Count -ne ($noSource.Count + $vaultDrift.Count) -or
            $result.Status -cne $(if ($issuePaths.Count -gt 0) { 'fail' } else { 'pass' })) {
            throw "Bicep documentation issue/status mismatch for [$scope]."
        }
        $processed += $result.FilesProcessed
    }
    if ($readmeSet.Count -ne $selection.SourceReadmes.Count -or $processed -ne $selection.SourceReadmes.Count) {
        throw "README coverage mismatch: selected=$($selection.SourceReadmes.Count), processed=$processed."
    }
    if ($compiledDrift.Count -gt 0) {
        throw "Compiled JSON drifted from the Bicep source; commit the corrected main.json before validating READMEs: $($compiledDrift -join ', ')."
    }
    [pscustomobject]@{
        Status          = 'pass'
        FilesSelected   = $selection.SourceReadmes.Count
        FilesProcessed  = $processed
        SourceLessCount = $inventory.SourceLessReadmes.Count
        VaultExceptions = $vaultExceptions
    }
}
