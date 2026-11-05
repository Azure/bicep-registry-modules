BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
    $source = Get-Content -LiteralPath $fixturePath -Raw
    $nameMatch = [regex]::Match($source, '(?m)^\s+sshDeploymentScriptName: (?<expression>[^\r\n]+)')
    $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
    if (-not $nameMatch.Success -or -not $serviceMatch.Success) { throw 'Missing maximum fixture script name or service identifier.' }

    $defaults = @{
        root = 'a-r-rs-v-max-t1-20261008T1610055370Z'
        location = 'norwayeast'
        prefix = 'gci'
        service = $serviceMatch.Groups['value'].Value
    }
    $overrides = @(
        @{}
        @{ root = 'a-r-rs-v-max-t1-20261008T1710055370Z' }
        @{ location = 'eastus' }
        @{ root = 'a-r-rs-v-max-t2-20261008T1610055370Z'; location = 'eastus' }
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
            Replace('deployment().name', "'$($values.root)'").
            Replace('resourceLocation', "'$($values.location)'").
            Replace('namePrefix', "'$($values.prefix)'").
            Replace('serviceShort', "'$($values.service)'").
            Replace('iteration', "'$iteration'")
            $parameterSource += "param script${index}${iteration} = $expression"
        }
    }
    $parameterPath = Join-Path $TestDrive 'script-names.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'script-names.json'
    $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

    $fixtureOutput = Join-Path $TestDrive 'max.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $dependencies = @($resources | Where-Object { $_.name -match '-nestedDependencies' })[0]
    $testModule = @($resources | Where-Object { $_.name -match '-test-' })[0]
    $dependencyResources = $dependencies.properties.template.resources
    $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
    $scripts = @($dependencyResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
    if ($scripts.Count -ne 1) { throw 'Expected one SSH deployment script.' }
    $script = $scripts[0]
    $scriptContent = $script.properties.scriptContent
    $contentVariable = [regex]::Match($scriptContent, "^\[variables\('(?<name>[^']+)'\)\]$")
    if ($contentVariable.Success) {
        $scriptContent = $dependencies.properties.template.variables[$contentVariable.Groups['name'].Value]
        if ($scriptContent -isnot [string]) { throw 'Missing compiled SSH script content.' }
    }
    $sshKey = @($dependencyResources | Where-Object type -EQ 'Microsoft.Compute/sshPublicKeys')[0]
    $vm = @($dependencyResources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.Contains('vmSize')
        })[0]
}

Describe 'Maximum Recovery Services fixture script identity' {
    It 'Separates root executions in the same region and resource group' {
        $names.script0init.value | Should -Not -Be $names.script1init.value
    }

    It 'Separates regional attempts without pinning a region' {
        $names.script0init.value | Should -Not -Be $names.script2init.value
        $names.script0init.value | Should -Not -Be $names.script3init.value
        $template.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
    }

    It 'Keeps one dependency script for serial init and idem within a root attempt' {
        foreach ($index in 0..6) {
            $names["script${index}init"].value | Should -BeExactly $names["script${index}idem"].value
        }
        $dependencies.Contains('copy') | Should -BeFalse
        $testModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -BeExactly 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Meets the 90-character script name limit' {
        foreach ($entry in $names.Values) { $entry.value | Should -Match '^[a-zA-Z0-9][a-zA-Z0-9-]{0,89}$' }
        $names.script4init.value.Length | Should -Be 90
    }

    It 'Keeps full prefix and service inputs distinct after truncation' {
        $names.script4init.value | Should -Not -Be $names.script5init.value
        $names.script4init.value | Should -Not -Be $names.script6init.value
    }

    It 'Forwards the root and region qualified name into the existing resource group' {
        $dependencies.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
        $dependencies.properties.parameters.sshDeploymentScriptName.value | Should -Match 'deployment\(\)\.name'
        $dependencies.properties.parameters.sshDeploymentScriptName.value | Should -Match "parameters\('resourceLocation'\)"
        $script.name | Should -BeExactly "[parameters('sshDeploymentScriptName')]"
        $script.location | Should -BeExactly "[parameters('location')]"
    }

    It 'Retains the user-assigned identity and permission dependency' {
        $script.identity.type | Should -BeExactly 'UserAssigned'
        @($script.identity.userAssignedIdentities.Keys).Count | Should -Be 1
        ($script.identity.userAssignedIdentities.Keys -join "`n") | Should -Match "parameters\('managedIdentityName'\)"
        ($script.dependsOn -join "`n") | Should -Match 'Microsoft.ManagedIdentity/userAssignedIdentities'
        ($script.dependsOn -join "`n") | Should -Match "Microsoft.Authorization/roleAssignments.+Contributor"
    }

    It 'Preserves script retention, runtime and service-managed cleanup defaults' {
        $script.kind | Should -BeExactly 'AzurePowerShell'
        $script.properties.azPowerShellVersion | Should -BeExactly '11.0'
        $script.properties.retentionInterval | Should -BeExactly 'P1D'
        foreach ($property in @('cleanupPreference', 'forceUpdateTag', 'containerSettings', 'storageAccountSettings')) {
            $script.properties.Contains($property) | Should -BeFalse
        }
    }

    It 'Keeps existing-key reuse and the script-to-VM SSH dependency chain' {
        $script.properties.arguments | Should -Match "parameters\('sshKeyName'\)"
        $script.properties.arguments | Should -Match 'resourceGroup\(\)\.name'
        $scriptContent | Should -Match 'Get-AzSshKey'
        $scriptContent | Should -Match '\$sshKey\.publicKey'
        $sshKey.properties.publicKey | Should -Match "parameters\('sshDeploymentScriptName'\).+outputs\.publicKey"
        ($sshKey.dependsOn -join "`n") | Should -Match "parameters\('sshDeploymentScriptName'\)"
        $vm.properties.parameters.publicKeys.value[0].keyData | Should -Match "parameters\('sshKeyName'\).+publicKey"
        ($vm.dependsOn -join "`n") | Should -Match 'Microsoft.Compute/sshPublicKeys'
        $vm.properties.parameters.disablePasswordAuthentication.value | Should -BeTrue
    }

    It 'Retains protected VM and backup security coverage' {
        $parameters = $testModule.properties.parameters
        $parameters.protectedItems.value[0].sourceResourceId | Should -Match '\.outputs\.virtualMachineResourceId\.value'
        $parameters.protectedItems.value[0].policyName | Should -BeExactly 'VMpolicy'
        @($parameters.backupPolicies.value).Count | Should -Be 3
        $parameters.backupConfig.value.enhancedSecurityState | Should -BeExactly 'AlwaysON'
        $parameters.softDeleteSettings.value.softDeleteState | Should -BeExactly 'AlwaysON'
        $parameters.softDeleteSettings.value.softDeleteRetentionPeriodInDays | Should -Be 14
        @($parameters.privateEndpoints.value).Count | Should -Be 1
        @($parameters.roleAssignments.value).Count | Should -Be 3
    }
}
