BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' '..'
    $fixtures = @{}
    foreach ($scenario in @('linux.max', 'waf-aligned', 'windows.disks', 'windows.hostpool', 'windows.max', 'windows.zrsdisks')) {
        $source = Join-Path $modulePath 'tests' 'e2e' $scenario 'main.test.bicep'
        $output = Join-Path $TestDrive "$scenario.json"
        $diagnostics = bicep build $source --no-restore --outfile $output 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable
        $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
        $testModules = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('vmSize')
            })
        if ($testModules.Count -ne 1) { throw "Expected one tested VM module in [$scenario]." }
        $fixtures[$scenario] = @{
            Template = $template
            Resources = $resources
            Parameters = $testModules[0].properties.parameters
        }
    }
}

Describe 'Virtual machine fixture compatibility' {
    Context '<scenario>' -ForEach @(
        @{ scenario = 'linux.max'; zone = 1 }
        @{ scenario = 'waf-aligned'; zone = 2 }
        @{ scenario = 'windows.disks'; zone = 1 }
        @{ scenario = 'windows.hostpool'; zone = -1 }
        @{ scenario = 'windows.max'; zone = 2 }
        @{ scenario = 'windows.zrsdisks'; zone = 2 }
    ) {
        It 'Uses the compatible CI VM size' {
            $fixtures[$scenario].Parameters.vmSize.value | Should -Be 'Standard_D4ads_v5'
        }

        It 'Uses the SCSI disk controller' {
            $fixtures[$scenario].Parameters.diskControllerType.value | Should -Be 'SCSI'
        }

        It 'Preserves availability-zone coverage' {
            $fixtures[$scenario].Parameters.availabilityZone.value | Should -Be $zone
        }

        It 'Lets CI choose the resource location' {
            $fixtures[$scenario].Template.parameters.resourceLocation.defaultValue | Should -Be '[deployment().location]'
            $resourceGroups = @($fixtures[$scenario].Resources | Where-Object type -EQ 'Microsoft.Resources/resourceGroups')
            $resourceGroups.Count | Should -Be 1
            $resourceGroups[0].location | Should -Be "[parameters('resourceLocation')]"
        }
    }

    It 'Keeps Azure Disk Encryption and backup enabled in <scenario>' -ForEach @(
        @{ scenario = 'linux.max' }
        @{ scenario = 'waf-aligned' }
        @{ scenario = 'windows.max' }
    ) {
        $parameters = $fixtures[$scenario].Parameters
        $parameters.extensionAzureDiskEncryptionConfig.value.enabled | Should -BeTrue
        $parameters.backupPolicyName.value | Should -Not -BeNullOrEmpty
        $parameters.backupVaultName.value | Should -Not -BeNullOrEmpty
        $parameters.encryptionAtHost.value | Should -BeFalse
    }

    It 'Uses the selected region for Linux max deployment names and the VM' {
        $fixture = $fixtures['linux.max']
        $fixture.Parameters.location.value | Should -Be "[parameters('resourceLocation')]"
        $deployments = @($fixture.Resources | Where-Object type -EQ 'Microsoft.Resources/deployments')
        $deployments.Count | Should -Be 3
        foreach ($deployment in $deployments) {
            $deployment.name | Should -Match "parameters\('resourceLocation'\)"
        }
    }

    It 'Keeps ZRS storage for the OS and data disk' {
        $parameters = $fixtures['windows.zrsdisks'].Parameters
        $parameters.osDisk.value.managedDisk.storageAccountType | Should -Be 'Premium_ZRS'
        $parameters.dataDisks.value[0].managedDisk.storageAccountType | Should -Be 'Premium_ZRS'
    }

    It 'Keeps existing encrypted OS and shared data disk attachments' {
        $parameters = $fixtures['windows.disks'].Parameters
        $parameters.osDisk.value.managedDisk.resourceId | Should -Not -BeNullOrEmpty
        $parameters.osDisk.value.managedDisk.diskEncryptionSetResourceId | Should -Not -BeNullOrEmpty
        $parameters.dataDisks.value[1].managedDisk.resourceId | Should -Not -BeNullOrEmpty
        $parameters.dataDisks.value[1].managedDisk.diskEncryptionSetResourceId | Should -Not -BeNullOrEmpty
    }

    It 'Keeps host-pool registration enabled with its dependency outputs' {
        $registration = $fixtures['windows.hostpool'].Parameters.extensionHostPoolRegistration.value
        $registration.enabled | Should -BeTrue
        $registration.hostPoolName | Should -Match 'outputs\.hostPoolName\.value'
        $registration.registrationInfoToken | Should -Match 'outputs\.registrationInfoToken\.value'
    }

    It 'Creates the source OS disk on a compatible SCSI VM' {
        $dependencies = @($fixtures['windows.disks'].Resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('osDiskVMName')
            })
        $dependencies.Count | Should -Be 1
        $resources = $dependencies[0].properties.template.resources
        $resources = $resources -is [System.Collections.IDictionary] ? @($resources.Values) : @($resources)
        $sourceVMs = @($resources | Where-Object type -EQ 'Microsoft.Compute/virtualMachines')
        $sourceVMs.Count | Should -Be 1
        $sourceVMs[0].properties.hardwareProfile.vmSize | Should -Be 'Standard_D4ads_v5'
        $sourceVMs[0].properties.storageProfile.diskControllerType | Should -Be 'SCSI'
    }
}
