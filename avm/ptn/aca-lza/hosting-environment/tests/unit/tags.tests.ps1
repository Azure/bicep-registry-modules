BeforeAll {
    $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
    $source = Get-Content (Join-Path $moduleRoot 'main.bicep') -Raw
    $compiledPath = Join-Path $TestDrive 'tags-main.json'
    $diagnostics = bicep build (Join-Path $moduleRoot 'main.bicep') --no-restore --outfile $compiledPath 2>&1
    if ($LASTEXITCODE) { throw "Actual module compilation failed: $($diagnostics -join "`n")" }
    $template = Get-Content $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $declaration = [regex]::Match($source, '(?m)^param tags (?<type>object\??)(?: = (?<default>[^\r\n]+))?$')
    if (-not $declaration.Success) { throw 'Actual tags contract was not found.' }
    $forwards = [regex]::Matches($source, '(?m)^\s+tags: (?<expression>[^\r\n]+)$')
    if ($forwards.Count -ne 6) { throw 'Unexpected tag-consuming module count.' }
    $expression = $forwards[0].Groups['expression'].Value
}

Describe 'ACA nullable tags contract' {
    It 'Accepts explicit null with an implicit null parameter default' {
        $template.parameters.tags.nullable | Should -BeTrue
        $template.parameters.tags.defaultValue | Should -BeNullOrEmpty
    }

    It 'Forwards the same null-to-empty expression to all six existing consumers' {
        $expression | Should -BeExactly 'tags ?? {}'
        foreach ($forward in $forwards) {
            $forward.Groups['expression'].Value | Should -BeExactly $expression
        }
        foreach ($name in @('spokeResourceGroup', 'spoke', 'supportingServices', 'containerAppsEnvironment', 'sampleApplication', 'applicationGateway')) {
            $template.resources[$name].properties.parameters.tags.value |
                Should -BeExactly "[coalesce(parameters('tags'), createObject())]"
        }
    }

    It 'Evaluates actual tag expressions for <case>' -ForEach @(
        @{ case = 'omitted'; valueExpression = $null; expected = @{} }
        @{ case = 'explicit null'; valueExpression = 'null'; expected = @{} }
        @{ case = 'empty object'; valueExpression = '{}'; expected = @{} }
        @{ case = 'nonempty object'; valueExpression = "{ purpose: 'synthetic', owner: 'test' }"; expected = @{ purpose = 'synthetic'; owner = 'test' } }
        @{ case = 'multibyte value'; valueExpression = "json('{`"purpose`":`"$([char]0x00E9)$([char]0x4E2D)`"}')"; expected = @{ purpose = "$([char]0x00E9)$([char]0x4E2D)" } }
    ) {
        $default = $declaration.Groups['default'].Success ? $declaration.Groups['default'].Value : 'null'
        $value = $null -eq $valueExpression ? $default : $valueExpression
        $lines = @(
            'using none'
            "var rawTags $($declaration.Groups['type'].Value) = $value"
            "param effectiveTags = $($expression -replace '\btags\b', 'rawTags')"
        )
        $path = Join-Path $TestDrive "$case.bicepparam"
        $out = Join-Path $TestDrive "$case.json"
        [IO.File]::WriteAllText($path, ($lines -join "`n"))
        $messages = bicep build-params $path --no-restore --outfile $out 2>&1
        $LASTEXITCODE | Should -Be 0 -Because ($messages -join "`n")
        $actual = (Get-Content $out -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters.effectiveTags.value
        $actual.Count | Should -Be $expected.Count
        foreach ($key in $expected.Keys) { $actual[$key] | Should -BeExactly $expected[$key] }
    }

    It 'Rejects an array rather than silently treating invalid tags as empty' {
        $path = Join-Path $TestDrive 'invalid-tags.bicepparam'
        [IO.File]::WriteAllText($path, "using none`nvar rawTags $($declaration.Groups['type'].Value) = []`nparam effectiveTags = rawTags")
        $messages = bicep build-params $path --no-restore --outfile (Join-Path $TestDrive 'invalid-tags.json') 2>&1
        $LASTEXITCODE | Should -Not -Be 0
        ($messages -join "`n") | Should -Match 'BCP033'
    }
}
