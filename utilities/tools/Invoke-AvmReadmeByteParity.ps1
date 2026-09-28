function Test-AvmReadmeApprovedHistoricalDrift {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $RelativePath,

        [Parameter(Mandatory)]
        [byte[]] $ExpectedBytes,

        [Parameter(Mandatory)]
        [byte[]] $ActualBytes,

        [Parameter(Mandatory)]
        [string] $ExpectedSha256
    )

    if ($RelativePath -cne 'avm/res/key-vault/vault/README.md' -or
        $ExpectedBytes.LongLength -ne 94325 -or $ActualBytes.LongLength -ne 94557 -or
        $ExpectedSha256 -cne '72befb145543d707ba849143eccb8d4b17efe2b09385156e6a5cc1b7060d8e01' -or
        [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($ExpectedBytes)).ToLowerInvariant() -cne
        $ExpectedSha256) {
        return $false
    }

    $utf8 = [Text.UTF8Encoding]::new($false, $true)
    $expected = $utf8.GetString($ExpectedBytes)
    if ($expected.Contains("`r")) {
        return $false
    }
    $lines = $expected.Split([char]"`n")
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
    foreach ($insertion in $insertions.GetEnumerator()) {
        $index = [int]$insertion.Key - 1
        if ($index -ge $lines.Length -or $lines[$index] -cne $insertion.Value.Anchor) {
            return $false
        }
    }

    $allowed = [Text.StringBuilder]::new($expected.Length + 232)
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

    $allowedBytes = $utf8.GetBytes($allowed.ToString())
    if ($allowedBytes.Length -ne $ActualBytes.Length) {
        return $false
    }
    for ($index = 0; $index -lt $allowedBytes.Length; $index++) {
        if ($allowedBytes[$index] -ne $ActualBytes[$index]) {
            return $false
        }
    }
    return $true
}

function Test-AvmReadmeApprovedCanonicalHeadingDrift {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string] $RelativePath,

        [Parameter(Mandatory)]
        [byte[]] $ExpectedBytes,

        [Parameter(Mandatory)]
        [byte[]] $ActualBytes,

        [Parameter(Mandatory)]
        [string] $ExpectedSha256,

        [Parameter(Mandatory)]
        [string] $MetadataFilePath
    )

    # Remove these interim allowances when the corrected READMEs and baseline are merged.
    $allowances = [Collections.Generic.Dictionary[string, object]]::new([StringComparer]::Ordinal)
    $allowances.Add('avm/res/db-for-my-sql/flexible-server/advanced-threat-protection/README.md', @{
            ExpectedLength = 3394
            ExpectedSha256 = 'd2de74734da0334b1fa458aa45bf9bd96be50bc286df72e564f3ee38cf7b53fc'
            OldHeading = '# DBforMySQL Flexible Server Advanced Threat Protection `[Microsoft.DBforMySQL/flexibleServers]`'
            NewHeading = '# DBforMySQL Flexible Server Advanced Threat Protection `[Microsoft.DBforMySQL/flexibleServers/advancedThreatProtectionSettings]`'
            CanonicalType = 'Microsoft.DBforMySQL/flexibleServers/advancedThreatProtectionSettings'
        })
    $allowances.Add('avm/res/dev-test-lab/lab/secret/README.md', @{
            ExpectedLength = 4500
            ExpectedSha256 = '1102eb1ab6fc6330bd0e1cc4cac05c251ceaab3cb453852d1d07621b998230c2'
            OldHeading = '# DevTest Lab Secrets `[Microsoft.DevTestLab/labs]`'
            NewHeading = '# DevTest Lab Secrets `[Microsoft.DevTestLab/labs/secrets]`'
            CanonicalType = 'Microsoft.DevTestLab/labs/secrets'
        })
    $allowances.Add('avm/res/devices/iot-hub/consumergroup/README.md', @{
            ExpectedLength = 2855
            ExpectedSha256 = '128b8671261d05df3c33a4bcb03cc3f1a6aecb5e36580990cc81754fc7ce8229'
            OldHeading = '# IoT Hub Consumer Groups `[Microsoft.Devices/IotHubs]`'
            NewHeading = '# IoT Hub Consumer Groups `[Microsoft.Devices/IotHubs/eventHubEndpoints/ConsumerGroups]`'
            CanonicalType = 'Microsoft.Devices/IotHubs/eventHubEndpoints/ConsumerGroups'
        })
    $allowances.Add('avm/res/storage/storage-account/object-replication-policy/policy/README.md', @{
            ExpectedLength = 6078
            ExpectedSha256 = '2c28aa446b24bd6b0ef3dc81e3fceb0ddb07178d9c2ccdea92426bb9cf5ec20f'
            OldHeading = '# Storage Account Object Replication Policy `[Microsoft.Storage/storageaccount/objectreplicationpolicy/policy]`'
            NewHeading = '# Storage Account Object Replication Policy `[Microsoft.Storage/storageAccounts/objectReplicationPolicies]`'
            CanonicalType = 'Microsoft.Storage/storageAccounts/objectReplicationPolicies'
        })
    if (-not $allowances.ContainsKey($RelativePath)) {
        return $false
    }
    $approval = $allowances[$RelativePath]
    if ($ExpectedBytes.LongLength -ne $approval.ExpectedLength -or
        $ExpectedSha256 -cne $approval.ExpectedSha256 -or
        [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($ExpectedBytes)).ToLowerInvariant() -cne
        $approval.ExpectedSha256) {
        return $false
    }

    $utf8 = [Text.UTF8Encoding]::new($false, $true)
    $oldHeading = $utf8.GetBytes($approval.OldHeading + "`n")
    $newHeading = $utf8.GetBytes($approval.NewHeading + "`n")
    if ($ExpectedBytes.LongLength -le $oldHeading.Length -or
        $ActualBytes.LongLength -ne $ExpectedBytes.LongLength + $newHeading.Length - $oldHeading.Length) {
        return $false
    }
    for ($index = 0; $index -lt $oldHeading.Length; $index++) {
        if ($ExpectedBytes[$index] -ne $oldHeading[$index]) {
            return $false
        }
    }
    for ($index = 0; $index -lt $newHeading.Length; $index++) {
        if ($ActualBytes[$index] -ne $newHeading[$index]) {
            return $false
        }
    }
    $shift = $newHeading.Length - $oldHeading.Length
    for ($index = $oldHeading.Length; $index -lt $ExpectedBytes.Length; $index++) {
        if ($ExpectedBytes[$index] -ne $ActualBytes[$index + $shift]) {
            return $false
        }
    }

    $metadata = Get-Content -LiteralPath $MetadataFilePath -Raw -Encoding utf8 -ErrorAction Stop |
        ConvertFrom-Json -AsHashtable -Depth 5 -ErrorAction Stop
    return $metadata.canonicalType -ceq $approval.CanonicalType
}

<#
.SYNOPSIS
Checks the 577 tracked AVM README files against independently rendered UTF-8 bytes.
.PARAMETER AuthoringModulePath
Path to an existing Avm.Authoring.psd1 from the tools checkout; this script does not install it.
.EXAMPLE
. .\utilities\tools\Invoke-AvmReadmeByteParity.ps1
Invoke-AvmReadmeByteParity -SourceRepositoryPath . `
    -BaselinePath .\utilities\tools\avm-readme-byte-baseline.json `
    -AuthoringModulePath $authoringManifest `
    -WorkingRepositoryPath (Join-Path $env:TEMP 'avm-readme-parity-work') `
    -ReportDirectory (Join-Path $env:TEMP 'avm-readme-parity-report')
#>
function Invoke-AvmReadmeByteParity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $SourceRepositoryPath,

        [Parameter(Mandatory)]
        [string] $BaselinePath,

        [Parameter(Mandatory)]
        [string] $AuthoringModulePath,

        [Parameter(Mandatory)]
        [string] $WorkingRepositoryPath,

        [Parameter(Mandatory)]
        [string] $ReportDirectory,

        [switch] $KeepWorkingRepository
    )

    Set-StrictMode -Version 3.0
    $ErrorActionPreference = 'Stop'

    function Get-AvmReadmeParityHash {
        param([AllowEmptyCollection()][byte[]] $Bytes)
        return [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($Bytes)).ToLowerInvariant()
    }

    function Get-AvmReadmeParityRelativePath {
        param([string] $Root, [string] $Path)
        $absolute = if ([IO.Path]::IsPathRooted($Path)) {
            [IO.Path]::GetFullPath($Path)
        } else {
            [IO.Path]::GetFullPath((Join-Path $Root $Path))
        }
        $relative = [IO.Path]::GetRelativePath($Root, $absolute).Replace('\', '/')
        if ($relative -eq '..' -or $relative.StartsWith('../', [StringComparison]::Ordinal)) {
            throw "Renderer returned a path outside the disposable checkout: $Path"
        }
        return $relative
    }

    $source = [IO.Path]::TrimEndingDirectorySeparator(
        (Resolve-Path -LiteralPath $SourceRepositoryPath -ErrorAction Stop).ProviderPath)
    $moduleManifest = (Resolve-Path -LiteralPath $AuthoringModulePath -ErrorAction Stop).ProviderPath
    $templateSource = Join-Path (Split-Path $moduleManifest -Parent) 'Resources\bicep\avm-readme-v1.scriban'
    $work = [IO.Path]::TrimEndingDirectorySeparator([IO.Path]::GetFullPath($WorkingRepositoryPath))
    $report = [IO.Path]::TrimEndingDirectorySeparator([IO.Path]::GetFullPath($ReportDirectory))
    $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
    $separator = [string][IO.Path]::DirectorySeparatorChar
    if (-not $work.StartsWith($tempRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw "The disposable checkout must be inside the operating system temporary directory: $work"
    }
    foreach ($destination in @($work, $report)) {
        if ($destination.Equals($source, [StringComparison]::OrdinalIgnoreCase) -or
            $destination.StartsWith("$source$separator", [StringComparison]::OrdinalIgnoreCase)) {
            throw "The disposable checkout and reports must be outside the source repository: $destination"
        }
    }
    if ($work.Equals($report, [StringComparison]::OrdinalIgnoreCase) -or
        $work.StartsWith("$report$separator", [StringComparison]::OrdinalIgnoreCase) -or
        $report.StartsWith("$work$separator", [StringComparison]::OrdinalIgnoreCase)) {
        throw 'The report directory and disposable checkout must be separate.'
    }
    if (Test-Path -LiteralPath $work) {
        throw "The disposable checkout path must not already exist: $work"
    }
    if (Test-Path -LiteralPath $report) {
        throw "The report directory must not already exist: $report"
    }
    if (-not (Test-Path -LiteralPath $templateSource -PathType Leaf)) {
        throw "The packaged AVM Scriban template is missing: $templateSource"
    }

    $utf8 = [Text.UTF8Encoding]::new($false, $true)
    if ([IO.File]::ReadAllText($templateSource, $utf8) -match '(?i)custom\.fullReadme') {
        throw 'The echo-of-existing-README template is not independent evidence.'
    }
    $templateHash = (Get-FileHash -LiteralPath $templateSource -Algorithm SHA256).Hash.ToLowerInvariant()

    $baseline = Get-Content -LiteralPath $BaselinePath -Raw -Encoding utf8 |
        ConvertFrom-Json -Depth 5 -ErrorAction Stop
    $commit = @(git -C $source rev-parse HEAD)[0]
    if ($LASTEXITCODE -ne 0 -or $baseline.schemaVersion -ne 1 -or
        $baseline.gitCommit -cnotmatch '^[0-9a-f]{40}$' -or
        $commit -cnotmatch '^[0-9a-f]{40}$') {
        throw 'The baseline must name a valid pinned commit and schema version.'
    }
    $null = git -C $source merge-base --is-ancestor $baseline.gitCommit $commit 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "The source HEAD must descend from the baseline commit $($baseline.gitCommit)."
    }
    $tracked = @(git -C $source ls-files -- 'avm/**/README.md' |
            Where-Object { $_ -cmatch '^avm/(res|ptn|utl)/.+/README\.md$' })
    if ($LASTEXITCODE -ne 0 -or $tracked.Count -ne 577 -or
        $baseline.count -ne 577 -or @($baseline.files).Count -ne 577) {
        throw "Expected exactly 577 tracked module READMEs at baseline HEAD; found $($tracked.Count)."
    }
    $untracked = @(git -C $source ls-files --others --exclude-standard -- 'avm/**/README.md')
    if ($LASTEXITCODE -ne 0 -or $untracked.Count -gt 0) {
        throw "Untracked AVM READMEs are not accounted for: $($untracked -join ', ')"
    }
    $modified = @(git -C $source diff --name-only HEAD -- 'avm/**/README.md')
    if ($LASTEXITCODE -ne 0 -or $modified.Count -gt 0) {
        throw "Tracked AVM READMEs differ from baseline HEAD: $($modified -join ', ')"
    }
    $nestedConfigs = @(git -C $source ls-files -- 'avm/**/bicepconfig.json')
    if ($LASTEXITCODE -ne 0 -or $nestedConfigs.Count -gt 0) {
        throw "Nested Bicep configurations would override the shared template: $($nestedConfigs -join ', ')"
    }

    $trackedSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($path in $tracked) {
        $null = $trackedSet.Add($path)
    }
    $supportingSet = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($path in @(
            'avm/ptn/aca-lza/hosting-environment/modules/container-apps-environment/README.md',
            'avm/ptn/aca-lza/hosting-environment/modules/spoke/README.md',
            'avm/ptn/aca-lza/hosting-environment/modules/supporting-services/README.md'
        )) {
        $null = $supportingSet.Add($path)
    }
    $expectedBytes = @{}
    $sourcePaths = @{}
    $sourceModules = [Collections.Generic.List[object]]::new()
    $supportingFiles = [Collections.Generic.List[object]]::new()
    $notesModules = [Collections.Generic.List[object]]::new()
    $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($file in $baseline.files) {
        $path = [string]$file.relativePath
        if (-not $seen.Add($path) -or -not $trackedSet.Contains($path)) {
            throw "Duplicate or untracked README in the baseline: $path"
        }
        if ($file.PSObject.Properties.Name -contains 'absolutePath') {
            throw "The baseline must contain only repository-relative README paths: $path"
        }
        $absolute = [IO.Path]::GetFullPath((Join-Path $source $path.Replace('/', $separator)))
        $bytes = [IO.File]::ReadAllBytes($absolute)
        if ($bytes.LongLength -ne [long]$file.length -or
            (Get-AvmReadmeParityHash -Bytes $bytes) -cne $file.sha256) {
            throw "README bytes differ from the immutable baseline: $path"
        }
        $expectedBytes[$path] = $bytes
        $sourcePaths[$path] = $absolute
        $folder = Split-Path $absolute -Parent
        $hasSource = Test-Path -LiteralPath (Join-Path $folder 'main.bicep') -PathType Leaf
        $hasJson = Test-Path -LiteralPath (Join-Path $folder 'main.json') -PathType Leaf
        $hasMetadata = Test-Path -LiteralPath (Join-Path $folder 'metadata.json') -PathType Leaf
        if ($supportingSet.Contains($path) -and -not $hasSource -and -not $hasJson -and -not $hasMetadata) {
            $supportingFiles.Add($file)
        } elseif ($hasSource -and $hasJson -and -not $supportingSet.Contains($path)) {
            $sourceModules.Add($file)
            if ($utf8.GetString($bytes) -cmatch '(?m)^## Notes$') {
                $notesModules.Add($file)
            }
        } else {
            throw "Unaccounted README or incomplete module inputs: $path"
        }
    }
    if ($seen.Count -ne $trackedSet.Count -or $sourceModules.Count -ne 574 -or
        $supportingFiles.Count -ne 3 -or $notesModules.Count -ne 53) {
        throw "Baseline coverage changed: tracked=$($seen.Count), renderable=$($sourceModules.Count), supporting=$($supportingFiles.Count), Notes=$($notesModules.Count)."
    }

    $null = New-Item -ItemType Directory -Path $report -Force
    $wasAutoInstallSet = Test-Path Env:\AVM_NO_AUTO_INSTALL
    $oldAutoInstall = $env:AVM_NO_AUTO_INSTALL
    $env:AVM_NO_AUTO_INSTALL = '1'
    $createdWorktree = $false
    try {
        $null = New-Item -ItemType Directory -Path (Split-Path $work -Parent) -Force
        $checkoutOutput = @(git -C $source worktree add --detach $work $commit 2>&1)
        if ($LASTEXITCODE -ne 0) {
            throw "Cannot create isolated checkout: $($checkoutOutput -join '; ')"
        }
        $createdWorktree = $true
        $checkoutRoot = @(git -C $work rev-parse --show-toplevel)[0]
        $checkoutCommit = @(git -C $work rev-parse HEAD)[0]
        if ($LASTEXITCODE -ne 0 -or
            -not [IO.Path]::GetFullPath($checkoutRoot).Equals($work, [StringComparison]::OrdinalIgnoreCase) -or
            $checkoutCommit -cne $commit -or
            ((Get-Item -LiteralPath $work -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "The disposable checkout does not resolve to the pinned repository HEAD: $work"
        }
        $workAvmRoot = (Join-Path $work 'avm') + $separator

        $configPath = Join-Path $work 'bicepconfig.json'
        $config = [IO.File]::ReadAllText($configPath, $utf8) | ConvertFrom-Json -AsHashtable
        if ($config.Keys -contains 'documentation') {
            $relativeTemplatePath = [string]$config.documentation.template.file
            if ([string]::IsNullOrWhiteSpace($relativeTemplatePath) -or
                [IO.Path]::IsPathRooted($relativeTemplatePath)) {
                throw 'The tracked documentation template must use a relative path.'
            }
            $configuredTemplate = [IO.Path]::GetFullPath(
                (Join-Path $work $relativeTemplatePath.Replace('/', $separator)))
            if (-not $configuredTemplate.StartsWith("$work$separator", [StringComparison]::OrdinalIgnoreCase) -or
                -not (Test-Path -LiteralPath $configuredTemplate -PathType Leaf) -or
                ((Get-Item -LiteralPath $configuredTemplate -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
                throw "The tracked documentation template must be a regular file inside the disposable checkout: $configuredTemplate"
            }
        } else {
            $templateFolder = Join-Path $work 'docs\templates'
            $configuredTemplate = Join-Path $templateFolder 'avm-readme-v1.scriban'
            if (Test-Path -LiteralPath $configuredTemplate) {
                throw "Refusing to overwrite a tracked template without documentation settings: $configuredTemplate"
            }
            $null = New-Item -ItemType Directory -Path $templateFolder -Force
            Copy-Item -LiteralPath $templateSource -Destination $configuredTemplate
            $config['documentation'] = @{
                template = @{
                    file        = 'docs/templates/avm-readme-v1.scriban'
                    includeRoot = 'docs/templates'
                }
                examples = @{
                    reassignments = @(
                        @{ from = @{ include = @('**/mg-scope.*/**') }; to = 'mg-scope' },
                        @{ from = @{ include = @('**/rg-scope.*/**') }; to = 'rg-scope' },
                        @{ from = @{ include = @('**/sub-scope.*/**') }; to = 'sub-scope' }
                    )
                }
            }
            [IO.File]::WriteAllText($configPath, (ConvertTo-Json -InputObject $config -Depth 30) + "`n", $utf8)
        }
        if ([IO.File]::ReadAllText($configuredTemplate, $utf8) -match '(?i)custom\.fullReadme') {
            throw 'The configured template must not echo an existing README.'
        }
        $configuredTemplateHash = (Get-FileHash -LiteralPath $configuredTemplate -Algorithm SHA256).Hash.ToLowerInvariant()

        Import-Module -Name $moduleManifest -Force -ErrorAction Stop
        $preparationErrors = @{}
        foreach ($file in $notesModules) {
            $moduleRelative = $file.relativePath.Substring(0, $file.relativePath.Length - '/README.md'.Length)
            $modulePath = [IO.Path]::GetFullPath((Join-Path $work $moduleRelative.Replace('/', $separator)))
            if (-not $modulePath.StartsWith($workAvmRoot, [StringComparison]::OrdinalIgnoreCase)) {
                throw "Notes migration resolved outside the disposable AVM checkout: $modulePath"
            }
            $sidecarPath = Join-Path $modulePath 'README.notes.md'
            if (Test-Path -LiteralPath $sidecarPath) {
                if (-not (Test-Path -LiteralPath $sidecarPath -PathType Leaf) -or
                    ((Get-Item -LiteralPath $sidecarPath -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
                    throw "The tracked Notes sidecar is not a regular file: $sidecarPath"
                }
                continue
            }
            try {
                $notesResult = Export-AvmReadmeNote -Path $modulePath -SkipModuleVersionCheck -Confirm:$false -ErrorAction Stop
                if ($notesResult.Status -cne 'pass' -or
                    -not (Test-Path -LiteralPath $sidecarPath -PathType Leaf)) {
                    throw "Notes export did not create a sidecar for $moduleRelative."
                }
            } catch {
                $preparationErrors[$file.relativePath] = "Notes export failed: $($_.Exception.Message)"
            }
        }
        if ($preparationErrors.Count -gt 0) {
            $preparationErrors.GetEnumerator() | ForEach-Object {
                [pscustomobject]@{ Path = $_.Key; Error = $_.Value }
            } | Export-Csv -LiteralPath (Join-Path $report 'preparation-errors.csv') -NoTypeInformation
            throw "Notes sidecar extraction failed for $($preparationErrors.Count) module(s); see $report\preparation-errors.csv."
        }

        foreach ($file in $sourceModules) {
            $readmePath = [IO.Path]::GetFullPath((Join-Path $work $file.relativePath.Replace('/', $separator)))
            if (-not $readmePath.StartsWith($workAvmRoot, [StringComparison]::OrdinalIgnoreCase) -or
                [IO.Path]::GetFileName($readmePath) -cne 'README.md') {
                throw "README deletion resolved outside the disposable AVM checkout: $readmePath"
            }
            if (Test-Path -LiteralPath $readmePath -PathType Leaf) {
                if ((Get-Item -LiteralPath $readmePath -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) {
                    throw "README deletion refuses a linked file: $readmePath"
                }
                Remove-Item -LiteralPath $readmePath -Force -ErrorAction Stop
                if (Test-Path -LiteralPath $readmePath) {
                    throw "The disposable README was not removed: $readmePath"
                }
            } else {
                $preparationErrors[$file.relativePath] = "README missing before the renderer ran: $readmePath"
            }
        }

        $renderError = $null
        $renderResult = $null
        try {
            $renderResults = @(Invoke-AvmDocs -Path $work -Ecosystem bicep -CheckDrift `
                    -IncludeRenderedContent -SkipModuleVersionCheck -AllowPathFallback -ErrorAction Stop)
            if ($renderResults.Count -ne 1) {
                throw "Expected one repository-level renderer result; got $($renderResults.Count)."
            }
            $renderResult = $renderResults[0]
        } catch {
            $renderError = $_.Exception.ToString()
        }

        $rendered = @{}
        $invalidOutputs = [Collections.Generic.List[string]]::new()
        if ($null -ne $renderResult) {
            foreach ($item in @($renderResult.GeneratedReadmes)) {
                try {
                    $path = Get-AvmReadmeParityRelativePath -Root $work -Path ([string]$item.Path)
                    if (-not $trackedSet.Contains($path) -or $supportingSet.Contains($path) -or
                        $rendered.ContainsKey($path) -or $item.Content -isnot [string]) {
                        throw "Unexpected, duplicate, or empty renderer entry: $path"
                    }
                    $bytes = $utf8.GetBytes($item.Content)
                    $rendered[$path] = $bytes
                    $generatedPath = Join-Path (Join-Path $report 'generated') $path.Replace('/', $separator)
                    $null = New-Item -ItemType Directory -Path (Split-Path $generatedPath -Parent) -Force
                    [IO.File]::WriteAllBytes($generatedPath, $bytes)
                } catch {
                    $invalidOutputs.Add($_.Exception.Message)
                }
            }
        }

        $notRenderedPaths = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        if ($null -ne $renderResult) {
            foreach ($item in @($renderResult.NotRendered)) {
                $path = if ($item -is [string]) { $item } else { $item.Path }
                $null = $notRenderedPaths.Add(
                    (Get-AvmReadmeParityRelativePath -Root $work -Path ([string]$path)))
            }
        }
        $unexpectedIssues = [Collections.Generic.List[object]]::new()
        if ($null -ne $renderResult) {
            foreach ($issue in @($renderResult.Issues)) {
                $issuePath = [string]$issue.File
                if (($issue.Code -ceq 'avm.bicep.docs-missing' -and $trackedSet.Contains($issuePath) -and
                        -not $supportingSet.Contains($issuePath)) -or
                    ($supportingSet.Contains($issuePath) -and $issue.Code -ceq 'avm.bicep.docs-no-source')) {
                    continue
                }
                $unexpectedIssues.Add($issue)
            }
        }

        $comparison = [Collections.Generic.List[object]]::new()
        foreach ($file in $baseline.files) {
            $path = [string]$file.relativePath
            $kind = if ($supportingSet.Contains($path)) { 'Supporting' } else { 'Generated' }
            $actual = $null
            $failure = $null
            if ($kind -eq 'Supporting') {
                $workingPath = Join-Path $work $path.Replace('/', $separator)
                if (Test-Path -LiteralPath $workingPath -PathType Leaf) {
                    $actual = [IO.File]::ReadAllBytes($workingPath)
                } else {
                    $failure = 'Supporting README missing from disposable checkout.'
                }
            } elseif ($rendered.ContainsKey($path)) {
                $actual = $rendered[$path]
            } else {
                $failure = 'No independent renderer content was returned.'
            }
            if ($preparationErrors.ContainsKey($path)) {
                $failure = "$failure $($preparationErrors[$path])".Trim()
            }
            if ($kind -eq 'Generated' -and
                (Test-Path -LiteralPath (Join-Path $work $path.Replace('/', $separator)))) {
                $failure = "$failure The check-drift renderer wrote a README to the disposable checkout.".Trim()
            }

            $offset = $null
            $expectedByte = $null
            $actualByte = $null
            $actualHash = $null
            $actualLength = $null
            if ($null -ne $actual) {
                $actualHash = Get-AvmReadmeParityHash -Bytes $actual
                $actualLength = $actual.LongLength
                $expected = $expectedBytes[$path]
                $limit = [Math]::Min($expected.Length, $actual.Length)
                for ($index = 0; $index -lt $limit; $index++) {
                    if ($expected[$index] -ne $actual[$index]) {
                        $offset = $index
                        break
                    }
                }
                if ($null -eq $offset -and $expected.Length -ne $actual.Length) {
                    $offset = $limit
                }
                if ($null -ne $offset) {
                    $expectedByte = if ($offset -lt $expected.Length) { '{0:x2}' -f $expected[$offset] } else { 'EOF' }
                    $actualByte = if ($offset -lt $actual.Length) { '{0:x2}' -f $actual[$offset] } else { 'EOF' }
                }
            }
            $status = if ($failure) {
                'failure'
            } elseif ($null -eq $actual) {
                'missing'
            } elseif ($null -ne $offset -or $actualHash -cne $file.sha256) {
                if (Test-AvmReadmeApprovedHistoricalDrift -RelativePath $path `
                        -ExpectedBytes $expected -ActualBytes $actual -ExpectedSha256 $file.sha256) {
                    'approved_historical_drift'
                } elseif (Test-AvmReadmeApprovedCanonicalHeadingDrift -RelativePath $path `
                        -ExpectedBytes $expected -ActualBytes $actual -ExpectedSha256 $file.sha256 `
                        -MetadataFilePath (Join-Path (Split-Path (Join-Path $work $path.Replace('/', $separator)) -Parent) 'metadata.json')) {
                    'approved_canonical_heading_drift'
                } else {
                    'mismatch'
                }
            } elseif ($kind -eq 'Supporting') {
                'preserved'
            } else {
                'match'
            }
            $comparison.Add([pscustomobject][ordered]@{
                    Path              = $path
                    SourcePath        = $sourcePaths[$path]
                    Kind              = $kind
                    Status            = $status
                    ExpectedBytes     = $file.length
                    ActualBytes       = $actualLength
                    FirstDiffByte     = $offset
                    ExpectedByteHex   = $expectedByte
                    ActualByteHex     = $actualByte
                    ExpectedSha256    = $file.sha256
                    ActualSha256      = $actualHash
                    GeneratedPath     = if ($kind -eq 'Generated' -and $null -ne $actual) {
                        Join-Path (Join-Path $report 'generated') $path.Replace('/', $separator)
                    } else { $null }
                    Error             = $failure
                    ApprovalReason    = if ($status -eq 'approved_historical_drift') {
                        'Checked-in Vault JSON usage examples omit eight comments emitted by the current legacy generator; this is historical drift, not a new docs regression.'
                    } elseif ($status -eq 'approved_canonical_heading_drift') {
                        'Only the first-line resource type title changes to the module metadata canonicalType; remove this allowance after the README and baseline are updated.'
                    } else { $null }
                })
        }

        $rows = @($comparison.ToArray() | Sort-Object Path)
        $approvedVault = @($rows | Where-Object Status -eq 'approved_historical_drift')
        $approvedHeadings = @($rows | Where-Object Status -eq 'approved_canonical_heading_drift')
        $approved = @($approvedVault) + @($approvedHeadings)
        $failures = @($rows | Where-Object {
                $_.Status -notin @('match', 'preserved', 'approved_historical_drift', 'approved_canonical_heading_drift')
            })
        $unexpectedNotRendered = @($notRenderedPaths | Where-Object { -not $supportingSet.Contains($_) })
        $missingNotRendered = @($supportingSet | Where-Object { -not $notRenderedPaths.Contains($_) })
        $selected = if ($null -ne $renderResult) { $renderResult.FilesSelected } else { 0 }
        $processed = if ($null -ne $renderResult) { $renderResult.FilesProcessed } else { 0 }
        $rendererStatus = if ($null -ne $renderResult) { $renderResult.Status } else { $null }
        $notesSidecars = @($notesModules | Where-Object {
                $moduleRelative = $_.relativePath.Substring(0, $_.relativePath.Length - '/README.md'.Length)
                Test-Path -LiteralPath (Join-Path (Join-Path $work $moduleRelative.Replace('/', $separator)) 'README.notes.md') -PathType Leaf
            }).Count
        $templateHashAfter = (Get-FileHash -LiteralPath $templateSource -Algorithm SHA256).Hash.ToLowerInvariant()
        $configuredTemplateHashAfter = (Get-FileHash -LiteralPath $configuredTemplate -Algorithm SHA256).Hash.ToLowerInvariant()
        $summary = [pscustomobject][ordered]@{
            SourceCommit          = $commit
            BaselineCommit        = $baseline.gitCommit
            BaselinePath          = (Resolve-Path -LiteralPath $BaselinePath).ProviderPath
            TemplateSha256        = $templateHash
            TemplateSha256After   = $templateHashAfter
            ConfiguredTemplateSha256 = $configuredTemplateHash
            ConfiguredTemplateSha256After = $configuredTemplateHashAfter
            AuthoringModulePath   = $moduleManifest
            WorkingRepositoryPath = $work
            TrackedReadmes        = $rows.Count
            RenderableReadmes     = $sourceModules.Count
            SupportingReadmes     = $supportingFiles.Count
            NotesSidecars         = $notesSidecars
            FilesSelected         = $selected
            FilesProcessed        = $processed
            RenderedContentCount  = $rendered.Count
            RendererStatus        = $rendererStatus
            ByteMatches           = @($rows | Where-Object Status -eq 'match').Count
            SupportingPreserved   = @($rows | Where-Object Status -eq 'preserved').Count
            FileFailures          = $failures.Count
            ExactBytes            = @($rows | Where-Object { $_.Status -in @('match', 'preserved') }).Count
            ApprovedException     = $approved.Count
            ApprovedVaultException = $approvedVault.Count
            ApprovedCanonicalHeadingExceptions = $approvedHeadings.Count
            Failures              = $failures.Count
            ApprovedExceptionDetails = @($approvedVault | ForEach-Object {
                    [pscustomobject]@{
                        Path                        = $_.Path
                        Reason                      = $_.ApprovalReason
                        AllowedInsertedCommentLines = 8
                        ExpectedBytes               = $_.ExpectedBytes
                        ActualBytes                 = $_.ActualBytes
                        ExpectedSha256              = $_.ExpectedSha256
                        ActualSha256                = $_.ActualSha256
                    }
                })
            ApprovedCanonicalHeadingDetails = @($approvedHeadings | ForEach-Object {
                    [pscustomobject]@{
                        Path           = $_.Path
                        Reason         = $_.ApprovalReason
                        ExpectedBytes  = $_.ExpectedBytes
                        ActualBytes    = $_.ActualBytes
                        ExpectedSha256 = $_.ExpectedSha256
                        ActualSha256   = $_.ActualSha256
                    }
                })
            UnexpectedOutputs     = $invalidOutputs.ToArray()
            UnexpectedIssues      = $unexpectedIssues.ToArray()
            UnexpectedNotRendered = $unexpectedNotRendered
            MissingNotRendered    = $missingNotRendered
            RendererError         = $renderError
            Result               = 'fail'
        }
        $pass = $rows.Count -eq 577 -and $selected -eq 574 -and $processed -eq 574 -and
            $rendered.Count -eq 574 -and $failures.Count -eq 0 -and
            @($rows | Where-Object Status -eq 'preserved').Count -eq 3 -and
            $notRenderedPaths.Count -eq 3 -and $unexpectedNotRendered.Count -eq 0 -and
            $missingNotRendered.Count -eq 0 -and $unexpectedIssues.Count -eq 0 -and
            $invalidOutputs.Count -eq 0 -and $preparationErrors.Count -eq 0 -and
            $notesSidecars -eq 53 -and $templateHashAfter -ceq $templateHash -and
            $configuredTemplateHashAfter -ceq $configuredTemplateHash -and
            $rendererStatus -in @('pass', 'fail') -and
            $null -eq $renderError -and
            (git -C $source rev-parse HEAD) -ceq $commit
        if ($pass) {
            $summary.Result = if ($approved.Count -gt 0) { 'pass_with_approved_exception' } else { 'pass' }
        }
        $rows | Export-Csv -LiteralPath (Join-Path $report 'comparison.csv') -NoTypeInformation
        $failures | Export-Csv -LiteralPath (Join-Path $report 'failures.csv') -NoTypeInformation
        $summary | ConvertTo-Json -Depth 8 |
            Set-Content -LiteralPath (Join-Path $report 'summary.json') -Encoding utf8
        if (-not $pass) {
            throw "AVM README byte-parity gate failed; see $report\summary.json and $report\failures.csv."
        }
        return $summary
    } finally {
        if ($wasAutoInstallSet) {
            $env:AVM_NO_AUTO_INSTALL = $oldAutoInstall
        } else {
            Remove-Item Env:\AVM_NO_AUTO_INSTALL -ErrorAction SilentlyContinue
        }
        if ($createdWorktree -and -not $KeepWorkingRepository) {
            if (-not (Test-Path -LiteralPath $work -PathType Container) -or
                ((Get-Item -LiteralPath $work -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) {
                throw "Refusing to remove an absent or linked disposable checkout: $work"
            }
            $cleanupRoot = @(git -C $work rev-parse --show-toplevel)[0]
            $cleanupCommit = @(git -C $work rev-parse HEAD)[0]
            if ($LASTEXITCODE -ne 0 -or
                -not [IO.Path]::GetFullPath($cleanupRoot).Equals($work, [StringComparison]::OrdinalIgnoreCase) -or
                $cleanupCommit -cne $commit) {
                throw "Refusing to remove a checkout that no longer matches the pinned disposable worktree: $work"
            }
            $cleanupOutput = @(git -C $source worktree remove --force $work 2>&1)
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to remove disposable checkout ${work}: $($cleanupOutput -join '; ')"
            }
        }
    }
}
