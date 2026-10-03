function Get-RequiredSubscriptionFeature {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param (
        [Parameter(Mandatory)]
        [string] $RepoRootPath,

        [Parameter(Mandatory)]
        [string] $ModulePath
    )

    $ErrorActionPreference = 'Stop'
    $modulePattern = '\Aavm/(res|ptn|utl)/[a-z0-9]+(?:-[a-z0-9]+)*(?:/[a-z0-9]+(?:-[a-z0-9]+)*)+\z'
    if ($ModulePath -cnotmatch $modulePattern) {
        throw 'ModulePath must be an exact repository-relative AVM module directory, using lowercase names and forward slashes.'
    }

    $files = @(Get-ChildItem -LiteralPath $RepoRootPath -Force | Where-Object { $_.Name -ieq '.required-features.json' })
    if ($files.Count -eq 0) {
        Write-Verbose 'No root .required-features.json found; no subscription features are required.' -Verbose
        return
    }
    if ($files.Count -ne 1 -or $files[0].Name -cne '.required-features.json' -or $files[0].PSIsContainer) {
        throw 'Required subscription features must be declared in a file named exactly .required-features.json at the repository root.'
    }
    if ($files[0].Length -gt 65536) {
        throw '.required-features.json exceeds the 64 KiB limit.'
    }

    $contents = Get-Content -LiteralPath $files[0].FullName -Raw -Encoding utf8
    if ([string]::IsNullOrWhiteSpace($contents)) {
        throw '.required-features.json must contain a valid JSON object mapping module paths to feature arrays.'
    }
    try {
        $document = [System.Text.Json.JsonDocument]::Parse([string] $contents)
    } catch [System.Text.Json.JsonException] {
        throw [System.ArgumentException]::new('.required-features.json must contain a valid JSON object mapping module paths to feature arrays.', $_.Exception)
    }

    try {
        if ($document.RootElement.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) {
            throw '.required-features.json must contain a JSON object mapping module paths to feature arrays.'
        }

        $modules = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        $features = [System.Collections.Generic.List[pscustomobject]]::new()
        $featurePattern = '\A(?<namespace>[A-Za-z][A-Za-z0-9]*(?:\.[A-Za-z][A-Za-z0-9]*)+)/(?<name>[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)\z'
        foreach ($module in $document.RootElement.EnumerateObject()) {
            if ($module.Name -cnotmatch $modulePattern) {
                throw ".required-features.json key [$($module.Name)] must be an exact repository-relative AVM module directory."
            }
            if (-not $modules.Add($module.Name)) {
                throw "Duplicate module path [$($module.Name)] in .required-features.json."
            }
            if ($module.Value.ValueKind -ne [System.Text.Json.JsonValueKind]::Array) {
                throw ".required-features.json entry [$($module.Name)] must be a JSON array of Namespace/FeatureName strings."
            }
            if ($module.Value.GetArrayLength() -gt 32) {
                throw ".required-features.json entry [$($module.Name)] must contain no more than 32 features."
            }

            $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
            foreach ($entry in $module.Value.EnumerateArray()) {
                if ($entry.ValueKind -ne [System.Text.Json.JsonValueKind]::String) {
                    throw ".required-features.json entry [$($module.Name)] must contain only Namespace/FeatureName strings."
                }
                $name = $entry.GetString()
                $match = [regex]::Match($name, $featurePattern)
                if (-not $match.Success -or
                    $match.Groups['namespace'].Value.Length -gt 128 -or
                    $match.Groups['name'].Value.Length -gt 128) {
                    throw ".required-features.json entry [$($module.Name)] must use ASCII Namespace/FeatureName strings without whitespace, extra path segments or command arguments (128 characters per part maximum)."
                }
                if (-not $seen.Add($name)) {
                    throw "Duplicate feature [$name] in .required-features.json entry [$($module.Name)] (case-insensitive)."
                }
                if ($module.Name -ceq $ModulePath) {
                    $features.Add([pscustomobject]@{
                            Namespace = $match.Groups['namespace'].Value
                            Name      = $match.Groups['name'].Value
                            FullName  = $name
                        })
                }
            }
        }

        if ($features.Count -eq 0) {
            Write-Verbose "No subscription features are required for exact module path [$ModulePath]." -Verbose
        }
        return $features.ToArray()
    } finally {
        $document.Dispose()
    }
}

function Invoke-RequiredFeatureAzCli {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string[]] $ArgumentList,

        [Parameter(Mandatory)]
        [string] $RepoRootPath,

        [Parameter(Mandatory)]
        [string] $Operation,

        [Parameter()]
        [string] $PermissionHint = ''
    )

    $ErrorActionPreference = 'Stop'
    try {
        $command = Get-Command -Name az -CommandType Application -ErrorAction Stop | Select-Object -First 1
    } catch [System.Management.Automation.CommandNotFoundException] {
        throw 'Azure CLI is required to register subscription features. Install az and authenticate with the same identity used for deployment tests.'
    }
    if (-not $command -or -not [System.IO.Path]::IsPathRooted($command.Source)) {
        throw 'Azure CLI must resolve to an installed executable.'
    }

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $command.Source
    $startInfo.WorkingDirectory = $RepoRootPath
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
    $startInfo.StandardErrorEncoding = [System.Text.UTF8Encoding]::new($false)
    if ($IsWindows -and [System.IO.Path]::GetExtension($command.Source) -ieq '.cmd') {
        $pythonPath = Join-Path (Split-Path -Parent (Split-Path -Parent $command.Source)) 'python.exe'
        if ([System.IO.Path]::GetFileName($command.Source) -cne 'az.cmd' -or
            -not (Test-Path -LiteralPath $pythonPath -PathType Leaf)) {
            throw 'The Azure CLI Windows MSI Python executable was not found. Repair the Azure CLI installation.'
        }
        $startInfo.FileName = $pythonPath
        foreach ($argument in @('-IBm', 'azure.cli')) {
            $startInfo.ArgumentList.Add($argument)
        }
        $startInfo.Environment['AZ_INSTALLER'] = 'MSI'
    }
    foreach ($argument in $ArgumentList) {
        $startInfo.ArgumentList.Add($argument)
    }

    $process = New-Object -TypeName System.Diagnostics.Process
    $started = $false
    try {
        $process.StartInfo = $startInfo
        $started = $process.Start()
        if (-not $started) {
            throw "Azure CLI could not start to $Operation."
        }
        $outputTask = $process.StandardOutput.ReadToEndAsync()
        $errorTask = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit(60000)) {
            throw [System.TimeoutException]::new("Azure CLI timed out after 60 seconds while attempting to $Operation. Check Azure registration status before retrying.")
        }
        $output = $outputTask.GetAwaiter().GetResult()
        $errorOutput = $errorTask.GetAwaiter().GetResult()
        if ($process.ExitCode -ne 0) {
            $diagnostic = [string]::IsNullOrWhiteSpace($errorOutput) ? $output : $errorOutput
            throw "Azure CLI failed to $Operation (exit code $($process.ExitCode)). $PermissionHint$diagnostic"
        }
        return $output
    } catch [System.ComponentModel.Win32Exception] {
        throw [System.InvalidOperationException]::new("Azure CLI could not start to $Operation. $($_.Exception.Message)", $_.Exception)
    } finally {
        try {
            if ($started -and -not $process.HasExited) {
                $process.Kill($true)
                if (-not $process.WaitForExit(5000)) {
                    throw "Could not stop the Azure CLI process after attempting to $Operation."
                }
            }
        } finally {
            $process.Dispose()
        }
    }
}

function Get-RequiredFeatureRegistrationState {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Feature', 'Provider')]
        [string] $Kind,

        [Parameter(Mandatory)]
        [string] $RepoRootPath,

        [Parameter(Mandatory)]
        [string] $SubscriptionId,

        [Parameter(Mandatory)]
        [string] $Namespace,

        [Parameter()]
        [string] $Name
    )

    $ErrorActionPreference = 'Stop'
    $arguments = @($Kind.ToLowerInvariant(), 'show', '--namespace', $Namespace)
    $label = $Namespace
    if ($Kind -eq 'Feature') {
        $arguments += @('--name', $Name)
        $label = "$Namespace/$Name"
    }
    $arguments += @('--subscription', $SubscriptionId, '--output', 'json', '--only-show-errors')
    $response = Invoke-RequiredFeatureAzCli -ArgumentList $arguments -RepoRootPath $RepoRootPath `
        -Operation "inspect $Kind [$label] in subscription [$SubscriptionId]"
    if ([string]::IsNullOrWhiteSpace($response)) {
        throw "Azure CLI returned empty JSON for $Kind [$label] in subscription [$SubscriptionId]."
    }
    try {
        $data = ConvertFrom-Json -InputObject $response -AsHashtable -NoEnumerate -ErrorAction Stop
    } catch [System.ArgumentException] {
        throw [System.InvalidOperationException]::new("Azure CLI returned invalid JSON for $Kind [$label] in subscription [$SubscriptionId].", $_.Exception)
    }
    if ($data -isnot [System.Collections.IDictionary]) {
        throw "Azure CLI returned an unexpected JSON value for $Kind [$label] in subscription [$SubscriptionId]."
    }

    if ($Kind -eq 'Feature') {
        $expectedId = "/subscriptions/$SubscriptionId/providers/Microsoft.Features/providers/$Namespace/features/$Name"
        if ($data['id'] -isnot [string] -or $data['id'] -ine $expectedId -or
            $data['name'] -isnot [string] -or $data['name'] -ine $label -or
            $data['properties'] -isnot [System.Collections.IDictionary]) {
            throw "Azure CLI returned an unexpected feature identity for [$label] in subscription [$SubscriptionId]."
        }
        $state = $data['properties']['state']
    } else {
        if ($data['namespace'] -isnot [string] -or $data['namespace'] -ine $Namespace) {
            throw "Azure CLI returned an unexpected provider identity for [$Namespace] in subscription [$SubscriptionId]."
        }
        $state = $data['registrationState']
    }
    if ($state -isnot [string] -or [string]::IsNullOrWhiteSpace($state)) {
        throw "Azure CLI returned an invalid registration state for $Kind [$label] in subscription [$SubscriptionId]."
    }
    return $state
}

function Wait-RequiredFeatureRegistration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Feature', 'Provider')]
        [string] $Kind,

        [Parameter(Mandatory)]
        [string] $RepoRootPath,

        [Parameter(Mandatory)]
        [string] $SubscriptionId,

        [Parameter(Mandatory)]
        [string] $Namespace,

        [Parameter()]
        [string] $Name,

        [Parameter(Mandatory)]
        [int] $MaximumPolls,

        [Parameter(Mandatory)]
        [int] $PollIntervalSeconds
    )

    $label = $Kind -eq 'Feature' ? "$Namespace/$Name" : $Namespace
    for ($attempt = 1; $attempt -le $MaximumPolls; $attempt++) {
        if ($attempt -gt 1) {
            Start-Sleep -Seconds $PollIntervalSeconds
        }
        $state = Get-RequiredFeatureRegistrationState -Kind $Kind -RepoRootPath $RepoRootPath `
            -SubscriptionId $SubscriptionId -Namespace $Namespace -Name $Name
        Write-Verbose "$Kind [$label] in subscription [$SubscriptionId] is [$state] (check $attempt of $MaximumPolls)." -Verbose
        if ($state -ceq 'Registered') {
            return
        }
        if ($state -ceq 'Pending') {
            throw "$Kind [$label] is Pending in subscription [$SubscriptionId]. Request approval from the Azure service or open a support ticket before rerunning tests."
        }
        if ($state -cnotin @('Registering', 'NotRegistered', 'Unregistered')) {
            throw "$Kind [$label] has unexpected registration state [$state] in subscription [$SubscriptionId]."
        }
    }
    throw "$Kind [$label] did not reach Registered in subscription [$SubscriptionId] after $MaximumPolls checks ($PollIntervalSeconds seconds apart). Check Azure registration status before retrying."
}

<#
.SYNOPSIS
Register a module's required Azure features in its selected test subscription.

.DESCRIPTION
The optional repository-root .required-features.json maps exact module paths to
arrays of "Namespace/FeatureName" strings. For example:
{ "avm/res/example/module": ["Microsoft.Example/FeatureOne"] }
The entire map is validated before Azure calls. Missing or empty requirements
are logged and skipped; parent module requirements are not inherited.
The map is limited to 64 KiB and 32 features per module. Feature parts must
be ASCII with at most 128 characters each; duplicate keys/features are rejected.

Use the same authenticated Azure CLI identity, subscription and tenant as the
deployment tests. The identity needs Microsoft.Features/* and each resource
provider's /register/action at subscription scope. Registered features are
skipped; existing Registering operations are awaited without resubmission.
After each newly completed feature, its provider is re-registered and awaited.
Pending approval, unexpected states, failed commands and timeouts stop the run.
Each Azure CLI command has a 60-second timeout. Registrations persist after
testing; this function never unregisters features or switches Azure accounts.

.PARAMETER ModulePath
Exact repository-relative module directory, using lowercase forward-slash paths.

.PARAMETER SubscriptionId
Nonempty GUID of the selected test subscription.

.PARAMETER TenantId
Nonempty GUID of the tenant used for the test job's Azure login.

.PARAMETER RepoRootPath
Repository root containing the optional .required-features.json map.

.PARAMETER MaximumPolls
Maximum status checks per feature or provider. Defaults to 60.

.PARAMETER PollIntervalSeconds
Seconds between checks, with an immediate first check. Defaults to 10.

.EXAMPLE
Register-RequiredSubscriptionFeature -ModulePath 'avm/res/example/module' -SubscriptionId $subscriptionId -TenantId $tenantId -WhatIf

Validate requirements without contacting Azure.
#>
function Register-RequiredSubscriptionFeature {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([pscustomobject])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $ModulePath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $SubscriptionId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $TenantId,

        [Parameter()]
        [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName,

        [Parameter()]
        [ValidateRange(1, 120)]
        [int] $MaximumPolls = 60,

        [Parameter()]
        [ValidateRange(1, 60)]
        [int] $PollIntervalSeconds = 10
    )

    $ErrorActionPreference = 'Stop'
    $features = @(Get-RequiredSubscriptionFeature -RepoRootPath $RepoRootPath -ModulePath $ModulePath)
    foreach ($identity in @{ SubscriptionId = $SubscriptionId; TenantId = $TenantId }.GetEnumerator()) {
        $guid = [guid]::Empty
        if (-not [guid]::TryParseExact($identity.Value, 'D', [ref] $guid) -or $guid -eq [guid]::Empty) {
            throw "$($identity.Key) must be an explicit, nonempty GUID for the selected test subscription and login tenant."
        }
    }
    $SubscriptionId = ([guid] $SubscriptionId).ToString('D')
    $TenantId = ([guid] $TenantId).ToString('D')
    $result = [pscustomobject]@{
        Status                    = 'skipped'
        SubscriptionId            = $SubscriptionId
        TenantId                  = $TenantId
        FeaturesTotal             = $features.Count
        RegisteredFeatures        = @()
        AlreadyRegisteredFeatures = @()
        Reason                    = 'No required Azure subscription features declared.'
    }
    if ($features.Count -eq 0) {
        return $result
    }
    if (-not $PSCmdlet.ShouldProcess("Azure subscription $SubscriptionId in tenant $TenantId", "Register required features for $ModulePath")) {
        $result.Reason = 'Registration was not approved (WhatIf or Confirm).'
        return $result
    }

    $response = Invoke-RequiredFeatureAzCli -ArgumentList @('account', 'show', '--output', 'json', '--only-show-errors') `
        -RepoRootPath $RepoRootPath -Operation 'verify the selected Azure subscription and tenant'
    if ([string]::IsNullOrWhiteSpace($response)) {
        throw 'Azure CLI returned empty account JSON while verifying the selected test subscription and tenant.'
    }
    try {
        $account = ConvertFrom-Json -InputObject $response -AsHashtable -NoEnumerate -ErrorAction Stop
    } catch [System.ArgumentException] {
        throw [System.InvalidOperationException]::new('Azure CLI returned invalid account JSON while verifying the selected test subscription and tenant.', $_.Exception)
    }
    if ($account -isnot [System.Collections.IDictionary] -or
        $account['id'] -isnot [string] -or $account['id'] -ine $SubscriptionId -or
        $account['tenantId'] -isnot [string] -or $account['tenantId'] -ine $TenantId) {
        throw "Azure CLI must be authenticated to the selected test subscription [$SubscriptionId] and login tenant [$TenantId]. Refusing feature registration."
    }

    foreach ($feature in $features) {
        $stateInput = @{
            RepoRootPath   = $RepoRootPath
            SubscriptionId = $SubscriptionId
            Namespace      = $feature.Namespace
        }
        $waitInput = @{
            MaximumPolls        = $MaximumPolls
            PollIntervalSeconds = $PollIntervalSeconds
        }
        $state = Get-RequiredFeatureRegistrationState @stateInput -Kind Feature -Name $feature.Name
        if ($state -ceq 'Registered') {
            $result.AlreadyRegisteredFeatures += $feature.FullName
            Write-Verbose "Feature [$($feature.FullName)] is already Registered in subscription [$SubscriptionId]." -Verbose
            continue
        }
        if ($state -cin @('NotRegistered', 'Unregistered')) {
            $arguments = @(
                'feature', 'register', '--namespace', $feature.Namespace, '--name', $feature.Name,
                '--subscription', $SubscriptionId, '--output', 'none', '--only-show-errors'
            )
            $null = Invoke-RequiredFeatureAzCli -ArgumentList $arguments -RepoRootPath $RepoRootPath `
                -Operation "register feature [$($feature.FullName)] in subscription [$SubscriptionId]" `
                -PermissionHint 'The test identity needs Microsoft.Features/* at subscription scope. '
        } elseif ($state -ceq 'Pending') {
            throw "Feature [$($feature.FullName)] is Pending in subscription [$SubscriptionId]. Request approval from the Azure service or open a support ticket before rerunning tests."
        } elseif ($state -cne 'Registering') {
            throw "Feature [$($feature.FullName)] has unexpected registration state [$state] in subscription [$SubscriptionId]."
        }

        Wait-RequiredFeatureRegistration @stateInput @waitInput -Kind Feature -Name $feature.Name
        $arguments = @(
            'provider', 'register', '--namespace', $feature.Namespace,
            '--subscription', $SubscriptionId, '--output', 'none', '--only-show-errors'
        )
        $null = Invoke-RequiredFeatureAzCli -ArgumentList $arguments -RepoRootPath $RepoRootPath `
            -Operation "refresh provider [$($feature.Namespace)] in subscription [$SubscriptionId]" `
            -PermissionHint "The test identity needs the provider's /register/action at subscription scope. "
        Wait-RequiredFeatureRegistration @stateInput @waitInput -Kind Provider
        $result.RegisteredFeatures += $feature.FullName
        Write-Verbose "Feature [$($feature.FullName)] and provider [$($feature.Namespace)] are Registered in subscription [$SubscriptionId]." -Verbose
    }

    $result.Status = 'pass'
    $result.Reason = ''
    return $result
}
