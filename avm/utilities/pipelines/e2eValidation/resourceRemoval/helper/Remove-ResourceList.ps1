#region helperScripts
<#
.SYNOPSIS
Remove the given resource(s)

.DESCRIPTION
Remove the given resource(s). Resources that the script fails to removed are returned in an array.

.PARAMETER ResourcesToRemove
Mandatory. The resource(s) to remove. Each resource must have a type & resourceId property.

.EXAMPLE
Remove-ResourceListInner -ResourcesToRemove @( @{ Type = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )
#>
function Remove-ResourceListInner {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [Hashtable[]] $ResourcesToRemove = @()
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load functions
        . (Join-Path $PSScriptRoot 'Invoke-ResourceRemoval.ps1')
        . (Join-Path $PSScriptRoot 'Invoke-ResourcePostRemoval.ps1')
    }

    process {
        $resourcesToRemove | ForEach-Object { Write-Verbose ('- Remove [{0}]' -f $_.resourceId) -Verbose }
        $resourcesToRetry = @()
        $processedResources = @()
        Write-Verbose '----------------------------------' -Verbose

        foreach ($resource in $resourcesToRemove) {
            $resourceName = Split-Path $resource.resourceId -Leaf
            $alreadyProcessed = $processedResources.count -gt 0 ? (($processedResources | Where-Object { $resource.resourceId -like ('{0}/*' -f $_) }).Count -gt 0) : $false

            if ($alreadyProcessed) {
                # Skipping
                Write-Verbose ('[/] Skipping resource [{0}] of type [{1}]. Reason: Its parent resource was already processed' -f $resourceName, $resource.type) -Verbose
                [array]$processedResources += $resource.resourceId
                [array]$resourcesToRetry = $resourcesToRetry | Where-Object { $_.resourceId -notmatch $resource.resourceId }
            } else {
                Write-Verbose ('[-] Removing resource [{0}] of type [{1}]' -f $resourceName, $resource.type) -Verbose
                try {
                    if ($PSCmdlet.ShouldProcess(('Resource [{0}]' -f $resource.resourceId), 'Remove')) {
                        Invoke-ResourceRemoval -Type $resource.type -ResourceId $resource.resourceId
                    }

                    # If we removed a parent remove its children
                    [array]$processedResources += $resource.resourceId
                    [array]$resourcesToRetry = $resourcesToRetry | Where-Object { $_.resourceId -notmatch $resource.resourceId }
                } catch {
                    if ($_.Exception.HttpStatus -in @(404, 'NotFound')) {
                        # Skipping because resource/parent is missing. This 'exception handling' can be required in case the parent resource removal ran into an issue, but was completed regardless
                        Write-Verbose ('[/] Skipping resource [{0}] of type [{1}]. Reason: It or its parent cannot be found.' -f $resourceName, $resource.type) -Verbose
                        [array]$processedResources += $resource.resourceId
                        [array]$resourcesToRetry = $resourcesToRetry | Where-Object { $_.resourceId -notmatch $resource.resourceId }
                    } else {
                        Write-Warning ('[!] Removal moved back for retry. Reason: [{0}]' -f $_.Exception.Message)
                        [array]$resourcesToRetry += $resource
                    }
                }
            }

            # We want to purge resources even if they were not explicitly removed because they were 'alreadyProcessed'
            if ($PSCmdlet.ShouldProcess(('Post-resource-removal for [{0}]' -f $resource.resourceId), 'Execute')) {
                Invoke-ResourcePostRemoval -Type $resource.type -ResourceId $resource.resourceId
            }
        }
        Write-Verbose '----------------------------------' -Verbose
        return $resourcesToRetry
    }
    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
#endregion

<#
.SYNOPSIS
Remove all resources in the provided array from Azure

.DESCRIPTION
Remove all resources in the provided array from Azure. Resources are removed with a retry mechanism.

.PARAMETER ResourcesToRemove
Optional. The array of resources to remove. Has to contain objects with at least a 'resourceId' & 'type' property

.EXAMPLE
Remove-ResourceList @( @{ Type = 'Microsoft.Storage/storageAccounts'; ResourceId = 'subscriptions/.../storageAccounts/resourceName' } )

Remove resource with ID 'subscriptions/.../storageAccounts/resourceName'.
#>
function Remove-ResourceList {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [PSObject[]] $ResourcesToRemove = @(),

        [Parameter(Mandatory = $false)]
        [int] $RemovalRetryLimit = 3,

        [Parameter(Mandatory = $false)]
        [int] $RemovalRetryInterval = 15
    )

    $removalRetryCount = 1
    $resourcesToRetry = $resourcesToRemove

    do {
        if ($PSCmdlet.ShouldProcess(("[{0}] Resource(s) with a maximum of [$removalRetryLimit] attempts." -f (($resourcesToRetry -is [array]) ? $resourcesToRetry.Count : 1)), 'Remove')) {
            $resourcesToRetry = Remove-ResourceListInner -ResourcesToRemove $resourcesToRetry
        } else {
            Remove-ResourceListInner -ResourcesToRemove $resourcesToRemove -WhatIf
        }

        if (-not $resourcesToRetry) {
            break
        }
        Write-Verbose ('Retry removal of remaining [{0}] resources. Waiting [{1}] seconds. Round [{2}|{3}]' -f (($resourcesToRetry -is [array]) ? $resourcesToRetry.Count : 1), $removalRetryInterval, $removalRetryCount, $removalRetryLimit)
        $removalRetryCount++
        Start-Sleep $removalRetryInterval
    } while ($removalRetryCount -le $removalRetryLimit)

    if ($resourcesToRetry.Count -gt 0) {
        throw ('The removal failed for resources [{0}]' -f ((Split-Path $resourcesToRetry.resourceId -Leaf) -join ', '))
    } else {
        Write-Verbose ('The removal of the [{0}] completed successfully' -f $ResourcesToRemove.Count)
    }
}
