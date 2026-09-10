#requires -Version 7.2

#region helper functions
function Invoke-CIGitHubCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ExecutablePath,

        [Parameter(Mandatory)]
        [string[]] $ArgumentList,

        [Parameter()]
        [System.Security.SecureString] $InputValue
    )

    $hasInput = $PSBoundParameters.ContainsKey('InputValue')
    $process = $null
    $started = $false
    $plainText = $null

    try {
        $arguments = @($ArgumentList)
        if ($hasInput) {
            $plainText = [System.Net.NetworkCredential]::new('', $InputValue).Password
            # gh trims CR/LF from raw stdin; a quoted dotenv value preserves trailing line endings.
            if ($plainText.EndsWith("`r") -or $plainText.EndsWith("`n")) {
                $escapedValue = $plainText.Replace('\', '\\').Replace('"', '\"').Replace('$', '\$').Replace("`r", '\r').Replace("`n", '\n')
                $plainText = '{0}="{1}"' -f $arguments[2], $escapedValue
                $escapedValue = $null
                $arguments += @('--env-file', '-')
            }
        }

        $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
        $startInfo.FileName = $ExecutablePath
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true
        $startInfo.RedirectStandardInput = $true
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardInputEncoding = [System.Text.UTF8Encoding]::new($false)
        $startInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
        $startInfo.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)
        $startInfo.Environment['GH_HOST'] = 'github.com'
        $startInfo.Environment['GH_PROMPT_DISABLED'] = '1'
        $null = $startInfo.Environment.Remove('GH_DEBUG')
        foreach ($argument in $arguments) {
            $startInfo.ArgumentList.Add($argument)
        }

        $process = New-Object -TypeName System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $started = $process.Start()
        if (-not $started) {
            throw [System.InvalidOperationException]::new('The process did not start.')
        }

        # Drain both streams concurrently, but never disclose native diagnostics or write output.
        $outputTask = $process.StandardOutput.ReadToEndAsync()
        $errorTask = $process.StandardError.ReadToEndAsync()
        if ($hasInput) {
            $process.StandardInput.Write($plainText)
        }
        $process.StandardInput.Close()
        $plainText = $null
        $process.WaitForExit()
        $output = $outputTask.GetAwaiter().GetResult()
        $null = $errorTask.GetAwaiter().GetResult()
        $exitCode = $process.ExitCode
    } catch [System.ComponentModel.Win32Exception], [System.InvalidOperationException], [System.IO.IOException], [System.Management.Automation.MethodInvocationException] {
        throw 'GitHub CLI process failed. Native output and exception details are suppressed to protect values.'
    } finally {
        $plainText = $null
        $escapedValue = $null
        if ($null -ne $process) {
            try {
                if ($started -and -not $process.HasExited) {
                    $process.Kill($true)
                    $process.WaitForExit()
                }
            } finally {
                $process.Dispose()
            }
        }
    }

    if ($exitCode -ne 0) {
        throw "GitHub CLI exited with code [$exitCode]. Native output is suppressed to protect values."
    }
    if (-not $hasInput) {
        return $output
    }
}

function Get-CIGitHubConfigurationNameSet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ExecutablePath,

        [Parameter(Mandatory)]
        [ValidateSet('Secret', 'Variable')]
        [string] $Kind,

        [Parameter(Mandatory)]
        [string] $Repository,

        [Parameter()]
        [string] $Environment = ''
    )

    $arguments = @($Kind.ToLowerInvariant(), 'list', '--repo', $Repository, '--json', 'name')
    if ($Environment) {
        $arguments += @('--env', $Environment)
    }
    $json = Invoke-CIGitHubCommand -ExecutablePath $ExecutablePath -ArgumentList $arguments
    try {
        $entries = ConvertFrom-Json -InputObject $json -AsHashtable -NoEnumerate -ErrorAction Stop
    } catch [System.ArgumentException] {
        throw "Invalid GitHub $Kind name inventory. Response details are suppressed."
    }
    if ($entries -isnot [array]) {
        throw "Invalid GitHub $Kind name inventory: expected an array."
    }

    $names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $entries) {
        if ($entry -isnot [System.Collections.IDictionary] -or $entry.name -isnot [string] -or $entry.name -cnotmatch '^[A-Za-z_][A-Za-z0-9_]*$') {
            throw "Invalid entry in GitHub $Kind name inventory. Response details are suppressed."
        }
        $null = $names.Add($entry.name)
    }
    return ,$names
}
#endregion

<#
.SYNOPSIS
Preview or copy CI Key Vault secrets to GitHub Actions secrets or explicitly selected variables.

.DESCRIPTION
Inventories CI-<parameterName> Key Vault secret metadata and GitHub destination names.
SecretName optionally limits the plan to reviewed, existing source names; omitted means all CI- entries.
Maps names to uppercase CI_<parameterName> without changing the parameter suffix.
Values remain secrets unless explicitly selected using VariableName. Variables are NON-SENSITIVE.
Dry run is the default. Apply and per-entry ShouldProcess approval are required before reading values.
Existing entries are skipped unless Overwrite is supplied. Opposite-kind collisions are always blocked;
resolve the classification or destination configuration explicitly before retrying.
Never deletes source or destination entries, writes value files, or prints values.

Only the selected repository or environment scope is inventoried; GitHub resolves inherited scopes
at runtime. Destination names are rechecked before each approved copy, but GitHub CLI set operations
are upserts, not atomic create-only operations. Avoid concurrent destination configuration changes.
The inventory's source version is used when available; otherwise metadata-only version enumeration
pins the uniquely newest version before reading it. Failures stop the run without rollback.

.PARAMETER VaultName
Mandatory. Existing Azure Key Vault containing CI-<parameterName> secrets.

.PARAMETER Repository
Mandatory. Public github.com destination in owner/repo form.

.PARAMETER Environment
Optional. Existing GitHub environment name. Empty or omitted selects repository scope.

.PARAMETER SecretName
Optional. Exact CI-<parameterName> Key Vault source names to include, matched case-insensitively.
Omitted includes all CI- entries. An explicitly empty selection, unknown name, or wildcard fails.
Unselected legacy entries are not validated or copied. This does not change destination classification.

.PARAMETER VariableName
Optional. Explicit CI_<parameterName> destination names to copy as NON-SENSITIVE GitHub variables.
Names are matched case-insensitively and must match the selected source plan. All other entries are secrets.

.PARAMETER Apply
Optional. Perform approved copies. Without this switch, only metadata is read.

.PARAMETER Overwrite
Optional. Allow replacement of existing entries of the same kind only. Never deletes or changes kinds.

.OUTPUTS
System.Management.Automation.PSCustomObject
Source/destination names, repository/environment scope, kind, and status. No values.

.NOTES
Requires PowerShell 7.2+, Az.KeyVault, an authenticated Azure PowerShell context with secret list/get
permissions, and GitHub CLI (gh) on PATH authenticated to github.com with destination write permissions.
Does not install dependencies, log in, switch subscriptions, create environments, or manage tokens.
The current Azure context and the existing GitHub CLI authenticated session are used.
Dry run/WhatIf still require metadata read permissions. No secret values are read for skipped entries.

.EXAMPLE
. .\utilities\tools\Copy-CIKeyVaultSecretsToGitHub.ps1
Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo'

Preview repository-scoped copies using names and metadata only.

.EXAMPLE
Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName 'CI-clientId', 'CI-location' -VariableName 'CI_LOCATION'

Preview only reviewed source names, opting CI_LOCATION into a non-sensitive variable.

.EXAMPLE
Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Environment 'validation' -VariableName 'CI_LOCATION' -Apply -WhatIf

Preview environment-scoped copies, opting only CI_LOCATION into a non-sensitive variable.

.EXAMPLE
Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite

Copy entries and deliberately replace same-kind entries. Opposite-kind collisions remain blocked.
#>
function Copy-CIKeyVaultSecretsToGitHub {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^(?!.*--)[A-Za-z][A-Za-z0-9-]{1,22}[A-Za-z0-9]$')]
        [string] $VaultName,

        [Parameter(Mandatory)]
        [ValidatePattern('^[A-Za-z0-9][A-Za-z0-9-]*/[A-Za-z0-9_.-]+$')]
        [string] $Repository,

        [Parameter()]
        [AllowEmptyString()]
        [ValidateLength(0, 255)]
        [ValidatePattern('^[^\x00-\x1F\x7F]*$')]
        [string] $Environment = '',

        [Parameter()]
        [string[]] $SecretName = @(),

        [Parameter()]
        [string[]] $VariableName = @(),

        [Parameter()]
        [switch] $Apply,

        [Parameter()]
        [switch] $Overwrite
    )

    if ($Environment -and [string]::IsNullOrWhiteSpace($Environment)) {
        throw 'Environment must be an existing environment name or empty for repository scope.'
    }
    if ($PSBoundParameters.ContainsKey('SecretName') -and ($null -eq $SecretName -or $SecretName.Count -eq 0)) {
        throw 'SecretName was explicitly empty. Supply reviewed CI- source names or omit the parameter to include all CI- entries.'
    }

    try {
        $ghPath = (Get-Command -Name gh -CommandType Application -ErrorAction Stop).Path
    } catch [System.Management.Automation.CommandNotFoundException] {
        throw 'GitHub CLI (gh) must be installed on PATH and authenticated to github.com.'
    }

    $azOptions = @{
        VaultName         = $VaultName
        ErrorAction       = 'Stop'
        Verbose           = $false
        Debug             = $false
        WarningAction     = 'SilentlyContinue'
        InformationAction = 'SilentlyContinue'
    }
    try {
        $sources = @(Get-AzKeyVaultSecret @azOptions)
    } catch [System.Management.Automation.ActionPreferenceStopException], [System.Management.Automation.CmdletInvocationException], [System.Net.Http.HttpRequestException], [System.TimeoutException] {
        throw "Cannot inventory Key Vault [$VaultName]. Check Az.KeyVault, the current Azure context, and list permissions. Details are suppressed."
    }

    $selectedNames = $null
    if ($PSBoundParameters.ContainsKey('SecretName')) {
        $selectedNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $availableNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($source in $sources) {
            $null = $availableNames.Add($source.Name)
        }
        foreach ($name in $SecretName) {
            if ([string]::IsNullOrWhiteSpace($name) -or $name -notmatch '^CI-') {
                throw "SecretName [$name] must be an exact CI- Key Vault source name, not a CI_ destination name."
            }
            if (-not $availableNames.Contains($name)) {
                throw "SecretName [$name] does not match a source secret in the Key Vault inventory. Names are literal; wildcards and name conversions are not supported."
            }
            $null = $selectedNames.Add($name)
        }
    }

    $plannedNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $plan = @(
        foreach ($source in $sources) {
            if ($null -ne $selectedNames -and -not $selectedNames.Contains($source.Name)) {
                continue
            }
            if ($source.Name -notmatch '^CI-') {
                continue
            }
            if ($source.Name -cnotmatch '^(?i:CI)-[A-Za-z_][A-Za-z0-9_]*$' -or $source.Name.Length -gt 100) {
                throw "Cannot map Key Vault name [$($source.Name)] to CI_<parameterName>. The suffix must be a Bicep identifier and the target at most 100 characters; hyphens are not replaced."
            }
            $targetName = 'CI_{0}' -f $source.Name.Substring(3).ToUpperInvariant()
            if (-not $plannedNames.Add($targetName)) {
                throw "Multiple source names map to GitHub name [$targetName]. Resolve the ambiguity before copying."
            }
            @{
                Source = $source
                Name   = $targetName
            }
        }
    )

    $variableNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($name in $VariableName) {
        if ([string]::IsNullOrWhiteSpace($name) -or -not $plannedNames.Contains($name)) {
            throw "VariableName [$name] does not match a planned CI_ destination name. Use exact mapped names, not Key Vault CI- names."
        }
        $null = $variableNames.Add($name)
    }

    $githubOptions = @{
        ExecutablePath = $ghPath
        Repository     = $Repository
        Environment    = $Environment
    }
    $destinationNames = @{}
    foreach ($kind in @('Secret', 'Variable')) {
        $destinationNames[$kind] = Get-CIGitHubConfigurationNameSet @githubOptions -Kind $kind
    }

    foreach ($item in $plan) {
        $kind = $variableNames.Contains($item.Name) ? 'Variable' : 'Secret'
        $oppositeKind = $kind -eq 'Secret' ? 'Variable' : 'Secret'
        $result = [pscustomobject]@{
            VaultName       = $VaultName
            SourceName      = $item.Source.Name
            DestinationName = $item.Name
            Repository      = $Repository
            Environment     = $Environment
            Scope           = $Environment ? 'Environment' : 'Repository'
            Kind            = $kind
            Status          = 'Planned'
        }

        if ($destinationNames[$oppositeKind].Contains($item.Name)) {
            $result.Status = 'BlockedByOppositeKind'
        } elseif ($destinationNames[$kind].Contains($item.Name) -and -not $Overwrite) {
            $result.Status = 'SkippedExisting'
        } elseif ($item.Source.Enabled -eq $false) {
            $result.Status = 'SkippedDisabled'
        } elseif ($item.Source.Expires -and [DateTimeOffset] $item.Source.Expires -le [DateTimeOffset]::UtcNow) {
            $result.Status = 'SkippedExpired'
        } elseif ($item.Source.NotBefore -and [DateTimeOffset] $item.Source.NotBefore -gt [DateTimeOffset]::UtcNow) {
            $result.Status = 'SkippedNotYetValid'
        } elseif ($destinationNames[$kind].Contains($item.Name)) {
            $result.Status = 'PlannedOverwrite'
        }

        if (-not $Apply -or $result.Status -notin @('Planned', 'PlannedOverwrite')) {
            $result
            continue
        }

        $action = $Overwrite ? 'Copy or overwrite from Key Vault' : 'Copy from Key Vault'
        $target = "$Repository [$($result.Scope):$Environment] $kind [$($item.Name)] from [$($item.Source.Name)]"
        if (-not $PSCmdlet.ShouldProcess($target, $action)) {
            $result.Status = 'SkippedShouldProcess'
            $result
            continue
        }

        # Recheck both kinds after approval, before retrieving a value.
        $currentNames = @{}
        foreach ($currentKind in @('Secret', 'Variable')) {
            $currentNames[$currentKind] = Get-CIGitHubConfigurationNameSet @githubOptions -Kind $currentKind
        }
        if ($currentNames[$oppositeKind].Contains($item.Name)) {
            $result.Status = 'BlockedByOppositeKind'
            $result
            continue
        }
        if ($currentNames[$kind].Contains($item.Name) -and -not $Overwrite) {
            $result.Status = 'SkippedExisting'
            $result
            continue
        }

        $metadata = $item.Source
        if ([string]::IsNullOrWhiteSpace($metadata.Version)) {
            try {
                $versions = @(Get-AzKeyVaultSecret @azOptions -Name $metadata.Name -IncludeVersions)
            } catch [System.Management.Automation.ActionPreferenceStopException], [System.Management.Automation.CmdletInvocationException], [System.Net.Http.HttpRequestException], [System.TimeoutException] {
                throw "Cannot inventory versions of Key Vault secret [$($metadata.Name)]. Details are suppressed."
            }
            if ($versions.Count -eq 0 -or @($versions | Where-Object { -not $_.Version -or -not $_.Created }).Count -gt 0) {
                throw "Cannot pin a version of Key Vault secret [$($metadata.Name)]: version metadata is missing."
            }
            $versions = @($versions | Sort-Object -Property { [DateTimeOffset] $_.Created } -Descending)
            if ($versions.Count -gt 1 -and [DateTimeOffset] $versions[0].Created -eq [DateTimeOffset] $versions[1].Created) {
                throw "Cannot pin a unique latest version of Key Vault secret [$($metadata.Name)]."
            }
            $metadata = $versions[0]
        }
        if ($metadata.Enabled -eq $false) {
            $result.Status = 'SkippedDisabled'
            $result
            continue
        }
        if ($metadata.Expires -and [DateTimeOffset] $metadata.Expires -le [DateTimeOffset]::UtcNow) {
            $result.Status = 'SkippedExpired'
            $result
            continue
        }
        if ($metadata.NotBefore -and [DateTimeOffset] $metadata.NotBefore -gt [DateTimeOffset]::UtcNow) {
            $result.Status = 'SkippedNotYetValid'
            $result
            continue
        }

        $secret = $null
        try {
            try {
                $secret = Get-AzKeyVaultSecret @azOptions -Name $item.Source.Name -Version $metadata.Version
            } catch [System.Management.Automation.ActionPreferenceStopException], [System.Management.Automation.CmdletInvocationException], [System.Net.Http.HttpRequestException], [System.TimeoutException] {
                throw "Cannot read the pinned version of Key Vault secret [$($item.Source.Name)]. Check source availability and get permissions. Details are suppressed."
            }
            if ($null -eq $secret -or $secret.SecretValue -isnot [System.Security.SecureString] -or $secret.SecretValue.Length -eq 0) {
                throw "Key Vault secret [$($item.Source.Name)] has no accessible, non-empty value. Nothing was copied for this entry."
            }
            if ($secret.Enabled -eq $false) {
                throw "Key Vault secret [$($item.Source.Name)] is now disabled. Nothing was copied for this entry."
            }
            if (($secret.Expires -and [DateTimeOffset] $secret.Expires -le [DateTimeOffset]::UtcNow) -or ($secret.NotBefore -and [DateTimeOffset] $secret.NotBefore -gt [DateTimeOffset]::UtcNow)) {
                throw "Key Vault secret [$($item.Source.Name)] is outside its validity period. Nothing was copied for this entry."
            }
            if ($secret.Version -cne $metadata.Version) {
                throw "Key Vault secret [$($item.Source.Name)] did not return the pinned version. Nothing was copied for this entry."
            }

            $arguments = @($kind.ToLowerInvariant(), 'set', $item.Name, '--repo', $Repository)
            if ($Environment) {
                $arguments += @('--env', $Environment)
            }
            $null = Invoke-CIGitHubCommand -ExecutablePath $ghPath -ArgumentList $arguments -InputValue $secret.SecretValue
        } finally {
            if ($null -ne $secret -and $secret.SecretValue -is [System.Security.SecureString]) {
                $secret.SecretValue.Dispose()
            }
            $secret = $null
        }

        $result.Status = 'Copied'
        $result
    }
}
