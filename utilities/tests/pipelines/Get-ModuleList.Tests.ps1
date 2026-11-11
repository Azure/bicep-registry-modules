param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Get-ModuleList' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleList.ps1')
        Import-Module Avm.Authoring -ErrorAction Stop

        function New-ModuleListFixture {
            param(
                [string] $ModuleName = 'avm/res/example/module',
                [AllowEmptyCollection()]
                [string[]] $Owners = @(),
                [switch] $Versioned
            )

            $modulePath = Join-Path $script:fixtureRoot $ModuleName
            $null = New-Item -Path $modulePath -ItemType Directory -Force
            Set-Content -LiteralPath (Join-Path $modulePath 'main.bicep') -Value 'This fixture must not be compiled.'
            $moduleKind = ($ModuleName -split '/')[1]
            $metadata = @{
                '$schema'         = 'https://raw.githubusercontent.com/Azure/azure-verified-modules-tools/main/src/Avm.Authoring/Resources/Schemas/v1/avm-module-metadata.schema.json'
                moduleDisplayName = 'Example Module'
                moduleDescription = 'Example module for local ownership tests.'
                canonicalType     = $moduleKind -eq 'res' ? 'Microsoft.Example/modules' : 'example/module'
                telemetryIdPrefix = "46d3xbcp.$moduleKind.example-module"
            }
            if (($ModuleName -split '/').Count -eq 4) {
                $metadata.owners = @($Owners)
            }
            $metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $modulePath 'metadata.json')
            if ($Versioned) {
                Set-Content -LiteralPath (Join-Path $modulePath 'version.json') -Value '{"version":"1.0.0"}'
            }
            return $modulePath
        }
    }

    BeforeEach {
        $script:fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString())
        $null = New-Item -Path $script:fixtureRoot -ItemType Directory
        Mock Invoke-WebRequest { throw 'Module listing must not access the network.' }
        Mock Invoke-RestMethod { throw 'Module listing must not access the network.' }
        Mock Invoke-WebRequest { throw 'Metadata validation must stay offline.' } -ModuleName Avm.Authoring
        Mock Invoke-RestMethod { throw 'Metadata validation must stay offline.' } -ModuleName Avm.Authoring
    }

    AfterEach {
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        Should -Invoke Invoke-WebRequest -ModuleName Avm.Authoring -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -ModuleName Avm.Authoring -Times 0 -Exactly
    }

    It 'finds ownerless <ModuleKind> modules without a marker or public index' -ForEach @(
        @{ ModuleKind = 'res' }
        @{ ModuleKind = 'ptn' }
        @{ ModuleKind = 'utl' }
    ) {
        $moduleName = "avm/$ModuleKind/example/module"
        $modulePath = New-ModuleListFixture -ModuleName $moduleName -Versioned

        Test-Path -LiteralPath (Join-Path $modulePath 'ORPHANED.md') | Should -BeFalse
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true) | Should -Be @($moduleName)
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $false) | Should -BeNullOrEmpty

        Set-Content -LiteralPath (Join-Path $modulePath 'ORPHANED.md') -Value 'Legacy notice'
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true) | Should -Be @($moduleName)
    }

    It 'recognizes <Ownership> ownership even with a stale marker' -ForEach @(
        @{ Ownership = 'individual'; Owners = @('owner-one') }
        @{ Ownership = 'team-only'; Owners = @('@Azure/module-owners') }
        @{ Ownership = 'mixed'; Owners = @('owner-one', '@Azure/module-owners') }
    ) {
        $modulePath = New-ModuleListFixture -Owners $Owners
        Set-Content -LiteralPath (Join-Path $modulePath 'ORPHANED.md') -Value 'Legacy notice'

        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true) | Should -BeNullOrEmpty
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $false) | Should -Be @('avm/res/example/module')
    }

    It 'reads adoption and orphaning from metadata on each invocation' {
        $modulePath = New-ModuleListFixture
        $metadataPath = Join-Path $modulePath 'metadata.json'
        $metadata = Get-Content -LiteralPath $metadataPath -Raw | ConvertFrom-Json -AsHashtable
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true).Count | Should -Be 1

        $metadata.owners = @('@Azure/module-owners')
        $metadata | ConvertTo-Json | Set-Content -LiteralPath $metadataPath
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true) | Should -BeNullOrEmpty
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $false).Count | Should -Be 1

        $metadata.owners = @()
        $metadata | ConvertTo-Json | Set-Content -LiteralPath $metadataPath
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true).Count | Should -Be 1
    }

    It 'inherits <Ownership> root ownership for children and grandchildren, including a child-only scan' -ForEach @(
        @{ Ownership = 'empty'; Owners = @(); IsOrphaned = $true }
        @{ Ownership = 'individual'; Owners = @('owner-one'); IsOrphaned = $false }
        @{ Ownership = 'team-only'; Owners = @('@Azure/module-owners'); IsOrphaned = $false }
    ) {
        $rootPath = New-ModuleListFixture -Owners $Owners -Versioned
        $childPath = New-ModuleListFixture -ModuleName 'avm/res/example/module/child'
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/module/child/grandchild'
        $expected = @('avm/res/example/module/child', 'avm/res/example/module/child/grandchild')

        @(Get-ModuleList -RepoRoot $script:fixtureRoot -Path $rootPath -Scope Child -IsOrphaned $IsOrphaned | Sort-Object) |
            Should -Be $expected
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -Path $childPath -IsOrphaned $IsOrphaned | Sort-Object) |
            Should -Be $expected
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -Path $childPath -IsOrphaned (-not $IsOrphaned)) |
            Should -BeNullOrEmpty
    }

    It 'validates each family root once, offline, without validating descendants as roots' {
        $rootPath = New-ModuleListFixture
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/module/child'
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/module/child/grandchild'
        Mock Test-AvmModuleMetadata {
            @{ Status = 'pass'; Issues = @(); Metadata = @{ owners = @() } }
        }

        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true).Count | Should -Be 3
        Should -Invoke Test-AvmModuleMetadata -Times 1 -Exactly -ParameterFilter {
            $Path -eq $rootPath -and $Ecosystem -eq 'bicep' -and $ModuleType -eq 'resource' -and $SkipModuleVersionCheck
        }
    }

    It 'rejects <MetadataState> root metadata rather than assuming no owners' -ForEach @(
        @{ MetadataState = 'missing file' }
        @{ MetadataState = 'empty file'; Json = '' }
        @{ MetadataState = 'malformed JSON'; Json = '{invalid JSON' }
        @{ MetadataState = 'null JSON'; Json = 'null' }
        @{ MetadataState = 'array JSON'; Json = '[{"owners":[]}]' }
        @{ MetadataState = 'missing required metadata'; Json = '{"owners":[]}' }
        @{ MetadataState = 'missing owners' }
        @{ MetadataState = 'null owners'; Owners = $null }
        @{ MetadataState = 'string owners'; Owners = 'owner-one' }
        @{ MetadataState = 'object owners'; Owners = @{ owner = 'owner-one' } }
        @{ MetadataState = 'numeric owners'; Owners = 42 }
        @{ MetadataState = 'null owner'; Owners = @($null) }
        @{ MetadataState = 'empty owner'; Owners = @('') }
        @{ MetadataState = 'whitespace owner'; Owners = @('owner one') }
        @{ MetadataState = 'numeric owner'; Owners = @(42) }
        @{ MetadataState = 'object owner'; Owners = @(@{ name = 'owner-one' }) }
        @{ MetadataState = 'invalid individual'; Owners = @('@owner-one') }
        @{ MetadataState = 'invalid team'; Owners = @('Azure/module-owners') }
        @{ MetadataState = 'invalid team slug'; Owners = @('@Azure/Module-Owners') }
        @{ MetadataState = 'duplicate owners'; Owners = @('owner-one', 'OWNER-ONE') }
        @{ MetadataState = 'mixed valid and invalid owners'; Owners = @('owner-one', $null) }
    ) {
        $rootPath = New-ModuleListFixture
        $childPath = New-ModuleListFixture -ModuleName 'avm/res/example/module/child/grandchild'
        $metadataPath = Join-Path $rootPath 'metadata.json'
        if ($MetadataState -eq 'missing file') {
            Remove-Item -LiteralPath $metadataPath
        } elseif ($MetadataState -match 'file|JSON|required metadata') {
            Set-Content -LiteralPath $metadataPath -Value $Json
        } else {
            $metadata = Get-Content -LiteralPath $metadataPath -Raw | ConvertFrom-Json -AsHashtable
            if ($MetadataState -eq 'missing owners') {
                $metadata.Remove('owners')
            } else {
                $metadata.owners = $Owners
            }
            $metadata | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $metadataPath
        }

        foreach ($isOrphaned in @($true, $false)) {
            { Get-ModuleList -RepoRoot $script:fixtureRoot -Path $childPath -IsOrphaned $isOrphaned } |
                Should -Throw '*metadata.json*AVM_METADATA*'
        }
    }

    It 'preserves all default and non-ownership filters without requiring metadata validation' {
        $rootPath = New-ModuleListFixture -Versioned
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/module/child'
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/module/child/grandchild' -Versioned
        Remove-Item -LiteralPath (Join-Path $rootPath 'metadata.json')
        Mock Test-AvmModuleMetadata { throw 'An ownership filter was not requested.' }

        @(Get-ModuleList -RepoRoot $script:fixtureRoot).Count | Should -Be 3
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $null).Count | Should -Be 3
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -Scope TopLevel) | Should -Be @('avm/res/example/module')
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -Scope Child).Count | Should -Be 2
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsVersioned $true).Count | Should -Be 2
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsVersioned $false) | Should -Be @('avm/res/example/module/child')
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -HasChildren $true).Count | Should -Be 2
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -HasChildren $false) | Should -Be @('avm/res/example/module/child/grandchild')
        Should -Invoke Test-AvmModuleMetadata -Times 0 -Exactly
    }

    It 'combines hierarchy, ownership, versioning and child filters' {
        $null = New-ModuleListFixture -Versioned
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/module/child'
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/module/child/grandchild' -Versioned
        $null = New-ModuleListFixture -ModuleName 'avm/res/example/owned' -Owners @('owner-one') -Versioned

        @(Get-ModuleList -RepoRoot $script:fixtureRoot -Scope Child -IsOrphaned $true -IsVersioned $false -HasChildren $true) |
            Should -Be @('avm/res/example/module/child')
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -Scope TopLevel -IsOrphaned $false -IsVersioned $true -HasChildren $false) |
            Should -Be @('avm/res/example/owned')
    }

    It 'does not infer public catalog lifecycle status from local ownership or version files' {
        $rootPath = New-ModuleListFixture
        Set-Content -LiteralPath (Join-Path $rootPath 'DEPRECATED.md') -Value 'Retained deprecation notice'

        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true -IsVersioned $false) |
            Should -Be @('avm/res/example/module')
        @(Get-ModuleList -RepoRoot $script:fixtureRoot -IsOrphaned $true -IsVersioned $true) |
            Should -BeNullOrEmpty
        Get-Content -LiteralPath (Join-Path $rootPath 'DEPRECATED.md') | Should -Be 'Retained deprecation notice'
    }
}
