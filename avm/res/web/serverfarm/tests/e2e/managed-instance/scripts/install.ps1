<#
This is an example PowerShell script to show how to customize an App Service Managed Instance to perform additional configuration after it has been provisioned.
In this example, the script creates a registry key with a string value, creates a JSON configuration file on the C: drive, and installs fonts from the current directory and subdirectories to the Windows Fonts folder.
You can RDP via Azure Bastion onto one of the instances in the App Service Managed Instance to see the results after deployment.
#>

# Create a registry key with a string value
Write-Host "Creating registry key..."

$registryPath = "HKLM:\SOFTWARE\MyApp2"
$valueName    = "SettingFromInstallScript"
$valueData    = "ValueFromInstallScript"
$valueType    = "String"

try {
  if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
  }

  Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData -Type $valueType
  Write-Host "Registry key creation completed." -ForegroundColor Green
}
catch {
  Write-Host "Error creating registry key: $($_.Exception.Message)" -ForegroundColor Red
}

# Create a file on the C: drive with some sample content
Write-Host "Creating file on C: drive..."

$filePath = "C:\MyApp\Config.json"
$content = ConvertTo-Json -InputObject [ordered]@{
  setting1 = $true
  setting2 = "Value2"
  setting3 = 42
  setting4 = @("hello", "world")
  setting5 = [ordered]@{
    nestedSetting1 = "NestedValue1"
    nestedSetting2 = 3.14
  }
} -Depth 3
$fileDirectory = Split-Path -Path $filePath -Parent

try {
  if (-not (Test-Path $fileDirectory)) {
    New-Item -Path $fileDirectory -ItemType Directory -Force | Out-Null
  }

  Set-Content -Path $filePath -Value $content -Force
  Write-Host "Config file creation completed." -ForegroundColor Green
}
catch {
  Write-Host "Error creating config file: $($_.Exception.Message)" -ForegroundColor Red
}

# Install fonts from the current directory and subdirectories
Write-Host "Install fonts..."

try {
  Get-ChildItem -Recurse -Include *.ttf, *.otf | ForEach-Object {
      $FontFullName = $_.FullName
      $FontName = $_.BaseName + " (TrueType)"
      $Destination = "$env:windir\Fonts\$($_.Name)"

      Write-Host "Installing font: $($_.Name)"
      Copy-Item $FontFullName -Destination $Destination -Force
      New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $FontName -PropertyType String -Value $_.Name -Force | Out-Null
  }

  Write-Host "Font installation completed." -ForegroundColor Green
}
catch {
  Write-Host "Error installing fonts: $($_.Exception.Message)" -ForegroundColor Red
}
