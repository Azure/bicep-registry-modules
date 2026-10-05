BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' '..'
    $source = Join-Path $modulePath 'tests' 'e2e' 'kubenet' 'main.test.bicep'
    $output = Join-Path $TestDrive 'kubenet.json'
    $diagnostics = bicep build $source --no-restore --outfile $output 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $testModules = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('primaryAgentPoolProfiles')
        })
    if ($testModules.Count -ne 1) { throw 'Expected one tested AKS module in the kubenet fixture.' }
    $testModule = $testModules[0]
    $parameters = $testModule.properties.parameters
    $primaryPools = @($parameters.primaryAgentPoolProfiles.value)
    $userPools = @($parameters.agentPools.value)
}

Describe 'Kubenet fixture compatibility' {
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
