param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Coordinated tools dependency updates' {
    It 'keeps each caller tools reference aligned without pinning Avm.Authoring' {
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
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

            $toolsRefs = @(
                [regex]::Matches($content, '(?m)^\s*uses:\s*Azure/azure-verified-modules-tools/[^\s@]+@([^\s#]+)') |
                    ForEach-Object { $_.Groups[1].Value }
            )
            $expectedCount = if ($file -eq 'pr-check.yml') { 4 } else { 2 }
            $toolsRefs | Should -HaveCount $expectedCount
            @($toolsRefs | Select-Object -Unique) | Should -HaveCount 1
        }
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
        $release.on.push.paths | Should -Be @('avm/**')
        $release.on.ContainsKey('workflow_dispatch') | Should -BeTrue
        $prCheck.on.pull_request.ContainsKey('paths') | Should -BeFalse
        $prCheck.on.pull_request.types | Should -Be @('opened', 'reopened', 'synchronize')
        $prCheck.on.ContainsKey('workflow_dispatch') | Should -BeTrue
        $release.name | Should -BeExactly '.Module - Release'
        $release.jobs.release.name | Should -BeExactly '${{ matrix.modulePath }}'
        $prCheck.name | Should -BeExactly '.Module - PR Check'
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

    It 'evaluates mutually exclusive module check routes in one gate' {
        $prCheck = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'pr-check.yml') -Raw |
            ConvertFrom-Yaml

        $prCheck.jobs.check.name | Should -BeExactly 'Module checks: ${{ matrix.modulePath }}'
        $prCheck.jobs.check.strategy.matrix | Should -BeExactly '${{ fromJSON(needs.initialize.outputs.moduleMatrix) }}'
        $prCheck.jobs.check.with.e2eRoute | Should -BeExactly '${{ matrix.e2eRoute }}'
        $prCheck.jobs.check.with.moduleTestFilePaths | Should -BeExactly '${{ matrix.moduleTestFilePaths }}'
        $prCheck.jobs.'check-fork'.strategy.matrix | Should -BeExactly $prCheck.jobs.check.strategy.matrix
        $prCheck.jobs.ContainsKey('required-e2e') | Should -BeFalse
        $prCheck.jobs.ContainsKey('optional-e2e') | Should -BeFalse
        $prCheck.jobs.ContainsKey('static-gate') | Should -BeFalse
        $prCheck.jobs.ContainsKey('required-e2e-gate') | Should -BeFalse
        $prCheck.jobs.'module-gate'.name | Should -BeExactly 'Report check status'
        $prCheck.jobs.'module-gate'.if | Should -BeExactly 'always()'
        $prCheck.jobs.'module-gate'.needs | Should -Be @('initialize', 'check', 'check-fork')
    }

    It 'exposes the selected release plan in per-module jobs' {
        $release = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'release.yml') -Raw |
            ConvertFrom-Yaml
        $selector = $release.jobs.initialize
        $publisher = $release.jobs.release

        $selector.name | Should -BeExactly 'Select pending module releases'
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
