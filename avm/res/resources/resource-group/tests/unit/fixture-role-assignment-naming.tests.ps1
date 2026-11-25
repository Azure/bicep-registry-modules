Describe 'Resource group fixture role assignment names' {
    BeforeAll {
        $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $pattern = '(?ms)^\s+name:\s*(?<name>guid\([^)]*\))\s+roleDefinitionIdOrName:\s*(?<role>[^\r\n]+)\s+principalId:\s*(?<principal>[^\r\n]+)'
        $assignments = @([regex]::Matches($source, $pattern))
        if ($assignments.Count -ne 2) { throw 'Expected two explicitly named role assignments.' }
    }

    It 'Derives each name from its assigned principal and stable fixture scope' {
        foreach ($assignment in $assignments) {
            $assignment.Groups['principal'].Value.Trim() | Should -Be 'nestedDependencies.outputs.managedIdentityPrincipalId'
            $name = $assignment.Groups['name'].Value
            $name | Should -Match 'nestedDependencies\.outputs\.managedIdentityPrincipalId'
            $name | Should -Match 'namePrefix'
            $name | Should -Match 'serviceShort'
            $name | Should -Not -Match 'deployment\(\)|newGuid\(|utcNow\('
        }
    }

    It 'Uses different seeds for the Owner and Contributor assignments' {
        $assignments[0].Groups['role'].Value.Trim() | Should -Be "'Owner'"
        $assignments[1].Groups['role'].Value.Trim() | Should -Be "'b24988ac-6180-42a0-ab88-20f7382dd24c'"
        $assignments[0].Groups['name'].Value | Should -Not -Be $assignments[1].Groups['name'].Value
    }
}
