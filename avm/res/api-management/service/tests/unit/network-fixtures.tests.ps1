Describe 'API Management maximum fixture network dependencies' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'dependencies.bicep'
        $fixtureOutput = Join-Path $TestDrive 'max-dependencies.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $networkSecurityGroups = @($resources | Where-Object type -EQ 'Microsoft.Network/networkSecurityGroups')
    }

    It 'Defines a network security group for each fixture region' {
        $networkSecurityGroups | Should -HaveCount 2
        $networkSecurityGroups.location | Should -Contain "[parameters('locationRegion1')]"
        $networkSecurityGroups.location | Should -Contain "[parameters('locationRegion2')]"
    }

    Context 'Region <region>' -ForEach @(
        @{ region = 1 }
        @{ region = 2 }
    ) {
        BeforeAll {
            $regionalGroups = @($networkSecurityGroups | Where-Object location -EQ "[parameters('locationRegion$region')]")
            if ($regionalGroups.Count -ne 1) { throw "Expected one network security group for region $region." }
            $rules = $regionalGroups[0].properties.securityRules
        }

        It 'Allows outbound HTTPS to Azure Storage on port 443' {
            $storageRules = @($rules | Where-Object name -EQ 'Dependency_on_Azure_Storage_for_core_service_functionality')
            $storageRules | Should -HaveCount 1
            $properties = $storageRules[0].properties
            $properties.protocol | Should -BeExactly 'Tcp'
            $properties.direction | Should -BeExactly 'Outbound'
            $properties.access | Should -BeExactly 'Allow'
            $properties.sourceAddressPrefix | Should -BeExactly 'VirtualNetwork'
            $properties.sourcePortRange | Should -BeExactly '*'
            $properties.destinationAddressPrefix | Should -BeExactly 'Storage'
            $properties.destinationPortRange | Should -BeExactly '443'
        }

        It 'Allows outbound diagnostics to Azure Monitor on ports 1886 and 443' {
            $monitorRules = @($rules | Where-Object name -EQ 'Publish_Diagnostics_Logs_and_Metrics_Resource_Health_and_Application_Insights')
            $monitorRules | Should -HaveCount 1
            $properties = $monitorRules[0].properties
            $properties.protocol | Should -BeExactly 'Tcp'
            $properties.direction | Should -BeExactly 'Outbound'
            $properties.access | Should -BeExactly 'Allow'
            $properties.sourceAddressPrefix | Should -BeExactly 'VirtualNetwork'
            $properties.sourcePortRange | Should -BeExactly '*'
            $properties.destinationAddressPrefix | Should -BeExactly 'AzureMonitor'
            ($properties.destinationPortRanges | Sort-Object) -join ',' | Should -BeExactly '1886,443'
        }
    }
}
