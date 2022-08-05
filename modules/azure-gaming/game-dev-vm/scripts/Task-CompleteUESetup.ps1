param (
    [string]$ueVersion = '',
    [string]$ueEditor = ''
)

switch ($ueVersion[0]) {
    '4' { $uePrereqs='UE4PrereqSetup_x64.exe'}
    '5' { $uePrereqs = 'UEPrereqSetup_x64.exe' }
}

if ($ueVersion -and $ueEditor) {

    $ueEditorExe = "E:\Epic Games\UE_$ueVersion\Engine\Binaries\Win64\$ueEditor"

    netsh advfirewall firewall add rule name='UnrealEditor' dir=in action=allow program="$ueEditorExe" protocol=TCP profile=Public
    netsh advfirewall firewall add rule name='UnrealEditor' dir=in action=allow program="$ueEditorExe" protocol=UDP profile=Public

    & "E:\Epic Games\UE_$ueVersion\Engine\Extras\Redist\en-us\$uePrereqs" /quiet

    $shortcutLocation = $env:Public + '\Desktop\Unreal Editor.lnk'
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutLocation)
    $shortcut.TargetPath = "$ueEditorExe"
    $shortcut.Save()
}     