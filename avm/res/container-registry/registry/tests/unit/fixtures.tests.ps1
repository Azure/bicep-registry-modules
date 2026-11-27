param(
    [string] $repoRootPath = (Get-Item -LiteralPath "$PSScriptRoot\..\..\..\..\..\..").FullName
)

Describe 'Registry replication region selection' {
    BeforeAll {
        $selectionScript = Join-Path $repoRootPath 'utilities\e2e-template-assets\scripts\Get-ReplicationRegion.ps1'

        function Get-AzLocation {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure location query.'
        }

        function Get-AzResourceProvider {
            [CmdletBinding()]
            param([string] $ProviderNamespace)
            throw 'Unexpected Azure provider query.'
        }
    }

    BeforeEach {
        $script:locationMetadata = @(
            [pscustomobject]@{
                Location = 'swedencentral'
                DisplayName = 'Sweden Central'
                PairedRegion = @([pscustomobject]@{ Name = 'swedensouth' })
                RegionCategory = 'Recommended'
                GeographyGroup = 'Europe'
            }
            [pscustomobject]@{
                Location = 'swedensouth'
                DisplayName = 'Sweden South'
                PairedRegion = @([pscustomobject]@{ Name = 'swedencentral' })
                RegionCategory = 'Other'
                GeographyGroup = 'Europe'
            }
            [pscustomobject]@{
                Location = 'austriaeast'
                DisplayName = 'Austria East'
                PairedRegion = @()
                RegionCategory = 'Recommended'
                GeographyGroup = 'Europe'
            }
            [pscustomobject]@{
                Location = 'eastus'
                DisplayName = 'East US'
                PairedRegion = @()
                RegionCategory = 'Recommended'
                GeographyGroup = 'US'
            }
            [pscustomobject]@{
                Location = 'francecentral'
                DisplayName = 'France Central'
                PairedRegion = @()
                RegionCategory = 'Recommended'
                GeographyGroup = 'Europe'
            }
        )
        $script:supportedLocations = @('Sweden Central', 'Sweden South', 'Austria East', 'East US', 'France Central')
        $DeploymentScriptOutputs = $null
        Mock Start-Sleep {}
        Mock Get-AzLocation { $script:locationMetadata }
        Mock Get-AzResourceProvider {
            [pscustomobject]@{
                ResourceTypes = @(
                    [pscustomobject]@{
                        ResourceTypeName = 'registries/replications'
                        Locations = $script:supportedLocations
                    }
                )
            }
        }
    }

    It 'prefers a supported pair for <Location>' -ForEach @(
        @{ Location = 'swedencentral' }
        @{ Location = 'SwEdEnCeNtRaL' }
        @{ Location = 'Sweden Central' }
        @{ Location = 'SWEDEN CENTRAL' }
    ) {
        . $selectionScript -Location $Location -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'swedensouth'
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly -ParameterFilter {
            $ProviderNamespace -eq 'Microsoft.ContainerRegistry' -and $ErrorAction -eq 'Stop'
        }
    }

    It 'does not select an unsupported paired region' {
        $script:supportedLocations = @('Sweden Central', 'Austria East', 'East US', 'France Central')

        . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'austriaeast'
    }

    It 'accepts canonical provider region names' {
        $script:supportedLocations = @('SWEDENCENTRAL', 'SWEDENSOUTH')

        . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'swedensouth'
    }

    It 'selects a supported secondary region when no pair exists' {
        $script:locationMetadata[0].PairedRegion = @()
        $script:supportedLocations = @('Sweden Central', 'Austria East', 'East US', 'France Central')

        . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'austriaeast'
    }

    It 'never selects the primary region even when it appears as its own pair' {
        $script:locationMetadata[0].PairedRegion = @([pscustomobject]@{ Name = 'swedencentral' })
        $script:supportedLocations = @('Sweden Central', 'France Central')

        . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'francecentral'
    }

    It 'prefers a recommended fallback over a nonrecommended region' {
        $script:locationMetadata[0].PairedRegion = @()
        $script:locationMetadata[2].RegionCategory = 'Other'
        $script:supportedLocations = @('Sweden Central', 'Austria East', 'France Central')

        . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'francecentral'
    }

    It 'prefers a fallback in the same geography among recommended regions' {
        $script:supportedLocations = @('Sweden Central', 'East US', 'France Central')

        . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'francecentral'
    }

    It 'selects the same region regardless of metadata ordering' {
        $script:supportedLocations = @('France Central', 'East US', 'Austria East', 'Sweden Central')
        [array]::Reverse($script:locationMetadata)

        . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications'

        $DeploymentScriptOutputs.replicationRegionName | Should -BeExactly 'austriaeast'
    }

    It 'rejects missing provider location metadata' {
        $script:supportedLocations = @()

        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*No location metadata*'
        $DeploymentScriptOutputs | Should -BeNullOrEmpty
    }

    It 'does not substitute a different resource type' {
        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries' } |
            Should -Throw '*No location metadata*'
    }

    It 'rejects a provider that only supports the primary region' {
        $script:supportedLocations = @('Sweden Central')

        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*No supported secondary region*'
        $DeploymentScriptOutputs | Should -BeNullOrEmpty
    }

    It 'does not invent a region missing from Azure location metadata' {
        $script:supportedLocations = @('Unknown Region')

        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*No supported secondary region*'
    }

    It 'does not treat global availability as a secondary region' {
        $script:supportedLocations = @('global')

        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*No supported secondary region*'
    }

    It 'rejects an unknown primary region' {
        { . $selectionScript -Location 'unknown' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*Expected one Azure region*'
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'rejects ambiguous primary region metadata' {
        $script:locationMetadata += $script:locationMetadata[0]

        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*Expected one Azure region matching*'
    }

    It 'propagates location discovery errors' {
        Mock Get-AzLocation { throw 'Location discovery failed.' }

        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*Location discovery failed*'
        $DeploymentScriptOutputs | Should -BeNullOrEmpty
    }

    It 'propagates provider discovery errors' {
        Mock Get-AzResourceProvider { throw 'Provider discovery failed.' }

        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry/registries/replications' } |
            Should -Throw '*Provider discovery failed*'
        $DeploymentScriptOutputs | Should -BeNullOrEmpty
    }

    It 'rejects an incomplete resource type' {
        { . $selectionScript -Location 'swedencentral' -ResourceType 'Microsoft.ContainerRegistry' } | Should -Throw
        Should -Invoke Get-AzLocation -Times 0 -Exactly
    }
}

Describe 'Registry replication fixture wiring' {
    BeforeAll {
        $registryRoot = Join-Path $repoRootPath 'avm\res\container-registry\registry'
        $expectedScript = Get-Content -LiteralPath (Join-Path $repoRootPath 'utilities\e2e-template-assets\scripts\Get-ReplicationRegion.ps1') -Raw
        $fixtures = @{}
        foreach ($scenario in @('max', 'waf-aligned')) {
            $outputPath = Join-Path $TestDrive "$scenario.json"
            $diagnostics = @(bicep build (Join-Path $registryRoot "tests\e2e\$scenario\main.test.bicep") --outfile $outputPath --no-restore 2>&1)
            if ($LASTEXITCODE -ne 0) {
                throw "Fixture compilation failed for [$scenario]: $($diagnostics -join [Environment]::NewLine)"
            }
            $template = Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable
            $resources = if ($template.resources -is [System.Collections.IDictionary]) { @($template.resources.Values) } else { @($template.resources) }
            $dependencies = @($resources | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -match 'nestedDependencies' })
            $testDeployment = @($resources | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -match '-test-' })
            if ($dependencies.Count -ne 1 -or $testDeployment.Count -ne 1) {
                throw "Unexpected fixture deployment structure for [$scenario]."
            }
            $nestedTemplate = $dependencies[0].properties.template
            $nestedResources = if ($nestedTemplate.resources -is [System.Collections.IDictionary]) { @($nestedTemplate.resources.Values) } else { @($nestedTemplate.resources) }
            $scripts = @($nestedResources | Where-Object type -EQ 'Microsoft.Resources/deploymentScripts')
            if ($scripts.Count -ne 1) { throw "Expected one replication-region script for [$scenario]." }
            $scriptContent = $scripts[0].properties.scriptContent
            if ($scriptContent -match "^\[variables\('([^']+)'\)\]$") {
                if (-not $nestedTemplate.variables.Contains($Matches[1])) {
                    throw "Missing compiled script content for [$scenario]."
                }
                $scriptContent = $nestedTemplate.variables[$Matches[1]]
            }
            $fixtures[$scenario] = @{
                Script = $scripts[0]
                ScriptContent = $scriptContent
                Outputs = $nestedTemplate.outputs
                Deployment = $testDeployment[0]
                Template = $template
            }
        }
    }

    It 'loads the resource-aware script in <Scenario>' -ForEach @(
        @{ Scenario = 'max' }
        @{ Scenario = 'waf-aligned' }
    ) {
        $fixtures[$Scenario].ScriptContent | Should -BeExactly $expectedScript
    }

    It 'queries the replica resource type in <Scenario>' -ForEach @(
        @{ Scenario = 'max' }
        @{ Scenario = 'waf-aligned' }
    ) {
        $fixtures[$Scenario].Script.properties.arguments | Should -Match '\-ResourceType'
        $fixtures[$Scenario].Script.properties.arguments | Should -Match 'Microsoft\.ContainerRegistry/registries/replications'
    }

    It 'exposes the selected secondary region in <Scenario>' -ForEach @(
        @{ Scenario = 'max' }
        @{ Scenario = 'waf-aligned' }
    ) {
        $fixtures[$Scenario].Outputs.Contains('replicationRegionName') | Should -BeTrue
        $fixtures[$Scenario].Outputs.replicationRegionName.value | Should -Match 'outputs\.replicationRegionName'
    }

    It 'uses the selected region for both replica name and location in <Scenario>' -ForEach @(
        @{ Scenario = 'max' }
        @{ Scenario = 'waf-aligned' }
    ) {
        $replicas = @($fixtures[$Scenario].Deployment.properties.parameters.replications.value)
        $replicas | Should -HaveCount 1
        $replicas[0].location | Should -Match 'replicationRegionName'
        $replicas[0].name | Should -BeExactly $replicas[0].location
    }

    It 'does not pin the primary region in <Scenario>' -ForEach @(
        @{ Scenario = 'max' }
        @{ Scenario = 'waf-aligned' }
    ) {
        $fixtures[$Scenario].Template.parameters.resourceLocation.defaultValue | Should -BeExactly '[deployment().location]'
        $fixtures[$Scenario].Deployment.properties.parameters.location.value | Should -BeExactly "[parameters('resourceLocation')]"
    }

    It 'retains Premium and private-endpoint coverage in <Scenario>' -ForEach @(
        @{ Scenario = 'max'; PrivateEndpointCount = 2 }
        @{ Scenario = 'waf-aligned'; PrivateEndpointCount = 1 }
    ) {
        $fixtures[$Scenario].Deployment.properties.parameters.acrSku.value | Should -BeExactly 'Premium'
        @($fixtures[$Scenario].Deployment.properties.parameters.privateEndpoints.value) | Should -HaveCount $PrivateEndpointCount
    }
}
