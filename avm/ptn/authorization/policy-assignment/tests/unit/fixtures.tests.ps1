BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' '..'
    $fixturePath = Join-Path $modulePath 'tests' 'e2e' 'mg.max' 'main.test.bicep'
    $fixture = Get-Content -LiteralPath $fixturePath -Raw
    $nameExpression = [regex]::Match($fixture, '(?s)module testDeployment.*?params:\s*\{\s*name:\s*([^\r\n]+)').Groups[1].Value.Trim()
    $nameExpression | Should -Not -BeNullOrEmpty
    $compiledPath = Join-Path $TestDrive 'fixture.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $compiledPath 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
    $managementGroup = $template.resources | Where-Object type -EQ 'Microsoft.Management/managementGroups'
    $testModule = $template.resources | Where-Object {
        $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('policyDefinitionId')
    }
    $roleSource = Get-Content -LiteralPath (Join-Path $modulePath 'modules' 'management-group-additional-rbac-asi.bicep') -Raw
    $roleExpression = [regex]::Match($roleSource, '(?m)^\s+name:\s*(guid\([^\r\n]+\))').Groups[1].Value.Trim()
    $roleExpression | Should -Not -BeNullOrEmpty
    $cases = @(
        @{ Name = 'first'; Prefix = 'gci'; Short = 'apamgmax'; Deployment = 'run-one' }
        @{ Name = 'repeat'; Prefix = 'gci'; Short = 'apamgmax'; Deployment = 'run-one' }
        @{ Name = 'next'; Prefix = 'gci'; Short = 'apamgmax'; Deployment = 'run-two' }
        @{ Name = 'long'; Prefix = 'long-test-prefix'; Short = 'long-test-service-identifier'; Deployment = 'run-one' }
    )
    $parameterLines = @('using none')
    foreach ($case in $cases) {
        $expression = $nameExpression.Replace('namePrefix', "'$($case.Prefix)'").
            Replace('serviceShort', "'$($case.Short)'").
            Replace('deployment().name', "'$($case.Deployment)'")
        $roleName = $roleExpression.Replace('managementGroup().id', "'/providers/Microsoft.Management/managementGroups/test'").
            Replace('roleDefinitionId', "'/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'").
            Replace('location', "'westeurope'")
        $roleName = [regex]::Replace($roleName, '\bname\b', { $expression })
        $parameterLines += "param $($case.Name)Name = $expression"
        $parameterLines += "param $($case.Name)Role = $roleName"
    }
    $parameterPath = Join-Path $TestDrive 'names.bicepparam'
    $parameterOutput = Join-Path $TestDrive 'names.json'
    $parameterLines -join "`n" | Set-Content -LiteralPath $parameterPath
    $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $names = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
}

Describe 'Management group policy fixture isolation' {
    It 'Creates the additional group beneath the deployment management group' {
        $managementGroup.properties.details.parent.id | Should -Be '[managementGroup().id]'
    }

    It 'Uses different policy names for independent test deployments' {
        $names.firstName.value | Should -Not -Be $names.nextName.value
    }

    It 'Does not reuse a previous test deployment role assignment name' {
        $names.firstRole.value | Should -Not -Be $names.nextRole.value
    }

    It 'Keeps policy and role names stable within the same test deployment' {
        $names.firstName.value | Should -Be $names.repeatName.value
        $names.firstRole.value | Should -Be $names.repeatRole.value
    }

    It 'Keeps policy names within the management group length limit' {
        foreach ($case in $cases) {
            $names["$($case.Name)Name"].value.Length | Should -BeLessOrEqual 24
            $names["$($case.Name)Name"].value | Should -Not -BeNullOrEmpty
        }
    }

    It 'Passes the bounded deployment-specific name to the tested module' {
        $testModule.properties.parameters.name.value |
            Should -Be "[format('{0}{1}', take(format('{0}{1}', parameters('namePrefix'), parameters('serviceShort')), 11), uniqueString(deployment().name))]"
    }
}
