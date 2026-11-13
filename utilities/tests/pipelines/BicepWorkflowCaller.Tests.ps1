param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Experimental Bicep workflow isolation' {
    BeforeAll {
        $baseline = '795bfc3da023e8bd2d0831856ec684ed4352880b'
        $workflowRoot = Join-Path $RepoRootPath '.github' 'workflows'
    }

    It 'keeps every nonexperimental workflow byte-identical to the current main baseline' {
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
        $expected = @(
            $entries |
            ForEach-Object { ($_ -split "`t", 2)[1] } |
            Where-Object { $_ -ne '.github/workflows/avm.module.yml' }
        ) + @(
            '.github/workflows/pr-check.yml'
            '.github/workflows/release.yml'
        )
        $current = @(Get-ChildItem -LiteralPath $workflowRoot -File | ForEach-Object { ".github/workflows/$($_.Name)" })
        @($current | Sort-Object) | Should -Be @($expected | Sort-Object)
    }

    It 'leaves module sources and workflow support unchanged' {
        $changes = @(git -C $RepoRootPath diff --name-only $baseline -- utilities/pipelines .github/actions)
        $LASTEXITCODE | Should -Be 0
        $changes | Should -BeNullOrEmpty
    }
}
