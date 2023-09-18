﻿<#
.SYNOPSIS
Order the given resources as per the provided ordered resource type list

.DESCRIPTION
Order the given resources as per the provided ordered resource type list.
Any resources not in that list will be appended after.

.PARAMETER ResourcesToOrder
Mandatory. The resources to order. Items are stacked as per their order in the list (i.e. the first items is put on top, then the next, etc.)
Each item should be in format:
@{
    name        = '...'
    resourceID = '...'
    type        = '...'
}

.PARAMETER Order
Optional. The order of resource types to apply for deletion. If order is provided, the list is returned as is

.EXAMPLE
Get-OrderedResourcesList -ResourcesToOrder @(@{ name = 'myAccount'; resourceId '(..)/Microsoft.Automation/automationAccounts/myAccount'; type = 'Microsoft.Automation/automationAccounts'}) -Order @('Microsoft.Insights/diagnosticSettings','Microsoft.Automation/automationAccounts')

Order the given list of resources which would put the diagnostic settings to the front of the list, then the automation account, then the rest. As only one item exists, the list is returned as is.
#>
function Get-OrderedResourcesList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable[]] $ResourcesToOrder,

        [Parameter(Mandatory = $false)]
        [string[]] $Order = @()
    )

    # Going from back to front of the list to stack in the correct order
    for ($orderIndex = ($order.Count - 1); $orderIndex -ge 0; $orderIndex--) {
        $searchItem = $order[$orderIndex]
        if ($elementsContained = $resourcesToOrder | Where-Object { $_.type -eq $searchItem }) {
            $resourcesToOrder = @() + $elementsContained + ($resourcesToOrder | Where-Object { $_.type -ne $searchItem })
        }
    }

    return $resourcesToOrder
}
