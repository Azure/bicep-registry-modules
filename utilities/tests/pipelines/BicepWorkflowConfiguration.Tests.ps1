param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Coordinated tools dependency updates' {
    It 'keeps every caller tools reference aligned without pinning Avm.Authoring' {
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $toolsRefs = @()
        foreach ($file in @('pr-check.yml', 'release.yml')) {
            $workflowPath = Join-Path $workflowRoot $file
            $content = Get-Content -LiteralPath $workflowPath -Raw
            $workflow = $content | ConvertFrom-Yaml
            $dispatchInputs = $workflow.on.workflow_dispatch.inputs
            $dispatchInputs.authoringSource.type | Should -BeExactly 'choice'
            $dispatchInputs.authoringSource.options | Should -Be @('gallery', 'repo')
            $dispatchInputs.authoringSource.default | Should -BeExactly 'gallery'
            $dispatchInputs.authoringSource.required | Should -BeTrue
            $dispatchInputs.authoringRef.type | Should -BeExactly 'string'
            $dispatchInputs.authoringRef.required | Should -BeFalse
            $dispatchInputs.authoringRef.ContainsKey('default') | Should -BeFalse

            $authoringWith = if ($file -eq 'pr-check.yml') {
                ($workflow.jobs.initialize.steps | Where-Object id -eq 'initialize').with
            }
            else {
                $workflow.jobs.initialize.with
            }
            $authoringWith.authoringSource | Should -BeExactly ('$' + '{{ inputs.authoringSource || ''gallery'' }}')
            $authoringWith.authoringRef | Should -BeExactly ('$' + '{{ inputs.authoringRef || ' + "''" + ' }}')

            $toolsRefs += @(
                [regex]::Matches($content, '(?m)^\s*uses:\s*Azure/azure-verified-modules-tools/[^\s@]+@([^\s#]+)') |
                    ForEach-Object { $_.Groups[1].Value }
            )
        }
        $toolsRefs | Should -HaveCount 4
        @($toolsRefs | Select-Object -Unique) | Should -HaveCount 1
    }

    It 'prevents automatic uses-only changes from diverging from tools-ref inputs' {
        $configuration = ConvertFrom-Yaml -Yaml (
            Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'dependabot.yml') -Raw
        )
        $updates = @($configuration.updates | Where-Object { $_.'package-ecosystem' -eq 'github-actions' -and $_.directory -eq '/' })
        $updates.Count | Should -Be 1
        $ignored = @($updates[0].ignore.'dependency-name')
        $ignored | Should -Contain 'Azure/azure-verified-modules-tools'
        $ignored | Should -Contain 'Azure/azure-verified-modules-tools/*'
        @($ignored | Where-Object { 'actions/checkout' -clike $_ }).Count | Should -Be 0
        @($ignored | Where-Object { 'azure/login' -clike $_ }).Count | Should -Be 0
    }
}

Describe 'Shared Bicep workflow entry points' {
    It 'enables main pushes and manual releases without experimental workflow names' {
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $release = Get-Content -LiteralPath (Join-Path $workflowRoot 'release.yml') -Raw | ConvertFrom-Yaml
        $prCheck = Get-Content -LiteralPath (Join-Path $workflowRoot 'pr-check.yml') -Raw | ConvertFrom-Yaml

        $release.on.push.branches | Should -Be @('main')
        $release.on.push.ContainsKey('paths') | Should -BeFalse
        $release.on.ContainsKey('workflow_dispatch') | Should -BeTrue
        $release.name | Should -BeExactly '.Module - Release'
        $release.jobs.release.name | Should -BeExactly '${{ matrix.modulePath }}'
        $prCheck.name | Should -BeExactly '.Module - PR Check'
        $release.jobs.initialize.needs | Should -BeExactly 'changes'
        $release.jobs.initialize.if | Should -BeExactly "needs.changes.outputs.hasModules == 'true'"
        $checkout = $release.jobs.changes.steps | Where-Object name -eq 'Check out repository'
        $checkout.if | Should -BeExactly "github.event_name == 'push'"
        $checkout.with.'fetch-depth' | Should -Be 0
        $checkout.with.'sparse-checkout' | Should -BeExactly '/.github/workflows/release.yml'
        $checkout.with.'sparse-checkout-cone-mode' | Should -BeFalse
        $checkout.with.'persist-credentials' | Should -BeFalse
        $prCheckout = $prCheck.jobs.initialize.steps | Where-Object name -eq 'Check out repository for change detection'
        $prChanges = $prCheck.jobs.initialize.steps | Where-Object id -eq 'changes'
        $prepare = $prCheck.jobs.initialize.steps | Where-Object id -eq 'initialize'
        $prChanges.if | Should -BeExactly $prCheckout.if
        ($prChanges.if -replace '\s+', ' ').Trim() | Should -BeExactly (
            "github.event_name == 'pull_request' && github.repository == 'Azure/bicep-registry-modules' && " +
            "(github.event.action != 'labeled' || github.event.label.name == 'PR: Run E2E Tests')"
        )
        $prCheckout.with.'fetch-depth' | Should -Be 0
        $prCheckout.with.'sparse-checkout' | Should -BeExactly '/.github/workflows/pr-check.yml'
        $prCheckout.with.'sparse-checkout-cone-mode' | Should -BeFalse
        $prCheckout.with.'persist-credentials' | Should -BeFalse
        $prepare.if | Should -BeExactly "steps.changes.outputs.hasModules != 'false'"
    }

    It 'forwards optional manual target and base SHAs while leaving push ranges automatic' {
        $release = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'release.yml') -Raw |
            ConvertFrom-Yaml

        foreach ($inputName in @('targetCommit', 'baseCommit')) {
            $release.on.workflow_dispatch.inputs[$inputName].type | Should -BeExactly 'string'
            $release.on.workflow_dispatch.inputs[$inputName].required | Should -BeFalse
            $release.on.workflow_dispatch.inputs[$inputName].ContainsKey('default') | Should -BeFalse
            $release.jobs.initialize.with[$inputName] | Should -BeExactly ('$' + "{{ inputs.$inputName || '' }}")
        }
    }

    It 'exposes the selected release plan in per-module jobs' {
        $release = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'release.yml') -Raw |
            ConvertFrom-Yaml
        $selector = $release.jobs.initialize
        $publisher = $release.jobs.release

        $selector.uses | Should -Match '^Azure/azure-verified-modules-tools/\.github/workflows/bicep-release\.yml@'
        $selector.with.initializeOnly | Should -BeTrue
        $publisher.uses | Should -Match '^Azure/azure-verified-modules-tools/\.github/workflows/bicep-module-runtime-release\.yml@'
        $publisher.needs | Should -BeExactly 'initialize'
        $publisher.if | Should -BeExactly "needs.initialize.outputs.hasModules == 'true'"
        $publisher.permissions.contents | Should -BeExactly 'write'
        $publisher.strategy.'fail-fast' | Should -BeFalse
        $publisher.strategy.matrix | Should -BeExactly '${{ fromJSON(needs.initialize.outputs.moduleMatrix) }}'
        foreach ($name in @('modulePath', 'plannedTags', 'releaseTagLabel')) {
            $publisher.with[$name] | Should -BeExactly ('$' + "{{ matrix.$name }}")
        }
        foreach ($name in @('targetCommit', 'baseCommit', 'authoringArtifact')) {
            $publisher.with[$name] | Should -BeExactly ('$' + "{{ needs.initialize.outputs.$name }}")
        }
        $publisher.with.pendingRelease | Should -BeTrue
        $publisher.with.requireChangelog | Should -BeTrue
    }

    It 'grants the initialize-only reusable workflow the nested release job permissions' {
        $release = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'release.yml') -Raw |
            ConvertFrom-Yaml
        $selector = $release.jobs.initialize

        $selector.uses | Should -Match '^Azure/azure-verified-modules-tools/\.github/workflows/bicep-release\.yml@'
        $selector.with.initializeOnly | Should -BeTrue
        @($selector.permissions.Keys) | Should -Be @('contents')
        $selector.permissions.contents | Should -BeExactly 'write'
    }
}

Describe 'Workflow module change detection' {
    BeforeAll {
        $workflow = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'release.yml') -Raw |
            ConvertFrom-Yaml
        $script:run = [scriptblock]::Create(($workflow.jobs.changes.steps | Where-Object id -eq 'changes').run)
        $prWorkflow = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml') -Raw |
            ConvertFrom-Yaml
        $script:prRun = [scriptblock]::Create(($prWorkflow.jobs.initialize.steps | Where-Object id -eq 'changes').run)
        $script:oldEnvironment = @{
            EVENT_NAME = $env:EVENT_NAME
            BASE_COMMIT = $env:BASE_COMMIT
            TARGET_COMMIT = $env:TARGET_COMMIT
            HEAD_COMMIT = $env:HEAD_COMMIT
            GITHUB_OUTPUT = $env:GITHUB_OUTPUT
        }
        $script:repository = Join-Path $TestDrive 'release-change-detection'
        New-Item -ItemType Directory -Path $script:repository | Out-Null
        Push-Location $script:repository
        try {
            git init --quiet --template= .
            git config user.name 'AVM test'
            git config user.email 'avm-test@example.invalid'
            Set-Content -LiteralPath 'README.md' -Value 'base'
            git add --all
            git commit --quiet -m 'base'
            $script:base = (git rev-parse HEAD).Trim()
            Set-Content -LiteralPath 'README.md' -Value 'non-module change'
            New-Item -ItemType Directory -Path 'docs' | Out-Null
            for ($i = 0; $i -lt 301; $i++) {
                Set-Content -LiteralPath "docs\file-$i.txt" -Value 'non-module change'
            }
            git add --all
            git commit --quiet -m 'non-module change'
            $script:nonModule = (git rev-parse HEAD).Trim()
            New-Item -ItemType Directory -Path 'avm' | Out-Null
            Set-Content -LiteralPath 'avm\module.txt' -Value 'module change'
            git add --all
            git commit --quiet -m 'module change'
            $script:module = (git rev-parse HEAD).Trim()
            git rm --quiet 'avm/module.txt'
            git commit --quiet -m 'module deletion'
            $script:deletion = (git rev-parse HEAD).Trim()
            $nonModuleTree = (git rev-parse "$($script:nonModule)^{tree}").Trim()
            $moduleTree = (git rev-parse "$($script:module)^{tree}").Trim()
            $deletionTree = (git rev-parse "$($script:deletion)^{tree}").Trim()
            $script:nonModuleMerge = (git commit-tree $nonModuleTree -p $script:base -p $script:nonModule -m 'non-module merge').Trim()
            $script:moduleMerge = (git commit-tree $moduleTree -p $script:base -p $script:module -m 'module merge').Trim()
            $script:deletionMerge = (git commit-tree $deletionTree -p $script:module -p $script:deletion -m 'module deletion merge').Trim()
            git sparse-checkout init --no-cone
            git sparse-checkout set --no-cone /README.md
            $LASTEXITCODE | Should -Be 0
        }
        finally {
            Pop-Location
        }
    }

    BeforeEach {
        $env:EVENT_NAME = 'push'
        $env:BASE_COMMIT = $script:base
        $env:TARGET_COMMIT = $script:nonModule
        $env:GITHUB_OUTPUT = Join-Path $TestDrive 'release-change-output.txt'
        Set-Content -LiteralPath $env:GITHUB_OUTPUT -Value ''
        Push-Location $script:repository
    }

    AfterEach {
        Pop-Location
    }

    AfterAll {
        foreach ($name in $script:oldEnvironment.Keys) {
            [Environment]::SetEnvironmentVariable($name, $script:oldEnvironment[$name], 'Process')
        }
    }

    It 'skips module initialization for a non-module push' {
        & $script:run
        (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim() | Should -BeExactly 'hasModules=false'
    }

    It 'detects module changes across a multi-commit push with over 300 files' {
        $env:TARGET_COMMIT = $script:module
        & $script:run
        (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim() | Should -BeExactly 'hasModules=true'
    }

    It 'detects a module deletion' {
        $env:BASE_COMMIT = $script:module
        $env:TARGET_COMMIT = $script:deletion
        & $script:run
        (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim() | Should -BeExactly 'hasModules=true'
    }

    It 'allows a manual release without inspecting the push range' {
        $env:EVENT_NAME = 'workflow_dispatch'
        $env:BASE_COMMIT = ''
        $env:TARGET_COMMIT = ''
        & $script:run
        (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim() | Should -BeExactly 'hasModules=true'
    }

    It 'fails rather than skipping a push with an invalid comparison' {
        $env:BASE_COMMIT = $script:deletion
        { & $script:run } | Should -Throw '*available ancestor*'
    }

    It 'skips module checks for a pull request without module changes' {
        $env:TARGET_COMMIT = $script:nonModuleMerge
        $env:HEAD_COMMIT = $script:nonModule
        & $script:prRun
        (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim() | Should -BeExactly 'hasModules=false'
    }

    It 'detects pull request module changes after more than 300 other files' {
        $env:TARGET_COMMIT = $script:moduleMerge
        $env:HEAD_COMMIT = $script:module
        & $script:prRun
        (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim() | Should -BeExactly 'hasModules=true'
    }

    It 'detects a pull request module deletion' {
        $env:TARGET_COMMIT = $script:deletionMerge
        $env:HEAD_COMMIT = $script:deletion
        & $script:prRun
        (Get-Content -LiteralPath $env:GITHUB_OUTPUT -Raw).Trim() | Should -BeExactly 'hasModules=true'
    }

    It 'fails rather than skipping a pull request with a mismatched head' {
        $env:TARGET_COMMIT = $script:moduleMerge
        $env:HEAD_COMMIT = $script:nonModule
        { & $script:prRun } | Should -Throw '*does not match the pull request head*'
    }
}

Describe 'Registry-owned child module publishing approvals' {
    It 'does not introduce a root child module publishing approval file' {
        $configurationPath = Join-Path $RepoRootPath '.avm' 'child-module-publish-allowed-list.json'

        Test-Path -LiteralPath $configurationPath | Should -BeFalse
    }

    It 'preserves the existing <surface> unchanged from main' -ForEach @(
        @{ surface = 'approval list'; path = 'utilities/pipelines/staticValidation/compliance/helper/child-module-publish-allowed-list.json' }
    ) {
        $baseline = '2544042ac741cd306d669c320b8650ce71fc7755'
        $expectedBlob = git -C $RepoRootPath rev-parse "${baseline}:$path"
        $LASTEXITCODE | Should -Be 0

        (git -C $RepoRootPath hash-object "--path=$path" -- (Join-Path $RepoRootPath $path)) |
            Should -BeExactly $expectedBlob
        $LASTEXITCODE | Should -Be 0
    }
}

Describe 'Module workflow entrypoints' {
    It 'keeps dedicated workflows only for reserved modules' {
        $reserved = (Get-Content -LiteralPath (Join-Path $RepoRootPath '.reserved-test-subscriptions.json') -Raw |
                ConvertFrom-Json -AsHashtable).Keys | ForEach-Object { "$($_.Replace('/', '.')).yml" }
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $entrypoints = @(Get-ChildItem -LiteralPath $workflowRoot -File |
                Where-Object { $_.Name -match '^avm\.(res|ptn|utl)\..+\.yml$' } |
                ForEach-Object Name)

        @($entrypoints | Sort-Object) | Should -Be @($reserved | Sort-Object)
        @(Get-ChildItem -LiteralPath $workflowRoot -File -Filter 'avm.template.module*.yml') | Should -BeNullOrEmpty
        foreach ($file in $entrypoints) {
            $workflow = Get-Content -LiteralPath (Join-Path $workflowRoot $file) -Raw | ConvertFrom-Yaml
            $workflow.jobs.'call-workflow-passing-data'.uses | Should -Be './.github/workflows/avm.template.hci.module.yml'
        }
    }
}

Describe 'Canonical Bicep documentation template checkout' {
    It 'preserves the selected template raw bytes with Git autocrlf enabled' {
        $configuration = Get-Content -LiteralPath (Join-Path $RepoRootPath 'bicepconfig.json') -Raw |
            ConvertFrom-Json -AsHashtable
        $relativePath = $configuration.documentation.template.file
        $templatePath = Join-Path $RepoRootPath $relativePath
        $expectedHash = (Get-FileHash -LiteralPath $templatePath -Algorithm SHA256).Hash
        [IO.File]::ReadAllBytes($templatePath) | Should -Not -Contain ([byte] 13)

        $fixture = Join-Path $TestDrive 'template-checkout'
        $emptyAttributes = Join-Path $TestDrive 'empty-attributes'
        $null = New-Item -ItemType Directory -Path $fixture
        $null = New-Item -ItemType File -Path $emptyAttributes
        $selectedPath = Join-Path $fixture $relativePath
        $null = New-Item -ItemType Directory -Path (Split-Path $selectedPath -Parent) -Force
        Copy-Item -LiteralPath $templatePath -Destination $selectedPath
        Copy-Item -LiteralPath (Join-Path $RepoRootPath '.gitattributes') -Destination (Join-Path $fixture '.gitattributes')

        git init --quiet --template= -- $fixture
        $LASTEXITCODE | Should -Be 0
        $gitOptions = @(
            '-C', $fixture,
            '-c', 'core.autocrlf=true',
            '-c', 'core.safecrlf=false',
            '-c', "core.attributesFile=$emptyAttributes"
        )
        git @gitOptions add -- .gitattributes $relativePath
        $LASTEXITCODE | Should -Be 0
        Remove-Item -LiteralPath $selectedPath
        git @gitOptions checkout-index --force -- $relativePath
        $LASTEXITCODE | Should -Be 0

        (Get-FileHash -LiteralPath $selectedPath -Algorithm SHA256).Hash | Should -BeExactly $expectedHash
        [IO.File]::ReadAllBytes($selectedPath) | Should -Not -Contain ([byte] 13)
    }
}
