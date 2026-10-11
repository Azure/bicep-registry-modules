BeforeAll {
    $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'psrule' 'Save-PSRulePackageSet.ps1')
    function Save-Package {
        [CmdletBinding()]
        param(
            [string] $Name,
            [string] $RequiredVersion,
            [string] $Source,
            [string] $ProviderName,
            [string] $Path,
            [switch] $Force,
            [switch] $AllowPrereleaseVersions
        )
        throw 'The download stub must be mocked.'
    }
    function New-TestArchive {
        param([string] $Path, [string] $Id, [string] $Version, [string] $Xml)
        $archive = [IO.Compression.ZipFile]::Open($Path, [IO.Compression.ZipArchiveMode]::Create)
        try {
            $writer = [IO.StreamWriter]::new($archive.CreateEntry("$Id.nuspec").Open())
            try {
                if (-not $Xml) { $Xml = "<package><metadata><id>$Id</id><version>$Version</version></metadata></package>" }
                $writer.Write($Xml)
            } finally { $writer.Dispose() }
        } finally { $archive.Dispose() }
    }
}

Describe 'PSRule package download staging' {
    BeforeEach {
        $script:destination = Join-Path $TestDrive ('repository-' + [guid]::NewGuid().ToString('N'))
        $script:package = @([pscustomobject]@{ Name = 'PSRule.Rules.Azure'; Version = '1.48.0-preview1'; AllowPrerelease = $true })
        $script:attemptPaths = [Collections.Generic.List[string]]::new()
        $script:corruptAttempts = 0
        $script:corruptDependency = $false
        $script:downloadError = $null
        $script:manifestVersion = '1.48.0-preview1'
        $script:manifestXml = $null
        Mock Save-Package {
            $script:attemptPaths.Add($Path)
            if ($script:downloadError) { throw $script:downloadError }
            $rulesPath = Join-Path $Path 'PSRule.Rules.Azure.1.48.0-preview1.nupkg'
            $enginePath = Join-Path $Path 'PSRule.2.9.0.nupkg'
            New-TestArchive -Path $rulesPath -Id 'PSRule.Rules.Azure' -Version $script:manifestVersion -Xml $script:manifestXml
            New-TestArchive -Path $enginePath -Id 'PSRule' -Version '2.9.0'
            if ($script:attemptPaths.Count -le $script:corruptAttempts) {
                $corruptPath = if ($script:corruptDependency) { $enginePath } else { $rulesPath }
                [IO.File]::WriteAllText($corruptPath, 'Truncated archive without an end-of-central-directory record.')
            }
        }
    }

    It 'publishes a complete readable package set without installing anything' {
        $result = Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination
        $result | Should -Be $script:destination
        @(Get-ChildItem -LiteralPath $result -Filter '*.nupkg').Count | Should -Be 2
        Should -Invoke Save-Package -Exactly 1 -ParameterFilter {
            $Name -eq 'PSRule.Rules.Azure' -and $RequiredVersion -eq '1.48.0-preview1' -and
            $Source -eq 'fixture-source' -and $ProviderName -eq 'NuGet' -and $AllowPrereleaseVersions -and $Force
        }
    }

    It 'retries a corrupt root archive once with unchanged selection and a fresh directory' {
        $script:corruptAttempts = 1
        $result = Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination
        Test-Path -LiteralPath $result | Should -BeTrue
        $script:attemptPaths.Count | Should -Be 2
        $script:attemptPaths[0] | Should -Not -Be $script:attemptPaths[1]
        $script:attemptPaths | ForEach-Object { Test-Path -LiteralPath $_ | Should -BeFalse }
        Should -Invoke Save-Package -Exactly 2 -ParameterFilter { $RequiredVersion -eq '1.48.0-preview1' -and $AllowPrereleaseVersions }
    }

    It 'also confines corrupt dependency recovery to download-only staging' {
        $script:corruptAttempts = 1
        $script:corruptDependency = $true
        $result = Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination
        @(Get-ChildItem -LiteralPath $result -Filter '*.nupkg').Count | Should -Be 2
        Should -Invoke Save-Package -Exactly 2
    }

    It 'fails after two corrupt downloads and does not publish partial content' {
        $script:corruptAttempts = 2
        $caught = $null
        try { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } catch { $caught = $_ }
        $caught | Should -Not -BeNullOrEmpty
        $caught.FullyQualifiedErrorId | Should -BeLike 'PSRulePackageArchiveInvalid*'
        Test-Path -LiteralPath $script:destination | Should -BeFalse
        $script:attemptPaths | ForEach-Object { Test-Path -LiteralPath $_ | Should -BeFalse }
        Should -Invoke Save-Package -Exactly 2
    }

    It 'does not retry a transport failure and preserves its error record' {
        $script:downloadError = [Management.Automation.ErrorRecord]::new(
            [IO.IOException]::new('Connection failed.'), 'FixtureTransportFailure',
            [Management.Automation.ErrorCategory]::ConnectionError, 'fixture-source'
        )
        $caught = $null
        try { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } catch { $caught = $_ }
        $caught.FullyQualifiedErrorId | Should -BeLike 'FixtureTransportFailure*'
        $caught.TargetObject | Should -Be 'fixture-source'
        Should -Invoke Save-Package -Exactly 1
        Test-Path -LiteralPath $script:destination | Should -BeFalse
    }

    It 'does not treat an error with a matching label from the downloader as local archive corruption' {
        $script:downloadError = [Management.Automation.ErrorRecord]::new(
            [IO.InvalidDataException]::new('Not the local archive reader.'), 'PSRulePackageArchiveInvalid',
            [Management.Automation.ErrorCategory]::InvalidData, 'fixture-source'
        )
        { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } | Should -Throw '*Not the local archive reader*'
        Should -Invoke Save-Package -Exactly 1
    }

    It 'does not accept or retry the wrong package version' {
        $script:manifestVersion = '1.49.0'
        { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } | Should -Throw '*was not downloaded*'
        Should -Invoke Save-Package -Exactly 1
        Test-Path -LiteralPath $script:destination | Should -BeFalse
    }

    It 'does not retry malformed package metadata' {
        $script:manifestXml = '<package><metadata>'
        { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } | Should -Throw
        Should -Invoke Save-Package -Exactly 1
        Test-Path -LiteralPath $script:destination | Should -BeFalse
    }

    It 'rejects an existing destination without changing its contents' {
        $null = New-Item -Path $script:destination -ItemType Directory
        $marker = Join-Path $script:destination 'existing.txt'
        [IO.File]::WriteAllText($marker, 'unchanged')
        { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } | Should -Throw '*already exists*'
        [IO.File]::ReadAllText($marker) | Should -Be 'unchanged'
        Should -Invoke Save-Package -Exactly 0
    }

    It 'rejects an unpinned requested version before downloading' {
        $script:package[0].Version = 'latest'
        { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } | Should -Throw '*exact version*'
        Should -Invoke Save-Package -Exactly 0
    }

    It 'does not pass the prerelease switch for a stable-only request' {
        $script:package[0].AllowPrerelease = $false
        $null = Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination
        Should -Invoke Save-Package -Exactly 1 -ParameterFilter { -not $PSBoundParameters.ContainsKey('AllowPrereleaseVersions') }
    }

    It 'does not retry an empty download' {
        Mock Save-Package {}
        { Save-PSRulePackageSet -Package $script:package -Source 'fixture-source' -Destination $script:destination } | Should -Throw '*no archives*'
        Should -Invoke Save-Package -Exactly 1
        Test-Path -LiteralPath $script:destination | Should -BeFalse
    }
}
