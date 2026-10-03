function Test-CleanupResourceAbsent {
    [CmdletBinding()]
    [OutputType([bool])]
    param ([Parameter(Mandatory)] [string] $ResourceId)

    $isGroup = $ResourceId -match '^/subscriptions/[^/]+/resourceGroups/[^/]+$'
    $isDeployment = $ResourceId -match '/providers/Microsoft\.Resources/deployments/[^/]+$'
    if ($isGroup -or $isDeployment) {
        $response = Invoke-AzRestMethod -Method GET -Path "${ResourceId}?api-version=2021-04-01" -ErrorAction Stop
        $content = ConvertFrom-Json -InputObject $response.Content -ErrorAction Stop
        $absentCodes = $isGroup ? @('ResourceGroupNotFound') : @('DeploymentNotFound')
        if ($isDeployment -and $ResourceId -match '/resourceGroups/') {
            $absentCodes += 'ResourceGroupNotFound'
        }
        if ($response.StatusCode -eq 404 -and $content.error.code -in $absentCodes) {
            return $true
        }
        if ($response.StatusCode -eq 200 -and $content.id -ieq $ResourceId) {
            return $false
        }
        throw "Cannot confirm removal of [$ResourceId]: HTTP [$($response.StatusCode)], error [$($content.error.code)]."
    }

    try {
        $resources = @(Get-AzResource -ResourceId $ResourceId -ErrorAction Stop)
    } catch {
        $record = $_
        $status = $record.Exception.Response.StatusCode ?? $record.Exception.HttpStatus
        $code = $record.Exception.Body.Code ?? $record.Exception.Error.Code
        if (-not $code -and $record.ErrorDetails.Message) {
            try {
                $body = ConvertFrom-Json -InputObject $record.ErrorDetails.Message -ErrorAction Stop
                $code = $body.error.code ?? $body.code
            } catch {
                throw $record
            }
        }
        if ((Get-DeploymentErrorKind -ErrorRecord $record) -eq 'Other' -and $status -in @(404, 'NotFound') -and
            $code -in @('ResourceNotFound', 'ResourceGroupNotFound', 'ParentResourceNotFound')) {
            return $true
        }
        throw $record
    }
    if ($resources.Count -eq 1 -and $resources[0].ResourceId -ieq $ResourceId) {
        return $false
    }
    throw "Resource lookup did not confirm either the presence or removal of [$ResourceId]."
}

function Complete-DeploymentRemoval {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string[]] $ResourceIds = @(),
        [string[]] $DeploymentIds = @(),
        [hashtable] $DeploymentNamesById = @{}
    )

    $removedNames = [System.Collections.Generic.List[string]]::new()
    try {
        $absentParents = [System.Collections.Generic.List[string]]::new()
        foreach ($resourceId in ($ResourceIds | Sort-Object -Unique | Sort-Object -Property Length)) {
            if (@($absentParents | Where-Object { $resourceId.StartsWith("$_/", [System.StringComparison]::OrdinalIgnoreCase) }).Count -gt 0) {
                continue
            }
            if (-not (Test-CleanupResourceAbsent -ResourceId $resourceId)) {
                throw "Resource [$resourceId] still exists after cleanup; regional relocation is blocked."
            }
            $absentParents.Add($resourceId)
        }
        foreach ($deploymentId in $DeploymentIds) {
            $parentAbsent = @($absentParents | Where-Object { $deploymentId.StartsWith("$_/", [System.StringComparison]::OrdinalIgnoreCase) }).Count -gt 0
            if (-not $parentAbsent) {
                if (-not $PSCmdlet.ShouldProcess($deploymentId, 'Remove completed deployment record')) {
                    throw 'Deployment record removal was not performed; regional relocation is blocked.'
                }
                $response = Invoke-AzRestMethod -Method DELETE -Path "${deploymentId}?api-version=2021-04-01" -ErrorAction Stop
                if ($response.StatusCode -notin @(200, 202, 204)) {
                    throw "Deployment record removal failed for [$deploymentId]: HTTP [$($response.StatusCode)]."
                }
                if (-not (Test-CleanupResourceAbsent -ResourceId $deploymentId)) {
                    throw "Deployment record [$deploymentId] still exists after cleanup; regional relocation is blocked."
                }
            }
            if ($DeploymentNamesById.ContainsKey($deploymentId)) {
                $removedNames.Add($DeploymentNamesById[$deploymentId])
            }
        }
    } catch {
        if ($removedNames.Count -gt 0) {
            $_.Exception.Data['RemovedDeploymentNames'] = @($removedNames)
        }
        throw
    }
}

<#
.SYNOPSIS
Invoke the removal of a deployed module

.DESCRIPTION
Invoke the removal of a deployed module.
Requires the resource in question to be tagged with 'removeModule = <moduleName>'

.PARAMETER ModuleName
Mandatory. The name of the module to remove

.PARAMETER ResourceGroupName
Optional. The resource group of the resource to remove

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.PARAMETER DeploymentName(s)
Optional. The name(s) of the deployment(s). Combined with resources provide via the resource Id(s).

.PARAMETER PreflightRejectedDeploymentNames
Optional. Attempt names rejected by preflight validation. Real deployment records are still resolved and cleaned.

.PARAMETER ResourceId(s)
Optional. The resource Id(s) of the resources to remove. Combined with resources found via the deployment name(s).

.PARAMETER TemplateFilePath
Optional. The path to the template used for the deployment(s). Used to determine the level/scope (e.g. subscription). Required if deploymentName(s) are provided.

.PARAMETER RemoveFirstSequence
Optional. The order of resource types to remove before all others

.PARAMETER RemoveLastSequence
Optional. The order of resource types to remove after all others

.PARAMETER RequireCompleteRemoval
Optional. Require terminal deployments, complete discovery and confirmed resource/record removal before regional relocation.

.OUTPUTS
Strict removal returns RemovedDeploymentNames only after complete removal.
If record removal partly succeeds before failing, Exception.Data.RemovedDeploymentNames identifies confirmed removed roots.

.EXAMPLE
Remove-Deployment -DeploymentNames @('KeyVault-t1','KeyVault-t2') -TemplateFilePath 'C:/main.json'

Remove all resources deployed via the with deployment names 'KeyVault-t1' & 'KeyVault-t2'
#>
function Remove-Deployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [string[]] $DeploymentNames = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $PreflightRejectedDeploymentNames = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $ResourceIds = @(),

        [Parameter(Mandatory = $false)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string[]] $RemoveFirstSequence = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $RemoveLastSequence = @(),

        [Parameter()]
        [switch] $RequireCompleteRemoval
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper
        . (Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-DeploymentTargetResourceList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-ResourceIdsAsFormattedObjectList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Get-OrderedResourcesList.ps1')
        . (Join-Path (Split-Path $PSScriptRoot -Parent) 'helper' 'Remove-ResourceList.ps1')
    }

    process {
        if ($RequireCompleteRemoval -and ($WhatIfPreference -or $DeploymentNames.Count -eq 0)) {
            throw 'Complete cleanup requires submitted deployment names and actual removal.'
        }
        if (@($PreflightRejectedDeploymentNames | Where-Object { $_ -notin $DeploymentNames }).Count -gt 0) {
            throw 'Preflight rejection metadata contains names outside the supplied deployments.'
        }
        $azContext = Get-AzContext -ErrorAction Stop

        $deployedTargetResources = $ResourceIds
        $resolveResult = @{}

        if ($DeploymentNames.Count -gt 0) {
            # Prepare data
            # ============
            $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $TemplateFilePath

            # Fetch deployments
            # =================
            $deploymentsInputObject = @{
                DeploymentNames                  = $DeploymentNames
                PreflightRejectedDeploymentNames = $PreflightRejectedDeploymentNames
                Scope                            = $deploymentScope
                RequireCompleteRemoval           = $RequireCompleteRemoval
            }
            if (-not [String]::IsNullOrEmpty($ResourceGroupName)) {
                $deploymentsInputObject['resourceGroupName'] = $ResourceGroupName
            }
            if (-not [String]::IsNullOrEmpty($ManagementGroupId)) {
                $deploymentsInputObject['ManagementGroupId'] = $ManagementGroupId
            }

            # In case the function also returns an error, we'll throw a corresponding exception at the end of this script (see below)
            $resolveResult = Get-DeploymentTargetResourceList @deploymentsInputObject
            $deployedTargetResources += $resolveResult.resourcesToRemove
        }

        [array] $deployedTargetResources = $deployedTargetResources | Select-Object -Unique

        if ($RequireCompleteRemoval -and $resolveResult.resolveError) {
            throw "Complete cleanup discovery failed: $($resolveResult.resolveError)"
        }
        if ($RequireCompleteRemoval) {
            $completionInput = @{
                DeploymentIds       = $resolveResult.deploymentIds
                DeploymentNamesById = @{}
                ErrorAction         = 'Stop'
            }
            foreach ($name in $DeploymentNames) {
                $id = Get-DeploymentResourceId -Scope $deploymentScope -Name $name -SubscriptionId $azContext.Subscription.Id `
                    -ResourceGroupName $ResourceGroupName -ManagementGroupId $ManagementGroupId
                $completionInput.DeploymentNamesById[$id] = $name
            }
        }
        Write-Verbose ('Total number of deployment target resources after fetching deployments [{0}]' -f $deployedTargetResources.Count) -Verbose

        if (-not $deployedTargetResources) {
            if ($resolveResult.resolveError) {
                throw ('The following error was thrown while resolving the original deployment names: [{0}]' -f $resolveResult.resolveError)
            }
            if ($RequireCompleteRemoval) {
                Complete-DeploymentRemoval @completionInput
                return @{ RemovedDeploymentNames = @($DeploymentNames) }
            }
            return
        }

        # Pre-Filter & order items
        # ========================
        $rawTargetResourceIdsToRemove = $deployedTargetResources | Sort-Object -Culture 'en-US' -Property { $_.Split('/').Count } -Descending | Select-Object -Unique
        Write-Verbose ('Total number of deployment target resources after pre-filtering (duplicates) & ordering items [{0}]' -f $rawTargetResourceIdsToRemove.Count) -Verbose

        # Format items
        # ============
        [array] $resourcesToRemove = Get-ResourceIdsAsFormattedObjectList -ResourceIds $rawTargetResourceIdsToRemove
        Write-Verbose ('Total number of deployment target resources after formatting items [{0}]' -f $resourcesToRemove.Count) -Verbose

        # Filter resources
        # ================

        # Resource IDs in the below list are ignored by the removal
        $resourceIdsToIgnore = @(
            '/subscriptions/{0}/resourceGroups/NetworkWatcherRG' -f $azContext.Subscription.Id
        )

        # Resource IDs starting with a prefix in the below list are ignored by the removal
        $resourceIdPrefixesToIgnore = @(
            '/subscriptions/{0}/providers/Microsoft.Security/autoProvisioningSettings/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/deviceSecurityGroups/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/iotSecuritySolutions/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/pricings/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/securityContacts/' -f $azContext.Subscription.Id
            '/subscriptions/{0}/providers/Microsoft.Security/workspaceSettings/' -f $azContext.Subscription.Id
        )
        [regex] $ignorePrefix_regex = '(?i)^(' + (($resourceIdPrefixesToIgnore | ForEach-Object { [regex]::escape($_) }) -join '|') + ')'


        if ($resourcesToIgnore = $resourcesToRemove | Where-Object { $_.resourceId -in $resourceIdsToIgnore -or $_.resourceId -match $ignorePrefix_regex }) {
            if ($RequireCompleteRemoval) {
                throw 'Cleanup includes protected resources; regional relocation is blocked.'
            }
            Write-Verbose 'Resources excluded from removal:' -Verbose
            $resourcesToIgnore | ForEach-Object { Write-Verbose ('- Ignore [{0}]' -f $_.resourceId) -Verbose }
        }

        [array] $resourcesToRemove = $resourcesToRemove | Where-Object { $_.resourceId -notin $resourceIdsToIgnore -and $_.resourceId -notmatch $ignorePrefix_regex }
        Write-Verbose ('Total number of deployments after filtering all dependency resources [{0}]' -f $resourcesToRemove.Count) -Verbose

        # Order resources
        # ===============
        $orderListInputObject = @{
            ResourcesToOrder    = $resourcesToRemove
            RemoveFirstSequence = $RemoveFirstSequence
            RemoveLastSequence  = $RemoveLastSequence
        }
        [array] $resourcesToRemove = Get-OrderedResourcesList @orderListInputObject
        Write-Verbose ('Total number of deployments after final ordering of resources [{0}]' -f $resourcesToRemove.Count) -Verbose

        # Remove resources
        # ================
        if ($resourcesToRemove.Count -gt 0) {
            if ($PSCmdlet.ShouldProcess(('[{0}] resources' -f (($resourcesToRemove -is [array]) ? $resourcesToRemove.Count : 1)), 'Remove')) {
                Remove-ResourceList -ResourcesToRemove $resourcesToRemove -RequireCompleteRemoval:$RequireCompleteRemoval
            }
        } else {
            Write-Verbose 'Found [0] resources to remove'
        }

        # In case any deployment was not resolved as planned we finally want to throw an exception to make this visible in the pipeline
        if ($resolveResult.resolveError) {
            throw ('The following error was thrown while resolving the original deployment names: [{0}]' -f $resolveResult.resolveError)
        }
        if ($RequireCompleteRemoval) {
            Complete-DeploymentRemoval @completionInput -ResourceIds $deployedTargetResources
            return @{ RemovedDeploymentNames = @($DeploymentNames) }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
