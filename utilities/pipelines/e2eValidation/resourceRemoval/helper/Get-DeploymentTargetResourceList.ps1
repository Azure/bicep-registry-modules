. (Join-Path $PSScriptRoot '..' '..' '..' 'sharedScripts' 'Get-DeploymentErrorKind.ps1')

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

    $response = Invoke-AzRestMethod -Method 'GET' -Path $path -ErrorAction Stop
    $content = $response.Content | ConvertFrom-Json -ErrorAction Stop

    if ($response.StatusCode -ne 200) {
        if ($response.StatusCode -eq 404 -and $content.error.code -eq 'DeploymentNotFound') {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException]::new("Deployment [$Name] was not found in scope [$Scope]."),
                    'DeploymentNotFound',
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                    $Name
                ))
        }
        if ($Scope -eq 'resourcegroup' -and $response.StatusCode -eq 404 -and $content.error.code -eq 'ResourceGroupNotFound') {
            Write-Verbose "Resource group [$ResourceGroupName] no longer exists. No contained resources remain to remove." -Verbose
            return $true
        }
        throw ('Failed to fetch deployment operations for deployment [{0}] in scope [{1}]: HTTP [{2}], error [{3}].' -f $Name, $Scope, $response.StatusCode, $content.error.code)
    }
    if ($content.value -isnot [array]) {
        throw "Invalid deployment operations response for deployment [$Name] in scope [$Scope]."
    }
    $deploymentOperations = $content.value.properties
    $deploymentOperationsFiltered = $deploymentOperations | Where-Object { $_.provisioningOperation -in $ProvisioningOperationsToInclude }
    return $deploymentOperationsFiltered ?? $true # Returning true to indicate that the deployment was found, but did not contain any relevant operations
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

.PARAMETER ResolvedResourceIds
Optional. Accumulates known resource IDs so a later nested lookup failure cannot discard already discovered cleanup targets.

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
        [switch] $DoThrow,

        [Parameter(Mandatory = $false)]
        [System.Collections.Generic.List[string]] $ResolvedResourceIds = [System.Collections.Generic.List[string]]::new()
    )

    $resultSet = [System.Collections.ArrayList]@()
    $currentContext = Get-AzContext -ErrorAction Stop

    ##############################################
    # Get all deployment children based on scope #
    ##############################################
    $baseInputObject = @{
        Scope          = $Scope
        DeploymentName = $Name
    }
    switch ($Scope) {
        'resourcegroup' {
            $baseInputObject.ResourceGroupName = $ResourceGroupName
            $baseInputObject.SubscriptionId = $currentContext.Subscription.Id
            break
        }
        'subscription' {
            $baseInputObject.SubscriptionId = $currentContext.Subscription.Id
            break
        }
        'managementgroup' {
            $baseInputObject.ManagementGroupId = $ManagementGroupId
            break
        }
    }
    try {
        $op = Get-DeploymentOperationAtScope @baseInputObject
        [array] $deploymentTargets = $op.TargetResource.id | Where-Object { $_ -ne $null } | Select-Object -Unique
    } catch {
        if (-not $DoThrow -and $_.FullyQualifiedErrorId.Split(',')[0] -eq 'DeploymentNotFound' -and (Get-DeploymentErrorKind -ErrorRecord $_) -eq 'Other') {
            Write-Warning "Deployment [$Name] was not found in scope [$Scope]. Ignoring, as nested deployment."
            return
        }
        throw
    }

    ###########################
    # Manage nested resources #
    ###########################
    foreach ($deployment in ($deploymentTargets | Where-Object { $_ -notmatch '\/Microsoft\.Resources\/deployments\/' } )) {
        Write-Verbose ('Found deployed resource [{0}]' -f $deployment)
        [array]$resultSet += $deployment
        $ResolvedResourceIds.Add($deployment)
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
                    $null = Set-AzContext -Subscription $subscriptionId -ErrorAction Stop
                }
            }
            Write-Verbose ('Found [resource group] deployment [{0}]' -f $deployment)
            $resourceGroupName = $deployment.split('/resourceGroups/')[1].Split('/')[0]
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'resourcegroup' -ResourceGroupName $ResourceGroupName -ResolvedResourceIds $ResolvedResourceIds
        } elseif ($deployment -match '/subscriptions/') {
            # Subscription Level Child Deployments #
            ########################################
            if ($deployment -match '^\/subscriptions\/([0-9a-zA-Z-]+?)\/') {
                $subscriptionId = $Matches[1]
                if ($currentContext.Subscription.Id -ne $subscriptionId) {
                    $null = Set-AzContext -Subscription $subscriptionId -ErrorAction Stop
                }
            }
            Write-Verbose ('Found [subscription] deployment [{0}]' -f $deployment)
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'subscription' -ResolvedResourceIds $ResolvedResourceIds
        } elseif ($deployment -match '/managementgroups/') {
            # Management Group Level Child Deployments #
            ############################################
            Write-Verbose ('Found [management group] deployment [{0}]' -f $deployment)
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'managementgroup' -ManagementGroupId $ManagementGroupId -ResolvedResourceIds $ResolvedResourceIds
        } else {
            # Tenant Level Child Deployments #
            ##################################
            Write-Verbose ('Found [tenant] deployment [{0}]' -f $deployment)
            [array]$resultSet += Get-DeploymentTargetResourceListInner -Name $name -Scope 'tenant' -ResolvedResourceIds $ResolvedResourceIds
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
Only DeploymentNotFound is retried. A preflight-rejected attempt with that response is known not to have been created.
Other lookup failures, including request timeouts, retain known resources for cleanup before reporting the error.
Genuine cancellation propagates without further discovery or removal.

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourcegroup'

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.PARAMETER Name
Optional. The deployment name to use for the removal

.PARAMETER PreflightRejectedDeploymentNames
Optional. Subset of DeploymentNames rejected by preflight validation. Existing records are always resolved normally.

.PARAMETER Scope
Mandatory. The scope to search in

.PARAMETER SearchRetryLimit
Optional. Maximum discovery rounds for required deployment records. Defaults to 40.

.PARAMETER SearchRetryInterval
Optional. Seconds between discovery rounds. Defaults to 60.

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

        [Parameter(Mandatory = $false)]
        [string[]] $PreflightRejectedDeploymentNames = @(),

        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'resourcegroup',
            'subscription',
            'managementgroup',
            'tenant'
        )]
        [string] $Scope,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 2147483647)]
        [int] $SearchRetryLimit = 40,

        [Parameter(Mandatory = $false)]
        [ValidateRange(0, 2147483647)]
        [int] $SearchRetryInterval = 60
    )

    if (@($PreflightRejectedDeploymentNames | Where-Object { $_ -notin $DeploymentNames }).Count -gt 0) {
        throw 'Preflight rejection metadata contains names outside the supplied deployments.'
    }
    $searchRetryCount = 1
    $resourcesToRemove = @()
    $deploymentNameObjects = $DeploymentNames | ForEach-Object {
        @{
            Name         = $_
            Resolved     = $false
            ResolveError = $null
        }
    }

    do {
        foreach ($deploymentNameObject in $deploymentNameObjects) {

            if ($deploymentNameObject.Resolved -or $deploymentNameObject.ResolveError) {
                continue
            }

            $resolvedResourceIds = [System.Collections.Generic.List[string]]::new()
            $innerInputObject = @{
                Name                = $deploymentNameObject.Name
                Scope               = $scope
                ResolvedResourceIds = $resolvedResourceIds
                ErrorAction         = 'Stop'
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
            } catch {
                $errorKind = Get-DeploymentErrorKind -ErrorRecord $_
                if ($errorKind -eq 'Cancellation') {
                    throw
                }
                if ($errorKind -eq 'Other' -and $_.FullyQualifiedErrorId.Split(',')[0] -eq 'DeploymentNotFound') {
                    if ($deploymentNameObject.Name -in $PreflightRejectedDeploymentNames) {
                        Write-Verbose "Confirmed no deployment record for preflight-rejected attempt [$($deploymentNameObject.Name)]. No lookup retry is needed." -Verbose
                        $deploymentNameObject.Resolved = $true
                    }
                } else {
                    $deploymentNameObject.ResolveError = 'Lookup for deployment [{0}] failed: {1}' -f $deploymentNameObject.Name, $_.Exception.Message
                    Write-Warning "Lookup for deployment [$($deploymentNameObject.Name)] failed. Resources from other attempts will still be cleaned before reporting the error."
                }
            }
            $resourcesToRemove += @($resolvedResourceIds)
        }

        $pendingDeployments = @($deploymentNameObjects | Where-Object { -not $_.Resolved -and -not $_.ResolveError })
        if ($pendingDeployments.Count -eq 0 -or $searchRetryCount -ge $SearchRetryLimit) {
            break
        }
        Write-Verbose ('No deployment found by name(s) [{0}] in scope [{1}]. Retrying in [{2}] seconds [{3}/{4}]' -f ($pendingDeployments.Name -join ', '), $Scope, $SearchRetryInterval, $searchRetryCount, $SearchRetryLimit) -Verbose
        Start-Sleep -Seconds $SearchRetryInterval
        $searchRetryCount++
    } while ($searchRetryCount -le $searchRetryLimit)

    $resolveErrors = @($deploymentNameObjects.ResolveError | Where-Object { $_ })
    if ($pendingDeployments.Count -gt 0) {
        $resolveErrors += 'No deployment for the deployment name(s) [{0}] found' -f ($pendingDeployments.Name -join ', ')
    }

    if ($resolveErrors.Count -gt 0) {
        # We don't want to outright throw an exception as we want to remove as many resources as possible before failing the script in the calling function
        return @{
            resolveError      = $resolveErrors -join '; '
            resourcesToRemove = $resourcesToRemove
        }
    }
    return @{
        resourcesToRemove = $resourcesToRemove
    }
}
