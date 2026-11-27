BeforeAll {
    $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
}

Describe 'AI Foundry nullable tags: <sourcePath>' -ForEach @(
    @{ sourcePath = 'main.bicep'; consumerCount = 6 }
    @{ sourcePath = 'modules/project/main.bicep'; consumerCount = 3 }
) {
    BeforeAll {
        $sourceFile = Join-Path $moduleRoot $sourcePath
        $source = Get-Content -LiteralPath $sourceFile -Raw
        $output = Join-Path $TestDrive 'compiled.json'
        $messages = bicep build $sourceFile --no-restore --outfile $output 2>&1
        if ($LASTEXITCODE) { throw "Actual source compilation failed: $($messages -join "`n")" }
        $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $declaration = [regex]::Match($source, '(?m)^param tags (?<type>resourceInput<[^>]+>\.tags\?)$')
        $forwards = [regex]::Matches($source, '(?m)^\s+tags: (?<expression>[^\r\n]+)$')
        [IO.File]::WriteAllText((Join-Path $TestDrive 'tags-type.bicep'), "@export()`ntype resourceTagsType = $($declaration.Groups['type'].Value)")
    }

    It 'Accepts omitted and explicit-null tags without changing the resource-derived type' {
        $declaration.Success | Should -BeTrue
        $template.parameters.tags.nullable | Should -BeTrue
        $default = $template.parameters.tags.ContainsKey('defaultValue') ? $template.parameters.tags['defaultValue'] : $null
        $default | Should -BeNullOrEmpty
    }

    It 'Normalizes null for every existing tag consumer' {
        $forwards.Count | Should -Be $consumerCount
        foreach ($forward in $forwards) {
            $forward.Groups['expression'].Value | Should -BeExactly 'tags ?? {}'
        }
    }

    It 'Compiles the actual module with <case> tags' -ForEach @(
        @{ case = 'omitted'; explicitNull = $false }
        @{ case = 'explicit null'; explicitNull = $true }
    ) {
        $relativeSource = [IO.Path]::GetRelativePath($TestDrive, $sourceFile).Replace('\', '/')
        $requiredParameters = if ($sourcePath -eq 'main.bicep') {
            "baseName: 'synthetic'"
        } else {
            "name: 'synthetic'`naccountName: 'synthetic'`ncreateAccountCapabilityHost: false`ncreateProjectCapabilityHost: false"
        }
        $tagsParameter = $explicitNull ? 'tags: null' : ''
        $inputPath = Join-Path $TestDrive "$case-module.bicep"
        $outputPath = Join-Path $TestDrive "$case-module.json"
        [IO.File]::WriteAllText($inputPath, "module tested '$relativeSource' = {`nname: 'synthetic'`nparams: {`n$requiredParameters`n$tagsParameter`n}`n}")
        $messages = bicep build $inputPath --no-restore --outfile $outputPath 2>&1
        $LASTEXITCODE | Should -Be 0 -Because ($messages -join "`n")
        $wrapper = Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $wrapper.resources -is [Collections.IDictionary] ? @($wrapper.resources.Values) : @($wrapper.resources)
        $deployment = @($resources | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' })
        $deployment.Count | Should -Be 1
        $deployment[0].properties.parameters.ContainsKey('tags') | Should -Be $explicitNull
        if ($explicitNull) { $deployment[0].properties.parameters.tags.value | Should -BeNullOrEmpty }
    }

    It 'Preserves <case> input behavior using the actual declaration and expression' -ForEach @(
        @{ case = 'explicit null'; valueExpression = 'null'; expected = @{} }
        @{ case = 'empty object'; valueExpression = '{}'; expected = @{} }
        @{ case = 'nonempty object'; valueExpression = "{ purpose: 'synthetic', owner: 'test' }"; expected = @{ purpose = 'synthetic'; owner = 'test' } }
    ) {
        $inputPath = Join-Path $TestDrive "$case.bicepparam"
        $outputPath = Join-Path $TestDrive "$case.json"
        $expression = $forwards[0].Groups['expression'].Value -replace '\btags\b', 'rawTags'
        [IO.File]::WriteAllText($inputPath, "using none`nimport { resourceTagsType } from 'tags-type.bicep'`nvar rawTags resourceTagsType = $valueExpression`nparam effectiveTags = $expression")
        $messages = bicep build-params $inputPath --no-restore --outfile $outputPath 2>&1
        $LASTEXITCODE | Should -Be 0 -Because ($messages -join "`n")
        $actual = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters.effectiveTags.value
        $actual.Count | Should -Be $expected.Count
        foreach ($key in $expected.Keys) { $actual[$key] | Should -BeExactly $expected[$key] }
    }

    It 'Rejects arrays rather than silently normalizing invalid tags' {
        $inputPath = Join-Path $TestDrive 'invalid-tags.bicepparam'
        [IO.File]::WriteAllText($inputPath, "using none`nimport { resourceTagsType } from 'tags-type.bicep'`nvar rawTags resourceTagsType = []`nparam effectiveTags = rawTags")
        $messages = bicep build-params $inputPath --no-restore --outfile (Join-Path $TestDrive 'invalid-tags.json') 2>&1
        $LASTEXITCODE | Should -Not -Be 0
        ($messages -join "`n") | Should -Match 'BCP033'
    }
}
