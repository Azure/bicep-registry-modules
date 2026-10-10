param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-EnvironmentOnAgent.ps1')

    function Get-PSRepository {
        [CmdletBinding()]
        param()
        throw 'Unexpected repository lookup.'
    }
    function Register-PSRepository {
        [CmdletBinding()]
        param([switch] $Default)
        throw 'Unexpected repository registration.'
    }
    function Find-Module {
        [CmdletBinding()]
        param([string] $Name, [string] $Repository, [string] $RequiredVersion)
        throw 'Unexpected module lookup.'
    }
    function Install-Module {
        [CmdletBinding()]
        param([Parameter(ValueFromPipeline)] [object] $InputObject, [switch] $Force, [switch] $SkipPublisherCheck, [switch] $AllowClobber)
        process { throw 'Unexpected module installation.' }
    }
    function Get-PackageProvider {
        [CmdletBinding()]
        param()
        throw 'Unexpected package provider lookup.'
    }
    function Get-ArchiveFailure {
        param(
            [string] $Name = 'Fixture.Module',
            [string] $Detail = 'End of Central Directory record could not be found.',
            [string] $ErrorId = "Package '{0}' failed to be installed because: {1},Microsoft.PowerShell.PackageManagement.Cmdlets.InstallPackage",
            [System.Management.Automation.ErrorCategory] $Category = 'InvalidResult'
        )
        [System.Management.Automation.ErrorRecord]::new(
            [Exception]::new("Package '$Name' failed to be installed because: $Detail"),
            $ErrorId, $Category, $Name
        )
    }
}

Describe 'PowerShell Gallery initialization' {
    BeforeEach {
        $script:moduleBase = Join-Path $TestDrive 'Fixture.Module\1.2.3'
        $script:installedFixture = [pscustomobject] @{
            Name       = 'Fixture.Module'
            Version    = [version] '1.2.3'
            ModuleBase = $script:moduleBase
        }
        Mock Get-Module {
            if ($ListAvailable) { $script:installedFixture }
        }
        Mock Get-Module { @{ Version = [version] '2.2.5' } } -ParameterFilter { $Name -eq 'PowerShellGet' }
        Mock Get-Module { @{ Version = [version] '1.4.8.1' } } -ParameterFilter { $Name -eq 'PackageManagement' }
        Mock Get-PackageProvider { @{ Name = 'NuGet'; Version = [version] '3.0.0.1' } }
        Mock Test-Path { $true } -ParameterFilter { $LiteralPath -eq (Join-Path $script:moduleBase 'Fixture.Module.psd1') }
        Mock Import-Module { $script:installedFixture }
        Mock Start-Sleep {}
        Mock Write-Warning {}
        Mock Remove-Module { throw 'A loaded module must not be removed.' }
        Mock Get-PSRepository { @{ Name = 'PSGallery' } }
        Mock Register-PSRepository {}
        Mock Find-Module {
            [pscustomobject] @{ Name = 'Fixture.Module'; Version = [version] '1.2.3'; Dependencies = @() }
        }
        Mock Install-Module {}
    }

    It 'Keeps an existing PowerShell Gallery registration' {
        Install-CustomModule -Module @{ Name = 'Fixture.Module' }

        Should -Invoke Register-PSRepository -Times 0 -Exactly
        Should -Invoke Find-Module -Times 1 -Exactly -ParameterFilter { $Repository -eq 'PSGallery' }
    }

    It 'Registers PowerShell Gallery before resolving a module when it is missing' {
        $script:galleryRegistered = $false
        Mock Get-PSRepository {
            @{ Name = 'ExistingPrivateRepository' }
            if ($script:galleryRegistered) { @{ Name = 'PSGallery' } }
        }
        Mock Register-PSRepository { $script:galleryRegistered = $true } -ParameterFilter { $Default }
        Mock Find-Module {
            if (-not $script:galleryRegistered) { throw 'PowerShell Gallery was not registered before module resolution.' }
            @{ Name = 'Fixture.Module'; Version = [version] '1.2.3' }
        }

        Install-CustomModule -Module @{ Name = 'Fixture.Module'; Version = '1.2.3' }

        Should -Invoke Register-PSRepository -Times 1 -Exactly -ParameterFilter { $Default }
        Should -Invoke Find-Module -Times 1 -Exactly -ParameterFilter {
            $Repository -eq 'PSGallery' -and $RequiredVersion -eq '1.2.3'
        }
    }

    It 'Registers PowerShell Gallery when no repositories are configured' {
        $script:galleryRegistered = $false
        Mock Get-PSRepository { if ($script:galleryRegistered) { @{ Name = 'PSGallery' } } }
        Mock Register-PSRepository { $script:galleryRegistered = $true }

        Install-CustomModule -Module @{ Name = 'Fixture.Module' }

        Should -Invoke Register-PSRepository -Times 1 -Exactly -ParameterFilter { $Default }
    }

    It 'Stops when repository discovery fails' {
        Mock Get-PSRepository { throw 'Repository discovery failed.' }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*Repository discovery failed.*'

        Should -Invoke Register-PSRepository -Times 0 -Exactly
        Should -Invoke Find-Module -Times 0 -Exactly
    }

    It 'Does not register or query a missing repository when WhatIf is specified' {
        Mock Get-PSRepository {}

        Install-CustomModule -Module @{ Name = 'Fixture.Module' } -WhatIf

        Should -Invoke Register-PSRepository -Times 0 -Exactly
        Should -Invoke Find-Module -Times 0 -Exactly
    }

    It 'Stops when PowerShell Gallery registration fails' {
        Mock Get-PSRepository {}
        Mock Register-PSRepository { throw 'Repository registration failed.' }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*Repository registration failed.*'

        Should -Invoke Find-Module -Times 0 -Exactly
    }

    It 'Does not report success when default registration returns but a required dependency remains unavailable' {
        Mock Get-PSRepository {}
        Mock Register-PSRepository {}
        Mock Find-Module { Write-Error "Unable to find repository 'PSGallery'." }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } -ErrorAction Continue } |
            Should -Throw '*PSGallery*not available*2*registration attempts*'

        Should -Invoke Register-PSRepository -Times 2 -Exactly -ParameterFilter { $Default }
        Should -Invoke Find-Module -Times 0 -Exactly
        Should -Invoke Install-Module -Times 0 -Exactly
    }

    It 'Retries a no-op default registration only after confirming PSGallery is still absent' {
        $script:registrationAttempts = 0
        $script:repositoryChecks = 0
        Mock Get-PSRepository {
            $script:repositoryChecks++
            if ($script:registrationAttempts -eq 2) { @{ Name = 'PSGallery' } }
        }
        Mock Register-PSRepository {
            $script:repositoryChecks | Should -Be ($script:registrationAttempts + 1)
            $script:registrationAttempts++
        }
        Mock Find-Module {
            if ($script:registrationAttempts -ne 2) { throw "Unable to find repository 'PSGallery'." }
            [pscustomobject] @{ Name = 'Fixture.Module'; Version = [version] '1.2.3'; Dependencies = @() }
        }

        Install-CustomModule -Module @{ Name = 'Fixture.Module'; Version = '1.2.3' }

        Should -Invoke Register-PSRepository -Times 2 -Exactly -ParameterFilter { $Default }
        Should -Invoke Get-PSRepository -Times 3 -Exactly
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 2 }
        Should -Invoke Find-Module -Times 1 -Exactly -ParameterFilter { $RequiredVersion -eq '1.2.3' }
    }

    It 'Does not require repository access for an already installed <requirement> module' -ForEach @(
        @{ requirement = 'unversioned'; requested = @{} }
        @{ requirement = 'exact-version'; requested = @{ Version = '1.2.3' } }
    ) {
        Mock Get-PSRepository { throw 'Repository is unavailable.' }
        $module = @{ Name = 'Fixture.Module' } + $requested
        $installed = @(
            @{ Name = 'Fixture.Module'; Version = [version] '1.1.0' }
            @{ Name = 'Fixture.Module'; Version = [version] '1.2.3' }
        )

        Install-CustomModule -Module $module -InstalledModule $installed

        Should -Invoke Get-PSRepository -Times 0 -Exactly
        Should -Invoke Register-PSRepository -Times 0 -Exactly
        Should -Invoke Find-Module -Times 0 -Exactly
        Should -Invoke Install-Module -Times 0 -Exactly
        Should -Invoke Get-PackageProvider -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
    }

    It 'Does not mistake an installed wrong version or another module for the required dependency: <kind>' -ForEach @(
        @{ kind = 'wrong version'; installedName = 'Fixture.Module'; version = '1.1.0' }
        @{ kind = 'another module'; installedName = 'Another.Module'; version = '1.2.3' }
    ) {
        Mock Find-Module { throw 'Required dependency is unavailable.' }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module'; Version = '1.2.3' } `
                -InstalledModule @(@{ Name = $installedName; Version = [version] $version }) } |
            Should -Throw '*Required dependency is unavailable.*'

        Should -Invoke Find-Module -Times 1 -Exactly -ParameterFilter { $RequiredVersion -eq '1.2.3' }
        Should -Invoke Install-Module -Times 0 -Exactly
    }

    It 'Fails when repository resolution returns no required module' {
        Mock Find-Module {}

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*Fixture.Module*'

        Should -Invoke Install-Module -Times 0 -Exactly
    }

    It 'Does not continue after a nonterminating module lookup error' {
        Mock Find-Module { Write-Error 'Repository lookup failed.' }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } -ErrorAction Continue } |
            Should -Throw '*Repository lookup failed.*'

        Should -Invoke Install-Module -Times 0 -Exactly
    }

    It 'Rejects unsuccessful installation without accepting another installed version' {
        Mock Get-Module {
            if ($ListAvailable) { @{ Name = 'Fixture.Module'; Version = [version] '1.1.0' } }
        }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module'; Version = '1.2.3' } } |
            Should -Throw '*Installation of module*failed*'

        Should -Invoke Install-Module -Times 1 -Exactly
    }

    It 'Propagates installation errors rather than accepting stale installed modules' {
        Mock Install-Module { Write-Error 'Installation failed.' }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } -ErrorAction Continue } |
            Should -Throw '*Installation failed.*'

        Should -Invoke Install-Module -Times 1 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
    }

    It 'Retries the exact resolved dependency once after the known NuGet archive failure' {
        $script:installAttempts = 0
        Mock Install-Module {
            $script:installAttempts++
            if ($script:installAttempts -eq 1) { throw (Get-ArchiveFailure) }
        }

        Install-CustomModule -Module @{ Name = 'Fixture.Module'; Version = '1.2.3' }

        Should -Invoke Find-Module -Times 1 -Exactly -ParameterFilter { $RequiredVersion -eq '1.2.3' }
        Should -Invoke Install-Module -Times 2 -Exactly -ParameterFilter {
            $InputObject.Name -eq 'Fixture.Module' -and $InputObject.Version -eq [version] '1.2.3' -and
            $Force -and $AllowClobber -and $SkipPublisherCheck -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 2 }
        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter {
            $FullyQualifiedName.Name -eq (Join-Path $script:moduleBase 'Fixture.Module.psd1') -and
            $FullyQualifiedName.RequiredVersion -eq [version] '1.2.3' -and $PassThru -and -not $Force
        }
    }

    It 'Stops after two corrupt archives without accepting a stale module' {
        Mock Install-Module { throw (Get-ArchiveFailure) }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } -ErrorAction Continue } |
            Should -Throw '*End of Central Directory record could not be found.*'

        Should -Invoke Install-Module -Times 2 -Exactly
        Should -Invoke Start-Sleep -Times 1 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
    }

    It 'Preserves a different failure from the second installation attempt' {
        $script:installAttempts = 0
        Mock Install-Module {
            $script:installAttempts++
            if ($script:installAttempts -eq 1) { throw (Get-ArchiveFailure) }
            throw 'Publisher validation failed.'
        }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*Publisher validation failed.*'

        Should -Invoke Install-Module -Times 2 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
    }

    It 'Does not accept a stale version after a retry returns without installing the resolved module' {
        $script:installAttempts = 0
        Mock Install-Module {
            $script:installAttempts++
            if ($script:installAttempts -eq 1) { throw (Get-ArchiveFailure) }
        }
        Mock Get-Module {
            if ($ListAvailable) { @{ Name = 'Fixture.Module'; Version = [version] '1.1.0' } }
        } -ParameterFilter { $Name -eq 'Fixture.Module' }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*Installation of module*failed*'

        Should -Invoke Install-Module -Times 2 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
    }

    It 'Does not retry an archive-like error outside the proved contract: <kind>' -ForEach @(
        @{ kind = 'different error identifier'; errorInput = @{ ErrorId = 'UnrelatedError' } }
        @{ kind = 'different category'; errorInput = @{ Category = 'InvalidOperation' } }
        @{ kind = 'different package'; errorInput = @{ Name = 'Another.Module' } }
        @{ kind = 'other installation failure'; errorInput = @{ Detail = 'Access to the path is denied.' } }
    ) {
        Mock Install-Module { throw (Get-ArchiveFailure @errorInput) }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } | Should -Throw

        Should -Invoke Install-Module -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Does not replay an installation with <kind> dependency metadata' -ForEach @(
        @{ kind = 'declared'; dependency = @(@{ Name = 'Another.Module'; RequiredVersion = '1.0.0' }); hasProperty = $true }
        @{ kind = 'missing'; dependency = $null; hasProperty = $false }
        @{ kind = 'null'; dependency = $null; hasProperty = $true }
    ) {
        Mock Find-Module {
            $result = [pscustomobject] @{ Name = 'Fixture.Module'; Version = [version] '1.2.3' }
            if ($hasProperty) { $result | Add-Member Dependencies $dependency }
            $result
        }
        Mock Install-Module { throw (Get-ArchiveFailure) }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } | Should -Throw

        Should -Invoke Install-Module -Times 1 -Exactly
    }

    It 'Does not retry an unverified <component> runtime' -ForEach @(
        @{ component = 'PowerShellGet' }
        @{ component = 'PackageManagement' }
        @{ component = 'NuGet' }
    ) {
        if ($component -eq 'NuGet') {
            Mock Get-PackageProvider { @{ Name = 'NuGet'; Version = [version] '9.9.9' } }
        } else {
            Mock Get-Module { @{ Version = [version] '9.9.9' } } -ParameterFilter { $Name -eq $component }
        }
        Mock Install-Module { throw (Get-ArchiveFailure) }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } | Should -Throw

        Should -Invoke Install-Module -Times 1 -Exactly
    }

    It 'Does not install, retry, import, or unload with an existing repository under WhatIf' {
        Install-CustomModule -Module @{ Name = 'Fixture.Module' } -WhatIf

        Should -Invoke Install-Module -Times 0 -Exactly
        Should -Invoke Get-PackageProvider -Times 0 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
        Should -Invoke Remove-Module -Times 0 -Exactly
    }

    It 'Checks the resolved version even when the request did not specify a version' {
        Mock Get-Module {
            if ($ListAvailable) { @{ Name = 'Fixture.Module'; Version = [version] '1.1.0' } }
        }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*Installation of module*failed*'
    }

    It 'Does not accept a matching module directory without its manifest' {
        Mock Test-Path { $false } -ParameterFilter { $LiteralPath -eq (Join-Path $script:moduleBase 'Fixture.Module.psd1') }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*manifest*'

        Should -Invoke Import-Module -Times 0 -Exactly
    }

    It 'Rejects a module that cannot be imported' {
        Mock Import-Module { throw 'Module initialization failed.' }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*Module initialization failed.*'

        Should -Invoke Install-Module -Times 1 -Exactly
    }

    It 'Rejects an imported module with the wrong <mismatch>' -ForEach @(
        @{ mismatch = 'name'; name = 'Another.Module'; version = '1.2.3'; useOtherPath = $false }
        @{ mismatch = 'version'; name = 'Fixture.Module'; version = '1.1.0'; useOtherPath = $false }
        @{ mismatch = 'path'; name = 'Fixture.Module'; version = '1.2.3'; useOtherPath = $true }
    ) {
        Mock Import-Module {
            [pscustomobject] @{
                Name       = $name
                Version    = [version] $version
                ModuleBase = $useOtherPath ? (Join-Path $TestDrive 'other') : $script:moduleBase
            }
        }

        { Install-CustomModule -Module @{ Name = 'Fixture.Module' } } |
            Should -Throw '*imported module*does not match*'
    }

    Context 'Manifest initializer module metadata' -Tag 'YamlImportIdentity' {
        It 'Accepts initializer metadata <position> the requested module with caller preference <preference>' -ForEach @(
            @{ position = 'before'; initializerFirst = $true; preference = 'Continue' }
            @{ position = 'after'; initializerFirst = $false; preference = 'Continue' }
            @{ position = 'before'; initializerFirst = $true; preference = 'Stop' }
            @{ position = 'after'; initializerFirst = $false; preference = 'Stop' }
        ) {
            $ErrorActionPreference = $preference
            Mock Import-Module {
                $initializer = [pscustomobject] @{
                    Name       = 'Load-Assemblies'
                    Version    = [version] '0.0'
                    ModuleBase = $script:moduleBase
                }
                if ($initializerFirst) { $initializer }
                $script:installedFixture
                if (-not $initializerFirst) { $initializer }
            }

            Install-CustomModule -Module @{ Name = 'Fixture.Module'; Version = '1.2.3' } -ErrorAction $preference

            Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter {
                $FullyQualifiedName.Name -ceq (Join-Path $script:moduleBase 'Fixture.Module.psd1') -and
                $FullyQualifiedName.RequiredVersion -eq [version] '1.2.3' -and $Global -and $PassThru -and
                $ErrorAction -eq 'Stop' -and -not $Force
            }
            Should -Invoke Install-Module -Times 1 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
            Should -Invoke Remove-Module -Times 0 -Exactly
            $ErrorActionPreference | Should -Be $preference
        }

        It 'Rejects <shape> alongside initializer metadata' -ForEach @(
            @{ shape = 'no requested module'; moduleCount = 0; candidateName = 'Fixture.Module'; candidateVersion = '1.2.3'; useOtherPath = $false }
            @{ shape = 'different name casing'; moduleCount = 1; candidateName = 'fixture.module'; candidateVersion = '1.2.3'; useOtherPath = $false }
            @{ shape = 'the wrong requested version'; moduleCount = 1; candidateName = 'Fixture.Module'; candidateVersion = '1.1.0'; useOtherPath = $false }
            @{ shape = 'the wrong requested origin'; moduleCount = 1; candidateName = 'Fixture.Module'; candidateVersion = '1.2.3'; useOtherPath = $true }
            @{ shape = 'duplicate requested modules'; moduleCount = 2; candidateName = 'Fixture.Module'; candidateVersion = '1.2.3'; useOtherPath = $false }
            @{ shape = 'conflicting requested versions'; moduleCount = 2; candidateName = 'Fixture.Module'; candidateVersion = '1.1.0'; useOtherPath = $false }
            @{ shape = 'conflicting requested origins'; moduleCount = 2; candidateName = 'Fixture.Module'; candidateVersion = '1.2.3'; useOtherPath = $true }
        ) {
            $script:importedFixtures = @(
                [pscustomobject] @{
                    Name       = 'Load-Assemblies'
                    Version    = [version] '0.0'
                    ModuleBase = $script:moduleBase
                }
                if ($moduleCount -gt 1) { $script:installedFixture }
                if ($moduleCount -gt 0) {
                    [pscustomobject] @{
                        Name       = $candidateName
                        Version    = [version] $candidateVersion
                        ModuleBase = $useOtherPath ? (Join-Path $TestDrive 'other') : $script:moduleBase
                    }
                }
            )
            Mock Import-Module { $script:importedFixtures }

            { Install-CustomModule -Module @{ Name = 'Fixture.Module'; Version = '1.2.3' } -ErrorAction Continue } |
                Should -Throw '*imported module*does not match*'

            Should -Invoke Import-Module -Times 1 -Exactly
            Should -Invoke Install-Module -Times 1 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
            Should -Invoke Remove-Module -Times 0 -Exactly
        }
    }

    It 'Does not replace an incompatible loaded Pester engine' {
        Mock Find-Module {
            [pscustomobject] @{ Name = 'Pester'; Version = [version] '5.7.1'; Dependencies = @() }
        }
        Mock Get-Module {
            if ($ListAvailable) {
                [pscustomobject] @{ Name = 'Pester'; Version = [version] '5.7.1'; ModuleBase = (Join-Path $TestDrive 'Pester\5.7.1') }
            } else {
                [pscustomobject] @{ Name = 'Pester'; Version = [version] '5.5.0'; ModuleBase = (Join-Path $TestDrive 'Pester\5.5.0') }
            }
        } -ParameterFilter { $Name -eq 'Pester' }

        { Install-CustomModule -Module @{ Name = 'Pester'; Version = '5.7.1' } } |
            Should -Throw '*already loaded*'

        Should -Invoke Remove-Module -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
    }
}

Describe 'Installed dependency usability' {
    BeforeAll {
        if (Get-Module -Name Avm.BootstrapFixture -ListAvailable) { throw 'The fixture module name is already installed.' }
        $script:originalModulePath = $env:PSModulePath
        $script:originalPester = Get-Module -Name Pester
    }

    BeforeEach {
        $script:fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $script:fixtureBase = Join-Path $script:fixtureRoot 'Avm.BootstrapFixture\1.2.3'
        $script:fixtureManifest = Join-Path $script:fixtureBase 'Avm.BootstrapFixture.psd1'
        $script:fixtureScript = Join-Path $script:fixtureBase 'Avm.BootstrapFixture.psm1'
        $null = New-Item -ItemType Directory -Path $script:fixtureBase -Force
        $env:PSModulePath = $script:fixtureRoot + [System.IO.Path]::PathSeparator + $script:originalModulePath
        Set-Content -LiteralPath $script:fixtureManifest -Value "@{ ModuleVersion = '1.2.3'; RootModule = 'Avm.BootstrapFixture.psm1'; FunctionsToExport = @('Get-AvmBootstrapFixtureValue') }"
        Set-Content -LiteralPath $script:fixtureScript -Value "function Get-AvmBootstrapFixtureValue { 'fixture-ready' }"
        Mock Get-PSRepository { @{ Name = 'PSGallery' } }
        Mock Find-Module {
            [pscustomobject] @{ Name = 'Avm.BootstrapFixture'; Version = [version] '1.2.3'; Dependencies = @() }
        }
        Mock Install-Module {}
        Mock Start-Sleep {}
    }

    AfterEach {
        Get-Module -Name Avm.BootstrapFixture, Load-Assemblies |
            Where-Object ModuleBase -EQ $script:fixtureBase |
            Remove-Module -ErrorAction Stop
        $env:PSModulePath = $script:originalModulePath
        $pester = Get-Module -Name Pester
        $pester.Version | Should -Be $script:originalPester.Version
        $pester.ModuleBase | Should -BeExactly $script:originalPester.ModuleBase
    }

    It 'Imports the exact manifest and makes the installed fixture usable' {
        Install-CustomModule -Module @{ Name = 'Avm.BootstrapFixture'; Version = '1.2.3' }

        Get-AvmBootstrapFixtureValue | Should -BeExactly 'fixture-ready'
        $loaded = Get-Module -Name Avm.BootstrapFixture
        $loaded.Version | Should -Be ([version] '1.2.3')
        $loaded.ModuleBase | Should -BeExactly $script:fixtureBase
    }

    It 'Imports a usable manifest with ScriptsToProcess under caller preference <preference>' -Tag 'YamlImportIdentity' -ForEach @(
        @{ preference = 'Continue' }
        @{ preference = 'Stop' }
    ) {
        $ErrorActionPreference = $preference
        Set-Content -LiteralPath (Join-Path $script:fixtureBase 'Load-Assemblies.ps1') -Value '$null = 1'
        Set-Content -LiteralPath $script:fixtureManifest -Value "@{ ModuleVersion = '1.2.3'; RootModule = 'Avm.BootstrapFixture.psm1'; FunctionsToExport = @('Get-AvmBootstrapFixtureValue'); ScriptsToProcess = @('Load-Assemblies.ps1') }"

        Install-CustomModule -Module @{ Name = 'Avm.BootstrapFixture'; Version = '1.2.3' } -ErrorAction $preference

        Get-AvmBootstrapFixtureValue | Should -BeExactly 'fixture-ready'
        $loaded = @(Get-Module -Name Avm.BootstrapFixture)
        $loaded.Count | Should -Be 1
        $loaded[0].Version | Should -Be ([version] '1.2.3')
        $loaded[0].ModuleBase | Should -BeExactly $script:fixtureBase
        Should -Invoke Install-Module -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
        $ErrorActionPreference | Should -Be $preference
    }

    It 'Preserves a root initialization error after ScriptsToProcess with caller preference <preference>' -Tag 'YamlImportIdentity' -ForEach @(
        @{ preference = 'Continue' }
        @{ preference = 'Stop' }
    ) {
        $ErrorActionPreference = $preference
        Set-Content -LiteralPath (Join-Path $script:fixtureBase 'Load-Assemblies.ps1') -Value '$null = 1'
        Set-Content -LiteralPath $script:fixtureManifest -Value "@{ ModuleVersion = '1.2.3'; RootModule = 'Avm.BootstrapFixture.psm1'; FunctionsToExport = @('Get-AvmBootstrapFixtureValue'); ScriptsToProcess = @('Load-Assemblies.ps1') }"
        Set-Content -LiteralPath $script:fixtureScript -Value "Write-Error 'Offline initialized fixture failed.'"

        { Install-CustomModule -Module @{ Name = 'Avm.BootstrapFixture'; Version = '1.2.3' } -ErrorAction $preference } |
            Should -Throw '*Offline initialized fixture failed.*'

        Should -Invoke Install-Module -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
        $ErrorActionPreference | Should -Be $preference
    }

    It 'Rejects a real manifest whose root module fails to initialize' {
        Set-Content -LiteralPath $script:fixtureScript -Value "throw 'Offline fixture initialization failed.'"

        { Install-CustomModule -Module @{ Name = 'Avm.BootstrapFixture'; Version = '1.2.3' } } |
            Should -Throw '*Offline fixture initialization failed.*'

        Should -Invoke Install-Module -Times 1 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Rejects a manifest whose required root file is missing' {
        Remove-Item -LiteralPath $script:fixtureScript

        { Install-CustomModule -Module @{ Name = 'Avm.BootstrapFixture'; Version = '1.2.3' } } | Should -Throw

        Should -Invoke Install-Module -Times 1 -Exactly
    }

    It 'Does not accept an empty leftover version directory' {
        Remove-Item -LiteralPath $script:fixtureScript, $script:fixtureManifest

        { Install-CustomModule -Module @{ Name = 'Avm.BootstrapFixture'; Version = '1.2.3' } } |
            Should -Throw '*Installation of module*failed*'
    }
}

Describe 'Bicep CLI installation' {
    BeforeAll {
        function az { throw 'Unexpected Azure CLI invocation.' }
        function bicep { throw 'Unexpected compiler invocation.' }
        function curl { throw 'Unexpected download.' }
        function chmod { throw 'Unexpected permission change.' }
        function sudo { throw 'Unexpected privileged command.' }

        $candidatePath = Join-Path $TestDrive 'candidate bicep'
        Set-Item -LiteralPath "Function:\$candidatePath" -Value { throw 'Unexpected candidate invocation.' }
    }

    BeforeEach {
        $savedExitCode = $global:LASTEXITCODE
        $script:installedPath = Join-Path $TestDrive 'installed-bicep'
        $script:preinstalledContents = 'Preinstalled compiler fixture'
        $script:validContents = 'New compiler fixture'
        $script:downloadContents = $script:validContents
        $script:downloadExitCode = 0
        $script:downloadDiagnostics = $null
        $script:commands = [System.Collections.Generic.List[string]]::new()
        Set-Content -LiteralPath $script:installedPath -Value $script:preinstalledContents -NoNewline
        Push-Location -LiteralPath $TestDrive

        Mock az {
            $global:LASTEXITCODE = 0
            if ($args[0] -eq 'extension') {
                $script:commands.Add('extensions')
                '[]'
            }
        }
        Mock bicep {
            $global:LASTEXITCODE = 0
            switch (Get-Content -LiteralPath $script:installedPath -Raw) {
                $script:preinstalledContents {
                    $script:commands.Add('preinstalled-version')
                    'Bicep CLI version 0.47.16 (offline fixture)'
                }
                $script:validContents {
                    $script:commands.Add('installed-version')
                    'Bicep CLI version 1.2.3 (offline fixture)'
                }
                default { throw 'Exec format error (offline fixture).' }
            }
        }
        Mock curl {
            $script:commands.Add('download')
            $outputIndex = [array]::IndexOf($args, '--output')
            if ($outputIndex -lt 0) {
                $outputIndex = [array]::IndexOf($args, '-Lo')
            }
            if ($outputIndex -lt 0) { throw 'Unexpected download arguments.' }
            Set-Content -LiteralPath $args[$outputIndex + 1] -Value $script:downloadContents -NoNewline
            $global:LASTEXITCODE = $script:downloadExitCode
            $script:downloadDiagnostics
        }
        Mock chmod {
            $script:commands.Add('permissions')
            $global:LASTEXITCODE = 0
        }
        Mock sudo {
            $script:commands.Add('promote')
            if ($args.Count -ne 3 -or $args[0] -ne 'mv' -or $args[2] -ne '/usr/local/bin/bicep') {
                throw 'Unexpected privileged command arguments.'
            }
            Move-Item -LiteralPath $args[1] -Destination $script:installedPath -Force
            $global:LASTEXITCODE = 0
        }
        Mock New-TemporaryFile {
            New-Item -Path $candidatePath -ItemType File -Force
        }
        Mock -CommandName $candidatePath -MockWith {
            $script:commands.Add('candidate-version')
            if ((Get-Content -LiteralPath $candidatePath -Raw) -ne $script:validContents) {
                throw 'Exec format error (offline fixture).'
            }
            $global:LASTEXITCODE = 0
            'Bicep CLI version 1.2.3 (offline fixture)'
        }
        Mock Get-Module {}
        Mock Install-CustomModule { $script:commands.Add('modules') }
        Mock Test-Path { $Path -eq $profile } -ParameterFilter {
            $Path -eq $profile -or $Path -eq '/usr/share/'
        }
    }

    AfterEach {
        Pop-Location
        $global:LASTEXITCODE = $savedExitCode
    }

    AfterAll {
        Remove-Item -LiteralPath "Function:\$candidatePath"
    }

    It 'Preserves the installed compiler when downloaded bytes cannot execute' {
        $script:downloadContents = 'x' * 1812

        { Set-EnvironmentOnAgent } | Should -Throw '*Exec format error*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke sudo -Times 0 -Exactly
        Should -Invoke Install-CustomModule -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Validates the official latest download before promotion and continues unrelated setup' {
        Set-Content -LiteralPath 'bicep' -Value 'Unrelated workspace file' -NoNewline

        Set-EnvironmentOnAgent -PSModules @(@{ Name = 'Fixture.Module' }) | Out-Null

        $script:commands -join ',' | Should -BeExactly 'preinstalled-version,download,permissions,candidate-version,promote,installed-version,extensions,modules'
        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:validContents
        Get-Content -LiteralPath 'bicep' -Raw | Should -BeExactly 'Unrelated workspace file'
        Should -Invoke curl -Times 1 -Exactly -ParameterFilter {
            ($args -join '|') -eq "--fail|--location|--silent|--show-error|--output|$candidatePath|https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64"
        }
        Should -Invoke chmod -Times 1 -Exactly -ParameterFilter {
            ($args -join '|') -eq "+x|$candidatePath"
        }
        Should -Invoke -CommandName $candidatePath -Times 1 -Exactly -ParameterFilter {
            ($args -join '|') -eq '--version'
        }
        Should -Invoke Install-CustomModule -Times 1 -Exactly -ParameterFilter { $Module.Name -eq 'Fixture.Module' }
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Stops after one failed GET and preserves download diagnostics: <kind>' -ForEach @(
        @{ kind = 'HTTP failure'; code = 22; diagnostics = 'curl: (22) The requested URL returned error: 503' }
        @{ kind = 'partial transfer'; code = 18; diagnostics = 'curl: (18) end of response with bytes missing' }
        @{ kind = 'TLS failure'; code = 60; diagnostics = 'curl: (60) SSL certificate problem' }
    ) {
        $script:downloadExitCode = $code
        $script:downloadDiagnostics = $diagnostics

        { Set-EnvironmentOnAgent -ErrorAction Continue } | Should -Throw "*exit code ${code}: $diagnostics*"

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke curl -Times 1 -Exactly
        Should -Invoke chmod -Times 0 -Exactly
        Should -Invoke -CommandName $candidatePath -Times 0 -Exactly
        Should -Invoke sudo -Times 0 -Exactly
        Should -Invoke Install-CustomModule -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Rejects a candidate with a failing version command even if it prints a Bicep version' {
        Mock -CommandName $candidatePath -MockWith {
            $global:LASTEXITCODE = 1
            'Bicep CLI version 1.2.3 (offline fixture)'
            'Candidate runtime failure'
        }

        { Set-EnvironmentOnAgent } | Should -Throw '*candidate validation failed with exit code 1:*Candidate runtime failure*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke sudo -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Rejects a successful command without a Bicep version: <kind>' -ForEach @(
        @{ kind = 'empty output'; output = '' }
        @{ kind = 'unexpected output'; output = 'Not a Bicep compiler' }
    ) {
        $script:versionOutput = $output
        Mock -CommandName $candidatePath -MockWith {
            $global:LASTEXITCODE = 0
            $script:versionOutput
        }

        { Set-EnvironmentOnAgent } | Should -Throw '*candidate returned an unexpected version*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke sudo -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Stops before validation when executable permissions cannot be set' {
        Mock chmod {
            $global:LASTEXITCODE = 1
            'chmod: permission denied'
        }

        { Set-EnvironmentOnAgent } | Should -Throw '*permission update failed with exit code 1:*chmod: permission denied*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke -CommandName $candidatePath -Times 0 -Exactly
        Should -Invoke sudo -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Reports promotion failure instead of falling back to the installed compiler' {
        Mock sudo {
            $global:LASTEXITCODE = 1
            'mv: permission denied'
        }

        { Set-EnvironmentOnAgent } | Should -Throw '*installation failed with exit code 1:*mv: permission denied*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke bicep -Times 1 -Exactly
        Should -Invoke Install-CustomModule -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Preserves launch errors under caller error preferences <preference> and native preference <nativePreference>' -ForEach @(
        @{ preference = 'Continue'; nativePreference = $false }
        @{ preference = 'Continue'; nativePreference = $true }
        @{ preference = 'Stop'; nativePreference = $false }
        @{ preference = 'Stop'; nativePreference = $true }
    ) {
        $ErrorActionPreference = $preference
        $PSNativeCommandUseErrorActionPreference = $nativePreference
        Mock -CommandName $candidatePath -MockWith { Write-Error 'Exec format error (offline fixture).' }

        { Set-EnvironmentOnAgent -ErrorAction $preference } | Should -Throw '*Exec format error*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke sudo -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
        $ErrorActionPreference | Should -Be $preference
        $PSNativeCommandUseErrorActionPreference | Should -Be $nativePreference
    }

    It 'Reports a failed installed compiler version check and does not continue setup' {
        Mock bicep {
            if ((Get-Content -LiteralPath $script:installedPath -Raw) -eq $script:preinstalledContents) {
                $global:LASTEXITCODE = 0
                'Bicep CLI version 0.47.16 (offline fixture)'
            } else {
                $global:LASTEXITCODE = 1
                'Installed compiler runtime failure'
            }
        }

        { Set-EnvironmentOnAgent } | Should -Throw '*Installed Bicep CLI version check failed with exit code 1:*Installed compiler runtime failure*'

        Should -Invoke sudo -Times 1 -Exactly
        Should -Invoke Install-CustomModule -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Preserves stderr diagnostics from a failed download' {
        Mock curl {
            $global:LASTEXITCODE = 22
            Write-Error 'Download stderr fixture' -ErrorAction Continue
        }

        { Set-EnvironmentOnAgent } | Should -Throw '*download failed with exit code 22:*Download stderr fixture*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke sudo -Times 0 -Exactly
        Test-Path -LiteralPath $candidatePath | Should -BeFalse
    }

    It 'Does not hide the download failure when temporary file cleanup also fails' {
        $script:downloadExitCode = 22
        $script:downloadDiagnostics = 'Download failure fixture'
        $script:cleanupErrors = @()
        Mock Remove-Item { Write-Error 'Temporary candidate cleanup failed.' } -ParameterFilter {
            $LiteralPath -eq $candidatePath
        }

        { Set-EnvironmentOnAgent -ErrorVariable +script:cleanupErrors 2>$null } |
            Should -Throw '*download failed with exit code 22:*Download failure fixture*'

        $script:cleanupErrors | Out-String | Should -Match 'Temporary candidate cleanup failed'
        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke sudo -Times 0 -Exactly
    }

    It 'Stops before downloading when a temporary candidate cannot be created' {
        Mock New-TemporaryFile { Write-Error 'Temporary file creation failed.' }

        { Set-EnvironmentOnAgent -ErrorAction Continue } | Should -Throw '*Temporary file creation failed*'

        Get-Content -LiteralPath $script:installedPath -Raw | Should -BeExactly $script:preinstalledContents
        Should -Invoke curl -Times 0 -Exactly
        Should -Invoke sudo -Times 0 -Exactly
    }
}
