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
    $userAssignedManagedIdentityClientId

)
Function log {
    Param (
        [string]$message,
        [string]$logPath = 'C:\temp\hciHostDeploy-7.log'
    )

    If (!(Test-Path -Path C:\temp)) {
        New-Item -Path C:\temp -ItemType Directory
    }

    Write-Host $message
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage7] - $message"
}

$ErrorActionPreference = 'Stop'

$hciNodeNames = @()
for ($i = 1; $i -le $hciNodeCount; $i++) {
    $hciNodeNames += "hcinode$i"
}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Az.ConnectedMachine -Force -AllowClobber -Scope CurrentUser -Repository PSGallery -ErrorAction SilentlyContinue
Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted

log "Logging in to Azure with user-assigned managed identity '$($userAssignedManagedIdentityClientId)'..."
Login-AzAccount -Identity -Subscription $subscriptionId -AccountId $userAssignedManagedIdentityClientId

log "Waiting for HCI Arc Machines to exist in the resource group '$($resourceGroupName)'..."

$timer = [System.Diagnostics.Stopwatch]::StartNew()
While (($arcMachines = Get-AzConnectedMachine -ResourceGroupName $resourceGroupName | Where-Object { $_.name -in ($hciNodeNames) }).Count -lt $hciNodeNames.Count -and $timer.Elapsed.TotalMinutes -lt 60) {
    log "Found '$($arcMachines.Count)' HCI Arc Machines, waiting for '$($hciNodeNames.Count)' machines for up to 1 hour..."
    Start-Sleep -Seconds 30
}
If ($timer.Elapsed.TotalMinutes -gt 60) {
    log 'HCI Arc Machines did not exist within the 1 hour timeout period'
    Write-Error 'HCI Arc Machines did not exist within the 1 hour timeout period' -ErrorAction Stop
    Exit 1
} Else {
    log "All HCI Arc Machines exist in the resource group '$($resourceGroupName)'"
}

log 'Waiting up to two hours for HCI Arc Machine extensions to be installed...'
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$allExtensionsReady = $false
while (!$allExtensionsReady -and $timer.Elapsed.TotalMinutes -lt 120) {
    $allExtensionsReadyCheck = $true
    foreach ($arcMachine in $arcMachines) {
        $extensions = Get-AzConnectedMachineExtension -ResourceGroupName $resourceGroupName -MachineName $arcMachine.Name
        if ($extensions.MachineExtensionType -notcontains 'TelemetryAndDiagnostics' -or $extensions.MachineExtensionType -notcontains 'DeviceManagementExtension' -or $extensions.MachineExtensionType -notcontains 'LcmController' -or $extensions.MachineExtensionType -notcontains 'EdgeRemoteSupport') {
            log "Waiting for extensions to be installed on HCI Arc Machine '$($arcMachine.Name)'..."

            # install extensions if not already installed
            log "Installing any missing extensions on HCI Arc Machine '$($arcMachine.Name)'..."
            $extensionParams = @{
                ResourceGroupName = $resourceGroupName
                MachineName       = $arcMachine.Name
                Location          = $arcMachine.Location
                ErrorAction       = 'Continue'
            }

            # Invoke-AzStackHciArcInitialization seemingly misses installing some extensions some of the time - so we'll install them here if missing
            If ($extensions.MachineExtensionType -notcontains 'TelemetryAndDiagnostics') {
                log "Installing TelemetryAndDiagnostics extension on HCI Arc Machine '$($arcMachine.Name)'..."
                New-AzConnectedMachineExtension -Name 'AzureEdgeTelemetryAndDiagnostics' -Publisher 'Microsoft.AzureStack.Observability' -ExtensionType 'TelemetryAndDiagnostics' -NoWait @extensionParams
            }
            If ($extensions.MachineExtensionType -notcontains 'DeviceManagementExtension') {
                log "Installing DeviceManagementExtension extension on HCI Arc Machine '$($arcMachine.Name)'..."
                New-AzConnectedMachineExtension -Name 'AzureEdgeDeviceManagement' -Publisher 'Microsoft.Edge' -ExtensionType 'DeviceManagementExtension' -NoWait @extensionParams
            }
            If ($extensions.MachineExtensionType -notcontains 'LcmController') {
                log "Installing LcmController extension on HCI Arc Machine '$($arcMachine.Name)'..."
                New-AzConnectedMachineExtension -Name 'AzureEdgeLifecycleManager' -Publisher 'Microsoft.AzureStack.Orchestration' -ExtensionType 'LcmController' -NoWait @extensionParams
            }
            If ($extensions.MachineExtensionType -notcontains 'EdgeRemoteSupport') {
                log "Installing EdgeRemoteSupport extension on HCI Arc Machine '$($arcMachine.Name)'..."
                New-AzConnectedMachineExtension -Name 'AzureEdgeRemoteSupport' -Publisher 'Microsoft.AzureStack.Observability' -ExtensionType 'EdgeRemoteSupport' -NoWait @extensionParams
            }

            $allExtensionsReadyCheck = $false
            continue
        } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'TelemetryAndDiagnostics').ProvisioningState -ne 'Succeeded') {
            log "Waiting for TelemetryAndDiagnostics extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
            $allExtensionsReadyCheck = $false
        } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'DeviceManagementExtension').ProvisioningState -ne 'Succeeded') {
            log "Waiting for DeviceManagementExtension extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
            $allExtensionsReadyCheck = $false
        } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'LcmController').ProvisioningState -ne 'Succeeded') {
            log "Waiting for LcmController extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
            $allExtensionsReadyCheck = $false
        } elseIf (($extensionState = $extensions | Where-Object MachineExtensionType -EQ 'EdgeRemoteSupport').ProvisioningState -ne 'Succeeded') {
            log "Waiting for EdgeRemoteSupport extension to be installed on HCI Arc Machine '$($arcMachine.Name)'. Current state: '$($extensionState.ProvisioningState)'..."
            $allExtensionsReadyCheck = $false
        } else {
            log "All extensions are installed and ready on HCI Arc Machine '$($arcMachine.Name)'"
        }
    }
    $allExtensionsReady = $allExtensionsReadyCheck
    If (!$allExtensionsReady) {
        log 'waiting 30 seconds to check extensions again...'
        Start-Sleep -Seconds 30
    }
}

If (!$allExtensionsReady) {
    log 'Extensions did not install within the two hour timeout period'
    Exit 1
} Else {
    log 'All extensions are installed and ready on all HCI Arc Machines'
}

# import local administrator credential (exported in stage 6)
log "Re-importing local '$($adminUsername)' credential..."
$adminCred = Import-Clixml -Path 'C:\temp\hciHostDeployAdminCred.xml'

# name net adapters - seems to be required on 2405
log 'Renaming network adapters on HCI nodes...'
$vmNicLocalNamingOut = Invoke-Command -VMName (Get-VM).Name -Credential $adminCred {
    $ErrorActionPreference = 'Stop'

    Get-NetAdapter | ForEach-Object {
        $adapter = $_

        try {
            Write-Output "Getting Hyper-V network adapter name for '$($adapter.Name)' on VM '$($env:COMPUTERNAME)'..."
            $newAdapterName = Get-NetAdapterAdvancedProperty -RegistryKeyword HyperVNetworkAdapterName -Name $adapter.Name | Select-Object -ExpandProperty DisplayValue
        } catch {
            Write-Output "Failed to get Hyper-V network adapter name for '$($adapter.Name)' on VM '$($env:COMPUTERNAME)'. Ensure DeviceNaming is turned on for the VM Network Adapter! $_ Exiting..."
            Write-Error "Failed to get Hyper-V network adapter name for '$($adapter.Name)'  on VM '$($env:COMPUTERNAME)'. Ensure DeviceNaming is turned on for the VM Network Adapter! $_ Exiting..." -ErrorAction Stop
            Exit 1
        }

        If ($adapter.InterfaceAlias -ne $newAdapterName) {
            Write-Output "Renaming network adapter '$($adapter.InterfaceAlias)' to '$newAdapterName'  on VM '$($env:COMPUTERNAME)'..."
            Rename-NetAdapter -Name $adapter.Name -NewName $newAdapterName
        } Else {
            Write-Output "Network adapter '$($adapter.InterfaceAlias)' is already named correctly on VM '$($env:COMPUTERNAME)'..."
        }
    }
}
log "VM NIC local naming output: $vmNicLocalNamingOut"

# change dynamically assigned FABRIC IP addresses to static IPs as required by validation
log 'Changing dynamically assigned FABRIC IP addresses to static IPs on HCI nodes...'
$ipChangeOutput = Invoke-Command -VMName (Get-VM).Name -Credential $adminCred {
    $ErrorActionPreference = 'Stop'

    $dhcpIpConfig = Get-NetIPConfiguration -InterfaceAlias 'FABRIC'
    $prefixLength = Get-NetIPAddress -InterfaceAlias 'FABRIC' -AddressFamily IPv4 | Select-Object -ExpandProperty PrefixLength
    $dnsClientConfig = Get-DnsClientServerAddress -InterfaceAlias 'FABRIC' -AddressFamily IPv4 | Select-Object -ExpandProperty ServerAddresses

    try {
        If (!(Get-NetIPInterface -InterfaceAlias 'FABRIC' -Dhcp Enabled -ErrorAction SilentlyContinue)) {
            Write-Output "[$env:computerName]DHCP is already disabled on network interface 'FABRIC'..."
        } Else {
            Write-Output "[$env:computerName]Disabling DHCP on network interface 'FABRIC'..."
            Set-NetIPInterface -InterfaceAlias 'FABRIC' -Dhcp Disabled
        }
    } catch {
        Write-Output "[$env:computerName]Failed to disable DHCP on network interface 'FABRIC'. Error message: $_. Exiting..."
        Write-Error "[$env:computerName]Failed to disable DHCP on network interface 'FABRIC'. Error message: $_. Exiting..." -ErrorAction Stop
        Exit 1
    }

    try {
        If (!(Get-NetIPAddress -IPAddress $dhcpIpConfig.IPv4Address.ipAddress -InterfaceAlias 'FABRIC' -ErrorAction SilentlyContinue)) {
            Write-Output "[$env:computerName]Setting static IP address on network interface 'FABRIC'..."
            New-NetIPAddress -InterfaceAlias 'FABRIC' -IPAddress $dhcpIpConfig.IPv4Address.ipAddress -DefaultGateway $dhcpIpConfig.Ipv4DefaultGateway.NextHop -AddressFamily IPv4 -PrefixLength $prefixLength
        } Else {
            Write-Output "[$env:computerName]Static IP address already set on network interface 'FABRIC'..."
        }
    } catch {
        Write-Output "[$env:computerName]Failed to set static IP address on network interface 'FABRIC'. Error message: $_. Exiting..."
        Write-Error "[$env:computerName]Failed to set static IP address on network interface 'FABRIC'. Error message: $_. Exiting..." -ErrorAction Stop
        Exit 1
    }

    try {
        Write-Output "[$env:computerName]Setting DNS server addresses on network interface 'FABRIC' to '$dnsClientConfig'..."
        Set-DnsClientServerAddress -InterfaceAlias 'FABRIC' -ResetServerAddresses
        Set-DnsClientServerAddress -InterfaceAlias 'FABRIC' -ServerAddresses $dnsClientConfig
    } catch {
        Write-Output "[$env:computerName]Failed to set DNS server addresses on network interface 'FABRIC'. Error message: $_. Exiting..."
        Write-Error "[$env:computerName]Failed to set DNS server addresses on network interface 'FABRIC'. Error message: $_. Exiting..." -ErrorAction Stop
        Exit 1
    }
}
log "IP change output: $ipChangeOutput"

# change dynamically assigned FABRIC2 IP addresses to static IPs as required by validation
log 'Changing dynamically assigned FABRIC2 IP addresses to static IPs on HCI nodes...'
$ipChangeOutput2 = Invoke-Command -VMName (Get-VM).Name -Credential $adminCred {
    $ErrorActionPreference = 'Stop'

    $dhcpIpConfig2 = Get-NetIPConfiguration -InterfaceAlias 'FABRIC2'
    $prefixLength2 = Get-NetIPAddress -InterfaceAlias 'FABRIC2' -AddressFamily IPv4 | Select-Object -ExpandProperty PrefixLength

    try {
        If (!(Get-NetIPInterface -InterfaceAlias 'FABRIC2' -Dhcp Enabled -ErrorAction SilentlyContinue)) {
            Write-Output "[$env:computerName]DHCP is already disabled on network interface 'FABRIC2'..."
        } Else {
            Write-Output "[$env:computerName]Disabling DHCP on network interface 'FABRIC2'..."
            Set-NetIPInterface -InterfaceAlias 'FABRIC2' -Dhcp Disabled
        }
    } catch {
        Write-Output "[$env:computerName]Failed to disable DHCP on network interface 'FABRIC2'. Error message: $_. Exiting..."
        Write-Error "[$env:computerName]Failed to disable DHCP on network interface 'FABRIC2'. Error message: $_. Exiting..." -ErrorAction Stop
        Exit 1
    }

    try {
        If (!(Get-NetIPAddress -IPAddress $dhcpIpConfig2.IPv4Address.ipAddress -InterfaceAlias 'FABRIC2' -ErrorAction SilentlyContinue)) {
            Write-Output "[$env:computerName]Setting static IP address on network interface 'FABRIC2'..."
            New-NetIPAddress -InterfaceAlias 'FABRIC2' -IPAddress $dhcpIpConfig2.IPv4Address.ipAddress -AddressFamily IPv4 -PrefixLength $prefixLength2
        } Else {
            Write-Output "[$env:computerName]Static IP address already set on network interface 'FABRIC2'..."
        }
    } catch {
        Write-Output "[$env:computerName]Failed to set static IP address on network interface 'FABRIC2'. Error message: $_. Exiting..."
        Write-Error "[$env:computerName]Failed to set static IP address on network interface 'FABRIC2'. Error message: $_. Exiting..." -ErrorAction Stop
        Exit 1
    }
}
log "IP change output (FABRIC2): $ipChangeOutput2"

# ============================================= #
# NTP Configuration                              #
# ============================================= #

# Step 1 - Configure DC host to sync from external NTP (time.windows.com)
# The DC is the authoritative time source for the domain
log 'Configuring NTP on DC host (time.windows.com)...'
w32tm /config /manualpeerlist:"time.windows.com" /syncfromflags:manual /reliable:YES /update
Stop-Service W32Time -Force -ErrorAction SilentlyContinue
Start-Service W32Time
Start-Sleep -Seconds 5
w32tm /resync /force
log "DC NTP status: $(w32tm /query /status | Out-String)"

# Step 2 - Configure HCI nodes to sync from DC (172.20.0.1)
# Disable VM IC Time Synchronization and point to DC instead
log 'Configuring NTP on HCI nodes to sync from DC at 172.20.0.1...'
$ntpOutput = Invoke-Command -VMName (Get-VM).Name -Credential $adminCred {
    $ErrorActionPreference = 'Stop'

    # Disable VM IC Time Synchronization provider - not valid for HCI deployment validation
    Write-Output "[$env:COMPUTERNAME] Disabling VM IC Time Synchronization provider..."
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\W32Time\TimeProviders\VMICTimeProvider" /v Enabled /t REG_DWORD /d 0 /f

    # Configure NTP to sync from domain controller at 172.20.0.1
    Write-Output "[$env:COMPUTERNAME] Configuring NTP server to DC at 172.20.0.1..."
    w32tm /config /manualpeerlist:"172.20.0.1" /syncfromflags:manual /reliable:YES /update
    Stop-Service W32Time -Force -ErrorAction SilentlyContinue
    Start-Service W32Time
    Start-Sleep -Seconds 5
    w32tm /resync /force

    # Verify NTP sync
    $ntpStatus = w32tm /query /status | Out-String
    Write-Output "[$env:COMPUTERNAME] NTP status: $ntpStatus"
}
log "NTP configuration output: $ntpOutput"

# ============================================= #
# Network Connectivity Validation from HCI nodes #
# ============================================= #
log 'Validating outbound network connectivity from HCI nodes to required Azure endpoints...'
$connectivityOutput = Invoke-Command -VMName (Get-VM).Name -Credential $adminCred {
    $ErrorActionPreference = 'Stop'

    $endpoints = @(
        @{ Host = 'login.microsoftonline.com'; Port = 443; Description = 'Azure AD authentication' }
        @{ Host = 'management.azure.com'; Port = 443; Description = 'Azure Resource Manager' }
        @{ Host = 'dp.stackhci.azure.com'; Port = 443; Description = 'Azure Stack HCI data plane' }
        @{ Host = 'azurestackhci.azurefd.net'; Port = 443; Description = 'Azure Stack HCI front door' }
    )

    $allPassed = $true
    foreach ($ep in $endpoints) {
        $maxRetries = 3
        $connected = $false
        for ($retry = 1; $retry -le $maxRetries; $retry++) {
            try {
                $tcp = New-Object System.Net.Sockets.TcpClient
                $asyncResult = $tcp.BeginConnect($ep.Host, $ep.Port, $null, $null)
                $wait = $asyncResult.AsyncWaitHandle.WaitOne(10000, $false) # 10s timeout
                if ($wait -and $tcp.Connected) {
                    $tcp.EndConnect($asyncResult)
                    Write-Output ("[$env:COMPUTERNAME] OK: {0}:{1} ({2})" -f $ep.Host, $ep.Port, $ep.Description)
                    $connected = $true
                    $tcp.Close()
                    break
                } else {
                    $tcp.Close()
                    throw "Connection timed out"
                }
            } catch {
                    Write-Output ("[$env:COMPUTERNAME] RETRY {0}/{1}: {2}:{3} - {4}" -f $retry, $maxRetries, $ep.Host, $ep.Port, $_.Exception.Message)
                if ($retry -lt $maxRetries) { Start-Sleep -Seconds 10 }
            }
        }
        if (-not $connected) {
            Write-Output ("[$env:COMPUTERNAME] FAIL: {0}:{1} ({2}) - unreachable after {3} attempts" -f $ep.Host, $ep.Port, $ep.Description, $maxRetries)
            $allPassed = $false
        }
    }

    # Also validate DNS resolution for the domain
    try {
        $domainDns = Resolve-DnsName -Name 'hci.local' -ErrorAction Stop
        Write-Output "[$env:COMPUTERNAME] OK: DNS resolution for 'hci.local' -> $($domainDns.IPAddress -join ', ')"
    } catch {
        Write-Output "[$env:COMPUTERNAME] WARN: DNS resolution for 'hci.local' failed: $($_.Exception.Message)"
    }

    if (-not $allPassed) {
        Write-Error "[$env:COMPUTERNAME] One or more Azure endpoints are unreachable. Cluster deployment will likely fail." -ErrorAction Stop
    }
}
log "Network connectivity validation output: $connectivityOutput"