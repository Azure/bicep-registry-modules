Describe 'NetApp volume security style configuration' {
    BeforeAll {
        $moduleRoot = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.FullName
        $account = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $capacityPool = Get-Content -LiteralPath (Join-Path $moduleRoot 'capacity-pool' 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $volume = Get-Content -LiteralPath (Join-Path $moduleRoot 'capacity-pool' 'volume' 'main.json') -Raw | ConvertFrom-Json -AsHashtable

        $fixture = bicep build (Join-Path $PSScriptRoot 'fixtures' 'security-style.bicep') --stdout | ConvertFrom-Json -AsHashtable
        if ($LASTEXITCODE -ne 0) {
            throw 'Failed to compile the volume security style regression fixture.'
        }
    }

    It 'Accepts ntfs and unix through the capacity pool volume input type' {
        $fixture.outputs.volumes.value | Should -Be "[variables('testVolumes')]"
        $fixture.variables.testVolumes[0].securityStyle | Should -Be 'ntfs'
        $fixture.variables.testVolumes[1].securityStyle | Should -Be 'unix'
    }

    It 'Accepts ntfs and unix through the account capacity pool input type' {
        $fixture.outputs.capacityPools.value[0].volumes | Should -Be "[variables('testVolumes')]"
    }

    It 'Allows callers to omit the security style through both input types' {
        $fixture.variables.testVolumes[2].ContainsKey('securityStyle') | Should -BeFalse
    }

    It 'Exposes the optional supported security styles in both generated schemas' {
        foreach ($template in @($account, $capacityPool)) {
            $property = $template.definitions.volumeType.properties.securityStyle
            $property.type | Should -Be 'string'
            $property.nullable | Should -BeTrue
            $property.allowedValues | Should -Be @('ntfs', 'unix')
        }
    }

    It 'Forwards the selected security style from the capacity pool to the volume' {
        $deployment = $capacityPool.resources.capacityPool_volumes
        $deployment.properties.parameters.securityStyle.value | Should -Be "[tryGet(coalesce(parameters('volumes'), createArray())[copyIndex()], 'securityStyle')]"
    }

    It 'Preserves the nullable standalone parameter without introducing a default' {
        $volume.parameters.securityStyle.nullable | Should -BeTrue
        $volume.parameters.securityStyle.allowedValues | Should -Be @('ntfs', 'unix')
        $volume.parameters.securityStyle.ContainsKey('defaultValue') | Should -BeFalse
    }

    It 'Passes the selected security style to the Azure volume resource' {
        $volume.resources.volume.properties | Should -Match "'securityStyle', parameters\('securityStyle'\)"
    }
}
