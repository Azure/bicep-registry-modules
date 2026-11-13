param (
    [string] $RepoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')).Path
)

Describe 'Storage account private endpoint deployment ordering' {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..' '..' 'main.bicep'
        $compiledPath = Join-Path $TestDrive 'storage.json'
        $diagnostics = bicep build $modulePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $endpointCalls = @($resources | Where-Object { $_.copy.name -eq 'storageAccount_privateEndpoints' })
        if ($endpointCalls.Count -ne 1) { throw 'Expected one private endpoint module collection.' }
        $endpointCall = $endpointCalls[0]
        $accounts = @($resources | Where-Object type -EQ 'Microsoft.Storage/storageAccounts')
        if ($accounts.Count -ne 1) { throw 'Expected one storage account.' }
        $account = $accounts[0]
        $accountProperties = $account.properties | ConvertTo-Json -Depth 100 -Compress
    }

    It 'Serializes complete endpoint deployments one at a time for this account' {
        $endpointCall.copy.mode | Should -BeExactly 'serial'
        $endpointCall.copy.batchSize | Should -Be 1
    }

    It 'Retains the account completion dependency and the full nullable endpoint collection' {
        $endpointCall.dependsOn | Should -HaveCount 1
        $endpointCall.dependsOn[0] | Should -BeExactly 'storageAccount'
        $endpointCall.copy.count | Should -BeExactly "[length(coalesce(parameters('privateEndpoints'), createArray()))]"
        $template.parameters.privateEndpoints.defaultValue | Should -BeNullOrEmpty
    }

    It 'Keeps automatic and manual connections bound to the account and each selected service' {
        foreach ($connection in @('privateLinkServiceConnections', 'manualPrivateLinkServiceConnections')) {
            $value = $endpointCall.properties.parameters[$connection]
            $value | Should -Match "'privateLinkServiceId', resourceId\('Microsoft.Storage/storageAccounts', parameters\('name'\)\)"
            $value | Should -Match "'groupIds', createArray\(coalesce\(parameters\('privateEndpoints'\), createArray\(\)\)\[copyIndex\(\)\]\.service\)"
            $value | Should -Match 'isManualConnection'
        }
        $endpointCall.properties.parameters.subnetResourceId.value |
            Should -BeExactly "[coalesce(parameters('privateEndpoints'), createArray())[copyIndex()].subnetResourceId]"
        $endpointCall.subscriptionId | Should -Match 'resourceGroupResourceId'
        $endpointCall.resourceGroup | Should -Match 'resourceGroupResourceId'
    }

    It 'Preserves identity and public-network input handling instead of changing access settings' {
        $account.identity | Should -BeExactly "[variables('identity')]"
        $template.parameters.managedIdentities.defaultValue | Should -BeNullOrEmpty
        $template.parameters.publicNetworkAccess.defaultValue | Should -BeNullOrEmpty
        $template.parameters.allowBlobPublicAccess.defaultValue | Should -BeFalse
        $accountProperties | Should -Match "parameters\('publicNetworkAccess'\)"
        $accountProperties | Should -Match "parameters\('privateEndpoints'\)"
        $accountProperties | Should -Match "parameters\('networkAcls'\)"
        $accountProperties | Should -Match "'Disabled'"
        $accountProperties | Should -Match "'defaultAction', 'Deny'"
    }

    Context '<fixture> deployment coverage' -ForEach @(
        @{ fixture = 'defaults'; services = @() }
        @{ fixture = 'max'; services = @('blob', 'blob', 'table', 'queue', 'file', 'web', 'dfs') }
        @{ fixture = 'waf-aligned'; services = @('blob') }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' $fixture 'main.test.bicep'
            $compiledPath = Join-Path $TestDrive "$fixture.json"
            $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $fixtureTemplate = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $resources = $fixtureTemplate.resources -is [System.Collections.IDictionary] ? @($fixtureTemplate.resources.Values) : @($fixtureTemplate.resources)
            $testCalls = @($resources | Where-Object { $_.copy.name -eq 'testDeployment' })
            if ($testCalls.Count -ne 1) { throw "Expected one serial init/idem collection in $fixture." }
            $testCall = $testCalls[0]
            $inputs = $testCall.properties.parameters
            $endpoints = $inputs.Contains('privateEndpoints') ? @($inputs.privateEndpoints.value) : @()
            $storageTemplate = $testCall.properties.template
            $resources = $storageTemplate.resources -is [System.Collections.IDictionary] ? @($storageTemplate.resources.Values) : @($storageTemplate.resources)
            $endpointCalls = @($resources | Where-Object { $_.copy.name -eq 'storageAccount_privateEndpoints' })
            if ($endpointCalls.Count -ne 1) { throw "Expected one embedded endpoint collection in $fixture." }
            $embeddedEndpoints = $endpointCalls[0]
        }

        It 'Retains both init and idem passes and their existing serial ordering' {
            $testCall.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
            $testCall.copy.mode | Should -BeExactly 'serial'
            $testCall.copy.batchSize | Should -Be 1
            $testCall.name | Should -Match "createArray\('init', 'idem'\)\[copyIndex\(\)\]"
        }

        It 'Serializes the production endpoint collection without reducing endpoint or service coverage' {
            $embeddedEndpoints.copy.mode | Should -BeExactly 'serial'
            $embeddedEndpoints.copy.batchSize | Should -Be 1
            $embeddedEndpoints.copy.count | Should -BeExactly "[length(coalesce(parameters('privateEndpoints'), createArray()))]"
            $endpoints | Should -HaveCount $services.Count
            ($endpoints.service -join ',') | Should -BeExactly ($services -join ',')
        }

        It 'Retains existing DNS, subnet, identity and public-access inputs' {
            $inputs.Contains('publicNetworkAccess') | Should -BeFalse
            $allowPublicBlob = $inputs.Contains('allowBlobPublicAccess') ?
                $inputs.allowBlobPublicAccess.value : $storageTemplate.parameters.allowBlobPublicAccess.defaultValue
            $allowPublicBlob | Should -BeFalse
            foreach ($endpoint in $endpoints) {
                $endpoint.subnetResourceId | Should -Not -BeNullOrEmpty
                $endpoint.privateDnsZoneGroup.privateDnsZoneGroupConfigs | Should -HaveCount 1
                $endpoint.privateDnsZoneGroup.privateDnsZoneGroupConfigs[0].privateDnsZoneResourceId |
                    Should -BeExactly "[reference('nestedDependencies').outputs.privateDNSZoneResourceId.value]"
            }
            if ($services.Count -gt 0) {
                $inputs.managedIdentities.value.systemAssigned | Should -BeTrue
                $inputs.managedIdentities.value.userAssignedResourceIds | Should -HaveCount 1
                $inputs.managedIdentities.value.userAssignedResourceIds[0] |
                    Should -BeExactly "[reference('nestedDependencies').outputs.managedIdentityResourceId.value]"
            }
            if ($fixture -eq 'max') {
                $endpoints[0].subnetResourceId |
                    Should -BeExactly "[reference('nestedDependencies').outputs.customSubnet1ResourceId.value]"
                $endpoints[1].subnetResourceId |
                    Should -BeExactly "[reference('nestedDependencies').outputs.customSubnet2ResourceId.value]"
                foreach ($endpoint in $endpoints[2..6]) {
                    $endpoint.subnetResourceId | Should -BeExactly $endpoints[0].subnetResourceId
                }
                $inputs.networkAcls.value.defaultAction | Should -BeExactly 'Deny'
                $inputs.networkAcls.value.bypass | Should -BeExactly 'AzureServices'
                $inputs.networkAcls.value.virtualNetworkRules[0].id |
                    Should -BeExactly "[reference('nestedDependencies').outputs.defaultSubnetResourceId.value]"
            }
        }
    }
}
