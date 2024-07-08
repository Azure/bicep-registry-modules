<#
.SYNOPSIS
Returns a registration token to a host pool that is valid for 24h.

.DESCRIPTION
Returns a registration token to a host pool that is valid for 24h.

.PARAMETER HostPoolName
Mandatory. The name of the host pool.

.PARAMETER HostPoolResourceGroupName
Mandatory. The name of the resource group fo the host pool.

.PARAMETER SubscriptionId
Mandatory. The subscription ID wher the host pool resides.

.EXAMPLE
./Get-HostPoolRegistrationKey.ps1 -HostPoolName 'hp-01' -HostPoolResourceGroupName 'rg-01' -SubscriptionId '00000000-0000-0000-0000-000000000000'

Output will be '<tokenValue>'.
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $HostPoolName,

    [Parameter(Mandatory = $true)]
    [string] $HostPoolResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string] $SubscriptionId
)

if ($null -eq (Get-InstalledModule -Name 'Az.DesktopVirtualization' -ErrorAction 'SilentlyContinue')) {
    Install-Module Az.DesktopVirtualization -Force -AllowClobber
}

$parameters = @{
    HostPoolName      = $HostPoolName
    ResourceGroupName = $HostPoolResourceGroupName
    SubscriptionId    = $SubscriptionId
    ExpirationTime    = $((Get-Date).ToUniversalTime().AddHours(24).ToString('yyyy-MM-ddTHH:mm:ss.fffffffZ'))
}

$registrationKey = New-AzWvdRegistrationInfo @parameters

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    registrationInfoToken = $registrationKey.Token
}
