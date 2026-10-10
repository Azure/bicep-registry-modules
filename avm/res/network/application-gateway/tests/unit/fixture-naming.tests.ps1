BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $roleBlock = [regex]::Match($source, '(?ms)^      roleAssignments: \[(?<value>.*?)^      \]')
    $assignmentBlocks = [regex]::Matches($roleBlock.Groups['value'].Value, '(?ms)^        \{(?<value>.*?)^        \}')
    $nameExpressions = @($assignmentBlocks | ForEach-Object {
            $match = [regex]::Match($_.Groups['value'].Value, '(?ms)^\s+name: (?<expression>.*?)(?=^\s+\w+:|\z)')
            if ($match.Success) { $match.Groups['expression'].Value.Trim() }
        })
    $gatewayName = [regex]::Match($source, '(?m)^var appGWName = (?<expression>[^\r\n]+)')
    $gatewayScope = [regex]::Match($source, '(?m)^var appGWExpectedResourceID = (?<expression>[^\r\n]+)')
    if ($assignmentBlocks.Count -ne 3 -or $nameExpressions.Count -ne 2 -or
        -not $gatewayName.Success -or -not $gatewayScope.Success) {
        throw 'Missing max fixture role-assignment names or gateway scope expressions.'
    }

    $scenarios = @(
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; service = 'nagmax'; principal = '00000000-0000-4000-8000-000000000003'; root = 'attempt-one'; location = 'eastus' }
        @{ subscription = '00000000-0000-4000-8000-000000000002'; group = 'fixture-one'; service = 'nagmax'; principal = '00000000-0000-4000-8000-000000000003'; root = 'attempt-one'; location = 'eastus' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-two'; service = 'nagmax'; principal = '00000000-0000-4000-8000-000000000003'; root = 'attempt-one'; location = 'eastus' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; service = 'nagsecond'; principal = '00000000-0000-4000-8000-000000000003'; root = 'attempt-one'; location = 'eastus' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; service = 'nagmax'; principal = '00000000-0000-4000-8000-000000000004'; root = 'attempt-one'; location = 'eastus' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; service = 'nagmax'; principal = '00000000-0000-4000-8000-000000000003'; root = 'attempt-two'; location = 'eastus' }
        @{ subscription = '00000000-0000-4000-8000-000000000001'; group = 'fixture-one'; service = 'nagmax'; principal = '00000000-0000-4000-8000-000000000003'; root = 'attempt-one'; location = 'norwayeast' }
    )
    $parameterSource = @('using none')
    for ($scenarioIndex = 0; $scenarioIndex -lt $scenarios.Count; $scenarioIndex++) {
        $scenario = $scenarios[$scenarioIndex]
        foreach ($iteration in @('init', 'idem')) {
            $suffix = "case${scenarioIndex}${iteration}"
            $nameExpression = $gatewayName.Groups['expression'].Value.
            Replace('namePrefix', "'gci'").Replace('serviceShort', "'$($scenario.service)'")
            $scopeExpression = $gatewayScope.Groups['expression'].Value.
            Replace('resourceGroup.id', "'/subscriptions/$($scenario.subscription)/resourceGroups/$($scenario.group)'").
            Replace('appGWName', "appGWName$suffix")
            $parameterSource += "var appGWName$suffix = $nameExpression"
            $parameterSource += "var appGWExpectedResourceID$suffix = $scopeExpression"
            for ($assignmentIndex = 0; $assignmentIndex -lt $nameExpressions.Count; $assignmentIndex++) {
                $expression = $nameExpressions[$assignmentIndex].
                Replace('appGWExpectedResourceID', "appGWExpectedResourceID$suffix").
                Replace('nestedDependencies.outputs.managedIdentityPrincipalId', "'$($scenario.principal)'").
                Replace('namePrefix', "'gci'").
                Replace('serviceShort', "'$($scenario.service)'").
                Replace('deployment().name', "'$($scenario.root)'").
                Replace('resourceLocation', "'$($scenario.location)'").
                Replace('iteration', "'$iteration'")
                $parameterSource += "param role${assignmentIndex}$suffix = $expression"
            }
        }
    }
    $parameterPath = Join-Path $TestDrive 'role-assignment-names.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'role-assignment-names.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'max.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $testModule = @($resources | Where-Object {
            $_.properties.parameters -is [System.Collections.IDictionary] -and $_.properties.parameters.Contains('roleAssignments')
        })[0]
    $dependencies = @($resources | Where-Object {
            $_.properties.parameters -is [System.Collections.IDictionary] -and $_.properties.parameters.Contains('managedIdentityName')
        })[0]
    $assignments = $testModule.properties.parameters.roleAssignments.value
    $moduleResources = $testModule.properties.template.resources
    $moduleResources = $moduleResources -is [System.Collections.IDictionary] ? @($moduleResources.Values) : @($moduleResources)
    $roleResource = @($moduleResources | Where-Object type -EQ 'Microsoft.Authorization/roleAssignments')[0]
}

Describe 'Max fixture role-assignment identity' {
    Context '<role> explicit assignment' -ForEach @(
        @{ role = 'Network Contributor'; assignmentIndex = 0 }
        @{ role = 'Contributor'; assignmentIndex = 1 }
    ) {
        It 'Separates otherwise identical deployments in different subscriptions' {
            $names["role${assignmentIndex}case0init"].value | Should -Not -Be $names["role${assignmentIndex}case1init"].value
        }

        It 'Separates deployments in different resource groups' {
            $names["role${assignmentIndex}case0init"].value | Should -Not -Be $names["role${assignmentIndex}case2init"].value
        }

        It 'Separates different gateway resources in the same resource group' {
            $names["role${assignmentIndex}case0init"].value | Should -Not -Be $names["role${assignmentIndex}case3init"].value
        }

        It 'Separates a recreated managed identity principal at the same target scope' {
            $names["role${assignmentIndex}case0init"].value | Should -Not -Be $names["role${assignmentIndex}case4init"].value
        }

        It 'Preserves assignment identity across retries, regions and init/idem for an unchanged principal' {
            $names["role${assignmentIndex}case0init"].value | Should -BeExactly $names["role${assignmentIndex}case5init"].value
            $names["role${assignmentIndex}case0init"].value | Should -BeExactly $names["role${assignmentIndex}case6init"].value
            foreach ($scenarioIndex in 0..6) {
                $names["role${assignmentIndex}case${scenarioIndex}init"].value |
                    Should -BeExactly $names["role${assignmentIndex}case${scenarioIndex}idem"].value
            }
        }

        It 'Produces valid GUID resource names' {
            foreach ($scenarioIndex in 0..6) {
                $names["role${assignmentIndex}case${scenarioIndex}init"].value |
                    Should -Match '^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$'
            }
        }

        It 'Forwards the actual scope and principal into the compiled explicit name' {
            $assignments[$assignmentIndex].name | Should -Match '^\[guid\('
            $assignments[$assignmentIndex].name | Should -Match "variables\('appGWExpectedResourceID'\)"
            $assignments[$assignmentIndex].name | Should -Match '\.outputs\.managedIdentityPrincipalId\.value'
        }
    }

    It 'Keeps the two explicit assignments distinct for the same scope and principal' {
        foreach ($scenarioIndex in 0..6) {
            $names["role0case${scenarioIndex}init"].value | Should -Not -Be $names["role1case${scenarioIndex}init"].value
        }
    }

    It 'Preserves both explicit examples, the default Reader name and all role definitions and principal types' {
        $assignments.Count | Should -Be 3
        $assignments[0].Contains('name') | Should -BeTrue
        $assignments[1].Contains('name') | Should -BeTrue
        $assignments[2].Contains('name') | Should -BeFalse
        $assignments[0].roleDefinitionIdOrName | Should -BeExactly 'Network Contributor'
        $assignments[1].roleDefinitionIdOrName | Should -BeExactly 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        $assignments[2].roleDefinitionIdOrName |
            Should -BeExactly "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')]"
        foreach ($assignment in $assignments) {
            $assignment.principalType | Should -BeExactly 'ServicePrincipal'
        }
    }

    It 'Preserves the dependency principal, deployment ordering and gateway assignment scope' {
        $dependencies.properties.template.outputs.managedIdentityPrincipalId.value | Should -Match '\.principalId'
        foreach ($assignment in $assignments) {
            $assignment.principalId | Should -BeExactly $assignments[0].principalId
            $assignment.principalId | Should -Match '\.outputs\.managedIdentityPrincipalId\.value'
        }
        @($testModule.dependsOn | Where-Object { $_ -match '-nestedDependencies' }).Count | Should -Be 1
        $roleResource.scope | Should -BeExactly "[resourceId('Microsoft.Network/applicationGateways', parameters('name'))]"
        $roleResource.name | Should -Match 'coalesce\(tryGet'
        $roleResource.name | Should -Match 'principalId.*roleDefinitionId'
    }

    It 'Preserves serial idempotency, region selection and WAF scenario coverage' {
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
        $template.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
        $testModule.properties.parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
        ($testModule.properties.parameters.availabilityZones.value -join ',') | Should -BeExactly '1,2,3'
        $testModule.properties.parameters.sku.value | Should -BeExactly 'WAF_v2'
        $testModule.properties.parameters.managedIdentities.value.userAssignedResourceIds[0] |
            Should -Match '\.outputs\.managedIdentityResourceId\.value'
    }
}
