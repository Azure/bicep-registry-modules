param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Registry replication region selection in <scenario>' -ForEach @(
    @{ scenario = 'max' }
    @{ scenario = 'waf-aligned' }
) {
    BeforeAll {
        $fixturePath = Join-Path $repoRootPath 'avm' 'res' 'container-registry' 'registry' 'tests' 'e2e' $scenario 'main.test.bicep'
        $compiledPath = Join-Path $TestDrive "$scenario.json"
        $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        $dependencies = ($template.resources | Where-Object { $_.name -match '-nestedDependencies' }).properties.template
        $deploymentScript = $dependencies.resources | Where-Object { $_.type -eq 'Microsoft.Resources/deploymentScripts' }
        $scriptVariable = [regex]::Match($deploymentScript.properties.scriptContent, "^\[variables\('([^']+)'\)\]$")
        if (-not $scriptVariable.Success) { throw 'Expected an embedded region-selection script.' }
        $scriptPath = Join-Path $TestDrive "$scenario.ps1"
        $dependencies.variables[$scriptVariable.Groups[1].Value] | Set-Content -LiteralPath $scriptPath
        $scriptParameters = @{ Location = 'swedencentral' }
        $resourceType = [regex]::Match($deploymentScript.properties.arguments, '-ResourceType\s+([A-Za-z./]+)')
        if ($resourceType.Success) {
            $scriptParameters.ResourceType = $resourceType.Groups[1].Value
        }

        function Get-AzLocation {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure location query.'
        }
        function Get-AzResourceProvider {
            [CmdletBinding()]
            param([string[]] $ProviderNamespace)
            throw 'Unexpected Azure provider query.'
        }
    }

    BeforeEach {
        $DeploymentScriptOutputs = $null
        $script:locations = @(
            @{ Location = 'swedencentral'; DisplayName = 'Sweden Central'; RegionCategory = 'Recommended'; GeographyGroup = 'Europe'; PairedRegion = @(@{ Name = 'swedensouth' }) }
            @{ Location = 'swedensouth'; DisplayName = 'Sweden South'; RegionCategory = 'Other'; GeographyGroup = 'Europe' }
            @{ Location = 'northeurope'; DisplayName = 'North Europe'; RegionCategory = 'Recommended'; GeographyGroup = 'Europe' }
            @{ Location = 'eastus'; DisplayName = 'East US'; RegionCategory = 'Recommended'; GeographyGroup = 'US' }
        )
        Mock Start-Sleep {}
        Mock Get-AzLocation { $script:locations }
        Mock Get-AzResourceProvider {
            @{
                ResourceTypes = @(
                    @{ ResourceTypeName = 'registries'; Locations = @('Sweden Central', 'Sweden South') }
                    @{ ResourceTypeName = 'registries/replications'; Locations = @('Sweden Central', 'North Europe', 'East US') }
                )
            }
        }
    }

    It 'Selects a supported secondary region when the Azure pair is unsupported' {
        . $scriptPath @scriptParameters

        @($DeploymentScriptOutputs.Values) | Should -Be @('northeurope')
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly -ParameterFilter {
            $ProviderNamespace -eq 'Microsoft.ContainerRegistry'
        }
    }

    It 'Prefers a supported paired region' {
        $script:locations[0].PairedRegion = @(@{ Name = 'eastus' })

        . $scriptPath @scriptParameters

        @($DeploymentScriptOutputs.Values) | Should -Be @('eastus')
    }

    It 'Keeps selection stable across repeated reads with reordered metadata' {
        . $scriptPath @scriptParameters
        $firstSelection = @($DeploymentScriptOutputs.Values)
        [array]::Reverse($script:locations)

        . $scriptPath @scriptParameters

        @($DeploymentScriptOutputs.Values) | Should -Be $firstSelection
        $firstSelection | Should -Be @('northeurope')
    }

    It 'Fails rather than skipping replication when <problem>' -ForEach @(
        @{ problem = 'replica metadata is missing'; replicaLocations = @(); expectedError = '*No location metadata*' }
        @{ problem = 'only the primary region is supported'; replicaLocations = @('Sweden Central'); expectedError = '*No supported secondary region*' }
    ) {
        Mock Get-AzResourceProvider {
            @{ ResourceTypes = @(@{ ResourceTypeName = 'registries/replications'; Locations = $replicaLocations }) }
        }

        { . $scriptPath @scriptParameters } | Should -Throw $expectedError
    }

    It 'Uses one selected region for replication name and location in both init and idem' {
        $testDeployment = $template.resources | Where-Object { $_.copy.name -eq 'testDeployment' }
        $replications = $testDeployment.properties.parameters.replications.value
        $replications.Count | Should -Be 1
        $replications[0].location | Should -Be $replications[0].name
        $replications[0].location | Should -Match '\.outputs\.replicationRegionName\.value\]$'
        $dependencies.outputs.replicationRegionName.value | Should -Match '\.outputs\.replicationRegionName\]$'
        $testDeployment.copy.count | Should -Be "[length(createArray('init', 'idem'))]"
        $testDeployment.properties.parameters.acrSku.value | Should -Be 'Premium'
        $deploymentScript.properties.ContainsKey('forceUpdateTag') | Should -BeFalse
    }
}
