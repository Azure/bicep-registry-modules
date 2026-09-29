param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

$repoRootPath = (Resolve-Path -LiteralPath $repoRootPath -ErrorAction Stop).ProviderPath

Describe 'Bicep README drift coverage' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'Test-AvmReadmeDrift.ps1')
        $script:supportingReadmes = @(
            'avm/ptn/aca-lza/hosting-environment/modules/container-apps-environment/README.md'
            'avm/ptn/aca-lza/hosting-environment/modules/spoke/README.md'
            'avm/ptn/aca-lza/hosting-environment/modules/supporting-services/README.md'
        )
        $script:fixtureRoot = Join-Path $TestDrive 'preserved'
        foreach ($relative in $script:supportingReadmes) {
            $target = Join-Path $script:fixtureRoot $relative
            $null = New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force
            Copy-Item -LiteralPath (Join-Path $repoRootPath $relative) -Destination $target
        }
    }

    BeforeEach {
        foreach ($relative in $script:supportingReadmes) {
            Copy-Item -LiteralPath (Join-Path $repoRootPath $relative) `
                -Destination (Join-Path $script:fixtureRoot $relative) -Force
        }
        foreach ($name in @('main.json', 'metadata.json')) {
            $path = Join-Path $script:fixtureRoot (Split-Path $script:supportingReadmes[0] -Parent) $name
            if (Test-Path -LiteralPath $path) {
                Remove-Item -LiteralPath $path
            }
        }
    }

    It 'accounts for exactly 574 source-backed and three approved source-less READMEs' {
        $inventory = Get-AvmReadmeDriftInventory -RepoRootPath $repoRootPath
        $fullScan = Get-AvmReadmeDriftSelection -SourceReadmes $inventory.SourceReadmes `
            -ChangedFilePath @('bicepconfig.json')

        $inventory.SourceReadmes.Count | Should -Be 574
        $inventory.SourceLessReadmes | Should -Be $script:supportingReadmes
        $fullScan.SourceReadmes.Count | Should -Be 574
        $fullScan.Scopes | Should -Be @('.')
    }

    It 'preserves the three source-less READMEs by exact bytes and hashes' {
        {
            Assert-AvmReadmePreservation -RepoRootPath $script:fixtureRoot `
                -SourceLessReadmes $script:supportingReadmes
        } | Should -Not -Throw
    }

    It 'rejects changed source-less README bytes' {
        $path = Join-Path $script:fixtureRoot $script:supportingReadmes[0]
        [IO.File]::AppendAllText($path, 'changed')

        {
            Assert-AvmReadmePreservation -RepoRootPath $script:fixtureRoot `
                -SourceLessReadmes $script:supportingReadmes
        } | Should -Throw '*bytes changed*'
    }

    It 'rejects a newly discovered source-less README' {
        {
            Assert-AvmReadmePreservation -RepoRootPath $script:fixtureRoot `
                -SourceLessReadmes ($script:supportingReadmes + 'avm/ptn/example/extra/README.md')
        } | Should -Throw '*exactly three*'
    }

    It 'rejects adding compiled JSON or metadata to a source-less supporting folder' -ForEach @(
        @{ FileName = 'main.json' }
        @{ FileName = 'metadata.json' }
    ) {
        $path = Join-Path $script:fixtureRoot (Split-Path $script:supportingReadmes[0] -Parent) $FileName
        [IO.File]::WriteAllText($path, '{}')

        {
            Assert-AvmReadmePreservation -RepoRootPath $script:fixtureRoot `
                -SourceLessReadmes $script:supportingReadmes
        } | Should -Throw '*no longer source-less*'
    }

    It 'rejects a missing or replaced approved source-less README' {
        $path = Join-Path $script:fixtureRoot $script:supportingReadmes[1]
        Remove-Item -LiteralPath $path
        {
            Assert-AvmReadmePreservation -RepoRootPath $script:fixtureRoot `
                -SourceLessReadmes $script:supportingReadmes
        } | Should -Throw '*missing*'

        $replaced = @($script:supportingReadmes[0], 'avm/ptn/example/extra/README.md', $script:supportingReadmes[2])
        {
            Assert-AvmReadmePreservation -RepoRootPath $script:fixtureRoot `
                -SourceLessReadmes $replaced
        } | Should -Throw '*coverage changed*'
    }
}

Describe 'README-only pull request selection' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'Test-AvmReadmeDrift.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleWorkflowMatrix.ps1')
        $script:sourceReadmes = @(
            'avm/res/network/virtual-network/README.md'
            'avm/res/storage/storage-account/README.md'
            'avm/res/storage/storage-account/blob-service/container/README.md'
        )
    }

    It 'selects a README-only change for docs but not the existing deployment matrix' {
        $change = 'avm/res/network/virtual-network/README.md'
        $selection = Get-AvmReadmeDriftSelection -SourceReadmes $script:sourceReadmes `
            -ChangedFilePath @($change)
        $deployment = Get-ModuleWorkflowMatrix -ChangedFilePath @($change) -RepoRoot $repoRootPath

        $selection.Scopes | Should -Be @('avm/res/network/virtual-network')
        $selection.SourceReadmes | Should -Be @($change)
        $selection.CompileScopes | Should -BeNullOrEmpty
        $deployment.include.Count | Should -Be 0
    }

    It 'selects the containing top-level module and recompiles child sources under modules' {
        $selection = Get-AvmReadmeDriftSelection -SourceReadmes @(
            'avm/ptn/aca-lza/hosting-environment/README.md'
            'avm/ptn/aca-lza/hosting-environment/modules/child/README.md'
            'avm/res/storage/storage-account/README.md'
        ) -ChangedFilePath @('avm/ptn/aca-lza/hosting-environment/modules/child/main.bicep')

        $selection.Scopes | Should -Be @('avm/ptn/aca-lza/hosting-environment')
        $selection.CompileScopes | Should -Be @('avm/ptn/aca-lza/hosting-environment')
        $selection.SourceReadmes | Should -Be @(
            'avm/ptn/aca-lza/hosting-environment/README.md'
            'avm/ptn/aca-lza/hosting-environment/modules/child/README.md'
        )
    }

    It 'checks all source-backed READMEs when the tracked root config or template changes' -ForEach @(
        @{ ChangedPath = 'bicepconfig.json' }
        @{ ChangedPath = 'docs/templates/avm-readme-v1.scriban' }
        @{ ChangedPath = 'avm-readme-v1.scriban' }
    ) {
        $selection = Get-AvmReadmeDriftSelection -SourceReadmes $script:sourceReadmes `
            -ChangedFilePath @($ChangedPath)

        $selection.Scopes | Should -Be @('.')
        $selection.SourceReadmes | Should -Be $script:sourceReadmes
    }

    It 'rejects a parent-directory traversal in changed paths' {
        {
            Get-AvmReadmeDriftSelection -SourceReadmes $script:sourceReadmes `
                -ChangedFilePath @('avm/res/network/../virtual-network/README.md')
        } | Should -Throw '*repository-relative*'
    }
}

Describe 'Fail-closed Bicep README drift checking' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'Test-AvmReadmeDrift.ps1')
        $script:fixtureRoot = Join-Path $TestDrive 'docs'
        $script:modulePath = 'avm/res/example/module'
        $script:readmePath = "$($script:modulePath)/README.md"
        $script:readmeFile = Join-Path $script:fixtureRoot $script:readmePath
        $script:jsonFile = Join-Path $script:fixtureRoot "$($script:modulePath)/main.json"
        $script:toolPath = Join-Path $TestDrive 'pinned-bicep'
        $null = New-Item -ItemType Directory -Path (Split-Path $script:readmeFile -Parent) -Force
        [IO.File]::WriteAllText($script:toolPath, 'test tool placeholder')

        function Invoke-AvmDocs {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Mock the pinned Avm.Authoring command by its real name.')]
            param()
            throw 'Unmocked docs invocation.'
        }
        function Get-AvmTool { throw 'Unmocked tool lookup.' }
        function Install-AvmTool { throw 'Unmocked tool installation.' }
    }

    BeforeEach {
        [IO.File]::WriteAllText($script:readmeFile, 'expected')
        [IO.File]::WriteAllText($script:jsonFile, 'stale')
        $script:inventory = [pscustomobject]@{
            Root              = $script:fixtureRoot
            SourceReadmes     = @($script:readmePath)
            SourceLessReadmes = @()
        }
        $script:docsResult = [pscustomobject]@{
            Engine           = 'bicep'
            Status           = 'pass'
            FilesSelected    = 1
            FilesProcessed   = 1
            NotRendered      = @()
            Changed          = @()
            Issues           = @()
            GeneratedReadmes = @([pscustomobject]@{ Path = 'README.md'; Content = 'expected' })
        }
        Mock Get-AvmReadmeDriftInventory { $script:inventory }
        Mock Invoke-AvmDocs { $script:docsResult }
        Mock Get-AvmTool { [pscustomobject]@{ Status = 'installed'; Path = $script:toolPath } }
        Mock Install-AvmTool { throw 'Unexpected pinned tool installation.' }
        Mock Get-AvmReadmeCompiledJson { return ,([Text.Encoding]::UTF8.GetBytes('fresh')) }
    }

    It 'checks README-only changes without writing files, including with -WhatIf' {
        $before = [IO.File]::ReadAllBytes($script:readmeFile)

        $result = Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
            -ChangedFilePath @($script:readmePath) -WhatIf

        $result.Status | Should -Be 'pass'
        $result.FilesProcessed | Should -Be 1
        [IO.File]::ReadAllBytes($script:readmeFile) | Should -Be $before
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'stale'
        Should -Invoke -CommandName Get-AvmReadmeCompiledJson -Exactly -Times 0
        Should -Invoke -CommandName Invoke-AvmDocs -Exactly -Times 1
    }

    It 'accepts unchanged historical compiler metadata on a README-only change' {
        $legacyJson = '{"metadata":{"_generator":{"name":"bicep","version":"0.41.2.15936"}}}'
        [IO.File]::WriteAllText($script:jsonFile, $legacyJson)

        $result = Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
            -ChangedFilePath @($script:readmePath)

        $result.Status | Should -Be 'pass'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be $legacyJson
        Should -Invoke -CommandName Get-AvmTool -Exactly -Times 0
        Should -Invoke -CommandName Get-AvmReadmeCompiledJson -Exactly -Times 0
    }

    It 'does not recompile historical JSON for config/template-only full scans' -ForEach @(
        @{ ChangedPath = 'bicepconfig.json' }
        @{ ChangedPath = 'docs/templates/avm-readme-v1.scriban' }
    ) {
        $legacyJson = '{"metadata":{"_generator":{"name":"bicep","version":"0.41.2.15936"}}}'
        [IO.File]::WriteAllText($script:jsonFile, $legacyJson)
        $script:docsResult.GeneratedReadmes[0].Path = $script:readmePath

        $result = Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
            -ChangedFilePath @($ChangedPath)

        $result.Status | Should -Be 'pass'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be $legacyJson
        Should -Invoke -CommandName Get-AvmTool -Exactly -Times 0
        Should -Invoke -CommandName Get-AvmReadmeCompiledJson -Exactly -Times 0
    }

    It 'refreshes JSON before docs and fails if the checked-in JSON was stale' {
        [IO.File]::WriteAllText($script:jsonFile, '{"metadata":{"_generator":{"version":"0.41.2.15936"}}}')
        Mock Invoke-AvmDocs {
            if ([IO.File]::ReadAllText($script:jsonFile) -cne 'fresh') {
                throw 'Docs saw stale compiled JSON.'
            }
            $script:docsResult
        }

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/main.bicep") -DisposableCheckout
        } | Should -Throw '*Compiled JSON drifted*'

        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'fresh'
        [IO.File]::ReadAllText($script:readmeFile) | Should -Be 'expected'
        Should -Invoke -CommandName Invoke-AvmDocs -Exactly -Times 1
    }

    It 'compiles parents and changed children under modules before comparing READMEs' {
        $childReadme = "$($script:modulePath)/modules/child/README.md"
        $childFile = Join-Path $script:fixtureRoot $childReadme
        $childJson = Join-Path $script:fixtureRoot "$($script:modulePath)/modules/child/main.json"
        $null = New-Item -ItemType Directory -Path (Split-Path $childFile -Parent) -Force
        [IO.File]::WriteAllText($childFile, 'child expected')
        [IO.File]::WriteAllText($childJson, 'child stale')
        $script:inventory.SourceReadmes = @($script:readmePath, $childReadme)
        $script:docsResult.FilesSelected = 2
        $script:docsResult.FilesProcessed = 2
        $script:docsResult.GeneratedReadmes += [pscustomobject]@{
            Path = 'modules/child/README.md'; Content = 'child expected'
        }
        Mock Get-AvmReadmeCompiledJson {
            if ($SourcePath -match 'modules[\\/]child') {
                return ,([Text.Encoding]::UTF8.GetBytes('child fresh'))
            }
            return ,([Text.Encoding]::UTF8.GetBytes('parent fresh'))
        }

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/modules/child/main.bicep") -DisposableCheckout
        } | Should -Throw '*Compiled JSON drifted*'

        [IO.File]::ReadAllText($childJson) | Should -Be 'child fresh'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'parent fresh'
        [IO.File]::ReadAllText($childFile) | Should -Be 'child expected'
        Should -Invoke -CommandName Get-AvmReadmeCompiledJson -Exactly -Times 2
    }

    It 'passes changed source only when the compiled JSON and README are already current' {
        [IO.File]::WriteAllText($script:jsonFile, 'fresh')

        $result = Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
            -ChangedFilePath @("$($script:modulePath)/main.bicep") -DisposableCheckout

        $result.Status | Should -Be 'pass'
        [IO.File]::ReadAllText($script:readmeFile) | Should -Be 'expected'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'fresh'
    }

    It 'refuses source compilation outside a disposable checkout or under -WhatIf' {
        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/main.bicep")
        } | Should -Throw '*-DisposableCheckout*'
        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/main.bicep") -DisposableCheckout -WhatIf
        } | Should -Throw '*-WhatIf*'
        [IO.File]::ReadAllText($script:readmeFile) | Should -Be 'expected'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'stale'
        Should -Invoke -CommandName Get-AvmReadmeCompiledJson -Exactly -Times 0
    }

    It 'rejects compiler failure without rewriting JSON or the README' {
        Mock Get-AvmReadmeCompiledJson { throw 'Bicep build failed: invalid main.bicep' }

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/main.bicep") -DisposableCheckout
        } | Should -Throw '*Bicep build failed*'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'stale'
        [IO.File]::ReadAllText($script:readmeFile) | Should -Be 'expected'
        Should -Invoke -CommandName Invoke-AvmDocs -Exactly -Times 0
    }

    It 'does not partially refresh JSON when a later child compilation fails' {
        $script:inventory.SourceReadmes = @(
            $script:readmePath
            "$($script:modulePath)/modules/child/README.md"
        )
        Mock Get-AvmReadmeCompiledJson {
            if ($SourcePath -match 'modules[\\/]child') {
                throw 'Bicep build failed: invalid child main.bicep'
            }
            return ,([Text.Encoding]::UTF8.GetBytes('parent fresh'))
        }

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/modules/child/main.bicep") -DisposableCheckout
        } | Should -Throw '*invalid child main.bicep*'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'stale'
        [IO.File]::ReadAllText($script:readmeFile) | Should -Be 'expected'
        Should -Invoke -CommandName Invoke-AvmDocs -Exactly -Times 0
    }

    It 'does not fall back to a PATH compiler when the pinned tool is unavailable' {
        Mock Get-AvmTool { [pscustomobject]@{ Status = 'auto-install-disabled'; Path = $null } }

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/main.bicep") -DisposableCheckout
        } | Should -Throw '*SHA-pinned Bicep CLI is unavailable*'
        [IO.File]::ReadAllText($script:jsonFile) | Should -Be 'stale'
        Should -Invoke -CommandName Install-AvmTool -Exactly -Times 0
    }

    It 'rejects invalid test source, missing Notes, and malformed JSON render failures' -ForEach @(
        @{ Failure = 'invalid test source' }
        @{ Failure = 'missing README.notes.md' }
        @{ Failure = 'malformed main.json' }
    ) {
        $script:docsResult.Status = 'fail'
        $script:docsResult.FilesProcessed = 0
        $script:docsResult.GeneratedReadmes = @()
        $script:docsResult.Issues = @([pscustomobject]@{
                File = 'README.md'; Severity = 'error'; Code = 'avm.bicep.docs-render-failed'; Message = $Failure
            })
        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @("$($script:modulePath)/tests/e2e/defaults/main.test.bicep")
        } | Should -Throw '*avm.bicep.docs-render-failed*'
        [IO.File]::ReadAllText($script:readmeFile) | Should -Be 'expected'
    }

    It 'propagates missing or mismatched tracked Scriban template errors' -ForEach @(
        @{ Failure = 'No bicepconfig.json was found' }
        @{ Failure = 'Scriban template differs from the packaged version' }
    ) {
        Mock Invoke-AvmDocs { throw $Failure }

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @($script:readmePath)
        } | Should -Throw "*$Failure*"
        [IO.File]::ReadAllText($script:readmeFile) | Should -Be 'expected'
    }

    It 'rejects a selected/processed count mismatch or an unexpected generated path' {
        $script:docsResult.FilesProcessed = 0
        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @($script:readmePath)
        } | Should -Throw '*did not process every selected README*'

        $script:docsResult.FilesProcessed = 1
        $script:docsResult.GeneratedReadmes[0].Path = 'unexpected/README.md'
        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @($script:readmePath)
        } | Should -Throw '*Unexpected or incomplete generated README*'
    }

    It 'rejects a malformed docs result instead of treating missing issues as success' {
        $script:docsResult.Issues = $null

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @($script:readmePath)
        } | Should -Throw '*non-array*Issues*'
    }

    It 'rejects unapproved source-less issues instead of treating a failed tool result as success' {
        $script:docsResult.Status = 'fail'
        $script:docsResult.NotRendered = @('modules/unapproved/README.md')
        $script:docsResult.Issues = @([pscustomobject]@{
                File = 'modules/unapproved/README.md'; Severity = 'error'
                Code = 'avm.bicep.docs-no-source'; Message = 'Unknown source-less README.'
            })
        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @($script:readmePath)
        } | Should -Throw '*Source-less README coverage changed*'
    }

    It 'accepts only the three verified source-less README issues from a failed docs result' {
        $root = 'avm/ptn/aca-lza/hosting-environment'
        $relative = "$root/README.md"
        $file = Join-Path $script:fixtureRoot $relative
        $null = New-Item -ItemType Directory -Path (Split-Path $file -Parent) -Force
        [IO.File]::WriteAllText($file, 'expected')
        $script:inventory.SourceReadmes = @($relative)
        $script:inventory.SourceLessReadmes = @(
            "$root/modules/container-apps-environment/README.md"
            "$root/modules/spoke/README.md"
            "$root/modules/supporting-services/README.md"
        )
        $script:docsResult.Status = 'fail'
        $script:docsResult.GeneratedReadmes = @([pscustomobject]@{
                Path = 'README.md'; Content = 'expected'
            })
        $script:docsResult.NotRendered = @(
            'modules/container-apps-environment/README.md'
            'modules/spoke/README.md'
            'modules/supporting-services/README.md'
        )
        $script:docsResult.Issues = @($script:docsResult.NotRendered | ForEach-Object {
                [pscustomobject]@{
                    File = $_; Severity = 'error'; Code = 'avm.bicep.docs-no-source'; Message = 'No source.'
                }
            })

        $result = Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
            -ChangedFilePath @($relative)
        $result.Status | Should -Be 'pass'
        $result.SourceLessCount | Should -Be 3

        $script:docsResult.Issues = @($script:docsResult.Issues[0..1])
        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @($relative)
        } | Should -Throw '*issue/status mismatch*'
    }

    It 'rejects a stale issue outside the exact Vault exception' {
        $script:docsResult.Status = 'fail'
        $script:docsResult.Issues = @([pscustomobject]@{
                File = 'README.md'; Severity = 'error'
                Code = 'avm.bicep.docs-stale'; Message = 'Unexpected stale README.'
            })

        {
            Test-AvmReadmeDrift -RepoRootPath $script:fixtureRoot `
                -ChangedFilePath @($script:readmePath)
        } | Should -Throw '*avm.bicep.docs-stale*'
    }
}

Describe 'Pinned Vault historical exception and workflow isolation' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'Test-AvmReadmeDrift.ps1')
        $script:vaultPath = 'avm/res/key-vault/vault/README.md'
        $script:current = [IO.File]::ReadAllBytes((Join-Path $repoRootPath $script:vaultPath))
        $lines = [Text.UTF8Encoding]::new($false, $true).GetString($script:current).Split([char]"`n")
        $insertions = @{
            182 = '    // Required parameters'; 185 = '    // Non-required parameters'
            549 = '    // Required parameters'; 552 = '    // Non-required parameters'
            1134 = '    // Required parameters'; 1137 = '    // Non-required parameters'
            1347 = '    // Required parameters'; 1350 = '    // Non-required parameters'
        }
        $rendered = [Text.StringBuilder]::new()
        for ($index = 0; $index -lt $lines.Length; $index++) {
            if ($index -gt 0) { $null = $rendered.Append("`n") }
            $null = $rendered.Append($lines[$index])
            if ($insertions.ContainsKey($index + 1)) {
                $null = $rendered.Append("`n").Append($insertions[$index + 1])
            }
        }
        $script:approved = [Text.Encoding]::UTF8.GetBytes($rendered.ToString())
    }

    It 'allows exactly the eight pinned comment lines in the unmodified Vault README' {
        Test-AvmReadmeApprovedVaultDifference -RelativePath $script:vaultPath `
            -CurrentBytes $script:current -GeneratedBytes $script:approved | Should -BeTrue
    }

    It 'rejects other paths, extra changed bytes, or a modified Vault README' {
        $changedOutput = [byte[]]$script:approved.Clone()
        $changedOutput[10] = $changedOutput[10] -bxor 1
        $changedInput = [byte[]]$script:current.Clone()
        $changedInput[10] = $changedInput[10] -bxor 1

        Test-AvmReadmeApprovedVaultDifference -RelativePath 'avm/res/another/module/README.md' `
            -CurrentBytes $script:current -GeneratedBytes $script:approved | Should -BeFalse
        Test-AvmReadmeApprovedVaultDifference -RelativePath $script:vaultPath `
            -CurrentBytes $script:current -GeneratedBytes $changedOutput | Should -BeFalse
        Test-AvmReadmeApprovedVaultDifference -RelativePath $script:vaultPath `
            -CurrentBytes $changedInput -GeneratedBytes $script:approved | Should -BeFalse
    }

    It 'keeps the new workflow manual-only, read-only, and pinned to unreleased authoring source' {
        $workflow = Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'avm.readme-drift.yml') -Raw

        $workflow | Should -Match '(?m)^on:\r?\n  workflow_dispatch:'
        $workflow | Should -Not -Match '(?m)^  (pull_request|pull_request_target|push|workflow_run):'
        $workflow | Should -Match '(?m)^  contents: read\r?$'
        $workflow | Should -Not -Match 'id-token:|secrets:|avm-setEnvironment|AllowPathFallback'
        $workflow | Should -Match '(?m)^  AVM_AUTHORING_SHA: "[0-9a-f]{40}"\r?$'
        $workflow | Should -Match ([regex]::Escape('ref: "${{ env.AVM_AUTHORING_SHA }}"'))
        $workflow | Should -Match ([regex]::Escape('$checkoutCommit -cne $env:AVM_AUTHORING_SHA'))
        $workflow | Should -Match 'Import-Module -Name'
        $workflow | Should -Match 'persist-credentials: false'
        $workflow | Should -Match 'Test-AvmReadmeDrift @input'
    }
}
