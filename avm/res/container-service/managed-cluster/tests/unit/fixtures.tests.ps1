BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' '..'

    function Get-AksFixture {
        param ([Parameter(Mandatory)] [string] $Name)

        $source = Join-Path $modulePath 'tests' 'e2e' $Name 'main.test.bicep'
        $output = Join-Path $TestDrive "$Name.json"
        $diagnostics = bicep build $source --no-restore --outfile $output 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $testModules = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('primaryAgentPoolProfiles')
            })
        if ($testModules.Count -ne 1) { throw "Expected one tested AKS module in the $Name fixture." }
        [pscustomobject]@{
            Template = $template
            Resources = $resources
            TestModule = $testModules[0]
        }
    }
}

Describe 'Kubenet fixture compatibility' {
    BeforeAll {
        $fixture = Get-AksFixture -Name 'kubenet'
        $template = $fixture.Template
        $resources = $fixture.Resources
        $testModule = $fixture.TestModule
        $parameters = $testModule.properties.parameters
        $primaryPools = @($parameters.primaryAgentPoolProfiles.value)
        $userPools = @($parameters.agentPools.value)
    }

    It 'Uses a supported size in the manual scale profile' {
        $profiles = @($userPools[0].virtualMachinesProfile.scale.manual)
        $profiles.Count | Should -Be 1
        $profiles[0].size | Should -Be 'Standard_D8ds_v5'
    }

    It 'Keeps two manually scaled Virtual Machines user nodes' {
        $userPools.Count | Should -Be 1
        $userPools[0].type | Should -Be 'VirtualMachines'
        $userPools[0].mode | Should -Be 'User'
        $userPools[0].virtualMachinesProfile.scale.manual[0].count | Should -Be 2
    }

    It 'Keeps the user pool Linux OS and disk size' {
        $userPools[0].osType | Should -Be 'Linux'
        $userPools[0].osDiskSizeGB | Should -Be 128
    }

    It 'Keeps the existing zonal scale-set system pool' {
        $primaryPools.Count | Should -Be 1
        $primaryPools[0].type | Should -Be 'VirtualMachineScaleSets'
        $primaryPools[0].mode | Should -Be 'System'
        $primaryPools[0].vmSize | Should -Be 'Standard_D8ds_v5'
        $primaryPools[0].availabilityZones.Count | Should -Be 1
        $primaryPools[0].availabilityZones[0] | Should -Be 3
    }

    It 'Keeps the system pool autoscaling bounds' {
        $primaryPools[0].count | Should -Be 1
        $primaryPools[0].enableAutoScaling | Should -BeTrue
        $primaryPools[0].minCount | Should -Be 1
        $primaryPools[0].maxCount | Should -Be 3
    }

    It 'Keeps the kubenet network plugin' {
        $parameters.networkPlugin.value | Should -Be 'kubenet'
    }

    It 'Lets CI choose the resource location' {
        $template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
        $resourceGroups = @($resources | Where-Object type -EQ 'Microsoft.Resources/resourceGroups')
        $resourceGroups.Count | Should -Be 1
        $resourceGroups[0].location | Should -Be "[parameters('resourceLocation')]"
    }

    It 'Keeps sequential initial and idempotency deployments' {
        $testModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -Be 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }
}

Describe 'Maximum fixture compatibility' {
    BeforeAll {
        $fixture = Get-AksFixture -Name 'max'
        $parameters = $fixture.TestModule.properties.parameters
        $primaryPools = @($parameters.primaryAgentPoolProfiles.value)
        $userPools = @($parameters.agentPools.value)
        if ($userPools.Count -ne 1 -or $userPools[0].name -cne 'userpool1') {
            throw 'Expected the maximum fixture userpool1.'
        }
        $userPool = $userPools[0]
        $dependencies = @($fixture.Resources | Where-Object { $_.name -match '-nestedDependencies|-paramNested' })[0]
        $dependencyResources = $dependencies.properties.template.resources
        $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
        $virtualNetwork = @($dependencyResources | Where-Object type -EQ 'Microsoft.Network/virtualNetworks')[0]
        $applicationGateway = @($dependencyResources | Where-Object type -EQ 'Microsoft.Network/applicationGateways')[0]
    }

    It 'Uses the Dds_v5 size for the user pool' {
        $userPool.vmSize | Should -Be 'Standard_D2ds_v5'
    }

    It 'Keeps the ephemeral Linux OS disk' {
        $userPool.osType | Should -Be 'Linux'
        $userPool.osDiskType | Should -Be 'Ephemeral'
        $userPool.osDiskSizeGB | Should -Be 30
    }

    It 'Keeps the zonal scale-set user pool and autoscaling bounds' {
        $userPool.type | Should -Be 'VirtualMachineScaleSets'
        $userPool.mode | Should -Be 'User'
        $userPool.availabilityZones.Count | Should -Be 1
        $userPool.availabilityZones[0] | Should -Be 1
        $userPool.count | Should -Be 1
        $userPool.enableAutoScaling | Should -BeTrue
        $userPool.minCount | Should -Be 1
        $userPool.maxCount | Should -Be 2
    }

    It 'Keeps the managed system disk and two system-pool zones' {
        $primaryPools.Count | Should -Be 1
        $primaryPools[0].vmSize | Should -Be 'Standard_D2s_v5'
        $primaryPools[0].type | Should -Be 'VirtualMachineScaleSets'
        $primaryPools[0].mode | Should -Be 'System'
        $primaryPools[0].count | Should -Be 1
        $primaryPools[0].enableAutoScaling | Should -BeTrue
        $primaryPools[0].minCount | Should -Be 1
        $primaryPools[0].maxCount | Should -Be 3
        $primaryPools[0].osDiskType | Should -Be 'Managed'
        $primaryPools[0].osDiskSizeGB | Should -Be 128
        $primaryPools[0].availabilityZones.Count | Should -Be 2
        $primaryPools[0].availabilityZones[0] | Should -Be 1
        $primaryPools[0].availabilityZones[1] | Should -Be 2
    }

    It 'Lets CI choose the resource location' {
        $fixture.Template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
        $parameters.location.value | Should -Be "[parameters('resourceLocation')]"
        $resourceGroups = @($fixture.Resources | Where-Object type -EQ 'Microsoft.Resources/resourceGroups')
        $resourceGroups.Count | Should -Be 1
        $resourceGroups[0].location | Should -Be "[parameters('resourceLocation')]"
    }

    It 'Keeps sequential initial and idempotency deployments' {
        $fixture.TestModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $fixture.TestModule.copy.mode | Should -Be 'serial'
        $fixture.TestModule.copy.batchSize | Should -Be 1
    }

    It 'Delegates only the gateway subnet to the Application Gateway service' {
        $subnet = @($virtualNetwork.properties.subnets | Where-Object name -EQ 'appGatewaySubnet')[0]
        $subnet.properties.Contains('delegations') | Should -BeTrue
        @($subnet.properties.delegations).Count | Should -Be 1
        $subnet.properties.delegations[0].properties.serviceName | Should -BeExactly 'Microsoft.Network/applicationGateways'
        $gatewaySubnets = @($virtualNetwork.properties.subnets | Where-Object {
                $_.properties.delegations.properties.serviceName -contains 'Microsoft.Network/applicationGateways'
            })
        $gatewaySubnets.Count | Should -Be 1
        $gatewaySubnets[0].name | Should -BeExactly 'appGatewaySubnet'
    }

    It 'Preserves subnet ranges, policies and the API server delegation' {
        @($virtualNetwork.properties.subnets).Count | Should -Be 3
        $defaultSubnet = @($virtualNetwork.properties.subnets | Where-Object name -EQ 'defaultSubnet')[0]
        $defaultSubnet.properties.addressPrefix | Should -BeExactly '10.0.0.0/20'
        $defaultSubnet.properties.privateEndpointNetworkPolicies | Should -BeExactly 'Disabled'
        $defaultSubnet.properties.privateLinkServiceNetworkPolicies | Should -BeExactly 'Enabled'
        $gatewaySubnet = @($virtualNetwork.properties.subnets | Where-Object name -EQ 'appGatewaySubnet')[0]
        $gatewaySubnet.properties.addressPrefix | Should -BeExactly '10.0.16.0/24'
        $apiSubnet = @($virtualNetwork.properties.subnets | Where-Object name -EQ 'apiServerSubnet')[0]
        $apiSubnet.properties.addressPrefix | Should -BeExactly '10.0.17.0/28'
        @($apiSubnet.properties.delegations).Count | Should -Be 1
        $apiSubnet.properties.delegations[0].properties.serviceName | Should -BeExactly 'Microsoft.ContainerService/managedClusters'
    }

    It 'Keeps the gateway and ingress add-on connected to the delegated subnet' {
        $applicationGateway.properties.gatewayIPConfigurations[0].properties.subnet.id | Should -Match '/subnets/appGatewaySubnet'
        $applicationGateway.properties.gatewayIPConfigurations[0].properties.subnet.id | Should -Match "parameters\('virtualNetworkName'\)"
        $applicationGateway.properties.sku.name | Should -BeExactly 'Standard_v2'
        $applicationGateway.properties.sku.capacity | Should -Be 2
        $gatewayOutputs = @($dependencies.properties.template.outputs.GetEnumerator() | Where-Object {
                $_.Value.value -match 'Microsoft.Network/applicationGateways'
            })
        $gatewayOutputs.Count | Should -Be 1
        $parameters | ConvertTo-Json -Depth 30 -Compress |
            Should -Match "\.outputs\.$([regex]::Escape($gatewayOutputs[0].Key))\.value"
    }
}

Describe 'Private fixture compatibility' {
    BeforeAll {
        $fixture = Get-AksFixture -Name 'priv'
        $parameters = $fixture.TestModule.properties.parameters
        $primaryPools = @($parameters.primaryAgentPoolProfiles.value)
        $userPools = @($parameters.agentPools.value)
        if ($primaryPools.Count -ne 1 -or $userPools.Count -ne 1) {
            throw 'Expected one system pool and one user pool in the private fixture.'
        }
        $pools = @($primaryPools[0], $userPools[0])
    }

    It 'Uses the D8ds_v5 size for both pools' {
        foreach ($pool in $pools) {
            $pool.vmSize | Should -Be 'Standard_D8ds_v5'
        }
    }

    It 'Keeps both scale-set pools in zone three' {
        $primaryPools[0].mode | Should -Be 'System'
        $userPools[0].mode | Should -Be 'User'
        foreach ($pool in $pools) {
            $pool.type | Should -Be 'VirtualMachineScaleSets'
            $pool.availabilityZones.Count | Should -Be 1
            $pool.availabilityZones[0] | Should -Be 3
        }
    }

    It 'Keeps the initial node counts and autoscaling bounds' {
        $primaryPools[0].count | Should -Be 1
        $userPools[0].count | Should -Be 2
        foreach ($pool in $pools) {
            $pool.enableAutoScaling | Should -BeTrue
            $pool.minCount | Should -Be 1
            $pool.maxCount | Should -Be 3
        }
    }

    It 'Keeps the Linux disks, pod limits and system taint' {
        $primaryPools[0].osDiskSizeGB | Should -Be 0
        $userPools[0].osDiskSizeGB | Should -Be 128
        $userPools[0].minPods | Should -Be 2
        $primaryPools[0].nodeTaints | Should -Contain 'CriticalAddonsOnly=true:NoSchedule'
        foreach ($pool in $pools) {
            $pool.osType | Should -Be 'Linux'
            $pool.maxPods | Should -Be 30
        }
    }

    It 'Keeps private networking, custom DNS and managed identity access' {
        $parameters.apiServerAccessProfile.value.enablePrivateCluster | Should -BeTrue
        $parameters.apiServerAccessProfile.value.privateDNSZone | Should -Match '\.outputs\.privateDnsZoneResourceId\.value'
        $parameters.networkPlugin.value | Should -Be 'azure'
        $parameters.aadProfile.value.enableAzureRBAC | Should -BeTrue
        $parameters.aadProfile.value.managed | Should -BeTrue
        $identities = @($parameters.managedIdentities.value.userAssignedResourceIds)
        $identities.Count | Should -Be 1
        $identities[0] | Should -Match '\.outputs\.managedIdentityResourceId\.value'
        $primaryPools[0].vnetSubnetResourceId | Should -Match '\.outputs\.vNetResourceId\.value'
        $primaryPools[0].vnetSubnetResourceId | Should -Be $userPools[0].vnetSubnetResourceId
    }

    It 'Lets CI choose the resource location' {
        $fixture.Template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
        $parameters.ContainsKey('location') | Should -BeFalse
        $resourceGroups = @($fixture.Resources | Where-Object type -EQ 'Microsoft.Resources/resourceGroups')
        $resourceGroups.Count | Should -Be 1
        $resourceGroups[0].location | Should -Be "[parameters('resourceLocation')]"
    }

    It 'Keeps sequential initial and idempotency deployments' {
        $fixture.TestModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $fixture.TestModule.copy.mode | Should -Be 'serial'
        $fixture.TestModule.copy.batchSize | Should -Be 1
    }
}

Describe 'Automatic fixture compatibility' {
    BeforeAll {
        $fixture = Get-AksFixture -Name 'automatic'
        $parameters = $fixture.TestModule.properties.parameters
    }

    It 'Leaves system node pools under AKS Automatic management' {
        $parameters.ContainsKey('primaryAgentPoolProfiles') | Should -BeTrue
        @($parameters.primaryAgentPoolProfiles.value).Count | Should -Be 0
        $parameters.ContainsKey('agentPools') | Should -BeFalse
    }

    It 'Keeps the Automatic SKU and automatic node provisioning' {
        $parameters.skuName.value | Should -Be 'Automatic'
        $parameters.nodeProvisioningProfile.value.mode | Should -Be 'Auto'
        $parameters.nodeResourceGroupProfile.value.restrictionLevel | Should -Be 'ReadOnly'
    }

    It 'Keeps managed identity and Entra access controls' {
        $parameters.managedIdentities.value.systemAssigned | Should -BeTrue
        $parameters.aadProfile.value.enableAzureRBAC | Should -BeTrue
        $parameters.aadProfile.value.managed | Should -BeTrue
        $parameters.disableLocalAccounts.value | Should -BeTrue
    }

    It 'Keeps both workload autoscalers' {
        $parameters.workloadAutoScalerProfile.value.keda.enabled | Should -BeTrue
        $parameters.workloadAutoScalerProfile.value.verticalPodAutoscaler.enabled | Should -BeTrue
    }

    It 'Lets CI choose the resource location' {
        $fixture.Template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
        $parameters.ContainsKey('location') | Should -BeFalse
        $resourceGroups = @($fixture.Resources | Where-Object type -EQ 'Microsoft.Resources/resourceGroups')
        $resourceGroups.Count | Should -Be 1
        $resourceGroups[0].location | Should -Be "[parameters('resourceLocation')]"
    }

    It 'Keeps sequential initial and idempotency deployments' {
        $fixture.TestModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $fixture.TestModule.copy.mode | Should -Be 'serial'
        $fixture.TestModule.copy.batchSize | Should -Be 1
    }
}
