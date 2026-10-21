param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Coordinated tools dependency updates' {
    It 'keeps every tools workflow, action and support ref on one immutable commit without a package fallback' {
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $reference = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.module.yml') -Raw | ConvertFrom-Yaml
        $toolsRef = $reference.jobs.call_module_preview.with.'tools-ref'
        $toolsRef | Should -MatchExactly '^[0-9a-f]{40}$'
        $remoteCount = 0
        foreach ($file in Get-ChildItem -LiteralPath $workflowRoot -File -Filter '*.yml') {
            $workflow = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Yaml
            foreach ($job in $workflow.jobs.Values) {
                foreach ($node in @($job) + @($job.steps | Where-Object { $null -ne $_ })) {
                    if ($node.uses -like 'Azure/azure-verified-modules-tools/*') {
                        $node.uses | Should -MatchExactly '^Azure/azure-verified-modules-tools/[^@]+@[0-9a-f]{40}$'
                        ($node.uses -split '@')[-1] | Should -BeExactly $toolsRef
                        $remoteCount++
                    }
                    if ($node.with -and $node.with.ContainsKey('tools-ref')) {
                        $node.with.'tools-ref' | Should -BeExactly $toolsRef
                    }
                    if ($node.with -and $node.with.ContainsKey('avm-authoring-version')) {
                        $node.with.'avm-authoring-version' | Should -Be '${{ vars.AVM_AUTHORING_VERSION }}'
                    }
                }
            }
        }
        $remoteCount | Should -BeGreaterThan 0
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
        $baseline = '08dab5ba19b6f9b87514954e386226809564445b'
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
