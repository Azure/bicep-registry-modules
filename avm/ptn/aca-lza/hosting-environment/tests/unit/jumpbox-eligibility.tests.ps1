param (
    [string] $RepoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')).Path
)

Describe 'ACA landing-zone fixture jumpbox eligibility' {
    BeforeAll {
        function Get-TemplateResources {
            param ([System.Collections.IDictionary] $Template)
            if ($Template.resources -is [System.Collections.IDictionary]) { @($Template.resources.Values) }
            else { @($Template.resources) }
        }

        function Get-NestedResources {
            param ([System.Collections.IDictionary] $Template)
            foreach ($resource in (Get-TemplateResources $Template)) {
                $resource
                if ($resource.properties.template -is [System.Collections.IDictionary]) {
                    Get-NestedResources $resource.properties.template
                }
            }
        }
    }

    Context '<fixture> preserves its deployment features' -ForEach @(
        @{ fixture = 'defaults'; premiumDisk = $false; geoReplication = $true }
        @{ fixture = 'waf-aligned'; premiumDisk = $true; geoReplication = $true }
        @{ fixture = 'hub-spoke'; premiumDisk = $true; geoReplication = $false }
    ) {
        BeforeAll {
            $path = Join-Path $PSScriptRoot '..' 'e2e' $fixture 'main.test.bicep'
            $output = Join-Path $TestDrive "$fixture.json"
            $diagnostics = bicep build $path --no-restore --outfile $output 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable -Depth 100
            $calls = @(Get-TemplateResources $template | Where-Object { $_.properties.parameters.vmSize })
            $calls | Should -HaveCount 1
            $call = $calls[0]
            $inputs = $call.properties.parameters
            $main = $call.properties.template
            $spoke = @(Get-TemplateResources $main | Where-Object { $_.properties.parameters.vmJumpboxOSType })[0]
            $linux = @(Get-TemplateResources $spoke.properties.template |
                    Where-Object { $_.properties.template.parameters.vmSshPublicKey })[0]
            $vm = @(Get-TemplateResources $linux.properties.template |
                    Where-Object { $_.properties.parameters.osType.value -eq 'Linux' })[0]
            $nativeVm = @(Get-TemplateResources $vm.properties.template |
                    Where-Object type -EQ 'Microsoft.Compute/virtualMachines')[0]
            $resources = @(Get-NestedResources $main)
        }

        It 'Passes the compatible x64 premium-capable SKU through every layer to the VM' {
            $inputs.vmSize.value | Should -BeExactly 'Standard_D2as_v5'
            foreach ($layer in @($spoke, $linux, $vm)) {
                $layer.properties.parameters.vmSize.value | Should -BeExactly "[parameters('vmSize')]"
            }
            $nativeVm.properties.hardwareProfile.vmSize | Should -BeExactly "[parameters('vmSize')]"
            $vm.properties.parameters.imageReference.value.sku | Should -BeExactly '20_04-lts-gen2'
            $vm.properties.parameters.osType.value | Should -BeExactly 'Linux'
        }

        It 'Keeps hub, spoke and deployment identities on the same supported fixed region' {
            $template.variables.enforcedLocation | Should -BeExactly 'swedencentral'
            $inputs.location.value | Should -BeExactly "[variables('enforcedLocation')]"
            $call.name | Should -Match "uniqueString\(deployment\(\)\.name, variables\('enforcedLocation'\)\)"
            $spoke.properties.parameters.location.value | Should -BeExactly "[parameters('location')]"
            if ($fixture -eq 'hub-spoke') {
                $hub = @(Get-TemplateResources $template | Where-Object { $_.properties.parameters.workloadName -and -not $_.properties.parameters.vmSize })
                $hub | Should -HaveCount 1
                $hub[0].properties.parameters.location.value | Should -BeExactly "[variables('enforcedLocation')]"
                $inputs.hubVirtualNetworkResourceId.value | Should -Match 'hubVNetId'
                $inputs.networkApplianceIpAddress.value | Should -Match 'networkApplianceIpAddress'
            }
        }

        It 'Preserves the existing zone-2 VM and three-zone application gateway' {
            $main.parameters.deployZoneRedundantResources.defaultValue | Should -BeTrue
            $spoke.properties.parameters.vmZone | Should -Match "createObject\('value', 2\)"
            $linux.properties.parameters.vmZone.value | Should -BeExactly "[parameters('vmZone')]"
            $vm.properties.parameters.zone.value | Should -BeExactly "[parameters('vmZone')]"
            $nativeVm.zones | Should -Match "parameters\('zone'\)"
            $gateway = @($resources | Where-Object type -EQ 'Microsoft.Network/applicationGateways')
            $gateway | Should -HaveCount 1
            ($gateway[0].zones -join ',') | Should -BeExactly '1,2,3'
        }

        It 'Preserves SSH, private networking and each fixture disk type' {
            $inputs.vmAuthenticationType.value | Should -BeExactly 'sshPublicKey'
            $inputs.vmJumpboxOSType.value | Should -BeExactly 'linux'
            $template.parameters.password.type | Should -BeExactly 'securestring'
            $inputs.vmAdminPassword.value | Should -BeExactly "[parameters('password')]"
            $inputs.vmJumpBoxSubnetAddressPrefix.value | Should -BeExactly '10.1.2.32/27'
            $inputs.spokeInfraSubnetAddressPrefix.value | Should -BeExactly '10.1.0.0/23'
            $inputs.spokePrivateEndpointsSubnetAddressPrefix.value | Should -BeExactly '10.1.2.0/27'
            $nic = $vm.properties.parameters.nicConfigurations.value[0]
            $nic.enableAcceleratedNetworking | Should -BeFalse
            $nic.ipConfigurations[0].subnetResourceId | Should -Match 'Microsoft.Network/virtualNetworks/subnets'
            $diskType = $premiumDisk ? $inputs.storageAccountType.value : $main.parameters.storageAccountType.defaultValue
            $diskType | Should -BeExactly ($premiumDisk ? 'Premium_LRS' : 'Standard_LRS')
            $vm.properties.parameters.osDisk.value.managedDisk.storageAccountType |
                Should -BeExactly "[parameters('storageAccountType')]"
        }

        It 'Retains workspace replication and the separate ACR geo-replication scenario' {
            $workspace = @($resources | Where-Object { $_.type -eq 'Microsoft.OperationalInsights/workspaces' -and $_.properties.replication })
            $workspace | Should -HaveCount 1
            $workspace[0].properties.replication.enabled | Should -BeTrue
            $workspace[0].properties.replication.location | Should -BeExactly "[variables('locationPairs')[parameters('location')]]"
            $logModule = @(Get-TemplateResources $spoke.properties.template |
                    Where-Object { $_.properties.template.variables.locationPairs })[0]
            $logModule.properties.template.variables.locationPairs.swedencentral | Should -BeExactly 'northeurope'
            if ($geoReplication) {
                $inputs.acrGeoReplicationLocations.value | Should -HaveCount 1
                $inputs.acrGeoReplicationLocations.value[0] | Should -BeExactly 'westeurope'
            } else {
                $inputs.Contains('acrGeoReplicationLocations') | Should -BeFalse
            }
        }

        It 'Keeps the dedicated ACR agent pool, application insights and WAF protections' {
            $main.parameters.deployAgentPool.defaultValue | Should -BeTrue
            @($resources | Where-Object type -EQ 'Microsoft.ContainerRegistry/registries/agentPools') | Should -HaveCount 1
            $inputs.enableApplicationInsights.value | Should -BeTrue
            $inputs.enableDaprInstrumentation.value | Should -BeFalse
            if ($premiumDisk) {
                $inputs.deployZoneRedundantResources.value | Should -BeTrue
                $inputs.exposeContainerAppsWith.value | Should -BeExactly 'applicationGateway'
                $inputs.enableDdosProtection.value | Should -BeTrue
            }
        }
    }
}
