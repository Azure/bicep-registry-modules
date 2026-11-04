Describe 'NetApp weekly snapshot schedules and volume LDAP configuration' {
    BeforeAll {
        $moduleRoot = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.FullName
        $account = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $snapshotPolicy = Get-Content -LiteralPath (Join-Path $moduleRoot 'snapshot-policy' 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $capacityPool = Get-Content -LiteralPath (Join-Path $moduleRoot 'capacity-pool' 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $volume = Get-Content -LiteralPath (Join-Path $moduleRoot 'capacity-pool' 'volume' 'main.json') -Raw | ConvertFrom-Json -AsHashtable

        $fixture = bicep build (Join-Path $PSScriptRoot 'fixtures' 'inputs.bicep') --stdout | ConvertFrom-Json -AsHashtable
        if ($LASTEXITCODE -ne 0) {
            throw 'Failed to compile the weekly snapshot and LDAP input regression fixture.'
        }
    }

    It 'Accepts single-day, multi-day and all-week schedules through the account input type' {
        $fixture.outputs.snapshotPolicies.value.weeklySchedule.day | Should -Be @(
            'Monday'
            'Monday,Tuesday'
            'Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday'
        )
    }

    It 'Does not restrict weekly snapshot days to a single enum value' {
        $snapshotPolicy.definitions.weeklyScheduleType.properties.day.type | Should -Be 'string'
        $snapshotPolicy.definitions.weeklyScheduleType.properties.day.ContainsKey('allowedValues') | Should -BeFalse
        $account.definitions.weeklyScheduleType.properties.day.ContainsKey('allowedValues') | Should -BeFalse
    }

    It 'Passes the weekly schedule unchanged to the snapshot policy resource' {
        $resource = $snapshotPolicy.resources.snapshotPolicies
        $resource.properties.weeklySchedule | Should -Be "[parameters('weeklySchedule')]"
    }

    It 'Accepts true, false and omitted LDAP values through the volume input type' {
        $fixture.outputs.volumes.value[0].ldapEnabled | Should -BeTrue
        $fixture.outputs.volumes.value[1].ldapEnabled | Should -BeFalse
        $fixture.outputs.volumes.value[2].ContainsKey('ldapEnabled') | Should -BeFalse
    }

    It 'Exposes optional LDAP configuration in the account and capacity pool schemas' {
        foreach ($template in @($account, $capacityPool)) {
            $template.definitions.volumeType.properties.ldapEnabled.type | Should -Be 'bool'
            $template.definitions.volumeType.properties.ldapEnabled.nullable | Should -BeTrue
        }
    }

    It 'Keeps the standalone LDAP parameter nullable without a default that disables LDAP' {
        $volume.parameters.ldapEnabled.type | Should -Be 'bool'
        $volume.parameters.ldapEnabled.nullable | Should -BeTrue
        $volume.parameters.ldapEnabled.ContainsKey('defaultValue') | Should -BeFalse
    }

    It 'Forwards the LDAP value from the capacity pool without replacing explicit false values' {
        $deployment = $capacityPool.resources.capacityPool_volumes
        $deployment.properties.parameters.ldapEnabled.value | Should -Be "[tryGet(coalesce(parameters('volumes'), createArray())[copyIndex()], 'ldapEnabled')]"
    }

    It 'Passes the LDAP parameter directly to the Azure volume resource' {
        $resource = $volume.resources.volume
        $resource.properties | Should -Match "'ldapEnabled', parameters\('ldapEnabled'\)"
    }
}
