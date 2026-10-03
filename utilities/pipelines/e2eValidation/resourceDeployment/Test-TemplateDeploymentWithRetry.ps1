. (Join-Path $PSScriptRoot 'Invoke-TemplateDeploymentWithRetry.ps1')

<#
.SYNOPSIS
Validate a test template in at most three distinct eligible resource regions.

.DESCRIPTION
Only wholly regional validation failures may select another supported, allowed region.
Explicit custom, CI and token locations, global resources and resource-group scope never relocate.
Failed validation restores pristine location-token files; successful validation retains the selected region.

.PARAMETER ValidationInput
Required. Parameters for Test-TemplateDeployment. An empty resourceLocation permits automatic selection.

.PARAMETER ModuleRoot
Required. Module path used to find supported regions.

.PARAMETER CustomLocation
Optional. Caller-pinned resource location.

.PARAMETER TokenResourceLocation
Optional. Resource location supplied by local or custom tokens.

.PARAMETER RetryLimit
Optional. Maximum validation attempts, including the first. Defaults to three.
#>
function Test-TemplateDeploymentWithRetry {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [hashtable] $ValidationInput,

        [Parameter(Mandatory)]
        [string] $ModuleRoot,

        [Parameter()]
        [string] $CustomLocation,

        [Parameter()]
        [string] $TokenResourceLocation,

        [Parameter()]
        [ValidateRange(1, 3)]
        [int] $RetryLimit = 3
    )

    Invoke-TemplateDeploymentWithRetry -TemplateInput $ValidationInput -ModuleRoot $ModuleRoot `
        -CustomLocation $CustomLocation -TokenResourceLocation $TokenResourceLocation -RegionLimit $RetryLimit -ValidationOnly
}
