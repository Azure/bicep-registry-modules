<#
.SYNOPSIS
Distinguish request timeouts from deployment cancellation.

.DESCRIPTION
A typed TimeoutException identifies a deadline in its cancellation exception chain.
Unclassified cancellation and PipelineStoppedException remain terminal, including in wrappers.

.PARAMETER ErrorRecord
Required. The error from deployment submission or resource discovery.
#>
function Get-DeploymentErrorKind {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord] $ErrorRecord
    )

    $pending = [System.Collections.Generic.Stack[System.Exception]]::new()
    $pending.Push($ErrorRecord.Exception)
    $visited = [System.Collections.Generic.HashSet[System.Exception]]::new()
    $hasTimeout = $false
    $hasTransportError = $false

    while ($pending.Count -gt 0) {
        $chainHasCancellation = $false
        $chainHasTimeout = $false
        $exception = $pending.Pop()
        while ($null -ne $exception -and $visited.Add($exception)) {
            if ($exception -is [System.Management.Automation.PipelineStoppedException]) {
                return 'Cancellation'
            }
            if ($exception -is [System.AggregateException]) {
                foreach ($innerException in $exception.InnerExceptions) {
                    $pending.Push($innerException)
                }
                break
            }
            $chainHasCancellation = $chainHasCancellation -or $exception -is [System.OperationCanceledException]
            $chainHasTimeout = $chainHasTimeout -or $exception -is [System.TimeoutException]
            $hasTransportError = $hasTransportError -or $exception -is [System.Net.Http.HttpRequestException]
            $innerException = $exception.InnerException
            if ($null -eq $innerException -and $exception -is [System.Management.Automation.RuntimeException]) {
                $innerException = $exception.ErrorRecord.Exception
            }
            $exception = $innerException
        }
        if ($chainHasCancellation -and -not $chainHasTimeout) {
            return 'Cancellation'
        }
        $hasTimeout = $hasTimeout -or $chainHasTimeout
    }

    if ($hasTimeout) { return 'Timeout' }
    if ($hasTransportError) { return 'Transport' }
    return 'Other'
}
