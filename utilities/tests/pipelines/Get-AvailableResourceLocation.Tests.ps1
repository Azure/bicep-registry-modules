param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Available resource location selection' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'regionSelector' 'Get-AvailableResourceLocation.ps1')

        function Get-AzResourceProvider {
            [CmdletBinding()]
            param([string[]] $ProviderNamespace)
            throw 'Unexpected Azure provider query.'
        }
        function Get-AzLocation {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure location query.'
        }
    }

    BeforeEach {
        $savedTemp = $env:TEMP
        $savedTmpDir = $env:TMPDIR
        $env:TEMP = $TestDrive
        $env:TMPDIR = $TestDrive
        '{"Microsoft.DevTestLab":{"labs":{},"labs/virtualMachines":{}}}' |
            Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
        $inputParameters = @{
            ModuleRoot                  = 'avm/res/dev-test-lab/lab'
            GlobalResourceGroupLocation = 'WestEurope'
            RepoRoot                    = $repoRootPath
        }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Get-Random { 0 }
        Mock Get-AzResourceProvider {
            if ($ProviderNamespace) {
                [pscustomobject]@{
                    ProviderNamespace = 'Microsoft.DevTestLab'
                    RegistrationState = 'NotRegistered'
                    ResourceTypes     = @(
                        @{ ResourceTypeName = 'labs'; Locations = @('Central US', 'East US', 'West Europe') }
                        @{ ResourceTypeName = 'labs/virtualMachines'; Locations = @('East US') }
                    )
                }
            }
        }
        Mock Get-AzLocation {
            @(
                @{ Location = 'centralus'; DisplayName = 'Central US'; RegionCategory = 'Recommended'; PairedRegion = 'eastus2' }
                @{ Location = 'eastus'; DisplayName = 'East US'; RegionCategory = 'Recommended'; PairedRegion = 'westus' }
                @{ Location = 'westeurope'; DisplayName = 'West Europe'; RegionCategory = 'Recommended'; PairedRegion = 'northeurope' }
                @{ Location = 'norwayeast'; DisplayName = 'Norway East'; RegionCategory = 'Recommended'; PairedRegion = 'norwaywest' }
            )
        }
    }

    AfterEach {
        $env:TEMP = $savedTemp
        $env:TMPDIR = $savedTmpDir
    }

    It 'Keeps API specs fixtures in the runtime temporary cache' {
        $cacheFolderPath = $IsWindows ? $env:TEMP : [System.IO.Path]::GetTempPath()
        (Join-Path $cacheFolderPath 'avm-apiSpecs.json') | Should -Be (Join-Path $TestDrive 'avm-apiSpecs.json')
    }

    It 'Recovers missing registered-only enumeration using explicit namespace metadata' {
        @(Get-AzResourceProvider).Count | Should -Be 0

        $location = Get-AvailableResourceLocation @inputParameters

        $location | Should -Be 'centralus'
        $location | Should -Not -Be 'westeurope'
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly -ParameterFilter {
            $ProviderNamespace -eq 'Microsoft.DevTestLab'
        }
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
    }

    It 'Recognizes Windows and absolute resource module paths' -ForEach @(
        @{ path = 'avm\res\dev-test-lab\lab' }
        @{ path = 'C:\repo\avm\res\dev-test-lab\lab' }
    ) {
        $inputParameters.ModuleRoot = $path
        Get-AvailableResourceLocation @inputParameters | Should -Be 'centralus'
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Uses the full child resource type instead of its parent locations' {
        $inputParameters.ModuleRoot = 'avm/res/dev-test-lab/lab/virtual-machine'
        Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
    }

    It 'Keeps the metadata location only for explicitly global resources' {
        Mock Get-AzResourceProvider {
            @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @('Global') }) }
        }

        $selection = Get-AvailableResourceLocation @inputParameters -AsObject

        $selection.Location | Should -BeExactly 'WestEurope'
        $selection.IsGlobal | Should -BeTrue
        Should -Invoke Get-AzLocation -Times 0 -Exactly
    }

    It 'Rejects missing <missing> rather than assuming global availability' -ForEach @(
        @{ missing = 'provider'; data = $null }
        @{ missing = 'resource type'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'other'; Locations = @('Central US') }) } }
        @{ missing = 'null locations'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = $null }) } }
        @{ missing = 'empty locations'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @() }) } }
        @{ missing = 'blank locations'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @(' ') }) } }
    ) {
        Mock Get-AzResourceProvider { $data }

        { Get-AvailableResourceLocation @inputParameters } | Should -Throw '*No location metadata*'
        Should -Invoke Get-AzLocation -Times 0 -Exactly
        Should -Invoke Get-Random -Times 0 -Exactly
    }

    It 'Intersects supported and allowed regions and preserves exclusions' {
        $inputParameters.AllowedRegionsList = @('westeurope', 'eastus', 'norwayeast')
        Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
    }

    It 'Does not use global as a fallback for mixed location metadata' {
        Mock Get-AzResourceProvider {
            @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @('Global', 'Central US') }) }
        }
        $selection = Get-AvailableResourceLocation @inputParameters -AsObject
        $selection.Location | Should -Be 'centralus'
        $selection.IsGlobal | Should -BeFalse
    }

    It 'Excludes previously attempted regions without replacing the normal exclusion list' {
        $inputParameters.AllowedRegionsList = @('centralus', 'eastus', 'westeurope')
        Get-AvailableResourceLocation @inputParameters -UnavailableRegions 'Central US' | Should -Be 'eastus'
    }

    It 'Fails explicitly when no eligible candidates remain' {
        { Get-AvailableResourceLocation @inputParameters -UnavailableRegions @('centralus', 'eastus') } |
            Should -Throw '*No supported, allowed regions remain*'
        Should -Invoke Get-Random -Times 0 -Exactly
    }

    It 'Honors exclusions for non-resource modules too' {
        $inputParameters.ModuleRoot = 'avm/ptn/test/example'
        $inputParameters.AllowedRegionsList = @('westeurope', 'eastus', 'centralus')
        Get-AvailableResourceLocation @inputParameters -UnavailableRegions 'centralus' | Should -Be 'eastus'
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'Fails on an empty allowed list for non-resource modules' {
        $inputParameters.ModuleRoot = 'avm/ptn/test/example'
        $inputParameters.AllowedRegionsList = @()
        { Get-AvailableResourceLocation @inputParameters } | Should -Throw '*No supported, allowed regions remain*'
    }

    It 'Propagates provider permission errors without location fallback' {
        Mock Get-AzResourceProvider { throw '403 Forbidden' }
        { Get-AvailableResourceLocation @inputParameters } | Should -Throw '*403 Forbidden*'
        Should -Invoke Get-AzLocation -Times 0 -Exactly
        Should -Invoke Get-Random -Times 0 -Exactly
    }
}
