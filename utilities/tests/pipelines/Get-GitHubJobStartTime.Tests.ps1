param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Exact public GitHub job timing' -Tag 'BoundedHciRecovery' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-GitHubJobStartTime.ps1')
    }

    BeforeEach {
        $script:clock = [datetime]::new(2026, 10, 12, 8, 0, 0, [DateTimeKind]::Utc)
        $script:job = @{
            id            = 303
            check_run_url = 'https://api.github.com/repos/Azure/bicep-registry-modules/check-runs/303'
            run_id        = 101
            run_attempt   = 2
            head_sha      = 'a' * 40
            runner_id     = 404
            runner_name   = 'GitHub Actions 404'
            status        = 'in_progress'
            conclusion    = $null
            completed_at  = $null
            started_at    = '2026-10-12T07:50:00Z'
            name          = 'Deployment validation / Deploy [defaults]'
        }
        $jobInput = @{
            ApiUrl             = 'https://api.github.com'
            Repository         = 'Azure/bicep-registry-modules'
            RunId              = '101'
            RunAttempt         = '2'
            CheckRunId         = '303'
            RunnerName         = 'GitHub Actions 404'
            RunnerEnvironment  = 'github-hosted'
            EventName          = 'workflow_dispatch'
            HeadSha            = 'a' * 40
            PullRequestHeadSha = 'b' * 40
        }
        $script:pages = @{ 1 = @{ total_count = 1; jobs = @($script:job) } }
        $script:httpStatus = 200
        $script:rawContent = $null
        $script:requests = [System.Collections.Generic.List[hashtable]]::new()
        $savedTokens = @{}
        foreach ($name in @('GH_TOKEN', 'GITHUB_TOKEN')) {
            $savedTokens[$name] = [Environment]::GetEnvironmentVariable($name)
            [Environment]::SetEnvironmentVariable($name, 'synthetic-token-not-for-requests-or-errors')
        }
        Mock Get-Date { $script:clock }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock Invoke-WebRequest {
            $script:requests.Add(@{} + $PesterBoundParameters)
            $page = [int] [regex]::Match($Uri, '[?&]page=([0-9]+)$').Groups[1].Value
            if (-not $script:pages.ContainsKey($page)) { throw 'Unexpected extra page.' }
            @{
                StatusCode = $script:httpStatus
                Content    = $script:rawContent ?? (ConvertTo-Json -InputObject $script:pages[$page] -Depth 10 -Compress)
                Headers    = @{ Link = '<https://example.test/foreign/jobs?page=2>; rel="next"'; Location = 'https://example.test/redirect' }
            }
        }
    }

    AfterEach {
        foreach ($name in $savedTokens.Keys) {
            [Environment]::SetEnvironmentVariable($name, $savedTokens[$name])
        }
    }

    It 'Uses the documented check run and event-specific head for <event>' -ForEach @(
        @{ event = 'push' }, @{ event = 'workflow_dispatch' }, @{ event = 'pull_request' }
    ) {
        $jobInput.EventName = $event
        if ($event -eq 'pull_request') { $script:job.head_sha = $jobInput.PullRequestHeadSha }
        $start = Get-GitHubJobStartTime @jobInput
        $start | Should -Be $script:clock.AddMinutes(-10)
        $start.Kind | Should -Be ([DateTimeKind]::Utc)
        $script:requests.Count | Should -Be 1
        $request = $script:requests[0]
        $request.Uri | Should -BeExactly 'https://api.github.com/repos/Azure/bicep-registry-modules/actions/runs/101/attempts/2/jobs?per_page=100&page=1'
        $request.Method | Should -Be 'Get'
        $request.Authentication | Should -Be 'None'
        @($request.Headers.Keys | Sort-Object) | Should -Be @('Accept', 'X-GitHub-Api-Version')
        $request.MaximumRedirection | Should -Be 0
        $request.MaximumRetryCount | Should -Be 0
        $request.ConnectionTimeoutSeconds | Should -Be 20
        $request.OperationTimeoutSeconds | Should -Be 20
        $request.ContainsKey('Credential') | Should -BeFalse
        $request.ContainsKey('Token') | Should -BeFalse
        $request.ContainsKey('UseDefaultCredentials') | Should -BeFalse
        $request | ConvertTo-Json -Depth 5 | Should -Not -Match 'synthetic-token'
        $env:GH_TOKEN | Should -BeExactly 'synthetic-token-not-for-requests-or-errors'
        $env:GITHUB_TOKEN | Should -BeExactly 'synthetic-token-not-for-requests-or-errors'
    }

    It 'Does not substitute the synthetic merge when the pull-request head is missing or mismatched' -ForEach @(
        @{ head = ''; message = 'event-specific workflow head SHA' }
        @{ head = ('b' * 40); message = 'does not match' }
    ) {
        $jobInput.EventName = 'pull_request'
        $jobInput.PullRequestHeadSha = $head
        { Get-GitHubJobStartTime @jobInput } | Should -Throw "*$message*"
    }

    It 'Rejects unsupported or incomplete <field> context before making a request' -ForEach @(
        @{ field = 'ApiUrl'; value = 'https://github.example/api/v3' }
        @{ field = 'ApiUrl'; value = 'http://api.github.com' }
        @{ field = 'ApiUrl'; value = 'https://api.github.com.evil.example' }
        @{ field = 'ApiUrl'; value = 'https://api.github.com/redirect' }
        @{ field = 'Repository'; value = '../private' }
        @{ field = 'Repository'; value = 'Azure/repo?token=synthetic-token' }
        @{ field = 'Repository'; value = 'Azure/%2e%2e' }
        @{ field = 'RunId'; value = '' }
        @{ field = 'RunId'; value = '101/../../jobs' }
        @{ field = 'RunId'; value = '99999999999999999999999' }
        @{ field = 'RunAttempt'; value = '0' }
        @{ field = 'CheckRunId'; value = '' }
        @{ field = 'CheckRunId'; value = '3.03' }
        @{ field = 'RunnerName'; value = ' ' }
        @{ field = 'RunnerEnvironment'; value = 'self-hosted' }
        @{ field = 'EventName'; value = 'pull_request_target' }
        @{ field = 'HeadSha'; value = 'not-a-sha' }
    ) {
        $jobInput[$field] = $value
        { Get-GitHubJobStartTime @jobInput } | Should -Throw
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
    }

    It 'Rejects an inconsistent <field> on the exact check run' -ForEach @(
        @{ field = 'run_id'; value = 999 }
        @{ field = 'run_attempt'; value = 1 }
        @{ field = 'head_sha'; value = ('c' * 40) }
        @{ field = 'runner_name'; value = 'GitHub Actions another runner' }
        @{ field = 'runner_id'; value = 0 }
        @{ field = 'runner_id'; value = $null }
        @{ field = 'status'; value = 'completed' }
        @{ field = 'status'; value = 'queued' }
        @{ field = 'conclusion'; value = 'success' }
        @{ field = 'completed_at'; value = '2026-10-12T07:59:00Z' }
        @{ field = 'started_at'; value = @('2026-10-12T07:50:00Z') }
    ) {
        $script:job[$field] = $value
        { Get-GitHubJobStartTime @jobInput } | Should -Throw
        $script:requests.Count | Should -Be 1
    }

    It 'Rejects a missing or ambiguous check run despite an identical job name and runner' -ForEach @(
        @{ kind = 'missing' }, @{ kind = 'ambiguous' }, @{ kind = 'foreign check URL' }
    ) {
        if ($kind -eq 'ambiguous') {
            $anotherJob = $script:job.Clone()
            $anotherJob.id = 304
            $script:pages[1].jobs += $anotherJob
            $script:pages[1].total_count = 2
        } else {
            $script:job.check_run_url = $kind -eq 'missing' ?
            'https://api.github.com/repos/Azure/bicep-registry-modules/check-runs/999' :
            'https://example.test/repos/Azure/bicep-registry-modules/check-runs/303'
        }
        { Get-GitHubJobStartTime @jobInput } | Should -Throw '*exactly one current check run*'
        $script:requests.Count | Should -Be 1
    }

    It 'Normalizes explicit UTC and offset timestamps without using the machine timezone: <timestamp>' -ForEach @(
        @{ timestamp = '2026-10-12T07:50:00Z' }
        @{ timestamp = '2026-10-12T07:50:00.0000000Z' }
        @{ timestamp = '2026-10-12T09:50:00+02:00' }
        @{ timestamp = '2026-10-12T02:20:00-05:30' }
    ) {
        $script:job.started_at = $timestamp
        $start = Get-GitHubJobStartTime @jobInput
        $start | Should -Be $script:clock.AddMinutes(-10)
        $start.Kind | Should -Be ([DateTimeKind]::Utc)
    }

    It 'Rejects a malformed, offset-free, future or exhausted start: <timestamp>' -ForEach @(
        @{ timestamp = $null }
        @{ timestamp = '' }
        @{ timestamp = 'not-a-date' }
        @{ timestamp = '2026-10-12T07:50:00' }
        @{ timestamp = '2026-10-12T07:50:00+25:00' }
        @{ timestamp = '2026-02-30T07:50:00Z' }
        @{ timestamp = '2026-10-12T08:00:01Z' }
        @{ timestamp = '2026-10-12T02:40:00Z' }
        @{ timestamp = '2026-10-12T02:39:59Z' }
    ) {
        $script:job.started_at = $timestamp
        { Get-GitHubJobStartTime @jobInput } | Should -Throw
    }

    It 'Counts time spent reading metadata against the same job cap' {
        $script:job.started_at = '2026-10-12T02:40:01Z'
        Mock Invoke-WebRequest {
            $script:clock = $script:clock.AddSeconds(1)
            @{ StatusCode = 200; Content = (ConvertTo-Json -InputObject $script:pages[1] -Depth 10 -Compress) }
        }
        { Get-GitHubJobStartTime @jobInput } | Should -Throw '*exhausted*'
        Should -Invoke Invoke-WebRequest -Times 1 -Exactly
    }

    It 'Fails closed without replay, redirects, credentials or response-body logging for HTTP <status>' -ForEach @(
        @{ status = 301 }, @{ status = 302 }, @{ status = 307 }, @{ status = 308 }
        @{ status = 401 }, @{ status = 403 }, @{ status = 404 }, @{ status = 429 }
        @{ status = 500 }, @{ status = 503 }
    ) {
        $script:httpStatus = $status
        $script:rawContent = '{"message":"synthetic-token-not-for-requests-or-errors"}'
        $errorRecord = try { Get-GitHubJobStartTime @jobInput } catch { $_ }
        $errorRecord.Exception.Message | Should -Match 'inaccessible or redirected'
        $errorRecord | Out-String | Should -Not -Match 'synthetic-token'
        $script:requests.Count | Should -Be 1
        $script:requests[0].MaximumRedirection | Should -Be 0
        $script:requests[0].MaximumRetryCount | Should -Be 0
    }

    It 'Sanitizes <kind> failures instead of returning a fallback start' -ForEach @(
        @{ kind = 'network' }, @{ kind = 'invalid JSON' }, @{ kind = 'duplicate property' }
    ) {
        if ($kind -eq 'network') {
            Mock Invoke-WebRequest { throw 'Connection failed: synthetic-token-not-for-requests-or-errors' }
        } elseif ($kind -eq 'invalid JSON') {
            $script:rawContent = 'synthetic-token-not-for-requests-or-errors'
        } else {
            $script:rawContent = (ConvertTo-Json -InputObject $script:pages[1] -Depth 10 -Compress).
            Replace('"total_count":1', '"total_count":1,"total_count":1')
        }
        $errorRecord = try { Get-GitHubJobStartTime @jobInput } catch { $_ }
        $errorRecord | Should -BeOfType [System.Management.Automation.ErrorRecord]
        $errorRecord | Out-String | Should -Not -Match 'synthetic-token'
        Should -Invoke Invoke-WebRequest -Times 1 -Exactly
    }

    It 'Rejects incomplete or excessive pagination (<count>)' -ForEach @(
        @{ count = 0 }, @{ count = -1 }, @{ count = 2 }, @{ count = 2001 }, @{ count = '1' }
    ) {
        $script:pages[1].total_count = $count
        { Get-GitHubJobStartTime @jobInput } | Should -Throw '*malformed, incomplete or ambiguous*'
        $script:requests.Count | Should -Be 1
    }

    Context 'Multiple pages' {
        BeforeEach {
            $otherJobs = @(1..100 | ForEach-Object {
                    @{
                        id            = 1000 + $_
                        check_run_url = "https://api.github.com/repos/Azure/bicep-registry-modules/check-runs/$(1000 + $_)"
                    }
                })
            $script:pages = @{
                1 = @{ total_count = 101; jobs = $otherJobs }
                2 = @{ total_count = 101; jobs = @($script:job) }
            }
        }

        It 'Reads the complete attempt using only the constructed origin and attempt path' {
            Get-GitHubJobStartTime @jobInput | Should -Be $script:clock.AddMinutes(-10)
            $script:requests.Count | Should -Be 2
            @($script:requests.Uri) | Should -Be @(
                'https://api.github.com/repos/Azure/bicep-registry-modules/actions/runs/101/attempts/2/jobs?per_page=100&page=1'
                'https://api.github.com/repos/Azure/bicep-registry-modules/actions/runs/101/attempts/2/jobs?per_page=100&page=2'
            )
            @($script:requests.Uri) -join ' ' | Should -Not -Match 'example\.test'
        }

        It 'Does not accept a matching first page without checking for later ambiguity' {
            $script:pages[1].jobs[0] = $script:job.Clone()
            $script:pages[1].jobs[0].id = 304
            { Get-GitHubJobStartTime @jobInput } | Should -Throw '*exactly one current check run*'
            $script:requests.Count | Should -Be 2
        }

        It 'Rejects <kind> on later pages without returning the previously matched job' -ForEach @(
            @{ kind = 'changed total' }, @{ kind = 'duplicate job' }, @{ kind = 'empty page' }, @{ kind = 'API failure' }
        ) {
            $script:pages[1].jobs[0] = $script:job.Clone()
            $script:pages[1].jobs[0].id = 304
            switch ($kind) {
                'changed total' { $script:pages[2].total_count = 102 }
                'duplicate job' { $script:job.id = 304 }
                'empty page' { $script:pages[2].jobs = @() }
                'API failure' {
                    Mock Invoke-WebRequest { throw 'Later page unavailable.' } -ParameterFilter { $Uri -like '*page=2' }
                }
            }
            { Get-GitHubJobStartTime @jobInput } | Should -Throw
            Should -Invoke Invoke-WebRequest -Times 2 -Exactly
        }
    }
}
