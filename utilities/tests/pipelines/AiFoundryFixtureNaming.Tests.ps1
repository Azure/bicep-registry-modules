param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

$script:repoRootPath = $repoRootPath

Describe 'AI Foundry fixture resource naming' {
    BeforeAll {
        $fixtureRoot = Join-Path $repoRootPath 'avm' 'ptn' 'ai-ml' 'ai-foundry' 'tests' 'e2e'
        $fixtures = @(Get-ChildItem -LiteralPath $fixtureRoot -Recurse -File -Filter 'main.test.bicep' | Sort-Object FullName)
        $prefixes = @('x', 'gci', 'gcix', 'longprefix12345')
        $parameterLines = @('using none')
        $script:cases = @()

        for ($fixtureIndex = 0; $fixtureIndex -lt $fixtures.Count; $fixtureIndex++) {
            $fixture = $fixtures[$fixtureIndex]
            $source = Get-Content -LiteralPath $fixture.FullName -Raw
            $serviceShort = [regex]::Match($source, "(?m)^param serviceShort string = '([^']+)'").Groups[1].Value
            $nameExpression = [regex]::Match($source, '(?m)^var workloadName = (.+)').Groups[1].Value.Trim()
            if ([string]::IsNullOrEmpty($serviceShort) -or [string]::IsNullOrEmpty($nameExpression)) {
                throw "Missing naming inputs in [$($fixture.FullName)]."
            }

            $dependencyPath = Join-Path $fixture.DirectoryName 'dependencies.bicep'
            $dependencyExpressions = @()
            if (Test-Path -LiteralPath $dependencyPath) {
                $dependencySource = Get-Content -LiteralPath $dependencyPath -Raw
                $dependencyExpressions = @(
                    [regex]::Matches($dependencySource, "(?s)resource \w+ '[^']+' = \{\s*name:\s*(?<expression>[^\r\n]+)") |
                    ForEach-Object { $_.Groups['expression'].Value.Trim() }
                )
            }

            for ($prefixIndex = 0; $prefixIndex -lt $prefixes.Count; $prefixIndex++) {
                $prefix = $prefixes[$prefixIndex]
                $key = "fixture${fixtureIndex}prefix${prefixIndex}"
                $expression = $nameExpression.Replace('namePrefix', "'$prefix'").Replace('serviceShort', "'$serviceShort'")
                $parameterLines += "var ${key}Workload = $expression"
                $parameterLines += "param $key = ${key}Workload"
                $dependencyKeys = @(
                    for ($dependencyIndex = 0; $dependencyIndex -lt $dependencyExpressions.Count; $dependencyIndex++) {
                        $dependencyKey = "${key}dependency${dependencyIndex}"
                        $dependencyExpression = $dependencyExpressions[$dependencyIndex].Replace('workloadName', "${key}Workload")
                        $parameterLines += "param $dependencyKey = $dependencyExpression"
                        $dependencyKey
                    }
                )
                $script:cases += @{
                    key            = $key
                    fixture        = $fixture.Directory.Name
                    prefix         = $prefix
                    inputName      = "$prefix$serviceShort"
                    dependencyKeys = $dependencyKeys
                }
            }
        }

        $parameterPath = Join-Path $TestDrive 'names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'names.json'
        $parameterLines -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Generates 12-character alphanumeric workload names for every example and prefix length' {
        $script:cases.Count | Should -BeGreaterThan 0
        foreach ($case in $script:cases) {
            $script:names[$case.key].value | Should -Match '^[a-z0-9]{12}$' -Because "[$($case.fixture)] with prefix [$($case.prefix)] must not introduce spaces."
        }
    }

    It 'Keeps names unchanged when the input already meets the minimum length' {
        foreach ($case in $script:cases | Where-Object { $_.inputName.Length -ge 12 }) {
            $script:names[$case.key].value | Should -BeExactly $case.inputName.Substring(0, 12)
        }
    }

    It 'Does not introduce whitespace into dependency resource names' {
        $dependencyCases = @($script:cases | Where-Object { $_.dependencyKeys.Count -gt 0 })
        $dependencyCases.Count | Should -BeGreaterThan 0
        foreach ($case in $dependencyCases) {
            foreach ($key in $case.dependencyKeys) {
                $script:names[$key].value | Should -Not -Match '\s' -Because "[$($case.fixture)] dependencies must use valid resource names."
            }
        }
    }

    It 'Generates the expected virtual network name for the failing CI prefix' {
        $case = $script:cases | Where-Object { $_.fixture -eq 'waf-aligned' -and $_.prefix -eq 'gci' }
        $case | Should -Not -BeNullOrEmpty
        $script:names[$case.key].value | Should -BeExactly '0gcifndrywaf'
        $dependencyNames = @($case.dependencyKeys | ForEach-Object { $script:names[$_].value })
        $dependencyNames | Should -Contain 'vnet-0gcifndrywaf'
    }
}
