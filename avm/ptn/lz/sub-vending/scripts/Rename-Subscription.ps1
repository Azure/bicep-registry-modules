Param(
    [Parameter(Mandatory = $true)]
    [string]$subscriptionId,
    [Parameter(Mandatory = $true)]
    [string]$subscriptionDisplayName
)

Write-Output 'Installing Az.Subscription module if not already installed'
Install-Module Az.Subscription -Force
Write-Output 'Az.Subscription module installed successfully'
Write-Output 'Importing Az.Subscription module'
Import-Module Az.Subscription
Write-Output 'Az.Subscription module imported successfully'

# Validate required parameters
Write-Output "Subscription display name is set to: $subscriptionDisplayName"
# Proceed with renaming the subscription
Write-Output "Renaming subscription '$subscriptionId' to '$subscriptionDisplayName'"
Rename-AzSubscription -Id $subscriptionId -SubscriptionName $subscriptionDisplayName | Write-Output
Write-Output 'Subscription renamed successfully'
