<#
.SYNOPSIS
Fetch the latest build status for the provided image template

.DESCRIPTION
Fetch the latest build status for the provided image template

.PARAMETER ResourceGroupName
Required. The name of the Resource Group containing the image template

.PARAMETER ImageTemplateName
Required. The name of the image template to query to build status for. E.g. 'lin_it-2022-02-20-16-17-38'

.EXAMPLE
. 'Wait-ForImageBuild.ps1' -ResourceGroupName' 'myRG' -ImageTemplateName 'lin_it-2022-02-20-16-17-38'

Check the current build status of Image Template 'lin_it-2022-02-20-16-17-38' in Resource Group 'myRG'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $ResourceGroupName,

    [Parameter(Mandatory)]
    [string] $ImageTemplateName
)

begin {
    Write-Debug ('[{0} entered]' -f $MyInvocation.MyCommand)
}

process {
    # Logic
    # -----
    $context = Get-AzContext
    $subscriptionId = $context.Subscription.Id
    $currentRetry = 1
    $maximumRetries = 720
    $timeToWait = 15
    $maxTimeCalc = '{0:hh\:mm\:ss}' -f [timespan]::fromseconds($maximumRetries * $timeToWait)
    do {

        # Runnning fetch in retry as it happened that the status was not available
        $statusFetchRetryCount = 3
        $statusFetchCurrentRetry = 1
        do {
            $path = '/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.VirtualMachineImages/imageTemplates/{2}?api-version=2020-02-14' -f $subscriptionId, $ResourceGroupName, $ImageTemplateName
            $requestInputObject = @{
                Method = 'GET'
                Path   = $path
            }

            $response = ((Invoke-AzRestMethod @requestInputObject).Content | ConvertFrom-Json).properties

            if ($response.lastRunStatus) {
                $latestStatus = $response.lastRunStatus
                break
            }
            Start-Sleep 5
            $statusFetchCurrentRetry++
        } while ($statusFetchCurrentRetry -le $statusFetchRetryCount)

        if (-not $latestStatus) {
            Write-Verbose ('Image Build failed with error: [{0}]' -f $response.provisioningError.message) -Verbose
            $latestStatus = 'failed'
        }


        if ($latestStatus -eq 'failed' -or $latestStatus.runState.ToLower() -eq 'failed') {
            $failedMessage = 'Image Template [{0}] build failed with status [{1}]. API reply: [{2}]' -f $ImageTemplateName, $latestStatus.runState, $response.lastRunStatus.message
            Write-Verbose $failedMessage -Verbose
            throw $failedMessage
        }

        if ($latestStatus.runState.ToLower() -notIn @('running', 'new')) {
            break
        }

        $currTimeCalc = '{0:hh\:mm\:ss}' -f [timespan]::fromseconds($currentRetry * $timeToWait)

        Write-Verbose ('[{0}] Waiting 15 seconds [{1}|{2}]' -f (Get-Date -Format 'HH:mm:ss'), $currTimeCalc, $maxTimeCalc) -Verbose
        $currentRetry++
        Start-Sleep $timeToWait
    } while ($currentRetry -le $maximumRetries)

    if ($latestStatus) {
        $duration = New-TimeSpan -Start $latestStatus.startTime -End $latestStatus.endTime
        Write-Verbose ('It took [{0}] minutes and [{1}] seconds to build and distribute the image.' -f $duration.Minutes, $duration.Seconds) -Verbose
    } else {
        Write-Warning "Timeout at [$currTimeCalc]. Note, the Azure Image Builder may still succeed."
    }
    return $latestStatus
}

end {
    Write-Debug ('[{0} existed]' -f $MyInvocation.MyCommand)
}
