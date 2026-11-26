$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$outputDir = Join-Path $env:RUNNER_TEMP 'encrypted-service-logs'
$null = New-Item -ItemType Directory -Path $outputDir -Force
$content = @(az acr task logs --subscription $env:SUBSCRIPTION_ID --resource-group $env:RESOURCE_GROUP --registry $env:REGISTRY_NAME --run-id ch1 --only-show-errors 2>$null)
if ($LASTEXITCODE -ne 0) { throw 'Unable to retrieve the registry task log.' }
$plaintext = Join-Path $env:RUNNER_TEMP ([guid]::NewGuid().ToString('N') + '.log')
try {
    [IO.File]::WriteAllLines($plaintext, [string[]]$content)
    $encrypted = Join-Path $outputDir 'task.p7m'
    & openssl cms -encrypt -aes-256-gcm -binary -outform DER -in $plaintext -out $encrypted $env:DIAGNOSTIC_CERT 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'Unable to encrypt the service log.' }
}
finally {
    if (Test-Path -LiteralPath $plaintext) {
        Remove-Item -LiteralPath $plaintext -Force
    }
}
Write-Host 'Encrypted the service log.'
