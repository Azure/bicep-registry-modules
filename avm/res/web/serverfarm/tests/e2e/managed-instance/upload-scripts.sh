#!/bin/bash
# Creates a scripts.zip archive containing a placeholder install script
# and uploads it to the blob container for the Managed Instance test.

set -euo pipefail

# Create a temporary directory for the scripts
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Create a placeholder install.ps1 that mimics the real script structure
cat > "$TEMP_DIR/install.ps1" << 'PWSH'
<#
  Placeholder install script for AVM e2e testing.
  The real install script and fonts are stored alongside the Bicep test files
  in the scripts/ folder for reference.
#>

# Create a registry key with a string value
Write-Host "Creating registry key..."
$registryPath = "HKLM:\SOFTWARE\MyApp2"
if (-not (Test-Path $registryPath)) {
  New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name "SettingFromInstallScript" -Value "ValueFromInstallScript" -Type String
Write-Host "Registry key creation completed."

# Create a config file on the C: drive
Write-Host "Creating config file..."
$filePath = "C:\MyApp\Config.json"
$fileDirectory = Split-Path -Path $filePath -Parent
if (-not (Test-Path $fileDirectory)) {
  New-Item -Path $fileDirectory -ItemType Directory -Force | Out-Null
}
Set-Content -Path $filePath -Value '{"setting1":true,"setting2":"Value2"}' -Force
Write-Host "Config file creation completed."
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
