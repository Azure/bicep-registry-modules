<#
.SYNOPSIS
Wait for the specified resource to report a successful provisioning state.

.DESCRIPTION
This script waits for a specified resource to finish deploying by periodically checking its provisioning state.
This can be useful as the provisioning state can sometimes report as 'Succeeded' before the resources are fully operational.

.PARAMETER ResourceId
Mandatory. The Resource ID of the resource to wait for deployment completion.

.PARAMETER MaxRetries
Optional. The maximum number of retries when waiting for the resource deployment to complete. Default is 240.

.PARAMETER WaitIntervalInSeconds
Optional. The wait interval between checks for resource deployment status, in seconds. Default is 15 seconds.

.EXAMPLE
.\Wait-ForResourceDeployment.ps1 -ResourceId "/subscriptions/xxxx/resourceGroups/rg-name/providers/Microsoft.Compute/virtualMachines/vm-name" -MaxRetries 120 -WaitIntervalInSeconds 10

This example waits for the specified virtual machine resource to finish deploying, checking every 10 seconds for up to 120 retries.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string] $ResourceId,

    [Parameter(Mandatory = $false)]
    [int] $MaxRetries = 240, # E.g. 240 retries * 15 seconds = 1 hour

    [Parameter(Mandatory = $false)]
    [int] $WaitIntervalInSeconds = 15
)


# Get API Version
$providerNamespace, $resourceType = ($ResourceId -split '\/')[6, 7]
$latestApiVersion = ((Get-AzResourceProvider -ProviderNamespace $providerNamespace).ResourceTypes | Where-Object {
        $_.ResourceTypeName -eq $resourceType
    }).ApiVersions[-1]
$resourceAPIPath = '{0}?api-version={1}' -f $ResourceId, $latestApiVersion

# Get State
$getResourceStateInputObject = @{
    Method = 'GET'
    Path   = $resourceAPIPath
}
$retryCount = 1

Write-Verbose 'Invoke function with' -Verbose
Write-Verbose ($getResourceStateInputObject | ConvertTo-Json | Out-String) -Verbose

do {
    $resourceState = Invoke-AzRestMethod @getResourceStateInputObject
    $resourceStateContent = $resourceState.Content | ConvertFrom-Json
    if ($resourceState.StatusCode -notlike '2*') {
        throw ('{0} : {1}' -f $resourceStateContent.error.code, $resourceStateContent.error.message)
    }

    if ($resourceStateContent.properties.provisioningState -eq 'Succeeded') {
        Write-Verbose ('    [✔️] Resource provisioning succeeded.') -Verbose
        $replicationFullyProvisioned = $true
        break
    } else {
        $replicationFullyProvisioned = $false
        Write-Verbose ('    [⏱️] Waiting {0} seconds for resource provisioning to finish. [{1}/{2}]' -f $WaitIntervalInSeconds, $retryCount, $MaxRetries) -Verbose
        Start-Sleep -Seconds $WaitIntervalInSeconds
        $retryCount++
    }
} while (-not $replicationFullyProvisioned -and $retryCount -lt $MaxRetries)

if ($retryCount -ge $MaxRetries) {
    Write-Warning ('    [!] Resource provisioning was not finished after {0} seconds.' -f ($retryCount * $WaitIntervalInSeconds))
}
