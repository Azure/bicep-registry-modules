Describe 'API Management fixture identities' {
    Context '<scenario> service' -ForEach @(
        @{ scenario = 'v2min'; sku = 'BasicV2'; developerPortal = $true }
        @{ scenario = 'developerSku'; sku = 'Developer'; developerPortal = $true }
        @{ scenario = 'consumptionSku'; sku = 'Consumption'; developerPortal = $false }
        @{ scenario = 'defaults'; sku = ''; developerPortal = $false }
        @{ scenario = 'waf-aligned'; sku = ''; developerPortal = $false }
        @{ scenario = 'max'; sku = ''; developerPortal = $false }
        @{ scenario = 'v2max'; sku = 'PremiumV2'; developerPortal = $false }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $scenario 'main.test.bicep'
            $source = Get-Content -LiteralPath $fixturePath -Raw
            $nameMatch = [regex]::Match($source, '(?ms)^module testDeployment\b.*?\bparams:\s*\{\s*name: (?<expression>[^\r\n]+)')
            $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw "Missing $scenario service name or identifier." }
            $nameExpression = $nameMatch.Groups['expression'].Value
            $usesNameVariable = $nameExpression -ceq 'apimName'
            if ($usesNameVariable) {
                $variableMatch = [regex]::Match($source, '(?m)^var apimName = (?<expression>[^\r\n]+)')
                if (-not $variableMatch.Success) { throw "Missing $scenario apimName expression." }
                $nameExpression = $variableMatch.Groups['expression'].Value
            }
            $expressions = [ordered]@{ '' = $nameExpression }
            if ($scenario -eq 'max') {
                $hostnameMatch = [regex]::Match($source, '(?m)^\s*hostName: (?<expression>[^\r\n]+)')
                $workspaceMatch = [regex]::Match($source, '(?m)^var workspace1Name = (?<expression>[^\r\n]+)')
                $gatewayMatches = [regex]::Matches($source, '(?m)^\s*gateway:\s*\{\s*name: (?<expression>[^\r\n]+)')
                if (-not $hostnameMatch.Success -or -not $workspaceMatch.Success -or $gatewayMatches.Count -ne 2) {
                    throw 'Missing max hostname or workspace gateway expressions.'
                }
                $expressions.hostname = $hostnameMatch.Groups['expression'].Value.Replace('apimName', "($nameExpression)")
                for ($index = 0; $index -lt $gatewayMatches.Count; $index++) {
                    $expressions["gateway$index"] = $gatewayMatches[$index].Groups['expression'].Value.
                        Replace('apimName', "($nameExpression)").
                        Replace('workspace1Name', $workspaceMatch.Groups['expression'].Value)
                }
            }
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
                @{ prefix = ''; service = 'a' }
            )
            $parameterSource = @('using none')
            for ($index = 0; $index -lt $overrides.Count; $index++) {
                $values = $defaults.Clone()
                foreach ($key in $overrides[$index].Keys) { $values[$key] = $overrides[$index][$key] }
                foreach ($iteration in @('init', 'idem')) {
                    foreach ($suffix in $expressions.Keys) {
                        $expression = $expressions[$suffix].
                            Replace('resourceGroup.id', "'/subscriptions/$($values.subscription)/resourceGroups/$($values.group)'").
                            Replace('deployment().name', "'$($values.root)'").
                            Replace('secondaryEnforcedLocation', "'$($values.location)'").
                            Replace('enforcedLocationRegion2', "'$($values.location)'").
                            Replace('enforcedLocation', "'$($values.location)'").
                            Replace('locationRegion2', "'$($values.location)'").
                            Replace('resourceLocation', "'$($values.location)'").
                            Replace('namePrefix', "'$($values.prefix)'").
                            Replace('serviceShort', "'$($values.service)'").
                            Replace('iteration', "'$iteration'")
                        $parameterSource += "param case${index}${iteration}${suffix} = $expression"
                    }
                }
            }
            $parameterPath = Join-Path $TestDrive "$scenario-names.bicepparam"
            $parameterOutput = Join-Path $TestDrive "$scenario-names.json"
            $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
            $fixtureOutput = Join-Path $TestDrive "$scenario.json"
            $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
            $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
            $parameters = $testModule.properties.parameters
            $nested = $testModule.properties.template
            $nestedResources = $nested.resources -is [System.Collections.IDictionary] ? @($nested.resources.Values) : @($nested.resources)
            $service = @($nestedResources | Where-Object type -EQ 'Microsoft.ApiManagement/service')[0]
            $groupId = $template.resources -is [System.Collections.IDictionary] ?
                'resourceGroup' :
                "[subscriptionResourceId('Microsoft.Resources/resourceGroups', parameters('resourceGroupName'))]"
        }

        It 'Separates otherwise identical deployments in different subscriptions' {
            foreach ($suffix in $expressions.Keys) {
                $names["case0init$suffix"].value | Should -Not -Be $names["case1init$suffix"].value
            }
        }

        It 'Separates deployments in different resource groups' {
            foreach ($suffix in $expressions.Keys) {
                $names["case0init$suffix"].value | Should -Not -Be $names["case2init$suffix"].value
            }
        }

        It 'Keeps identity stable across roots, regions and serial init/idem' {
            foreach ($suffix in $expressions.Keys) {
                $names["case0init$suffix"].value | Should -BeExactly $names["case3init$suffix"].value
                $names["case0init$suffix"].value | Should -BeExactly $names["case4init$suffix"].value
                foreach ($index in 0..($overrides.Count - 1)) {
                    $names["case${index}init$suffix"].value | Should -BeExactly $names["case${index}idem$suffix"].value
                }
            }
            $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
            $testModule.copy.mode | Should -BeExactly 'serial'
            $testModule.copy.batchSize | Should -Be 1
        }

        It 'Meets service-name constraints for short and long inputs' {
            foreach ($index in 0..($overrides.Count - 1)) {
                foreach ($iteration in @('init', 'idem')) {
                    $names["case${index}${iteration}"].value | Should -Match '^[a-zA-Z](?:[a-zA-Z0-9-]{0,48}[a-zA-Z0-9])?$'
                    if ($scenario -eq 'max') {
                        $names["case${index}${iteration}hostname"].value | Should -BeExactly "$($names["case${index}${iteration}"].value).azure-api.net"
                        $names["case${index}${iteration}hostname"].value.Split('.')[0].Length | Should -BeLessOrEqual 63
                        foreach ($gateway in 0..1) {
                            $names["case${index}${iteration}gateway$gateway"].value | Should -Match '^[a-zA-Z](?:[a-zA-Z0-9-]{0,43}[a-zA-Z0-9])?$'
                        }
                    }
                }
            }
            $names.case5init.value.Length | Should -Be ($scenario -eq 'max' ? 31 : 50)
            if ($scenario -eq 'max') {
                $names.case5initgateway0.value.Length | Should -Be 45
                $names.case5initgateway1.value.Length | Should -Be 45
            }
        }

        It 'Retains differences beyond the readable prefix and service-name bounds' {
            foreach ($suffix in $expressions.Keys) {
                $names["case5init$suffix"].value | Should -Not -Be $names["case6init$suffix"].value
                $names["case5init$suffix"].value | Should -Not -Be $names["case7init$suffix"].value
            }
        }

        It 'Passes the scope-qualified identity to the service in its owning group' {
            $compiledName = $parameters.name.value
            if ($usesNameVariable) {
                $parameters.name.value | Should -BeExactly "[variables('apimName')]"
                $compiledName = $template.variables.apimName
            }
            $compiledName | Should -Match "parameters\('resourceGroupName'\)"
            $compiledName | Should -Match 'uniqueString\('
            $testModule.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
            $testModule.dependsOn | Should -Contain $groupId
            $service.name | Should -BeExactly "[parameters('name')]"
            $nested.outputs.name.value | Should -BeExactly "[parameters('name')]"
            $nested.outputs.resourceId.value | Should -BeExactly "[resourceId('Microsoft.ApiManagement/service', parameters('name'))]"
            if ($scenario -eq 'waf-aligned') {
                $names.case0init.value | Should -Match '^gciapiswaf002-[a-z0-9]{13}$'
            } elseif ($scenario -eq 'max') {
                $names.case0init.value | Should -Match '^gciapismax001-[a-z0-9]{13}$'
            } elseif ($scenario -eq 'v2max') {
                $names.case0init.value | Should -Match '^gciapiv2max002-[a-z0-9]{13}$'
            }
        }

        It 'Preserves SKU, publisher, portal and inherited security settings' {
            $expectedParameters = @('name', 'publisherEmail', 'publisherName')
            if ($sku) {
                $expectedParameters += 'sku'
                $parameters.sku.value | Should -BeExactly $sku
            } else {
                $parameters.Contains('sku') | Should -BeFalse
                $nested.parameters.sku.defaultValue | Should -BeExactly 'Premium'
            }
            if ($developerPortal) {
                $expectedParameters += 'enableDeveloperPortal'
                $parameters.enableDeveloperPortal.value | Should -BeTrue
            } else {
                $parameters.Contains('enableDeveloperPortal') | Should -BeFalse
            }
            if ($scenario -eq 'waf-aligned') {
                $expectedParameters += @(
                    'additionalLocations', 'customProperties', 'apis', 'apiVersionSets', 'authorizationServers',
                    'backends', 'caches', 'diagnosticSettings', 'identityProviders', 'loggers', 'managedIdentities',
                    'namedValues', 'policies', 'portalsettings', 'products', 'subscriptions', 'virtualNetworkType',
                    'tags', 'publicNetworkAccess', 'privateEndpoints'
                )
                $template.variables.enforcedLocation | Should -BeExactly 'germanywestcentral'
                $template.variables.secondaryEnforcedLocation | Should -BeExactly 'northeurope'
                $parameters.additionalLocations.value | Should -HaveCount 1
                $additionalLocation = $parameters.additionalLocations.value[0]
                $additionalLocation.location | Should -BeExactly "[variables('secondaryEnforcedLocation')]"
                $additionalLocation.sku.name | Should -BeExactly 'Premium'
                $additionalLocation.sku.capacity | Should -Be 3
                $additionalLocation.availabilityZones -join ',' | Should -BeExactly '1,2,3'
                $additionalLocation.disableGateway | Should -BeFalse
                $parameters.customProperties.value.Count | Should -Be 15
                foreach ($property in $parameters.customProperties.value.GetEnumerator()) {
                    $property.Value | Should -BeExactly (
                        $property.Key -eq 'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2' ? 'True' : 'False'
                    )
                }
                $parameters.backends.value[0].tls.validateCertificateChain | Should -BeTrue
                $parameters.backends.value[0].tls.validateCertificateName | Should -BeTrue
                $parameters.managedIdentities.value.systemAssigned | Should -BeTrue
                $parameters.managedIdentities.value.userAssignedResourceIds | Should -HaveCount 1
                $parameters.managedIdentities.value.userAssignedResourceIds[0] | Should -Match '\.outputs\.managedIdentityResourceId\.value'
                $parameters.portalsettings.value.name -join ',' | Should -BeExactly 'signin,signup'
                foreach ($portal in $parameters.portalsettings.value) { $portal.properties.enabled | Should -BeFalse }
                $parameters.namedValues.value[0].secret | Should -BeTrue
                $parameters.virtualNetworkType.value | Should -BeExactly 'None'
                $parameters.publicNetworkAccess | Should -BeExactly "[if(equals(createArray('init', 'idem')[copyIndex()], 'init'), createObject('value', 'Enabled'), createObject('value', null()))]"
                $parameters.privateEndpoints.value | Should -HaveCount 1
                $endpoint = $parameters.privateEndpoints.value[0]
                $endpoint.subnetResourceId | Should -Match '\.outputs\.subnetResourceId\.value'
                $endpoint.privateDnsZoneGroup.privateDnsZoneGroupConfigs[0].privateDnsZoneResourceId | Should -Match '\.outputs\.privateDNSZoneResourceId\.value'
                @($testModule.dependsOn | Where-Object { $_ -match 'nestedDependencies' }) | Should -HaveCount 1
                @($testModule.dependsOn | Where-Object { $_ -match 'diagnosticDependencies' }) | Should -HaveCount 1
            } elseif ($scenario -in @('max', 'v2max')) {
                $expectedParameters += @(
                    'location', 'apis', 'apiVersionSets', 'authorizationServers', 'backends', 'caches',
                    'diagnosticSettings', 'identityProviders', 'loggers', 'managedIdentities', 'namedValues',
                    'policies', 'products', 'publicNetworkAccess', 'roleAssignments', 'subnetResourceId',
                    'subscriptions', 'tags', 'virtualNetworkType'
                )
                $parameters.name.value | Should -BeExactly "[variables('apimName')]"
                $parameters.location.value | Should -BeExactly "[variables('enforcedLocation')]"
                $parameters.virtualNetworkType.value | Should -BeExactly 'External'
                $parameters.publicNetworkAccess.value | Should -BeExactly 'Enabled'
                $parameters.subnetResourceId.value | Should -Match '\.outputs\.subnetResourceIdRegion1\.value'
                $parameters.Contains('privateEndpoints') | Should -BeFalse
                $parameters.managedIdentities.value.systemAssigned | Should -BeTrue
                $parameters.managedIdentities.value.userAssignedResourceIds | Should -HaveCount 1
                $parameters.managedIdentities.value.userAssignedResourceIds[0] | Should -Match '\.outputs\.managedIdentityResourceId\.value'
                $parameters.roleAssignments.value | Should -HaveCount 3
                foreach ($assignment in $parameters.roleAssignments.value) {
                    $assignment.principalType | Should -BeExactly 'ServicePrincipal'
                    $assignment.principalId | Should -Match '\.outputs\.managedIdentityPrincipalId\.value'
                }
                $parameters.backends.value[1].pool.services[0].id | Should -Match "variables\('apimName'\)"
                if ($scenario -eq 'max') {
                    $expectedParameters += @('additionalLocations', 'hostnameConfigurations', 'lock', 'portalsettings', 'serviceDiagnostics', 'workspaces')
                    $template.variables.enforcedLocation | Should -BeExactly 'germanywestcentral'
                    $template.parameters.locationRegion2.defaultValue | Should -BeExactly 'westus'
                    $parameters.additionalLocations.value | Should -HaveCount 1
                    $parameters.additionalLocations.value[0].location | Should -BeExactly "[parameters('locationRegion2')]"
                    $parameters.additionalLocations.value[0].sku.capacity | Should -Be 1
                    $parameters.hostnameConfigurations.value | Should -BeExactly "[variables('hostnameConfigurationsWithReadOnlyField')]"
                    $hostname = $template.variables.hostnameConfigurationsWithReadOnlyField[0]
                    $hostname.hostName | Should -BeExactly "[format('{0}.azure-api.net', variables('apimName'))]"
                    $hostname.certificateSource | Should -BeExactly 'BuiltIn'
                    $hostname.certificateStatus | Should -BeExactly 'In-progress'
                    $service.properties.hostnameConfigurations | Should -Match "'hostName'"
                    $service.properties.hostnameConfigurations | Should -Not -Match "'certificateStatus'"
                    $parameters.workspaces.value | Should -HaveCount 2
                    foreach ($workspace in $parameters.workspaces.value) {
                        $workspace.gateway.name | Should -Match "variables\('apimName'\)"
                        $workspace.gateway.capacity | Should -Be 1
                    }
                    $parameters.workspaces.value[0].gateway.virtualNetworkType | Should -BeExactly 'None'
                    $parameters.workspaces.value[1].gateway.virtualNetworkType | Should -BeExactly 'External'
                    $parameters.workspaces.value[1].gateway.subnetResourceId | Should -Match '\.outputs\.workspaceGatewaySubnetResourceId\.value'
                } else {
                    $expectedParameters += @('availabilityZones', 'restore')
                    $template.variables.enforcedLocation | Should -BeExactly 'norwayeast'
                    $template.variables.enforcedLocationRegion2 | Should -BeExactly 'canadacentral'
                    $parameters.availabilityZones.value | Should -BeNullOrEmpty
                    $parameters.restore.value | Should -BeFalse
                }
            }
            ($parameters.Keys | Sort-Object) -join ',' | Should -BeExactly (($expectedParameters | Sort-Object) -join ',')
            $parameters.publisherEmail.value | Should -BeExactly 'apimgmt-noreply@mail.windowsazure.com'
            $parameters.publisherName.value | Should -BeExactly "[format('{0}-az-amorg-x-001', parameters('namePrefix'))]"
            $service.sku.name | Should -BeExactly "[parameters('sku')]"
            $nested.parameters.skuCapacity.defaultValue | Should -Be 3
            $nested.parameters.location.defaultValue | Should -BeExactly '[resourceGroup().location]'
            $nested.parameters.restore.defaultValue | Should -BeFalse
            $nested.parameters.virtualNetworkType.defaultValue | Should -BeExactly 'None'
        }
    }
}

Describe 'API Management maximum fixture role names' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
        $script:apimRoleSource = Get-Content -LiteralPath $fixturePath -Raw
        $serviceBlock = [regex]::Match($script:apimRoleSource, '(?ms)^      roleAssignments:\s*\[(?<assignments>.*?)^      \]')
        $workspaceBlock = [regex]::Match($script:apimRoleSource, '(?ms)^          roleAssignments:\s*\[(?<assignments>.*?)^          \]')
        $namePattern = '(?s)\{\s*name:\s*(?<expression>.*?)\s+roleDefinitionIdOrName:'
        $serviceMatches = [regex]::Matches($serviceBlock.Groups['assignments'].Value, $namePattern)
        $workspaceMatches = [regex]::Matches($workspaceBlock.Groups['assignments'].Value, $namePattern)
        $serviceMatch = [regex]::Match($script:apimRoleSource, "(?m)^param serviceShort string = '(?<value>[^']+)'")
        $workspaceMatch = [regex]::Match($script:apimRoleSource, "(?m)^var workspace1Name = '(?<value>[^']+)'")
        if (-not $serviceBlock.Success -or -not $workspaceBlock.Success -or
            $serviceMatches.Count -ne 2 -or $workspaceMatches.Count -ne 2 -or
            -not $serviceMatch.Success -or -not $workspaceMatch.Success) {
            throw 'Expected two explicit service names, two workspace names and their fixture identifiers.'
        }
        $script:apimRoleExpressions = @((@($serviceMatches) + @($workspaceMatches)) |
                ForEach-Object { $_.Groups['expression'].Value.Trim() })
        $defaults = @{
            subscription = '00000000-0000-4000-8000-000000000001'
            group = 'fixture-one'
            principal = '00000000-0000-4000-8000-000000000003'
            serviceName = 'fixture-apim-one'
            workspace = $workspaceMatch.Groups['value'].Value
            prefix = 'gci'
            service = $serviceMatch.Groups['value'].Value
        }
        $script:apimRoleScenarios = @(
            @{}
            @{ subscription = '00000000-0000-4000-8000-000000000002' }
            @{ group = 'fixture-two' }
            @{ serviceName = 'fixture-apim-two' }
            @{ workspace = 'workspace-two' }
            @{ principal = '00000000-0000-4000-8000-000000000004' }
        )
        $parameterSource = @('using none')
        for ($scopeIndex = 0; $scopeIndex -lt $script:apimRoleScenarios.Count; $scopeIndex++) {
            $values = $defaults.Clone()
            foreach ($key in $script:apimRoleScenarios[$scopeIndex].Keys) {
                $values[$key] = $script:apimRoleScenarios[$scopeIndex][$key]
            }
            $groupId = "/subscriptions/$($values.subscription)/resourceGroups/$($values.group)"
            $identityId = "$groupId/providers/Microsoft.ManagedIdentity/userAssignedIdentities/fixture-identity"
            foreach ($attempt in 1..3) {
                $location = @('germanywestcentral', 'norwayeast', 'swedencentral')[$attempt - 1]
                foreach ($iteration in @('init', 'idem')) {
                    for ($roleIndex = 0; $roleIndex -lt $script:apimRoleExpressions.Count; $roleIndex++) {
                        $expression = $script:apimRoleExpressions[$roleIndex].
                        Replace('resourceGroup.id', "'$groupId'").
                        Replace('subscription().subscriptionId', "'$($values.subscription)'").
                        Replace('resourceGroupName', "'$($values.group)'").
                        Replace('nestedDependencies.outputs.managedIdentityPrincipalId', "'$($values.principal)'").
                        Replace('nestedDependencies.outputs.managedIdentityResourceId', "'$identityId'").
                        Replace('apimName', "'$($values.serviceName)'").
                        Replace('workspace1Name', "'$($values.workspace)'").
                        Replace('namePrefix', "'$($values.prefix)'").
                        Replace('serviceShort', "'$($values.service)'").
                        Replace('deployment().name', "'attempt-$attempt'").
                        Replace('deployment().location', "'$location'").
                        Replace('enforcedLocation', "'$location'").
                        Replace('locationRegion2', "'$location'").
                        Replace('resourceLocation', "'$location'").
                        Replace('iteration', "'$iteration'")
                        $parameterSource += "param role${roleIndex}scope${scopeIndex}t${attempt}${iteration} = $expression"
                    }
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'max-role-names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'max-role-names.json'
        $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:apimRoleNames = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

        $fixtureOutput = Join-Path $TestDrive 'max-roles.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:apimRoleTemplate = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $script:apimRoleTemplate.resources
        $resources = $resources -is [System.Collections.IDictionary] ? @($resources.Values) : @($resources)
        $testModules = @($resources | Where-Object { $_.name -match '-test-' })
        if ($testModules.Count -ne 1) { throw 'Expected one tested API Management service module.' }
        $script:apimRoleTestModule = $testModules[0]
        $script:apimRoleParameters = $script:apimRoleTestModule.properties.parameters
        $script:apimServiceRoles = @($script:apimRoleParameters.roleAssignments.value)
        $script:apimWorkspaceRoles = @($script:apimRoleParameters.workspaces.value[0].roleAssignments)
        $script:apimExplicitRoles = @($script:apimServiceRoles[0..1]) + @($script:apimWorkspaceRoles[0..1])
    }

    It 'Separates <role> assignment names across <dimension>' -ForEach @(
        @{ role = 'service Owner'; roleIndex = 0; dimension = 'subscriptions'; scopeIndex = 1 }
        @{ role = 'service Contributor'; roleIndex = 1; dimension = 'subscriptions'; scopeIndex = 1 }
        @{ role = 'workspace Owner'; roleIndex = 2; dimension = 'subscriptions'; scopeIndex = 1 }
        @{ role = 'workspace Contributor'; roleIndex = 3; dimension = 'subscriptions'; scopeIndex = 1 }
        @{ role = 'service Owner'; roleIndex = 0; dimension = 'resource groups'; scopeIndex = 2 }
        @{ role = 'service Contributor'; roleIndex = 1; dimension = 'resource groups'; scopeIndex = 2 }
        @{ role = 'workspace Owner'; roleIndex = 2; dimension = 'resource groups'; scopeIndex = 2 }
        @{ role = 'workspace Contributor'; roleIndex = 3; dimension = 'resource groups'; scopeIndex = 2 }
        @{ role = 'service Owner'; roleIndex = 0; dimension = 'actual service names'; scopeIndex = 3 }
        @{ role = 'service Contributor'; roleIndex = 1; dimension = 'actual service names'; scopeIndex = 3 }
        @{ role = 'workspace Owner'; roleIndex = 2; dimension = 'actual service names'; scopeIndex = 3 }
        @{ role = 'workspace Contributor'; roleIndex = 3; dimension = 'actual service names'; scopeIndex = 3 }
        @{ role = 'service Owner'; roleIndex = 0; dimension = 'recreated principals'; scopeIndex = 5 }
        @{ role = 'service Contributor'; roleIndex = 1; dimension = 'recreated principals'; scopeIndex = 5 }
        @{ role = 'workspace Owner'; roleIndex = 2; dimension = 'recreated principals'; scopeIndex = 5 }
        @{ role = 'workspace Contributor'; roleIndex = 3; dimension = 'recreated principals'; scopeIndex = 5 }
    ) {
        $script:apimRoleNames["role${roleIndex}scope${scopeIndex}t1init"].value |
            Should -Not -Be $script:apimRoleNames["role${roleIndex}scope0t1init"].value
    }

    It 'Separates workspace <role> assignments when only the workspace name changes' -ForEach @(
        @{ role = 'Owner'; roleIndex = 2 }
        @{ role = 'Contributor'; roleIndex = 3 }
    ) {
        $script:apimRoleNames["role${roleIndex}scope4t1init"].value |
            Should -Not -Be $script:apimRoleNames["role${roleIndex}scope0t1init"].value
    }

    It 'Keeps service <role> assignments unchanged when only the workspace name changes' -ForEach @(
        @{ role = 'Owner'; roleIndex = 0 }
        @{ role = 'Contributor'; roleIndex = 1 }
    ) {
        $script:apimRoleNames["role${roleIndex}scope4t1init"].value |
            Should -BeExactly $script:apimRoleNames["role${roleIndex}scope0t1init"].value
    }

    It 'Keeps <role> names stable for retained principals across root, location and init/idem changes' -ForEach @(
        @{ role = 'service Owner'; roleIndex = 0 }
        @{ role = 'service Contributor'; roleIndex = 1 }
        @{ role = 'workspace Owner'; roleIndex = 2 }
        @{ role = 'workspace Contributor'; roleIndex = 3 }
    ) {
        for ($scopeIndex = 0; $scopeIndex -lt $script:apimRoleScenarios.Count; $scopeIndex++) {
            $names = @(
                foreach ($attempt in 1..3) {
                    foreach ($iteration in @('init', 'idem')) {
                        $script:apimRoleNames["role${roleIndex}scope${scopeIndex}t${attempt}${iteration}"].value
                    }
                }
            )
            @($names | Select-Object -Unique).Count | Should -Be 1
        }
    }

    It 'Produces four distinct valid GUIDs in every scenario' {
        foreach ($entry in $script:apimRoleNames.Values) {
            $entry.value | Should -Match '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
        }
        for ($scopeIndex = 0; $scopeIndex -lt $script:apimRoleScenarios.Count; $scopeIndex++) {
            $names = @(foreach ($roleIndex in 0..3) { $script:apimRoleNames["role${roleIndex}scope${scopeIndex}t1init"].value })
            @($names | Select-Object -Unique).Count | Should -Be 4
        }
    }

    It 'Keeps four custom names and all three automatic-name cases' {
        $script:apimServiceRoles.Count | Should -Be 3
        $script:apimWorkspaceRoles.Count | Should -Be 4
        foreach ($assignment in $script:apimExplicitRoles) { $assignment.Contains('name') | Should -BeTrue }
        $script:apimServiceRoles[2].Contains('name') | Should -BeFalse
        $script:apimWorkspaceRoles[2].Contains('name') | Should -BeFalse
        $script:apimWorkspaceRoles[3].Contains('name') | Should -BeFalse
    }

    It 'Preserves Owner coverage, other roles and the actual ServicePrincipal identity' {
        foreach ($assignments in @($script:apimServiceRoles, $script:apimWorkspaceRoles)) {
            $assignments[0].roleDefinitionIdOrName | Should -BeExactly 'Owner'
            $assignments[1].roleDefinitionIdOrName | Should -BeExactly 'b24988ac-6180-42a0-ab88-20f7382dd24c'
            $assignments[2].roleDefinitionIdOrName |
                Should -BeExactly "[subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')]"
            foreach ($assignment in $assignments) {
                $assignment.principalType | Should -BeExactly 'ServicePrincipal'
                $assignment.principalId | Should -BeExactly $script:apimServiceRoles[0].principalId
                $assignment.principalId | Should -Match '\.outputs\.managedIdentityPrincipalId\.value'
            }
        }
        $script:apimWorkspaceRoles[3].roleDefinitionIdOrName | Should -BeExactly 'API Management Workspace Contributor'
        $script:apimRoleParameters.managedIdentities.value.systemAssigned | Should -BeTrue
        $script:apimRoleParameters.managedIdentities.value.userAssignedResourceIds | Should -HaveCount 1
        $script:apimRoleParameters.managedIdentities.value.userAssignedResourceIds[0] | Should -Match '\.outputs\.managedIdentityResourceId\.value'
    }

    It 'Forwards the complete actual target scope and principal into the <role> name' -ForEach @(
        @{ role = 'service Owner'; roleIndex = 0; workspace = $false }
        @{ role = 'service Contributor'; roleIndex = 1; workspace = $false }
        @{ role = 'workspace Owner'; roleIndex = 2; workspace = $true }
        @{ role = 'workspace Contributor'; roleIndex = 3; workspace = $true }
    ) {
        $assignment = $script:apimExplicitRoles[$roleIndex]
        $assignment.name | Should -Match 'Microsoft.ApiManagement/service/'
        $assignment.name | Should -Match "subscriptionResourceId\('Microsoft.Resources/resourceGroups', parameters\('resourceGroupName'\)\)"
        $assignment.name | Should -Match "variables\('apimName'\)"
        $principalExpression = $assignment.principalId.Substring(1, $assignment.principalId.Length - 2)
        $assignment.name | Should -Match ([regex]::Escape($principalExpression))
        if ($workspace) {
            $assignment.name | Should -Match '/workspaces/'
            $assignment.name | Should -Match "variables\('workspace1Name'\)"
        } else {
            $assignment.name | Should -Not -Match '/workspaces/'
        }
    }

    It 'Preserves the two literal Owner seeds and both Custom seed expressions' {
        $seeds = @(
            '6352c3e3-ac6b-43d5-ac43-1077ff373721'
            'Custom seed ${namePrefix}${serviceShort}'
            '832142e9-a3da-4881-9838-c2b8c73ad1e7'
            'Custom seed ${namePrefix}${serviceShort}${workspace1Name}'
        )
        foreach ($index in 0..3) {
            $script:apimRoleExpressions[$index] | Should -Match ([regex]::Escape($seeds[$index]))
        }
    }

    It 'Preserves actual service/workspace forwarding, region choices and serial init/idem' {
        $script:apimRoleParameters.name.value | Should -BeExactly "[variables('apimName')]"
        $script:apimRoleParameters.workspaces.value[0].name | Should -BeExactly "[variables('workspace1Name')]"
        $script:apimRoleTestModule.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
        $script:apimRoleTemplate.variables.enforcedLocation | Should -BeExactly 'germanywestcentral'
        $script:apimRoleParameters.location.value | Should -BeExactly "[variables('enforcedLocation')]"
        $script:apimRoleTemplate.parameters.locationRegion2.defaultValue | Should -BeExactly 'westus'
        $script:apimRoleSource | Should -Match "(?m)^#disable-next-line no-hardcoded-location\r?\nvar enforcedLocation = 'germanywestcentral'"
        $script:apimRoleTestModule.copy.mode | Should -BeExactly 'serial'
        $script:apimRoleTestModule.copy.batchSize | Should -Be 1
        $script:apimRoleTestModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
    }
}
