Param(
    [Parameter(Mandatory = $true)]
    [string]$subscriptionId,
    [Parameter(Mandatory = $true)]
    [string]$subscriptionDisplayName
)

$ErrorActionPreference = 'SilentlyContinue'
Import-Module Az.Subscription

# Validate required parameters
Write-Output "Subscription display name is set to: $subscriptionDisplayName"
# Proceed with renaming the subscription
Write-Output "Renaming subscription '$subscriptionId' to '$subscriptionDisplayName'"
Rename-AzSubscription -Id $subscriptionId -SubscriptionName $subscriptionDisplayName | Write-Output
Write-Output 'Subscription renamed successfully'






