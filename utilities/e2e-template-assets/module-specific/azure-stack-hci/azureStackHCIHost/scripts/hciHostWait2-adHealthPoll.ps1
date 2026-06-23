<#
.SYNOPSIS
    Polls Active Directory health after VM reboot instead of using a fixed sleep.
    Waits until AD DS is fully initialized and responsive before proceeding.
#>

$ErrorActionPreference = 'Stop'

$maxWaitMinutes = 20
$pollIntervalSeconds = 30
$timer = [System.Diagnostics.Stopwatch]::StartNew()

Write-Output "Waiting up to $maxWaitMinutes minutes for Active Directory to be fully initialized after reboot..."

# Initial minimum wait to allow the VM to complete reboot and begin starting services
Write-Output 'Initial 90-second wait for VM reboot completion...'
Start-Sleep -Seconds 90

$adReady = $false
while (-not $adReady -and $timer.Elapsed.TotalMinutes -lt $maxWaitMinutes) {
    try {
        # Check 1: AD Web Services must be running (required for AD PowerShell cmdlets)
        $adwsService = Get-Service -Name 'ADWS' -ErrorAction SilentlyContinue
        if ($adwsService.Status -ne 'Running') {
            Write-Output "[$([math]::Round($timer.Elapsed.TotalSeconds))s] AD Web Services not yet running (Status: $($adwsService.Status)). Waiting..."
            Start-Sleep -Seconds $pollIntervalSeconds
            continue
        }

        # Check 2: DNS Server service must be running
        $dnsService = Get-Service -Name 'DNS' -ErrorAction SilentlyContinue
        if ($dnsService.Status -ne 'Running') {
            Write-Output "[$([math]::Round($timer.Elapsed.TotalSeconds))s] DNS Server service not yet running (Status: $($dnsService.Status)). Waiting..."
            Start-Sleep -Seconds $pollIntervalSeconds
            continue
        }

        # Check 3: NTDS (AD DS) service must be running
        $ntdsService = Get-Service -Name 'NTDS' -ErrorAction SilentlyContinue
        if ($ntdsService.Status -ne 'Running') {
            Write-Output "[$([math]::Round($timer.Elapsed.TotalSeconds))s] NTDS service not yet running (Status: $($ntdsService.Status)). Waiting..."
            Start-Sleep -Seconds $pollIntervalSeconds
            continue
        }

        # Check 4: Can query AD domain (proves AD is actually responding)
        $env:ADPS_LoadDefaultDrive = 0
        Import-Module ActiveDirectory -ErrorAction Stop
        $domain = Get-ADDomain -ErrorAction Stop
        if (-not $domain) {
            Write-Output "[$([math]::Round($timer.Elapsed.TotalSeconds))s] Get-ADDomain returned null. Waiting..."
            Start-Sleep -Seconds $pollIntervalSeconds
            continue
        }

        # Check 5: Can resolve the domain name via DNS
        $dnsResult = Resolve-DnsName -Name $domain.DNSRoot -ErrorAction Stop
        if (-not $dnsResult) {
            Write-Output "[$([math]::Round($timer.Elapsed.TotalSeconds))s] DNS resolution for '$($domain.DNSRoot)' failed. Waiting..."
            Start-Sleep -Seconds $pollIntervalSeconds
            continue
        }

        Write-Output "[$([math]::Round($timer.Elapsed.TotalSeconds))s] Active Directory is fully initialized and responsive."
        Write-Output "  Domain: $($domain.DNSRoot)"
        Write-Output "  Domain Controller: $($domain.PDCEmulator)"
        Write-Output "  DNS resolves: $($dnsResult.IPAddress -join ', ')"
        $adReady = $true

    } catch {
        Write-Output "[$([math]::Round($timer.Elapsed.TotalSeconds))s] AD not ready yet: $($_.Exception.Message). Waiting..."
        Start-Sleep -Seconds $pollIntervalSeconds
    }
}

if (-not $adReady) {
    Write-Error "Active Directory did not become ready within $maxWaitMinutes minutes. Last services state - ADWS: $((Get-Service -Name 'ADWS' -ErrorAction SilentlyContinue).Status), DNS: $((Get-Service -Name 'DNS' -ErrorAction SilentlyContinue).Status), NTDS: $((Get-Service -Name 'NTDS' -ErrorAction SilentlyContinue).Status)" -ErrorAction Stop
} else {
    # Extra buffer after AD is confirmed ready - allow replication and cache warming
    Write-Output 'AD confirmed ready. Waiting additional 60 seconds for replication and cache warming...'
    Start-Sleep -Seconds 60
    Write-Output 'AD health check complete. Proceeding to next stage.'
}
