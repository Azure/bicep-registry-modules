Describe 'Maximum VM fixture deployment script identities' {
    Context '<scenario>' -ForEach @(
        @{
            scenario = 'windows.max'
            scriptParameters = @('storageUploadDeploymentScriptName', 'waitDeploymentScriptName')
            operatingSystem = 'Windows'
            zone = 2
        }
        @{
            scenario = 'linux.max'
            scriptParameters = @('storageUploadDeploymentScriptName', 'sshDeploymentScriptName', 'waitDeploymentScriptName')
            operatingSystem = 'Linux'
            zone = 1
        }
    ) {
        BeforeAll {
            $modulePath = Join-Path $PSScriptRoot '..' '..'
            $fixturePath = Join-Path $modulePath 'tests' 'e2e' $scenario 'main.test.bicep'
            $source = Get-Content -LiteralPath $fixturePath -Raw
            $serviceMatch = [regex]::Match($source, "(?m)^param serviceShort string = '(?<value>[^']+)'")
            if (-not $serviceMatch.Success) { throw "Missing serviceShort default in [$scenario]." }
            $serviceShort = $serviceMatch.Groups['value'].Value
            $expressions = @{}
            foreach ($parameter in $scriptParameters) {
                $match = [regex]::Match($source, "(?m)^\s+$parameter`: (?<expression>[^\r\n]+)")
                if (-not $match.Success) { throw "Missing deployment script name expression for $parameter." }
                $expressions[$parameter] = $match.Groups['expression'].Value
            }

            $inputs = @(
                @{ root = 'attempt-one'; location = 'norwayeast'; prefix = 'gci'; service = $serviceShort }
                @{ root = 'attempt-two'; location = 'norwayeast'; prefix = 'gci'; service = $serviceShort }
                @{ root = 'attempt-one'; location = 'eastasia'; prefix = 'gci'; service = $serviceShort }
                @{ root = 'attempt-three'; location = 'centralus'; prefix = 'gci'; service = $serviceShort }
                @{ root = 'attempt-one'; location = 'norwayeast'; prefix = ('g' * 100); service = ('s' * 100 + '1') }
                @{ root = 'attempt-one'; location = 'norwayeast'; prefix = ('g' * 100); service = ('s' * 100 + '2') }
                @{ root = 'attempt-one'; location = 'norwayeast'; prefix = ('g' * 100 + '2'); service = ('s' * 100 + '1') }
            )
            $parameterSource = @('using none')
            for ($index = 0; $index -lt $inputs.Count; $index++) {
                $inputCase = $inputs[$index]
                foreach ($iteration in @('init', 'idem')) {
                    foreach ($parameter in $scriptParameters) {
                        $expression = $expressions[$parameter].
                        Replace('deployment().name', "'$($inputCase.root)'").
                        Replace('resourceLocation', "'$($inputCase.location)'").
                        Replace('namePrefix', "'$($inputCase.prefix)'").
                        Replace('serviceShort', "'$($inputCase.service)'")
                        $parameterSource += "param ${parameter}${index}${iteration} = $expression"
                    }
                }
            }
            $parameterPath = Join-Path $TestDrive "$scenario-names.bicepparam"
            $outputPath = Join-Path $TestDrive "$scenario-names.json"
            $parameterSource -join "`n" | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $names = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters

            $fixtureOutput = Join-Path $TestDrive "$scenario.json"
            $diagnostics = bicep build $fixturePath --no-restore --outfile $fixtureOutput 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $fixtureOutput -Raw | ConvertFrom-Json -AsHashtable
            $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
            $dependencyModules = @($resources | Where-Object {
                    $_.type -eq 'Microsoft.Resources/deployments' -and
                    $_.properties.parameters.ContainsKey('storageUploadDeploymentScriptName')
                })
            $testModules = @($resources | Where-Object {
                    $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('vmSize')
                })
            if ($dependencyModules.Count -ne 1 -or $testModules.Count -ne 1) {
                throw "Expected one dependency module and one tested VM module in [$scenario]."
            }
            $dependencies = $dependencyModules[0]
            $testModule = $testModules[0]
            $dependencyResources = $dependencies.properties.template.resources
            $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
            $scripts = @($dependencyResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
            $upload = @($scripts | Where-Object name -EQ "[parameters('storageUploadDeploymentScriptName')]")[0]
            $waitScript = @($scripts | Where-Object name -EQ "[parameters('waitDeploymentScriptName')]")[0]
        }

        It 'Changes every script identity for a new root attempt in the same region' {
            @($scriptParameters | Where-Object {
                    $names["${_}0init"].value -eq $names["${_}1init"].value
                }) | Should -BeNullOrEmpty
        }

        It 'Changes every script identity when the deployment region changes' {
            @($scriptParameters | Where-Object {
                    $names["${_}0init"].value -eq $names["${_}2init"].value
                }) | Should -BeNullOrEmpty
        }

        It 'Keeps script identities stable within the same root attempt' {
            foreach ($index in 0..6) {
                foreach ($parameter in $scriptParameters) {
                    $names["${parameter}${index}init"].value | Should -BeExactly $names["${parameter}${index}idem"].value
                }
            }
            $dependencies.ContainsKey('copy') | Should -BeFalse
            if ($operatingSystem -eq 'Windows') {
                $testModule.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
                $testModule.copy.mode | Should -Be 'serial'
                $testModule.copy.batchSize | Should -Be 1
            } else {
                $testModule.ContainsKey('copy') | Should -BeFalse
            }
        }

        It 'Keeps generated names within the 90-character deployment script limit' {
            foreach ($entry in $names.Values) {
                $entry.value | Should -Match '^[a-zA-Z0-9][a-zA-Z0-9-]{0,89}$'
            }
            foreach ($parameter in $scriptParameters) {
                $names["${parameter}4init"].value.Length | Should -Be 90
            }
        }

        It 'Keeps different script roles and full input names distinct after truncation' {
            foreach ($index in 0..6) {
                $roleNames = @($scriptParameters | ForEach-Object { $names["${_}${index}init"].value })
                @($roleNames | Select-Object -Unique).Count | Should -Be $scriptParameters.Count
            }
            foreach ($parameter in $scriptParameters) {
                $names["${parameter}4init"].value | Should -Not -Be $names["${parameter}5init"].value
                $names["${parameter}4init"].value | Should -Not -Be $names["${parameter}6init"].value
            }
        }

        It 'Passes root and region qualified names through to every deployment script resource' {
            $scripts.Count | Should -Be $scriptParameters.Count
            foreach ($parameter in $scriptParameters) {
                $scripts.name | Should -Contain "[parameters('$parameter')]"
                $dependencies.properties.parameters[$parameter].value | Should -Match 'deployment\(\)\.name'
                $dependencies.properties.parameters[$parameter].value | Should -Match "parameters\('resourceLocation'\)"
            }
        }

        It 'Waits for the upload account, container, identity and Contributor role before running' {
            $uploadDependencies = $upload.dependsOn -join "`n"
            $uploadDependencies | Should -Match "(?m)^storageAccount$|resourceId\('Microsoft.Storage/storageAccounts',"
            $uploadDependencies | Should -Match 'storageAccount::blobService::container|Microsoft.Storage/storageAccounts/blobServices/containers'
            $uploadDependencies | Should -Match 'managedIdentity|Microsoft.ManagedIdentity/userAssignedIdentities'
            $uploadDependencies | Should -Match 'msiRGContrRoleAssignment|Microsoft.Authorization/roleAssignments.+Contributor'
            $upload.properties.arguments | Should -Match "parameters\('storageAccountName'\)"
            $upload.properties.arguments | Should -Match 'resourceGroup\(\)\.name'
            $upload.properties.arguments | Should -Match "'scripts'"
        }

        It 'Preserves script identity, cleanup, retention and backup permission ordering' {
            foreach ($script in $scripts) {
                $script.identity.type | Should -Be 'UserAssigned'
                $script.properties.azPowerShellVersion | Should -Be '11.0'
                $script.properties.ContainsKey('forceUpdateTag') | Should -BeFalse
                $script.properties.ContainsKey('containerSettings') | Should -BeFalse
                $script.properties.ContainsKey('storageAccountSettings') | Should -BeFalse
            }
            $upload.properties.retentionInterval | Should -Be 'P1D'
            $upload.properties.ContainsKey('cleanupPreference') | Should -BeFalse
            $waitScript.properties.retentionInterval | Should -Be 'PT1H'
            $waitScript.properties.cleanupPreference | Should -Be 'Always'
            $waitScript.condition | Should -Match "parameters\('backupManagementServiceApplicationObjectId'\)"
            ($waitScript.dependsOn -join "`n") | Should -Match 'backupServiceKeyVaultPermissions|BackupManagementService-KeyVault-KeyVaultAdministrator-RoleAssignment'
        }

        It 'Preserves selected-region, zonal VM, encryption and backup coverage' {
            $parameters = $testModule.properties.parameters
            $template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
            $parameters.location.value | Should -Be "[parameters('resourceLocation')]"
            $parameters.osType.value | Should -Be $operatingSystem
            $parameters.vmSize.value | Should -Be 'Standard_D4ads_v5'
            $parameters.availabilityZone.value | Should -Be $zone
            $parameters.extensionAzureDiskEncryptionConfig.value.enabled | Should -BeTrue
            $parameters.backupPolicyName.value | Should -Match '\.outputs\.recoveryServicesVaultBackupPolicyName\.value'
            $parameters.extensionCustomScriptConfig.value.protectedSettings.fileUris[0] |
                Should -Match '\.outputs\.storageAccountCSEFileUrl\.value'
            if ($operatingSystem -eq 'Linux') {
                $parameters.publicKeys.value[0].keyData | Should -Match '\.outputs\.SSHKeyPublicKey\.value'
                $parameters.disablePasswordAuthentication.value | Should -BeTrue
                $parameters.extensionCustomScriptConfig.value.protectedSettings.managedIdentityResourceId |
                    Should -Match '\.outputs\.managedIdentityResourceId\.value'
            } else {
                $parameters.extensionCustomScriptConfig.value.protectedSettings.fileUris[0] |
                    Should -Match "listOutputsWithSecureValues\('nestedDependencies', '[^']+'\)\.storageAccountContainerCSFileSasToken"
            }
        }
    }
}
