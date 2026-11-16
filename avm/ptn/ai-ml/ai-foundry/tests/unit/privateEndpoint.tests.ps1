param(
    [Parameter()]
    [array] $moduleFolderPaths,

    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName
)

Describe 'Foundry private endpoint configuration' {
    BeforeDiscovery {
        $wrappers = @('account', 'keyVault', 'aiSearch', 'storageAccount', 'cosmosDb')
    }

    BeforeAll {
        $modulePath = Join-Path $repoRootPath 'avm/ptn/ai-ml/ai-foundry/modules'

        function Invoke-EndpointScenario {
            param(
                [string] $Wrapper,
                [bool] $HasSubnet,
                [bool] $HasDns,
                [bool] $HasName
            )

            $source = Get-Content -LiteralPath (Join-Path $modulePath "$Wrapper.bicep") -Raw
            $networking = [regex]::Match($source, '(?m)^var privateNetworkingEnabled = (?<expression>[^\r\n]+)')
            $endpoints = [regex]::Match($source, '(?s)privateEndpoints: (?<expression>.*?\r?\n\s*: \[\])')
            if (-not $networking.Success -or -not $endpoints.Success) {
                throw "Could not find endpoint expressions in $Wrapper."
            }

            $subnet = if ($HasSubnet) { "'subnet-id'" } else { 'null' }
            $dns = if ($HasDns) { "'zone-id'" } else { 'null' }
            $name = if ($HasName) { "'custom-endpoint'" } else { 'null' }
            $dnsIds = if ($HasDns -and $Wrapper -eq 'account') {
                "['zone-id', 'zone-id-2', 'zone-id-3']"
            } elseif ($HasDns) {
                "['zone-id']"
            } else {
                '[]'
            }
            $lines = @(
                'using none'
                "var privateEndpointSubnetResourceId = $subnet"
                "var privateEndpointName = $name"
                "var privateDnsZoneResourceId = $dns"
                "var blobPrivateDnsZoneResourceId = $dns"
                "var privateDnsZoneResourceIds = $dnsIds"
                'var privateDnsZoneResourceIdValues = [for id in privateDnsZoneResourceIds: { privateDnsZoneResourceId: id }]'
                "var privateNetworkingEnabled = $($networking.Groups['expression'].Value)"
                "param endpoint = $($endpoints.Groups['expression'].Value)"
            )
            $inputPath = Join-Path $TestDrive "$Wrapper-$HasSubnet-$HasDns-$HasName.bicepparam"
            $outputPath = Join-Path $TestDrive "$Wrapper-$HasSubnet-$HasDns-$HasName.json"
            $lines -join "`n" | Set-Content -LiteralPath $inputPath
            $diagnostics = bicep build-params $inputPath --no-restore --outfile $outputPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            return (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters.endpoint.value
        }
    }

    It 'Creates the <_> endpoint without a DNS zone group when DNS is externally managed' -ForEach $wrappers {
        $endpoint = @(Invoke-EndpointScenario -Wrapper $_ -HasSubnet $true -HasDns $false -HasName $true)
        $endpoint.Count | Should -Be 1
        $endpoint[0].subnetResourceId | Should -Be 'subnet-id'
        $endpoint[0].name | Should -Be 'custom-endpoint'
        $endpoint[0].privateDnsZoneGroup | Should -BeNullOrEmpty
    }

    It 'Keeps the <_> DNS zone group when a zone ID is supplied' -ForEach $wrappers {
        $endpoint = @(Invoke-EndpointScenario -Wrapper $_ -HasSubnet $true -HasDns $true -HasName $false)
        $endpoint.Count | Should -Be 1
        $endpoint[0].name | Should -BeNullOrEmpty
        $endpoint[0].privateDnsZoneGroup.privateDnsZoneGroupConfigs[0].privateDnsZoneResourceId | Should -Be 'zone-id'
        if ($_ -eq 'account') {
            $endpoint[0].privateDnsZoneGroup.privateDnsZoneGroupConfigs.Count | Should -Be 3
        }
    }

    It 'Does not create the <_> endpoint without a subnet' -ForEach $wrappers {
        $endpoint = @(Invoke-EndpointScenario -Wrapper $_ -HasSubnet $false -HasDns $true -HasName $true)
        $endpoint.Count | Should -Be 0
    }

    It 'Uses public access <expected> and agent injection <injected> with subnet <hasSubnet> and override <override>' -ForEach @(
        @{ hasSubnet = $true; override = 'null'; expected = 'Disabled'; injected = $true }
        @{ hasSubnet = $true; override = 'true'; expected = 'Enabled'; injected = $true }
        @{ hasSubnet = $false; override = 'null'; expected = 'Enabled'; injected = $false }
        @{ hasSubnet = $false; override = 'false'; expected = 'Disabled'; injected = $false }
    ) {
        $source = Get-Content -LiteralPath (Join-Path $modulePath 'account.bicep') -Raw
        $networking = [regex]::Match($source, '(?m)^var privateNetworkingEnabled = (?<expression>[^\r\n]+)')
        $publicAccess = [regex]::Match($source, '(?m)^\s+publicNetworkAccess: (?<expression>[^\r\n]+)')
        $injection = [regex]::Match($source, '(?s)networkInjections: (?<expression>.*?\r?\n\s*: null)')
        if (-not $networking.Success -or -not $publicAccess.Success -or -not $injection.Success) {
            throw 'Could not find account networking expressions.'
        }

        $subnet = if ($hasSubnet) { "'subnet-id'" } else { 'null' }
        $lines = @(
            'using none'
            "var privateEndpointSubnetResourceId = $subnet"
            "var enablePublicNetworkAccess = $override"
            "var agentSubnetResourceId = 'agent-subnet-id'"
            "var privateNetworkingEnabled = $($networking.Groups['expression'].Value)"
            "param publicAccess = $($publicAccess.Groups['expression'].Value)"
            "param injection = $($injection.Groups['expression'].Value)"
        )
        $inputPath = Join-Path $TestDrive "account-$hasSubnet-$override.bicepparam"
        $outputPath = Join-Path $TestDrive "account-$hasSubnet-$override.json"
        $lines -join "`n" | Set-Content -LiteralPath $inputPath
        $diagnostics = bicep build-params $inputPath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $result = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
        $result.publicAccess.value | Should -Be $expected
        if ($injected) {
            $result.injection.value.scenario | Should -Be 'agent'
            $result.injection.value.subnetResourceId | Should -Be 'agent-subnet-id'
        } else {
            $result.injection.value | Should -BeNullOrEmpty
        }
    }
}
