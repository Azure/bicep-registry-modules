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
}

Describe 'PowerShell Gallery initialization' {
    BeforeEach {
        Mock Get-Module {
            if ($ListAvailable) { @{ Name = 'Fixture.Module'; Version = [version] '1.2.3' } }
        }
        Mock Get-PSRepository { @{ Name = 'PSGallery' } }
        Mock Register-PSRepository {}
        Mock Find-Module { @{ Name = 'Fixture.Module'; Version = [version] '1.2.3' } }
        Mock Install-Module {}
    }

    It 'Keeps an existing PowerShell Gallery registration' {
        Install-CustomModule -Module @{ Name = 'Fixture.Module' }

        Should -Invoke Register-PSRepository -Times 0 -Exactly
        Should -Invoke Find-Module -Times 1 -Exactly -ParameterFilter { $Repository -eq 'PSGallery' }
    }

    It 'Registers PowerShell Gallery before resolving a module when it is missing' {
        $script:galleryRegistered = $false
        Mock Get-PSRepository { @{ Name = 'ExistingPrivateRepository' } }
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
        Mock Get-PSRepository {}

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
            Should -Throw "*Unable to find repository 'PSGallery'.*"

        Should -Invoke Register-PSRepository -Times 1 -Exactly -ParameterFilter { $Default }
        Should -Invoke Install-Module -Times 0 -Exactly
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
    }
}
