. (Join-Path $PSScriptRoot '..' '..' '..' 'sharedScripts' 'Get-DeploymentErrorKind.ps1')
. (Join-Path $PSScriptRoot '..' '..' 'resourceDeployment' 'New-TemplateDeployment.ps1')

#region helper
function Get-DeploymentResourceId {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('DeploymentName')]
        [string] $Name,
        [Parameter(Mandatory)]
        [ValidateSet('resourcegroup', 'subscription', 'managementgroup', 'tenant')]
        [string] $Scope,
        [string] $SubscriptionId,
        [string] $ResourceGroupName,
        [string] $ManagementGroupId
    )

    $prefix = switch ($Scope) {
        'resourcegroup' { "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName" }
        'subscription' { "/subscriptions/$SubscriptionId" }
        'managementgroup' { "/providers/Microsoft.Management/managementGroups/$ManagementGroupId" }
        'tenant' { '' }
    }
    return "$prefix/providers/Microsoft.Resources/deployments/$Name"
}

<#
.SYNOPSIS
Get all deployment operations at a given scope

.DESCRIPTION
Get all deployment operations at a given scope, following every operation page.
By default, results include only 'create' operations, excluding 'read' operations for existing resources.

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

.PARAMETER RequireCompleteRemoval
Optional. Require terminal operations and complete target IDs before authorizing relocation.

.PARAMETER ResolvedResourceIds
Optional. Preserve known create targets when a later operation page fails.

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
        [string] $Scope,

        [Parameter()]
        [switch] $RequireCompleteRemoval,

        [Parameter()]
        [System.Collections.Generic.List[string]] $ResolvedResourceIds
    )


    $resourceId = Get-DeploymentResourceId -Name $Name -Scope $Scope -SubscriptionId $SubscriptionId `
        -ResourceGroupName $ResourceGroupName -ManagementGroupId $ManagementGroupId
    $operationsPath = "$resourceId/operations"
    $path = "${operationsPath}?api-version=2021-04-01"

    ##############################################
    # Get all deployment children based on scope #
    ##############################################

    $deploymentOperations = @()
    $visitedPages = [System.Collections.Generic.HashSet[string]]::new()
    do {
        if (-not $visitedPages.Add($path) -or $visitedPages.Count -gt 1000) {
            throw "Deployment [$Name] returned repeated or excessive operation pages."
        }
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
            if (-not $RequireCompleteRemoval -and $Scope -eq 'resourcegroup' -and
                $response.StatusCode -eq 404 -and $content.error.code -eq 'ResourceGroupNotFound') {
                Write-Verbose "Resource group [$ResourceGroupName] no longer exists. No contained resources remain to remove." -Verbose
                return $true
            }
            throw ('Failed to fetch deployment operations for deployment [{0}] in scope [{1}]: HTTP [{2}], error [{3}].' -f $Name, $Scope, $response.StatusCode, $content.error.code)
        }
        if ($content.value -isnot [array]) {
            throw "Invalid deployment operations response for deployment [$Name] in scope [$Scope]."
        }
        foreach ($operation in $content.value) {
            $deploymentOperations += , $operation.properties
            $targetId = $operation.properties.targetResource.id
            if ($null -ne $ResolvedResourceIds -and $operation.properties.provisioningOperation -eq 'Create' -and
                -not [string]::IsNullOrWhiteSpace($targetId) -and $targetId -notmatch '/Microsoft\.Resources/deployments/') {
                $ResolvedResourceIds.Add($targetId)
            }
        }
        $path = $null
        if ($content.nextLink) {
            $endpoint = [uri] (Get-AzContext -ErrorAction Stop).Environment.ResourceManagerUrl
            $nextPage = [uri]::new($endpoint, [string] $content.nextLink)
            if ($nextPage.Scheme -ne 'https' -or $nextPage.Authority -ne $endpoint.Authority -or
                $nextPage.AbsolutePath -ine $operationsPath -or $nextPage.UserInfo -or $nextPage.Fragment) {
                throw "Deployment [$Name] returned an operation page outside its original scope."
            }
            $path = $nextPage.PathAndQuery
        }
    } while ($path)

    if ($RequireCompleteRemoval) {
        foreach ($operation in $deploymentOperations) {
            if ($operation.provisioningState -notin @('Succeeded', 'Failed') -or
                ($operation.provisioningOperation -eq 'Create' -and [string]::IsNullOrWhiteSpace($operation.targetResource.id))) {
                throw "Deployment [$Name] has an incomplete operation; cleanup cannot authorize regional relocation."
            }
        }
    }
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

.PARAMETER RequireCompleteRemoval
Optional. Require failed roots and terminal nested deployments; restore cross-subscription discovery context.

.PARAMETER ResolvedDeploymentIds
Optional. Accumulates deployment record IDs in child-before-parent order for strict removal.

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
        [System.Collections.Generic.List[string]] $ResolvedResourceIds = [System.Collections.Generic.List[string]]::new(),

        [Parameter()]
        [switch] $RequireCompleteRemoval,

        [Parameter()]
        [System.Collections.Generic.List[string]] $ResolvedDeploymentIds = [System.Collections.Generic.List[string]]::new()
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
        if ($RequireCompleteRemoval) {
            $state = Get-TemplateDeployment -DeploymentScope $Scope -DeploymentName $Name `
                -SubscriptionId $baseInputObject.SubscriptionId -ResourceGroupName $ResourceGroupName `
                -ManagementGroupId $ManagementGroupId -DefaultProfile $currentContext
            $allowedStates = $DoThrow ? @('Failed') : @('Succeeded', 'Failed')
            if ($state.ProvisioningState -notin $allowedStates) {
                throw "Deployment [$Name] is [$($state.ProvisioningState)]; cleanup cannot authorize regional relocation."
            }
        }
        $op = Get-DeploymentOperationAtScope @baseInputObject -RequireCompleteRemoval:$RequireCompleteRemoval -ResolvedResourceIds $ResolvedResourceIds
        [array] $deploymentTargets = $op.TargetResource.id | Where-Object { $_ -ne $null } | Select-Object -Unique
    } catch {
        if (-not $RequireCompleteRemoval -and -not $DoThrow -and $_.FullyQualifiedErrorId.Split(',')[0] -eq 'DeploymentNotFound' -and (Get-DeploymentErrorKind -ErrorRecord $_) -eq 'Other') {
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
        if (-not $ResolvedResourceIds.Contains($deployment)) {
            $ResolvedResourceIds.Add($deployment)
        }
    }

    #############################
    # Manage nested deployments #
    #############################
    foreach ($deployment in ($deploymentTargets | Where-Object { $_ -match '\/Microsoft\.Resources\/deployments\/' } )) {
        $name = Split-Path $deployment -Leaf
        $nestedInput = @{
            Name                   = $name
            ResolvedResourceIds    = $ResolvedResourceIds
            RequireCompleteRemoval = $RequireCompleteRemoval
            ResolvedDeploymentIds  = $ResolvedDeploymentIds
        }
        $restoreContext = $false
        $discoveryError = $null
        try {
            if ($deployment -match '/resourceGroups/') {
                # Resource Group Level Child Deployments #
                ##########################################
                if ($deployment -match '^\/subscriptions\/([0-9a-zA-Z-]+?)\/') {
                    $subscriptionId = $Matches[1]
                    if ($currentContext.Subscription.Id -ne $subscriptionId) {
                        $restoreContext = $RequireCompleteRemoval
                        $null = Set-AzContext -Subscription $subscriptionId -ErrorAction Stop
                    }
                }
                Write-Verbose ('Found [resource group] deployment [{0}]' -f $deployment)
                $nestedResourceGroup = [regex]::Match($deployment, '(?i)/resourceGroups/([^/]+)/').Groups[1].Value
                [array]$resultSet += Get-DeploymentTargetResourceListInner @nestedInput -Scope 'resourcegroup' -ResourceGroupName $nestedResourceGroup
            } elseif ($deployment -match '/subscriptions/') {
                # Subscription Level Child Deployments #
                ########################################
                if ($deployment -match '^\/subscriptions\/([0-9a-zA-Z-]+?)\/') {
                    $subscriptionId = $Matches[1]
                    if ($currentContext.Subscription.Id -ne $subscriptionId) {
                        $restoreContext = $RequireCompleteRemoval
                        $null = Set-AzContext -Subscription $subscriptionId -ErrorAction Stop
                    }
                }
                Write-Verbose ('Found [subscription] deployment [{0}]' -f $deployment)
                [array]$resultSet += Get-DeploymentTargetResourceListInner @nestedInput -Scope 'subscription'
            } elseif ($deployment -match '/managementgroups/') {
                # Management Group Level Child Deployments #
                ############################################
                Write-Verbose ('Found [management group] deployment [{0}]' -f $deployment)
                $nestedManagementGroup = [regex]::Match($deployment, '(?i)/managementGroups/([^/]+)/').Groups[1].Value
                [array]$resultSet += Get-DeploymentTargetResourceListInner @nestedInput -Scope 'managementgroup' -ManagementGroupId $nestedManagementGroup
            } else {
                # Tenant Level Child Deployments #
                ##################################
                Write-Verbose ('Found [tenant] deployment [{0}]' -f $deployment)
                [array]$resultSet += Get-DeploymentTargetResourceListInner @nestedInput -Scope 'tenant'
            }
        } catch {
            $discoveryError = $_
            throw
        } finally {
            if ($restoreContext) {
                try {
                    $null = Set-AzContext -Context $currentContext -ErrorAction Stop
                } catch {
                    if ($discoveryError -and (Get-DeploymentErrorKind -ErrorRecord $discoveryError) -eq 'Cancellation') {
                        Write-Warning "Azure context restoration also failed during cancellation: $($_.Exception.Message)"
                    } else {
                        throw
                    }
                }
            }
        }
    }

    if ($RequireCompleteRemoval) {
        $ResolvedDeploymentIds.Add((Get-DeploymentResourceId @baseInputObject))
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

.PARAMETER RequireCompleteRemoval
Optional. Require complete terminal-state discovery and collect deployment records for removal.
Only proven missing root preflight attempts may omit a record. Other missing or incomplete records block relocation.

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
        [int] $SearchRetryInterval = 60,

        [Parameter()]
        [switch] $RequireCompleteRemoval
    )

    if (@($PreflightRejectedDeploymentNames | Where-Object { $_ -notin $DeploymentNames }).Count -gt 0) {
        throw 'Preflight rejection metadata contains names outside the supplied deployments.'
    }
    $searchRetryCount = 1
    $resourcesToRemove = @()
    $resolvedDeploymentIds = [System.Collections.Generic.List[string]]::new()
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
                Name                   = $deploymentNameObject.Name
                Scope                  = $scope
                ResolvedResourceIds    = $resolvedResourceIds
                ErrorAction            = 'Stop'
                RequireCompleteRemoval = $RequireCompleteRemoval
                ResolvedDeploymentIds  = $resolvedDeploymentIds
            }
            if (-not [String]::IsNullOrEmpty($resourceGroupName)) {
                $innerInputObject['resourceGroupName'] = $resourceGroupName
            }
            if (-not [String]::IsNullOrEmpty($ManagementGroupId)) {
                $innerInputObject['ManagementGroupId'] = $ManagementGroupId
            }
            try {
                if ($RequireCompleteRemoval -and $deploymentNameObject.Name -in $PreflightRejectedDeploymentNames) {
                    $null = Get-DeploymentOperationAtScope -Name $deploymentNameObject.Name -Scope $Scope `
                        -SubscriptionId (Get-AzContext -ErrorAction Stop).Subscription.Id -ResourceGroupName $ResourceGroupName `
                        -ManagementGroupId $ManagementGroupId -RequireCompleteRemoval
                }
                $targetResources = Get-DeploymentTargetResourceListInner @innerInputObject -DoThrow # Specifying [-DoThrow] for top-level deployments that we definitely want to resolve
                Write-Verbose ('Found & resolved deployment [{0}]. [{1}] resources found to remove.' -f $deploymentNameObject.Name, $targetResources.Count) -Verbose
                $deploymentNameObject.Resolved = $true
            } catch {
                $errorKind = Get-DeploymentErrorKind -ErrorRecord $_
                if ($errorKind -eq 'Cancellation') {
                    throw
                }
                if ((-not $RequireCompleteRemoval -or $deploymentNameObject.Name -in $PreflightRejectedDeploymentNames) -and
                    $errorKind -eq 'Other' -and $_.FullyQualifiedErrorId.Split(',')[0] -eq 'DeploymentNotFound') {
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
            deploymentIds     = @($resolvedDeploymentIds | Select-Object -Unique)
        }
    }
    return @{
        resourcesToRemove = $resourcesToRemove
        deploymentIds     = @($resolvedDeploymentIds | Select-Object -Unique)
    }
}
