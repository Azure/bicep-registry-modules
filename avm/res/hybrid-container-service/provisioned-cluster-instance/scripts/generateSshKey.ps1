# Create temp directory in a known location
$tempDir = '/tmp/sshkeys'
New-Item -ItemType Directory -Path $tempDir -Force
Set-Location $tempDir
# Generate SSH key pair using ssh-keygen
ssh-keygen -t rsa -b 4096 -f ./key -N '""' -q
# Read the generated keys
$publicKey = Get-Content -Path './key.pub' -Raw
$privateKey = Get-Content -Path './key' -Raw
# Clean up temp files
Remove-Item -Path './key*' -Force
Remove-Item -Path $tempDir -Force -Recurse
# Set output
$DeploymentScriptOutputs = @{}
$DeploymentScriptOutputs['publicKey'] = $publicKey
$DeploymentScriptOutputs['privateKey'] = $privateKey
