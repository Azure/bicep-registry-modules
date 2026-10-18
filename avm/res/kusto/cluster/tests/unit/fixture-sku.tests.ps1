param (
    [string] $RepoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')).Path
)

Describe 'Kusto fixture regional SKU eligibility' {
    BeforeAll {
        function Get-TemplateResources {
            param ([System.Collections.IDictionary] $Template)
            if ($Template.resources -is [System.Collections.IDictionary]) { @($Template.resources.Values) }
            else { @($Template.resources) }
        }
    }

    Context '<fixture> preserves its cluster scenario' -ForEach @(
        @{ fixture = 'defaults'; diskEncryption = $true; doubleEncryption = $false; privateNetwork = $false }
        @{ fixture = 'waf-aligned'; diskEncryption = $true; doubleEncryption = $true; privateNetwork = $true }
        @{ fixture = 'max'; diskEncryption = $true; doubleEncryption = $true; privateNetwork = $false }
        @{ fixture = 'pe'; diskEncryption = $false; doubleEncryption = $false; privateNetwork = $true }
    ) {
        BeforeAll {
            $path = Join-Path $PSScriptRoot '..' 'e2e' $fixture 'main.test.bicep'
            $output = Join-Path $TestDrive "$fixture.json"
            $diagnostics = bicep build $path --no-restore --outfile $output 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $calls = @(Get-TemplateResources $template | Where-Object { $_.copy.name -eq 'testDeployment' })
            $calls | Should -HaveCount 1
            $call = $calls[0]
            $inputs = $call.properties.parameters
            $main = $call.properties.template
            $clusters = @(Get-TemplateResources $main | Where-Object type -EQ 'Microsoft.Kusto/clusters')
            $clusters | Should -HaveCount 1
            $cluster = $clusters[0]
        }

        It 'Keeps the existing Standard SKU on a fixed catalog-supported region' {
            $inputs.sku.value | Should -BeExactly 'Standard_E2ads_v5'
            $cluster.sku.name | Should -BeExactly "[parameters('sku')]"
            $main.parameters.tier.defaultValue | Should -BeExactly 'Standard'
            $template.variables.resourceLocation | Should -BeExactly 'centralus'
            $template.parameters.Contains('resourceLocation') | Should -BeFalse
            $groups = @(Get-TemplateResources $template | Where-Object type -EQ 'Microsoft.Resources/resourceGroups')
            $groups | Should -HaveCount 1
            $groups[0].location | Should -BeExactly "[variables('resourceLocation')]"
            $main.parameters.location.defaultValue | Should -BeExactly '[resourceGroup().location]'
            if ($inputs.Contains('location')) {
                $inputs.location.value | Should -BeExactly "[variables('resourceLocation')]"
            }
        }

        It 'Retains serial initial and idempotency passes with location-consistent deployment names' {
            $call.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
            $call.copy.mode | Should -BeExactly 'serial'
            $call.copy.batchSize | Should -Be 1
            $call.name | Should -Match "uniqueString\(deployment\(\)\.name, variables\('resourceLocation'\)\)"
            $call.name | Should -Match "createArray\('init', 'idem'\)\[copyIndex\(\)\]"
            @($inputs.Keys | Where-Object { $_ -match 'ignore|skip' }) | Should -HaveCount 0
        }

        It 'Preserves disk and double encryption with the existing user-assigned identity' {
            foreach ($setting in @(
                @{ name = 'enableDiskEncryption'; expected = $diskEncryption }
                @{ name = 'enableDoubleEncryption'; expected = $doubleEncryption }
            )) {
                $actual = $inputs.Contains($setting.name) ?
                    $inputs[$setting.name].value : $main.parameters[$setting.name].defaultValue
                $actual | Should -Be $setting.expected
                $cluster.properties[$setting.name] | Should -BeExactly "[parameters('$($setting.name)')]"
            }
            if ($diskEncryption) {
                $inputs.managedIdentities.value.userAssignedResourceIds | Should -HaveCount 1
                $inputs.managedIdentities.value.userAssignedResourceIds[0] | Should -Match 'managedIdentityResourceId'
            }
        }

        It 'Preserves public access, private endpoints and DNS/subnet coverage' {
            $publicAccess = $inputs.Contains('enablePublicNetworkAccess') ?
                $inputs.enablePublicNetworkAccess.value : $main.parameters.enablePublicNetworkAccess.defaultValue
            $publicAccess | Should -Be (-not $privateNetwork)
            if ($fixture -eq 'pe') {
                $inputs.privateEndpoints.value | Should -HaveCount 2
                ($inputs.privateEndpoints.value.service -join ',') | Should -BeExactly 'cluster,cluster'
                $inputs.publicIPType.value | Should -BeExactly 'IPv4'
                foreach ($endpoint in $inputs.privateEndpoints.value) {
                    $endpoint.subnetResourceId | Should -Not -BeNullOrEmpty
                    $endpoint.privateDnsZoneGroup.privateDnsZoneGroupConfigs | Should -HaveCount 1
                }
                $inputs.privateEndpoints.value[0].subnetResourceId |
                    Should -Not -BeExactly $inputs.privateEndpoints.value[1].subnetResourceId
            }
        }

        It 'Preserves the max/WAF capacity, autoscaling, zones and max feature set' {
            if ($fixture -in @('max', 'waf-aligned')) {
                $inputs.capacity.value | Should -Be 3
                $inputs.enableAutoScale.value | Should -BeTrue
                $inputs.autoScaleMin.value | Should -Be 3
                $inputs.autoScaleMax.value | Should -Be ($fixture -eq 'max' ? 6 : 10)
            }
            if ($fixture -eq 'max') {
                ($inputs.availabilityZones.value -join ',') | Should -BeExactly '1,2,3'
                $inputs.engineType.value | Should -BeExactly 'V3'
                $inputs.publicIPType.value | Should -BeExactly 'DualStack'
                $inputs.enablePurge.value | Should -BeTrue
                $inputs.enableStreamingIngest.value | Should -BeTrue
                $inputs.enableRestrictOutboundNetworkAccess.value | Should -BeTrue
                $inputs.databases.value | Should -HaveCount 1
                $inputs.roleAssignments.value | Should -HaveCount 3
                $inputs.lock.value.kind | Should -BeExactly 'CanNotDelete'
            }
        }
    }
}
