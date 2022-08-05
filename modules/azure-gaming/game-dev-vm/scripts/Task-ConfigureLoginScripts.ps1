param (
    [string]$gdkVersion = '',
    [string]$ueVersion = '',
    [string]$ueEditor = '',
    [string]$useVmToSysprepCustomImage='False')


(Get-Content 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd').replace('[VERSION]', "$gdkVersion").replace('[UE_VERSION]', "$ueVersion").replace('[UE_EDITOR]', "$ueEditor") | Set-Content 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd'

if ([System.Convert]::ToBoolean($useVmToSysprepCustomImage)) {
    (Get-Content -Raw 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd').replace("@ECHO OFF`r`necho", "@ECHO OFF`r`nGoto Quit`r`necho") | Set-Content 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd'
} else {
    (Get-Content -Raw 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd').replace("@ECHO OFF`r`nGoto Quit", "@ECHO OFF") | Set-Content 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\gdkinstall.cmd'
}