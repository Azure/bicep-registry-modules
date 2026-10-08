Describe 'WAF registry fixture identity' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'waf-aligned' 'main.test.bicep'
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $nameMatch = [regex]::Match($source, '(?ms)^module testDeployment\b.*?\bparams:\s*\{\s*name: (?<expression>[^\r\n]+)')
        $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
        if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw 'Missing registry name or service identifier.' }
        $defaults = @{
            subscription = '00000000-0000-4000-8000-000000000001'
            group = 'fixture-one'
            prefix = 'gci'
            service = $serviceMatch.Groups['value'].Value
            root = 'attempt-one'
            location = 'westus3'
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
                $expression = $nameMatch.Groups['expression'].Value.
                    Replace('resourceGroup.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)'").
                    Replace('deployment().name', "'$($values.root)'").
                    Replace('resourceLocation', "'$($values.location)'").
                    Replace('namePrefix', "'$($values.prefix)'").
                    Replace('serviceShort', "'$($values.service)'").
                    Replace('iteration', "'$iteration'")
                $parameterSource += "param case${index}${iteration} = $expression"
            }
        }
        $parameterPath = Join-Path $TestDrive 'registry-names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'registry-names.json'
        $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        $fixtureOutput = Join-Path $TestDrive 'waf-aligned.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
        $parameters = $testModule.properties.parameters
        $dependencyIds = @{}
        $dependencyReferences = @{}
        foreach ($dependencyName in @('nestedDependencies', 'diagnosticDependencies')) {
            $dependency = @($resources | Where-Object { $_.name -match "-$dependencyName" })[0]
            if ($template.resources -is [System.Collections.IDictionary]) {
                $dependencyIds[$dependencyName] = $dependencyName
                $dependencyReferences[$dependencyName] = "reference('$dependencyName')"
            } else {
                $resourceId = "extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('resourceGroupName')), 'Microsoft.Resources/deployments', $($dependency.name.Trim('[', ']')))"
                $dependencyIds[$dependencyName] = "[$resourceId]"
                $dependencyReferences[$dependencyName] = "reference($resourceId, '$($dependency.apiVersion)')"
            }
        }
        $registryResources = $testModule.properties.template.resources
        $registryResources = $registryResources -is [System.Collections.IDictionary] ? @($registryResources.Values) : @($registryResources)
        $registry = @($registryResources | Where-Object type -EQ 'Microsoft.ContainerRegistry/registries')[0]
    }

    It 'Separates otherwise identical deployments in different subscriptions' {
        $names.case0init.value | Should -Not -Be $names.case1init.value
    }

    It 'Separates deployments in different resource groups' {
        $names.case0init.value | Should -Not -Be $names.case2init.value
    }

    It 'Keeps identity stable across roots, regions and serial init/idem' {
        $names.case0init.value | Should -BeExactly $names.case3init.value
        $names.case0init.value | Should -BeExactly $names.case4init.value
        foreach ($index in 0..($overrides.Count - 1)) {
            $names["case${index}init"].value | Should -BeExactly $names["case${index}idem"].value
        }
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
        $parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
    }

    It 'Meets registry-name constraints for short and long inputs' {
        foreach ($index in 0..($overrides.Count - 1)) {
            foreach ($iteration in @('init', 'idem')) {
                $names["case${index}${iteration}"].value | Should -Match '^[a-zA-Z0-9]{5,50}$'
            }
        }
        $names.case5init.value.Length | Should -Be 50
    }

    It 'Retains differences beyond the readable prefix and service-name bounds' {
        $names.case5init.value | Should -Not -Be $names.case6init.value
        $names.case5init.value | Should -Not -Be $names.case7init.value
    }

    It 'Passes the scope-qualified identity to the registry in its owning group' {
        $parameters.name.value | Should -Match "parameters\('resourceGroupName'\)"
        $parameters.name.value | Should -Match 'uniqueString\('
        $testModule.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
        $registry.name | Should -BeExactly "[parameters('name')]"
    }

    It 'Preserves WAF settings, replication selection, diagnostics and private endpoint dependencies' {
        $parameters.acrAdminUserEnabled.value | Should -BeFalse
        $parameters.acrSku.value | Should -BeExactly 'Premium'
        $parameters.autoGeneratedDomainNameLabelScope.value | Should -BeExactly 'NoReuse'
        $parameters.roleAssignmentMode.value | Should -BeExactly 'AbacRepositoryPermissions'
        $parameters.exportPolicyStatus.value | Should -BeExactly 'enabled'
        $parameters.azureADAuthenticationAsArmPolicyStatus.value | Should -BeExactly 'disabled'
        $parameters.softDeletePolicyStatus.value | Should -BeExactly 'disabled'
        $parameters.softDeletePolicyDays.value | Should -Be 7
        $parameters.quarantinePolicyStatus.value | Should -BeExactly 'enabled'
        $parameters.trustPolicyStatus.value | Should -BeExactly 'disabled'
        @($parameters.replications.value).Count | Should -Be 1
        $parameters.replications.value[0].name | Should -BeExactly "[$($dependencyReferences.nestedDependencies).outputs.replicationRegionName.value]"
        $parameters.replications.value[0].location | Should -BeExactly $parameters.replications.value[0].name
        @($parameters.diagnosticSettings.value).Count | Should -Be 1
        $parameters.diagnosticSettings.value[0].workspaceResourceId | Should -BeExactly "[$($dependencyReferences.diagnosticDependencies).outputs.logAnalyticsWorkspaceResourceId.value]"
        @($parameters.privateEndpoints.value).Count | Should -Be 1
        $parameters.privateEndpoints.value[0].subnetResourceId | Should -BeExactly "[$($dependencyReferences.nestedDependencies).outputs.subnetResourceId.value]"
        $parameters.privateEndpoints.value[0].privateDnsZoneGroup.privateDnsZoneGroupConfigs[0].privateDnsZoneResourceId |
            Should -BeExactly "[$($dependencyReferences.nestedDependencies).outputs.privateDNSZoneResourceId.value]"
        $testModule.dependsOn | Should -Contain $dependencyIds.nestedDependencies
        $testModule.dependsOn | Should -Contain $dependencyIds.diagnosticDependencies
    }
}
