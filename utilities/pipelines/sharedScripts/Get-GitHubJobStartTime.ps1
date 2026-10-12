<#
.SYNOPSIS
Read the exact running GitHub-hosted job's start time without credentials.

.DESCRIPTION
Matches the documented job.check_run_id against every page of the current run attempt.
Only public GitHub.com jobs are supported. Requests never follow redirects or use tokens.
Missing, inconsistent, inaccessible or exhausted metadata rejects deployment, without a fallback.

.PARAMETER ApiUrl
Required. The github.api_url context; only https://api.github.com is supported.

.PARAMETER Repository
Required. The github.repository context.

.PARAMETER RunId
Required. The github.run_id context.

.PARAMETER RunAttempt
Required. The github.run_attempt context.

.PARAMETER CheckRunId
Required. The job.check_run_id context, not the shared github.job name.

.PARAMETER RunnerName
Required. The runner.name context, used to cross-check the selected job.

.PARAMETER RunnerEnvironment
Required. The runner.environment context; must be github-hosted.

.PARAMETER EventName
Required. The github.event_name context: push, workflow_dispatch or pull_request.

.PARAMETER HeadSha
Required. The github.sha context for push and workflow_dispatch.

.PARAMETER PullRequestHeadSha
Optional. Required for pull_request, whose github.sha identifies a synthetic merge instead.

.OUTPUTS
The job's started_at as an absolute UTC datetime.
#>
function Get-GitHubJobStartTime {
    [CmdletBinding()]
    [OutputType([datetime])]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $ApiUrl,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Repository,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $RunId,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $RunAttempt,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $CheckRunId,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $RunnerName,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $RunnerEnvironment,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $EventName,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $HeadSha,

        [Parameter()]
        [string] $PullRequestHeadSha
    )

    $observedAtUtc = (Get-Date).ToUniversalTime()
    if ($ApiUrl -cne 'https://api.github.com' -or $RunnerEnvironment -cne 'github-hosted' -or
        $Repository -cnotmatch '\A[A-Za-z0-9_-][A-Za-z0-9_.-]*/[A-Za-z0-9_-][A-Za-z0-9_.-]*\z' -or
        [string]::IsNullOrWhiteSpace($RunnerName) -or $EventName -cnotin @('push', 'workflow_dispatch', 'pull_request')) {
        throw 'Bounded HCI recovery requires a public GitHub.com job with complete GitHub-hosted context.'
    }
    foreach ($id in @($RunId, $RunAttempt, $CheckRunId)) {
        $parsedId = 0L
        if ($id -cnotmatch '\A[1-9][0-9]*\z' -or -not [long]::TryParse($id, [ref] $parsedId)) {
            throw 'Bounded HCI recovery requires valid run, attempt and check-run IDs.'
        }
    }
    $expectedHeadSha = $EventName -ceq 'pull_request' ? $PullRequestHeadSha : $HeadSha
    if ($expectedHeadSha -notmatch '\A[0-9a-fA-F]{40}\z') {
        throw 'Bounded HCI recovery requires the event-specific workflow head SHA.'
    }

    $jobsUrl = "$ApiUrl/repos/$Repository/actions/runs/$RunId/attempts/$RunAttempt/jobs"
    $checkRunUrl = "$ApiUrl/repos/$Repository/check-runs/$CheckRunId"
    $matchingJobs = [System.Collections.Generic.List[hashtable]]::new()
    $seenIds = [System.Collections.Generic.HashSet[long]]::new()
    $totalCount = -1
    for ($page = 1; $page -le 20; $page++) {
        try {
            $response = Invoke-WebRequest -Uri "${jobsUrl}?per_page=100&page=$page" -Method Get -Authentication None `
                -Headers @{ Accept = 'application/vnd.github+json'; 'X-GitHub-Api-Version' = '2022-11-28' } `
                -MaximumRedirection 0 -MaximumRetryCount 0 -ConnectionTimeoutSeconds 20 -OperationTimeoutSeconds 20 -SkipHttpErrorCheck `
                -ErrorAction Stop -Verbose:$false -Debug:$false
        } catch [System.Management.Automation.PipelineStoppedException] {
            throw
        } catch {
            throw 'Cannot read public GitHub job metadata. Check API availability and anonymous rate limits; deployment will not start.'
        }
        if ($response.StatusCode -ne 200) {
            throw 'GitHub job metadata is inaccessible or redirected. Check public access and anonymous rate limits; deployment will not start.'
        }
        $document = $null
        try {
            $document = [System.Text.Json.JsonDocument]::Parse([string] $response.Content)
            $root = $document.RootElement
            $count = $root.GetProperty('total_count').GetInt32()
            $jobs = @($root.GetProperty('jobs').EnumerateArray())
            foreach ($item in (@($root) + $jobs)) {
                $properties = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
                foreach ($property in $item.EnumerateObject()) {
                    if (-not $properties.Add($property.Name)) { throw 'Repeated metadata property.' }
                }
            }
            if ($count -lt 1 -or $count -gt 2000 -or ($totalCount -ne -1 -and $count -ne $totalCount) -or
                $jobs.Count -ne [Math]::Min(100, $count - (($page - 1) * 100))) {
                throw 'Incomplete or excessive job pagination.'
            }
            $totalCount = $count
            foreach ($job in $jobs) {
                $jobId = $job.GetProperty('id').GetInt64()
                if ($jobId -le 0 -or -not $seenIds.Add($jobId)) { throw 'Repeated or invalid job identity.' }
                if ($job.GetProperty('check_run_url').GetString() -ceq $checkRunUrl) {
                    $matchingJobs.Add(@{
                            RunId         = $job.GetProperty('run_id').GetInt64()
                            RunAttempt    = $job.GetProperty('run_attempt').GetInt64()
                            HeadSha       = $job.GetProperty('head_sha').GetString()
                            RunnerName    = $job.GetProperty('runner_name').GetString()
                            RunnerId      = $job.GetProperty('runner_id').GetInt64()
                            Status        = $job.GetProperty('status').GetString()
                            Conclusion    = $job.GetProperty('conclusion').ValueKind
                            CompletedAt   = $job.GetProperty('completed_at').ValueKind
                            StartedAt     = $job.GetProperty('started_at').GetString()
                        })
                }
            }
        } catch [System.Management.Automation.PipelineStoppedException] {
            throw
        } catch {
            throw 'GitHub returned malformed, incomplete or ambiguous job metadata; deployment will not start.'
        } finally {
            if ($null -ne $document) { $document.Dispose() }
        }
        if ($seenIds.Count -eq $totalCount) { break }
    }
    if ($matchingJobs.Count -ne 1) {
        throw 'GitHub metadata must identify exactly one current check run; deployment will not start.'
    }
    $currentJob = $matchingJobs[0]
    if ($currentJob.RunId -ne [long] $RunId -or $currentJob.RunAttempt -ne [long] $RunAttempt -or
        $currentJob.HeadSha -ine $expectedHeadSha -or $currentJob.RunnerName -cne $RunnerName -or
        $currentJob.RunnerId -le 0 -or $currentJob.Status -cne 'in_progress' -or
        $currentJob.Conclusion -ne [System.Text.Json.JsonValueKind]::Null -or
        $currentJob.CompletedAt -ne [System.Text.Json.JsonValueKind]::Null) {
        throw 'GitHub job metadata does not match the running workflow attempt, head and runner; deployment will not start.'
    }

    $startedAt = [datetimeoffset]::MinValue
    if ($currentJob.StartedAt -cnotmatch '\A[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(?:\.[0-9]{1,7})?(?:Z|[+-][0-9]{2}:[0-9]{2})\z' -or
        -not [datetimeoffset]::TryParse($currentJob.StartedAt, [cultureinfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref] $startedAt) -or
        $startedAt.UtcDateTime -gt $observedAtUtc) {
        throw 'GitHub job started_at must be an unambiguous timestamp with an offset, not in the future; deployment will not start.'
    }
    if ($startedAt.UtcDateTime.AddMinutes(320) -le (Get-Date).ToUniversalTime()) {
        throw 'The GitHub job has exhausted its bounded HCI recovery allowance; deployment will not start.'
    }
    return $startedAt.UtcDateTime
}
