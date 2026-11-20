. (Join-Path $PSScriptRoot 'Get-DeploymentErrorKind.ps1')

function Test-DeploymentReadTimeout {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord] $ErrorRecord
    )

    if ($ErrorRecord.CategoryInfo.Category -in @('AuthenticationError', 'PermissionDenied', 'SecurityError') -or
        (Get-DeploymentErrorKind -ErrorRecord $ErrorRecord) -ne 'Timeout') {
        return $false
    }
    $pending = [System.Collections.Generic.Stack[System.Exception]]::new()
    $pending.Push($ErrorRecord.Exception)
    $visited = [System.Collections.Generic.HashSet[System.Exception]]::new()
    while ($pending.Count -gt 0) {
        $exception = $pending.Pop()
        if (-not $visited.Add($exception)) { continue }
        if ($exception -is [System.UnauthorizedAccessException] -or
            $null -ne $exception.Response.StatusCode -or $null -ne $exception.StatusCode) {
            return $false
        }
        if ($exception -is [System.AggregateException]) {
            foreach ($inner in $exception.InnerExceptions) {
                $record = [System.Management.Automation.ErrorRecord]::new(
                    $inner, 'DeploymentReadFailed', [System.Management.Automation.ErrorCategory]::NotSpecified, $null
                )
                if ((Get-DeploymentErrorKind -ErrorRecord $record) -ne 'Timeout') { return $false }
                $pending.Push($inner)
            }
        } else {
            if ($exception -is [System.Management.Automation.RuntimeException] -and
                $null -ne $exception.ErrorRecord) {
                if ($exception.ErrorRecord.CategoryInfo.Category -in @('AuthenticationError', 'PermissionDenied', 'SecurityError')) {
                    return $false
                }
                if ((Get-DeploymentErrorKind -ErrorRecord $exception.ErrorRecord) -ne 'Timeout') { return $false }
                $pending.Push($exception.ErrorRecord.Exception)
            }
            if ($null -ne $exception.InnerException) { $pending.Push($exception.InnerException) }
        }
    }
    return $true
}

<#
.SYNOPSIS
Retry a single idempotent deployment read after a typed request timeout.

.DESCRIPTION
At most three reads, five seconds apart. Permission errors, cancellation, HTTP responses and
mixed failures do not retry. Exhaustion rethrows the final original ErrorRecord.

.PARAMETER Read
Required. One idempotent status or operation-page read, never a submission or deletion.
#>
function Invoke-DeploymentRead {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [scriptblock] $Read
    )

    for ($attempt = 1; $attempt -le 3; $attempt++) {
        try {
            $result = . $Read
            return $result
        } catch [System.Management.Automation.PipelineStoppedException] {
            throw
        } catch {
            if ($attempt -eq 3 -or -not (Test-DeploymentReadTimeout -ErrorRecord $_)) {
                throw
            }
            Write-Warning "Deployment read timed out ($attempt/3); retrying the same read without resubmitting or deleting."
            Start-Sleep -Seconds 5
        }
    }
}
