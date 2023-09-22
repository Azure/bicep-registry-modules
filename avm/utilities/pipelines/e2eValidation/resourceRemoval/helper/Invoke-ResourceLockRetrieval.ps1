<#
.SYNOPSIS
Gets resource locks on a resource or a specific resource lock.

.DESCRIPTION
Gets resource locks on a resource or a specific resource lock.

.PARAMETER ResourceId
Mandatory. The resourceID of the resource to check or the resource lock to check.

.PARAMETER Type
Optional. The type of the resource.
If the resource is a lock, the lock itself will be returned.
If the resource is not a lock, all locks on the resource will be returned.

.EXAMPLE
Invoke-ResourceLockRetrieval -ResourceId '/subscriptions/.../resourceGroups/validation-rg/.../resource-name'

Check if the resource 'resource-name' is locked. If it is, return the lock.

.EXAMPLE
Invoke-ResourceLockRetrieval -ResourceId '/subscriptions/.../resourceGroups/validation-rg/.../resource-name/providers/Microsoft.Authorization/locks/lock-name' -Type 'Microsoft.Authorization/locks'

Return the lock 'lock-name' on the resource 'resource-name'.

.NOTES
Needed as the AzPwsh cmdlet Get-AzResourceLock does not support getting a specific lock by LockId.
#>
function Invoke-ResourceLockRetrieval {
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceId,

        [Parameter(Mandatory = $false)]
        [string] $Type = ''
    )
    if ($Type -eq 'Microsoft.Authorization/locks') {
        $lockName = ($ResourceId -split '/')[-1]
        $lockScope = ($ResourceId -split '/providers/Microsoft.Authorization/locks')[0]
        return Get-AzResourceLock -LockName $lockName -Scope $lockScope -ErrorAction SilentlyContinue
    } else {
        return Get-AzResourceLock -Scope $ResourceId -ErrorAction SilentlyContinue
    }
}
