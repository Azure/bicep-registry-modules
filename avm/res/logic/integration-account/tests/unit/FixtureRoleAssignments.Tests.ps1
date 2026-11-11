Describe 'Integration Account max fixture role-assignment names' {
    BeforeAll {
        $moduleRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        $source = Get-Content -LiteralPath (Join-Path $moduleRoot 'tests/e2e/max/dependencies.bicep') -Raw
        $scenarios = @(
            @{ Subscription = 'sub-a'; Group = 'group-a'; Vault = 'vault-a'; Principal = 'principal-a' }
            @{ Subscription = 'sub-a'; Group = 'group-a'; Vault = 'vault-b'; Principal = 'principal-a' }
            @{ Subscription = 'sub-a'; Group = 'group-b'; Vault = 'vault-a'; Principal = 'principal-a' }
            @{ Subscription = 'sub-b'; Group = 'group-a'; Vault = 'vault-a'; Principal = 'principal-a' }
            @{ Subscription = 'sub-a'; Group = 'group-a'; Vault = 'vault-a'; Principal = 'principal-b' }
        )
        $names = @{}
        foreach ($symbol in @('keyPermissions', 'keyPermissions2')) {
            $match = [regex]::Match($source, "(?s)resource $symbol '[^']+' = \{\s*name:\s*(?<expression>[^\r\n]+)")
            if (-not $match.Success) { throw "Missing role-assignment name expression for $symbol." }
            foreach ($index in 0..($scenarios.Count - 1)) {
                $scenario = $scenarios[$index]
                $vaultId = "/subscriptions/$($scenario.Subscription)/resourceGroups/$($scenario.Group)/providers/Microsoft.KeyVault/vaults/$($scenario.Vault)"
                $rolePrefix = "/subscriptions/$($scenario.Subscription)/providers/Microsoft.Authorization/roleDefinitions"
                $expression = $match.Groups['expression'].Value.Trim().
                    Replace('keyVault.id', "'$vaultId'").
                    Replace('logicAppsServiceEnterpriseApplicationObjectId', "'$($scenario.Principal)'").
                    Replace('certificateOfficerRoleDefinitionId', "'$rolePrefix/a4417e6f-fecd-4de8-b567-7b0420556985'").
                    Replace('administratorRoleDefinitionId', "'$rolePrefix/00482a5a-887f-4fb3-b363-3b7fe8e74483'")
                $parameterPath = Join-Path $TestDrive "$symbol-$index.bicepparam"
                $parameterOutput = Join-Path $TestDrive "$symbol-$index.json"
                @(
                    'using none'
                    "param initial = $expression"
                    "param repeated = $expression"
                ) -join "`n" | Set-Content -LiteralPath $parameterPath
                $diagnostics = & bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
                if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
                $names["$symbol-$index"] = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
            }
        }
    }

    It '<Symbol> distinguishes vaults, resource groups, subscriptions and principals' -ForEach @(
        @{ Symbol = 'keyPermissions' }
        @{ Symbol = 'keyPermissions2' }
    ) {
        $values = @(0..4 | ForEach-Object { $names["$Symbol-$_"].initial.value })
        @($values | Select-Object -Unique).Count | Should -Be 5 -Because "different scopes and principals must not reuse $($values -join ', ')"
    }

    It 'keeps identical inputs stable across repeated deployments and separates the two roles' {
        foreach ($index in 0..4) {
            foreach ($symbol in @('keyPermissions', 'keyPermissions2')) {
                $values = $names["$symbol-$index"]
                $values.initial.value | Should -BeExactly $values.repeated.value
            }
            $names["keyPermissions-$index"].initial.value | Should -Not -Be $names["keyPermissions2-$index"].initial.value
        }
    }
}
