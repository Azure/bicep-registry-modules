param(
    [string] $repoRootPath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..' '..'))
)

Describe 'Terraform naming catalog synchronization' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'tools' 'Sync-NamingCatalog.ps1')
        $modulePath = Join-Path $repoRootPath 'avm' 'utl' 'general' 'naming'
        $manifest = Get-Content -LiteralPath (Join-Path $modulePath 'catalog-source.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $sources = [ordered]@{}
        foreach ($path in $manifest.sources.Keys) {
            $sources[$path] = [IO.File]::ReadAllBytes((Join-Path $modulePath 'upstream' $path))
        }
        $utf8 = [Text.UTF8Encoding]::new($false, $true)
        function Copy-NamingSources {
            $copy = [ordered]@{}
            foreach ($path in $sources.Keys) { $copy[$path] = $sources[$path] }
            return $copy
        }
        function Copy-NamingFixture([string] $Name) {
            $destination = Join-Path $TestDrive $Name
            $null = New-Item -Path $destination -ItemType Directory
            foreach ($path in @('upstream', 'generated', 'catalog-source.json')) {
                Copy-Item -LiteralPath (Join-Path $modulePath $path) -Destination $destination -Recurse
            }
            return $destination
        }
    }

    It 'Verifies immutable snapshot hashes and deterministic artifacts without network access' {
        $result = Sync-NamingCatalog -ModuleFolderPath $modulePath -Check
        $result.Check | Should -BeTrue
        $result.Revision | Should -BeExactly $manifest.revision
        $result.SourceFiles | Should -Be 5
        $result.MaximumChunkBytes | Should -BeLessOrEqual $manifest.chunkSize
        foreach ($path in $sources.Keys) {
            Get-NamingSha256 $sources[$path] | Should -BeExactly $manifest.sources[$path].sha256
            $sources[$path].Length | Should -Be $manifest.sources[$path].bytes
        }
        { Sync-NamingCatalog -ModuleFolderPath $modulePath -Check -Revision $manifest.revision } | Should -Throw '*offline*'
    }

    It 'Accepts compiler-qualified import variables without allowing non-camel-case source names' {
        $compliance = Get-Content -LiteralPath (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'module.tests.ps1') -Raw
        $match = [regex]::Match($compliance, '\$variable -cnotmatch ''([^'']+)''')
        $match.Success | Should -BeTrue
        $pattern = $match.Groups[1].Value
        foreach ($name in @('namingCatalog', '$fxv#0', '_1._2', '_12._34', '_1.generatedCatalog')) {
            $name -cmatch $pattern | Should -BeTrue -Because $name
        }
        foreach ($name in @('bad_name', 'BadName', 'bad-name', '1name', '_1.bad_name', '_1.BadName', '_1._bad', '_1._2_name')) {
            $name -cmatch $pattern | Should -BeFalse -Because $name
        }
    }

    It 'Recomposes every resource and every envelope property from the on-disk chunks' {
        foreach ($entry in @(
            @{ source = 'data/resource-name-rules.json'; stem = 'generated' },
            @{ source = 'data/resource-name-rules.manual.json'; stem = 'manual' }
        )) {
            $original = $utf8.GetString($sources[$entry.source]) | ConvertFrom-Json -AsHashtable -Depth 100
            $recomposed = $null
            $chunks = @(Get-ChildItem -LiteralPath (Join-Path $modulePath 'generated') -Filter "$($entry.stem)-*.json" | Sort-Object Name)
            foreach ($file in $chunks) {
                $bytes = [IO.File]::ReadAllBytes($file.FullName)
                $bytes.Length | Should -BeLessOrEqual $manifest.chunkSize
                $utf8.GetString($bytes).Length | Should -BeLessOrEqual 1048576
                $chunk = $utf8.GetString($bytes) | ConvertFrom-Json -AsHashtable -Depth 100
                @($chunk.Keys) -join ',' | Should -BeExactly (@($original.Keys) -join ',')
                foreach ($key in $original.Keys | Where-Object { $_ -cne 'resources' }) {
                    ConvertTo-Json -InputObject $chunk[$key] -Depth 100 -Compress |
                        Should -BeExactly (ConvertTo-Json -InputObject $original[$key] -Depth 100 -Compress)
                }
                if ($null -eq $recomposed) {
                    $recomposed = $chunk
                } else {
                    foreach ($key in $chunk.resources.Keys) {
                        $recomposed.resources.Contains($key) | Should -BeFalse
                        $recomposed.resources[$key] = $chunk.resources[$key]
                    }
                }
            }
            Get-NamingSha256 (Get-NamingJsonBytes $recomposed) | Should -BeExactly (Get-NamingSha256 (Get-NamingJsonBytes $original))
            Get-NamingSha256 (Get-NamingJsonBytes $recomposed) | Should -BeExactly $manifest.sources[$entry.source].recomposedSha256
        }
    }

    It 'Grows and shrinks chunks without dropping entries or exceeding the configured bound' {
        $small = New-NamingCatalogArtifacts -SourceFiles $sources -Revision $manifest.revision -ChunkSize 131072
        $small.Artifacts.Count | Should -BeGreaterThan $manifest.generated.Count
        foreach ($path in $small.Artifacts.Keys | Where-Object { $_ -match '^(generated|manual)-' }) {
            $small.Artifacts[$path].Length | Should -BeLessOrEqual 131072
        }
        $copy = Copy-NamingSources
        $catalog = $utf8.GetString($copy['data/resource-name-rules.json']) | ConvertFrom-Json -AsHashtable -Depth 100
        $catalog.resources = [ordered]@{}
        $copy['data/resource-name-rules.json'] = Get-NamingJsonBytes $catalog
        $empty = New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision
        @($empty.Artifacts.Keys | Where-Object { $_ -match '^generated-' }).Count | Should -Be 1
        ($utf8.GetString($empty.Artifacts['generated-0000.json']) | ConvertFrom-Json -AsHashtable).resources.Count | Should -Be 0
    }

    It 'Rejects oversized individual entries and oversized envelopes before writing' {
        $copy = Copy-NamingSources
        $catalog = $utf8.GetString($copy['data/resource-name-rules.manual.json']) | ConvertFrom-Json -AsHashtable -Depth 100
        $catalog.resources['fixture_entry'] = @{ slug = 'x'; override_reason = ('x' * 140000) }
        $copy['data/resource-name-rules.manual.json'] = Get-NamingJsonBytes $catalog
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision -ChunkSize 131072 } | Should -Throw '*entry*exceeds*'
        $catalog.resources = [ordered]@{}
        $catalog['provenance'] = 'x' * 140000
        $copy['data/resource-name-rules.manual.json'] = Get-NamingJsonBytes $catalog
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision -ChunkSize 131072 } | Should -Throw '*envelope*exceeds*'
    }

    It 'Rejects malformed JSON, duplicate keys and case collisions without loss' {
        { Test-NamingJsonKeys -Json '{"x":1,"x":2}' } | Should -Throw '*Duplicate*'
        { Test-NamingJsonKeys -Json '{"source":{"x":1,"X":2}}' } | Should -Throw '*case-colliding*'
        { Test-NamingJsonKeys -Json '{"x":' } | Should -Throw
        $copy = Copy-NamingSources
        $copy['data/resource-name-rules.json'] = [byte[]] @(255, 254)
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision } | Should -Throw
    }

    It 'Validates full generated entries and partial manual entries against upstream schemas' {
        $copy = Copy-NamingSources
        $catalog = $utf8.GetString($copy['data/resource-name-rules.json']) | ConvertFrom-Json -AsHashtable -Depth 100
        $key = @($catalog.resources.Keys)[0]
        $catalog.resources[$key].Remove('slug')
        $copy['data/resource-name-rules.json'] = Get-NamingJsonBytes $catalog
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision } | Should -Throw
        $copy = Copy-NamingSources
        $copy['data/resource-name-rules.manual.json'] = Get-NamingJsonBytes @{ schema_version = 2; resources = @{ valid_key = @{ slug = 'x'; lowercase = $null } } }
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision } | Should -Throw
        $copy['data/resource-name-rules.manual.json'] = Get-NamingJsonBytes @{ schema_version = 3; resources = @{} }
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision } | Should -Throw
    }

    It 'Stops on unsupported schema evolution or an unexpected source set' {
        $copy = Copy-NamingSources
        $schema = $utf8.GetString($copy['schemas/naming-overrides.schema.json']) | ConvertFrom-Json -AsHashtable -Depth 100
        $schema.'$defs'.resource_entry.properties['new_constraint'] = @{ type = 'string' }
        $copy['schemas/naming-overrides.schema.json'] = Get-NamingJsonBytes $schema
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision } | Should -Throw '*unsupported rule properties*'
        $copy = Copy-NamingSources
        $copy.Remove('LICENSE')
        { New-NamingCatalogArtifacts -SourceFiles $copy -Revision $manifest.revision } | Should -Throw '*source file set*'
    }

    It 'Rejects source, manifest and generated-file drift' {
        $fixture = Copy-NamingFixture 'drift'
        $sourcePath = Join-Path $fixture 'upstream' 'data' 'resource-name-rules.json'
        [IO.File]::AppendAllText($sourcePath, "`n")
        { Sync-NamingCatalog -ModuleFolderPath $fixture -Check } | Should -Throw '*snapshot hash mismatch*'
        [IO.File]::WriteAllBytes($sourcePath, $sources['data/resource-name-rules.json'])
        $chunkPath = Join-Path $fixture 'generated' 'generated-0000.json'
        [IO.File]::AppendAllText($chunkPath, "`n")
        { Sync-NamingCatalog -ModuleFolderPath $fixture -Check } | Should -Throw '*Generated catalog drift*'
        $null = Sync-NamingCatalog -ModuleFolderPath $fixture
        $manifestPath = Join-Path $fixture 'catalog-source.json'
        [IO.File]::AppendAllText($manifestPath, "`n")
        { Sync-NamingCatalog -ModuleFolderPath $fixture -Check } | Should -Throw '*manifest differs*'
    }

    It 'Removes only recognized stale chunks and leaves unexpected files untouched' {
        $fixture = Copy-NamingFixture 'stale'
        $stalePath = Join-Path $fixture 'generated' 'generated-9999.json'
        [IO.File]::WriteAllText($stalePath, '{}')
        { Sync-NamingCatalog -ModuleFolderPath $fixture -Check } | Should -Throw '*Stale or missing*'
        $null = Sync-NamingCatalog -ModuleFolderPath $fixture
        Test-Path -LiteralPath $stalePath | Should -BeFalse
        (Sync-NamingCatalog -ModuleFolderPath $fixture -Check).Check | Should -BeTrue
        $unexpectedPath = Join-Path $fixture 'generated' 'notes.txt'
        [IO.File]::WriteAllText($unexpectedPath, 'leave this alone')
        $before = (Get-FileHash -LiteralPath (Join-Path $fixture 'catalog-source.json')).Hash
        { Sync-NamingCatalog -ModuleFolderPath $fixture } | Should -Throw '*Unexpected generated file*'
        (Get-FileHash -LiteralPath (Join-Path $fixture 'catalog-source.json')).Hash | Should -BeExactly $before
        Get-Content -LiteralPath $unexpectedPath | Should -BeExactly 'leave this alone'
    }

    It 'Protects raw upstream bytes from Git line-ending conversion' {
        $attributes = git -C $repoRootPath check-attr text -- avm/utl/general/naming/upstream/data/resource-name-rules.json avm/utl/general/naming/upstream/data/resource-name-rules.manual.json
        $LASTEXITCODE | Should -Be 0
        @($attributes).Count | Should -Be 2
        foreach ($line in $attributes) { $line | Should -Match 'text: unset$' }
    }

    It 'Keeps every supported pattern including case-distinct literals in the descriptor array' {
        $descriptors = Get-Content -LiteralPath (Join-Path $modulePath 'generated' 'regex.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $patterns = [Collections.Generic.SortedSet[string]]::new([StringComparer]::Ordinal)
        foreach ($path in @('data/resource-name-rules.json', 'data/resource-name-rules.manual.json')) {
            $catalog = $utf8.GetString($sources[$path]) | ConvertFrom-Json -AsHashtable -Depth 100
            foreach ($rule in $catalog.resources.Values) {
                if ($rule.regex -and (Get-NamingRegexDescriptor -Pattern $rule.regex)) { $null = $patterns.Add($rule.regex) }
            }
        }
        $descriptors.Count | Should -Be $patterns.Count
        ($descriptors.pattern | Sort-Object -CaseSensitive) -join "`n" | Should -BeExactly (($patterns | Sort-Object -CaseSensitive) -join "`n")
        ($descriptors | Where-Object pattern -CEQ '^Default$').descriptor.value | Should -BeExactly 'Default'
        ($descriptors | Where-Object pattern -CEQ '^default$').descriptor.value | Should -BeExactly 'default'
        $utf8.GetString((Get-NamingJsonBytes @())).Trim() | Should -BeExactly '[]'
        $utf8.GetString((Get-NamingJsonBytes @(@{ value = 'one' }))).Trim() | Should -BeExactly '[{"value":"one"}]'
    }

    It 'Executes actual Bicep descriptor expressions against ASCII and boundary probes' {
        $sourcePath = Join-Path $TestDrive 'descriptor-source'
        $null = New-Item -Path $sourcePath -ItemType Directory
        $source = Get-Content -LiteralPath (Join-Path $modulePath 'main.bicep') -Raw
        ([regex]::Matches($source, 'func matchesDescriptor\(')).Count | Should -Be 1
        $source.Replace('func matchesDescriptor(', "@export()`nfunc matchesDescriptor(") |
            Set-Content -LiteralPath (Join-Path $sourcePath 'main.bicep') -Encoding utf8NoBOM
        Copy-Item -LiteralPath (Join-Path $modulePath 'generated') -Destination $sourcePath -Recurse
        $descriptors = Get-Content -LiteralPath (Join-Path $modulePath 'generated' 'regex.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $probes = @(
            foreach ($entry in $descriptors) {
                $pattern = $entry.pattern
                $descriptor = $entry.descriptor
                $values = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
                foreach ($value in @('', "`n", 'default', 'Default', 'current', 'Current', [string][char]0x00e9, '01234567-0123-5123-8123-0123456789ab', '01234567x0123-5123-8123-0123456789ab', '012-4567-0123-5123-8123-0123456789ab', '01234567-0123-5123-8123-0123456789a-')) { $null = $values.Add($value) }
                $first = $descriptor.kind -ceq 'characters' ? $descriptor.first.Substring(0, 1) : 'a'
                $middle = $descriptor.kind -ceq 'characters' ? $descriptor.middle.Substring(0, 1) : 'a'
                $last = $descriptor.kind -ceq 'characters' ? $descriptor.last.Substring(0, 1) : 'a'
                foreach ($code in 32..126) {
                    $character = [string][char]$code
                    foreach ($value in @($character, "$first$character", "$character$last", "$first$character$last", "$character$middle$last", "$first$middle$character")) { $null = $values.Add($value) }
                }
                foreach ($length in @(0, 1, 2, 3, 4, 63, 64, 65, $descriptor.minimum, $descriptor.maximum)) {
                    if ($null -ne $length -and $length -ge 0) { $null = $values.Add($first * $length) }
                }
                @{
                    pattern = $pattern
                    descriptor = $descriptor
                    values = @($values | Sort-Object -CaseSensitive)
                }
            }
        )
        $probePath = Join-Path $TestDrive 'descriptor-probes.json'
        [IO.File]::WriteAllBytes($probePath, (Get-NamingJsonBytes $probes))
        (Get-Item -LiteralPath $probePath).Length | Should -BeLessThan 1048576
        $parameterPath = Join-Path $TestDrive 'descriptor-probes.bicepparam'
        @'
using none
import { matchesDescriptor } from './descriptor-source/main.bicep'
var probes = loadJsonContent('./descriptor-probes.json')
param results = map(probes, probe => map(probe.values, value => matchesDescriptor(value, probe.descriptor)))
'@ | Set-Content -LiteralPath $parameterPath -Encoding utf8NoBOM
        $outputPath = Join-Path $TestDrive 'descriptor-results.json'
        $diagnostics = bicep build-params $parameterPath --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0 -or $diagnostics) { throw ($diagnostics | Out-String) }
        $results = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters.results.value
        for ($patternIndex = 0; $patternIndex -lt $probes.Count; $patternIndex++) {
            $probe = $probes[$patternIndex]
            $pattern = $probe.pattern.Replace('${min_length - 1}', '0').Replace('${max_length - 1}', '999')
            $pattern = '\A(?:' + $pattern.Substring(1, $pattern.Length - 2) + ')\z'
            $regex = [regex]::new($pattern, [Text.RegularExpressions.RegexOptions]::CultureInvariant, [timespan]::FromSeconds(1))
            for ($valueIndex = 0; $valueIndex -lt $probe.values.Count; $valueIndex++) {
                $results[$patternIndex][$valueIndex] | Should -Be ($regex.IsMatch($probe.values[$valueIndex])) -Because "$($probe.pattern) with [$($probe.values[$valueIndex])]"
            }
        }
    }

    It 'Keeps the downstream workflow guarded, offline-qualified and review-only' {
        Import-Module powershell-yaml -ErrorAction Stop
        $workflow = Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'platform.sync-naming-catalog.yml') -Raw
        $parsed = ConvertFrom-Yaml -Yaml $workflow
        $parsed.jobs.sync.if | Should -Match "github.repository == 'Azure/bicep-registry-modules'"
        $parsed.jobs.sync.if | Should -Match '!github.event.repository.fork'
        $parsed.jobs.sync.if | Should -Match 'github.event.repository.default_branch'
        $parsed.concurrency.'cancel-in-progress' | Should -BeFalse
        $parsed.permissions.Count | Should -Be 0
        @($parsed.jobs.sync.permissions.Keys | Sort-Object) -join ',' | Should -BeExactly 'contents,pull-requests'
        $workflow | Should -Match 'Sync-NamingCatalog -Check'
        $workflow | Should -Match 'Initialize-AvmPester'
        $workflow | Should -Match 'Invoke-Pester'
        $workflow | Should -Match '\$results.Result -cne ''Passed'''
        $workflow | Should -Match 'gh pr create.*--draft'
        $workflow | Should -Not -Match 'gh pr merge|--force|terraform apply|az deployment|Publish-ResourceNameRules|workflow_run|pull_request_target'
        foreach ($step in $parsed.jobs.sync.steps | Where-Object { $_.Contains('run') }) {
            $tokens = $null
            $errors = $null
            $null = [Management.Automation.Language.Parser]::ParseInput($step.run, [ref] $tokens, [ref] $errors)
            @($errors).Count | Should -Be 0 -Because $step.name
        }
    }

    It 'Documents only exported functions even when private helpers have no metadata' {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Merge-FileWithNewContent.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-BRMRepositoryName.ps1')
        $template = @{
            metadata = @{ name = 'Naming'; description = 'Pure naming functions.' }
            resources = @{}
            functions = @(@{
                    namespace = '__bicep'
                    members = @{
                        getName = @{ metadata = @{ '__bicep_export!' = $true; description = "Public naming function.`nSecond line." } }
                        getCatalog = @{ metadata = @{ '__bicep_export!' = $true } }
                        hiddenWithDescription = @{ metadata = @{ description = 'Private implementation.' } }
                        hiddenWithoutMetadata = @{ output = @{ type = 'string'; value = 'internal' } }
                    }
                })
        }
        $readme = @('# Utility', '', '## Exported functions', '', '## Notes', '', 'Keep these notes.')
        $result = Set-FunctionsSection -TemplateFileContent $template -ReadMeFileContent $readme
        $text = $result -join "`n"
        $text | Should -Match '\| `getName` \| Public naming function.<p>Second line. \|'
        $text | Should -Match '\| `getCatalog` \|  \|'
        $text | Should -Not -Match 'hiddenWithDescription|hiddenWithoutMetadata'
        $text | Should -Match 'Keep these notes.'
        $initialize = @{
            ReadMeFilePath = Join-Path $modulePath 'README.md'
            FullModuleIdentifier = 'general/naming'
            TemplateFilePath = Join-Path $modulePath 'main.bicep'
            TemplateFileContent = $template
        }
        (Initialize-ReadMe @initialize | ForEach-Object { $_ }) -join "`n" | Should -Match "import \{ getCatalog, getName \} from 'br/public:avm/utl/general/naming:<version>'"
        $template.resources = @{ resource = @{} }
        (Initialize-ReadMe @initialize | ForEach-Object { $_ }) -join "`n" | Should -Match "module naming 'br/public:avm/utl/general/naming:<version>'"
        $generatedReadme = Get-Content -LiteralPath (Join-Path $modulePath 'README.md') -Raw
        $generatedReadme | Should -Not -Match 'validate and deploy the module successfully|from ''../../../main.bicep'''
        $generatedReadme | Should -Match "import \{ getName \} from 'br/public:avm/utl/general/naming:<version>'"
        $generatedReadme | Should -Match '<summary>via Bicep import</summary>'
        $template.functions[0].members.Remove('getName')
        $template.functions[0].members.Remove('getCatalog')
        (Set-FunctionsSection -TemplateFileContent $template -ReadMeFileContent $readme) -join "`n" | Should -BeExactly ($readme -join "`n")
    }
}
