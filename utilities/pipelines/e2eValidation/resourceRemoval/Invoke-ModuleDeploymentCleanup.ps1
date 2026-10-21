. (Join-Path $PSScriptRoot 'Initialize-DeploymentRemoval.ps1')

<#
.SYNOPSIS
Clean the recorded deployment attempts and report whether complete teardown is confirmed.

.PARAMETER RequireCompleteRemoval
Opt into authoritative final teardown. Ordinary callers retain best-effort cleanup.
#>
function Invoke-ModuleDeploymentCleanup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $TemplateFilePath,
        [string[]] $DeploymentNames = @(),
        [string[]] $RemainingDeploymentNames,
        [string[]] $PreflightRejectedDeploymentNames = @(),
        [string[]] $PendingDeletionDeploymentIds = @(),
        [int] $DeploymentAttempts = -1,
        [string] $SubscriptionId,
        [string] $ManagementGroupId,
        [string] $ResourceGroupName,
        [string[]] $ProtectedResourceIds = @(),
        [switch] $RequireCompleteRemoval
    )

    if ($RequireCompleteRemoval) {
        foreach ($name in @('RemainingDeploymentNames', 'PreflightRejectedDeploymentNames', 'PendingDeletionDeploymentIds', 'DeploymentAttempts')) {
            if (-not $PSBoundParameters.ContainsKey($name) -or $null -eq $PSBoundParameters[$name]) {
                throw 'Complete final cleanup requires authoritative deployment tracking.'
            }
        }
        if ($DeploymentAttempts -lt 0 -or ($DeploymentNames.Count -gt 0 -and $DeploymentAttempts -eq 0)) {
            throw 'The recorded deployment attempt count is invalid.'
        }
    }
    foreach ($names in @(
            @{ Values = $DeploymentNames }
            @{ Values = @($RemainingDeploymentNames ?? @()) }
            @{ Values = $PreflightRejectedDeploymentNames }
        )) {
        if (@($names.Values | Where-Object { [string]::IsNullOrWhiteSpace($_) }).Count -gt 0 -or
            @($names.Values | Select-Object -Unique).Count -ne @($names.Values).Count) {
            throw 'Cleanup tracking requires unique, nonempty deployment names.'
        }
    }
    if (@($PreflightRejectedDeploymentNames | Where-Object { $_ -notin $DeploymentNames }).Count -gt 0 -or
        @(@($RemainingDeploymentNames ?? @()) | Where-Object { $_ -notin $DeploymentNames }).Count -gt 0) {
        throw 'Cleanup tracking contains names outside the original deployment attempts.'
    }
    if ($DeploymentNames.Count -eq 0) {
        if ($PendingDeletionDeploymentIds.Count -gt 0) {
            throw 'Pending deployment deletion metadata has no remaining deployment owner.'
        }
        return @{ Status = $DeploymentAttempts -eq 0 ? 'not-submitted' : 'unknown' }
    }
    $hasRemainingNames = $PSBoundParameters.ContainsKey('RemainingDeploymentNames') -and $null -ne $RemainingDeploymentNames
    $remaining = $hasRemainingNames ? @($RemainingDeploymentNames) : @($DeploymentNames)
    if ($remaining.Count -eq 0) {
        if ($PendingDeletionDeploymentIds.Count -gt 0) {
            throw 'Pending deployment deletion metadata has no remaining deployment owner.'
        }
        Write-Verbose 'All submitted deployments were already completely removed.' -Verbose
        return @{ Status = $RequireCompleteRemoval ? 'confirmed' : 'unconfirmed' }
    }
    $inputObject = @{
        TemplateFilePath                 = $TemplateFilePath
        DeploymentNames                  = $remaining
        PreflightRejectedDeploymentNames = @($PreflightRejectedDeploymentNames | Where-Object { $_ -in $remaining })
        PendingDeletionDeploymentIds     = $PendingDeletionDeploymentIds
        ManagementGroupId                = $ManagementGroupId
        ProtectedResourceIds             = $ProtectedResourceIds
    }
    if ($SubscriptionId) { $inputObject.SubscriptionId = $SubscriptionId }
    if ($ResourceGroupName) { $inputObject.ResourceGroupName = $ResourceGroupName }
    if ($RequireCompleteRemoval) {
        $inputObject.RequireCompleteRemoval = $true
        $inputObject.FinalCleanup = $true
    }
    $result = Initialize-DeploymentRemoval @inputObject -ErrorAction Stop
    if (-not $RequireCompleteRemoval) { return @{ Status = 'unconfirmed' } }
    if ($result -isnot [System.Collections.IDictionary] -or
        -not $result.Contains('RemovedDeploymentNames') -or $result.RemovedDeploymentNames -isnot [array] -or
        @($result.RemovedDeploymentNames).Count -ne $remaining.Count -or
        @(Compare-Object $result.RemovedDeploymentNames $remaining).Count -gt 0) {
        throw 'Final cleanup did not confirm every outstanding deployment.'
    }
    return @{ Status = 'confirmed' }
}
