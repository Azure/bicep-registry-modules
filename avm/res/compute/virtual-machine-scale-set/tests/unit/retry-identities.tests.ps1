Describe 'Linux maximum fixture retry identities' {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..' '..'
        $fixturePath = Join-Path $modulePath 'tests' 'e2e' 'linux.max' 'main.test.bicep'
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $scriptParameters = @('storageUploadDeploymentScriptName', 'sshDeploymentScriptName')
        $expressions = @{}
        foreach ($parameter in $scriptParameters) {
            $match = [regex]::Match($source, "(?m)^\s+$parameter`: (?<expression>[^\r\n]+)")
            if (-not $match.Success) { throw "Missing deployment script name expression for $parameter." }
            $expressions[$parameter] = $match.Groups['expression'].Value
        }

        $scenarios = @(
            @{ root = 'attempt-one'; location = 'eastus'; prefix = 'gci'; service = 'cvmsslinmax' }
            @{ root = 'attempt-two'; location = 'eastus'; prefix = 'gci'; service = 'cvmsslinmax' }
            @{ root = 'attempt-one'; location = 'centralus'; prefix = 'gci'; service = 'cvmsslinmax' }
            @{ root = 'attempt-two'; location = 'norwayeast'; prefix = 'gci'; service = 'cvmsslinmax' }
            @{ root = 'attempt-one'; location = 'eastus'; prefix = ('g' * 100); service = ('s' * 100 + '1') }
            @{ root = 'attempt-one'; location = 'eastus'; prefix = ('g' * 100); service = ('s' * 100 + '2') }
        )
        $parameterSource = @('using none')
        for ($index = 0; $index -lt $scenarios.Count; $index++) {
            $scenario = $scenarios[$index]
            foreach ($iteration in @('init', 'idem')) {
                foreach ($parameter in $scriptParameters) {
                    $expression = $expressions[$parameter].
                    Replace('deployment().name', "'$($scenario.root)'").
                    Replace('resourceLocation', "'$($scenario.location)'").
                    Replace('namePrefix', "'$($scenario.prefix)'").
                    Replace('serviceShort', "'$($scenario.service)'")
                    $parameterSource += "param ${parameter}${index}${iteration} = $expression"
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'script-names.bicepparam'
        $outputPath = Join-Path $TestDrive 'script-names.json'
        $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters

        $fixtureOutput = Join-Path $TestDrive 'linux.max.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $dependencies = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and
                $_.properties.parameters.ContainsKey('storageUploadDeploymentScriptName')
            })[0]
        $testModule = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and
                $_.properties.parameters.ContainsKey('skuName')
            })[0]
        $dependencyResources = $dependencies.properties.template.resources
        $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
        $scripts = @($dependencyResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
    }

    It 'Changes both script names for a new root attempt in the same region' {
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}0init"].value | Should -Not -Be $names["${parameter}1init"].value
        }
    }

    It 'Changes both script names when the deployment region changes' {
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}0init"].value | Should -Not -Be $names["${parameter}2init"].value
        }
    }

    It 'Keeps both script identities stable between init and idem' {
        foreach ($index in 0..5) {
            foreach ($parameter in $scriptParameters) {
                $names["${parameter}${index}init"].value | Should -BeExactly $names["${parameter}${index}idem"].value
            }
        }
        $dependencies.ContainsKey('copy') | Should -BeFalse
        $testModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $testModule.copy.mode | Should -Be 'serial'
        $testModule.copy.batchSize | Should -Be 1
    }

    It 'Keeps generated names valid within the 90-character API limit' {
        foreach ($entry in $names.Values) {
            $entry.value | Should -Match '^[a-zA-Z0-9][a-zA-Z0-9-]{0,89}$'
        }
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}4init"].value.Length | Should -Be 90
        }
    }

    It 'Keeps SSH and upload script identities distinct after truncation' {
        foreach ($index in 0..5) {
            $names["storageUploadDeploymentScriptName${index}init"].value |
                Should -Not -Be $names["sshDeploymentScriptName${index}init"].value
        }
        foreach ($parameter in $scriptParameters) {
            $names["${parameter}4init"].value | Should -Not -Be $names["${parameter}5init"].value
        }
    }

    It 'Passes the qualified names through to both deployment script resources' {
        $scripts.Count | Should -Be 2
        $scripts.name | Should -Contain "[parameters('storageUploadDeploymentScriptName')]"
        $scripts.name | Should -Contain "[parameters('sshDeploymentScriptName')]"
        foreach ($parameter in $scriptParameters) {
            $dependencies.properties.parameters[$parameter].value | Should -Match 'deployment\(\)\.name'
            $dependencies.properties.parameters[$parameter].value | Should -Match "parameters\('resourceLocation'\)"
        }
    }

    It 'Preserves managed identity permissions, cleanup and script outputs' {
        foreach ($script in $scripts) {
            $script.identity.type | Should -Be 'UserAssigned'
            $script.properties.retentionInterval | Should -Be 'P1D'
            $script.properties.ContainsKey('cleanupPreference') | Should -BeFalse
            @($script.dependsOn | Where-Object { $_ -match "Microsoft.Authorization/roleAssignments.+Contributor" }).Count | Should -Be 1
        }
        $testModule.properties.parameters.publicKeys.value[0].keyData | Should -Match '\.outputs\.SSHKeyPublicKey\.value'
        $testModule.properties.parameters.extensionCustomScriptConfig.value.settings.fileUris[0] |
            Should -Match '\.outputs\.storageAccountCSEFileUrl\.value'
        $testModule.properties.parameters.disablePasswordAuthentication.value | Should -BeTrue
    }

    It 'Preserves region selection and zonal Linux scale-set coverage' {
        $template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
        $testModule.properties.parameters.location.value | Should -Be "[parameters('resourceLocation')]"
        $testModule.properties.parameters.osType.value | Should -Be 'Linux'
        $testModule.properties.parameters.skuName.value | Should -Be 'Standard_D4ads_v5'
        $testModule.properties.parameters.availabilityZones.value | Should -Be @(2)
    }
}

Describe 'Windows maximum fixture upload-script identity' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'windows.max' 'main.test.bicep'
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $nameMatches = [regex]::Matches($source, '(?m)^\s+storageUploadDeploymentScriptName: (?<expression>[^\r\n]+)')
        if ($nameMatches.Count -ne 1) { throw 'Expected one Windows max upload-script name expression.' }

        $baseline = @{
            subscription = '00000000-0000-4000-8000-000000000001'
            group = 'fixture-one'
            root = 'attempt-one'
            location = 'norwayeast'
            prefix = 'gci'
            service = 'cvmsswinmax'
        }
        $scenarios = @(
            @{}
            @{ root = 'attempt-two' }
            @{ location = 'eastus' }
            @{ subscription = '00000000-0000-4000-8000-000000000002' }
            @{ group = 'fixture-two' }
            @{ root = 'attempt-two'; location = 'eastus' }
            @{ root = 'attempt-three'; location = 'centralus' }
            @{ prefix = ('g' * 54) }
            @{ prefix = ('g' * 55) }
            @{ prefix = ('g' * 56) }
            @{ prefix = ('g' * 100); service = ('s' * 100 + 'a') }
            @{ prefix = ('g' * 100); service = ('s' * 100 + 'b') }
            @{ prefix = ('g' * 100 + 'b'); service = ('s' * 100 + 'a') }
            @{ prefix = ''; service = '' }
            @{ root = ('r' * 64); group = ('g' * 90) }
        )
        $parameterSource = @('using none')
        for ($index = 0; $index -lt $scenarios.Count; $index++) {
            $scenario = $baseline.Clone()
            foreach ($entry in $scenarios[$index].GetEnumerator()) { $scenario[$entry.Key] = $entry.Value }
            foreach ($iteration in @('init', 'idem')) {
                foreach ($repetition in 0..1) {
                    $expression = $nameMatches[0].Groups['expression'].Value.
                    Replace('resourceGroup.id', "'/subscriptions/$($scenario.subscription)/resourceGroups/$($scenario.group)'").
                    Replace('deployment().name', "'$($scenario.root)'").
                    Replace('resourceLocation', "'$($scenario.location)'").
                    Replace('namePrefix', "'$($scenario.prefix)'").
                    Replace('serviceShort', "'$($scenario.service)'").
                    Replace('iteration', "'$iteration'")
                    $parameterSource += "param upload${index}${iteration}${repetition} = $expression"
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'windows-upload-names.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'windows-upload-names.json'
        $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:windowsUploadNames = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters

        $fixtureOutput = Join-Path $TestDrive 'windows.max.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $script:windowsUploadTemplate = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $script:windowsUploadTemplate.resources
        $resources = $resources -is [System.Collections.IDictionary] ? @($resources.Values) : @($resources)
        $script:windowsUploadDependencies = @($resources | Where-Object {
                $_.properties.parameters -is [System.Collections.IDictionary] -and
                $_.properties.parameters.Contains('storageUploadDeploymentScriptName')
            })[0]
        $script:windowsUploadTestModule = @($resources | Where-Object {
                $_.properties.parameters -is [System.Collections.IDictionary] -and
                $_.properties.parameters.Contains('skuName')
            })[0]
        $dependencyResources = $script:windowsUploadDependencies.properties.template.resources
        $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
        $script:windowsUploadScripts = @($dependencyResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
    }

    It 'Separates outer root attempts in the same region' {
        $script:windowsUploadNames.upload0init0.value | Should -Not -Be $script:windowsUploadNames.upload1init0.value
    }

    It 'Separates regions while retaining the same outer root name' {
        $script:windowsUploadNames.upload0init0.value | Should -Not -Be $script:windowsUploadNames.upload2init0.value
    }

    It 'Separates otherwise identical target subscriptions' {
        $script:windowsUploadNames.upload0init0.value | Should -Not -Be $script:windowsUploadNames.upload3init0.value
    }

    It 'Separates otherwise identical target resource groups' {
        $script:windowsUploadNames.upload0init0.value | Should -Not -Be $script:windowsUploadNames.upload4init0.value
    }

    It 'Separates all three regional attempts' {
        @(@(0, 5, 6) | ForEach-Object { $script:windowsUploadNames["upload${_}init0"].value } | Select-Object -Unique).Count |
            Should -Be 3
    }

    It 'Keeps repeated evaluation and init/idem stable within each outer attempt' {
        foreach ($index in 0..14) {
            foreach ($iteration in @('init', 'idem')) {
                foreach ($repetition in 0..1) {
                    $script:windowsUploadNames["upload${index}${iteration}${repetition}"].value |
                        Should -BeExactly $script:windowsUploadNames["upload${index}init0"].value
                }
            }
        }
    }

    It 'Shares one dependency deployment across serial init/idem' {
        $script:windowsUploadDependencies.Contains('copy') | Should -BeFalse
        $script:windowsUploadTestModule.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]"
        $script:windowsUploadTestModule.copy.mode | Should -BeExactly 'serial'
        $script:windowsUploadTestModule.copy.batchSize | Should -Be 1
    }

    It 'Keeps names valid within the native 1-90 character limit for all input boundaries' {
        foreach ($entry in $script:windowsUploadNames.Values) {
            $entry.value | Should -Match '^[a-zA-Z0-9][a-zA-Z0-9-]{0,89}$'
        }
    }

    It 'Bounds readable prefixes without truncating the isolation suffix' {
        $script:windowsUploadNames.upload7init0.value.Length | Should -Be 89
        foreach ($index in 8..12) {
            $script:windowsUploadNames["upload${index}init0"].value.Length | Should -Be 90
        }
    }

    It 'Preserves the recognizable prefix for normal fixture inputs' {
        $script:windowsUploadNames.upload0init0.value | Should -Match '^dep-gci-sads-cvmsswinmax-[a-z0-9]{13}$'
    }

    It 'Keeps long prefix and service inputs distinct after readable-prefix truncation' {
        $script:windowsUploadNames.upload10init0.value | Should -Not -Be $script:windowsUploadNames.upload11init0.value
        $script:windowsUploadNames.upload10init0.value | Should -Not -Be $script:windowsUploadNames.upload12init0.value
    }

    It 'Forwards the actual target scope and outer root identity to the upload script name' {
        $script:windowsUploadDependencies.resourceGroup | Should -BeExactly "[parameters('resourceGroupName')]"
        $name = $script:windowsUploadDependencies.properties.parameters.storageUploadDeploymentScriptName.value
        $name | Should -Match "subscriptionResourceId\('Microsoft.Resources/resourceGroups', parameters\('resourceGroupName'\)\)"
        $name | Should -Match 'deployment\(\)\.name'
        $name | Should -Match "parameters\('resourceLocation'\)"
    }

    It 'Preserves the script resource, runtime and default supporting-resource cleanup' {
        $script:windowsUploadScripts.Count | Should -Be 1
        $script:windowsUploadScripts[0].name | Should -BeExactly "[parameters('storageUploadDeploymentScriptName')]"
        $script:windowsUploadScripts[0].apiVersion | Should -BeExactly '2023-08-01'
        $script:windowsUploadScripts[0].kind | Should -BeExactly 'AzurePowerShell'
        $script:windowsUploadScripts[0].properties.azPowerShellVersion | Should -BeExactly '11.0'
        $script:windowsUploadScripts[0].properties.retentionInterval | Should -BeExactly 'P1D'
        foreach ($property in @('cleanupPreference', 'forceUpdateTag', 'containerSettings')) {
            $script:windowsUploadScripts[0].properties.Contains($property) | Should -BeFalse
        }
    }

    It 'Preserves identity permissions and upload output wiring' {
        $script:windowsUploadScripts[0].identity.type | Should -BeExactly 'UserAssigned'
        @($script:windowsUploadScripts[0].dependsOn | Where-Object { $_ -match 'Microsoft.Authorization/roleAssignments.+Contributor' }).Count |
            Should -Be 1
        $script:windowsUploadTestModule.properties.parameters.extensionCustomScriptConfig.value.settings.fileUris[0] |
            Should -Match '\.outputs\.storageAccountCSEFileUrl\.value'
        $script:windowsUploadTestModule.properties.parameters.extensionCustomScriptConfig.value.protectedSettings.managedIdentityResourceId |
            Should -Match '\.outputs\.managedIdentityResourceId\.value'
        $script:windowsUploadDependencies.properties.template.outputs.storageAccountCSEFileName.value |
            Should -BeExactly "[variables('storageAccountCSEFileName')]"
    }

    It 'Preserves unpinned region selection and Windows max coverage' {
        $script:windowsUploadTemplate.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
        $script:windowsUploadTestModule.properties.parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
        $script:windowsUploadTestModule.properties.parameters.osType.value | Should -BeExactly 'Windows'
        $script:windowsUploadTestModule.properties.parameters.skuName.value | Should -BeExactly 'Standard_D4ads_v5'
        $script:windowsUploadTestModule.properties.parameters.Contains('availabilityZones') | Should -BeFalse
        $script:windowsUploadTestModule.properties.parameters.managedIdentities.value.systemAssigned | Should -BeFalse
        $script:windowsUploadTestModule.properties.parameters.extensionAzureDiskEncryptionConfig.value.enabled | Should -BeTrue
        $script:windowsUploadTestModule.properties.parameters.extensionAntiMalwareConfig.value.enabled | Should -BeTrue
        $script:windowsUploadTestModule.properties.parameters.encryptionAtHost.value | Should -BeFalse
    }
}
