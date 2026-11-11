. (Join-Path $PSScriptRoot 'Register-RequiredSubscriptionFeature.ps1')

<#
.SYNOPSIS
Register a module's required Azure resource providers in its selected test subscription.

.DESCRIPTION
The optional repository-root .required-resource-providers.json maps exact module
paths to arrays of provider namespaces. For example:
{ "avm/res/example/module": ["Microsoft.Example"] }
The entire map is validated before Azure calls. Missing or empty requirements
are logged and skipped; parent module requirements are not inherited.
The map is limited to 64 KiB and 32 providers per module. Namespaces must be
ASCII with at most 128 characters; duplicate keys/providers are rejected.

Use the same authenticated Azure CLI identity, subscription and tenant as the
deployment tests. The identity needs each provider's /register/action at
subscription scope. Registered providers are skipped; existing Registering
operations are awaited without resubmission. NotRegistered or Unregistered
providers are registered once, then awaited. Pending approval, unexpected
states, failed commands and timeouts stop the run.
Each Azure CLI command has a 60-second timeout. Registrations persist after
testing; this function never unregisters providers or switches Azure accounts.

.PARAMETER ModulePath
Exact repository-relative module directory, using lowercase forward-slash paths.

.PARAMETER SubscriptionId
Nonempty GUID of the selected test subscription.

.PARAMETER TenantId
Nonempty GUID of the tenant used for the test job's Azure login.

.PARAMETER RepoRootPath
Repository root containing the optional .required-resource-providers.json map.

.PARAMETER MaximumPolls
Maximum status checks per provider. Defaults to 60.

.PARAMETER PollIntervalSeconds
Seconds between checks, with an immediate first check. Defaults to 10.

.EXAMPLE
Register-RequiredSubscriptionResourceProvider -ModulePath 'avm/res/example/module' -SubscriptionId $subscriptionId -TenantId $tenantId -WhatIf

Validate requirements without contacting Azure.
#>
function Register-RequiredSubscriptionResourceProvider {
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
    $providers = @(Get-RequiredSubscriptionRequirement -RepoRootPath $RepoRootPath -ModulePath $ModulePath -Kind Provider)
    foreach ($identity in @{ SubscriptionId = $SubscriptionId; TenantId = $TenantId }.GetEnumerator()) {
        $guid = [guid]::Empty
        if (-not [guid]::TryParseExact($identity.Value, 'D', [ref] $guid) -or $guid -eq [guid]::Empty) {
            throw "$($identity.Key) must be an explicit, nonempty GUID for the selected test subscription and login tenant."
        }
    }
    $SubscriptionId = ([guid] $SubscriptionId).ToString('D')
    $TenantId = ([guid] $TenantId).ToString('D')
    $result = [pscustomobject]@{
        Status                     = 'skipped'
        SubscriptionId             = $SubscriptionId
        TenantId                   = $TenantId
        ProvidersTotal             = $providers.Count
        RegisteredProviders        = @()
        AlreadyRegisteredProviders = @()
        Reason                     = 'No required Azure subscription resource providers declared.'
    }
    if ($providers.Count -eq 0) {
        return $result
    }
    if (-not $PSCmdlet.ShouldProcess("Azure subscription $SubscriptionId in tenant $TenantId", "Register required resource providers for $ModulePath")) {
        $result.Reason = 'Registration was not approved (WhatIf or Confirm).'
        return $result
    }

    Assert-RequiredSubscriptionAccount -RepoRootPath $RepoRootPath -SubscriptionId $SubscriptionId -TenantId $TenantId -Kind Provider
    foreach ($provider in $providers) {
        $stateInput = @{
            Kind           = 'Provider'
            RepoRootPath   = $RepoRootPath
            SubscriptionId = $SubscriptionId
            Namespace      = $provider.Namespace
        }
        $state = Get-RequiredFeatureRegistrationState @stateInput
        if ($state -ceq 'Registered') {
            $result.AlreadyRegisteredProviders += $provider.Namespace
            Write-Verbose "Provider [$($provider.Namespace)] is already Registered in subscription [$SubscriptionId]." -Verbose
            continue
        }
        if ($state -cin @('NotRegistered', 'Unregistered')) {
            $arguments = @(
                'provider', 'register', '--namespace', $provider.Namespace,
                '--subscription', $SubscriptionId, '--output', 'none', '--only-show-errors'
            )
            $null = Invoke-RequiredFeatureAzCli -ArgumentList $arguments -RepoRootPath $RepoRootPath `
                -Operation "register provider [$($provider.Namespace)] in subscription [$SubscriptionId]" `
                -PermissionHint "The test identity needs the provider's /register/action at subscription scope. "
        } elseif ($state -ceq 'Pending') {
            throw "Provider [$($provider.Namespace)] is Pending in subscription [$SubscriptionId]. Request approval from the Azure service or open a support ticket before rerunning tests."
        } elseif ($state -cne 'Registering') {
            throw "Provider [$($provider.Namespace)] has unexpected registration state [$state] in subscription [$SubscriptionId]."
        }

        Wait-RequiredFeatureRegistration @stateInput -MaximumPolls $MaximumPolls -PollIntervalSeconds $PollIntervalSeconds
        $result.RegisteredProviders += $provider.Namespace
        Write-Verbose "Provider [$($provider.Namespace)] is Registered in subscription [$SubscriptionId]." -Verbose
    }

    $result.Status = 'pass'
    $result.Reason = ''
    return $result
}
