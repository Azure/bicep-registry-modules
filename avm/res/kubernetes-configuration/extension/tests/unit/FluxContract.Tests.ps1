Describe 'Flux native-property secure overlay' {
    BeforeAll {
        $moduleRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        $moduleImport = [System.IO.Path]::GetRelativePath($TestDrive, (Join-Path $moduleRoot 'main.bicep'))
        $bicep = if ($env:AVM_CONTRACT_TEST_BICEP_PATH) { $env:AVM_CONTRACT_TEST_BICEP_PATH } else { 'bicep' }
        $fixture = Join-Path $TestDrive 'flux.bicep'
        @"
import { fluxConfigurationType } from '$moduleImport'
param optionalConfigurations fluxConfigurationType[]?
param fluxConfigurations fluxConfigurationType[] = [
  { namespace: 'flux-system', scope: 'cluster', kustomizations: {} }
  { namespace: 'flux-system', scope: 'namespace', kustomizations: {}, azureBlob: { containerName: 'previously-accepted' }, futureProperty: true }
]
"@ | Set-Content -LiteralPath $fixture
        $output = & $bicep build $fixture --stdout --no-restore 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($output | Out-String) }
        $template = ($output | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] } | Out-String) |
            ConvertFrom-Json -AsHashtable

        $source = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.bicep') -Raw
        $forwarding = foreach ($property in @('namespace', 'scope', 'kustomizations')) {
            $match = [regex]::Match($source, "(?m)^      ${property}: (?<expression>[^\r\n]+)")
            if (-not $match.Success) { throw "Missing Flux forwarding expression for $property." }
            "param $property = $($match.Groups['expression'].Value)"
        }
        $callerCases = @{}
        $forwardingCases = @{}
        foreach ($property in @('namespace', 'scope', 'kustomizations')) {
            foreach ($variant in @('missing', 'null')) {
                $key = "$variant-$property"
                $values = @{ namespace = 'flux-system'; scope = 'cluster'; kustomizations = @{ unified = @{ path = './cluster-manifests' } } }
                if ($variant -eq 'missing') { $values.Remove($property) }
                else { $values[$property] = $null }

                $members = foreach ($name in @('namespace', 'scope', 'kustomizations')) {
                    if (-not $values.ContainsKey($name)) { continue }
                    $value = if ($null -eq $values[$name]) { 'null' }
                    elseif ($name -eq 'kustomizations') { '{}' }
                    else { "'$($values[$name])'" }
                    "${name}: $value"
                }
                $callerPath = Join-Path $TestDrive "$key.bicep"
                @"
import { fluxConfigurationType } from '$moduleImport'
param configurations fluxConfigurationType[] = [
  { $($members -join ', ') }
]
"@ | Set-Content -LiteralPath $callerPath
                $diagnostics = & $bicep build $callerPath --no-restore --outfile (Join-Path $TestDrive "$key.arm.json") 2>&1 | Out-String
                $callerCases[$key] = @{ ExitCode = $LASTEXITCODE; Diagnostics = $diagnostics }

                $parameterPath = Join-Path $TestDrive "$key.bicepparam"
                $parameterOutput = Join-Path $TestDrive "$key.parameters.json"
                @(
                    'using none'
                    # Keep the test object's shape unknown so the evaluator exercises the real lookup.
                    "var fluxConfiguration = any(json('$($values | ConvertTo-Json -Compress -Depth 10)'))"
                    $forwarding
                ) -join "`n" | Set-Content -LiteralPath $parameterPath
                $diagnostics = & $bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1 | Out-String
                $forwardingCases[$key] = @{ ExitCode = $LASTEXITCODE; Diagnostics = $diagnostics }
                if ($LASTEXITCODE -eq 0) {
                    $forwardingCases[$key].Parameters = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
                }
            }
        }
        $presentPath = Join-Path $TestDrive 'present.bicepparam'
        $presentOutput = Join-Path $TestDrive 'present.parameters.json'
        @(
            'using none'
            "var fluxConfiguration = { namespace: 'flux-system', scope: 'cluster', kustomizations: { unified: { path: './cluster-manifests' } } }"
            $forwarding
        ) -join "`n" | Set-Content -LiteralPath $presentPath
        $diagnostics = & $bicep build-params $presentPath --no-restore --outfile $presentOutput 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) { throw $diagnostics }
        $present = (Get-Content -LiteralPath $presentOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Requires directly forwarded child inputs while retaining native types and open sibling properties' {
        foreach ($property in @('namespace', 'scope', 'kustomizations')) {
            $template.definitions.fluxConfigurationType.properties[$property].ContainsKey('nullable') | Should -BeFalse
            $template.definitions.fluxConfigurationType.properties[$property].metadata.'__bicep_resource_derived_type!'.source |
                Should -BeLike "Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01#*/$property"
        }
        $template.definitions.fluxConfigurationType.additionalProperties | Should -Not -BeFalse
        $template.parameters.optionalConfigurations.nullable | Should -BeTrue
    }

    It 'Protects only the configuration settings dictionary, not ordinary sibling properties' {
        $properties = $template.definitions.fluxConfigurationType.properties
        $properties.configurationProtectedSettings.type | Should -BeExactly 'secureObject'
        $properties.configurationProtectedSettings.nullable | Should -BeTrue
        $properties.namespace.type | Should -BeExactly 'string'
        $properties.scope.type | Should -BeExactly 'string'
        $properties.kustomizations.type | Should -BeExactly 'object'
    }

    It 'Rejects a missing required <Property> in the input contract' -ForEach @(
        @{ Property = 'namespace' }
        @{ Property = 'scope' }
        @{ Property = 'kustomizations' }
    ) {
        $callerCases["missing-$Property"].ExitCode | Should -Not -Be 0
        $callerCases["missing-$Property"].Diagnostics | Should -Match 'BCP035'
    }

    It 'Diagnoses an explicit null <Property> without replacing the native property type' -ForEach @(
        @{ Property = 'namespace' }
        @{ Property = 'scope' }
        @{ Property = 'kustomizations' }
    ) {
        # Native type mismatches can be warnings; the emitted contract must still be non-nullable.
        $callerCases["null-$Property"].Diagnostics | Should -Match 'BCP036'
        $template.definitions.fluxConfigurationType.properties[$Property].ContainsKey('nullable') | Should -BeFalse
    }

    It 'Forwards present required values without changing them' {
        $present.namespace.value | Should -BeExactly 'flux-system'
        $present.scope.value | Should -BeExactly 'cluster'
        $present.kustomizations.value.unified.path | Should -BeExactly './cluster-manifests'
    }

    It 'Cannot read a missing <Property> rather than inventing a forwarding default' -ForEach @(
        @{ Property = 'namespace' }
        @{ Property = 'scope' }
        @{ Property = 'kustomizations' }
    ) {
        $forwardingCases["missing-$Property"].ExitCode | Should -Not -Be 0
        $forwardingCases["missing-$Property"].Diagnostics | Should -Match 'BCP338'
    }

    It 'Passes an explicit null <Property> through the expression without inventing a default' -ForEach @(
        @{ Property = 'namespace' }
        @{ Property = 'scope' }
        @{ Property = 'kustomizations' }
    ) {
        $forwardingCases["null-$Property"].ExitCode | Should -Be 0
        $forwardingCases["null-$Property"].Parameters[$Property].ContainsKey('value') | Should -BeTrue
        $forwardingCases["null-$Property"].Parameters[$Property].value | Should -BeNullOrEmpty
    }
}
