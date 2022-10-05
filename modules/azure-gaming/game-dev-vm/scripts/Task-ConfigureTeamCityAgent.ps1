param (
    [string]$teamCityServerUrl="",
    [string]$agentDirectory="C:\TeamCity\BuildAgent",
    [string]$agentPort="9090")

$agentZipFile = 'buildAgentFull.zip'
$agentDownloadUrl = "$teamCityServerUrl/update/$agentZipFile"
$jreDownloadUrl = "https://aka.ms/download-jdk/microsoft-jdk-17.0.4.1-windows-x64.zip"


$distBuildProperties = "$agentDirectory\conf\buildAgent.dist.properties"
$buildProperties = "$agentDirectory\conf\buildAgent.properties"
$wrapperConfig = "$agentDirectory\launcher\conf\wrapper.conf"

New-Item $agentDirectory -type directory

Invoke-WebRequest -Uri $agentDownloadUrl -OutFile "$agentDirectory\$agentZipFile"
Expand-Archive `
    -LiteralPath "$agentDirectory\$agentZipFile" `
    -DestinationPath "$agentDirectory" `
    -Force `
    -Verbose
Remove-Item -Path "$agentDirectory\$agentZipFile" -Force

Invoke-WebRequest -Uri $jreDownloadUrl -OutFile "$agentDirectory\jdk.zip"
Expand-Archive `
    -LiteralPath "$agentDirectory\jdk.zip" `
    -DestinationPath "$agentDirectory" `
    -Force `
    -Verbose
Remove-Item -Path "$agentDirectory\jdk.zip" -Force
Get-Item "$agentDirectory\jdk*" | Rename-Item   -NewName "jre"

Copy-Item $distBuildProperties -Destination $buildProperties
( Get-Content $buildProperties | ForEach {($_ -replace "^serverUrl=\S+", "serverUrl=$($teamCityServerUrl.Replace(':', '\:'))") -replace "^name=", "name=$env:Computername"  } ) | Set-Content $buildProperties

$ephimeralLocation = $agentDirectory
if (Test-Path "D:\") {
    $ephimeralLocation = $ephimeralLocation.Replace('C:', 'D:')
}
New-Item "$ephimeralLocation\work" -ItemType Directory -Force
New-Item "$ephimeralLocation\temp" -ItemType Directory -Force
$ephimeralLocation = $ephimeralLocation.Replace('\', '\\').Replace(':', '\:')

( Get-Content $buildProperties | ForEach {(($_ -replace "^workDir=\S+", "workDir=$ephimeralLocation\\work") -replace "^tempDir=\S+", "tempDir=$ephimeralLocation\\temp") -replace "^systemDir=\S+", "systemDir=$($agentDirectory.Replace('\', '\\').Replace(':', '\:'))\\system"  }) | Set-Content $buildProperties

Add-Content $buildProperties "env.TEAMCITY_JRE=$($agentDirectory.Replace('\', '\\').Replace(':', '\:'))\\jre"
Add-Content $buildProperties "ownPort=$agentPort"

( Get-Content $wrapperConfig | ForEach { $_ -replace "^wrapper.java.command=\S+", "wrapper.java.command=../jre/bin/java" } ) | Set-Content $wrapperConfig

netsh advfirewall firewall add rule name='TeamCity Build Agent' dir=in action=allow protocol=TCP localport=$agentPort
netsh advfirewall firewall add rule name='TeamCity Build Agent' dir=out action=allow protocol=TCP localport=$agentPort

pushd
cd "$agentDirectory\bin"
cmd /c "$agentDirectory\bin\service.install.bat"
cmd /c "$agentDirectory\bin\service.start.bat"
popd

# cmd /c "$agentDirectory\bin\service.stop.bat"
# cmd /c "$agentDirectory\bin\service.uninstall.bat"
# Remove-Item "$agentDirectory" -Recurse -Force
