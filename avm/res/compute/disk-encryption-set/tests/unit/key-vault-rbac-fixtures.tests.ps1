Describe 'Disk Encryption Set RBAC fixture readiness' {
    BeforeAll {
        $modulePath = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent

        function Get-TemplateResource {
            param([System.Collections.IDictionary] $Template)
            if ($Template.resources -is [System.Collections.IDictionary]) {
                return @($Template.resources.Values)
            }
            return @($Template.resources)
        }

        function Build-TestTemplate {
            param([string] $Path, [string] $OutputName)
            $output = Join-Path $TestDrive $OutputName
            $diagnostics = bicep build $Path --no-restore --outfile $output 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            return Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        }

        $permissionTemplate = Build-TestTemplate `
            -Path (Join-Path $modulePath 'modules' 'nested_keyVaultPermissions.bicep') `
            -OutputName 'permissions.json'
        $script:permissionTemplateHash = $permissionTemplate.metadata._generator.templateHash
        $compiled = @{}
        foreach ($scenarioName in @('max', 'key-rbac')) {
            $template = Build-TestTemplate `
                -Path (Join-Path $modulePath 'tests' 'e2e' $scenarioName 'main.test.bicep') `
                -OutputName "$scenarioName.json"
            $resources = @(Get-TemplateResource $template)
            $dependencies = @($resources | Where-Object {
                    $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -match 'nestedDependencies'
                })
            $tested = @($resources | Where-Object {
                    $_.type -eq 'Microsoft.Resources/deployments' -and $_.copy.name -eq 'testDeployment'
                })
            if ($dependencies.Count -ne 1 -or $tested.Count -ne 1) {
                throw "Expected one dependency module and one tested module in $scenarioName."
            }
            $compiled[$scenarioName] = @{
                dependencies = $dependencies[0].properties.template
                tested = $tested[0]
            }
        }
    }

    Context '<scenario> fixture' -ForEach @(
        @{ scenario = 'max' }
        @{ scenario = 'key-rbac' }
    ) {
        BeforeAll {
            $fixture = $compiled[$scenario]
            $resources = @(Get-TemplateResource $fixture.dependencies)
            $script:permissionModules = @($resources | Where-Object type -EQ 'Microsoft.Resources/deployments')
            $script:probes = @($resources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
        }

        It 'Creates permissions through the actual module helper, not a duplicated role resource' {
            $script:permissionModules | Should -HaveCount 1
            $script:permissionModules[0].properties.template.metadata._generator.templateHash | Should -BeExactly $script:permissionTemplateHash
            $script:permissionModules[0].properties.parameters.rbacAuthorizationEnabled.value | Should -BeTrue
            @($resources | Where-Object type -EQ 'Microsoft.Authorization/roleAssignments') | Should -HaveCount 0
        }

        It 'Waits for key access as the same identity after permission creation' {
            $script:permissionModules | Should -HaveCount 1
            $script:probes | Should -HaveCount 1
            $permissions = $script:permissionModules[0]
            $probe = $script:probes[0]
            $probe.identity.type | Should -BeExactly 'UserAssigned'
            $identityExpression = $permissions.properties.parameters.userAssignedIdentityResourceId.value
            $identityBody = $identityExpression.Substring(1, $identityExpression.Length - 2)
            $expectedIdentityKeys = @($identityExpression, "[format('{0}', $identityBody)]")
            @($probe.identity.userAssignedIdentities.Keys) | Should -HaveCount 1
            @($probe.identity.userAssignedIdentities.Keys | Where-Object { $_ -in $expectedIdentityKeys }) | Should -HaveCount 1
            $moduleNameExpression = $permissions.name.Substring(1, $permissions.name.Length - 2)
            $expectedDependencies = @(
                'keyVaultPermissions'
                "[resourceId('Microsoft.Resources/deployments', $moduleNameExpression)]"
            )
            @($probe.dependsOn | Where-Object { $_ -in $expectedDependencies }) | Should -HaveCount 1
            $probe.properties.cleanupPreference | Should -BeExactly 'Always'
        }

        It 'Keeps permission creation enabled and awaited in the module under test' {
            $fixture.tested.properties.parameters.enableKeyPermissions.value | Should -BeTrue
            $main = $fixture.tested.properties.template
            $permissions = $main.resources.keyVaultPermissionsUami
            $permissions.properties.template.metadata._generator.templateHash | Should -BeExactly $script:permissionTemplateHash
            $permissions.condition | Should -BeExactly "[and(parameters('enableKeyPermissions'), not(variables('isHSMManagedCMK')))]"
            $permissions.properties.parameters.keyVaultResourceId.value | Should -BeExactly "[parameters('customerManagedKey').keyVaultResourceId]"
            $permissions.properties.parameters.keyName.value | Should -BeExactly "[parameters('customerManagedKey').keyName]"
            $permissions.properties.parameters.userAssignedIdentityResourceId.value | Should -BeExactly "[coalesce(tryGet(parameters('managedIdentities'), 'userAssignedResourceIds'), createArray())[copyIndex()]]"
            $main.resources.diskEncryptionSet.dependsOn | Should -Contain 'keyVaultPermissionsUami'
            ($fixture.tested.dependsOn -join ' ') | Should -Match 'nestedDependencies'
            $fixture.tested.copy.mode | Should -BeExactly 'serial'
            $fixture.tested.copy.batchSize | Should -Be 1
        }
    }

    Context 'Bounded data-plane readiness probe' {
        BeforeAll {
            $probe = @(Get-TemplateResource $compiled.max.dependencies |
                    Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
            if ($probe.Count -ne 1) { throw 'Expected the existing max readiness probe.' }
            $script:readinessScript = [scriptblock]::Create($probe[0].properties.scriptContent)
            function Get-AzKeyVaultKey {
                [CmdletBinding()]
                param([string] $VaultName, [string] $Name)
                throw "The Key Vault command for [$VaultName/$Name] must be mocked in this offline test."
            }
        }

        BeforeEach {
            Mock Start-Sleep {}
        }

        It 'Stops probing after key access succeeds' {
            $script:probeAttempts = 0
            Mock Get-AzKeyVaultKey {
                $script:probeAttempts++
                if ($script:probeAttempts -lt 3) { throw 'RBAC is not ready.' }
                return @{ Id = 'https://fixture.vault.azure.net/keys/fixture-key/version' }
            }
            . $script:readinessScript
            $DeploymentScriptOutputs.attempts | Should -Be 3
            Should -Invoke Get-AzKeyVaultKey -Times 3 -Exactly
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 10 }
        }

        It 'Fails explicitly when the bounded attempts are exhausted' {
            Mock Get-AzKeyVaultKey { throw 'RBAC is not ready.' }
            { . $script:readinessScript } | Should -Throw '*did not propagate*'
            Should -Invoke Get-AzKeyVaultKey -Times 10 -Exactly
            Should -Invoke Start-Sleep -Times 9 -Exactly -ParameterFilter { $Seconds -eq 10 }
        }
    }
}
