param ([string] $NotationExecutable = 'notation')

BeforeAll {
    $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
    . (Join-Path $moduleRoot 'scripts' 'Invoke-VerifiedContainerImage.ps1')
    $notation = (Get-Command $NotationExecutable -CommandType Application -ErrorAction Stop).Source
    $version = Invoke-NotationCommand -Executable $notation -Arguments @('version')
    if ($version.ExitCode -ne 0 -or $version.Output -cnotmatch '(?m)^Version:\s+1\.3\.2\s*$') {
        throw 'These offline login regressions require the production-pinned Notation 1.3.2 CLI.'
    }
    $pwsh = (Get-Process -Id $PID).Path
}

Describe 'ACA-LZA actual Notation login without host credential stores' {
    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in @('XDG_CONFIG_HOME', 'APPDATA', 'DOCKER_CONFIG', 'PATH', 'NOTATION_USERNAME', 'NOTATION_PASSWORD',
                'HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'NO_PROXY')) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
        }
        $directory = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($name in @('appdata', 'docker', 'empty-path')) {
            $null = New-Item -ItemType Directory -Path (Join-Path $directory $name) -Force
        }
        $env:XDG_CONFIG_HOME = $directory
        $env:APPDATA = Join-Path $directory 'appdata'
        $env:DOCKER_CONFIG = Join-Path $directory 'docker'
        $env:PATH = Join-Path $directory 'empty-path'
        $env:NOTATION_USERNAME = $null; $env:NOTATION_PASSWORD = $null
        $env:HTTP_PROXY = $null; $env:HTTPS_PROXY = $null; $env:ALL_PROXY = $null
        $env:NO_PROXY = '127.0.0.1,localhost'
        $username = '00000000-0000-0000-0000-000000000000'
        $credential = 'synthetic-offline-refresh'
        $expected = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${username}:$credential"))
        $state = [hashtable]::Synchronized(@{ Stop = $false; Accepted = 0; Rejected = 0 })
        $listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 0)
        $listener.Start()
        $server = "127.0.0.1:$($listener.LocalEndpoint.Port)"
        $worker = Start-ThreadJob -ArgumentList $listener, $state, $expected -ScriptBlock {
            param($Listener, $State, $Expected)
            $deadline = [DateTime]::UtcNow.AddMinutes(1)
            while (-not $State.Stop -and [DateTime]::UtcNow -lt $deadline) {
                if (-not $Listener.Pending()) { Start-Sleep -Milliseconds 20; continue }
                $client = $Listener.AcceptTcpClient()
                try {
                    $client.ReceiveTimeout = 5000
                    $stream = $client.GetStream()
                    $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::ASCII, $false, 1024, $true)
                    $request = $reader.ReadLine()
                    $authorization = ''
                    while ($line = $reader.ReadLine()) {
                        if ($line -match '^Authorization:\s*(.+)$') { $authorization = $Matches[1] }
                    }
                    if ($request -cne 'GET /v2/ HTTP/1.1') { throw 'Unexpected loopback registry request.' }
                    if ($authorization -ceq $Expected) {
                        $State.Accepted++
                        $response = "HTTP/1.1 200 OK`r`nContent-Type: application/json`r`nContent-Length: 2`r`nConnection: close`r`n`r`n{}"
                    } else {
                        if ($authorization) { $State.Rejected++ }
                        $response = "HTTP/1.1 401 Unauthorized`r`nWWW-Authenticate: Basic realm=`"offline`"`r`nContent-Length: 0`r`nConnection: close`r`n`r`n"
                    }
                    $bytes = [Text.Encoding]::ASCII.GetBytes($response)
                    $stream.Write($bytes, 0, $bytes.Length)
                    $stream.Flush()
                    $reader.Dispose()
                } finally { $client.Dispose() }
            }
        }
    }

    AfterEach {
        foreach ($name in $savedEnvironment.Keys) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
        $state.Stop = $true
        $null = Wait-Job $worker -Timeout 5
        $listener.Stop()
        if ($worker.State -ne 'Completed') { Stop-Job $worker }
        $workerErrors = @($worker.ChildJobs | ForEach-Object { $_.Error })
        Remove-Job $worker
        $workerErrors.Count | Should -Be 0
    }

    It 'Distinguishes accepted credentials followed by secure-store failure from rejected authentication' {
        $arguments = @('login', $server, '--username', $username, '--password-stdin', '--insecure-registry')
        $valid = Invoke-NotationCommand -Executable $notation -Arguments $arguments -StandardInput $credential
        $valid.ExitCode | Should -Not -Be 0
        $valid.Error | Should -Match 'credential could not be saved because a credentials store is required'
        $state.Accepted | Should -Be 1
        $state.Rejected | Should -Be 0

        $invalid = Invoke-NotationCommand -Executable $notation -Arguments $arguments -StandardInput 'synthetic-wrong'
        $invalid.ExitCode | Should -Not -Be 0
        $invalid.Error | Should -Match 'failed to validate the credentials'
        $invalid.Error | Should -Match '401'
        $state.Accepted | Should -Be 1
        $state.Rejected | Should -Be 1
        @(Get-ChildItem -LiteralPath $directory -Recurse -File).Count | Should -Be 0
        ($valid.Error + $invalid.Error).Contains($credential) | Should -BeFalse
    }
}

Describe 'ACA-LZA actual process output redaction before diagnostics escape' {
    It 'Clears ambient Notation credentials from a real non-registry child without changing its parent' {
        $savedUsername = $env:NOTATION_USERNAME
        $savedPassword = $env:NOTATION_PASSWORD
        try {
            $env:NOTATION_USERNAME = 'synthetic-ambient-user'
            $env:NOTATION_PASSWORD = 'synthetic-ambient-password'
            $result = Invoke-NotationCommand -Executable $pwsh -Arguments @('-NoLogo', '-NoProfile', '-NonInteractive', '-Command', @'
if ([Environment]::GetEnvironmentVariable('NOTATION_USERNAME') -or [Environment]::GetEnvironmentVariable('NOTATION_PASSWORD')) { exit 1 }
[Console]::Out.WriteLine('no ambient credentials')
'@)
            $result.ExitCode | Should -Be 0
            $result.Output.Trim() | Should -BeExactly 'no ambient credentials'
            $env:NOTATION_USERNAME | Should -BeExactly 'synthetic-ambient-user'
            $env:NOTATION_PASSWORD | Should -BeExactly 'synthetic-ambient-password'
        } finally {
            $env:NOTATION_USERNAME = $savedUsername
            $env:NOTATION_PASSWORD = $savedPassword
        }
    }

    It 'Rejects <Verb> with missing credentials before starting a child' -ForEach @(
        foreach ($verb in @('sign', 'verify')) {
            foreach ($value in @($null, '', ' ')) { @{ Verb = $verb; Credential = $value } }
        }
    ) {
        { Invoke-NotationCommand -Executable 'must-not-start' -Arguments @($Verb) -RegistryCredential $Credential } |
            Should -Throw '*Explicit registry credentials*'
    }

    It 'Rejects credential flag overrides before starting <Verb>: <Flag>' -ForEach @(
        @{ Verb = 'sign'; Flag = '--username=other' }
        @{ Verb = 'verify'; Flag = '--password=other' }
        @{ Verb = 'sign'; Flag = '-uother' }
        @{ Verb = 'verify'; Flag = '-pother' }
    ) {
        { Invoke-NotationCommand -Executable 'must-not-start' -Arguments @($Verb, $Flag) -RegistryCredential 'synthetic' } |
            Should -Throw '*child environment*'
    }

    It 'Rejects accidental credential forwarding to non-registry tools before starting them' {
        { Invoke-NotationCommand -Executable 'must-not-start' -Arguments @('policy', 'import') -RegistryCredential 'synthetic' } |
            Should -Throw '*only accepted for Notation sign and verify*'
    }

    It 'Redacts secret echoes and common encodings from both captured native streams' {
        $secret = 'synthetic-refresh+/= %quoted"value'
        $arguments = @('-NoLogo', '-NoProfile', '-NonInteractive', '-Command', @'
$value = [Console]::In.ReadToEnd().TrimEnd("`r", "`n")
$variants = @(
    $value
    [uri]::EscapeDataString($value)
    [Net.WebUtility]::UrlEncode($value)
    [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($value))
    [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("00000000-0000-0000-0000-000000000000:$value"))
    ($value | ConvertTo-Json -Compress).Trim('"')
)
foreach ($variant in $variants) {
    [Console]::Out.WriteLine($variant)
    [Console]::Error.WriteLine($variant)
}
[Console]::Error.WriteLine('native failure: 401 Unauthorized')
[Console]::Error.WriteLine('Authorization: Bearer synthetic-unknown-authorization')
[Console]::Error.WriteLine('{"refresh_token":"synthetic-unknown-token"}')
exit 1
'@)
        $result = Invoke-NotationCommand -Executable $pwsh -Arguments $arguments -StandardInput $secret
        $result.ExitCode | Should -Be 1
        $variants = @(
            $secret
            [uri]::EscapeDataString($secret)
            [Net.WebUtility]::UrlEncode($secret)
            [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($secret))
            [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("00000000-0000-0000-0000-000000000000:$secret"))
            ($secret | ConvertTo-Json -Compress).Trim('"')
            'synthetic-unknown-authorization'
            'synthetic-unknown-token'
        )
        foreach ($variant in $variants) {
            ($result.Output + $result.Error).Contains($variant) | Should -BeFalse
        }
        $result.Output | Should -Match '\[redacted\]'
        $result.Error | Should -Match 'native failure: 401 Unauthorized'
    }
}

Describe 'ACA-LZA actual pinned sign and verify with child-only registry credentials' {
    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in @('XDG_CONFIG_HOME', 'APPDATA', 'DOCKER_CONFIG', 'PATH', 'NOTATION_USERNAME', 'NOTATION_PASSWORD',
                'HTTP_PROXY', 'HTTPS_PROXY', 'ALL_PROXY', 'NO_PROXY')) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
        }
        $directory = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($name in @('appdata', 'docker', 'empty-path')) {
            $null = New-Item -ItemType Directory -Path (Join-Path $directory $name) -Force
        }
        $env:XDG_CONFIG_HOME = $directory
        $env:APPDATA = Join-Path $directory 'appdata'
        $env:DOCKER_CONFIG = Join-Path $directory 'docker'
        $env:PATH = Join-Path $directory 'empty-path'
        $env:NOTATION_USERNAME = 'synthetic-ambient-user'
        $env:NOTATION_PASSWORD = 'synthetic-ambient-password'
        $env:HTTP_PROXY = $null; $env:HTTPS_PROXY = $null; $env:ALL_PROXY = $null
        $env:NO_PROXY = '127.0.0.1,localhost'
        $credential = 'synthetic-child-refresh+/= %quoted"value'
        $suppliedCredential = $Scenario -ceq 'wrong' ? 'synthetic-wrong' : $credential
        $username = '00000000-0000-0000-0000-000000000000'
        $expectedBasic = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("${username}:$credential"))
        $token = 'synthetic-loopback-token'
        $echoes = @(
            $credential
            [uri]::EscapeDataString($credential)
            [Net.WebUtility]::UrlEncode($credential)
            [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credential))
            $expectedBasic
            ($credential | ConvertTo-Json -Compress).Trim('"')
        )
        $reason = 'synthetic authenticated manifest boundary'
        $failureStatus = $Scenario -ceq 'secret-echo' ? [uri]::EscapeDataString($credential) : '404'
        $state = [hashtable]::Synchronized(@{
                Stop = $false; Accepted = 0; Rejected = 0; TokenAccepted = 0; BearerAccepted = 0; Manifests = 0; Unexpected = 0
            })
        $listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 0)
        $listener.Start()
        $server = "127.0.0.1:$($listener.LocalEndpoint.Port)"
        $worker = Start-ThreadJob -ArgumentList $listener, $state, $expectedBasic, $token, $Challenge, $server, $reason, $failureStatus -ScriptBlock {
            param($Listener, $State, $ExpectedBasic, $Token, $Challenge, $Server, $Reason, $FailureStatus)
            $deadline = [DateTime]::UtcNow.AddMinutes(1)
            while (-not $State.Stop -and [DateTime]::UtcNow -lt $deadline) {
                if (-not $Listener.Pending()) { Start-Sleep -Milliseconds 20; continue }
                $client = $Listener.AcceptTcpClient()
                try {
                    $client.ReceiveTimeout = 5000
                    $stream = $client.GetStream()
                    $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::ASCII, $false, 1024, $true)
                    $request = $reader.ReadLine()
                    $authorization = ''
                    while ($line = $reader.ReadLine()) {
                        if ($line -match '^Authorization:\s*(.+)$') { $authorization = $Matches[1] }
                    }
                    $headers = ''
                    $status = '401 Unauthorized'
                    if ($request -match '^GET /oauth2/token\?' -and $Challenge -ceq 'Bearer') {
                        $uri = [uri] "http://$Server/$($request.Split(' ')[1].TrimStart('/'))"
                        if ($uri.Query -notmatch 'service=' -or [uri]::UnescapeDataString($uri.Query) -notmatch 'repository:aca-lza/probe:pull') {
                            $State.Unexpected++
                        }
                        if ($authorization -ceq $ExpectedBasic) {
                            $State.Accepted++; $State.TokenAccepted++
                            $status = '200 OK'
                            $body = '{"token":"' + $Token + '"}'
                        } else {
                            if ($authorization) { $State.Rejected++ }
                            $body = ''
                        }
                    } elseif ($request -match '^(GET|HEAD) /v2/aca-lza/probe/manifests/') {
                        $accepted = $Challenge -ceq 'Basic' ? $authorization -ceq $ExpectedBasic : $authorization -ceq "Bearer $Token"
                        if ($accepted) {
                            if ($Challenge -ceq 'Basic') { $State.Accepted++ } else { $State.BearerAccepted++ }
                            $State.Manifests++
                            $status = "$FailureStatus $Reason"
                            $body = @{ errors = @(@{ code = 'UNKNOWN'; message = $Reason }) } | ConvertTo-Json -Depth 4 -Compress
                        } else {
                            if ($authorization -and $Challenge -ceq 'Basic') { $State.Rejected++ }
                            $challengeValue = $Challenge -ceq 'Basic' ? 'Basic realm="offline"' :
                            "Bearer realm=`"http://$Server/oauth2/token`",service=`"$Server`",scope=`"repository:aca-lza/probe:pull`""
                            $headers = "WWW-Authenticate: $challengeValue`r`n"
                            $body = ''
                        }
                    } else {
                        $State.Unexpected++
                        $status = '400 Bad Request'
                        $body = ''
                    }
                    $length = [Text.Encoding]::UTF8.GetByteCount($body)
                    if ($request.StartsWith('HEAD ')) { $body = '' }
                    $response = "HTTP/1.1 $status`r`n${headers}Content-Type: application/json`r`nContent-Length: $length`r`nConnection: close`r`n`r`n$body"
                    $bytes = [Text.Encoding]::UTF8.GetBytes($response)
                    $stream.Write($bytes, 0, $bytes.Length)
                    $stream.Flush()
                    $reader.Dispose()
                } finally { $client.Dispose() }
            }
        }
        $configuration = Join-Path ($IsWindows ? $env:APPDATA : $env:XDG_CONFIG_HOME) 'notation'
        $plugin = Join-Path $configuration 'plugins' 'probe' ($IsWindows ? 'notation-probe.exe' : 'notation-probe')
        $null = New-Item -ItemType Directory -Path (Split-Path $plugin) -Force
        [IO.File]::WriteAllBytes($plugin, [byte[]]::new(0))
        if (-not $IsWindows) {
            [IO.File]::SetUnixFileMode($plugin, [IO.UnixFileMode] 'UserRead,UserWrite,UserExecute')
        }
        $policy = @{
            version = '1.0'
            trustPolicies = @(@{
                    name = 'offline-command-auth'; registryScopes = @("$server/aca-lza/probe")
                    signatureVerification = @{ level = 'strict' }; trustStores = @('ca:probe')
                    trustedIdentities = @('x509.subject: CN=offline-probe, O=AVM Tests, ST=Washington, C=US')
                })
        }
        $null = New-Item -ItemType Directory -Path (Join-Path $configuration 'truststore' 'x509' 'ca' 'probe') -Force
        $policy | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $configuration 'trustpolicy.json')
    }

    AfterEach {
        $state.Stop = $true
        $null = Wait-Job $worker -Timeout 5
        $listener.Stop()
        if ($worker.State -ne 'Completed') { Stop-Job $worker }
        $workerErrors = @($worker.ChildJobs | ForEach-Object { $_.Error })
        Remove-Job $worker
        foreach ($name in $savedEnvironment.Keys) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
        $workerErrors.Count | Should -Be 0
    }

    It 'Exercises native <Verb>/<Challenge>/<Scenario> through the production process helper, stopping before cryptography' -ForEach @(
        foreach ($challenge in @('Basic', 'Bearer')) {
            foreach ($verb in @('sign', 'verify')) {
                foreach ($scenario in @('valid', 'wrong', 'secret-echo')) {
                    @{ Challenge = $challenge; Verb = $verb; Scenario = $scenario }
                }
            }
        }
    ) {
        $arguments = @($Verb, '--insecure-registry')
        if ($Verb -ceq 'sign') { $arguments += @('--id', 'synthetic-unused-key', '--plugin', 'probe') }
        $arguments += "$server/aca-lza/probe@sha256:$('1' * 64)"
        $result = Invoke-NotationCommand -Executable $notation -Arguments $arguments -RegistryCredential $suppliedCredential
        $result.ExitCode | Should -Not -Be 0
        $state.Unexpected | Should -Be 0
        if ($Scenario -ceq 'wrong') {
            $state.Accepted | Should -Be 0
            $state.Rejected | Should -BeGreaterThan 0
            $state.Manifests | Should -Be 0
            $result.Error | Should -Match '401'
        } else {
            $state.Accepted | Should -BeGreaterThan 0
            $state.Manifests | Should -BeGreaterThan 0
            $result.Error | Should -Match ($Scenario -ceq 'secret-echo' ? 'malformed HTTP status code' : 'not found')
            if ($Challenge -ceq 'Bearer') {
                $state.TokenAccepted | Should -BeGreaterThan 0
                $state.BearerAccepted | Should -BeGreaterThan 0
            }
            if ($Scenario -ceq 'secret-echo') { $result.Error | Should -Match '\[redacted\]' }
        }
        $result.Error | Should -Not -Match 'credential could not be saved'
        foreach ($echo in @($echoes) + @($suppliedCredential)) {
            ($result.Output + $result.Error).Contains($echo) | Should -BeFalse
            foreach ($file in Get-ChildItem -LiteralPath $directory -Recurse -File) {
                [Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($file.FullName)).Contains($echo) | Should -BeFalse
            }
        }
        @(Get-ChildItem -LiteralPath $directory -Recurse -File | Where-Object Name -In @('config.json', 'signingkeys.json')).Count | Should -Be 0
        $arguments | Should -Not -Contain $suppliedCredential
        $env:NOTATION_USERNAME | Should -BeExactly 'synthetic-ambient-user'
        $env:NOTATION_PASSWORD | Should -BeExactly 'synthetic-ambient-password'
        (Get-Item -LiteralPath $plugin).Length | Should -Be 0
    }
}
