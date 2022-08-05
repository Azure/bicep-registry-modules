##############################
#    WVD Script Parameters   #
##############################
Param (        
    [Parameter(Mandatory=$true)]
        [string]$RegistrationToken    
)


######################
#    WVD Variables   #
######################
$LocalWVDpath            = "$env:Public\Downloads\"
$WVDBootURI              = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH'
$WVDAgentURI             = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv'
$FSLogixURI              = 'https://aka.ms/fslogix_download'
$FSInstaller             = 'FSLogixAppsSetup.zip'
$WVDAgentInstaller       = 'WVD-Agent.msi'
$WVDBootInstaller        = 'WVD-Bootloader.msi'



#################################
#    Download WVD Componants    #
#################################
Invoke-WebRequest -Uri $FSLogixURI -OutFile "$LocalWVDpath$FSInstaller"
Invoke-WebRequest -Uri $WVDBootURI -OutFile "$LocalWVDpath$WVDBootInstaller"
Invoke-WebRequest -Uri $WVDAgentURI -OutFile "$LocalWVDpath$WVDAgentInstaller"


##############################
#    Prep for WVD Install    #
##############################
Expand-Archive `
    -LiteralPath "$LocalWVDpath$FSInstaller" `
    -DestinationPath "$LocalWVDpath\FSLogix" `
    -Force `
    -Verbose
Remove-Item -Path $LocalWVDpath$FSInstaller -Force

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
cd $LocalWVDpath


##############################
#    OS Specific Settings    #
##############################
$OS = (Get-WmiObject Win32_OperatingSystem).name
If(($OS) -match 'Server') {

    If(((Get-WindowsFeature -Name RDS-RD-Server).InstallState) -ne 'Installed') {
        Install-WindowsFeature `
            -Name RDS-RD-Server `
            -Verbose `
            -LogPath "$LocalWVDpath\RdsServerRoleInstall.txt"
    }
    $AdminsKey = "SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UsersKey = "SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    $BaseKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey("LocalMachine","Default")
    $SubKey = $BaseKey.OpenSubkey($AdminsKey,$true)
    $SubKey.SetValue("IsInstalled",0,[Microsoft.Win32.RegistryValueKind]::DWORD)
    $SubKey = $BaseKey.OpenSubKey($UsersKey,$true)
    $SubKey.SetValue("IsInstalled",0,[Microsoft.Win32.RegistryValueKind]::DWORD)    
} else {
    Get-WindowsCapability -online | Where-Object -Property name -like "*MediaFeature*" | Add-WindowsCapability -Online
}


################################
#    Install WVD Componants    #
################################


$agent_deploy_status = Start-Process `
    -FilePath "msiexec.exe" `
    -ArgumentList "/i $LocalWVDpath$WVDAgentInstaller", `
        "/quiet", `
        "/qn", `
        "/norestart", `
        "/passive", `
        "REGISTRATIONTOKEN=$RegistrationToken" `
    -Wait `
    -Passthru

$sts = $agent_deploy_status.ExitCode
Write-Output "Installation of RD Agent completed with Exit code=$sts"
Remove-Item -Path $LocalWVDpath$WVDAgentInstaller -Force

Wait-Event -Timeout 5

$bootloader_deploy_status = Start-Process `
    -FilePath "msiexec.exe" `
    -ArgumentList "/i $LocalWVDpath$WVDBootInstaller", `
        "/quiet", `
        "/qn", `
        "/norestart", `
        "/passive", `
        "/l* $LocalWVDpath\AgentBootLoaderInstall.txt" `
    -Wait `
    -Passthru

$sts = $bootloader_deploy_status.ExitCode
Write-Output "Installation of RD BootLoader completed with Exit code=$sts"
Remove-Item -Path $LocalWVDpath$WVDBootInstaller -Force

Wait-Event -Timeout 5

#####################################
#   Configure direct path settings  #
#####################################
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations' -Name 'fUseUdpPortRedirector' -PropertyType:dword -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations' -Name 'UdpPortNumber' -PropertyType:dword -Value 3390 -Force

shutdown /r /t 30
