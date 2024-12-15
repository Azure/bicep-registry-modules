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

.PARAMETER ResourceId(s)
Optional. The resource Id(s) of the resources to remove. Combined with resources found via the deployment name(s).

.PARAMETER TemplateFilePath
Optional. The path to the template used for the deployment(s). Used to determine the level/scope (e.g. subscription). Required if deploymentName(s) are provided.

.PARAMETER RemoveFirstSequence
Optional. The order of resource types to remove before all others

.PARAMETER RemoveLastSequence
Optional. The order of resource types to remove after all others

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
        [string[]] $ResourceIds = @(),

        [Parameter(Mandatory = $false)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string[]] $RemoveFirstSequence = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $RemoveLastSequence = @()
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
        $azContext = Get-AzContext

        $deployedTargetResources = $ResourceIds

        if ($DeploymentNames.Count -gt 0) {
            # Prepare data
            # ============
            $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $TemplateFilePath

            # Fundamental checks
            if ($deploymentScope -eq 'resourcegroup' -and -not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction 'SilentlyContinue')) {
                Write-Verbose "Resource group [$ResourceGroupName] does not exist (anymore). Skipping removal of its contained resources" -Verbose
                return
            }

            # Fetch deployments
            # =================
            $deploymentsInputObject = @{
                DeploymentNames = $DeploymentNames
                Scope           = $deploymentScope
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

        Write-Verbose ('Total number of deployment target resources after fetching deployments [{0}]' -f $deployedTargetResources.Count) -Verbose

        if (-not $deployedTargetResources) {
            # Nothing to do
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
                Remove-ResourceList -ResourcesToRemove $resourcesToRemove
            }
        } else {
            Write-Verbose 'Found [0] resources to remove'
        }

        # In case any deployment was not resolved as planned we finally want to throw an exception to make this visible in the pipeline
        if ($resolveResult.resolveError) {
            throw ('The following error was thrown while resolving the original deployment names: [{0}]' -f $resolveResult.resolveError)
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
