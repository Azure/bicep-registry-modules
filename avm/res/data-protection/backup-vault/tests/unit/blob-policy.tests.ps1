param (
    [string] $RepoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')).Path
)

Describe 'Backup vault maximum fixture policy contract' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
        $compiledPath = Join-Path $TestDrive 'max.json'
        $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $fixture = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $resources = $fixture.resources -is [System.Collections.IDictionary] ? @($fixture.resources.Values) : @($fixture.resources)
        $testCalls = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and
            $_.properties.parameters -and $_.properties.parameters.Contains('backupPolicies')
        })
        if ($testCalls.Count -ne 1) { throw 'Expected one maximum fixture deployment with backup policies.' }
        $testCall = $testCalls[0]
        $policies = @($testCall.properties.parameters.backupPolicies.value)
        $diskPolicy = $policies[0].properties
        $blobPolicy = $policies[1].properties
        $blobRetention = @($blobPolicy.policyRules | Where-Object objectType -EQ 'AzureRetentionRule')
    }

    It 'Exercises the disk policy followed by the combined Blob policy' {
        $policies | Should -HaveCount 2
        $policies[0].name | Should -BeExactly "[variables('diskBackupPolicyName')]"
        $diskPolicy.datasourceTypes | Should -HaveCount 1
        $diskPolicy.datasourceTypes[0] | Should -BeExactly 'Microsoft.Compute/disks'
        $policies[1].name | Should -BeExactly "[variables('blobBackupPolicyName')]"
        $blobPolicy.datasourceTypes | Should -HaveCount 1
        $blobPolicy.datasourceTypes[0] | Should -BeExactly 'Microsoft.Storage/storageAccounts/blobServices'
    }

    It 'Uses distinct reserved retention names for operational and vaulted Blob backups' {
        $blobRetention | Should -HaveCount 2
        @($blobPolicy.policyRules.name | Sort-Object -Unique) | Should -HaveCount $blobPolicy.policyRules.Count
        $operational = @($blobRetention | Where-Object { $_.lifecycles[0].sourceDataStore.dataStoreType -eq 'OperationalStore' })
        $vaulted = @($blobRetention | Where-Object { $_.lifecycles[0].sourceDataStore.dataStoreType -eq 'VaultStore' })
        $operational | Should -HaveCount 1
        $vaulted | Should -HaveCount 1
        $operational[0].name | Should -BeExactly 'Default_OperationalStore'
        $vaulted[0].name | Should -BeExactly 'Default'
    }

    It 'Preserves <duration> retention in <store>' -ForEach @(
        @{ store = 'OperationalStore'; duration = 'P30D' }
        @{ store = 'VaultStore'; duration = 'P90D' }
    ) {
        $rules = @($blobRetention | Where-Object { $_.lifecycles[0].sourceDataStore.dataStoreType -eq $store })
        $rules | Should -HaveCount 1
        $rules[0].isDefault | Should -BeTrue
        $rules[0].lifecycles | Should -HaveCount 1
        $lifecycle = $rules[0].lifecycles[0]
        $lifecycle.deleteAfter.objectType | Should -BeExactly 'AbsoluteDeleteOption'
        $lifecycle.deleteAfter.duration | Should -BeExactly $duration
        $lifecycle.sourceDataStore.objectType | Should -BeExactly 'DataStoreInfoBase'
        $lifecycle.targetDataStoreCopySettings | Should -HaveCount 0
    }

    It 'Keeps daily discrete Blob backups tagged to the vaulted retention rule' {
        $backups = @($blobPolicy.policyRules | Where-Object objectType -EQ 'AzureBackupRule')
        $backups | Should -HaveCount 1
        $backup = $backups[0]
        $backup.backupParameters.backupType | Should -BeExactly 'Discrete'
        $backup.dataStore.dataStoreType | Should -BeExactly 'VaultStore'
        $backup.trigger.objectType | Should -BeExactly 'ScheduleBasedTriggerContext'
        $backup.trigger.schedule.repeatingTimeIntervals | Should -HaveCount 1
        $backup.trigger.schedule.repeatingTimeIntervals[0] | Should -BeExactly 'R/2025-03-31T00:00:00+04:00/P1D'
        $backup.trigger.schedule.timeZone | Should -BeExactly 'Arabian Standard Time'
        $backup.trigger.taggingCriteria | Should -HaveCount 1
        $tag = $backup.trigger.taggingCriteria[0]
        $tag.isDefault | Should -BeTrue
        $tag.taggingPriority | Should -Be 99
        $tag.tagInfo.id | Should -BeExactly 'Default_'
        $tag.tagInfo.tagName | Should -BeExactly 'Default'
        $taggedRetention = @($blobRetention | Where-Object name -EQ $tag.tagInfo.tagName)
        $taggedRetention | Should -HaveCount 1
        $taggedRetention[0].lifecycles[0].sourceDataStore.dataStoreType | Should -BeExactly $backup.dataStore.dataStoreType
    }

    It 'Preserves seven-day incremental operational disk backups' {
        $diskPolicy.policyRules | Should -HaveCount 2
        $backups = @($diskPolicy.policyRules | Where-Object objectType -EQ 'AzureBackupRule')
        $backups | Should -HaveCount 1
        $backups[0].backupParameters.backupType | Should -BeExactly 'Incremental'
        $backups[0].dataStore.dataStoreType | Should -BeExactly 'OperationalStore'
        $backups[0].trigger.schedule.repeatingTimeIntervals[0] | Should -BeExactly 'R/2025-03-31T00:00:00+04:00/P1D'
        $retention = @($diskPolicy.policyRules | Where-Object objectType -EQ 'AzureRetentionRule')
        $retention | Should -HaveCount 1
        $retention[0].name | Should -BeExactly 'Default'
        $retention[0].lifecycles[0].sourceDataStore.dataStoreType | Should -BeExactly 'OperationalStore'
        $retention[0].lifecycles[0].deleteAfter.duration | Should -BeExactly 'P7D'
    }

    It 'Keeps the Blob instance and both disk instances bound to their intended policies' {
        $instances = @($testCall.properties.parameters.backupInstances.value)
        $instances | Should -HaveCount 3
        $instances[0].dataSourceInfo.datasourceType | Should -BeExactly 'Microsoft.Storage/storageAccounts/blobServices'
        $instances[0].policyInfo.policyName | Should -BeExactly $policies[1].name
        $instances[0].policyInfo.policyParameters.backupDatasourceParametersList[0].objectType |
            Should -BeExactly 'BlobBackupDatasourceParameters'
        foreach ($instance in $instances[1..2]) {
            $instance.dataSourceInfo.datasourceType | Should -BeExactly 'Microsoft.Compute/disks'
            $instance.policyInfo.policyName | Should -BeExactly $policies[0].name
            $instance.policyInfo.policyParameters.dataStoreParametersList[0].dataStoreType |
                Should -BeExactly 'OperationalStore'
        }
    }

    It 'Passes each fixture policy through the production parent and policy child unchanged' {
        $parent = $testCall.properties.template
        $resources = $parent.resources -is [System.Collections.IDictionary] ? @($parent.resources.Values) : @($parent.resources)
        $calls = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.copy.name -eq 'backupVault_backupPolicies'
        })
        $calls | Should -HaveCount 1
        $calls[0].name | Should -Match '-BV-BackupPolicy-'
        $calls[0].properties.parameters.properties.value |
            Should -BeExactly "[coalesce(parameters('backupPolicies'), createArray())[copyIndex()].properties]"
        $child = $calls[0].properties.template
        $resources = $child.resources -is [System.Collections.IDictionary] ? @($child.resources.Values) : @($child.resources)
        $policyResources = @($resources | Where-Object type -EQ 'Microsoft.DataProtection/backupVaults/backupPolicies')
        $policyResources | Should -HaveCount 1
        $policyResources[0].properties | Should -BeExactly "[parameters('properties')]"
    }
}
