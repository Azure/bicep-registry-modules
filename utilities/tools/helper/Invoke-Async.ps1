<#
.SYNOPSIS
Asynchronously invoke a given script block for a given list of objects

.DESCRIPTION
Asynchronously invoke a given script block for a given list of objects, with a given throttle limit and progress display.

.PARAMETER List
Mandatory. The list of objects to invoke the script block for.

.PARAMETER ScriptBlock
Mandatory. The script block to invoke for each object in the list. The current object will be available as '$_' within the script block.

.PARAMETER ThrottleLimit
Optional. The maximum number of concurrent threads to use. Defaults to 5.

.PARAMETER ProgressText
Optional. The text to display in the progress bar. Must contain two placeholders for the completed and total job count (e.g. 'Completed [{0}/{1}] jobs'). Defaults to 'Completed [{0}/{1}] jobs'.

.PARAMETER PassThruObject
Optional. An object to which the output of each script block invocation will be added. If not provided, the output will not be collected.

.EXAMPLE
Invoke-Async -List @(1, 2, 3) -ScriptBlock { Start-Sleep -Seconds $_ }

This will asynchronously sleep for 1, 2 and 3 seconds, with a throttle limit of 5 and a progress display.
#>
function Invoke-Async {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [array] $List,

        [Parameter(Mandatory)]
        [System.Management.Automation.ScriptBlock] $ScriptBlock,

        [Parameter(Mandatory = $false)]
        [int] $ThrottleLimit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ProgressText = 'Completed [{0}/{1}] jobs',

        [Parameter(Mandatory = $false)]
        [object] $PassThruObject
    )

    try {
        $job = $List | ForEach-Object -ThrottleLimit $ThrottleLimit -AsJob -Parallel $ScriptBlock

        do {
            # Sleep a bit to allow the threads to run - adjust as desired.
            Start-Sleep -Seconds 0.5

            # Determine how many jobs have completed so far.
            $completedJobsCount = ($job.ChildJobs | Where-Object { $_.State -notin @('NotStarted', 'Running') }).Count


            if ($PassThruObject) {
                # Relay any pending output from the child jobs.
                $result = ($job | Receive-Job -WriteJobInResults -Wait)[1]
                $PassThruObject += $result ?? @{}
            } else {
                # Relay any pending output from the child jobs.
                $job | Receive-Job
            }

            # Update the progress display.
            [int] $percent = ($completedJobsCount / $job.ChildJobs.Count) * 100
            Write-Progress -Activity ($ProgressText -f $completedJobsCount, $List.Count) -Status "$percent% complete" -PercentComplete $percent

        } while ($completedJobsCount -lt $job.ChildJobs.Count)

        # Clean up the job.
        $job | Remove-Job
    } finally {
        # In case the user cancelled the process, we need to make sure to stop all running jobs
        $job | Remove-Job -Force -ErrorAction 'SilentlyContinue'
    }

    if ($PassThruObject) {
        return $PassThruObject
    }
}
