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

.PARAMETER IncludeAllOperations
Optional. Return every operation without filtering or a success sentinel, for structured failure inspection.

.PARAMETER RequireCompleteRemoval
Optional. Require terminal operations and complete target IDs before authorizing relocation.

.PARAMETER ResolvedResourceIds
Optional. Preserve known create targets when a later operation page fails.

.EXAMPLE
Get-DeploymentOperationAtScope -Scope 'subscription' -Name 'v73rhp24d7jya-test-apvmiaiboaai'

Get all deployment operations for a deployment with name 'v73rhp24d7jya-test-apvmiaiboaai' at scope 'subscription'

.NOTES
Raw responses retain structured statusMessage.error; Az deployment-operation cmdlets format it as text.
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
        [switch] $IncludeAllOperations,

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
        $content = $response.Content | ConvertFrom-Json -NoEnumerate -ErrorAction Stop

        if ($response.StatusCode -ne 200) {
            if ($response.StatusCode -eq 404 -and $content.error.code -eq 'DeploymentNotFound') {
                $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                        [System.InvalidOperationException]::new("Deployment [$Name] was not found in scope [$Scope]."),
                        'DeploymentNotFound',
                        [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                        $Name
                    ))
            }
            if (-not $RequireCompleteRemoval -and -not $IncludeAllOperations -and $Scope -eq 'resourcegroup' -and
                $response.StatusCode -eq 404 -and $content.error.code -eq 'ResourceGroupNotFound') {
                Write-Verbose "Resource group [$ResourceGroupName] no longer exists. No contained resources remain to remove." -Verbose
                return $true
            }
            throw ('Failed to fetch deployment operations for deployment [{0}] in scope [{1}]: HTTP [{2}], error [{3}].' -f $Name, $Scope, $response.StatusCode, $content.error.code)
        }
        if ($content -isnot [System.Management.Automation.PSCustomObject] -or $content.value -isnot [array]) {
            throw "Invalid deployment operations response for deployment [$Name] in scope [$Scope]."
        }
        foreach ($operation in $content.value) {
            if ($IncludeAllOperations -and ($operation -isnot [System.Management.Automation.PSCustomObject] -or
                    $operation.properties -isnot [System.Management.Automation.PSCustomObject] -or
                    $operation.properties.provisioningOperation -isnot [string] -or
                    [string]::IsNullOrWhiteSpace($operation.properties.provisioningOperation))) {
                throw "Deployment [$Name] returned an invalid operation."
            }
            $deploymentOperations += , $operation.properties
            $targetId = $operation.properties.targetResource.id
            if ($null -ne $ResolvedResourceIds -and $operation.properties.provisioningOperation -eq 'Create' -and
                -not [string]::IsNullOrWhiteSpace($targetId) -and $targetId -notmatch '/Microsoft\.Resources/deployments/') {
                $ResolvedResourceIds.Add($targetId)
            }
        }
        $path = $null
        if ($IncludeAllOperations -and $null -ne $content.nextLink -and
            ($content.nextLink -isnot [string] -or [string]::IsNullOrWhiteSpace($content.nextLink))) {
            throw "Deployment [$Name] returned an invalid operation page link."
        }
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
    if ($IncludeAllOperations) {
        return , $deploymentOperations
    }
    $deploymentOperationsFiltered = $deploymentOperations | Where-Object { $_.provisioningOperation -in $ProvisioningOperationsToInclude }
    return $deploymentOperationsFiltered ?? $true # Returning true to indicate that the deployment was found, but did not contain any relevant operations
}
