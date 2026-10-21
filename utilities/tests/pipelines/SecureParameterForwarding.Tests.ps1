param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1')

    <#
    .SYNOPSIS
    Construct a minimal parent/child template for analyzer behavior tests.
    .PARAMETER Schema
    The parent input schema.
    .PARAMETER Value
    The value forwarded to the child.
    .PARAMETER Sink
    The child input schema.
    #>
    function New-ForwardingTemplate {
        param(
            [System.Collections.IDictionary] $Schema = @{ type = 'string' },
            [object] $Value = "[parameters('arbitrary')]",
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

    <#
    .SYNOPSIS
    Compile a behavioral fixture and return its ARM template.
    .PARAMETER Path
    The Bicep fixture path.
    .PARAMETER OutputPath
    The compiled output path inside Pester's TestDrive.
    #>
    function Build-ForwardingTemplate {
        param([string] $Path, [string] $OutputPath)
        $diagnostics = bicep build $Path --outfile $OutputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        Get-Content -LiteralPath $OutputPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    }
}

Describe 'Bounded secure input forwarding analysis' {
    It 'Discovers arbitrary scalar <name> without a credential-name list' -TestCases @(
        @{ name = 'arbitrary' }
        @{ name = 'freshLeaf' }
        @{ name = 'unrelatedNewValue' }
        @{ name = 'Keys' }
        @{ name = 'Count' }
    ) {
        param([string] $name)
        $template = New-ForwardingTemplate
        $template.parameters = @{ $name = @{ type = 'string' } }
        $template.resources.child.properties.parameters.destination.value = "[parameters('$name')]"
        $result = @(Get-SecureParameterForwarding $template 'fixture')
        $result | Should -Not -BeNullOrEmpty -Because 'the child has a secure input binding'
        $result[0].Status | Should -Be 'Mismatch' -Because 'a plain parent cannot satisfy a secure child input'
        $result[0].Source | Should -Be $name -Because 'discovery must use schemas, not credential-name heuristics'
    }

    It 'Follows escaped local refs, aliases, nullability, and secure ancestors' {
        $template = New-ForwardingTemplate -Schema @{ '$ref' = '#/definitions/alias'; nullable = $true } -Value "[parameters('arbitrary').nested.freshLeaf]"
        $template.definitions = @{
            alias = @{ '$ref' = '#/definitions/private~1value' }
            'private/value' = @{ type = 'secureObject'; properties = @{ nested = @{ type = 'object' } } }
        }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure' -Because 'the referenced secure ancestor protects its nested leaves'
        $template.definitions['private/value'].type = 'object'
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'removing ancestor security leaves a plain nested input'
    }

    It 'Checks secure leaves inside whole forwarded objects and arrays, including discriminator variants' {
        $plain = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'string'; nullable = $true } } }
        $secure = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString'; nullable = $true } } }
        $template = New-ForwardingTemplate -Schema @{ type = 'array'; items = $plain } -Sink @{ type = 'array'; items = $secure }
        (Get-SecureParameterForwarding $template 'fixture').Source | Should -Be 'arbitrary.[].freshLeaf' -Because 'whole-array forwarding must include the nested leaf path'
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'the parent array item has a plain leaf'
        $template.parameters.arbitrary.items = $secure
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure' -Because 'the parent array item now matches the secure child leaf'

        $template = New-ForwardingTemplate -Schema @{
            type = 'object'; discriminator = @{ propertyName = 'kind'; mapping = @{ one = $plain; two = $plain } }
        } -Sink @{
            type = 'object'; discriminator = @{ propertyName = 'kind'; mapping = @{ one = $secure; two = $plain } }
        }
        $result = @(Get-SecureParameterForwarding $template 'fixture')
        $result | Should -Not -BeNullOrEmpty -Because 'the secure discriminator variant must be checked'
        $result[0].Source | Should -Be 'arbitrary.@kind=one.freshLeaf' -Because 'the path must retain the applicable discriminator variant'
        $result[0].Status | Should -Be 'Mismatch' -Because 'that parent variant has a plain leaf'
        $template.parameters.arbitrary.discriminator.mapping.one = $secure
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure' -Because 'the corresponding parent variant is now secure'
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
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'an open variant can contain an undeclared plain member'
        $template.parameters.arbitrary.discriminator.mapping.two.additionalProperties = @{ type = 'string' }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'the second variant explicitly permits plain additional members'
        $template.parameters.arbitrary.discriminator.mapping.two.additionalProperties = $false
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure' -Because 'the closed variant cannot contribute an insecure leaf'
    }

    It 'Handles literal constructors without treating their ordinary siblings as secure inputs' {
        $sink = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString' }; label = @{ type = 'string' } } }
        $template = New-ForwardingTemplate -Value @{ freshLeaf = "[parameters('arbitrary')]"; label = 'label' } -Sink $sink
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'the constructor forwards a plain input into a secure leaf'
        $template.resources.child.properties.parameters.destination.value.freshLeaf = 'literal'
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'NonInput' -Because 'the constructor now contains only literal values'
    }

    It 'Resolves <expression> to <source>' -TestCases @(
        @{ expression = "[tryGet(parameters('arbitrary'), 'nested', 'freshLeaf')]"; source = 'arbitrary.nested.freshLeaf'; array = $false }
        @{ expression = "[tryGet(tryGet(parameters('arbitrary'), 'nested'), 'freshLeaf')]"; source = 'arbitrary.nested.freshLeaf'; array = $false }
        @{ expression = "[parameters('arbitrary')['nested'].freshLeaf]"; source = 'arbitrary.nested.freshLeaf'; array = $false }
        @{ expression = "[coalesce(parameters('arbitrary'), createArray())[copyIndex('loop')].freshLeaf]"; source = 'arbitrary.[].freshLeaf'; array = $true }
        @{ expression = "[tryGet(parameters('arbitrary')[0], 'freshLeaf')]"; source = 'arbitrary.[].freshLeaf'; array = $true }
    ) {
        param([string] $expression, [string] $source, [bool] $array)
        $leaf = @{ type = 'object'; properties = @{ freshLeaf = @{ type = 'secureString'; nullable = $true } } }
        $schema = if ($array) { @{ type = 'array'; items = $leaf } } else { @{ type = 'object'; properties = @{ nested = $leaf } } }
        $template = New-ForwardingTemplate -Schema $schema -Value $expression
        $result = Get-SecureParameterForwarding $template 'fixture'
        $result.Status | Should -Be 'Secure' -Because 'the normalized parent leaf is secure'
        $result.Source | Should -Be $source -Because 'optional accesses and indices must preserve the input path'
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
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'NonInput' -Because 'an entirely literal union constructor has no caller input'
        $template.resources.child.properties.parameters.destination.value.freshLeaf = "[parameters('arbitrary')]"
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Unsupported' -Because 'a union constructor with expressions needs semantic analysis'
    }

    It 'Supports ARM resource arrays as well as symbolic resource dictionaries' {
        $template = New-ForwardingTemplate
        $template.resources = @($template.resources.child)
        $result = Get-SecureParameterForwarding $template 'fixture'
        $result.Status | Should -Be 'Mismatch' -Because 'array-form resources must receive the same checks as symbolic resources'
        $result.Deployment | Should -Be '/0' -Because 'array resource diagnostics use the resource index'
    }

    It 'Does not let dictionary member names hide forwarded object inputs' {
        $template = New-ForwardingTemplate -Sink @{ type = 'secureObject' } -Value @{
            Values = 'ordinary sibling'
            freshLeaf = "[parameters('arbitrary')]"
        }
        $results = @(Get-SecureParameterForwarding $template 'fixture')
        @($results | Where-Object Status -eq Mismatch) | Should -Not -BeNullOrEmpty -Because 'dictionary member names must not shadow the forwarded value'
    }

    It 'Does not mistake <value> for a forwarded input' -TestCases @(
        @{ value = 'literal' }
        @{ value = '[[escaped]' }
        @{ value = $null }
        @{ value = '[null()]' }
        @{ value = '[newGuid()]' }
        @{ value = "[reference('resource').value]" }
        @{ value = "[listKeys(resourceId('Microsoft.Storage/storageAccounts', parameters('arbitrary')), '2023-01-01').keys[0].value]" }
    ) {
        param([object] $value)
        (Get-SecureParameterForwarding (New-ForwardingTemplate -Value $value) 'fixture').Status | Should -Be 'NonInput' -Because 'this value is not a forwarded caller input'
    }

    It 'Ignores Key Vault references and omitted bindings' {
        $template = New-ForwardingTemplate
        $template.resources.child.properties.parameters.destination = @{ reference = @{ keyVault = @{ id = '/vault' }; secretName = 'example' } }
        @(Get-SecureParameterForwarding $template 'fixture') | Should -BeNullOrEmpty -Because 'a Key Vault parameter reference is not a forwarded caller input'
        $template.resources.child.properties.parameters.Clear()
        @(Get-SecureParameterForwarding $template 'fixture') | Should -BeNullOrEmpty -Because 'an omitted binding uses the child default'
    }

    It 'Checks both simple coalesce branches rather than trusting a generated but overridable default' {
        $template = New-ForwardingTemplate -Schema @{ type = 'secureString' } -Value "[coalesce(parameters('arbitrary'), parameters('fallback'))]"
        $template.parameters.fallback = @{ type = 'string'; defaultValue = '[newGuid()]' }
        $results = @(Get-SecureParameterForwarding $template 'fixture')
        $results.Status | Should -Contain 'Secure' -Because 'the first coalesce branch forwards a secure input'
        ($results | Where-Object Status -eq Mismatch).Source | Should -Be 'fallback' -Because 'the fallback remains a plain overridable input despite its default'
        $template.resources.child.properties.parameters.destination.value = "[coalesce(parameters('arbitrary'), '')]"
        @(Get-SecureParameterForwarding $template 'fixture' | Where-Object Status -eq Mismatch) | Should -BeNullOrEmpty -Because 'an empty-string fallback introduces no plain caller input'
    }

    It 'Reports <expression> as unsupported instead of inferring paths from fragments' -TestCases @(
        @{ expression = "[variables('alias')]" }
        @{ expression = "[format('{0}', parameters('arbitrary'))]" }
        @{ expression = "[if(true(), parameters('arbitrary'), null())]" }
        @{ expression = "[parameters('arbitrary')[parameters('index')]]" }
        @{ expression = "[map(parameters('arbitrary'), lambda('x', lambdaVariables('x')))]" }
        @{ expression = "[tryGet(parameters('arbitrary'), variables('key'))]" }
    ) {
        param([string] $expression)
        (Get-SecureParameterForwarding (New-ForwardingTemplate -Value $expression) 'fixture').Status | Should -Be 'Unsupported' -Because 'an unrecognized complete expression must not be inferred secure'
    }

    It 'Checks secure dictionary values and tuple positions' {
        $sink = @{ type = 'object'; additionalProperties = @{ type = 'object'; properties = @{ accessKey = @{ type = 'secureString' } } } }
        $template = New-ForwardingTemplate -Sink $sink -Schema @{ type = 'object'; additionalProperties = @{ type = 'object'; properties = @{ accessKey = @{ type = 'string' } } } }
        $result = Get-SecureParameterForwarding $template 'fixture'
        $result.Source | Should -Be 'arbitrary.*.accessKey' -Because 'dictionary value paths must preserve their nested secure leaf'
        $result.Status | Should -Be 'Mismatch' -Because 'the parent dictionary value has a plain accessKey'
        $template.parameters.arbitrary = $sink
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure' -Because 'the dictionary value now matches the secure sink schema'
        $template.parameters.arbitrary = @{ type = 'object'; properties = @{ plain = @{ type = 'string' } }; additionalProperties = @{ type = 'secureString' } }
        $template.resources.child.properties.template.parameters.destination = @{ type = 'object'; additionalProperties = @{ type = 'secureString' } }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'a declared plain member can also reach the secure dictionary'
        $template.parameters.arbitrary.properties.plain.type = 'secureString'
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure' -Because 'both declared and additional members are now secure'
        $template.parameters.arbitrary = $sink
        $template.resources.child.properties.template.parameters.destination = $sink
        $template.resources.child.properties.parameters.destination.value = @{ first = @{ accessKey = "[parameters('arbitrary').first.accessKey]" }; second = @{ accessKey = "[parameters('plain')]" } }
        $template.parameters.plain = @{ type = 'string' }
        $statuses = @(Get-SecureParameterForwarding $template 'fixture' | Sort-Object Status).Status
        $statuses | Should -Be @('Mismatch', 'Secure') -Because 'literal dictionaries must check each member independently'

        $template = New-ForwardingTemplate -Sink @{ type = 'array'; prefixItems = @(@{ type = 'secureString' }, @{ type = 'string' }); items = $false } `
            -Schema @{ type = 'array'; prefixItems = @(@{ type = 'secureString' }, @{ type = 'string' }); items = $false }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'tuple positions share one path token, so every position must be secure'
        $template.parameters.arbitrary.prefixItems[1] = @{ type = 'secureString' }
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Secure' -Because 'every parent tuple position is now secure'
    }

    It 'Ignores untyped any schemas and follows loadJsonContent templates' {
        $template = New-ForwardingTemplate -Sink @{ metadata = @{ description = 'any' } }
        @(Get-SecureParameterForwarding $template 'fixture') | Should -BeNullOrEmpty -Because 'an untyped schema declares no secure child leaves'

        $template = New-ForwardingTemplate
        $template.variables = @{ '$fxv#0' = $template.resources.child.properties.template }
        $template.resources.child.properties.template = "[variables('`$fxv#0')]"
        (Get-SecureParameterForwarding $template 'fixture').Status | Should -Be 'Mismatch' -Because 'loadJsonContent templates still contain enforceable child schemas'
    }

    It 'Fails loudly for malformed schemas, cycles, linked templates, and missing resources' {
        $template = New-ForwardingTemplate -Schema @{ '$ref' = '#/definitions/missing' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*Missing definition*' -Because 'unresolved schemas must not look like passing results'
        $template.definitions.missing = @{ '$ref' = '#/definitions/missing' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*cyclic*' -Because 'reference cycles cannot be analyzed'
        $template = New-ForwardingTemplate
        $template.resources.child.properties.templateLink = @{ uri = 'https://example.invalid/template.json' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*Linked templates*' -Because 'external templates cannot be inspected here'
        { Get-SecureParameterForwarding @{} 'fixture' } | Should -Throw '*resources*' -Because 'missing resource collections indicate an invalid template'
        $template = New-ForwardingTemplate -Sink @{ anyOf = @(@{ type = 'secureString' }) }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*anyOf*' -Because 'unsupported schema combinators must fail explicitly'
        $template = New-ForwardingTemplate -Sink @{ type = 'unknown' }
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*schema type*' -Because 'unknown schema types cannot establish secure leaves'
        $template = New-ForwardingTemplate -Value "[parameters('missing')]"
        { Get-SecureParameterForwarding $template 'fixture' } | Should -Throw '*Unknown input*' -Because 'a nonexistent parent input is a malformed binding'
    }

    Context 'Compiler-emitted forwarding' {
        BeforeAll {
            $template = Build-ForwardingTemplate (Join-Path $PSScriptRoot 'src/secureParameterForwarding/main.bicep') (Join-Path $TestDrive 'forwarding-fixture.json')
            $results = @(Get-SecureParameterForwarding $template 'fixture')
        }

        It 'Classifies <deployment> as <status> from the real compiler' -TestCases @(
            @{ deployment = '/scalar'; status = 'Mismatch' }
            @{ deployment = '/items'; status = 'Mismatch' }
            @{ deployment = '/nested'; status = 'Mismatch' }
            @{ deployment = '/discriminated'; status = 'Mismatch' }
            @{ deployment = '/ancestor'; status = 'Secure' }
            @{ deployment = '/transformed'; status = 'Unsupported' }
            @{ deployment = '/constant'; status = 'NonInput' }
            @{ deployment = '/optional'; status = 'NonInput' }
        ) {
            param([string] $deployment, [string] $status)
            ($results | Where-Object Deployment -eq $deployment).Status | Should -Be $status -Because 'the analyzer must recognize actual compiler output, not only synthetic templates'
        }

        It 'Preserves optional and array source paths' {
            ($results | Where-Object Deployment -eq '/nested').Source | Should -Be 'settings.nested.arbitrary' -Because 'compiled optional access must resolve to its parent schema'
            ($results | Where-Object Deployment -eq '/items').Source | Should -Be 'entries.[].payload' -Because 'compiled loop indices must resolve to the array item schema'
        }

        It 'Detects removal of a secure ancestor decorator after recompiling' {
            Copy-Item (Join-Path $PSScriptRoot 'src/secureParameterForwarding/child.bicep') $TestDrive
            $source = Get-Content (Join-Path $PSScriptRoot 'src/secureParameterForwarding/main.bicep') -Raw
            $source.Replace("@secure()`ntype protectedType", 'type protectedType') | Set-Content (Join-Path $TestDrive 'mutant.bicep')
            $mutant = Build-ForwardingTemplate (Join-Path $TestDrive 'mutant.bicep') (Join-Path $TestDrive 'mutant.json')
            (Get-SecureParameterForwarding $mutant 'fixture' | Where-Object Deployment -eq '/ancestor').Status | Should -Be 'Mismatch' -Because 'removing the real decorator must change the compiled classification'
        }
    }
}
