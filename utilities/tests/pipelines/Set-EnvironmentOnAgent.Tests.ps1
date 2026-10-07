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
}

Describe 'PowerShell Gallery initialization' {
    BeforeEach {
        Mock Get-Module {}
        Mock Get-PSRepository { @{ Name = 'PSGallery' } }
        Mock Register-PSRepository {}
        Mock Find-Module {}
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
}
