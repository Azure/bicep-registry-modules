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
