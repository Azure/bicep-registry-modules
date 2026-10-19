BeforeAll {
    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..')).Path
    $compliancePath = Join-Path $repoRoot 'utilities' 'pipelines' 'staticValidation' 'compliance' 'module.tests.ps1'
    $ast = [Management.Automation.Language.Parser]::ParseFile($compliancePath, [ref] $null, [ref] $null)
    $rule = @($ast.FindAll({
                param ($node)
                $node -is [Management.Automation.Language.CommandAst] -and
                $node.GetCommandName() -ceq 'It' -and
                $node.CommandElements[1].Value -like '*Resource Modules must not skip*'
            }, $true))
    if ($rule.Count -ne 1) { throw 'Could not identify the actual required-case compliance assertion.' }
    $body = @($rule[0].CommandElements | Where-Object { $_ -is [Management.Automation.Language.ScriptBlockExpressionAst] })
    if ($body.Count -ne 1) { throw 'Required-case compliance assertion body is ambiguous.' }
    $requiredCaseRule = $body[0].ScriptBlock.GetScriptBlock()

    function New-RequiredCaseFixture {
        param ([string] $Case)
        $root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $directory = Join-Path $root 'tests' 'e2e' $Case
        $null = New-Item -ItemType Directory -Path $directory -Force
        Set-Content -LiteralPath (Join-Path $directory '.e2eignore') -Value 'Synthetic compliance fixture; no deployment is executed.'
        $root
    }
}

Describe 'Actual required E2E case compliance' {
    It 'Recognizes only the approved existing WAF exception for <Module>' -TestCases @(
        @{ Module = 'res/dev-center/devcenter' }
        @{ Module = 'res/dev-center/project' }
    ) {
        param ($Module)
        $actualModule = Join-Path $repoRoot 'avm' $Module
        Test-Path -LiteralPath (Join-Path $actualModule 'tests' 'e2e' 'defaults' '.e2eignore') | Should -BeFalse
        {
            & $requiredCaseRule -moduleFolderName $Module -moduleFolderPath $actualModule
        } | Should -Not -Throw
    }

    It 'Still forbids ignoring mandatory defaults for <Module>' -TestCases @(
        @{ Module = 'res/dev-center/devcenter' }
        @{ Module = 'res/dev-center/project' }
    ) {
        param ($Module)
        $fixture = New-RequiredCaseFixture -Case 'defaults'
        {
            & $requiredCaseRule -moduleFolderName $Module -moduleFolderPath $fixture
        } | Should -Throw '*skipping this test is not allowed*'
    }

    It 'Still rejects unrelated or lookalike WAF exceptions for <Module>/<Case>' -TestCases @(
        @{ Module = 'res/service-bus/namespace'; Case = 'waf-aligned' }
        @{ Module = 'res/dev-center/project-copy'; Case = 'waf-aligned' }
        @{ Module = 'res/dev-center/devcenter'; Case = 'custom-waf-aligned' }
        @{ Module = 'res/dev-center/project'; Case = 'custom-waf-aligned' }
    ) {
        param ($Module, $Case)
        $fixture = New-RequiredCaseFixture -Case $Case
        {
            & $requiredCaseRule -moduleFolderName $Module -moduleFolderPath $fixture
        } | Should -Throw '*skipping this test is not allowed*'
    }

    It 'Preserves the existing retirement exception behavior for Redis/<Case>' -TestCases @(
        @{ Case = 'defaults' }
        @{ Case = 'waf-aligned' }
    ) {
        param ($Case)
        $fixture = New-RequiredCaseFixture -Case $Case
        {
            & $requiredCaseRule -moduleFolderName 'res/cache/redis' -moduleFolderPath $fixture
        } | Should -Not -Throw
    }
}
