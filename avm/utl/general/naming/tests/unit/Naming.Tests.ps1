param(
    [string] $repoRootPath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')),
    [string[]] $moduleFolderPaths,
    [string] $nativeResultsPath,
    [string] $consumerResultsPath
)

Describe 'Native Bicep naming functions' {
    BeforeAll {
        $modulePath = Join-Path $repoRootPath 'avm' 'utl' 'general' 'naming'
        $savedEnvironment = @{}
        $cachePath = Join-Path $TestDrive 'cache'
        $null = New-Item -Path $cachePath -ItemType Directory
        foreach ($variable in @('TEMP', 'TMP', 'TMPDIR', 'XDG_CACHE_HOME')) {
            $savedEnvironment[$variable] = [Environment]::GetEnvironmentVariable($variable)
            [Environment]::SetEnvironmentVariable($variable, $cachePath)
        }
        $outputPath = Join-Path $TestDrive 'evaluated.json'
        $diagnostics = bicep build-params (Join-Path $PSScriptRoot 'evaluate.bicepparam') --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0 -or $diagnostics) { throw "Native evaluation failed or warned: $($diagnostics | Out-String)" }
        if ($nativeResultsPath) { Copy-Item -LiteralPath $outputPath -Destination $nativeResultsPath }
        $evaluated = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters
        $baseline = $evaluated.baseline.value
        $cases = $evaluated.cases.value
        $generated = Get-Content -LiteralPath (Join-Path $modulePath 'upstream' 'data' 'resource-name-rules.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $manual = Get-Content -LiteralPath (Join-Path $modulePath 'upstream' 'data' 'resource-name-rules.manual.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $supportedPatterns = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($entry in (Get-Content -LiteralPath (Join-Path $modulePath 'generated' 'regex.json') -Raw | ConvertFrom-Json -Depth 100)) {
            $null = $supportedPatterns.Add($entry.pattern)
        }

        function Get-ExpectedBase([string] $Value, $Maximum, [string[]] $Suffixes) {
            if ($null -ne $Maximum) { $Value = $Value.Substring(0, [Math]::Min($Value.Length, [Math]::Max(0, $Maximum))) }
            $patterns = @($Suffixes | Where-Object { $_ -cne '' } | ForEach-Object { [regex]::Escape($_) })
            if ($patterns.Count -gt 0) { $Value = [regex]::Replace($Value, "(?:$($patterns -join '|'))+$", '') }
            return $Value
        }
    }

    AfterAll {
        foreach ($variable in $savedEnvironment.Keys) { [Environment]::SetEnvironmentVariable($variable, $savedEnvironment[$variable]) }
    }

    It 'Renders every merged entry and preserves naming rules without bundled provenance or legacy metadata' {
        $excluded = @('source', 'override_reason', 'override_source', 'legacy_slug', 'legacy_outputs')
        @($baseline.Keys | Sort-Object) -join ',' | Should -BeExactly (@(@($generated.resources.Keys) + @($manual.resources.Keys) | Sort-Object -Unique) -join ',')
        foreach ($key in $baseline.Keys) {
            $result = $baseline[$key]
            $result.nameAvailable | Should -BeTrue -Because $key
            $result.nameUniqueAvailable | Should -BeTrue -Because $key
            $expected = [ordered]@{}
            foreach ($entry in @($generated.resources[$key], $manual.resources[$key])) {
                if ($null -ne $entry) { foreach ($property in $entry.Keys) { $expected[$property] = $entry[$property] } }
            }
            foreach ($property in $excluded) {
                $result.rule.Contains($property) | Should -BeFalse -Because "$key.$property"
            }
            foreach ($property in $expected.Keys | Where-Object { $_ -cnotin $excluded }) {
                ConvertTo-Json -InputObject $result.rule[$property] -Depth 100 -Compress |
                    Should -BeExactly (ConvertTo-Json -InputObject $expected[$property] -Depth 100 -Compress) -Because "$key.$property"
            }
        }
    }

    It 'Applies explicit tokens, literal rules, casing and bounds across the full catalog' {
        foreach ($key in $baseline.Keys) {
            $result = $baseline[$key]
            $rule = $result.rule
            $result.uniqueSeed | Should -BeExactly 'a1b2c3d4' -Because $key
            if ($rule.name_kind -eq 'uuid') {
                $result.name | Should -Match '^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'
                continue
            }
            if ($rule.name_kind -eq 'literal') {
                $result.name | Should -BeExactly $rule.fixed_name -Because $key
                $result.nameUnique | Should -BeExactly $rule.fixed_name -Because $key
                $result.uniqueSuffixRetained | Should -BeFalse -Because $key
                continue
            }
            $slug = $rule.lowercase ? $rule.slug.ToLowerInvariant() : $rule.slug
            $maximum = $rule.max_length
            $uniqueMaximum = $null -eq $maximum ? $null : $maximum - 4 - $result.separator.Length
            $expectedName = Get-ExpectedBase $slug $maximum $rule.forbidden_suffixes
            $uniqueBase = Get-ExpectedBase $slug $uniqueMaximum $rule.forbidden_suffixes
            $expectedUnique = @($uniqueBase, 'a1b2' | Where-Object { $_ -cne '' }) -join $result.separator
            $result.name | Should -BeExactly $expectedName -Because $key
            $result.nameUnique | Should -BeExactly $expectedUnique -Because $key
            $result.uniqueSuffixRetained | Should -BeTrue -Because $key
        }
    }

    It 'Never reports complete validation for missing or unsupported constraints' {
        foreach ($key in $baseline.Keys) {
            $result = $baseline[$key]
            $expectedComplete = $result.rule.validation_complete -and $null -ne $result.rule.min_length -and $null -ne $result.rule.max_length -and $supportedPatterns.Contains($result.rule.regex)
            $result.validationComplete | Should -Be $expectedComplete -Because $key
            if (-not $result.validationComplete) {
                $result.validation.validName | Should -BeNullOrEmpty -Because $key
                $result.validation.validNameUnique | Should -BeNullOrEmpty -Because $key
                $result.validationNotes.Count | Should -BeGreaterThan 0 -Because $key
                continue
            }
            foreach ($property in @('name', 'nameUnique')) {
                $value = $result[$property]
                $rule = $result.rule
                $valid = $value.Length -ge $rule.min_length -and $value.Length -le $rule.max_length -and [regex]::IsMatch($value, $result.regex, [Text.RegularExpressions.RegexOptions]::CultureInvariant)
                foreach ($prefix in $rule.forbidden_prefixes) { $valid = $valid -and -not $value.StartsWith($prefix, [StringComparison]::Ordinal) }
                foreach ($suffix in $rule.forbidden_suffixes) { $valid = $valid -and -not $value.EndsWith($suffix, [StringComparison]::Ordinal) }
                foreach ($sequence in $rule.forbidden_sequences) { $valid = $valid -and -not $value.Contains($sequence, [StringComparison]::Ordinal) }
                $valid = $valid -and $value.ToLowerInvariant() -cnotin @($rule.reserved_names | ForEach-Object { $_.ToLowerInvariant() })
                $result.validation["valid$($property.Substring(0, 1).ToUpperInvariant())$($property.Substring(1))"] | Should -Be $valid -Because "$key.$property"
            }
        }
    }

    It 'Keeps exact seeds distinct from derived identities and disables uniqueness explicitly' {
        $cases.noSeed.name | Should -BeExactly 'st'
        $cases.noSeed.nameUnique | Should -BeNullOrEmpty
        $cases.noSeed.nameUniqueErrors -join ';' | Should -Match 'require.*uniqueSeed or uniqueIdentity'
        $cases.seedZero.nameUnique | Should -BeExactly $cases.seedZero.name
        $cases.seedUnchanged.uniqueSeed | Should -BeExactly 'AB12z'
        $cases.seedUnchanged.nameUnique | Should -BeExactly 'rg-AB12'
        $cases.seedDigit.uniqueSeed | Should -BeExactly '2ABCz'
        $cases.seedDigit.nameUnique | Should -BeExactly 'rg-2ABC'
        $cases.shortSeed.nameUnique | Should -BeExactly 'stz'
        $cases.compact.name | Should -BeExactly 'Team-rg-Dev'
    }

    It 'Repeats all names and changes only caller-owned identity for fresh runs' {
        ConvertTo-Json -InputObject $cases.repeated[0] -Depth 100 -Compress | Should -BeExactly (ConvertTo-Json -InputObject $cases.repeated[1] -Depth 100 -Compress)
        foreach ($case in @('fresh', 'changedIdentity', 'changedScope')) {
            $cases[$case].name | Should -BeExactly $cases.repeated[0].name
            $cases[$case].nameUnique | Should -Not -BeExactly $cases.repeated[0].nameUnique
        }
        $cases.fullIdentityA.name | Should -BeExactly $cases.fullIdentityB.name
        $cases.fullIdentityA.nameUnique | Should -Not -BeExactly $cases.fullIdentityB.nameUnique
        $cases.orderedVariables[0].uniqueSeed | Should -BeExactly $cases.orderedVariables[1].uniqueSeed
        $cases.letters.uniqueSeed | Should -Match '^[a-z]{13}$'
        $cases.letters.nameUnique.Length | Should -Be 24
    }

    It 'Starts every derived token with a letter even for unique-first or empty-base names' {
        $results = $evaluated.derivedTokens.value
        $results.Count | Should -Be 64
        foreach ($entry in $results) {
            $entry.group.uniqueSeed | Should -Match '^[a-z][a-z0-9]{12}$'
            foreach ($name in @('vault', 'emptyBase')) {
                $entry[$name].uniqueSeed | Should -Match '^[a-z][a-z0-9]{12}$'
                $entry[$name].nameUnique | Should -Match '^[a-z]'
                $entry[$name].nameUniqueAvailable | Should -BeTrue
                $entry[$name].validation.validNameUnique | Should -BeTrue
                $entry[$name].uniqueSuffixRetained | Should -BeTrue
            }
        }
        @($results | Where-Object { $_.group.uniqueSeed.Substring(1) -match '[0-9]' }).Count | Should -BeGreaterThan 0
    }

    It 'Excludes catalog metadata and bounds from identity hashing without hiding rendering changes' {
        $results = $evaluated.identityCatalogChanges.value
        foreach ($name in @('descriptive', 'context')) {
            $results[$name].uniqueSeed | Should -BeExactly $results.baseline.uniqueSeed -Because $name
            $results[$name].name | Should -BeExactly $results.baseline.name -Because $name
            $results[$name].nameUnique | Should -BeExactly $results.baseline.nameUnique -Because $name
        }
        $results.truncated.uniqueSeed | Should -BeExactly $results.baseline.uniqueSeed
        $results.truncated.nameUnique.Length | Should -Be 24
        $results.truncated.nameUnique | Should -Not -BeExactly $results.baseline.nameUnique
        $results.slug.uniqueSeed | Should -Not -BeExactly $results.baseline.uniqueSeed
        $results.slug.name | Should -Not -BeExactly $results.baseline.name
    }

    It 'Rejects mixed-case conversion verbs while preserving literal text around valid instance formats' {
        foreach ($entry in $evaluated.instanceFormats.value.invalid) {
            $entry.result.name | Should -BeNullOrEmpty -Because $entry.pattern
            $entry.result.nameUnique | Should -BeNullOrEmpty -Because $entry.pattern
            $entry.result.nameAvailable | Should -BeFalse -Because $entry.pattern
            $entry.result.nameUniqueAvailable | Should -BeFalse -Because $entry.pattern
            $entry.result.nameErrors -join ';' | Should -Match 'instanceFormat supports' -Because $entry.pattern
            @($entry.result.Keys | Sort-Object) -join ',' | Should -BeExactly (@($baseline.resource_group.Keys | Sort-Object) -join ',')
        }
        $expected = @{ '%d' = '7'; '%0d' = '7'; '%03d' = '007'; 'D%03dD' = 'D007D'; '%03dd' = '007d'; '%03d-Dd' = '007-Dd' }
        foreach ($entry in $evaluated.instanceFormats.value.valid) {
            $entry.result.nameAvailable | Should -BeTrue -Because $entry.pattern
            $entry.result.name | Should -BeExactly "rg-$($expected[$entry.pattern])"
            $entry.result.nameErrors.Count | Should -Be 0
        }
        $cases.instanceCaseLiteral.nameUnique | Should -BeExactly 'rg-workload-dev-D001D-abcd'
    }

    It 'Retains whole numbered instances and uniqueness tokens when truncating' {
        $cases.instance.nameUnique | Should -BeExactly 'stworkloaddev001abcd'
        $cases.instanceZero.nameUnique | Should -BeExactly 'rg-workload-dev-000-abcd'
        $cases.instanceLarge.nameUnique | Should -BeExactly 'rg-workload-dev-1000-abcd'
        $cases.instanceWidth.nameUnique | Should -BeExactly 'rg-workload-dev-20-abcd'
        $cases.instanceUnpadded.nameUnique | Should -BeExactly $cases.instanceWidth.nameUnique
        $cases.instanceLong.nameUnique | Should -BeExactly "$('a' * 17)001abcd"
        $cases.instanceLongOther.nameUnique | Should -BeExactly "$('a' * 17)020abcd"
        $cases.instanceOversized.nameAvailable | Should -BeFalse
        $cases.instanceOversized.nameUniqueAvailable | Should -BeFalse
        $cases.instanceUniqueOnly.nameAvailable | Should -BeFalse
        $cases.instanceUniqueOnly.nameUnique | Should -BeExactly 'rg-001-abcd'
    }

    It 'Evaluates supported templates and verifies real token interpolation' {
        $cases.simpleTemplate.name | Should -BeExactly 'stdevuks001'
        $cases.literalTemplate.name | Should -BeExactly 'st-dev-uks-001'
        $cases.joinedTemplate.nameUnique | Should -BeExactly 'abcd-rg-dev-uks'
        $cases.prefixTemplate.name | Should -BeExactly 'a-b'
        $cases.upperTemplate.nameUnique | Should -BeExactly 'rgABCD'
        $cases.upperCustomToken.name | Should -BeExactly 'blue'
        $cases.instanceUpper.nameUnique | Should -BeExactly 'ID001-rg-abcd'
        $cases.instanceMissing.instanceRetained.name | Should -BeFalse
        $cases.uniqueMissing.uniqueSuffixRetained | Should -BeFalse
        $cases.uniqueMissing.nameUniqueAvailable | Should -BeFalse
        $cases.emptyJoin.nameAvailable | Should -BeTrue
        $cases.emptyJoin.name | Should -BeExactly ''
        $cases.emptyJoin.validation.validName | Should -BeFalse
    }

    It 'Rejects invalid inputs and unsupported syntax without success-shaped results' {
        foreach ($case in @('instanceInvalid', 'formatInvalid', 'unsupportedTemplate', 'malformedLiteral', 'escapedTemplate', 'unknownToken', 'unclosedTemplate', 'invalidReservedToken', 'invalidReservedTokenCase', 'invalidInstanceTokenCase', 'exactAndIdentity', 'identityMissing', 'identityTooLong', 'unknownKey', 'invalidSlugKey', 'invalidBounds', 'nullBoolean', 'nullList', 'nullLegacyOutputs', 'invalidInterpolatedRegex', 'unrelatedInvalidEntry', 'invalidNewEntry')) {
            $cases[$case].name | Should -BeNullOrEmpty -Because $case
            $cases[$case].nameUnique | Should -BeNullOrEmpty -Because $case
            $cases[$case].nameAvailable | Should -BeFalse -Because $case
            $cases[$case].nameUniqueAvailable | Should -BeFalse -Because $case
            $cases[$case].nameErrors.Count | Should -BeGreaterThan 0 -Because $case
            @($cases[$case].Keys | Sort-Object) -join ',' | Should -BeExactly (@($baseline.storage_account.Keys | Sort-Object) -join ',') -Because $case
        }
    }

    It 'Preserves fixed names and uses deterministic native UUIDs' {
        $cases.fixed.name | Should -BeExactly 'default'
        $cases.fixed.nameUnique | Should -BeExactly 'default'
        $cases.fixed.instanceRetained.name | Should -BeFalse
        $cases.fixed.instanceRetained.nameUnique | Should -BeFalse
        $cases.fixed.uniqueSuffixRetained | Should -BeFalse
        $cases.uuidZero.name | Should -BeExactly $cases.uuidZero.nameUnique
        $cases.uuidZero.name | Should -Not -BeExactly $cases.uuidOther.name
        $cases.uuid.name | Should -Not -BeExactly $cases.uuid.nameUnique
    }

    It 'Uses whole-property overlays, exact boundaries and explicit validation flags' {
        $cases.custom.nameUnique | Should -BeExactly 'Contosoabcd'
        $cases.custom.rule.min_length | Should -Be 0
        $cases.custom.rule.lowercase | Should -BeFalse
        $cases.custom.rule.max_length | Should -BeNullOrEmpty
        $cases.custom.rule.source.Count | Should -Be 1
        $cases.custom.rule.source.organization | Should -BeExactly 'Contoso'
        $cases.customerMetadata.nameUnique | Should -BeExactly $baseline.resource_group.nameUnique
        $cases.customerMetadata.rule.source.organization | Should -BeExactly 'Contoso'
        $cases.customerMetadata.rule.override_reason | Should -BeExactly 'Organization metadata'
        $cases.customerMetadata.rule.override_source | Should -BeExactly 'https://example.com/naming'
        $cases.customerMetadata.rule.legacy_slug | Should -BeExactly 'old'
        $cases.customerMetadata.rule.legacy_outputs | Should -Be @('old_name')
        $evaluated.merged.value.site.forbidden_suffixes.Count | Should -Be 0
        $evaluated.merged.value.site.reserved_names | Should -Be @('admin')
        $cases.customNew.name | Should -BeExactly 'contosoteam'
        $cases.customSlug.name | Should -BeExactly 'override'
        $cases.customSlug.slugSource | Should -BeExactly 'override'
        $cases.customStrict.nameAvailable | Should -BeFalse
        $cases.unsupportedRegex.validationComplete | Should -BeFalse
        $cases.unsupportedRegex.validation.validName | Should -BeNullOrEmpty
        $cases.strictValid.validation.validNameUnique | Should -BeTrue
        $cases.strictInvalid.nameUniqueAvailable | Should -BeFalse
        $cases.caseSensitiveBoundary.name | Should -BeExactly 'Ab'
        $cases.suffixChain.name | Should -BeExactly 'z'
        $cases.longForbiddenSuffix.name | Should -BeExactly 'st'
    }

    It 'Preserves type variants, deduplicates selected keys and reports unknown keys' {
        $expected = @($baseline.Keys | Where-Object { $baseline[$_].resourceType -ceq 'Microsoft.Compute/virtualMachines' } | Sort-Object)
        @($evaluated.variants.value.Keys | Sort-Object) -join ',' | Should -BeExactly ($expected -join ',')
        $evaluated.selected.value.Count | Should -Be 3
        $evaluated.selected.value.unknown_key.nameAvailable | Should -BeFalse
    }

    It 'Reports case collisions without crashing batches or applying a mis-cased override' {
        $results = $evaluated.keyCollisions.value
        foreach ($name in @('requested', 'reversed')) {
            $results[$name].Count | Should -Be 2
            @($results[$name].Keys) -ccontains 'resource_group' | Should -BeTrue
            @($results[$name].Keys) -ccontains 'RESOURCE_GROUP' | Should -BeFalse
            $results[$name].resource_group.nameAvailable | Should -BeFalse
            $results[$name].resource_group.nameUniqueAvailable | Should -BeFalse
            $results[$name].resource_group.nameErrors -join ';' | Should -Match 'differ only by case'
            $results[$name].storage_account.nameUnique | Should -BeExactly $baseline.storage_account.nameUnique
        }
        @($results.misCasedOnly.Keys) -ccontains 'RESOURCE_GROUP' | Should -BeTrue
        $results.misCasedOnly.RESOURCE_GROUP.nameAvailable | Should -BeFalse
        $results.catalog.slug | Should -BeExactly $baseline.resource_group.slug
        $results.catalog.resource_type | Should -BeExactly $baseline.resource_group.resourceType
        $results.catalog.catalogErrors -join ';' | Should -Match 'differ only by case'
        $results.invalidCatalog.catalogErrors -join ';' | Should -Match 'lower snake case'
        $results.variants.Count | Should -Be 1
        @($results.variants.Keys) -ccontains 'resource_group' | Should -BeTrue
        foreach ($entry in @($results.canonical, $results.variants.resource_group, $results.slug)) {
            $entry.nameAvailable | Should -BeFalse
            $entry.nameUniqueAvailable | Should -BeFalse
            $entry.nameErrors.Count | Should -BeGreaterThan 0
            $entry.slug | Should -BeExactly $baseline.resource_group.slug
            $entry.rule.slug | Should -BeExactly $baseline.resource_group.rule.slug
        }
    }

    It 'Preserves nullable overrides and reserves the formatted instance only when supplied' {
        $nullable = $evaluated.nullableCases.value
        $nullable.inheritedSlug.nameUnique | Should -BeExactly 'stabcd'
        $nullable.inheritedSlug.slugSource | Should -BeExactly $baseline.storage_account.slugSource
        $nullable.customInstance.nameUnique | Should -BeExactly 'rg-blue-abcd'
        $nullable.customInstance.instance | Should -BeNullOrEmpty
        $nullable.instanceConflict.nameAvailable | Should -BeFalse
        $nullable.invalidIdentifier.nameAvailable | Should -BeFalse
        $nullable.nullToken.nameAvailable | Should -BeFalse
        $nullable.unusedNullToken.nameUnique | Should -BeExactly 'rg-abcd'
    }

    It 'Rejects unsupported catalog schema versions at the consumer compiler boundary' {
        $sourcePath = Join-Path $TestDrive 'source'
        $null = New-Item -Path $sourcePath -ItemType Directory
        Copy-Item -LiteralPath (Join-Path $modulePath 'main.bicep') -Destination $sourcePath
        Copy-Item -LiteralPath (Join-Path $modulePath 'generated') -Destination $sourcePath -Recurse
        $invalidPath = Join-Path $TestDrive 'invalid.bicepparam'
        @"
using none
import { getName } from './source/main.bicep'
param name = getName('storage_account', { customOverrides: { schema_version: 3, resources: {} } })
"@ | Set-Content -LiteralPath $invalidPath -Encoding utf8NoBOM
        $diagnostics = bicep build-params $invalidPath --outfile (Join-Path $TestDrive 'invalid.json') 2>&1
        $LASTEXITCODE | Should -Not -Be 0
        $diagnostics -join "`n" | Should -Match 'schema_version.*2'
    }

    It 'Imports the compiled registry artifact and stays within ARM template limits' {
        $compiledPath = Join-Path $TestDrive 'library.json'
        $diagnostics = bicep build (Join-Path $modulePath 'main.bicep') --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0 -or $diagnostics) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        (Get-Item -LiteralPath $compiledPath).Length | Should -BeLessThan 4194304
        $template.resources.Count | Should -Be 0
        $template.variables.Count | Should -BeLessOrEqual 512
        @($template.functions | ForEach-Object { $_.members.Keys }).Count | Should -BeLessOrEqual 256
        $pending = [Collections.Generic.Stack[object]]::new()
        $pending.Push($template)
        while ($pending.Count -gt 0) {
            $value = $pending.Pop()
            if ($value -is [Collections.IDictionary]) {
                foreach ($child in $value.Values) { if ($null -ne $child) { $pending.Push($child) } }
            } elseif ($value -is [array]) {
                foreach ($child in $value) { if ($null -ne $child) { $pending.Push($child) } }
            } elseif ($value -is [string] -and $value.StartsWith('[')) {
                $value.Length | Should -BeLessOrEqual 24576
            }
        }
        $consumerPath = Join-Path $TestDrive 'consumer.bicepparam'
        @"
using none
import { getName } from './library.json'
param result = getName('storage_account', { uniqueSeed: 'abcd' })
"@ | Set-Content -LiteralPath $consumerPath -Encoding utf8NoBOM
        $consumerOutput = Join-Path $TestDrive 'consumer.json'
        $diagnostics = bicep build-params $consumerPath --outfile $consumerOutput 2>&1
        if ($LASTEXITCODE -ne 0 -or $diagnostics) { throw ($diagnostics | Out-String) }
        $consumer = (Get-Content -LiteralPath $consumerOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters.result.value
        $consumer.nameUnique | Should -BeExactly 'stabcd'
    }

    It 'Budgets the actual importing consumer and three or ten separate nested copies' {
        $libraryPath = Join-Path $TestDrive 'sized-library.json'
        $diagnostics = bicep build (Join-Path $modulePath 'main.bicep') --outfile $libraryPath 2>&1
        if ($LASTEXITCODE -ne 0 -or $diagnostics) { throw ($diagnostics | Out-String) }
        $consumerPath = Join-Path $TestDrive 'runtime-consumer.bicep'
        @'
import { getName } from './sized-library.json'
param identity string
output result object = getName('storage_account', { uniqueIdentity: identity })
'@ | Set-Content -LiteralPath $consumerPath -Encoding utf8NoBOM
        $consumerOutput = Join-Path $TestDrive 'runtime-consumer.json'
        $diagnostics = bicep build $consumerPath --outfile $consumerOutput 2>&1
        if ($LASTEXITCODE -ne 0 -or $diagnostics) { throw ($diagnostics | Out-String) }
        $consumerBytes = (Get-Item -LiteralPath $consumerOutput).Length
        $consumerBytes | Should -BeLessThan 262144
        $nestedSizes = [ordered]@{}
        foreach ($count in @(3, 10)) {
            $nestedPath = Join-Path $TestDrive "nested-$count.bicep"
            $modules = foreach ($index in 0..($count - 1)) {
                @"
module consumer$index './runtime-consumer.bicep' = {
  name: 'consumer$index'
  params: { identity: identity }
}
"@
            }
            $references = (0..($count - 1) | ForEach-Object { "consumer$($_).outputs.result" }) -join ', '
            $moduleText = $modules -join "`n"
            "param identity string`n$moduleText`noutput results array = [$references]" |
                Set-Content -LiteralPath $nestedPath -Encoding utf8NoBOM
            $nestedOutput = Join-Path $TestDrive "nested-$count.json"
            $diagnostics = bicep build $nestedPath --outfile $nestedOutput 2>&1
            if ($LASTEXITCODE -ne 0 -or $diagnostics) { throw ($diagnostics | Out-String) }
            $nestedSizes["$count"] = (Get-Item -LiteralPath $nestedOutput).Length
            $nestedSizes["$count"] | Should -BeLessThan 4194304
            $nested = Get-Content -LiteralPath $nestedOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $nested.resources.Count | Should -Be $count
            $nestedTemplates = $nested.resources -is [Collections.IDictionary] ? @($nested.resources.Values) : @($nested.resources)
            foreach ($resource in $nestedTemplates) {
                $resource.properties.template.functions.Count | Should -BeGreaterThan 0
            }
        }
        $consumer = Get-Content -LiteralPath $consumerOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $consumer.outputs.result.value | Should -Match "getName.*parameters\('identity'\)"
        if ($consumerResultsPath) {
            [ordered]@{ consumerBytes = $consumerBytes; consumerBudgetBytes = 262144; nestedBytes = $nestedSizes['3']; tenNestedBytes = $nestedSizes['10']; templateLimitBytes = 4194304 } |
                ConvertTo-Json | Set-Content -LiteralPath $consumerResultsPath -Encoding utf8NoBOM
        }
    }
}
