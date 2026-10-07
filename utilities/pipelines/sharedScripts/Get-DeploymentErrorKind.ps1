<#
.SYNOPSIS
Distinguish HTTP 403 responses, request timeouts, transport errors and deployment cancellation.

.DESCRIPTION
A typed TimeoutException identifies a deadline in its cancellation exception chain.
Unclassified cancellation and PipelineStoppedException remain terminal, including in wrappers.
An explicit HTTP 403 status takes precedence over timeout and transport errors, but never cancellation.

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
    $hasForbidden = $false

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
            $statusCode = $exception.Response.StatusCode ?? $exception.StatusCode
            $hasForbidden = $hasForbidden -or (
                ($statusCode -is [System.Net.HttpStatusCode] -or $statusCode -is [int]) -and $statusCode -eq 403
            )
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

    if ($hasForbidden) { return 'Forbidden' }
    if ($hasTimeout) { return 'Timeout' }
    if ($hasTransportError) { return 'Transport' }
    return 'Other'
}
