param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1')
    $exceptions = Get-Content (Join-Path $PSScriptRoot 'src/secureParameterForwarding/exceptions.json') -Raw | ConvertFrom-Json -AsHashtable

    function Find-ForwardingException {
        param($Result)
        foreach ($exception in $exceptions) {
            $matchesException = $true
            foreach ($key in @('Module', 'Deployment', 'Target', 'SinkType', 'Source', 'Status', 'ExpressionHash')) {
                if ($exception[$key] -ne $Result.$key) { $matchesException = $false; break }
            }
            if ($matchesException) { return $exception }
        }
    }

    function Assert-ForwardingResults {
        param([object[]] $Results)
        if ($Results.Count -eq 0) { throw 'No secure bindings were analyzed.' }
        $unexpected = @($Results | Where-Object {
                $_.Status -in @('Mismatch', 'Unsupported') -and -not (Find-ForwardingException $_)
            })
        if ($unexpected.Count -gt 0) {
            throw "Unexpected secure forwarding findings: $($unexpected | ConvertTo-Json -Depth 10 -Compress)"
        }
    }

    function New-ForwardingTemplate {
        param(
            [System.Collections.IDictionary] $Schema = @{ type = 'string' },
            $Value = "[parameters('arbitrary')]",
            [System.Collections.IDictionary] $Sink = @{ type = 'secureString' }
        )
        @{
            parameters = @{ arbitrary = $Schema }
            definitions = @{}
            resources = @{
                child = @{
                    type = 'Microsoft.Resources/deployments'
                    properties = @{
                        parameters = @{ destination = @{ value = $Value } }
                        template = @{ parameters = @{ destination = $Sink }; resources = @{} }
                    }
                }
            }
        }
    }

    function Build-ForwardingTemplate {
        param([string] $Path, [string] $Name)
        $compiledPath = Join-Path $TestDrive "$Name.json"
        $diagnostics = bicep build $Path --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    }
}

Describe 'Bounded secure input forwarding analysis' {
    It 'Discovers arbitrary scalar names without a credential-name list' {
        foreach ($name in @('arbitrary', 'freshLeaf', 'unrelatedNewValue', 'Keys', 'Count')) {
            $template = New-ForwardingTemplate
            $template.parameters = @{ $name = @{ type = 'string' } }
            $template.resources.child.properties.parameters.destination.value = "[parameters('$name')]"
            $result = @(Get-SecureParameterForwarding $template 'fixture')
            $result.Count | Should -Be 1
            $result[0].Status | Should -Be 'Mismatch'
            $result[0].Source | Should -Be $name
        }
    }

    It 'Follows escaped local refs, aliases, nullability, and secure ancestors' {
        $template = New-ForwardingTemplate -Schema @{ '$ref' = '#/definitions/alias'; nullable = $true } -Value "[parameters('arbitrary').nested.freshLeaf]"
        $template.definitions = @{
            alias = @{ '$ref' = '#/definitions/private~1value' }
            'private/value' = @{ type = 'secureObject'; properties = @{ nested = @{ type = 'object' } } }
        }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure'
        $template.definitions['private/value'].type = 'object'
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch'
    }

    It 'Checks secure leaves inside whole forwarded objects and arrays, including discriminator variants' {
        $plain = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'string'; nullable = $true } } }
        $secure = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString'; nullable = $true } } }
        $template = New-ForwardingTemplate -Schema @{ type = 'array'; items = $plain } -Sink @{ type = 'array'; items = $secure }
        (Get-SecureParameterForwarding $template 'fixture').Source | Should -Be 'arbitrary.[].freshLeaf'
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch'
        $template.parameters.arbitrary.items = $secure
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure'

        $template = New-ForwardingTemplate -Schema @{
            type = 'object'; discriminator = @{ propertyName = 'kind'; mapping = @{ one = $plain; two = $plain } }
        } -Sink @{
            type = 'object'; discriminator = @{ propertyName = 'kind'; mapping = @{ one = $secure; two = $plain } }
        }
        $result = @(Get-SecureParameterForwarding $template 'fixture')
        $result.Count | Should -Be 1
        $result[0].Source | Should -Be 'arbitrary.@kind=one.freshLeaf'
        $result[0].Status | Should -Be 'Mismatch'
        $template.parameters.arbitrary.discriminator.mapping.one = $secure
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure'
    }

    It 'Does not infer security from only the explicitly declared discriminator properties' {
        $template = New-ForwardingTemplate -Value "[parameters('arbitrary').freshLeaf]" -Schema @{
            type = 'object'
            discriminator = @{
                propertyName = 'kind'
                mapping = @{
                    one = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString' } } }
                    two = @{ type = 'object'; properties = @{} }
                }
            }
        }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch'
        $template.parameters.arbitrary.discriminator.mapping.two.additionalProperties = @{ type = 'string' }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch'
        $template.parameters.arbitrary.discriminator.mapping.two.additionalProperties = $false
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure'
    }

    Context 'Selected production module interfaces' {
        BeforeAll {
            $production = @{}
            $findings = @{}
            foreach ($family in @('api-management/service', 'app/managed-environment', 'sql/server')) {
                $module = "avm/res/$family"
                $production[$module] = Build-ForwardingTemplate (Join-Path $repoRootPath "$module/main.bicep") ($family.Replace('/', '-'))
                $findings[$module] = @(Get-SecureParameterForwarding $production[$module] $module)
            }
        }

        It 'Checks every discovered secure child input below <module>' -TestCases @(
            @{ module = 'avm/res/api-management/service' }
            @{ module = 'avm/res/app/managed-environment' }
            @{ module = 'avm/res/sql/server' }
        ) {
            param($module)
            Assert-ForwardingResults $findings[$module]
        }

        It 'Keeps every exception visible and rejects stale exclusions' {
            $allFindings = @($findings.Values | ForEach-Object { $_ })
            foreach ($exception in $exceptions) {
                $exception.Reason | Should -Not -BeNullOrEmpty
                @($allFindings | Where-Object { (Find-ForwardingException $_) -eq $exception }).Count | Should -Be 1
                Write-Warning "$($exception.Status): $($exception.Module)$($exception.Deployment) -> $($exception.Target): $($exception.Reason)"
            }
        }

        It 'Fails the production gate when a previously secured parent leaf is reverted' {
            $module = 'avm/res/api-management/service'
            $mutant = $production[$module] | ConvertTo-Json -Depth 100 | ConvertFrom-Json -AsHashtable -Depth 100
            $mutant.definitions.cacheType.properties.connectionString.type = 'string'
            { Assert-ForwardingResults @(Get-SecureParameterForwarding $mutant $module) } | Should -Throw '*connectionString*'
        }

        It 'Fails the production gate for a newly added arbitrary leaf, with no field-list update' {
            $module = 'avm/res/api-management/service'
            $mutant = $production[$module] | ConvertTo-Json -Depth 100 | ConvertFrom-Json -AsHashtable -Depth 100
            $mutant.parameters.freshInput = @{ type = 'object'; properties = @{ unrelated = @{ type = 'string' } } }
            $binding = $mutant.resources.service_caches.properties
            $binding.template.parameters.neverSeenBefore = @{ type = 'secureString' }
            $binding.parameters.neverSeenBefore = @{ value = "[parameters('freshInput').unrelated]" }
            { Assert-ForwardingResults @(Get-SecureParameterForwarding $mutant $module) } | Should -Throw '*freshInput.unrelated*'
        }

        It 'Does not let the logger object exclusion hide a secureString or a different source path' {
            $exception = $exceptions | Where-Object Target -eq credentials
            $finding = [pscustomobject] $exception.Clone()
            $finding.SinkType = 'secureString'
            { Assert-ForwardingResults @($finding) } | Should -Throw '*Unexpected*'
            $finding.SinkType = 'secureObject'
            $finding.Source = 'loggers.[].freshLeaf'
            { Assert-ForwardingResults @($finding) } | Should -Throw '*Unexpected*'
        }

        It 'Rejects changes to the explicitly unsupported SQL projection' {
            $exception = $exceptions | Where-Object Status -eq Unsupported
            $finding = [pscustomobject] $exception.Clone()
            $finding.ExpressionHash = 'changed'
            { Assert-ForwardingResults @($finding) } | Should -Throw '*Unexpected*'
        }
    }

    It 'Handles literal constructors without treating their ordinary siblings as secure inputs' {
        $sink = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString' }; label = @{ type = 'string' } } }
        $template = New-ForwardingTemplate -Value @{ freshLeaf = "[parameters('arbitrary')]"; label = 'label' } -Sink $sink
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch'
        $template.resources.child.properties.parameters.destination.value.freshLeaf = 'literal'
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'NonInput'
    }

    It 'Resolves optional nested leaves and loop items to their secure schemas' {
        $leaf = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString'; nullable = $true } } }
        foreach ($expression in @(
                "[tryGet(parameters('arbitrary'), 'nested', 'freshLeaf')]"
                "[tryGet(tryGet(parameters('arbitrary'), 'nested'), 'freshLeaf')]"
                "[parameters('arbitrary')['nested'].freshLeaf]"
            )) {
            $template = New-ForwardingTemplate -Schema @{ type = 'object'; properties = @{ nested = $leaf } } -Value $expression
            $result = Get-SecureParameterForwarding $template 'fixture'
            $result.Status | Should -Be 'Secure'
            $result.Source | Should -Be 'arbitrary.nested.freshLeaf'
        }
        foreach ($expression in @(
                "[coalesce(parameters('arbitrary'), createArray())[copyIndex('loop')].freshLeaf]"
                "[tryGet(parameters('arbitrary')[0], 'freshLeaf')]"
            )) {
            $template = New-ForwardingTemplate -Schema @{ type = 'array'; items = $leaf } -Value $expression
            $result = Get-SecureParameterForwarding $template 'fixture'
            $result.Status | Should -Be 'Secure'
            $result.Source | Should -Be 'arbitrary.[].freshLeaf'
        }
    }

    It 'Treats entirely literal discriminated constructors as non-input and other constructors as unsupported' {
        $sink = @{
            type = 'object'
            discriminator = @{
                propertyName = 'kind'
                mapping = @{ one = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString' } } } }
            }
        }
        $template = New-ForwardingTemplate -Sink $sink -Value @{ kind = 'one'; freshLeaf = 'literal' }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'NonInput'
        $template.resources.child.properties.parameters.destination.value.freshLeaf = "[parameters('arbitrary')]"
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Unsupported'
    }

    It 'Supports ARM resource arrays as well as symbolic resource dictionaries' {
        $template = New-ForwardingTemplate
        $template.resources = @($template.resources.child)
        $result = Get-SecureParameterForwarding $template 'fixture'
        $result.Status | Should -Be 'Mismatch'
        $result.Deployment | Should -Be '/0'
    }

    It 'Does not let dictionary member names hide forwarded object inputs' {
        $template = New-ForwardingTemplate -Sink @{ type = 'secureObject' } -Value @{
            Values = 'ordinary sibling'
            freshLeaf = "[parameters('arbitrary')]"
        }
        $results = @(Get-SecureParameterForwarding $template 'fixture')
        @($results | Where-Object Status -eq Mismatch).Count | Should -Be 1
    }

    It 'Does not mistake literals, nulls, runtime resource results, or generated values for forwarded inputs' {
        foreach ($value in @('literal', '[[escaped]', $null, '[null()]', '[newGuid()]', "[reference('resource').value]", "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('arbitrary')), '2023-01-01').keys[0].value]")) {
            (Get-SecureParameterForwarding (New-ForwardingTemplate -Value $value) 'fixture').Status | Should -Be 'NonInput'
        }
        $template = New-ForwardingTemplate
        $template.resources.child.properties.parameters.destination = @{ reference = @{ keyVault = @{ id = '/vault' }; secretName = 'example' } }
        @(Get-SecureParameterForwarding $template 'fixture').Count | Should -Be 0
        $template.resources.child.properties.parameters.Clear()
        @(Get-SecureParameterForwarding $template 'fixture').Count | Should -Be 0
    }

    It 'Checks both simple coalesce branches rather than trusting a generated but overridable default' {
        $template = New-ForwardingTemplate -Schema @{ type = 'secureString' } -Value "[coalesce(parameters('arbitrary'), parameters('fallback'))]"
        $template.parameters.fallback = @{ type = 'string'; defaultValue = '[newGuid()]' }
        $results = @(Get-SecureParameterForwarding $template 'fixture')
        $results.Status | Should -Contain 'Secure'
        ($results | Where-Object Status -eq Mismatch).Source | Should -Be 'fallback'
        $template.resources.child.properties.parameters.destination.value = "[coalesce(parameters('arbitrary'), '')]"
        @(Get-SecureParameterForwarding $template 'fixture' | Where-Object Status -eq Mismatch).Count | Should -Be 0
    }

    It 'Reports unsupported expressions instead of inferring paths from fragments' -TestCases @(
        @{ expression = "[variables('alias')]" }
        @{ expression = "[format('{0}', parameters('arbitrary'))]" }
        @{ expression = "[if(true(), parameters('arbitrary'), null())]" }
        @{ expression = "[parameters('arbitrary')[parameters('index')]]" }
        @{ expression = "[map(parameters('arbitrary'), lambda('x', lambdaVariables('x')))]" }
        @{ expression = "[tryGet(parameters('arbitrary'), variables('key'))]" }
    ) {
        param($expression)
        (Get-SecureParameterForwarding (New-ForwardingTemplate -Value $expression) 'fixture').Status | Should -Be 'Unsupported'
    }

    It 'Fails loudly for malformed schemas, cycles, linked templates, and missing resources' {
        $template = New-ForwardingTemplate -Schema @{ '$ref' = '#/definitions/missing' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*Missing definition*'
        $template.definitions.missing = @{ '$ref' = '#/definitions/missing' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*cyclic*'
        $template = New-ForwardingTemplate
        $template.resources.child.properties.templateLink = @{ uri = 'https://example.invalid/template.json' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*Linked templates*'
        { Get-SecureParameterForwarding @{} 'fixture' } | Should -Throw '*resources*'
        $template = New-ForwardingTemplate -Sink @{ type = 'object'; additionalProperties = @{ type = 'secureString' } }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*additionalProperties*'
        $template = New-ForwardingTemplate -Sink @{ anyOf = @(@{ type = 'secureString' }) }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*anyOf*'
        $template = New-ForwardingTemplate -Sink @{ type = 'unknown' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*schema type*'
        $template = New-ForwardingTemplate -Value "[parameters('missing')]"
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*Unknown input*'
    }

    It 'Discovers forwarding forms emitted by the real compiler, with a decorator-removal negative control' {
        $template = Build-ForwardingTemplate (Join-Path $PSScriptRoot 'src/secureParameterForwarding/main.bicep') 'forwarding-fixture'
        $results = @(Get-SecureParameterForwarding $template 'fixture')
        foreach ($deployment in @('/scalar', '/items', '/nested', '/discriminated')) {
            ($results | Where-Object Deployment -eq $deployment).Status | Should -Be 'Mismatch'
        }
        ($results | Where-Object Deployment -eq '/nested').Source | Should -Be 'settings.nested.arbitrary'
        ($results | Where-Object Deployment -eq '/items').Source | Should -Be 'entries.[].payload'
        ($results | Where-Object Deployment -eq '/ancestor').Status | Should -Be 'Secure'
        ($results | Where-Object Deployment -eq '/transformed').Status | Should -Be 'Unsupported'
        ($results | Where-Object Deployment -eq '/constant').Status | Should -Be 'NonInput'
        ($results | Where-Object Deployment -eq '/optional').Status | Should -Be 'NonInput'

        Copy-Item (Join-Path $PSScriptRoot 'src/secureParameterForwarding/child.bicep') $TestDrive
        $source = Get-Content (Join-Path $PSScriptRoot 'src/secureParameterForwarding/main.bicep') -Raw
        $source.Replace("@secure()`ntype protectedType", 'type protectedType') | Set-Content (Join-Path $TestDrive 'mutant.bicep')
        $mutant = Build-ForwardingTemplate (Join-Path $TestDrive 'mutant.bicep') 'mutant'
        (Get-SecureParameterForwarding $mutant 'fixture' | Where-Object Deployment -eq '/ancestor').Status | Should -Be 'Mismatch'
    }
}
