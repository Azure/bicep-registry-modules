$ErrorActionPreference = 'Stop'
$env:DIAGNOSTIC_READ_ONLY = 'true'
& "$PSScriptRoot/verify-test-pool.ps1"

$registryId = '/subscriptions/0c46f267-ef68-463d-852a-bf8efb9217f4/resourceGroups/dep-m3y-devopsrunners-devminaci-rg/providers/Microsoft.ContainerRegistry/registries/acrm3ydevminacimi27ce2zniar4'
$pattern = '^/subscriptions/(?<subscription>[0-9a-fA-F-]{36})/resourceGroups/(?<group>[^/]+)/providers/Microsoft\.ContainerRegistry/registries/(?<registry>[a-zA-Z0-9]+)$'
if ($registryId -notmatch $pattern) { throw 'Invalid registry resource ID.' }
$subscription = $Matches.subscription
$group = $Matches.group
$registry = $Matches.registry
$pool = ConvertFrom-Json -InputObject $env:TEST_SUBSCRIPTION_IDS -AsHashtable -NoEnumerate
if (@($pool | Where-Object { $_.id -ieq $subscription }).Count -ne 1) {
    throw 'The registry subscription is not present in the verified test pool.'
}
$identities = ConvertFrom-Json -InputObject $env:MODULE_CLIENT_IDS -AsHashtable
$identity = [guid]::Empty
if (-not [guid]::TryParseExact([string]$identities['avm/ptn/dev-ops/cicd-agents-and-runners'], 'D', [ref]$identity) -or $identity -eq [guid]::Empty) {
    throw 'The module identity is unavailable.'
}
@(
    "subscriptionId=$subscription"
    "resourceGroup=$group"
    "registryName=$registry"
    "clientId=$identity"
) | Out-File -LiteralPath $env:GITHUB_OUTPUT -Append -Encoding utf8
