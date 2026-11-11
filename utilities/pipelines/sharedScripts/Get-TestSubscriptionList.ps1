<#
.SYNOPSIS
Resolve the test subscription pool and optionally shuffle it.

.DESCRIPTION
Callers prefer variables over secrets, selecting VALIDATE_SUBSCRIPTION_IDS
before its TEST_SUBSCRIPTION_IDS alias within each source. The selected value
is a JSON array of { id, name, tag? } objects; no other properties are allowed.
An omitted tag means General. Supplying ModulePath selects only its configured
tag; omitting ModulePath returns the complete inventory for maintenance.
Only General can use the legacy validation subscription when the pool is unset.
A shared random seed reproduces the same shuffled order across deployment jobs.
Records retain their original pool index and a SHA-256 digest of the canonical subscription ID.
#>
function Get-TestSubscriptionList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $TestSubscriptionIds,

        [Parameter()]
        [string] $FallbackSubscriptionId,

        [Parameter()]
        [string] $ModulePath,

        [Parameter()]
        [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName,

        [Parameter()]
        [ValidateRange(0, 2147483647)]
        [int] $RandomSeed
    )

    $ErrorActionPreference = 'Stop'
    . (Join-Path $PSScriptRoot 'Get-TestSubscriptionTag.ps1')
    $requiredTag = if ($PSBoundParameters.ContainsKey('ModulePath')) {
        Get-TestSubscriptionTag -ModulePath $ModulePath -RepoRootPath $RepoRootPath
    } else {
        $null
    }

    if (-not [string]::IsNullOrEmpty($TestSubscriptionIds) -and [string]::IsNullOrWhiteSpace($TestSubscriptionIds)) {
        throw 'The configured test subscription pool must not contain only whitespace.'
    }
    if ([string]::IsNullOrEmpty($TestSubscriptionIds)) {
        if ($requiredTag -and $requiredTag -cne 'General') {
            throw "Reserved subscription pool [$requiredTag] requires TEST_SUBSCRIPTION_IDS; the legacy subscription cannot be used."
        }
        if ([string]::IsNullOrWhiteSpace($FallbackSubscriptionId)) {
            throw 'No test subscriptions configured. Set the TEST_SUBSCRIPTION_IDS variable to a JSON array of { id, name } objects or set the VALIDATE_SUBSCRIPTION_ID secret.'
        }

        Write-Verbose 'TEST_SUBSCRIPTION_IDS is unset; using VALIDATE_SUBSCRIPTION_ID as a single-subscription pool.'
        $subscriptions = @([pscustomobject]@{
                id   = $FallbackSubscriptionId
                name = $FallbackSubscriptionId
            })
    } else {
        $document = [System.Text.Json.JsonDocument]::Parse($TestSubscriptionIds)
        try {
            if ($document.RootElement.ValueKind -eq [System.Text.Json.JsonValueKind]::Array) {
                foreach ($entry in $document.RootElement.EnumerateArray()) {
                    if ($entry.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) {
                        continue
                    }
                    $properties = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
                    foreach ($property in $entry.EnumerateObject()) {
                        if ($property.Name -cnotin @('id', 'name', 'tag')) {
                            throw 'Test subscription entries may contain only id, name, and optional tag properties, with those exact names.'
                        }
                        if (-not $properties.Add($property.Name)) {
                            throw 'Test subscription entries must not contain duplicate properties.'
                        }
                    }
                }
            }
        } finally {
            $document.Dispose()
        }
        $subscriptions = ConvertFrom-Json -InputObject $TestSubscriptionIds -NoEnumerate -ErrorAction Stop
        if ($subscriptions -isnot [array] -or $subscriptions.Count -eq 0) {
            throw 'TEST_SUBSCRIPTION_IDS must be a non-empty JSON array of { id, name } objects.'
        }
    }

    $subscriptionIds = [System.Collections.Generic.HashSet[guid]]::new()
    $normalizedSubscriptions = @(
        for ($index = 0; $index -lt $subscriptions.Count; $index++) {
            $subscription = $subscriptions[$index]
            $subscriptionId = [guid]::Empty
            if ($subscription -isnot [pscustomobject] -or
                $subscription.id -isnot [string] -or
                -not [guid]::TryParseExact($subscription.id, 'D', [ref] $subscriptionId) -or $subscriptionId -eq [guid]::Empty) {
                throw 'Each test subscription must be an object with an id containing a subscription GUID.'
            }
            if ($subscription.name -isnot [string] -or
                [string]::IsNullOrWhiteSpace($subscription.name) -or
                $subscription.name -match '[\r\n]') {
                throw 'Each test subscription must have a non-empty, single-line name.'
            }
            if (-not $subscriptionIds.Add($subscriptionId)) {
                throw 'TEST_SUBSCRIPTION_IDS must not contain duplicate subscription IDs, including across tags.'
            }
            $tag = if ($subscription.PSObject.Properties.Name -ccontains 'tag') {
                Assert-TestSubscriptionTag -Tag $subscription.tag
                $subscription.tag
            } else {
                'General'
            }

            [pscustomobject]@{
                id    = $subscription.id
                name  = $subscription.name
                tag   = $tag
                index = $index
                key   = [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData(
                        [System.Text.Encoding]::UTF8.GetBytes($subscriptionId.ToString('D'))
                    )).ToLowerInvariant()
            }
        }
    )

    if ($requiredTag) {
        $normalizedSubscriptions = @($normalizedSubscriptions | Where-Object { $_.tag -ceq $requiredTag })
        if ($normalizedSubscriptions.Count -eq 0) {
            throw "No test subscriptions match required tag [$requiredTag] for module [$ModulePath]."
        }
    }

    if ($PSBoundParameters.ContainsKey('RandomSeed')) {
        return $normalizedSubscriptions | Get-Random -Shuffle -SetSeed $RandomSeed
    }

    return $normalizedSubscriptions
}
