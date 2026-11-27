BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'replication' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $dependencySource = [regex]::Match($source, '(?ms)^module nestedDependencies\b.*?^}').Value
    $testSource = [regex]::Match($source, '(?ms)^module testDeployment\b.*\z').Value
    $primaryMatch = [regex]::Match($dependencySource, '(?m)^\s+primaryServerName: (?<expression>[^\r\n]+)')
    $replicaMatch = [regex]::Match($testSource, "(?m)^\s+name: (?<expression>'[^\r\n]*namePrefix[^\r\n]+)")
    $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
    if (-not $primaryMatch.Success -or -not $replicaMatch.Success -or -not $serviceMatch.Success) {
        throw 'Missing primary, replica or service identifier in the replication fixture.'
    }
    $expressions = @{
        primary = $primaryMatch.Groups['expression'].Value
        replica = $replicaMatch.Groups['expression'].Value
    }
    $defaults = @{
        subscription = '00000000-0000-4000-8000-000000000001'
        group = 'fixture-one'
        root = 'attempt-one'
        location = 'eastus'
        prefix = 'gci'
        service = $serviceMatch.Groups['value'].Value
    }
    $overrides = @(
        @{}
        @{ subscription = '00000000-0000-4000-8000-000000000002' }
        @{ group = 'fixture-two' }
        @{ root = 'attempt-two' }
        @{ location = 'norwayeast' }
        @{ prefix = ('g' * 100); service = ('s' * 100 + 'a') }
        @{ prefix = ('g' * 100); service = ('s' * 100 + 'b') }
        @{ prefix = ('g' * 100 + 'b'); service = ('s' * 100 + 'a') }
    )
    $parameterSource = @('using none')
    for ($index = 0; $index -lt $overrides.Count; $index++) {
        $values = $defaults.Clone()
        foreach ($key in $overrides[$index].Keys) { $values[$key] = $overrides[$index][$key] }
        foreach ($iteration in @('init', 'idem')) {
            foreach ($role in @('primary', 'replica')) {
                $expression = $expressions[$role].
                Replace('resourceGroup.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)'").
                Replace('subscription().subscriptionId', "'$($values.subscription)'").
                Replace('resourceGroupName', "'$($values.group)'").
                Replace('deployment().name', "'$($values.root)'").
                Replace('resourceLocation', "'$($values.location)'").
                Replace('namePrefix', "'$($values.prefix)'").
                Replace('serviceShort', "'$($values.service)'").
                Replace('iteration', "'$iteration'")
                $parameterSource += "param ${role}${index}${iteration} = $expression"
            }
        }
    }
    $parameterPath = Join-Path $TestDrive 'server-names.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'server-names.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'replication.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $dependencies = @($resources | Where-Object { $_.name -match '-nestedDependencies' })[0]
    $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
}

Describe 'PostgreSQL replication fixture identities' {
    Context '<role> server' -ForEach @(
        @{ role = 'primary' }
        @{ role = 'replica' }
    ) {
        It 'Separates otherwise identical deployments in different subscriptions' {
            $names["${role}0init"].value | Should -Not -Be $names["${role}1init"].value
        }

        It 'Separates deployments in different resource groups' {
            $names["${role}0init"].value | Should -Not -Be $names["${role}2init"].value
        }

        It 'Keeps server identity stable across root attempts, regions and init/idem' {
            $names["${role}0init"].value | Should -BeExactly $names["${role}3init"].value
            $names["${role}0init"].value | Should -BeExactly $names["${role}4init"].value
            foreach ($index in 0..7) {
                $names["${role}${index}init"].value | Should -BeExactly $names["${role}${index}idem"].value
            }
        }

        It 'Meets the 3-63 character server naming rules' {
            foreach ($index in 0..7) {
                $names["${role}${index}init"].value | Should -Match '^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$'
            }
            $names["${role}5init"].value.Length | Should -Be 63
        }

        It 'Keeps full prefix and service inputs distinct after truncation' {
            $names["${role}5init"].value | Should -Not -Be $names["${role}6init"].value
            $names["${role}5init"].value | Should -Not -Be $names["${role}7init"].value
        }

        It 'Passes a scope-qualified name to the intended server' {
            $forwardedName = $role -eq 'primary' ?
                $dependencies.properties.parameters.primaryServerName.value :
                $testModule.properties.parameters.name.value
            $forwardedName | Should -Match 'uniqueString\('
            $forwardedName | Should -Match "parameters\('resourceGroupName'\)"
        }
    }

    It 'Keeps primary and replica identities distinct even after truncation' {
        foreach ($index in 0..7) {
            $names["primary${index}init"].value | Should -Not -Be $names["replica${index}init"].value
        }
    }

    It 'Keeps replication attached to the created primary and preserves serial init/idem' {
        $dependencies.properties.template.outputs.serverResourceId.value | Should -Match '\.outputs\.resourceId\.value'
        $testModule.properties.parameters.sourceServerResourceId.value | Should -Match '\.outputs\.serverResourceId\.value'
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
        $testModule.properties.parameters.createMode |
            Should -BeExactly "[if(equals(createArray('init', 'idem')[copyIndex()], 'init'), createObject('value', 'Replica'), createObject('value', null()))]"
        $testModule.properties.parameters.version.value | Should -BeExactly '17'
        $testModule.properties.parameters.highAvailability.value | Should -BeExactly 'Disabled'
    }
}
