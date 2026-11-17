. (Join-Path $PSScriptRoot 'Save-PSRulePackageSet.ps1')

function Initialize-PSRuleRepository {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $TemporaryPath
    )

    # Match the engine required by the pinned microsoft/ps-rule action.
    $engineVersion = '2.9.0'
    $installed = @(Get-InstalledModule -ErrorAction Stop)
    $engineInstalled = $false
    if (@($installed | Where-Object Name -EQ 'PSRule').Count) {
        $engineInstalled = @(Get-InstalledModule -Name 'PSRule' -AllVersions -ErrorAction Stop |
            Where-Object { $_.Version.ToString() -eq $engineVersion }).Count -gt 0
    }
    $rulesInstalled = @($installed | Where-Object Name -EQ 'PSRule.Rules.Azure').Count -gt 0
    if ($engineInstalled -and $rulesInstalled) {
        return 'PSGallery'
    }

    $packages = @()
    if (-not $engineInstalled) {
        $engine = Find-Module -Name 'PSRule' -RequiredVersion $engineVersion -Repository 'PSGallery' -ErrorAction Stop
        if ($engine.Name -ne 'PSRule' -or $engine.Version.ToString() -ne $engineVersion) {
            throw "The PSRule action engine could not be resolved to version $engineVersion."
        }
        $packages += [pscustomobject]@{ Name = 'PSRule'; Version = $engineVersion; AllowPrerelease = $false }
    }
    if (-not $rulesInstalled) {
        $rules = Find-Module -Name 'PSRule.Rules.Azure' -AllowPrerelease -Repository 'PSGallery' -ErrorAction Stop
        if ($rules.Name -ne 'PSRule.Rules.Azure' -or -not $rules.Version) {
            throw 'The PSRule Azure rules package could not be resolved.'
        }
        $packages += [pscustomobject]@{ Name = 'PSRule.Rules.Azure'; Version = $rules.Version.ToString(); AllowPrerelease = $true }
    }
    $source = Get-PSRepository -Name 'PSGallery' -ErrorAction Stop
    if (-not $source.SourceLocation) { throw 'The PSGallery repository has no source location.' }
    $repositoryName = 'avm-psrule-' + [guid]::NewGuid().ToString('N')
    $destination = Join-Path $TemporaryPath $repositoryName
    $null = Save-PSRulePackageSet -Package $packages -Source $source.SourceLocation -Destination $destination
    Register-PSRepository -Name $repositoryName -SourceLocation $destination -InstallationPolicy Trusted -ErrorAction Stop
    return $repositoryName
}
