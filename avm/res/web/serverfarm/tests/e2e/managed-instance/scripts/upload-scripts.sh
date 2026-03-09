#!/bin/bash
# Creates a scripts.zip archive containing the install script
# and uploads it to the blob container for the Managed Instance test.

set -euo pipefail

# Create a temporary directory for the scripts
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Create install.ps1 matching the Terraform managed_instance example
cat > "$TEMP_DIR/install.ps1" << 'PWSH'
<#
This is an example PowerShell script to show how to customize an App Service Managed Instance to perform additional configuration after it has been provisioned.
In this example, the script creates a registry key with a string value and creates a JSON configuration file on the C: drive.
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
PWSH

# Create the zip archive
cd "$TEMP_DIR"
python3 -c "
import zipfile, os
with zipfile.ZipFile('scripts.zip', 'w', zipfile.ZIP_DEFLATED) as zf:
    zf.write('install.ps1', 'install.ps1')
"

# Upload to blob storage using managed identity
az storage blob upload \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --container-name "scripts" \
  --name "scripts.zip" \
  --file "scripts.zip" \
  --auth-mode login \
  --overwrite

echo "scripts.zip uploaded successfully to container 'scripts'"
