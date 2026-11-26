param(
    [string] $Repository,
    [int64] $PullRequestNumber,
    [string] $ExpectedHeadSha,
    [string] $ExpectedBaseSha,
    [int64] $DispatcherRunId,
    [int] $UnavailableAttempts = 12,
    [int] $CompletionAttempts = 1080,
    [int] $PollIntervalSeconds = 10
)

function Invoke-GitHubApi {
    param(
        [Parameter(Mandatory)]
        [string] $Path,

        [ValidateSet('GET', 'POST')]
        [string] $Method = 'GET'
    )

    $arguments = @(
        'api'
        '-H', 'Accept: application/vnd.github+json'
        '-H', 'X-GitHub-Api-Version: 2022-11-28'
        '--method', $Method
        $Path
    )
    $result = & gh @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "GitHub API request failed: $Method $Path"
    }
    if ([string]::IsNullOrWhiteSpace($result)) {
        return $null
    }

    return $result | ConvertFrom-Json
}

function Test-MatchingPrCheckRun {
    param(
        [Parameter(Mandatory)]
        [object] $Run,

        [Parameter(Mandatory)]
        [object] $PullRequest,

        [Parameter(Mandatory)]
        [int64] $PullRequestNumber
    )

    if ($Run.event -ne 'pull_request' -or
        $Run.path -ne '.github/workflows/pr-check.yml' -or
        $Run.head_sha -ne $PullRequest.head.sha -or
        $Run.head_branch -ne $PullRequest.head.ref) {
        return $false
    }

    $matchingPullRequests = @(
        $Run.pull_requests | Where-Object {
            $_.number -eq $PullRequestNumber -and
            $_.head.sha -eq $PullRequest.head.sha -and
            $_.head.ref -eq $PullRequest.head.ref -and
            $_.head.repo.id -eq $PullRequest.head.repo.id -and
            $_.base.sha -eq $PullRequest.base.sha -and
            $_.base.ref -eq $PullRequest.base.ref -and
            $_.base.repo.id -eq $PullRequest.base.repo.id
        }
    )

    return $matchingPullRequests.Count -eq 1
}

function Invoke-PrCheckRerun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^[^/\s]+/[^/\s]+$')]
        [string] $Repository,

        [Parameter(Mandatory)]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64] $PullRequestNumber,

        [Parameter(Mandatory)]
        [ValidatePattern('^[0-9a-f]{40}$')]
        [string] $ExpectedHeadSha,

        [Parameter(Mandatory)]
        [ValidatePattern('^[0-9a-f]{40}$')]
        [string] $ExpectedBaseSha,

        [Parameter(Mandatory)]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64] $DispatcherRunId,

        [ValidateRange(1, 1000)]
        [int] $UnavailableAttempts = 12,

        [ValidateRange(1, 10000)]
        [int] $CompletionAttempts = 2148,

        [ValidateRange(0, 300)]
        [int] $PollIntervalSeconds = 10
    )

    $dispatcher = Invoke-GitHubApi -Path "/repos/$Repository/actions/runs/$DispatcherRunId"
    if ($dispatcher.event -ne 'pull_request_target') {
        throw "Dispatcher run $DispatcherRunId is not a pull_request_target run."
    }

    $dispatcherStartedAt = [DateTimeOffset]::Parse($dispatcher.run_started_at)
    $unavailablePolls = 0

    for ($poll = 0; $poll -lt $CompletionAttempts; $poll++) {
        $pullRequest = Invoke-GitHubApi -Path "/repos/$Repository/pulls/$PullRequestNumber"
        if ($pullRequest.head.repo.id -ne $pullRequest.base.repo.id) {
            throw "Pull request #$PullRequestNumber is from a fork. Label-triggered reruns do not grant deployment access; use the approved release-branch handoff."
        }
        if ($pullRequest.head.sha -ne $ExpectedHeadSha) {
            Write-Output "The pull request head changed to $($pullRequest.head.sha); its synchronize run will evaluate the current labels."
            return
        }
        if ($pullRequest.base.sha -ne $ExpectedBaseSha) {
            throw "The pull request base changed from $ExpectedBaseSha to $($pullRequest.base.sha) while selecting a PR-check run."
        }

        $labels = @($pullRequest.labels | ForEach-Object name)
        if ($labels -notcontains 'PR: Run Required E2E Tests' -and
            $labels -notcontains 'PR: Run All E2E Tests') {
            Write-Output 'The E2E label is no longer present; no rerun is needed.'
            return
        }

        $runs = Invoke-GitHubApi -Path "/repos/$Repository/actions/workflows/pr-check.yml/runs?event=pull_request&head_sha=$($pullRequest.head.sha)&per_page=100"
        $matchingRuns = @(
            $runs.workflow_runs |
                Where-Object { Test-MatchingPrCheckRun -Run $_ -PullRequest $pullRequest -PullRequestNumber $PullRequestNumber } |
                Sort-Object -Property @(
                    @{ Expression = { [DateTimeOffset]::Parse($_.created_at) }; Descending = $true }
                    @{ Expression = { [int64] $_.id }; Descending = $true }
                )
        )

        if ($matchingRuns.Count -eq 0) {
            $unavailablePolls++
            if ($unavailablePolls -ge $UnavailableAttempts) {
                throw "No PR-check run matched pull request #$PullRequestNumber at head $ExpectedHeadSha and base $ExpectedBaseSha."
            }
            Start-Sleep -Seconds $PollIntervalSeconds
            continue
        }

        $unavailablePolls = 0
        $latestRun = $matchingRuns[0]
        $latestRunStartedAt = [DateTimeOffset]::Parse($latestRun.run_started_at)
        $activeRuns = @($matchingRuns | Where-Object status -ne 'completed')
        $olderActiveRuns = @(
            $activeRuns | Where-Object {
                [DateTimeOffset]::Parse($_.run_started_at) -lt $dispatcherStartedAt
            }
        )
        if ($latestRunStartedAt -ge $dispatcherStartedAt -and $olderActiveRuns.Count -eq 0) {
            Write-Output "PR-check run $($latestRun.id) already started after this label event at $($latestRun.run_started_at); no additional rerun is needed."
            return
        }

        if ($activeRuns.Count -gt 0) {
            Write-Output "Waiting for $($activeRuns.Count) active PR-check run(s) for head $ExpectedHeadSha."
            Start-Sleep -Seconds $PollIntervalSeconds
            continue
        }

        if ($latestRunStartedAt -ge $dispatcherStartedAt) {
            Write-Output "PR-check run $($latestRun.id) completed after this label event; no additional rerun is needed."
            return
        }

        $pullRequest = Invoke-GitHubApi -Path "/repos/$Repository/pulls/$PullRequestNumber"
        if ($pullRequest.head.sha -ne $ExpectedHeadSha) {
            Write-Output "The pull request head changed to $($pullRequest.head.sha); its synchronize run will evaluate the current labels."
            return
        }
        if ($pullRequest.base.sha -ne $ExpectedBaseSha) {
            throw "The pull request base changed from $ExpectedBaseSha to $($pullRequest.base.sha) before rerunning PR-check."
        }
        $labels = @($pullRequest.labels | ForEach-Object name)
        if ($labels -notcontains 'PR: Run Required E2E Tests' -and
            $labels -notcontains 'PR: Run All E2E Tests') {
            Write-Output 'The E2E label was removed before rerun; no rerun is needed.'
            return
        }

        $verifiedRuns = Invoke-GitHubApi -Path "/repos/$Repository/actions/workflows/pr-check.yml/runs?event=pull_request&head_sha=$($pullRequest.head.sha)&per_page=100"
        $verifiedMatchingRuns = @(
            $verifiedRuns.workflow_runs |
                Where-Object { Test-MatchingPrCheckRun -Run $_ -PullRequest $pullRequest -PullRequestNumber $PullRequestNumber } |
                Sort-Object -Property @(
                    @{ Expression = { [DateTimeOffset]::Parse($_.created_at) }; Descending = $true }
                    @{ Expression = { [int64] $_.id }; Descending = $true }
                )
        )
        $verifiedLatestRun = $verifiedMatchingRuns | Select-Object -First 1
        if ($verifiedLatestRun.id -ne $latestRun.id -or $verifiedLatestRun.status -ne 'completed') {
            Write-Output 'The PR-check run set changed during verification; selecting it again.'
            continue
        }

        Invoke-GitHubApi -Path "/repos/$Repository/actions/runs/$($latestRun.id)/rerun" -Method POST | Out-Null
        Write-Output "Requested a rerun of PR-check run $($latestRun.id) for pull request #$PullRequestNumber."
        return
    }

    throw "Timed out waiting for PR-check runs for pull request #$PullRequestNumber."
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-PrCheckRerun @PSBoundParameters
}
