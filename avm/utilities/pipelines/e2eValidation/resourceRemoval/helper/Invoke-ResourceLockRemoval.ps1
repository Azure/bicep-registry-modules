<#
.SYNOPSIS
Remove resource locks from a resource or a specific resource lock.

.DESCRIPTION
Remove resource locks from a resource or a specific resource lock.

.PARAMETER ResourceId
Mandatory. The resourceID of the resource to check, and remove a resource lock from.

.PARAMETER Type
Optional. The type of the resource. If the resource is a lock, the lock itself will be removed. If the resource is a resource, all locks on the resource will be removed. If not specified, the resource will be checked for locks, and if any are found, all locks will be removed.

.PARAMETER RetryLimit
Optional. The number of times to retry checking if the lock is removed.

.PARAMETER RetryInterval
Optional. The number of seconds to wait between each retry.

.EXAMPLE
Invoke-ResourceLockRemoval -ResourceId '/subscriptions/.../resourceGroups/validation-rg/.../resource-name'

Check if the resource 'resource-name' is locked. If it is, remove the lock.
#>
function Invoke-ResourceLockRemoval {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceId,

        [Parameter(Mandatory = $false)]
        [string] $Type,

        [Parameter(Mandatory = $false)]
        [int] $RetryLimit = 10,

        [Parameter(Mandatory = $false)]
        [int] $RetryInterval = 10
    )
    # Load functions
    . (Join-Path $PSScriptRoot 'Invoke-ResourceLockRetrieval.ps1')

    $resourceLock = Invoke-ResourceLockRetrieval -ResourceId $ResourceId -Type $Type

    $isLocked = $resourceLock.count -gt 0
    if (-not $isLocked) {
        return
    }

    $resourceLock | ForEach-Object {
        Write-Warning ('    [-] Removing lock [{0}] on [{1}] of type [{2}].' -f $_.Name, $_.ResourceName, $_.ResourceType)
        if ($PSCmdlet.ShouldProcess(('Lock [{0}] on resource [{1}] of type [{2}].' -f $_.Name, $_.ResourceName, $_.ResourceType ), 'Remove')) {
            $null = $_ | Remove-AzResourceLock -Force
        }
    }

    $retryCount = 0
    do {
        $retryCount++
        if ($retryCount -ge $RetryLimit) {
            Write-Warning ('    [!] Lock was not removed after {1} seconds. Continuing with resource removal.' -f ($retryCount * $RetryInterval))
            break
        }
        Write-Verbose '    [⏱️] Waiting for lock to be removed.' -Verbose
        Start-Sleep -Seconds $RetryInterval

        # Rechecking the resource locks to see if they have been removed.
        $resourceLock = Invoke-ResourceLockRetrieval -ResourceId $ResourceId -Type $Type
        $isLocked = $resourceLock.count -gt 0
    } while ($isLocked)
    
    Write-Verbose ('    [-] [{0}] resource lock(s) removed.' -f $resourceLock.count) -Verbose
}
