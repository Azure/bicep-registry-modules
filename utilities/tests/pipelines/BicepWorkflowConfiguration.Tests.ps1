param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Coordinated tools dependency updates' {
    It 'keeps every caller tools reference on the v0.40.0 merged commit without pinning Avm.Authoring' {
        $expectedToolsSha = '8bca18987ce8853e844f4e95f8cc309162ee7b40'
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $expectedReferences = @{
            'pr-check.yml' = @(
                "Azure/azure-verified-modules-tools/.github/actions/bicep-pr-check-initializer@$expectedToolsSha"
                "Azure/azure-verified-modules-tools/.github/workflows/bicep-module-runtime.yml@$expectedToolsSha"
            )
            'release.yml' = @(
                "Azure/azure-verified-modules-tools/.github/workflows/bicep-release.yml@$expectedToolsSha"
            )
        }
        foreach ($file in $expectedReferences.Keys) {
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
                $workflow.jobs.release.with
            }
            $authoringWith.authoringSource | Should -BeExactly ('$' + '{{ inputs.authoringSource || ''gallery'' }}')
            $authoringWith.authoringRef | Should -BeExactly ('$' + '{{ inputs.authoringRef || ' + "''" + ' }}')

            $references = @(
                [regex]::Matches($content, '(?m)^\s*uses:\s*(Azure/azure-verified-modules-tools/[^\s]+)') |
                    ForEach-Object { $_.Groups[1].Value }
            )
            @($references | Sort-Object) | Should -Be @($expectedReferences[$file] | Sort-Object)
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

Describe 'Registry-owned child module publishing approvals' {
    It 'does not introduce a root child module publishing approval file' {
        $configurationPath = Join-Path $RepoRootPath '.avm' 'child-module-publish-allowed-list.json'

        Test-Path -LiteralPath $configurationPath | Should -BeFalse
    }

    It 'preserves the existing <surface> unchanged from main' -ForEach @(
        @{ surface = 'approval list'; path = 'utilities/pipelines/staticValidation/compliance/helper/child-module-publish-allowed-list.json' }
        @{ surface = 'approval validator'; path = 'utilities/pipelines/staticValidation/compliance/module.tests.ps1' }
    ) {
        $baseline = '062537582b9392a0dec3388ff8b36bb141a06659'
        $expectedBlob = git -C $RepoRootPath rev-parse "${baseline}:$path"
        $LASTEXITCODE | Should -Be 0

        (git -C $RepoRootPath hash-object "--path=$path" -- (Join-Path $RepoRootPath $path)) |
            Should -BeExactly $expectedBlob
        $LASTEXITCODE | Should -Be 0
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
