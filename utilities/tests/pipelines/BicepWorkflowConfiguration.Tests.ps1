param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Coordinated tools dependency updates' {
    It 'keeps every tools workflow, action and support ref on one immutable commit without a package fallback' {
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $reference = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.res.network.route-table.yml') -Raw | ConvertFrom-Yaml
        $toolsRef = $reference.jobs.'call-workflow-passing-data'.with.'tools-ref'
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
    It 'keeps packaged and legacy publishing approvals identical during the transition' {
        $configurationPath = Join-Path $RepoRootPath '.avm' 'child-module-publish-allowed-list.json'
        $legacyPath = Join-Path $RepoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'helper' 'child-module-publish-allowed-list.json'
        $configuration = Get-Content -LiteralPath $configurationPath -Raw | ConvertFrom-Json -AsHashtable
        $legacy = Get-Content -LiteralPath $legacyPath -Raw | ConvertFrom-Json -AsHashtable

        ($configuration | ConvertTo-Json -Depth 5 -Compress) |
            Should -BeExactly ($legacy | ConvertTo-Json -Depth 5 -Compress)
    }
}
