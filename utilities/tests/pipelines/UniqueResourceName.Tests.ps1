param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Shared e2e resource names' {
    BeforeAll {
        Copy-Item -LiteralPath (Join-Path $repoRootPath 'utilities' 'e2e-template-assets' 'functions' 'unique-resource-name.bicep') -Destination $TestDrive
        $helperPath = './unique-resource-name.bicep'
        $lines = @(
            'using none'
            "import { uniqueResourceName } from '$helperPath'"
        )
        $scopes = @(
            '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/fixture-a'
            '/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/fixture-a'
            '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/fixture-b'
        )
        foreach ($limit in @(10, 22, 24, 44, 50, 60, 63)) {
            foreach ($scopeIndex in 0..2) {
                foreach ($iteration in @('init', 'idem', 'retry')) {
                    $lines += "param name${limit}s${scopeIndex}${iteration} = uniqueResourceName('storageaccountbase', '$($scopes[$scopeIndex])', $limit)"
                }
            }
        }
        $lines += @(
            "param firstLongName = uniqueResourceName('$('a' * 60)1', '$($scopes[0])', 24)"
            "param secondLongName = uniqueResourceName('$('a' * 60)2', '$($scopes[0])', 24)"
            "param shortName = uniqueResourceName('kv', '$($scopes[0])', 24)"
            "param hyphenatedName = uniqueResourceName('dep-key-vault-name', '$($scopes[0])', 24)"
        )
        $parameterPath = Join-Path $TestDrive 'names.bicepparam'
        $outputPath = Join-Path $TestDrive 'names.json'
        $lines -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Produces valid names no longer than <limit> characters' -ForEach (@(10, 22, 24, 44, 50, 60, 63) | ForEach-Object { @{ limit = $_ } }) {
        foreach ($scopeIndex in 0..2) {
            $name = $names["name${limit}s${scopeIndex}init"].value
            $name | Should -Match '^[a-z][a-z0-9]+$'
            $name.Length | Should -BeLessOrEqual $limit
            $name.Length | Should -Be ([Math]::Min(18, [Math]::Max(1, $limit - 13)) + [Math]::Min(13, $limit - 1))
        }
    }

    It 'Changes names across subscriptions and resource groups' {
        foreach ($limit in @(10, 22, 24, 44, 50, 60, 63)) {
            $values = @(0..2 | ForEach-Object { $names["name${limit}s${_}init"].value })
            @($values | Select-Object -Unique).Count | Should -Be 3
        }
    }

    It 'Keeps initial, idempotent and retry deployment names identical' {
        foreach ($limit in @(10, 22, 24, 44, 50, 60, 63)) {
            foreach ($scopeIndex in 0..2) {
                $names["name${limit}s${scopeIndex}init"].value | Should -Be $names["name${limit}s${scopeIndex}idem"].value
                $names["name${limit}s${scopeIndex}init"].value | Should -Be $names["name${limit}s${scopeIndex}retry"].value
            }
        }
    }

    It 'Hashes the complete base name, including truncated characters' {
        $names.firstLongName.value | Should -Not -Be $names.secondLongName.value
        $names.firstLongName.value.Substring(0, 11) | Should -Be $names.secondLongName.value.Substring(0, 11)
    }

    It 'Preserves short and hyphenated prefixes with the full suffix' {
        $names.shortName.value | Should -Match '^kv[a-z0-9]{13}$'
        $names.hyphenatedName.value | Should -Match '^dep-key-vau[a-z0-9]{13}$'
    }

    It 'Rejects <reason>' -ForEach @(
        @{ reason = 'an empty base name'; arguments = "'', 'scope', 24" }
        @{ reason = 'an empty scope'; arguments = "'base', '', 24" }
        @{ reason = 'an invalid length'; arguments = "'base', 'scope', 1" }
    ) {
        $parameterPath = Join-Path $TestDrive 'invalid.bicepparam'
        @(
            'using none'
            "import { uniqueResourceName } from '$helperPath'"
            "param name = uniqueResourceName($arguments)"
        ) -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --stdout 2>&1
        $LASTEXITCODE | Should -Not -Be 0
        $diagnostics | Out-String | Should -Match 'Error BCP'
    }
}
