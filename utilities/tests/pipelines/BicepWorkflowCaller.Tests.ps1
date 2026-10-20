param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Experimental shared workflow isolation' {
    BeforeAll {
        $baseline = '83845801bb29ea7c3a12b48d647bb5a0f1804e8e'
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
        $workflow = Get-Content -LiteralPath (Join-Path $workflowRoot 'avm.module.yml') -Raw | ConvertFrom-Yaml
        $toolsRef = 'ba9af85f4f1c164839f43080ac152cb372f9db0a'
    }

    It 'keeps every nonexperimental workflow byte-identical to the pre-adoption main baseline' {
        $entries = @(git -C $RepoRootPath ls-tree -r $baseline -- .github/workflows)
        $LASTEXITCODE | Should -Be 0
        foreach ($entry in $entries) {
            $match = [regex]::Match($entry, '^100644 blob ([0-9a-f]{40})\t(.+)$')
            $match.Success | Should -BeTrue
            $blob, $path = $match.Groups[1].Value, $match.Groups[2].Value
            if ($path -eq '.github/workflows/avm.module.yml') { continue }
            (git -C $RepoRootPath hash-object "--path=$path" -- $path) | Should -BeExactly $blob -Because $path
            $LASTEXITCODE | Should -Be 0
        }
        $current = @(Get-ChildItem -LiteralPath $workflowRoot -File | ForEach-Object { ".github/workflows/$($_.Name)" })
        @($current | Sort-Object) | Should -Be @($entries | ForEach-Object { ($_ -split "`t", 2)[1] } | Sort-Object)
    }

    It 'keeps all legacy production helpers and local actions unchanged' {
        $changes = @(git -C $RepoRootPath diff --name-only $baseline -- utilities/pipelines .github/actions)
        $LASTEXITCODE | Should -Be 0
        $changes | Should -BeNullOrEmpty
    }

    It 'uses the merged immutable tools revision only in the experimental workflow' {
        $remoteUses = 0
        foreach ($file in Get-ChildItem -LiteralPath $workflowRoot -File -Filter '*.yml') {
            $document = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Yaml
            foreach ($job in $document.jobs.Values) {
                foreach ($node in @($job) + @($job.steps | Where-Object { $null -ne $_ })) {
                    if ($node.uses -like 'Azure/azure-verified-modules-tools/*') {
                        $file.Name | Should -BeExactly 'avm.module.yml'
                        ($node.uses -split '@')[-1] | Should -BeExactly $toolsRef
                        $node.with.'avm-authoring-version' | Should -Be '${{ vars.AVM_AUTHORING_VERSION }}'
                        if ($node.uses -like '*/workflows/*') { $node.with.'tools-ref' | Should -BeExactly $toolsRef }
                        $remoteUses++
                    }
                }
            }
        }
        $remoteUses | Should -Be 5
    }

    It 'binds discovery to the tested checkout and preserves all original outputs' {
        $steps = $workflow.jobs.job_initialize_pipeline.steps
        $steps[0].with.ref | Should -Be '${{ github.sha }}'
        $matrix = $steps | Where-Object id -EQ 'get-module-matrix'
        $matrix.with.targetCommit | Should -Be $steps[0].with.ref
        $matrix.with.baseCommit | Should -Be '${{ github.event.before }}'
        $matrix.with.pullRequestHeadCommit | Should -Be '${{ github.event.pull_request.head.sha }}'
        $matrix.ContainsKey('run') | Should -BeFalse
        foreach ($name in @('baseCommit', 'targetCommit', 'hasModules', 'includeAllVersionedModules', 'moduleMatrix', 'workflowInput')) {
            $workflow.jobs.job_initialize_pipeline.outputs[$name] |
                Should -Be ('${{ steps.get-module-matrix.outputs.' + $name + ' }}')
        }
        @($workflow.on.Keys | Sort-Object) | Should -Be @('pull_request', 'workflow_dispatch')
    }

    It 'keeps reserved preview and publication on unchanged legacy local workflows' {
        foreach ($route in @('preview', 'publish', 'publish_only')) {
            $file = @{ preview = 'preview'; publish = 'publish'; publish_only = 'publish-only' }[$route]
            $job = $workflow.jobs["call_module_${route}_local"]
            $job.uses | Should -Be "./.github/workflows/avm.template.module.$file.yml"
            $job.with.ContainsKey('tools-ref') | Should -BeFalse
            $job.with.ContainsKey('avm-authoring-version') | Should -BeFalse
            $job.strategy.matrix | Should -Match 'localModuleMatrix'
        }
    }
}
