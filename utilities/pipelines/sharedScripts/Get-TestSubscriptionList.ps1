<#
.SYNOPSIS
Resolve the test subscription pool and optionally shuffle it.

.DESCRIPTION
TEST_BAMI_SUBSCRIPTION_IDS requires a non-empty JSON array of { id, name } objects.
A shared random seed reproduces the same shuffled order across deployment matrix jobs.
#>
function Get-TestSubscriptionList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $TestSubscriptionIds,

        [Parameter()]
        [ValidateRange(0, 2147483647)]
        [int] $RandomSeed
    )

    if ([string]::IsNullOrWhiteSpace($TestSubscriptionIds)) {
        throw 'Missing BAMI configuration for [TEST_BAMI_SUBSCRIPTION_IDS]. Set a non-empty JSON array of { id, name } objects.'
    }

    try {
        $subscriptions = ConvertFrom-Json -InputObject $TestSubscriptionIds -NoEnumerate -ErrorAction Stop
    }
    catch [System.ArgumentException] {
        throw 'TEST_BAMI_SUBSCRIPTION_IDS must be valid JSON containing an array of { id, name } objects.'
    }
    if ($subscriptions -isnot [array] -or $subscriptions.Count -eq 0) {
        throw 'TEST_BAMI_SUBSCRIPTION_IDS must be a non-empty JSON array of { id, name } objects.'
    }

    $subscriptionIds = [System.Collections.Generic.HashSet[guid]]::new()
    $normalizedSubscriptions = @(
        foreach ($subscription in $subscriptions) {
            $subscriptionId = [guid]::Empty
            if ($subscription -isnot [pscustomobject] -or
                $subscription.id -isnot [string] -or
                $subscription.id -cne $subscription.id.Trim() -or
                -not [guid]::TryParseExact($subscription.id, 'D', [ref] $subscriptionId) -or
                $subscriptionId -eq [guid]::Empty) {
                throw 'Each TEST_BAMI_SUBSCRIPTION_IDS entry must be an object with an id containing a non-empty subscription GUID.'
            }
            if (-not $subscriptionIds.Add($subscriptionId)) {
                throw 'TEST_BAMI_SUBSCRIPTION_IDS must not contain duplicate subscription IDs.'
            }
            if ($subscription.name -isnot [string] -or
                [string]::IsNullOrWhiteSpace($subscription.name) -or
                $subscription.name -match '[\r\n]') {
                throw 'Each TEST_BAMI_SUBSCRIPTION_IDS entry must have a non-empty, single-line name.'
            }

            [pscustomobject]@{
                id   = $subscription.id
                name = $subscription.name
            }
        }
    )

    if ($PSBoundParameters.ContainsKey('RandomSeed')) {
        return $normalizedSubscriptions | Get-Random -Shuffle -SetSeed $RandomSeed
    }

    return $normalizedSubscriptions
}
