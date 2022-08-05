$customDataFile ='C:\AzureData\CustomData.bin'
$localCongifFile ='C:\Azure-GDVM\GameDevVMConfig.ini'

function GetConfigValue([string] $name){

    $value=''

    if (Test-Path -Path $customDataFile) {
        $inputValues= Get-Content -Path $customDataFile -Raw | ConvertFrom-StringData
        if ($inputValues.ContainsKey($name) -and $inputValues[$name] ) {
            $value= $inputValues[$name]
        }
    }

    if (-Not $value) {
        if (Test-Path -Path $localCongifFile) {
            $inputValues= Get-Content -Path $localCongifFile -Raw | ConvertFrom-StringData
            if ($inputValues.ContainsKey($name) -and $inputValues[$name] ) {
                $value= $inputValues[$name]
            }
        }
    }

    return $value
}

if (-not ((Test-Path -Path $customDataFile) -or (Test-Path -Path $localCongifFile))) { exit }
if (((GetConfigValue('deployedFromSolutionTemplate')) -eq 'True') -and $PSCommandPath.StartsWith('C:\Azure-GDVM')) { exit }

$fileShareStorageAccount = GetConfigValue('fileShareStorageAccount')
$fileShareStorageAccountKey = GetConfigValue('fileShareStorageAccountKey')
$fileShareName = GetConfigValue('fileShareName')

$p4Port = GetConfigValue('p4Port')
$p4Username = GetConfigValue('p4Username')
$p4Password = GetConfigValue('p4Password')
$p4Workspace = GetConfigValue('p4Workspace')
$p4Stream = GetConfigValue('p4Stream')
$p4ClientViews = GetConfigValue('p4ClientViews')

$ibLicenseKey = GetConfigValue('ibLicenseKey')
if ($ibLicenseKey) {
    $filename = 'C:\Azure-GDVM\ibLicenseKey.IB_lic'
    $bytes = [Convert]::FromBase64String($ibLicenseKey)
    [IO.File]::WriteAllBytes($filename, $bytes)
}

$gdkVersion = GetConfigValue('gdkVersion')
$useVmToSysprepCustomImage = GetConfigValue('useVmToSysprepCustomImage')

$remoteAccessTechnology = GetConfigValue('remoteAccessTechnology')
$avdRegKey = GetConfigValue('avdRegistrationKey')
$teradiciRegKey = GetConfigValue('teradiciRegKey')
$parsecTeamId = GetConfigValue('parsecTeamId')
$parsecTeamKey = GetConfigValue('parsecTeamKey')
$parsecHost = GetConfigValue('parsecHost')
$parsecUserEmail = GetConfigValue('parsecUserEmail')
$parsecIsGuestAccess = GetConfigValue('parsecIsGuestAccess')

try {

    $ueVersion = ''
    $ueEditor = ''

    If (Test-Path 'E:\Epic Games') {
        $ueDirs = (Get-Item -Path 'E:\Epic Games\UE_*')
        if ($ueDirs) {
            $ueVersion = $ueDIrs[0].Name.Split('_')[1]
            
            switch ($ueVersion[0]) {
                '4' { $ueEditor = 'UE4Editor.exe' }
                '5' { $ueEditor = 'UnrealEditor.exe' }
            }
        }
    }
 
    ./Task-CompleteUESetup.ps1 -ueVersion $ueVersion -ueEditor $ueEditor

    ./Task-CreateDataDisk.ps1

    ./Task-MountFileShare.ps1 -storageAccount $fileShareStorageAccount `
                              -storageAccountKey $fileShareStorageAccountKey `
                              -fileShareName $fileShareName

    ./Task-SyncP4Depot.ps1 -p4Port $p4Port `
                           -p4Username $p4Username `
                           -p4Password $p4Password `
                           -p4Workspace $p4Workspace `
                           -p4Stream $p4Stream `
                           -p4ClientViews $p4ClientViews

    ./Task-SetupIncredibuild.ps1

    ./Task-ConfigureLoginScripts.ps1 -gdkVersion $gdkVersion -ueVersion $ueVersion -ueEditor $ueEditor -useVmToSysprepCustomImage $useVmToSysprepCustomImage


    switch ($remoteAccessTechnology) {
        "RDP" { if ($avdRegKey) { ./Task-AvdRegistration.ps1 -RegistrationToken $avdRegKey } }

        "Teradici" { ./Task-RegisterTeradici.ps1 -pcoip_registration_code $teradiciRegKey }

        "Parsec" { ./Task-SetupParsec.ps1 -parsecRegistrationProperties "team_id=$parsecTeamId`:key=$parsecTeamKey`:name=$parsecHost`:user_email=$parsecUserEmail`:is_guest_access=$parsecIsGuestAccess" }
    }
}
catch [Exception] {
    throw $_.Exception.Message
}
finally {
    if (Test-Path -Path $customDataFile) { Remove-Item -Path C:\AzureData -Recurse -Force }
    if (Test-Path -Path $localCongifFile) { Remove-Item -Path $localCongifFile -Force }
}


