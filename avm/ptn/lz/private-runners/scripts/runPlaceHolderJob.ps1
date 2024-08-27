Param(
    [string]$jobName,
    [string]$resourceGroup,
    [string]$subscriptionId
)
$ErrorActionPreference = 'SilentlyContinue'
$DeploymentScriptOutputs = @{}
$maxRetries = 10
$retryCount = 0

if (Get-AzContainerAppJob -Name $jobName -ResourceGroupName $resourceGroup -SubscriptionId $subscriptionId -ErrorVariable jobStartError) {
    do {
        $jobStatus = (Get-AzContainerAppJob -Name $jobName -ResourceGroupName $resourceGroup -SubscriptionId $subscriptionId).ProvisioningState
        Write-Host 'Waiting for the container app job to start...Waiting 10 seconds!'
        Start-Sleep -Seconds 10
        $retryCount++
    } until ($jobStatus -eq 'Succeeded' -or $maxRetries -eq $retryCount)

    $jobStart = Start-AzContainerAppJob -Name $jobName -ResourceGroupName $resourceGroup -SubscriptionId $subscriptionId -ErrorVariable jobStartError
    if ($jobStart) {
        Write-Host 'Job started successfully.'
        $DeploymentScriptOutputs['JobStatus'] = 'Success'
    } else {
        Write-Host "Failed to start Job. An error occurred: $($jobStartError[0].Exception.Message)"
        $DeploymentScriptOutputs['JobStatus'] = 'Failed'
    }
} else {
    Write-Host "Job not found. $($jobStartError[0].Exception.Message)"
    $DeploymentScriptOutputs['JobStatus'] = 'Failed'
}

