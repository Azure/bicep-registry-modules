#requires -Version 7.3

<#
.SYNOPSIS
Compares native Bicep results with the pinned Terraform implementation without planning or deploying resources.
.PARAMETER TerraformSourcePath
An already initialized checkout or extracted archive of the manifest's Terraform revision.
.PARAMETER NativeResultsPath
The output of bicep build-params tests/unit/evaluate.bicepparam.
.PARAMETER EvidencePath
Directory for Terraform inputs, results and the comparison report. No files are written into the Terraform source.
.EXAMPLE
Test-TerraformParity -TerraformSourcePath C:\references\naming -NativeResultsPath C:\evidence\native.json -EvidencePath C:\evidence\parity
#>
function Test-TerraformParity {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $TerraformSourcePath,
        [Parameter(Mandatory)][string] $NativeResultsPath,
        [Parameter(Mandatory)][string] $EvidencePath
    )

    $ErrorActionPreference = 'Stop'
    $modulePath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..'))
    $manifest = Get-Content -LiteralPath (Join-Path $modulePath 'catalog-source.json') -Raw | ConvertFrom-Json -AsHashtable
    foreach ($path in $manifest.sources.Keys) {
        $actual = (Get-FileHash -LiteralPath (Join-Path $TerraformSourcePath $path) -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actual -cne $manifest.sources[$path].sha256) { throw "Terraform reference [$path] differs from the pinned snapshots." }
    }
    $null = Get-Command terraform -ErrorAction Stop
    $null = New-Item -Path $EvidencePath -ItemType Directory -Force
    $native = (Get-Content -LiteralPath $NativeResultsPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters
    $supportedPatterns = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($entry in (Get-Content -LiteralPath (Join-Path $modulePath 'generated' 'regex.json') -Raw | ConvertFrom-Json -Depth 100)) {
        $null = $supportedPatterns.Add($entry.pattern)
    }
    $customer = (Join-Path $PSScriptRoot 'overrides.json').Replace('\', '/')
    $instance = @{ unique_seed = 'abcd1234'; suffix = @('workload', 'dev'); instance = 1 }
    $template = @{
        unique_length = 0
        instance = 1
        naming_template_variables = @{ environment = 'dev'; location = 'uks' }
        naming_templates = @{ name = '${slug}${separator}${environment}${separator}${location}${separator}${instance}' }
    }
    $scenarios = [ordered]@{
        baseline = @{ query = 'local.names'; variables = @{ unique_seed = 'a1b2c3d4' } }
        seedZero = @{ key = 'storage_account'; variables = @{ unique_length = 0 } }
        seedUnchanged = @{ key = 'resource_group'; variables = @{ unique_seed = 'AB12z'; unique_length = 4; unique_include_numbers = $false } }
        shortSeed = @{ key = 'storage_account'; variables = @{ unique_seed = 'z'; unique_length = 8 } }
        compact = @{ key = 'resource_group'; variables = @{ prefix = @('', 'Team', $null, ''); suffix = @('', $null, 'Dev', ''); unique_length = 0 } }
        instance = @{ key = 'storage_account'; variables = $instance }
        instanceZero = @{ key = 'resource_group'; variables = $instance + @{} }
        instanceLarge = @{ key = 'resource_group'; variables = $instance + @{} }
        instanceWidth = @{ key = 'resource_group'; variables = $instance + @{ instance_format = '%02d' } }
        instanceUnpadded = @{ key = 'resource_group'; variables = $instance + @{ instance_format = '%d' } }
        instanceLong = @{ key = 'storage_account'; variables = $instance + @{ prefix = @('a' * 100) } }
        instanceLongOther = @{ key = 'storage_account'; variables = $instance + @{ prefix = @('a' * 100) } }
        instanceOversized = @{ key = 'storage_account'; variables = $instance + @{ instance_format = '%030d' } }
        simpleTemplate = @{ key = 'storage_account'; variables = $template }
        literalTemplate = @{ key = 'storage_account'; variables = $template + @{} }
        joinedTemplate = @{ key = 'resource_group'; variables = @{
                unique_seed = 'abcd'
                naming_template_variables = @{ environment = 'dev'; location = 'uks' }
                naming_templates = @{ name = '${join(separator, compact([slug, environment, location]))}'; name_unique = '${join(separator, compact([unique, name]))}' }
            } }
        prefixTemplate = @{ key = 'resource_group'; variables = @{ unique_length = 0; prefix = @('a', 'b'); naming_templates = @{ name = '${join(separator, prefix)}' } } }
        upperTemplate = @{ key = 'resource_group'; variables = @{ unique_seed = 'abcd'; naming_templates = @{ name_unique = '${name}${upper(unique)}' } } }
        upperCustomToken = @{ key = 'resource_group'; variables = @{ unique_length = 0; naming_template_variables = @{ TEAM = 'blue' }; naming_templates = @{ name = '${TEAM}' } } }
        instanceUpper = @{ key = 'resource_group'; variables = $instance + @{ instance_format = 'id%03d'; naming_templates = @{ name = '${join(separator, [upper(instance), slug])}' } } }
        instanceMissing = @{ key = 'storage_account'; variables = $instance + @{ prefix = @('001'); naming_templates = @{ name = '${slug}' } } }
        instanceUniqueOnly = @{ key = 'resource_group'; variables = $instance + @{ naming_templates = @{ name = '${slug}'; name_unique = '${join(separator, [name, instance, unique])}' } } }
        uniqueMissing = @{ key = 'storage_account'; variables = @{ unique_seed = 'p'; prefix = @('prod'); naming_templates = @{ name_unique = '${name}' } } }
        fixed = @{ key = 'storage_account_blob_service'; variables = $instance + @{ prefix = @('a' * 100) } }
        uuid = @{ key = 'role_assignment'; variables = @{ unique_seed = 'a1b2c3d4' } }
        uuidZero = @{ key = 'role_assignment'; variables = @{ unique_length = 0; suffix = @('one') } }
        uuidOther = @{ key = 'role_assignment'; variables = @{ unique_length = 0; suffix = @('two') } }
        custom = @{ key = 'storage_account'; variables = @{ prefix = @('Contoso'); unique_seed = 'abcd'; custom_override_file = $customer } }
        customNew = @{ key = 'organization_label'; variables = @{ unique_length = 0; custom_override_file = $customer } }
        customSlug = @{ key = 'storage_account'; variables = @{ unique_length = 0; custom_override_file = $customer; slug_overrides = @{ storage_account = 'override' } } }
    }
    $scenarios.instanceZero.variables.instance = 0
    $scenarios.instanceLarge.variables.instance = 1000
    $scenarios.instanceWidth.variables.instance = 20
    $scenarios.instanceUnpadded.variables.instance = 20
    $scenarios.instanceLongOther.variables.instance = 20
    $scenarios.literalTemplate.variables.naming_templates = @{ name = '${slug}-${environment}-${location}-${instance}' }
    $fields = [ordered]@{
        name = 'name'; name_unique = 'nameUnique'; name_available = 'nameAvailable'; name_unique_available = 'nameUniqueAvailable'
        terraform_key = 'terraformKey'; resource_type = 'resourceType'; variant = 'variant'; name_kind = 'nameKind'
        slug = 'slug'; slug_source = 'slugSource'; separator = 'separator'; dashes = 'dashes'
        min_length = 'minLength'; max_length = 'maxLength'; scope = 'scope'; regex = 'regex'; instance = 'instance'
        unique_seed = 'uniqueSeed'; unique_suffix_retained = 'uniqueSuffixRetained'; fits_max_length = 'fitsMaxLength'
    }
    $differences = [Collections.Generic.List[object]]::new()
    $capabilityDifferences = [Collections.Generic.List[object]]::new()
    $comparisons = 0
    $entries = 0
    $uuidValuesExcluded = 0
    foreach ($scenarioName in $scenarios.Keys) {
        $scenario = $scenarios[$scenarioName]
        $variablesPath = Join-Path $EvidencePath "$scenarioName.tfvars.json"
        $scenario.variables | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $variablesPath -Encoding utf8NoBOM
        $query = $scenarioName -ceq 'baseline' ? $scenario.query : "local.names[`"$($scenario.key)`"]"
        $response = "jsonencode($query)" | terraform "-chdir=$TerraformSourcePath" console -no-color "-var-file=$variablesPath" 2>&1
        if ($LASTEXITCODE -ne 0) { throw "Terraform console failed for [$scenarioName]: $($response | Out-String)" }
        $json = ($response -join "`n") | ConvertFrom-Json
        $expected = $json | ConvertFrom-Json -AsHashtable -Depth 100
        $json | Set-Content -LiteralPath (Join-Path $EvidencePath "$scenarioName.json") -Encoding utf8NoBOM
        $actual = $scenarioName -ceq 'baseline' ? $native.baseline.value : @{ $scenario.key = $native.cases.value[$scenarioName] }
        if ($scenarioName -cne 'baseline') { $expected = @{ $scenario.key = $expected } }
        if (@($actual.Keys | Sort-Object) -join ',' -cne (@($expected.Keys | Sort-Object) -join ',')) { throw "Catalog keys differ for [$scenarioName]." }
        foreach ($key in $expected.Keys) {
            $entries++
            $expectedFields = [ordered]@{}
            $actualFields = [ordered]@{}
            foreach ($field in $fields.Keys) {
                if ($expected[$key].name_kind -ceq 'uuid' -and $field -in @('name', 'name_unique')) { $uuidValuesExcluded++; continue }
                $expectedFields[$field] = $expected[$key][$field]
                $actualFields[$field] = $actual[$key][$fields[$field]]
            }
            $expectedFields['validation_complete'] = $expected[$key].validation_complete -and $supportedPatterns.Contains($actual[$key].rule.regex)
            $actualFields['validation_complete'] = $actual[$key].validationComplete
            if ($expected[$key].validation_complete -ne $actual[$key].validationComplete) {
                $capabilityDifferences.Add(@{
                    scenario = $scenarioName
                    key = $key
                    pattern = $actual[$key].rule.regex
                    terraform = $expected[$key].validation_complete
                    bicep = $actual[$key].validationComplete
                })
            }
            foreach ($field in @('name', 'name_unique')) {
                $nativeField = $fields[$field]
                $expectedFields["instance_retained.$field"] = $expected[$key].instance_retained[$field]
                $actualFields["instance_retained.$field"] = $actual[$key].instanceRetained[$nativeField]
                $expectedFields["$field.errors-present"] = $expected[$key]["${field}_errors"].Count -gt 0
                $actualFields["$field.errors-present"] = $actual[$key]["${nativeField}Errors"].Count -gt 0
                $validationField = "valid$($nativeField.Substring(0, 1).ToUpperInvariant())$($nativeField.Substring(1))"
                $available = $actual[$key]["${nativeField}Available"]
                $expectedFields["validation.$field"] = -not $available ? $false : $actual[$key].validationComplete ? $expected[$key].validation["valid_$field"] : $null
                $actualFields["validation.$field"] = $actual[$key].validation[$validationField]
            }
            foreach ($field in $expectedFields.Keys) {
                $comparisons++
                $expectedJson = ConvertTo-Json -InputObject $expectedFields[$field] -Depth 100 -Compress
                $actualJson = ConvertTo-Json -InputObject $actualFields[$field] -Depth 100 -Compress
                if ($expectedJson -cne $actualJson) {
                    $differences.Add(@{ scenario = $scenarioName; key = $key; field = $field; expected = $expectedFields[$field]; actual = $actualFields[$field] })
                }
            }
        }
    }
    $referenceHashes = [ordered]@{}
    foreach ($file in Get-ChildItem -LiteralPath $TerraformSourcePath -Filter '*.tf' -File | Sort-Object Name) {
        $referenceHashes[$file.Name] = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    }
    $report = [ordered]@{
        upstreamRevision = $manifest.revision
        terraformVersion = ((terraform version -json | ConvertFrom-Json).terraform_version)
        referenceCodeHashes = $referenceHashes
        nativeOutputSha256 = (Get-FileHash -LiteralPath $NativeResultsPath -Algorithm SHA256).Hash.ToLowerInvariant()
        bicepSourceSha256 = (Get-FileHash -LiteralPath (Join-Path $modulePath 'main.bicep') -Algorithm SHA256).Hash.ToLowerInvariant()
        scenarios = $scenarios.Count
        entriesCompared = $entries
        comparisons = $comparisons
        uuidValuesExcluded = $uuidValuesExcluded
        validationCapabilityDifferences = $capabilityDifferences.ToArray()
        differences = $differences.ToArray()
    }
    $reportPath = Join-Path $EvidencePath 'parity-report.json'
    $report | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $reportPath -Encoding utf8NoBOM
    if ($differences.Count -gt 0) { throw "Terraform parity differs in $($differences.Count) checks. See [$reportPath]." }
    [pscustomobject]@{ Scenarios = $scenarios.Count; EntriesCompared = $entries; Comparisons = $comparisons; Differences = 0; ReportPath = $reportPath }
}
