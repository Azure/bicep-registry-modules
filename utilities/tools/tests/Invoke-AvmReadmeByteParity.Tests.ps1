BeforeAll {
    . (Join-Path $PSScriptRoot '..\Invoke-AvmReadmeByteParity.ps1')

    $script:repositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..\..')).ProviderPath
    $script:baselinePath = Join-Path $script:repositoryRoot 'utilities\tools\avm-readme-byte-baseline.json'
    $script:baseline = Get-Content -LiteralPath $script:baselinePath -Raw | ConvertFrom-Json
    $script:vaultPath = 'avm/res/key-vault/vault/README.md'
    $script:vaultEntry = $script:baseline.files | Where-Object relativePath -CEQ $script:vaultPath
    $script:vaultFile = Join-Path $script:repositoryRoot $script:vaultPath.Replace('/', '\')
    $script:expectedBytes = [IO.File]::ReadAllBytes($script:vaultFile)

    $utf8 = [Text.UTF8Encoding]::new($false, $true)
    $lines = $utf8.GetString($script:expectedBytes).Split([char]"`n")
    $comments = @{
        182  = '    // Required parameters'
        185  = '    // Non-required parameters'
        549  = '    // Required parameters'
        552  = '    // Non-required parameters'
        1134 = '    // Required parameters'
        1137 = '    // Non-required parameters'
        1347 = '    // Required parameters'
        1350 = '    // Non-required parameters'
    }
    $approvedLines = [Collections.Generic.List[string]]::new()
    for ($index = 0; $index -lt $lines.Length; $index++) {
        $approvedLines.Add($lines[$index])
        if ($comments.ContainsKey($index + 1)) {
            $approvedLines.Add($comments[$index + 1])
        }
    }
    $script:approvedBytes = $utf8.GetBytes($approvedLines -join "`n")
}

Describe 'AVM README byte-parity baseline' {
    It 'pins 577 distinct repository-relative paths without machine-specific fields' {
        $script:baseline.schemaVersion | Should -Be 1
        $script:baseline.count | Should -Be 577
        $script:baseline.files.Count | Should -Be 577
        ($script:baseline.PSObject.Properties.Name -contains 'repositoryRoot') | Should -BeFalse
        @($script:baseline.files | Group-Object relativePath | Where-Object Count -ne 1).Count |
            Should -Be 0
        @($script:baseline.files | Where-Object {
                $_.relativePath -cnotmatch '^avm/(res|ptn|utl)/.+/README\.md$' -or
                $_.sha256 -cnotmatch '^[0-9a-f]{64}$' -or
                $_.PSObject.Properties.Name -contains 'absolutePath'
            }).Count | Should -Be 0
    }

    It 'rejects a changed baseline before creating a checkout or modifying the source README' {
        $moduleFolder = Join-Path $TestDrive 'authoring'
        $null = New-Item -ItemType Directory -Path (Join-Path $moduleFolder 'Resources\bicep') -Force
        Set-Content -LiteralPath (Join-Path $moduleFolder 'Avm.Authoring.psd1') -Value '@{}'
        Set-Content -LiteralPath (Join-Path $moduleFolder 'Resources\bicep\avm-readme-v1.scriban') `
            -Value '{{ model.name }}'

        $altered = Get-Content -LiteralPath $script:baselinePath -Raw | ConvertFrom-Json
        $altered.files[0].sha256 = '0' * 64
        $alteredPath = Join-Path $TestDrive 'altered-baseline.json'
        $altered | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $alteredPath

        $work = Join-Path ([IO.Path]::GetTempPath()) "avm-readme-test-$([guid]::NewGuid().ToString('N'))"
        $report = Join-Path $TestDrive 'unused-report'
        $before = (Get-FileHash -LiteralPath $script:vaultFile -Algorithm SHA256).Hash
        {
            Invoke-AvmReadmeByteParity -SourceRepositoryPath $script:repositoryRoot `
                -BaselinePath $alteredPath `
                -AuthoringModulePath (Join-Path $moduleFolder 'Avm.Authoring.psd1') `
                -WorkingRepositoryPath $work -ReportDirectory $report
        } | Should -Throw '*README bytes differ from the immutable baseline*'
        (Test-Path -LiteralPath $work) | Should -BeFalse
        (Test-Path -LiteralPath $report) | Should -BeFalse
        (Get-FileHash -LiteralPath $script:vaultFile -Algorithm SHA256).Hash | Should -Be $before
    }
}

Describe 'Approved historical Vault README drift' {
    It 'accepts only the eight pinned JSON usage-example comments' {
        Test-AvmReadmeApprovedHistoricalDrift -RelativePath $script:vaultPath `
            -ExpectedBytes $script:expectedBytes -ActualBytes $script:approvedBytes `
            -ExpectedSha256 $script:vaultEntry.sha256 | Should -BeTrue
    }

    It 'rejects another path or another baseline hash' {
        Test-AvmReadmeApprovedHistoricalDrift -RelativePath 'avm/res/key-vault/vault/key/README.md' `
            -ExpectedBytes $script:expectedBytes -ActualBytes $script:approvedBytes `
            -ExpectedSha256 $script:vaultEntry.sha256 | Should -BeFalse
        Test-AvmReadmeApprovedHistoricalDrift -RelativePath $script:vaultPath `
            -ExpectedBytes $script:expectedBytes -ActualBytes $script:approvedBytes `
            -ExpectedSha256 ('0' * 64) | Should -BeFalse
    }

    It 'rejects any additional changed byte' {
        $extraChange = [byte[]]$script:approvedBytes.Clone()
        $extraChange[100] = $extraChange[100] -bxor 1
        Test-AvmReadmeApprovedHistoricalDrift -RelativePath $script:vaultPath `
            -ExpectedBytes $script:expectedBytes -ActualBytes $extraChange `
            -ExpectedSha256 $script:vaultEntry.sha256 | Should -BeFalse
    }
}
