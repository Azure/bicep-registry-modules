$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

if (-not (Test-Path -LiteralPath $env:STATE_PATH)) {
    throw 'The test cleanup state is unavailable; service logs cannot be scoped safely.'
}
$state = Get-Content -LiteralPath $env:STATE_PATH -Raw | ConvertFrom-Json
if ([string]$state.subscriptionId -cne $env:SUBSCRIPTION_ID) {
    throw 'The saved state does not match the selected subscription.'
}
$groups = @($state.ownedResourceGroups | Where-Object {
        $_.type -ceq 'Microsoft.Resources/resourceGroups' -and
        $_.id -match ('^/subscriptions/' + [regex]::Escape($env:SUBSCRIPTION_ID) + '/resourceGroups/[^/]+$')
    })
if ($groups.Count -eq 0) {
    throw 'No owned resource groups were recorded; service logs cannot be scoped safely.'
}

$outputDir = Join-Path $env:RUNNER_TEMP 'encrypted-service-logs'
$null = New-Item -ItemType Directory -Path $outputDir -Force
$count = 0
foreach ($group in $groups) {
    $groupName = ($group.id -split '/')[-1]
    $registries = @(az acr list --subscription $env:SUBSCRIPTION_ID --resource-group $groupName --query '[].name' --output tsv --only-show-errors 2>$null)
    if ($LASTEXITCODE -ne 0) { throw 'Unable to list registries in an owned test resource group.' }
    foreach ($registry in $registries) {
        $runs = @(az acr task list-runs --subscription $env:SUBSCRIPTION_ID --resource-group $groupName --registry $registry --query "[?status=='Failed'].runId" --output tsv --only-show-errors 2>$null)
        if ($LASTEXITCODE -ne 0) { throw 'Unable to list failed registry task runs.' }
        foreach ($run in $runs) {
            $content = @(az acr task logs --subscription $env:SUBSCRIPTION_ID --resource-group $groupName --registry $registry --run-id $run --only-show-errors 2>$null)
            if ($LASTEXITCODE -ne 0) { throw 'Unable to retrieve a registry task log.' }
            $plaintext = Join-Path $env:RUNNER_TEMP ([guid]::NewGuid().ToString('N') + '.log')
            try {
                [IO.File]::WriteAllLines($plaintext, [string[]]$content)
                $encrypted = Join-Path $outputDir ("task-{0}.p7m" -f $count)
                & openssl cms -encrypt -aes-256-gcm -binary -outform DER -in $plaintext -out $encrypted $env:DIAGNOSTIC_CERT 2>$null
                if ($LASTEXITCODE -ne 0) { throw 'Unable to encrypt a service log.' }
                $count++
            }
            finally {
                if (Test-Path -LiteralPath $plaintext) {
                    Remove-Item -LiteralPath $plaintext -Force
                }
            }
        }
    }
}
if ($count -eq 0) { throw 'No failed registry task logs were found in owned test resource groups.' }
Write-Host "Encrypted $count service log(s)."
