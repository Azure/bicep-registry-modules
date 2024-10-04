[CmdletBinding()]
param (
  [Parameter()]
  [string]
  $hciVHDXDownloadURL,

  [Parameter()]
  [string]
  $hciISODownloadURL,

  [Parameter()]
  [ValidateRange(1, 16)]
  [int]
  $hciNodeCount
)
Function log {
  Param (
    [string]$message,
    [string]$logPath = 'C:\temp\hciHostDeploy.log'
  )

  If (!(Test-Path -Path C:\temp)) {
    New-Item -Path C:\temp -ItemType Directory
  }

  Write-Host $message
  Add-Content -Path $logPath -Value "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') [hciHostStage3] - $message"
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

# THANKS https://github.com/bfrankMS/CreateHypervVms/blob/master/Scenario-AzStackHCI/CreateVhdxFromIso.ps1
Function New-VHDXFromISO {
  # Parameter help description
  param(
    [Parameter(ParameterSetName = 'SRC', Mandatory = $true, ValueFromPipeline = $true)]
    [Alias('ISO')]
    [string]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({ Test-Path $(Resolve-Path $_) })]
    $IsoPath,

    [Parameter(ParameterSetName = 'SRC')]
    [Alias('VHD')]
    [string]
    [ValidateNotNullOrEmpty()]
    $VhdxPath,

    [Parameter(ParameterSetName = 'SRC')]
    [Alias('Size')]
    [UInt64]
    [ValidateNotNullOrEmpty()]
    [ValidateRange(512MB, 64TB)]
    $SizeBytes = 120GB,

    [Parameter(ParameterSetName = 'SRC')]
    [Alias('Index')]
    [UInt64]
    [ValidateNotNullOrEmpty()]
    [ValidateRange(1, 10)]
    $ImageIndex = 1          #defaults to azure stack hci on 2405 image
  )

  $BCDBoot = 'bcdboot.exe'
  $VHDFormat = 'VHDX'
  $TempDirectory = $env:Temp

  function
  Write-ActionInfo {
    # Function to make the Write-Host output a bit prettier.
    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
      [string]
      [ValidateNotNullOrEmpty()]
      $text
    )
    Write-Host "INFO   : $($text)" -ForegroundColor White
  }

  function
  Start-Executable {
    <#
          .SYNOPSIS
              Runs an external executable file, and validates the error level.

          .PARAMETER Executable
              The path to the executable to run and monitor.

          .PARAMETER Arguments
              An array of arguments to pass to the executable when it's executed.

          .PARAMETER SuccessfulErrorCode
              The error code that means the executable ran successfully.
              The default value is 0.
      #>

    [CmdletBinding()]
    param(
      [Parameter(Mandatory = $true)]
      [string]
      [ValidateNotNullOrEmpty()]
      $Executable,

      [Parameter(Mandatory = $true)]
      [string[]]
      [ValidateNotNullOrEmpty()]
      $Arguments,

      [Parameter()]
      [int]
      [ValidateNotNullOrEmpty()]
      $SuccessfulErrorCode = 0

    )

    Write-ActionInfo "Running $Executable $Arguments"
    $ret = Start-Process           `
      -FilePath $Executable      `
      -ArgumentList $Arguments   `
      -NoNewWindow               `
      -Wait                      `
      -RedirectStandardOutput "$($TempDirectory)\$($scriptName)\$($sessionKey)\$($Executable)-StandardOutput.txt" `
      -RedirectStandardError "$($TempDirectory)\$($scriptName)\$($sessionKey)\$($Executable)-StandardError.txt"  `
      -PassThru

    Write-ActionInfo "Return code was $($ret.ExitCode)."

    if ($ret.ExitCode -ne $SuccessfulErrorCode) {
      throw "$Executable failed with code $($ret.ExitCode)!"
    }
  }

  Write-ActionInfo 'Creating virtual hard disk...'
  $newVhd = New-VHD -Path $VhdxPath -SizeBytes $SizeBytes -Dynamic

  Write-ActionInfo "Mounting $VHDFormat..."
  $disk = $newVhd | Mount-VHD -Passthru | Get-Disk


  # UEFI : 3 partitions : efi - msr - windows
  <#https://learn.microsoft.com/de-de/windows/win32/api/winioctl/ns-winioctl-partition_information_gpt
PARTITION_BASIC_DATA_GUID - ebd0a0a2-b9e5-4433-87c0-68b6b72699c7
PARTITION_SYSTEM_GUID - c12a7328-f81f-11d2-ba4b-00a0c93ec93b    # EFI
PARTITION_MSFT_RESERVED_GUID - e3c9e316-0b5c-4db8-817d-f92df00215ae  # MSR
PARTITION_MSFT_RECOVERY_GUID - de94bba4-06d1-4d40-a16a-bfd50179d6ac   # Recovery partition (Windows) we are not using this
#>

  try {
    Write-ActionInfo 'Initializing disk...'
    Initialize-Disk -Number $disk.Number -PartitionStyle GPT

    Write-ActionInfo 'Creating EFI system partition...'
    $systemPartition = New-Partition -DiskNumber $disk.Number -Size 200MB -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}'

    Write-ActionInfo 'Formatting EFI system volume...'
    $systemVolume = Format-Volume -Partition $systemPartition -FileSystem FAT32 -Force -Confirm:$false

    Write-ActionInfo 'Setting EFI system partition PARTITION_SYSTEM_GUID...'
    $systemPartition | Set-Partition -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}'
    $systemPartition | Add-PartitionAccessPath -AssignDriveLetter

    # Create the reserved partition
    Write-ActionInfo 'Creating MSR partition...'
    $reservedPartition = New-Partition -DiskNumber $disk.Number -Size 128MB -GptType '{e3c9e316-0b5c-4db8-817d-f92df00215ae}' -Verbose

    # Create the Windows partition
    Write-ActionInfo 'Creating windows partition...'
    $windowsPartition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}'

    Write-ActionInfo 'Formatting windows volume...'
    $windowsVolume = Format-Volume -Partition $windowsPartition -FileSystem NTFS -Force -Confirm:$false

    # Assign drive letter to Windows partition.  This is required for bcdboot
    $windowsPartition | Add-PartitionAccessPath -AssignDriveLetter
    $windowsDrive = $(Get-Partition -Volume $windowsVolume).AccessPaths[0].substring(0, 2)
    Write-ActionInfo "Windows path ($windowsDrive) has been assigned."

    # Refresh access paths (we have now formatted the volume)
    $systemPartition = $systemPartition | Get-Partition
    $systemDrive = $systemPartition.AccessPaths[0].trimend('\').replace('\?', '??')
    Write-ActionInfo "System volume location: $systemDrive"

    # Mount .iso to get the install.wim
    $beforeMount = (Get-Volume).DriveLetter -split ' '
    $mountResult = Mount-DiskImage -StorageType ISO -ImagePath $IsoPath
    $afterMount = (Get-Volume).DriveLetter -split ' '
    $setuppath = (Compare-Object $beforeMount $afterMount -PassThru )
    Write-ActionInfo "Mounted .iso to $($setuppath):"

    Write-ActionInfo "Applying image from .iso $("$setuppath"+':\sources\install.wim') to $VHDFormat. This could take a while..."

    Expand-WindowsImage -ApplyPath $windowsDrive -ImagePath "$setuppath`:\sources\install.wim" -Index $ImageIndex #-LogPath "$($logFolder)\DismLogs.log" | Out-Null
    Write-ActionInfo 'Image was applied successfully. '

    Write-ActionInfo 'Making image bootable...'
    $bcdBootArgs = @(
      "$($windowsDrive)\Windows", # Path to the \Windows on the VHD
      "/s $systemDrive", # Specifies the volume letter of the drive to create the \BOOT folder on.
      '/v'                        # Enabled verbose logging.
    )
    $bcdBootArgs += '/f UEFI'   # Specifies the firmware type of the target system partition

    Start-Executable -Executable $BCDBoot -Arguments $bcdBootArgs

    Write-ActionInfo 'Drive is bootable.  Cleaning up...'

    # Remove system partition access path, if necessary
    $systemPartition | Remove-PartitionAccessPath -AccessPath $systemPartition.AccessPaths[0]
  } finally {
    Write-ActionInfo "Dismounting $VHDFormat..."
    Dismount-VHD -Path $VhdxPath

    #ejecting .iso - releasing drive letter.
    Write-ActionInfo 'Dismounting .iso...'
    Dismount-DiskImage -ImagePath $IsoPath
  }
}

$ErrorActionPreference = 'Stop'

# download HCI VHDX or ISO
If (!(Test-Path -Path 'c:\ISOs')) {
  log 'Creating c:\ISOs directory...'
  mkdir c:\ISOs
} Else {
  log 'ISOs directory already exists, skipping...'
}

If ($hciVHDXDownloadURL) {
  log 'Downloading HCI VHDX...'
  If (! (Test-Path c:\ISOs\hci_os.vhdx)) {
    [System.Net.WebClient]::new().DownloadFile($hciVHDXDownloadURL, 'c:\isos\hci_os.vhdx')
  } Else {
    log 'HCI VHDX already exists, skipping download...'
  }
} ElseIf ($hciISODownloadURL) {
  log 'Downloading HCI ISO...'
  If (! (Test-Path c:\ISOs\hci_os.iso)) {
    [System.Net.WebClient]::new().DownloadFile($hciISODownloadURL, 'c:\isos\hci_os.iso')
  } Else {
    log 'HCI ISO already exists, skipping download...'
  }

  # convert ISO to VHDX
  If (!(Test-Path 'c:\isos\hci_os.vhdx')) {
    log 'Converting ISO to VHDX...'
    New-VHDXFromISO -IsoPath 'c:\isos\hci_os.iso' -VhdxPath 'c:\isos\hci_os.vhdx'
  } Else {
    log 'HCI VHDX already exists, skipping conversion...'

  }
} Else {
  log 'No download URL provided, cannot continue...'
  Write-Error 'No download URL provided, cannot continue...' -ErrorAction Stop
}

# create mount point directories on C:\
log 'Creating mount points...'
For ($i = 0; $i -lt $hciNodeCount; $i++) {
  $dirPath = "c:\diskmounts\hcinode$($i + 1)"
  If (!(Test-Path -Path $dirPath)) {
    mkdir $dirPath
  } Else {
    log "Mount point '$dirPath' already exists, skipping..."
  }
}

# format and mount disks
log 'Formatting and mounting disks...'
$count = 0
$rawDisks = Get-Disk | Where-Object PartitionStyle -EQ 'RAW'
$rawDisks |
  Initialize-Disk -PartitionStyle GPT -PassThru |
  New-Partition -UseMaximumSize -AssignDriveLetter:$false |
  Format-Volume -FileSystem NTFS |
  Get-Partition |
  Where-Object { $_.type -ne 'Reserved' } |
  ForEach-Object { $count++; mountvol c:\diskMounts\HCINode$count $_.accesspaths[0] }

log 'Copying VHDX to mount points...'
For ($i = 0; $i -lt $hciNodeCount; $i++) {
  If (!(Test-Path -Path "c:\diskmounts\hcinode$($i + 1)\hci_os.vhdx")) {
    Copy-Item -Path c:\isos\hci_os.vhdx -Destination "c:\diskmounts\hcinode$($i + 1)"
  } Else {
    log "HCI VHDX already exists at 'c:\diskmounts\hcinode$($i + 1)', skipping..."
  }
}

# install RRAS configure for routing
log 'Installing RRAS and configuring for routing...'
While (!(Test-Path -Path 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\RemoteAccess\RemoteAccess.psd1')) {
  Start-Sleep -Seconds 5
  log 'Waiting for RRAS module to be available...'
}
Import-Module 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\RemoteAccess\RemoteAccess.psd1'
Install-RemoteAccess -VpnType RoutingOnly
Set-Service -Name RemoteAccess -StartupType Automatic -PassThru | Start-Service

# install domain controller
log 'Checking whether AD is installed...'
If (!(Test-ADConnection)) {
  log 'AD is not installed, installing...'
  Import-Module 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ADDSDeployment\ADDSDeployment.psd1'

  $ADRecoveryPassword = ConvertTo-SecureString -Force -AsPlainText (New-Guid).guid
  Install-ADDSForest -DomainName hci.local -DomainNetbiosName hci -ForestMode Default -DomainMode Default -InstallDns:$true -SafeModeAdministratorPassword $ADRecoveryPassword -NoRebootOnCompletion:$true -Force:$true
} Else {
  log 'AD is already installed, skipping...'
}

log 'Adding DNS forwarders...'
Import-Module 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\DnsServer\DnsServer.psd1'
Add-DnsServerForwarder -IPAddress 8.8.8.8

# create reboot status file
If (Test-Path -Path 'C:\temp\Reboot2Completed.status') {
  log 'Reboot has already been completed, skipping...'
} ElseIf (Test-Path -Path 'C:\temp\Reboot2Initiated.status') {
  log 'Reboot has already been initiated, skipping...'
} Else {
  log 'Reboot required, creating status file...'
  Set-Content -Path 'C:\temp\Reboot2Required.status' -Value 'Reboot 2 Required'
}
