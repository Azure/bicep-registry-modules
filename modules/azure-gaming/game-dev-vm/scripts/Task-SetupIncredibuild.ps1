param (
    [bool]$installIB=$true,
    [bool]$registerIB=$false)

$keyFile = 'C:\Azure-GDVM\ibLicenseKey.IB_lic'
$logFile = 'C:\Users\Public\Desktop\INSTALLED_SOFTWARE.txt'

$vsPath = ${env:ProgramFiles(x86)} + '\Microsoft Visual Studio\Installer\vs_installer.exe'
$vsInstallPath = ${env:ProgramFiles(x86)} + '\Microsoft Visual Studio\2019\Community'

if (Test-Path -Path $keyFile) {

    if ($installIB) {
        try {
            $arguments = ' modify --installpath "' + $vsInstallPath +'" --add Component.Incredibuild --quiet'
    
            $process = Start-Process -FilePath $vsPath -ArgumentList $arguments -WindowStyle Hidden -PassThru
            $process | Wait-Process -Timeout 600 -ErrorAction SilentlyContinue -ErrorVariable stillRunning
            if ($stillRunning) {
                throw "Failed to configure Incredibuild"   
            }

            (Get-Content 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd').replace('SET GDKSuccess=1', "powershell $PSCommandPath -installIB `$false -registerIB `$true`r`nSET GDKSuccess=1") | Set-Content 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd'
        }
        catch [Exception] {
            Add-Content $logFile 'ERROR: Incredibuild installation has failed. Please check the Incredibuild setup.'
        }
    }

    if ($registerIB) {
        try {
            Add-Type -AssemblyName PresentationCore,PresentationFramework

            $licenseMessage = & cmd /c $keyFile

            if ($licenseMessage.ToLower().Contains('success')) {
                Add-Content $logFile '- Incredibuild'
                [System.Windows.MessageBox]::Show("$licenseMessage If you delete your viritual machine, please remember to unload your Incredibuild license key first.", 'Incredibuild License Key', 'OK', 'Information')
            }
            else {
                $msgBoxInput = [System.Windows.MessageBox]::Show("$licenseMessage Without a license key, all Unreal/Incredibuild builds will be limited to using 1 core. You can load a license key manually.`r`n`r`nAlternately, do you want to uninstall Incredibuild now?", 'Uninstall Incredibuild?', 'YesNo', 'Warning')
                switch ($msgBoxInput) {
                    'Yes' {
                        $arguments = ' modify --installpath "' + $vsInstallPath +'" --remove Component.Incredibuild --quiet'
                        Start-Process -FilePath $vsPath -ArgumentList $arguments -WindowStyle Hidden | Out-Null
                    }
                    'No' {
                        Add-Content $logFile '- Incredibuild'
                        Add-Content $logFile "ERROR: Your Incredibuild license failed to load with message: $licenseMessage"
                    }
                }                
            }
        }
        catch [Exception]{
            Add-Content $logFile "ERROR: Loading of the Incredibuild license key has failed. Please check the Incredibuild settings. Details: $PSItem"
        }
        finally {
            Remove-Item -Path $keyFile
        }
    }
}