[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $adminUsername,

    [Parameter()]
    [string]
    $adminPw,

    [Parameter()]
    [int]
    $hciNodeCount,

    [Parameter()]
    [string]
    $switchlessStorageConfig = 'switched'
)

Function log {
    Param (
        [string]$message,
        [string]$logPath = 'C:\temp\hciHostDeploy-5.log'
    )

    If (!(Test-Path -Path C:\temp)) {
        New-Item -Path C:\temp -ItemType Directory
    }

    Write-Host $message
    Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage5] - $message"
}

Function Test-ADConnection {
    try {
        If ((Get-Service -Name 'ADWS' -ErrorAction SilentlyContinue).Status -ne 'Running') { return $false }
        $env:ADPS_LoadDefaultDrive = 0
        Import-Module -Name ActiveDirectory -ErrorAction Stop
        [bool](Get-ADDomainController -Server $env:COMPUTERNAME -ErrorAction SilentlyContinue)
    } catch {
        $false
    }
}

$ErrorActionPreference = 'Stop'

# Prepare VMMS for fresh switch creation after sysprep /mode:vm + gallery image redeployment.
#
# Problem: gallery image v2.0.6 was baked with Hyper-V switches already created.
# After sysprep /mode:vm + redeployment, the system has:
#   - GHOST PnP devices from the bake (Status=Unknown, invisible to Get-NetAdapter)
#   - Their stale vms_pp registry bindings confuse VMMS on startup
#   - New Azure NICs get "#2" suffix due to name conflicts with ghosts
#   - Get-NetAdapter -Physical may pick the WRONG NIC (ghost-renamed virtual vs real physical)
#
# Fix:
#   1. Find the CORRECT NIC via default gateway route (most reliable - avoids picking SR-IOV VFs
#      or renamed virtual adapters; the default gateway NIC is always the external mgmt NIC)
#   2. Stop VMMS
#   3. Remove ghost PnP devices via pnputil.exe (Remove-PnpDevice is unavailable in RunCommand)
#   4. Disable vms_pp on all present adapters
#   5. Enable vms_pp ONLY on the selected NIC
#   6. Start VMMS fresh - only registers the NIC we want
#   7. Wait for NIC in Msvm_ExternalEthernetPort, then create switch

# Find NIC using default gateway route - the most reliable method on Azure VMs.
# - Works regardless of adapter name/description changes after sysprep
# - Skips SR-IOV VFs (Mellanox etc.) which don't have default routes
# - Skips renamed ghost-displaced adapters if they lost their IP config
log "Identifying external NIC via default gateway route..."
$defaultRoute = Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
    Sort-Object RouteMetric | Select-Object -First 1
$physicalNic = $null
if ($defaultRoute) {
    $physicalNic = Get-NetAdapter -InterfaceIndex $defaultRoute.InterfaceIndex -ErrorAction SilentlyContinue |
        Where-Object { $_.Status -eq 'Up' }
    if ($physicalNic) { log "  Found via default route: '$($physicalNic.Name)' ($($physicalNic.InterfaceDescription))" }
}
# Fallback 1: first Up physical adapter
if (-not $physicalNic) {
    log "  Default route NIC not found, trying Get-NetAdapter -Physical..."
    $physicalNic = Get-NetAdapter -Physical | Where-Object { $_.Status -eq 'Up' } | Select-Object -First 1
}
# Fallback 2: any Up adapter that's not Hyper-V management, loopback, or tunnel
if (-not $physicalNic) {
    log "  Falling back to first Up non-virtual adapter..."
    $physicalNic = Get-NetAdapter | Where-Object {
        $_.Status -eq 'Up' -and
        $_.InterfaceDescription -notmatch 'Hyper-V Virtual|Loopback|Tunnel|WAN Miniport'
    } | Select-Object -First 1
}
if (-not $physicalNic) {
    Write-Error 'No suitable network adapter found for Hyper-V external switch.'
    Exit 1
}
$physicalNicName = $physicalNic.Name
$physicalNicDesc = $physicalNic.InterfaceDescription
log "Selected NIC: name='$physicalNicName' description='$physicalNicDesc' GUID=$($physicalNic.InterfaceGuid)"

log "All current network adapters:"
Get-NetAdapter | ForEach-Object { log "  [$($_.Status)] '$($_.Name)' ($($_.InterfaceDescription))" }

log 'Stopping Hyper-V VMMS...'
Stop-Service vmms -Force -ErrorAction SilentlyContinue
$vmmsStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
while ((Get-Service vmms).Status -ne 'Stopped' -and $vmmsStopwatch.Elapsed.TotalSeconds -lt 180) {
    log "Waiting for VMMS to stop... [$([math]::Round($vmmsStopwatch.Elapsed.TotalSeconds))s]"
    Start-Sleep -Seconds 5
}
log "VMMS stopped."

# Remove ghost/absent PnP network adapters left over from gallery image bake.
# Ghost adapters have Status=Unknown and are invisible to Get-NetAdapter/Disable-NetAdapterBinding.
# Their vms_pp registry bindings persist and confuse VMMS on startup.
# Using pnputil.exe (built-in, available on WS2022) because Remove-PnpDevice is not available
# in the RunCommand handler context on the gallery image.
log "Scanning for ghost/absent PnP network adapters..."
$allPnpNetDevices = Get-PnpDevice -Class 'Net' -ErrorAction SilentlyContinue
$ghostAdapters = $allPnpNetDevices | Where-Object { $_.Status -eq 'Unknown' }
if ($ghostAdapters) {
    foreach ($ghost in $ghostAdapters) {
        log "  Removing ghost: '$($ghost.FriendlyName)' (InstanceId: $($ghost.InstanceId))"
        $pnpResult = & pnputil.exe /remove-device "$($ghost.InstanceId)" 2>&1
        log "    pnputil: $($pnpResult -join ' | ')"
    }
    Start-Sleep -Seconds 3
} else {
    log "No ghost PnP network adapters found."
}

# Disable vms_pp on ALL present adapters to clear any stale bindings.
log "Disabling vms_pp on all present adapters..."
Get-NetAdapter | ForEach-Object {
    $b = Get-NetAdapterBinding -InterfaceAlias $_.InterfaceAlias -ComponentID 'vms_pp' -ErrorAction SilentlyContinue
    if ($b -and $b.Enabled) {
        log "  Disabling vms_pp on '$($_.InterfaceAlias)' ($($_.InterfaceDescription))"
        Disable-NetAdapterBinding -InterfaceAlias $_.InterfaceAlias -ComponentID 'vms_pp' -ErrorAction SilentlyContinue
    }
}
Start-Sleep -Seconds 2

# Enable vms_pp ONLY on the selected NIC (the one with default gateway).
log "Enabling vms_pp on '$physicalNicName'..."
Enable-NetAdapterBinding -InterfaceAlias $physicalNicName -ComponentID 'vms_pp' -ErrorAction Stop
$hvBinding = Get-NetAdapterBinding -InterfaceAlias $physicalNicName -ComponentID 'vms_pp' -ErrorAction SilentlyContinue
log "vms_pp on '$physicalNicName': Enabled=$($hvBinding.Enabled)"

log 'Starting Hyper-V VMMS...'
Start-Service vmms
$vmmsStartWatch = [System.Diagnostics.Stopwatch]::StartNew()
while ((Get-Service vmms).Status -ne 'Running' -and $vmmsStartWatch.Elapsed.TotalSeconds -lt 60) {
    log "Waiting for VMMS to start... [$([math]::Round($vmmsStartWatch.Elapsed.TotalSeconds))s]"
    Start-Sleep -Seconds 5
}
log "VMMS is running."

# Wait for the NIC to appear in Msvm_ExternalEthernetPort (the WMI class New-VMSwitch queries).
# After ghost cleanup and vms_pp reset, only the selected NIC should appear here.
log "Waiting for '$physicalNicName' ($physicalNicDesc) in VMMS WMI..."
$wmiStopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$nicInVmms = $false
while (-not $nicInVmms -and $wmiStopwatch.Elapsed.TotalMinutes -lt 5) {
    $externalPorts = Get-WmiObject -Namespace 'root/virtualization/v2' -Class 'Msvm_ExternalEthernetPort' -ErrorAction SilentlyContinue
    $portNames = ($externalPorts | Select-Object -ExpandProperty ElementName) -join ', '
    $matchedPort = $externalPorts | Where-Object { $_.ElementName -eq $physicalNicDesc -or $_.ElementName -eq $physicalNicName }
    if ($matchedPort) {
        $nicInVmms = $true
        log "NIC registered in VMMS WMI: '$($matchedPort.ElementName)'. Elapsed: $([math]::Round($wmiStopwatch.Elapsed.TotalSeconds))s"
    } else {
        log "[$([math]::Round($wmiStopwatch.Elapsed.TotalSeconds))s] WMI ports: '$portNames'. Waiting..."
        Start-Sleep -Seconds 10
    }
}
if (-not $nicInVmms) {
    log "WARNING: NIC not in VMMS WMI after 5 min. Ports visible: '$portNames'. Proceeding anyway."
}


# create hyperv switches
log "Creating Hyper-V switches using NIC '$physicalNicName'..."
$existingSwitches = Get-VMSwitch

# Helper: create external VMSwitch with fallback strategies.
# Strategy 1: -NetAdapterName (by interface alias, e.g. 'Ethernet 4')
# Strategy 2: -NetAdapterInterfaceDescription (by description, e.g. 'Microsoft Hyper-V Network Adapter')
# After ghost PnP cleanup there should only be one port in Msvm_ExternalEthernetPort, so
# both strategies should work. If alias-based fails, description-based is tried.
function New-VMSwitchWithRetry {
    param(
        [string]$Name,
        [string]$NetAdapterName,
        [bool]$AllowManagementOS = $false,
        [string]$SwitchType,
        [bool]$EnableIov = $false,
        [int]$MaxRetries = 5
    )
    for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
        try {
            if ($NetAdapterName) {
                try {
                    New-VMSwitch -Name $Name -AllowManagementOS:$AllowManagementOS -NetAdapterName $NetAdapterName -ErrorAction Stop
                } catch {
                    # Fallback: match by interface description instead of alias.
                    # Hyper-V may not map the alias correctly if VMMS internal registry differs.
                    log "  Alias-based switch creation failed ('$_'). Trying by description '$physicalNicDesc'..."
                    New-VMSwitch -Name $Name -AllowManagementOS:$AllowManagementOS -NetAdapterInterfaceDescription $physicalNicDesc -ErrorAction Stop
                }
            } else {
                New-VMSwitch -Name $Name -SwitchType $SwitchType -EnableIov:$EnableIov -ErrorAction Stop
            }
            log "VMSwitch '$Name' created on attempt $attempt."
            return
        } catch {
            log "Attempt $attempt/${MaxRetries}: Failed to create VMSwitch '${Name}': $_"
            if ($attempt -lt $MaxRetries) {
                log "Retrying in 15s..."
                Start-Sleep -Seconds 15
            } else {
                throw
            }
        }
    }
}

If ($switchlessStorageConfig -eq 'switched') {
    log 'Creating Hyper-V switches for switched storage configuration...'
    If ($existingSwitches.Name -notcontains 'external' ) { New-VMSwitchWithRetry -Name external -AllowManagementOS $true -NetAdapterName $physicalNicName }
    If ($existingSwitches.Name -notcontains 'hciNodeMgmtInternal' ) { New-VMSwitchWithRetry -Name hciNodeMgmtInternal -SwitchType Internal -EnableIov $true }
    If ($existingSwitches.Name -notcontains 'hciNodeStoragePrivate' ) { New-VMSwitchWithRetry -Name hciNodeStoragePrivate -SwitchType Private -EnableIov $true }
} ElseIf ($switchlessStorageConfig -eq 'switchless') {
    If ($hciNodeCount -gt 3) {
        log -message 'ERROR: Switchless storage configuration is only supported for 3 or fewer HCI nodes. Exiting script...'
        Write-Error 'ERROR: Switchless storage configuration is only supported for 3 or fewer HCI nodes. Exiting script...'
        exit 1
    }

    log 'Creating Hyper-V switches for switchless storage configuration...'
    If ($existingSwitches.Name -notcontains 'external' ) { New-VMSwitchWithRetry -Name external -AllowManagementOS $true -NetAdapterName $physicalNicName }
    If ($existingSwitches.Name -notcontains 'hciNodeMgmtInternal' ) { New-VMSwitchWithRetry -Name hciNodeMgmtInternal -SwitchType Internal -EnableIov $true }
    If ($existingSwitches.Name -notcontains 'hciNodeStoragePrivateA' ) { New-VMSwitchWithRetry -Name hciNodeStoragePrivateA -SwitchType Private -EnableIov $true }
    If ($existingSwitches.Name -notcontains 'hciNodeStoragePrivateB' ) { New-VMSwitchWithRetry -Name hciNodeStoragePrivateB -SwitchType Private -EnableIov $true }
    If ($existingSwitches.Name -notcontains 'hciNodeStoragePrivateC' ) { New-VMSwitchWithRetry -Name hciNodeStoragePrivateC -SwitchType Private -EnableIov $true }
}

# add IPs for host
log 'Adding IPs for host...'
$existingIPs = Get-NetIPAddress
If ($existingIPs.IPAddress -notcontains '172.20.0.1') { New-NetIPAddress -InterfaceAlias 'vEthernet (hciNodeMgmtInternal)' -IPAddress 172.20.0.1 -PrefixLength 24 }

# configure NAT
log 'Restarting RemoteAccess service...'
Restart-Service RemoteAccess

log 'Configuring NAT...'

netsh routing ip nat uninstall
netsh routing ip nat install
netsh routing ip nat set global tcptimeoutmins=1440 udptimeoutmins=1 loglevel=ERROR
netsh routing ip nat add interface name="vEthernet (external)" mode=FULL
If (!$?) {
    $message = "Failed to run netsh command: ''netsh routing ip nat add interface name='vEthernet (external)' mode=FULL''."
    log $message
    Write-Error $message
}
netsh routing ip nat add interface name="vEthernet (hciNodeMgmtInternal)" mode=PRIVATE
If (!$?) {
    $message = "Failed to run netsh command: ''netsh routing ip nat add interface name='vEthernet (hciNodeMgmtInternal)' mode=PRIVATE''."
    log $message
    Write-Error $message
}

# Verify and retry NAT configuration (JumpStart-inspired reliability pattern)
log 'Verifying NAT configuration with retry...'
$natRetryCount = 0
$natMaxRetries = 3
while ($natRetryCount -lt $natMaxRetries) {
    Start-Sleep -Seconds 10
    $natInterfaces = netsh routing ip nat show interface
    if ($natInterfaces -match 'external' -and $natInterfaces -match 'hciNodeMgmtInternal') {
        log "NAT configuration verified successfully (attempt $($natRetryCount + 1))"
        break
    }
    $natRetryCount++
    log "NAT verification failed (attempt $natRetryCount/$natMaxRetries). Retrying NAT setup..."
    Restart-Service RemoteAccess -Force
    Start-Sleep -Seconds 15
    netsh routing ip nat uninstall
    netsh routing ip nat install
    netsh routing ip nat set global tcptimeoutmins=1440 udptimeoutmins=1 loglevel=ERROR
    netsh routing ip nat add interface name="vEthernet (external)" mode=FULL
    netsh routing ip nat add interface name="vEthernet (hciNodeMgmtInternal)" mode=PRIVATE
}
if ($natRetryCount -ge $natMaxRetries) {
    log 'WARNING: NAT configuration could not be fully verified after retries. Proceeding anyway...'
}

# create DHCP scopes
log 'Creating DHCP scopes...'
$existingScopes = Get-DhcpServerv4Scope
If ($existingScopes.name -notcontains 'HCIMgmt') { Add-DhcpServerv4Scope -StartRange 172.20.0.10 -EndRange 172.20.0.250 -Name HCIMgmt -State Active -SubnetMask 255.255.255.0 }

# exclude LCM IP range from DHCP to prevent conflicts during Azure Local cluster deployment
try { Add-DhcpServerv4ExclusionRange -ScopeId 172.20.0.0 -StartRange 172.20.0.50 -EndRange 172.20.0.70 } catch { log "DHCP exclusion range already exists or failed: $_" }

# test DC connectivity before attempting to authorize DHCP server in AD
log 'Testing DC connectivity...'
$count = 0
While (!(Test-ADConnection) -and $count -lt 120) {
    Start-Sleep -Seconds 5
    log 'Waiting for AD Web Services to be available...'
    $count++
}

log 'Authorizing DHCP servers in AD for DNS updates...'
$dhcpRetries = 5
$existingAuthorizedServers = $null
for ($r = 1; $r -le $dhcpRetries; $r++) {
    try {
        $existingAuthorizedServers = Get-DhcpServerInDC -ErrorAction Stop
        log "Successfully queried authorized DHCP servers (attempt $r)"
        break
    } catch {
        log "Failed to query authorized DHCP servers in AD (attempt $r/$dhcpRetries): $($_.Exception.Message)"
        if ($r -lt $dhcpRetries) {
            log "Waiting 60 seconds before retrying..."
            Start-Sleep -Seconds 60
        } else {
            throw "Failed to query DHCP servers after $dhcpRetries attempts: $($_.Exception.Message)"
        }
    }
}

If ($existingAuthorizedServers.IPAddress -notcontains '172.20.0.1') { Add-DhcpServerInDC -DnsName "$($env:COMPUTERNAME).hci.local" -IPAddress 172.20.0.1 }

# set router and dns options for mgmt DHCP scope
log 'Setting router and dns options for mgmt DHCP scope...'
Set-DhcpServerv4OptionValue -ScopeId 172.20.0.0 -DnsDomain hci.local -DnsServer 172.20.0.1 -Router 172.20.0.1

# create HCI node VMs
log 'Creating HCI node VMs...'
$existingVMs = Get-VM
For ($i = 1; $i -le $hciNodeCount; $i++) {
    $hciNodeName = "hcinode$i"
    $hciNodePath = "C:\diskMounts\$hciNodeName"

    If ($existingVMs.name -notcontains $hciNodeName) { New-VM -Name $hciNodeName -MemoryStartupBytes 32GB -BootDevice VHD -SwitchName hciNodeMgmtInternal -Path C:\diskMounts\ -VHDPath "$hciNodePath\hci_os.vhdx" -Generation 2 }
}

# configure HCI node VMs
log 'Configuring HCI node VMs...'
log 'Setting VM processor count to 20 and enabling virtualization extensions...'
# Stop VMs if running (required for Set-VMProcessor)
Get-VM | Where-Object { $_.State -eq 'Running' } | Stop-VM -Force -ErrorAction SilentlyContinue
Get-VM | Set-VMProcessor -ExposeVirtualizationExtensions $true -Count 20

log 'Setting VM key protector and enabling TPM...'
Get-VM | ForEach-Object {
    If (($_ | Get-VMKeyProtector).Length -eq 4) {
        log "Adding key protector for VM '$($_.Name)'"
        $_ | Set-VMKeyProtector -NewLocalKeyProtector
    } Else {
        log "Key protector already exists for VM '$($_.Name)'"
    }

    If (($_ | Get-VMSecurity).TpmEnabled -eq $false) {
        log "Enabling TPM for VM '$($_.Name)'"
        $_ | Enable-VMTPM
    } Else {
        log "TPM already enabled for VM '$($_.Name)'"
    }
}


# rename first NIC to FABRIC (matches Azure Local ManagementCompute intent)
log 'Renaming first network adapter on HCI nodes to FABRIC...'
if (Get-VMNetworkAdapter -Name 'Network Adapter' -VMName * -ErrorAction SilentlyContinue) { Rename-VMNetworkAdapter -NewName FABRIC -VMName * -Name 'Network Adapter' }
Get-VM | Get-VMNetworkAdapter -Name 'FABRIC' | Set-VMNetworkAdapter -DeviceNaming On

# add additional NICs to HCI node VMs (FABRIC2 for ManagementCompute, StorageA/StorageB for Storage intent)
log 'Adding additional NICs to HCI node VMs...'
ForEach ($existingVM in (Get-VM)) {
    $existingNICs = Get-VMNetworkAdapter -VM $existingVM
    # FABRIC2 on management switch - paired with FABRIC for ManagementCompute intent
    If ($existingNICs.name -notcontains 'FABRIC2') { $existingVM | Add-VMNetworkAdapter -Name FABRIC2 -SwitchName hciNodeMgmtInternal -DeviceNaming On }

    If ($switchlessStorageConfig -eq 'switched') {
        log "Adding storage NICs to VM '$($existingVM.name)' for switched storage configuration..."
        If ($existingNICs.name -notcontains 'StorageA') { $existingVM | Add-VMNetworkAdapter -Name StorageA -SwitchName hciNodeStoragePrivate -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '711' -NativeVlanId 0 }
        If ($existingNICs.name -notcontains 'StorageB') { $existingVM | Add-VMNetworkAdapter -Name StorageB -SwitchName hciNodeStoragePrivate -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '712' -NativeVlanId 0 }
    } ElseIf ($switchlessStorageConfig -eq 'switchless') {
        log "Adding storage NICs to VM '$($existingVM.name)' for switchless storage configuration..."

        switch ($existingVM.Name[-1]) {
            1 {
                If ($existingNICs.name -notcontains 'StorageA') { $existingVM | Add-VMNetworkAdapter -Name StorageA -SwitchName hciNodeStoragePrivateA -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '711' -NativeVlanId 0 }
                If ($existingNICs.name -notcontains 'StorageB') { $existingVM | Add-VMNetworkAdapter -Name StorageB -SwitchName hciNodeStoragePrivateB -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '711' -NativeVlanId 0 }
            }
            2 {
                If ($existingNICs.name -notcontains 'StorageA') { $existingVM | Add-VMNetworkAdapter -Name StorageA -SwitchName hciNodeStoragePrivateA -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '711' -NativeVlanId 0 }
                If ($existingNICs.name -notcontains 'StorageB') { $existingVM | Add-VMNetworkAdapter -Name StorageB -SwitchName hciNodeStoragePrivateC -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '711' -NativeVlanId 0 }
            }
            3 {
                If ($existingNICs.name -notcontains 'StorageA') { $existingVM | Add-VMNetworkAdapter -Name StorageA -SwitchName hciNodeStoragePrivateB -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '711' -NativeVlanId 0 }
                If ($existingNICs.name -notcontains 'StorageB') { $existingVM | Add-VMNetworkAdapter -Name StorageB -SwitchName hciNodeStoragePrivateC -DeviceNaming On -Passthru | Set-VMNetworkAdapterVlan -Trunk -AllowedVlanIdList '711' -NativeVlanId 0 }
            }
            Default {}
        }
    }
}

# add disks to HCI node VMs
log 'Adding disks to HCI node VMs...'
Foreach ($vm in (Get-VM)) {
    (1..4) | ForEach-Object {
        $diskPath = "C:\diskMounts\$($vm.Name)\hciNodeDisk$($_).vhdx"
        If (!(Test-Path -Path $diskPath)) {
            log "Creating disk: $diskPath"
            New-VHD -Path $diskPath -SizeBytes 1TB -Dynamic | Out-Null
        }
        If ($VM.HardDrives.Path -notcontains $diskPath) {
            log "Adding disk: $diskPath to VM: $($vm.Name)"
            Add-VMHardDiskDrive -VMName $vm.Name -ControllerType SCSI -ControllerNumber 0 -ControllerLocation $_ -Path $diskPath | Out-Null
        }
    }
}

# enable mac soofing on HCI node VMs
log 'Enabling MAC spoofing on HCI node VMs...'
Get-VM | Get-VMNetworkAdapter | Set-VMNetworkAdapter -MacAddressSpoofing On

# define unattend.xml for HCI node VMs template
$unattendSource = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="specialize">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ComputerName>$hciNodeName</ComputerName>
            <RegisteredOrganization>Organization</RegisteredOrganization>
            <RegisteredOwner>Owner</RegisteredOwner>
            <TimeZone>UTC</TimeZone>
        </component>
        <component name="Microsoft-Windows-IE-ESC" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <IEHardenAdmin>false</IEHardenAdmin>
        </component>
        <component name="Microsoft-Windows-ErrorReportingCore" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <DisableWER>1</DisableWER>
        </component>
        <component name="Microsoft-Windows-TerminalServices-LocalSessionManager" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <fDenyTSConnections>false</fDenyTSConnections>
        </component>
        <component name="Microsoft-Windows-TCPIP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <Interfaces>
                <Interface wcm:action="add">
                    <Ipv4Settings>
                        <DhcpEnabled>true</DhcpEnabled>
                    </Ipv4Settings>
                </Interface>
            </Interfaces>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                <HideLocalAccountScreen>true</HideLocalAccountScreen>
                <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
                <NetworkLocation>Work</NetworkLocation>
                <ProtectYourPC>1</ProtectYourPC>
            </OOBE>
            <FirstLogonCommands>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell.exe -command &quot;Get-NetAdapterAdvancedProperty -DisplayName 'Hyper-V Network Adapter Name' | Foreach-Object {`$_ | Get-NetAdapter | Rename-NetAdapter -NewName `$_.DisplayValue}&quot;</CommandLine>
                    <Order>1</Order>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>powershell.exe -command &quot;Enable-WindowsOptionalFeature -Online -FeatureName 'microsoft-hyper-v-online' -all -NoRestart&quot;</CommandLine>
                    <Order>2</Order>
                    <RequiresUserInput>false</RequiresUserInput>
                </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                <CommandLine>powershell.exe -command &quot;Remove-Item -Path &apos;C:\unattend.xml&apos; -Force&quot;</CommandLine>
                <Order>3</Order>
                <RequiresUserInput>false</RequiresUserInput>
            </SynchronousCommand>
                <SynchronousCommand wcm:action="add">
                    <CommandLine>shutdown -r -f -t 0</CommandLine>
                    <Order>4</Order>
                    <RequiresUserInput>false</RequiresUserInput>
            </SynchronousCommand>
            </FirstLogonCommands>
            <AutoLogon>
                <Username>Administrator</Username>
                <Enabled>true</Enabled>
                <LogonCount>1</LogonCount>
                <Password>
                    <Value>$adminPw</Value>
                    <PlainText>true</PlainText>
                </Password>
            </AutoLogon>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>$adminPw</Value>
                    <PlainText>True</PlainText>
                </AdministratorPassword>
                <LocalAccounts>
                <LocalAccount wcm:action="add">
                   <Password>
                      <Value>$adminPw</Value>
                      <PlainText>true</PlainText>
                   </Password>
                   <Description>HCI Admin User</Description>
                   <DisplayName>$adminUsername</DisplayName>
                   <Group>Administrators;Power Users</Group>
                   <Name>$adminUsername</Name>
                </LocalAccount>
                </LocalAccounts>
            </UserAccounts>
        </component>
        <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <InputLocale>en-us</InputLocale>
            <SystemLocale>en-us</SystemLocale>
            <UILanguage>en-us</UILanguage>
            <UILanguageFallback>en-us</UILanguageFallback>
            <UserLocale>en-us</UserLocale>
        </component>
    </settings>
</unattend>
'@

# inject updated sysp answer file into each HCI node disk
log 'Injecting updated sysprep answer file into each HCI node disk...'
For ($i = 1; $i -le $hciNodeCount; $i++) {
    $hciNodeName = "hciNode$i"
    $hciProductKey = ''

    Push-Location c:\diskMounts\$hciNodeName

    If (!(Test-Path -Path unattend_injected.status) -and (Get-VM -Name $hciNodeName).State -eq 'Off') {
        log "Injecting unattend.xml into HCI node disk '$hciNodeName'..."
        $mountedVolume = Mount-VHD .\hci_os.vhdx -Passthru | Get-Disk | Get-Partition | Get-Volume | Where-Object FileSystemType -EQ 'NTFS'

        $clone = $unattendSource.psobject.copy()
        $clone = $ExecutionContext.InvokeCommand.ExpandString($clone)

        Set-Content -Path "$($mountedVolume.DriveLetter):\unattend.xml" -Value $clone -Force

        Dismount-VHD .\hci_os.vhdx

        Set-Content 'unattend_injected.status' -Value 'Unattend.xml injected'
    } Else {
        log "Unattend.xml already injected into HCI node disk '$hciNodeName'."
    }

    Pop-Location
}

# start HCI node VMs
If (Get-VM | Where-Object State -EQ 'Off') {
    log 'Starting HCI node VMs...'
    try {
        $errorActionPreference = 'Stop'
        Get-VM | Start-VM
    } catch {
        log "Failed to start HCI node VMs. $_"
        Write-Error "Failed to start HCI node VMs. $_"
    }

    #wait for vms to boot - poll heartbeat instead of fixed sleep
    log 'Waiting for VMs to boot and apply sysprep (polling heartbeat, max 10 min)...'
    $bootTimer = [System.Diagnostics.Stopwatch]::StartNew()
    $allReady = $false
    while (-not $allReady -and $bootTimer.Elapsed.TotalMinutes -lt 10) {
        $vms = Get-VM
        $readyVMs = $vms | Where-Object { $_.Heartbeat -eq 'OkApplicationsHealthy' -or $_.Heartbeat -eq 'OkApplicationsUnknown' }
        if ($readyVMs.Count -eq $vms.Count) {
            log "All $($vms.Count) VMs have heartbeat after $([math]::Round($bootTimer.Elapsed.TotalSeconds))s."
            $allReady = $true
        } else {
            log "[$([math]::Round($bootTimer.Elapsed.TotalSeconds))s] $($readyVMs.Count)/$($vms.Count) VMs ready (heartbeat). Waiting 30s..."
            Start-Sleep -Seconds 30
        }
    }
    if (-not $allReady) {
        log 'WARNING: Not all VMs reported heartbeat within 10 min. Proceeding anyway (sysprep may still be running)...'
    }
    # Extra buffer for sysprep FirstLogonCommands to complete after heartbeat detected
    log 'Waiting 30s for sysprep FirstLogonCommands to complete...'
    Start-Sleep -Seconds 30
} Else {
    log 'HCI node VMs are already running.'
}

# create DHCP reservations for HCI node VMs management interfaces
log 'Checking DHCP reservations for HCI node VMs management interfaces...'
$existingReservations = Get-DhcpServerv4Reservation -ScopeId 172.20.0.0
For ($i = 1; $i -le $hciNodeCount; $i++) {
    $hciNodeName = "hciNode$i"
    $hciNodeIP = "172.20.0.$(9 + $i)"
    If ($existingReservations.Description -notcontains $hciNodeName) {
        log "Creating DHCP reservation for HCI node '$hciNodeName' with IP '$hciNodeIP'..."

        $fabricNIC = Get-VMNetworkAdapter -VMName $hciNodeName -Name FABRIC

        If ($fabricNIC) {
            $fabricMac = $fabricNIC.MacAddress -split '(.{2})' -ne '' -join '-'

            log "Creating DHCP reservation for HCI node '$hciNodeName' with IP '$hciNodeIP' for MAC address '$fabricMac'..."
            Add-DhcpServerv4Reservation -ScopeId 172.20.0.0 -Name $hciNodeName -IPAddress $hciNodeIP -ClientId $fabricMac -Description $hciNodeName
        } Else {
            log "Failed to create DHCP reservation for HCI node '$hciNodeName'. Could not find NIC named 'FABRIC'."
            Write-Error "Failed to create DHCP reservation for HCI node '$hciNodeName'. Could not find NIC named 'FABRIC'."
            exit 1
        }
    } Else {
        log "DHCP reservation for HCI node '$hciNodeName' already exists."
    }
}
