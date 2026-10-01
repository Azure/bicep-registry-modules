<#
.SYNOPSIS
Resolve the test subscription pool and optionally shuffle it.

.DESCRIPTION
TEST_SUBSCRIPTION_IDS uses a JSON array of { id, name } objects. An unset variable
retains the legacy validation subscription as a singleton pool. A shared random
seed reproduces the same shuffled order across deployment matrix jobs.
#>
function Get-TestSubscriptionList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $TestSubscriptionIds,

        [Parameter()]
        [string] $FallbackSubscriptionId,

        [Parameter()]
        [ValidateRange(0, 2147483647)]
        [int] $RandomSeed
    )

    if ([string]::IsNullOrWhiteSpace($TestSubscriptionIds)) {
        if ([string]::IsNullOrWhiteSpace($FallbackSubscriptionId)) {
            throw 'No test subscriptions configured. Set the TEST_SUBSCRIPTION_IDS variable to a JSON array of { id, name } objects or set the VALIDATE_SUBSCRIPTION_ID secret.'
        }

        Write-Verbose 'TEST_SUBSCRIPTION_IDS is unset; using VALIDATE_SUBSCRIPTION_ID as a single-subscription pool.'
        $subscriptions = @([pscustomobject]@{
                id   = $FallbackSubscriptionId
                name = $FallbackSubscriptionId
            })
    } else {
        $subscriptions = ConvertFrom-Json -InputObject $TestSubscriptionIds -NoEnumerate -ErrorAction Stop
        if ($subscriptions -isnot [array] -or $subscriptions.Count -eq 0) {
            throw 'TEST_SUBSCRIPTION_IDS must be a non-empty JSON array of { id, name } objects.'
        }
    }

    $normalizedSubscriptions = @(
        foreach ($subscription in $subscriptions) {
            $subscriptionId = [guid]::Empty
            if ($subscription -isnot [pscustomobject] -or
                $subscription.id -isnot [string] -or
                -not [guid]::TryParseExact($subscription.id, 'D', [ref] $subscriptionId)) {
                throw 'Each test subscription must be an object with an id containing a subscription GUID.'
            }
            if ($subscription.name -isnot [string] -or
                [string]::IsNullOrWhiteSpace($subscription.name) -or
                $subscription.name -match '[\r\n]') {
                throw 'Each test subscription must have a non-empty, single-line name.'
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
