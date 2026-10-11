param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'HCI fixture resource names' {
    BeforeAll {
        Copy-Item -LiteralPath (Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'functions' 'unique-resource-name.bicep') -Destination $TestDrive
        $scopes = @(
            '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/hci-a'
            '/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/hci-a'
            '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/hci-b'
        )
        $parameterNames = @('clusterWitnessStorageAccountName', 'keyVaultDiagnosticStorageAccountName', 'keyVaultName')
        $lines = @('using none', "import { uniqueResourceName } from './unique-resource-name.bicep'")
        foreach ($case in @('defaults', 'max', 'waf-aligned')) {
            $source = Get-Content -LiteralPath (Join-Path $RepoRootPath 'avm' 'res' 'hybrid-container-service' 'provisioned-cluster-instance' 'tests' 'e2e' $case 'main.test.bicep') -Raw
            $serviceShort = [regex]::Match($source, "(?m)^param serviceShort string = '([^']+)'").Groups[1].Value
            if ([string]::IsNullOrEmpty($serviceShort)) { throw "Missing serviceShort in $case." }
            foreach ($parameter in $parameterNames) {
                $expression = [regex]::Match($source, "(?m)^\s+$parameter`: ([^\r\n]+)").Groups[1].Value
                if ([string]::IsNullOrEmpty($expression)) { throw "Missing $parameter in $case." }
                foreach ($scopeIndex in 0..2) {
                    foreach ($iteration in @('init', 'idem', 'retry')) {
                        $value = $expression.Replace('${namePrefix}', 'gci').Replace('${serviceShort}', $serviceShort).
                            Replace('resourceGroup.id', "'$($scopes[$scopeIndex])'")
                        $lines += "param $($case.Replace('-', ''))${parameter}${scopeIndex}${iteration} = $value"
                    }
                }
            }
        }
        $parameterPath = Join-Path $TestDrive 'hci-names.bicepparam'
        $outputPath = Join-Path $TestDrive 'hci-names.json'
        $lines -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $names = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Separates every global fixture name across subscriptions and groups for <Case>' -ForEach @(
        @{ Case = 'defaults' }
        @{ Case = 'max' }
        @{ Case = 'waf-aligned' }
    ) {
        $key = $Case.Replace('-', '')
        foreach ($parameter in $parameterNames) {
            $values = @(0..2 | ForEach-Object { $names["$key${parameter}${_}init"].value })
            @($values | Select-Object -Unique).Count | Should -Be 3
        }
    }

    It 'Keeps all fixture names valid, distinct and stable for deployment, idempotency and retry' {
        foreach ($case in @('defaults', 'max', 'wafaligned')) {
            foreach ($scopeIndex in 0..2) {
                $values = @()
                foreach ($parameter in $parameterNames) {
                    $key = "$case$parameter$scopeIndex"
                    $name = $names["${key}init"].value
                    $name.Length | Should -BeLessOrEqual 24
                    if ($parameter -eq 'keyVaultName') {
                        $name | Should -Match '^[a-z][a-z0-9-]{1,22}[a-z0-9]$'
                    } else {
                        $name | Should -Match '^[a-z0-9]{3,24}$'
                    }
                    $name | Should -Be $names["${key}idem"].value
                    $name | Should -Be $names["${key}retry"].value
                    $values += $name
                }
                @($values | Select-Object -Unique).Count | Should -Be $parameterNames.Count
            }
        }
    }
}
