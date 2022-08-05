try {
    $driveLetter = (Get-CimInstance Win32_LogicalDisk | ?{ $_.DriveType -eq 5}).DeviceID
    Set-WmiInstance -InputObject (Get-WmiObject -Class Win32_volume -Filter "DriveLetter = '$driveLetter'" ) -Arguments @{DriveLetter='Z:'}
} catch {}

If ($null -ne (Get-PhysicalDisk -CanPool $True)) {

    New-StoragePool –FriendlyName LUN-DATA –StorageSubsystemFriendlyName 'Windows Storage*' –PhysicalDisks (Get-PhysicalDisk -CanPool $True)

    New-VirtualDisk -FriendlyName DataDisk1 -StoragePoolFriendlyName LUN-DATA -UseMaximumSize -ResiliencySettingName Simple
    Start-Sleep -Seconds 20

    Initialize-Disk -VirtualDisk (Get-VirtualDisk -FriendlyName DataDisk1)
    Start-Sleep -Seconds 20

    $diskNumber = ((Get-VirtualDisk -FriendlyName DataDisk1 | Get-Disk).Number)
    New-Partition -DiskNumber $diskNumber -UseMaximumSize -DriveLetter F
    Start-Sleep -Seconds 20


    Format-Volume -DriveLetter F -FileSystem NTFS -NewFileSystemLabel Data -Confirm:$false -Force
}