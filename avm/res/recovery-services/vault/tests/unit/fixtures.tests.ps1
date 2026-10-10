BeforeAll {
    $source = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
    $output = Join-Path $TestDrive 'vault.max.json'
    $diagnostics = bicep build $source --no-restore --outfile $output 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $testModules = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('protectedItems')
        })
    if ($testModules.Count -ne 1) { throw 'Expected one tested Vault module.' }
    $vaultParameters = $testModules[0].properties.parameters
    $dependencies = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('virtualMachineName')
        })
    if ($dependencies.Count -ne 1) { throw 'Expected one Vault dependency deployment.' }
    $dependencyResources = $dependencies[0].properties.template.resources
    $dependencyResources = $dependencyResources -is [System.Collections.IDictionary] ? @($dependencyResources.Values) : @($dependencyResources)
    $virtualMachines = @($dependencyResources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('vmSize')
        })
    if ($virtualMachines.Count -ne 1) { throw 'Expected one backup-source VM deployment.' }
    $vmParameters = $virtualMachines[0].properties.parameters
}

Describe 'Recovery Services Vault backup-source fixture' {
    It 'Uses the compatible two-core VM size' {
        $vmParameters.vmSize.value | Should -Be 'Standard_D2ads_v5'
    }

    It 'Keeps the VM unzoned and lets CI choose the resource location' {
        $vmParameters.availabilityZone.value | Should -Be -1
        $vmParameters.location.value | Should -Be "[parameters('location')]"
        $template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
        $dependencies[0].properties.parameters.location.value | Should -Be "[parameters('resourceLocation')]"
    }

    It 'Preserves the Linux generation-two image, Premium disk and SSH authentication' {
        $vmParameters.osType.value | Should -Be 'Linux'
        $vmParameters.imageReference.value.sku | Should -Be '22_04-lts-gen2'
        $vmParameters.osDisk.value.diskSizeGB | Should -Be 128
        $vmParameters.osDisk.value.managedDisk.storageAccountType | Should -Be 'Premium_LRS'
        $vmParameters.disablePasswordAuthentication.value | Should -BeTrue
        $vmParameters.publicKeys.value[0].path | Should -Be '/home/localAdminUser/.ssh/authorized_keys'
    }

    It 'Protects the created VM using the existing backup policy' {
        $protectedItems = @($vaultParameters.protectedItems.value)
        $protectedItems.Count | Should -Be 1
        $protectedItems[0].protectedItemType | Should -Be 'Microsoft.Compute/virtualMachines'
        $protectedItems[0].sourceResourceId | Should -Match 'outputs\.virtualMachineResourceId\.value'
        $protectedItems[0].policyName | Should -Be 'VMpolicy'
        $vaultParameters.backupPolicies.value.name | Should -Contain 'VMpolicy'
    }
}
