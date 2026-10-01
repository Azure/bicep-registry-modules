<#
.SYNOPSIS
Validate and resolve the five BAMI test settings before Azure authentication or validation.

.DESCRIPTION
Reads only TEST_BAMI_* environment settings. Returns the tenant, Bicep client,
management group, persistent subscription and test subscription pool.

.PARAMETER RandomSeed
Optional shared seed for shuffling the test subscription pool.
#>
function Get-BamiTestConfiguration {

    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateRange(0, 2147483647)]
        [int] $RandomSeed
    )

    . (Join-Path $PSScriptRoot 'Get-TestSubscriptionList.ps1')

    $settings = [ordered]@{
        TEST_BAMI_TENANT_ID                  = $env:TEST_BAMI_TENANT_ID
        TEST_BAMI_BICEP_CLIENT_ID            = $env:TEST_BAMI_BICEP_CLIENT_ID
        TEST_BAMI_SUBSCRIPTION_IDS           = $env:TEST_BAMI_SUBSCRIPTION_IDS
        TEST_BAMI_MANAGEMENT_GROUP_ID        = $env:TEST_BAMI_MANAGEMENT_GROUP_ID
        TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID = $env:TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID
    }
    foreach ($name in $settings.Keys) {
        if ([string]::IsNullOrWhiteSpace($settings[$name])) {
            throw "Missing BAMI configuration for [$name]."
        }
    }
    foreach ($name in @('TEST_BAMI_TENANT_ID', 'TEST_BAMI_BICEP_CLIENT_ID', 'TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID')) {
        $id = [guid]::Empty
        if ($settings[$name] -cne $settings[$name].Trim() -or
            -not [guid]::TryParseExact($settings[$name], 'D', [ref] $id) -or
            $id -eq [guid]::Empty) {
            throw "Invalid BAMI configuration for [$name]: expected a non-empty GUID."
        }
    }
    if ($settings.TEST_BAMI_MANAGEMENT_GROUP_ID -cnotmatch '\A[a-zA-Z0-9_.()-]{1,90}\z') {
        throw 'Invalid BAMI configuration for [TEST_BAMI_MANAGEMENT_GROUP_ID]: expected a management group name of 1-90 letters, digits, hyphens, underscores, periods or parentheses.'
    }

    $subscriptionInput = @{
        TestSubscriptionIds = $settings.TEST_BAMI_SUBSCRIPTION_IDS
    }
    if ($PSBoundParameters.ContainsKey('RandomSeed')) {
        $subscriptionInput.RandomSeed = $RandomSeed
    }
    $subscriptions = @(Get-TestSubscriptionList @subscriptionInput)
    if ($subscriptions.id -contains $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID) {
        throw 'TEST_BAMI_SUBSCRIPTION_IDS must not include TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID.'
    }

    return [pscustomobject]@{
        TenantId                 = $settings.TEST_BAMI_TENANT_ID
        ClientId                 = $settings.TEST_BAMI_BICEP_CLIENT_ID
        ManagementGroupId        = $settings.TEST_BAMI_MANAGEMENT_GROUP_ID
        PersistentSubscriptionId = $settings.TEST_BAMI_PERSISTENT_SUBSCRIPTION_ID
        Subscriptions            = $subscriptions
    }
}
