#requires -Version 7.3

function Get-NamingJsonBytes {
    param([Parameter(Mandatory)][AllowNull()][AllowEmptyCollection()] $Value)

    return ,([Text.UTF8Encoding]::new($false).GetBytes((ConvertTo-Json -InputObject $Value -Depth 100 -Compress) + "`n"))
}

function Get-NamingSha256 {
    param([Parameter(Mandatory)][byte[]] $Bytes)

    return [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($Bytes)).ToLowerInvariant()
}

function Test-NamingJsonKeys {
    param([Parameter(Mandatory)][string] $Json)

    $document = [Text.Json.JsonDocument]::Parse($Json)
    try {
        $pending = [Collections.Generic.Stack[Text.Json.JsonElement]]::new()
        $pending.Push($document.RootElement)
        while ($pending.Count -gt 0) {
            $element = $pending.Pop()
            if ($element.ValueKind -eq [Text.Json.JsonValueKind]::Object) {
                $keys = [Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
                foreach ($property in $element.EnumerateObject()) {
                    if (-not $keys.Add($property.Name)) { throw "Duplicate or case-colliding JSON key [$($property.Name)] cannot be represented losslessly in Bicep." }
                    $pending.Push($property.Value)
                }
            } elseif ($element.ValueKind -eq [Text.Json.JsonValueKind]::Array) {
                foreach ($item in $element.EnumerateArray()) { $pending.Push($item) }
            }
        }
    } finally {
        $document.Dispose()
    }
}

function Get-NamingRegexDescriptor {
    param([Parameter(Mandatory)][string] $Pattern)

    $class = '(\[(?:\\.|[^\]\\])+\])'
    $descriptor = $null
    if ($Pattern -cmatch ('^\^\(\?:' + $class + '\|' + $class + $class + '\*' + $class + '\)\$$')) {
        $descriptor = [ordered]@{ single = $Matches[1]; first = $Matches[2]; middle = $Matches[3]; last = $Matches[4]; minimum = 2; maximum = $null }
    } elseif ($Pattern -cmatch ('^\^' + $class + $class + '([*+])' + $class + '\$$')) {
        $descriptor = [ordered]@{ single = $null; first = $Matches[1]; middle = $Matches[2]; last = $Matches[4]; minimum = ($Matches[3] -ceq '+' ? 3 : 2); maximum = $null }
    } elseif ($Pattern -cmatch ('^\^' + $class + $class + '\*\$$')) {
        $descriptor = [ordered]@{ single = $Matches[1]; first = $Matches[1]; middle = $Matches[2]; last = $Matches[2]; minimum = 2; maximum = $null }
    } elseif ($Pattern -cmatch ('^\^' + $class + '([*+])\$$')) {
        $descriptor = [ordered]@{ single = $Matches[1]; first = $Matches[1]; middle = $Matches[1]; last = $Matches[1]; minimum = ($Matches[2] -ceq '*' ? 0 : 1); maximum = $null }
    } elseif ($Pattern -cmatch ('^\^' + $class + '\{(\d+),(\d+)\}\$$')) {
        $descriptor = [ordered]@{ single = $null; first = $Matches[1]; middle = $Matches[1]; last = $Matches[1]; minimum = [int] $Matches[2]; maximum = [int] $Matches[3] }
        if ($descriptor.minimum -le 1 -and $descriptor.maximum -ge 1) { $descriptor.single = $descriptor.first }
    } elseif ($Pattern -ceq '^[a-zA-Z0-9][a-zA-Z0-9_-]{${min_length - 1},${max_length - 1}}$') {
        $descriptor = [ordered]@{ single = '[a-zA-Z0-9]'; first = '[a-zA-Z0-9]'; middle = '[a-zA-Z0-9_-]'; last = '[a-zA-Z0-9_-]'; minimum = 1; maximum = $null }
    } elseif ($Pattern -cmatch '^\^([a-zA-Z0-9]+)\$$') {
        return [ordered]@{ kind = 'literal'; value = $Matches[1] }
    } elseif ($Pattern -ceq '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$') {
        return [ordered]@{ kind = 'uuid' }
    }
    if ($null -eq $descriptor) { return $null }

    foreach ($field in @('single', 'first', 'middle', 'last')) {
        $characterClass = $descriptor[$field]
        if ($null -eq $characterClass) { continue }
        if ($characterClass -cmatch '^\[\^' -or $characterClass -cmatch '\\[^\\.\-()[\]]' -or $characterClass -match '[^\x20-\x7e]') {
            return $null
        }
        $regex = [regex]::new("\A$characterClass\z", [Text.RegularExpressions.RegexOptions]::CultureInvariant, [timespan]::FromSeconds(1))
        $descriptor[$field] = -join (32..126 | ForEach-Object { [char] $_ } | Where-Object { $regex.IsMatch([string] $_) })
    }
    $descriptor['kind'] = 'characters'
    return $descriptor
}

function Merge-NamingCatalogResources {
    param([Parameter(Mandatory)][Collections.IDictionary[]] $Catalogs)

    $merged = [ordered]@{}
    foreach ($catalog in $Catalogs) {
        foreach ($entry in $catalog.GetEnumerator()) {
            if (-not $merged.Contains($entry.Key)) {
                $merged[$entry.Key] = [ordered]@{}
            } elseif ($entry.Key -cnotin @($merged.Keys)) {
                throw "Case-colliding catalog key [$($entry.Key)] cannot be merged losslessly."
            }
            foreach ($property in $entry.Value.GetEnumerator()) { $merged[$entry.Key][$property.Key] = $property.Value }
        }
    }
    return $merged
}

function Add-NamingJsonChunks {
    param(
        [Parameter(Mandatory)][Collections.IDictionary] $Artifacts,
        [Parameter(Mandatory)][string] $Stem,
        [Parameter(Mandatory)][AllowEmptyCollection()] $Items,
        [Parameter(Mandatory)][int] $ChunkSize
    )

    $isObject = $Items -is [Collections.IDictionary]
    $entries = $isObject ? @($Items.GetEnumerator()) : @(foreach ($item in $Items) { @{ Value = $item } })
    $chunk = $isObject ? [ordered]@{} : [Collections.Generic.List[object]]::new()
    $paths = [Collections.Generic.List[string]]::new()
    $chunkBytes = 3
    foreach ($entry in $entries) {
        $entryBytes = (Get-NamingJsonBytes $entry.Value).Length - 1
        if ($isObject) { $entryBytes += (Get-NamingJsonBytes ([string] $entry.Key)).Length }
        if ($entryBytes + 3 -gt $ChunkSize) { throw "Catalog index item in [$Stem] exceeds the chunk limit of $ChunkSize bytes." }
        if ($chunkBytes + ($chunk.Count -gt 0 ? 1 : 0) + $entryBytes -gt $ChunkSize) {
            $path = '{0}-{1:d4}.json' -f $Stem, $paths.Count
            $Artifacts[$path] = Get-NamingJsonBytes ($isObject ? $chunk : $chunk.ToArray())
            $paths.Add($path)
            $chunk = $isObject ? [ordered]@{} : [Collections.Generic.List[object]]::new()
            $chunkBytes = 3
        }
        $chunkBytes += ($chunk.Count -gt 0 ? 1 : 0) + $entryBytes
        if ($isObject) { $chunk[$entry.Key] = $entry.Value } else { $chunk.Add($entry.Value) }
    }
    $path = '{0}-{1:d4}.json' -f $Stem, $paths.Count
    $Artifacts[$path] = Get-NamingJsonBytes ($isObject ? $chunk : $chunk.ToArray())
    $paths.Add($path)
    return ,$paths.ToArray()
}

function Get-NamingCatalogChanges {
    param(
        [Parameter(Mandatory)][Collections.IDictionary] $Previous,
        [Parameter(Mandatory)][Collections.IDictionary] $Current
    )

    $nameProperties = @('resource_type', 'variant', 'slug', 'min_length', 'max_length', 'dashes', 'lowercase', 'name_kind', 'fixed_name', 'forbidden_suffixes')
    $validationProperties = @('min_length', 'max_length', 'regex', 'validation_complete', 'forbidden_prefixes', 'forbidden_suffixes', 'forbidden_sequences', 'reserved_names')
    $keys = [Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
    foreach ($key in @($Previous.Keys) + @($Current.Keys)) { $null = $keys.Add($key) }
    $changes = [Collections.Generic.List[object]]::new()
    foreach ($key in $keys) {
        $before = $Previous.Contains($key) ? $Previous[$key] : [ordered]@{}
        $after = $Current.Contains($key) ? $Current[$key] : [ordered]@{}
        $properties = [Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
        foreach ($property in @($before.Keys) + @($after.Keys)) { $null = $properties.Add($property) }
        $changed = @(
            foreach ($property in $properties) {
                if ($before.Contains($property) -ne $after.Contains($property) -or
                    (Get-NamingSha256 (Get-NamingJsonBytes $before[$property])) -cne (Get-NamingSha256 (Get-NamingJsonBytes $after[$property]))) {
                    $property
                }
            }
        )
        $kind = -not $Previous.Contains($key) ? 'added' : -not $Current.Contains($key) ? 'removed' : 'updated'
        if ($kind -ceq 'updated' -and $changed.Count -eq 0) { continue }
        $changes.Add([ordered]@{
                key = $key
                kind = $kind
                affectsNames = $kind -cne 'updated' -or @($changed | Where-Object { $_ -cin $nameProperties }).Count -gt 0
                affectsValidation = $kind -cne 'updated' -or @($changed | Where-Object { $_ -cin $validationProperties }).Count -gt 0
                properties = $changed
            })
    }
    return [ordered]@{
        addedCount = @($changes | Where-Object kind -CEQ 'added').Count
        removedCount = @($changes | Where-Object kind -CEQ 'removed').Count
        namingCount = @($changes | Where-Object affectsNames).Count
        validationCount = @($changes | Where-Object affectsValidation).Count
        metadataOnlyCount = @($changes | Where-Object { -not $_.affectsNames -and -not $_.affectsValidation }).Count
        entries = $changes.ToArray()
    }
}

function New-NamingCatalogArtifacts {
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary] $SourceFiles,
        [Parameter(Mandatory)][ValidatePattern('^[0-9a-f]{40}$')][string] $Revision,
        [ValidateRange(16384, 524288)][int] $ChunkSize = 262144
    )

    $artifacts = [ordered]@{}
    $sources = [ordered]@{}
    $catalogs = [ordered]@{}
    $chunkLists = [ordered]@{}
    $utf8 = [Text.UTF8Encoding]::new($false, $true)
    $expectedPaths = @('data/resource-name-rules.json', 'data/resource-name-rules.manual.json', 'schemas/naming-catalog.schema.json', 'schemas/naming-overrides.schema.json', 'LICENSE')
    if ($SourceFiles.Count -ne $expectedPaths.Count -or @($expectedPaths | Where-Object { -not $SourceFiles.Contains($_) }).Count -gt 0) {
        throw 'The upstream source file set does not match the supported catalog, schemas and license.'
    }
    foreach ($path in $expectedPaths | Where-Object { $_.EndsWith('.json') }) {
        Test-NamingJsonKeys -Json $utf8.GetString($SourceFiles[$path])
    }
    $overrideSchema = $utf8.GetString($SourceFiles['schemas/naming-overrides.schema.json'])
    $generatedSchema = $utf8.GetString($SourceFiles['schemas/naming-catalog.schema.json']) | ConvertFrom-Json -AsHashtable -Depth 100
    if ($generatedSchema.'$ref' -cne 'naming-overrides.schema.json') { throw 'The generated catalog schema has an unsupported reference; review the upstream schema change.' }
    $completeSchema = $overrideSchema | ConvertFrom-Json -AsHashtable -Depth 100
    $supportedProperties = @('resource_type', 'variant', 'slug', 'slug_source', 'legacy_slug', 'legacy_outputs', 'min_length', 'max_length', 'scope', 'regex', 'dashes', 'lowercase', 'name_kind', 'fixed_name', 'validation_complete', 'validation_notes', 'forbidden_prefixes', 'forbidden_suffixes', 'forbidden_sequences', 'reserved_names', 'source', 'override_reason', 'override_source')
    if (@($completeSchema.'$defs'.resource_entry.properties.Keys | Where-Object { $_ -cnotin $supportedProperties }).Count -gt 0 -or $generatedSchema.Contains('$defs')) {
        throw 'The upstream schema adds unsupported rule properties or definitions; review Bicep compatibility before updating.'
    }
    $generatedSchema.Remove('$ref')
    $completeSchema['allOf'] = @($completeSchema.allOf | Where-Object { $null -ne $_ }) + @($generatedSchema)
    foreach ($path in $expectedPaths) {
        $bytes = $SourceFiles[$path]
        $sources[$path] = [ordered]@{ sha256 = Get-NamingSha256 $bytes; bytes = $bytes.Length }
        if ($path -notin @('data/resource-name-rules.json', 'data/resource-name-rules.manual.json')) { continue }
        $schema = $path.EndsWith('.manual.json') ? $overrideSchema : ($completeSchema | ConvertTo-Json -Depth 100)
        if (-not (Test-Json -Json $utf8.GetString($bytes) -Schema $schema -ErrorAction Stop)) { throw "Catalog [$path] does not match its upstream schema." }
        $catalog = $utf8.GetString($bytes) | ConvertFrom-Json -AsHashtable -Depth 100 -ErrorAction Stop
        if ($catalog.schema_version -ne 2 -or $catalog.resources -isnot [System.Collections.IDictionary] -or $catalog.Contains('overrides')) {
            throw "Invalid version-2 catalog [$path]."
        }
        $catalogs[$path] = $catalog
        $stem = $path.EndsWith('.manual.json') ? 'manual' : 'generated'
        $chunkLists[$stem] = [Collections.Generic.List[string]]::new()
        $envelope = [ordered]@{}
        foreach ($key in $catalog.Keys) { $envelope[$key] = $key -ceq 'resources' ? [ordered]@{} : $catalog[$key] }
        if ((Get-NamingJsonBytes $envelope).Length -gt $ChunkSize) { throw "Catalog envelope [$path] exceeds the chunk limit of $ChunkSize bytes." }
        $chunkNumber = 0
        foreach ($key in $catalog.resources.Keys) {
            $envelope.resources[$key] = $catalog.resources[$key]
            if ((Get-NamingJsonBytes $envelope).Length -gt $ChunkSize) {
                $envelope.resources.Remove($key)
                if ($envelope.resources.Count -eq 0) { throw "Catalog entry [$key] exceeds the chunk limit of $ChunkSize bytes." }
                $chunkPath = '{0}-{1:d4}.json' -f $stem, $chunkNumber++
                $artifacts[$chunkPath] = Get-NamingJsonBytes $envelope
                $chunkLists[$stem].Add($chunkPath)
                $envelope.resources = [ordered]@{ $key = $catalog.resources[$key] }
                if ((Get-NamingJsonBytes $envelope).Length -gt $ChunkSize) { throw "Catalog entry [$key] exceeds the chunk limit of $ChunkSize bytes." }
            }
        }
        $chunkPath = '{0}-{1:d4}.json' -f $stem, $chunkNumber
        $artifacts[$chunkPath] = Get-NamingJsonBytes $envelope
        $chunkLists[$stem].Add($chunkPath)

        $recomposed = [ordered]@{}
        foreach ($key in $catalog.Keys) { $recomposed[$key] = $key -ceq 'resources' ? [ordered]@{} : $catalog[$key] }
        foreach ($chunkPath in $chunkLists[$stem]) {
            $chunk = $utf8.GetString($artifacts[$chunkPath]) | ConvertFrom-Json -AsHashtable -Depth 100
            $chunkEnvelope = [ordered]@{}
            foreach ($key in $chunk.Keys) { $chunkEnvelope[$key] = $key -ceq 'resources' ? [ordered]@{} : $chunk[$key] }
            $sourceEnvelope = [ordered]@{}
            foreach ($key in $catalog.Keys) { $sourceEnvelope[$key] = $key -ceq 'resources' ? [ordered]@{} : $catalog[$key] }
            if ((Get-NamingSha256 (Get-NamingJsonBytes $chunkEnvelope)) -cne (Get-NamingSha256 (Get-NamingJsonBytes $sourceEnvelope))) {
                throw "Catalog envelope changed in [$chunkPath]."
            }
            foreach ($key in $chunk.resources.Keys) {
                if ($recomposed.resources.Contains($key)) { throw "Duplicate chunk key [$key]." }
                $recomposed.resources[$key] = $chunk.resources[$key]
            }
        }
        if ((Get-NamingSha256 (Get-NamingJsonBytes $catalog)) -cne (Get-NamingSha256 (Get-NamingJsonBytes $recomposed))) {
            throw "Lossless chunk reconstruction failed for [$path]."
        }
        $sources[$path]['recomposedSha256'] = Get-NamingSha256 (Get-NamingJsonBytes $recomposed)
    }

    $merged = Merge-NamingCatalogResources -Catalogs @($catalogs['data/resource-name-rules.json'].resources, $catalogs['data/resource-name-rules.manual.json'].resources)
    $excludedProperties = @('source', 'override_reason', 'override_source', 'legacy_slug', 'legacy_outputs')
    $runtimeProperties = @($supportedProperties | Where-Object { $_ -cnotin $excludedProperties })
    $values = [Collections.Generic.List[object]]::new()
    $indexes = [Collections.Generic.Dictionary[string, int]]::new([StringComparer]::Ordinal)
    $rows = [ordered]@{}
    foreach ($entry in $merged.GetEnumerator()) {
        $rows[$entry.Key] = @(
            foreach ($field in $runtimeProperties) {
                if (-not $entry.Value.Contains($field)) { -1; continue }
                $value = $entry.Value[$field]
                $json = $utf8.GetString((Get-NamingJsonBytes $value))
                if (-not $indexes.ContainsKey($json)) { $indexes[$json] = $values.Count; $values.Add($value) }
                $indexes[$json]
            }
        ) -join ','
    }
    $entryPaths = Add-NamingJsonChunks -Artifacts $artifacts -Stem 'entries' -Items $rows -ChunkSize $ChunkSize
    $valuePaths = Add-NamingJsonChunks -Artifacts $artifacts -Stem 'values' -Items $values.ToArray() -ChunkSize $ChunkSize
    $manualSlugKeys = @($catalogs['data/resource-name-rules.manual.json'].resources.GetEnumerator() | Where-Object { $null -ne $_.Value.slug } | ForEach-Object Key)
    $slugPaths = Add-NamingJsonChunks -Artifacts $artifacts -Stem 'slugs' -Items $manualSlugKeys -ChunkSize $ChunkSize
    $artifacts['fields.json'] = Get-NamingJsonBytes $runtimeProperties

    $patterns = [Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
    foreach ($catalog in $catalogs.Values) {
        foreach ($entry in $catalog.resources.Values) {
            if (-not [string]::IsNullOrEmpty($entry.regex)) { $null = $patterns.Add($entry.regex) }
        }
    }
    $regexDescriptors = [Collections.Generic.List[object]]::new()
    foreach ($pattern in $patterns) {
        $descriptor = Get-NamingRegexDescriptor -Pattern $pattern
        if ($null -ne $descriptor) { $regexDescriptors.Add([ordered]@{ pattern = $pattern; descriptor = $descriptor }) }
    }
    $artifacts['regex.json'] = Get-NamingJsonBytes $regexDescriptors.ToArray()
    if ($artifacts['regex.json'].Length -gt 524288) { throw 'Regex descriptors exceed the safe Bicep file-loading limit; split the descriptor artifact before updating.' }
    $loader = [Collections.Generic.List[string]]::new()
    $loader.Add('// Generated by Sync-NamingCatalog. Do not edit.')
    $loader.Add('')
    $loader.Add('@export()')
    $loader.Add('var catalogEntries = shallowMerge([')
    foreach ($path in $entryPaths) { $loader.Add("  loadJsonContent('./$path')") }
    $loader.Add('])')
    $loader.Add('')
    $loader.Add('@export()')
    $loader.Add('var catalogValues = flatten([')
    foreach ($path in $valuePaths) { $loader.Add("  loadJsonContent('./$path')") }
    $loader.Add('])')
    $loader.Add('')
    $loader.Add('@export()')
    $loader.Add("var catalogFields = loadJsonContent('./fields.json')")
    $loader.Add('')
    $loader.Add('@export()')
    $loader.Add('var manualSlugKeys = flatten([')
    foreach ($path in $slugPaths) { $loader.Add("  loadJsonContent('./$path')") }
    $loader.Add('])')
    $loader.Add('')
    $loader.Add('@export()')
    $loader.Add("var regexDescriptors = loadJsonContent('./regex.json')")
    $artifacts['catalog.bicep'] = $utf8.GetBytes(($loader -join "`n") + "`n")
    $generated = [ordered]@{}
    foreach ($path in $artifacts.Keys) {
        $generated[$path] = [ordered]@{ sha256 = Get-NamingSha256 $artifacts[$path]; bytes = $artifacts[$path].Length }
    }
    return @{
        Artifacts = $artifacts
        Catalog = $merged
        Manifest  = [ordered]@{
            repository = 'Azure/terraform-azure-avm-utl-naming'
            revision = $Revision
            chunkSize = $ChunkSize
            runtime = [ordered]@{
                excludedProperties = $excludedProperties
                rowEncoding = 'delimited-indexes-v1'
            }
            sources = $sources
            generated = $generated
        }
    }
}

<#
.SYNOPSIS
Copies immutable Terraform catalogs and regenerates lossless Bicep chunks, or checks existing artifacts offline.
.PARAMETER Revision
An immutable commit in Azure/terraform-azure-avm-utl-naming. Omitting it never contacts upstream.
.PARAMETER Check
Verify hashes, complete JSON recomposition, chunk limits and generated-file parity without writing files.
.PARAMETER ModuleFolderPath
The naming utility directory. Defaults to this repository's avm/utl/general/naming.
.PARAMETER ChangeReportPath
Optional JSON report of potential naming, validation and metadata-only changes compared with the current pinned snapshots.
.EXAMPLE
Sync-NamingCatalog -Check
.EXAMPLE
Sync-NamingCatalog -Revision f74c017ea99d76f4109a78d99eea79dcac335240
#>
function Sync-NamingCatalog {
    [CmdletBinding()]
    param(
        [ValidatePattern('^[0-9a-f]{40}$')][string] $Revision,
        [switch] $Check,
        [string] $ModuleFolderPath = (Join-Path $PSScriptRoot '..' '..' 'avm' 'utl' 'general' 'naming'),
        [string] $ChangeReportPath
    )

    $ErrorActionPreference = 'Stop'
    if ($Check -and $Revision) { throw 'Check is offline and cannot be combined with Revision.' }
    if ($Check -and $ChangeReportPath) { throw 'Check does not write a change report.' }
    $modulePath = [IO.Path]::GetFullPath($ModuleFolderPath)
    $manifestPath = Join-Path $modulePath 'catalog-source.json'
    $previousRevision = $null
    $previousCatalog = [ordered]@{}
    if ($ChangeReportPath -and (Test-Path -LiteralPath $manifestPath)) {
        $previousManifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        if ($previousManifest.repository -cne 'Azure/terraform-azure-avm-utl-naming') { throw 'Unexpected previous upstream repository.' }
        $previousRevision = $previousManifest.revision
        $previousResources = @(
            foreach ($path in @('data/resource-name-rules.json', 'data/resource-name-rules.manual.json')) {
                $bytes = [IO.File]::ReadAllBytes((Join-Path $modulePath 'upstream' $path))
                if ((Get-NamingSha256 $bytes) -cne $previousManifest.sources[$path].sha256) { throw "Previous upstream snapshot hash mismatch: $path" }
                ([Text.Encoding]::UTF8.GetString($bytes) | ConvertFrom-Json -AsHashtable -Depth 100).resources
            }
        )
        $previousCatalog = Merge-NamingCatalogResources -Catalogs $previousResources
    }
    $paths = @('data/resource-name-rules.json', 'data/resource-name-rules.manual.json', 'schemas/naming-catalog.schema.json', 'schemas/naming-overrides.schema.json', 'LICENSE')
    $files = [ordered]@{}
    if ($Revision) {
        $client = [Net.Http.HttpClient]::new()
        try {
            foreach ($path in $paths) {
                $uri = "https://raw.githubusercontent.com/Azure/terraform-azure-avm-utl-naming/$Revision/$path"
                $files[$path] = $client.GetByteArrayAsync($uri).GetAwaiter().GetResult()
            }
        } finally {
            $client.Dispose()
        }
    } else {
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        if ($manifest.repository -cne 'Azure/terraform-azure-avm-utl-naming') { throw 'Unexpected upstream repository.' }
        $Revision = $manifest.revision
        foreach ($path in $paths) {
            $files[$path] = [IO.File]::ReadAllBytes((Join-Path $modulePath 'upstream' $path))
            if ((Get-NamingSha256 $files[$path]) -cne $manifest.sources[$path].sha256) { throw "Upstream snapshot hash mismatch: $path" }
        }
    }
    $result = New-NamingCatalogArtifacts -SourceFiles $files -Revision $Revision
    $manifestBytes = Get-NamingJsonBytes $result.Manifest
    $generatedPath = Join-Path $modulePath 'generated'
    $existing = @(if (Test-Path -LiteralPath $generatedPath) { Get-ChildItem -LiteralPath $generatedPath -Force })
    foreach ($file in $existing) {
        if ($file.PSIsContainer -or (-not $result.Artifacts.Contains($file.Name) -and $file.Name -cnotmatch '^(?:generated|manual|entries|values|slugs)-[0-9]{4}\.json$')) {
            throw "Unexpected generated file; refusing to modify [$($file.FullName)]."
        }
    }
    $upstreamPath = Join-Path $modulePath 'upstream'
    if (Test-Path -LiteralPath $upstreamPath) {
        foreach ($file in Get-ChildItem -LiteralPath $upstreamPath -File -Recurse -Force) {
            $relative = [IO.Path]::GetRelativePath($upstreamPath, $file.FullName).Replace('\', '/')
            if ($relative -cnotin $paths) { throw "Unexpected upstream file; refusing to modify [$($file.FullName)]." }
        }
    }
    if ($Check) {
        if ((Get-NamingSha256 ([IO.File]::ReadAllBytes($manifestPath))) -cne (Get-NamingSha256 $manifestBytes)) { throw 'Catalog manifest differs from reproducible artifacts.' }
        if ($existing.Count -ne $result.Artifacts.Count) { throw 'Stale or missing generated catalog files.' }
        foreach ($path in $result.Artifacts.Keys) {
            $actual = [IO.File]::ReadAllBytes((Join-Path $generatedPath $path))
            if ((Get-NamingSha256 $actual) -cne (Get-NamingSha256 $result.Artifacts[$path])) { throw "Generated catalog drift: $path" }
        }
    } else {
        foreach ($path in $paths) {
            $destination = Join-Path $modulePath 'upstream' $path
            $null = [IO.Directory]::CreateDirectory((Split-Path $destination))
            [IO.File]::WriteAllBytes($destination, $files[$path])
        }
        $null = [IO.Directory]::CreateDirectory($generatedPath)
        foreach ($path in $result.Artifacts.Keys) { [IO.File]::WriteAllBytes((Join-Path $generatedPath $path), $result.Artifacts[$path]) }
        foreach ($file in $existing) {
            if (-not $result.Artifacts.Contains($file.Name)) {
                Remove-Item -LiteralPath $file.FullName
            }
        }
        [IO.File]::WriteAllBytes($manifestPath, $manifestBytes)
        if ($ChangeReportPath) {
            $report = [ordered]@{
                previousRevision = $previousRevision
                revision = $Revision
                changes = Get-NamingCatalogChanges -Previous $previousCatalog -Current $result.Catalog
            }
            [IO.File]::WriteAllBytes([IO.Path]::GetFullPath($ChangeReportPath), (Get-NamingJsonBytes $report))
        }
    }
    [pscustomobject]@{
        Revision = $Revision
        SourceFiles = $files.Count
        GeneratedFiles = $result.Artifacts.Count
        MaximumChunkBytes = ($result.Artifacts.GetEnumerator() | Where-Object Key -Match '^(generated|manual|entries|values|slugs)-' | ForEach-Object { $_.Value.Length } | Measure-Object -Maximum).Maximum
        Check = $Check.IsPresent
    }
}
