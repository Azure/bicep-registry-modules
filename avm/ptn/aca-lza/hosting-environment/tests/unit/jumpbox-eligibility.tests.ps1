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
                $inputs.acrGeoReplicationLocations.value[0] | Should -BeExactly 'northeurope'
                $inputs.acrGeoReplicationLocations.value[0] | Should -Not -Be $template.variables.enforcedLocation
            } else {
                $inputs.Contains('acrGeoReplicationLocations') | Should -BeFalse
            }
        }

        It 'Forwards the extra replica through the actual registry deployment without moving its primary' {
            $forwarders = @($resources | Where-Object { $_.properties.parameters.acrGeoReplicationLocations })
            $forwarders | Should -HaveCount 2
            foreach ($forwarder in $forwarders) {
                $forwarder.properties.parameters.acrGeoReplicationLocations.value | Should -BeExactly "[parameters('acrGeoReplicationLocations')]"
                $forwarder.properties.parameters.location.value | Should -BeExactly "[parameters('location')]"
            }
            $mapping = @($forwarders.properties.template.variables.copy | Where-Object name -EQ 'acrGeoReplications')
            $mapping | Should -HaveCount 1
            $mapping[0].count | Should -BeExactly "[length(parameters('acrGeoReplicationLocations'))]"
            $mapping[0].input.location | Should -BeExactly "[parameters('acrGeoReplicationLocations')[copyIndex('acrGeoReplications')]]"
            $registry = @($resources | Where-Object { $_.properties.parameters.acrSku.value -eq 'Premium' })
            $registry | Should -HaveCount 1
            $registry[0].properties.parameters.location.value | Should -BeExactly "[parameters('location')]"
            $registry[0].properties.parameters.replications.value | Should -BeExactly "[variables('acrGeoReplications')]"
            $replica = @(Get-TemplateResources $registry[0].properties.template |
                    Where-Object { $_.copy.name -eq 'registry_replications' })
            $replica | Should -HaveCount 1
            $replica[0].copy.count | Should -BeExactly "[length(coalesce(parameters('replications'), createArray()))]"
            $replica[0].properties.parameters.location.value | Should -BeExactly "[coalesce(parameters('replications'), createArray())[copyIndex()].location]"
            $leaf = @(Get-TemplateResources $replica[0].properties.template | Where-Object { -not $_.existing })
            $leaf | Should -HaveCount 1
            $leaf[0].type | Should -BeExactly 'Microsoft.ContainerRegistry/registries/replications'
            $leaf[0].location | Should -BeExactly "[parameters('location')]"
            if (-not $geoReplication) {
                $main.parameters.acrGeoReplicationLocations.defaultValue | Should -BeNullOrEmpty
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

        It 'Passes the gateway service delegation to the native subnet without narrowing shared gateway configurations' {
            $vnet = @(Get-TemplateResources $spoke.properties.template |
                    Where-Object { $_.properties.parameters.subnets })
            $vnet | Should -HaveCount 1
            $vnet[0].properties.parameters.subnets |
                Should -Match "'delegation', 'Microsoft.Network/applicationGateways'"
            $subnet = @(Get-TemplateResources $vnet[0].properties.template |
                    Where-Object { $_.properties.parameters.delegation })
            $subnet | Should -HaveCount 1
            $subnet[0].properties.parameters.delegation.value |
                Should -BeExactly "[tryGet(coalesce(parameters('subnets'), createArray())[copyIndex()], 'delegation')]"
            $native = @(Get-TemplateResources $subnet[0].properties.template |
                    Where-Object type -EQ 'Microsoft.Network/virtualNetworks/subnets')
            $native | Should -HaveCount 1
            $native[0].properties.delegations |
                Should -BeExactly "[if(not(empty(parameters('delegation'))), createArray(createObject('name', parameters('delegation'), 'properties', createObject('serviceName', parameters('delegation')))), createArray())]"
            $native[0].properties.applicationGatewayIPConfigurations |
                Should -BeExactly "[parameters('applicationGatewayIPConfigurations')]"
            $subnet[0].properties.template.parameters.applicationGatewayIPConfigurations.type | Should -BeExactly 'array'
            $subnet[0].properties.template.parameters.applicationGatewayIPConfigurations.Contains('maxLength') | Should -BeFalse
        }
    }

    Context 'Actual subnet assembly: <scenario>' -ForEach @(
        @{ scenario = 'gateway and Linux jumpbox with hub egress'; gatewayPrefix = '10.1.3.0/24'; os = 'linux'; hub = 'hub-id'; appliance = '10.0.0.4' }
        @{ scenario = 'gateway without jumpbox or hub'; gatewayPrefix = '10.1.3.0/24'; os = 'none'; hub = ''; appliance = '' }
        @{ scenario = 'Windows jumpbox without gateway'; gatewayPrefix = ''; os = 'windows'; hub = 'hub-id'; appliance = '10.0.0.4' }
        @{ scenario = 'neither gateway nor jumpbox'; gatewayPrefix = ''; os = 'none'; hub = ''; appliance = '' }
    ) {
        BeforeAll {
            $sourcePath = Join-Path $PSScriptRoot '..' '..' 'modules' 'spoke' 'deploy.spoke.bicep'
            $source = Get-Content -LiteralPath $sourcePath -Raw
            $match = [regex]::Match($source, '(?ms)^var defaultSubnets = .*?(?=^// -+\r?\n// RESOURCES)')
            if (-not $match.Success) { throw 'Actual spoke subnet assembly expressions were not found.' }
            $expressions = $match.Value
            foreach ($binding in @{
                    'networkSecurityGroups[0].outputs.resourceId' = 'nsg-infra'
                    'networkSecurityGroups[3].outputs.resourceId' = 'nsg-deployment'
                    'networkSecurityGroups[2].outputs.resourceId' = 'nsg-pep'
                    'networkSecurityGroups[1].outputs.resourceId' = 'nsg-gateway'
                    'egressLockdownUdr.outputs.resourceId' = 'udr-egress'
                }.GetEnumerator()) {
                $expressions = $expressions.Replace($binding.Key, "'$($binding.Value)'")
            }
            $bindings = @{
                spokeInfraSubnetName = 'infra'; spokeInfraSubnetAddressPrefix = '10.1.0.0/23'
                deploymentSubnetName = 'deployment'; deploymentSubnetAddressPrefix = '10.1.4.0/24'
                spokePrivateEndpointsSubnetName = 'private-endpoints'; spokePrivateEndpointsSubnetAddressPrefix = '10.1.2.0/27'
                spokeApplicationGatewaySubnetName = 'custom-gateway'; spokeApplicationGatewaySubnetAddressPrefix = $gatewayPrefix
                vmSubnetName = 'jumpbox'; vmJumpBoxSubnetAddressPrefix = '10.1.2.32/27'; vmJumpboxOSType = $os
                hubVNetId = $hub; networkApplianceIpAddress = $appliance
            }
            $parameters = @('using none') + @($bindings.GetEnumerator() | Sort-Object Key | ForEach-Object {
                    "var $($_.Key) = '$($_.Value)'"
                }) + @($expressions, 'param actualSubnets = spokeSubnets')
            $parameterPath = Join-Path $TestDrive 'subnets.bicepparam'
            $output = Join-Path $TestDrive 'subnets.json'
            $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $output 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $subnets = (Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable).parameters.actualSubnets.value
        }

        It 'Delegates only the optional dedicated gateway subnet to Application Gateway' {
            $gateway = @($subnets | Where-Object name -CEQ 'custom-gateway')
            if ($gatewayPrefix) {
                $gateway | Should -HaveCount 1
                $gateway[0].delegation | Should -BeExactly 'Microsoft.Network/applicationGateways'
                $gateway[0].addressPrefix | Should -BeExactly $gatewayPrefix
                $gateway[0].networkSecurityGroupResourceId | Should -BeExactly 'nsg-gateway'
            } else {
                $gateway | Should -HaveCount 0
            }
            @($subnets | Where-Object delegation -CEQ 'Microsoft.Network/applicationGateways').Count |
                Should -Be ([int][bool]$gatewayPrefix)
        }

        It 'Preserves infrastructure and deployment delegations, private endpoints and egress controls' {
            $infra = @($subnets | Where-Object name -CEQ 'infra')[0]
            $infra.delegation | Should -BeExactly 'Microsoft.App/environments'
            $infra.networkSecurityGroupResourceId | Should -BeExactly 'nsg-infra'
            if ($hub -and $appliance) {
                $infra.routeTableResourceId | Should -BeExactly 'udr-egress'
            } else {
                $infra.routeTableResourceId | Should -BeNullOrEmpty
            }
            $deployment = @($subnets | Where-Object name -CEQ 'deployment')[0]
            $deployment.delegation | Should -BeExactly 'Microsoft.ContainerInstance/containerGroups'
            $deployment.networkSecurityGroupResourceId | Should -BeExactly 'nsg-deployment'
            $privateEndpoints = @($subnets | Where-Object name -CEQ 'private-endpoints')[0]
            $privateEndpoints.Contains('delegation') | Should -BeFalse
            $privateEndpoints.networkSecurityGroupResourceId | Should -BeExactly 'nsg-pep'
        }

        It 'Preserves optional subnet cardinality and leaves jumpbox subnets undelegated' {
            $subnets.Count | Should -Be (3 + [int][bool]$gatewayPrefix + [int]($os -ne 'none'))
            @($subnets.name | Select-Object -Unique).Count | Should -Be $subnets.Count
            $jumpbox = @($subnets | Where-Object name -CEQ 'jumpbox')
            if ($os -ne 'none') {
                $jumpbox | Should -HaveCount 1
                $jumpbox[0].addressPrefix | Should -BeExactly '10.1.2.32/27'
                $jumpbox[0].Contains('delegation') | Should -BeFalse
            } else {
                $jumpbox | Should -HaveCount 0
            }
        }
    }
}
