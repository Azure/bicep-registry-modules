<#
.SYNOPSIS
    Pre-deployment health check for Azure Stack HCI cluster.
    Validates all prerequisites that ECE Lite expects before the cluster deploymentSettings resource is created.
    Runs on the host VM and validates AD, DNS, credentials, node connectivity, and LcmController readiness.
#>
param(
    [Parameter()]
    [String]
    $resourceGroupName,

    [Parameter()]
    [String]
    $subscriptionId,

    [Parameter()]
    [int]
    $hciNodeCount,

    [Parameter()]
    [String]
    $userAssignedManagedIdentityClientId,

    [Parameter()]
    [String]
    $domainOUPath = 'OU=HCI,DC=HCI,DC=local',

    [Parameter()]
    [String]
    $deploymentUsername = 'deployUser'
)

Function log {
    Param (
        [string]$message,
        [string]$logPath = 'C:\temp\hciHostDeploy-8.log'
    )

    If (!(Test-Path -Path C:\temp)) {
        New-Item -Path C:\temp -ItemType Directory
    }

    Write-Host $message
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage8-preDeployCheck] - $message"
}

$ErrorActionPreference = 'Stop'

$hciNodeNames = @()
for ($i = 1; $i -le $hciNodeCount; $i++) {
    $hciNodeNames += "hcinode$i"
}

log '========================================='
log 'PRE-DEPLOYMENT HEALTH CHECK - Stage 8'
log '========================================='

$allChecksPass = $true
$failedChecks = @()

# ===========================
# Check 1: AD DS Health
# ===========================
log '[Check 1/6] Validating Active Directory health...'
try {
    $env:ADPS_LoadDefaultDrive = 0
    Import-Module ActiveDirectory -ErrorAction Stop
    $domain = Get-ADDomain -ErrorAction Stop
    log "  AD Domain: $($domain.DNSRoot) - OK"

    # Verify the HCI OU exists
    try {
        $ou = Get-ADOrganizationalUnit -Identity $domainOUPath -ErrorAction Stop
        log "  AD OU '$domainOUPath': EXISTS - OK"
    } catch {
        log "  AD OU '$domainOUPath': NOT FOUND - FAIL"
        $allChecksPass = $false
        $failedChecks += "AD OU '$domainOUPath' not found"
    }

    # Verify deployment user exists in AD
    try {
        $deployUser = Get-ADUser -Identity $deploymentUsername -ErrorAction Stop
        log "  Deployment user '$deploymentUsername': EXISTS - OK"
    } catch {
        log "  Deployment user '$deploymentUsername': NOT FOUND - FAIL"
        $allChecksPass = $false
        $failedChecks += "Deployment user '$deploymentUsername' not found in AD"
    }
} catch {
    log "  AD DS health check failed: $($_.Exception.Message) - FAIL"
    $allChecksPass = $false
    $failedChecks += "AD DS not responsive: $($_.Exception.Message)"
}

# ===========================
# Check 2: DNS Health
# ===========================
log '[Check 2/6] Validating DNS resolution...'
try {
    $dnsResult = Resolve-DnsName -Name 'hci.local' -Type A -ErrorAction Stop
    log "  DNS 'hci.local' resolves to: $($dnsResult.IPAddress -join ', ') - OK"
} catch {
    log "  DNS resolution for 'hci.local' failed: $($_.Exception.Message) - FAIL"
    $allChecksPass = $false
    $failedChecks += "DNS resolution for 'hci.local' failed"
}

# Verify each node is resolvable
foreach ($nodeName in $hciNodeNames) {
    try {
        $nodeResult = Resolve-DnsName -Name "$nodeName.hci.local" -Type A -ErrorAction Stop
        log "  DNS '$nodeName.hci.local' resolves to: $($nodeResult.IPAddress -join ', ') - OK"
    } catch {
        log "  DNS '$nodeName.hci.local' failed: $($_.Exception.Message) - WARN (may not be registered yet)"
    }
}

# ===========================
# Check 3: Node VM Health
# ===========================
log '[Check 3/6] Validating HCI node VMs are running...'
$adminCred = Import-Clixml -Path 'C:\temp\hciHostDeployAdminCred.xml'
$runningVMs = Get-VM | Where-Object { $_.State -eq 'Running' }
$runningVMNames = $runningVMs.Name

foreach ($nodeName in $hciNodeNames) {
    if ($nodeName -in $runningVMNames) {
        log "  VM '$nodeName': Running - OK"
    } else {
        log "  VM '$nodeName': NOT running - FAIL"
        $allChecksPass = $false
        $failedChecks += "HCI node VM '$nodeName' is not running"
    }
}

# ===========================
# Check 4: Node-to-Node connectivity
# ===========================
log '[Check 4/6] Validating node-to-node connectivity via WinRM...'
foreach ($nodeName in $hciNodeNames) {
    try {
        $result = Invoke-Command -VMName $nodeName -Credential $adminCred -ScriptBlock {
            return @{
                ComputerName = $env:COMPUTERNAME
                Uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
            }
        } -ErrorAction Stop
        log "  WinRM to '$nodeName' ($($result.ComputerName)): Connected, last boot: $($result.Uptime) - OK"
    } catch {
        log "  WinRM to '$nodeName': FAILED - $($_.Exception.Message)"
        $allChecksPass = $false
        $failedChecks += "Cannot reach node '$nodeName' via WinRM"
    }
}

# ===========================
# Check 5: Arc Extension readiness (LcmController must be responsive)
# ===========================
log '[Check 5/6] Validating Arc extension readiness on nodes...'
try {
    Login-AzAccount -Identity -Subscription $subscriptionId -AccountId $userAssignedManagedIdentityClientId
    Install-Module -Name Az.ConnectedMachine -Force -AllowClobber -Scope CurrentUser -Repository PSGallery -ErrorAction SilentlyContinue

    foreach ($nodeName in $hciNodeNames) {
        $extensions = Get-AzConnectedMachineExtension -ResourceGroupName $resourceGroupName -MachineName $nodeName -ErrorAction Stop
        $lcm = $extensions | Where-Object { $_.MachineExtensionType -eq 'LcmController' }
        $telemetry = $extensions | Where-Object { $_.MachineExtensionType -eq 'TelemetryAndDiagnostics' }
        $deviceMgmt = $extensions | Where-Object { $_.MachineExtensionType -eq 'DeviceManagementExtension' }
        $remoteSupport = $extensions | Where-Object { $_.MachineExtensionType -eq 'EdgeRemoteSupport' }

        if ($lcm.ProvisioningState -eq 'Succeeded') {
            log "  '$nodeName' LcmController: Succeeded - OK"
        } else {
            log "  '$nodeName' LcmController: $($lcm.ProvisioningState) - FAIL"
            $allChecksPass = $false
            $failedChecks += "'$nodeName' LcmController not in Succeeded state"
        }

        if ($telemetry.ProvisioningState -eq 'Succeeded') {
            log "  '$nodeName' TelemetryAndDiagnostics: Succeeded - OK"
        } else {
            log "  '$nodeName' TelemetryAndDiagnostics: $($telemetry.ProvisioningState) - WARN"
        }

        if ($deviceMgmt.ProvisioningState -eq 'Succeeded') {
            log "  '$nodeName' DeviceManagementExtension: Succeeded - OK"
        } else {
            log "  '$nodeName' DeviceManagementExtension: $($deviceMgmt.ProvisioningState) - WARN"
        }

        if ($remoteSupport.ProvisioningState -eq 'Succeeded') {
            log "  '$nodeName' EdgeRemoteSupport: Succeeded - OK"
        } else {
            log "  '$nodeName' EdgeRemoteSupport: $($remoteSupport.ProvisioningState) - WARN"
        }
    }
} catch {
    log "  Arc extension check failed: $($_.Exception.Message) - FAIL"
    $allChecksPass = $false
    $failedChecks += "Arc extension readiness check failed: $($_.Exception.Message)"
}

# ===========================
# Check 6: Credential validation from nodes
# ===========================
log '[Check 6/6] Validating deployment user credentials on nodes...'
foreach ($nodeName in $hciNodeNames) {
    try {
        $credResult = Invoke-Command -VMName $nodeName -Credential $adminCred -ScriptBlock {
            param($deployUser, $domainFqdn)
            try {
                $searcher = New-Object DirectoryServices.DirectorySearcher
                $searcher.Filter = "(sAMAccountName=$deployUser)"
                $result = $searcher.FindOne()
                if ($result) {
                    return "User '$deployUser' found in domain at: $($result.Path)"
                } else {
                    return "User '$deployUser' NOT found via LDAP search"
                }
            } catch {
                return "LDAP search failed: $($_.Exception.Message)"
            }
        } -ArgumentList $deploymentUsername, 'hci.local' -ErrorAction Stop
        log "  '$nodeName' credential check: $credResult"
    } catch {
        log "  '$nodeName' credential check failed: $($_.Exception.Message) - WARN"
    }
}

# ===========================
# Summary
# ===========================
log '========================================='
log 'PRE-DEPLOYMENT HEALTH CHECK - SUMMARY'
log '========================================='

if ($allChecksPass) {
    log 'ALL CHECKS PASSED - Environment is ready for cluster deployment.'
    log 'Proceeding with a 30-second stabilization wait...'
    Start-Sleep -Seconds 30
    log 'Pre-deployment health check complete.'
} else {
    log "FAILED CHECKS ($($failedChecks.Count)):"
    foreach ($check in $failedChecks) {
        log "  - $check"
    }
    log ''
    log 'Environment is NOT ready for cluster deployment.'
    Write-Error "Pre-deployment health check failed: $($failedChecks -join '; ')" -ErrorAction Stop
}
