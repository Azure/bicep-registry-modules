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
