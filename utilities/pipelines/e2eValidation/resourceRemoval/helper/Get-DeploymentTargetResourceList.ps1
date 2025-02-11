#region helper
<#
.SYNOPSIS
Get all deployment operations at a given scope

.DESCRIPTION
Get all deployment oeprations at a given scope. By default, the results are filtered down to 'create' operations (i.e., excluding 'read' operations that would correspond to 'existing' resources).

.PARAMETER Name
Mandatory. The deployment name to search for

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourcegroup'. Relevant for resource-group-level deployments.

.PARAMETER SubscriptionId
Optional. The ID of the subscription to fetch deployments from. Relevant for subscription- & resource-group-level deployments.

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group-level deployments.

.PARAMETER Scope
Mandatory. The scope to search in

.PARAMETER ProvisioningOperationsToInclude
Optional. The provisioning operations to include in the result set. By default, only 'create' operations are included.

.EXAMPLE
Get-DeploymentOperationAtScope -Scope 'subscription' -Name 'v73rhp24d7jya-test-apvmiaiboaai'

Get all deployment operations for a deployment with name 'v73rhp24d7jya-test-apvmiaiboaai' at scope 'subscription'

.NOTES
This function is a standin for the Get-AzDeploymentOperation cmdlet, which does not provide the ability to filter by provisioning operation.
As such, it was also returning 'existing' resources (i.e., with provisioningOperation=Read).
#>
function Get-DeploymentOperationAtScope {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('DeploymentName')]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'Create', # any resource creation
            'Read', # E.g., 'existing' resources
            'EvaluateDeploymentOutput' # Nobody knows
        )]
        [string[]] $ProvisioningOperationsToInclude = @('Create'),

        [Parameter(Mandatory)]
        [ValidateSet(
            'resourcegroup',
            'subscription',
            'managementgroup',
            'tenant'
        )]
        [string] $Scope
    )


    switch ($Scope) {
        'resourcegroup' {
            $path = '/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.Resources/deployments/{2}/operations?api-version=2021-04-01' -f $SubscriptionId, $ResourceGroupName, $name
            break
        }
        'subscription' {
            $path = '/subscriptions/{0}/providers/Microsoft.Resources/deployments/{1}/operations?api-version=2021-04-01' -f $SubscriptionId, $name
            break
        }
        'managementgroup' {
            $path = '/providers/Microsoft.Management/managementGroups/{0}/providers/Microsoft.Resources/deployments/{1}/operations?api-version=2021-04-01' -f $ManagementGroupId, $name
            break
        }
        'tenant' {
            $path = '/providers/Microsoft.Resources/deployments/{0}/operations?api-version=2021-04-01' -f $name
            break
        }
    }

    ##############################################
    # Get all deployment children based on scope #
    ##############################################

    $response = Invoke-AzRestMethod -Method 'GET' -Path $path

    if ($response.StatusCode -ne 200) {
        Write-Error ('Failed to fetch deployment operations for deployment [{0}] in scope [{1}]' -f $name, $scope)
        return
    } else {
        $deploymentOperations = ($response.content | ConvertFrom-Json).value.properties
        $deploymentOperationsFiltered = $deploymentOperations | Where-Object { $_.provisioningOperation -in $ProvisioningOperationsToInclude }
        return $deploymentOperationsFiltered ?? $true # Returning true to indicate that the deployment was found, but did not contain any relevant operations
    }
}

<#
.SYNOPSIS
Get all deployments that match a given deployment name in a given scope

.DESCRIPTION
Get all deployments that match a given deployment name in a given scope. Works recursively through the deployment tree.

.PARAMETER Name
Mandatory. The deployment name to search for

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourcegroup'

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.PARAMETER Scope
Mandatory. The scope to search in

.PARAMETER DoThrow
Optional. Throw an exception if a deployment cannot be found. If not set, a warning is returned instead.

.EXAMPLE
Get-DeploymentTargetResourceListInner -Name 'keyvault-12356' -Scope 'resourcegroup'

Get all deployments that match name 'keyvault-12356' in scope 'resourcegroup'

.EXAMPLE
Get-ResourceIdsOfDeploymentInner -Name 'mgmtGroup-12356' -Scope 'managementGroup' -ManagementGroupId 'af760cf5-3c9e-4804-a59a-a51741daa350'

Get all deployments that match name 'mgmtGroup-12356' in scope 'managementGroup'

.NOTES
Works after the principal:
- Find all deployments for the given deployment name
- If any of them are not a deployments, add their target resource to the result set (as they are e.g. a resource)
- If any of them is are deployments, recursively invoke this function for them to get their contained target resources
#>
function Get-DeploymentTargetResourceListInner {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory)]
        [ValidateSet(
            'resourcegroup',
            'subscription',
            'managementgroup',
            'tenant'
        )]
        [string] $Scope,

        [Parameter(Mandatory = $false)]
        [switch] $DoThrow
    )

    $resultSet = [System.Collections.ArrayList]@()
    $currentContext = Get-AzContext

    ##############################################
    # Get all deployment children based on scope #
    ##############################################
    $baseInputObject = @{
        Scope          = $Scope
        DeploymentName = $Name
    }
    switch ($Scope) {
        'resourcegroup' {
            if (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction 'SilentlyContinue') {
                if ($op = Get-DeploymentOperationAtScope @baseInputObject -ResourceGroupName $resourceGroupName -SubscriptionId $currentContext.Subscription.Id) {
                    [array]$deploymentTargets = $op.TargetResource.id | Where-Object { $_ -ne $null } | Select-Object -Unique
                } else {
                    $message = "Not found deployment [$Name] in scope [$Scope] of Resource Group [$ResourceGroupName]."
                    if ($DoThrow) {
                        throw $message
                    } else {
                        Write-Warning "$message Ignoring, as nested deployment."
                        return
                    }
                }
            } else {
                # In case the resource group itself was already deleted, there is no need to try and fetch deployments from it
                # In case we already have any such resources in the list, we should remove them
                return $resultSet | Where-Object { $_ -notmatch "\/resourceGroups\/$resourceGroupName\/" } | Select-Object -Unique
            }
            break
        }
        'subscription' {
            if ($op = Get-DeploymentOperationAtScope @baseInputObject -SubscriptionId $currentContext.Subscription.Id) {
                [array]$deploymentTargets = $op.TargetResource.id | Where-Object { $_ -ne $null } | Select-Object -Unique
            } else {
                $message = "Not found deployment [$Name] in scope [$Scope]."
                if ($DoThrow) {
                    throw $message
                } else {
                    Write-Warning "$message Ignoring, as nested deployment."
                    return
                }
            }
            break
        }
        'managementgroup' {
            if ($op = Get-DeploymentOperationAtScope @baseInputObject -ManagementGroupId $ManagementGroupId) {
                [array]$deploymentTargets = $op.TargetResource.id | Where-Object { $_ -ne $null } | Select-Object -Unique
            } else {
                $message = "Not found deployment [$Name] in scope [$Scope]."
                if ($DoThrow) {
                    throw $message
                } else {
                    Write-Warning "$message Ignoring, as nested deployment."
                    return
                }
            }
            break
        }
        'tenant' {
            if ($op = Get-DeploymentOperationAtScope @baseInputObject) {
                [array]$deploymentTargets = $op.TargetResource.id | Where-Object { $_ -ne $null } | Select-Object -Unique
            } else {
                $message = "Not found deployment [$Name] in scope [$Scope]."
                if ($DoThrow) {
                    throw $message
                } else {
                    Write-Warning "$message Ignoring, as nested deployment."
                    return
                }
            }
            break
        }
    }

    ###########################
    # Manage nested resources #
    ###########################
    foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '\/Microsoft\.Resources\/deployments\/' } )) {
        Write-Verbose ('Found deployed resource [{0}]' -f $deployment)
        [array]$resultSet += $deployment
    }

    #############################
    # Manage nested deployments #
    #############################
    foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '\/Microsoft\.Resources\/deployments\/' } )) {
        $name = Split-Path $deployment -Leaf
        if ($deployment -match '/resourceGroups/') {
            # Resource Group Level Child Deployments #
            ##########################################
            if ($deployment -match '^\/subscriptions\/([0-9a-zA-Z-]+?)\/') {
                $subscriptionId = $Matches[1]
                if ($currentContext.Subscription.Id -ne $subscriptionId) {
                    $null = Set-AzContext -Subscription $subscriptionId
                }
            }
            Write-Verbose ('Found [resource group] deployment [{0}]' -f $deployment)
            $resourceGroupName = $deployment.split('/resourceGroups/')[1].Split('/')[0]
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'resourcegroup' -ResourceGroupName $ResourceGroupName
        } elseif ($deployment -match '/subscriptions/') {
            # Subscription Level Child Deployments #
            ########################################
            if ($deployment -match '^\/subscriptions\/([0-9a-zA-Z-]+?)\/') {
                $subscriptionId = $Matches[1]
                if ($currentContext.Subscription.Id -ne $subscriptionId) {
                    $null = Set-AzContext -Subscription $subscriptionId
                }
            }
            Write-Verbose ('Found [subscription] deployment [{0}]' -f $deployment)
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'subscription'
        } elseif ($deployment -match '/managementgroups/') {
            # Management Group Level Child Deployments #
            ############################################
            Write-Verbose ('Found [management group] deployment [{0}]' -f $deployment)
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'managementgroup' -ManagementGroupId $ManagementGroupId
        } else {
            # Tenant Level Child Deployments #
            ##################################
            Write-Verbose ('Found [tenant] deployment [{0}]' -f $deployment)
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'tenant'
        }
    }

    return $resultSet | Select-Object -Unique
}
#endregion

<#
.SYNOPSIS
Get all deployments that match a given deployment name in a given scope using a retry mechanic

.DESCRIPTION
Get all deployments that match a given deployment name in a given scope using a retry mechanic.

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourcegroup'

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.PARAMETER Name
Optional. The deployment name to use for the removal

.PARAMETER Scope
Mandatory. The scope to search in

.PARAMETER SearchRetryLimit
Optional. The maximum times to retry the search for resources via their removal tag

.PARAMETER SearchRetryInterval
Optional. The time to wait in between the search for resources via their remove tags

.EXAMPLE
Get-DeploymentTargetResourceList -name 'KeyVault' -ResourceGroupName 'validation-rg' -scope 'resourcegroup'

Get all deployments that match name 'KeyVault' in scope 'resourcegroup' of resource group 'validation-rg'

.EXAMPLE
Get-ResourceIdsOfDeployment -Name 'mgmtGroup-12356' -Scope 'managementGroup' -ManagementGroupId 'af760cf5-3c9e-4804-a59a-a51741daa350'

Get all deployments that match name 'mgmtGroup-12356' in scope 'managementGroup'

#>
function Get-DeploymentTargetResourceList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $true)]
        [Alias('Name', 'Names', 'DeploymentName')]
        [string[]] $DeploymentNames,

        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'resourcegroup',
            'subscription',
            'managementgroup',
            'tenant'
        )]
        [string] $Scope,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [int] $SearchRetryInterval = 60
    )

    $searchRetryCount = 1
    $resourcesToRemove = @()
    $deploymentNameObjects = $DeploymentNames | ForEach-Object {
        @{
            Name     = $_
            Resolved = $false
        }
    }

    do {
        foreach ($deploymentNameObject in $deploymentNameObjects) {

            if ($deploymentNameObject.Resolved) {
                # Skip further invocations for this deployment name if deployment was already found
                continue
            }

            $innerInputObject = @{
                Name        = $deploymentNameObject.Name
                Scope       = $scope
                ErrorAction = 'SilentlyContinue'
            }
            if (-not [String]::IsNullOrEmpty($resourceGroupName)) {
                $innerInputObject['resourceGroupName'] = $resourceGroupName
            }
            if (-not [String]::IsNullOrEmpty($ManagementGroupId)) {
                $innerInputObject['ManagementGroupId'] = $ManagementGroupId
            }
            try {
                $targetResources = Get-DeploymentTargetResourceListInner @innerInputObject -DoThrow # Specifying [-DoThrow] for top-level deployments that we definitely want to resolve
                Write-Verbose ('Found & resolved deployment [{0}]. [{1}] resources found to remove.' -f $deploymentNameObject.Name, $targetResources.Count) -Verbose
                $deploymentNameObject.Resolved = $true
                $resourcesToRemove += $targetResources
            } catch {
                $remainingDeploymentNames = ($deploymentNameObjects | Where-Object { -not $_.Resolved }).Name
                Write-Verbose ('No deployment found by name(s) [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f ($remainingDeploymentNames -join ', '), $scope, $searchRetryInterval, $searchRetryCount, $searchRetryLimit) -Verbose
                Start-Sleep $searchRetryInterval
                $searchRetryCount++
            }
        }

        # Break check
        if ($deploymentNameObjects.Resolved -notcontains $false) {
            break
        }
    } while ($searchRetryCount -le $searchRetryLimit)

    if ($searchRetryCount -gt $searchRetryLimit) {
        $remainingDeploymentNames = ($deploymentNameObjects | Where-Object { -not $_.Resolved }).Name

        # We don't want to outright throw an exception as we want to remove as many resources as possible before failing the script in the calling function
        return @{
            resolveError      = ('No deployment for the deployment name(s) [{0}] found' -f ($remainingDeploymentNames -join ', '))
            resourcesToRemove = $resourcesToRemove
        }
    }
    return @{
        resourcesToRemove = $resourcesToRemove
    }
}
