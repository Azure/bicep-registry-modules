BeforeDiscovery {
    # An explicit compiler under test must support both rules; only the default may lack them.
    $bicep = if ($env:AVM_WEB_TEST_BICEP_PATH) { $env:AVM_WEB_TEST_BICEP_PATH } else { 'bicep' }
    # Probe behavior independently of the module under test, before discovering rule-specific cases.
    $probeRoot = Join-Path ([System.IO.Path]::GetTempPath()) "web-secure-rule-capabilities-$([guid]::NewGuid())"
    try {
        $null = New-Item -Path $probeRoot -ItemType Directory
        @'
@secure()
param sensitive string
param ordinary string
'@ | Set-Content -LiteralPath (Join-Path $probeRoot 'child.bicep')
        @'
@secure()
param secret string
param plain string
module probe 'child.bicep' = {
  name: 'capability-probe'
  params: {
    sensitive: plain
    ordinary: secret
  }
}
'@ | Set-Content -LiteralPath (Join-Path $probeRoot 'probe.bicep')
        '{"analyzers":{"core":{"rules":{"no-secure-values-in-insecure-inputs":{"level":"warning"},"use-secure-value-for-secure-inputs":{"level":"warning"}}}}}' |
            Set-Content -LiteralPath (Join-Path $probeRoot 'bicepconfig.json')
        $probeOutput = & $bicep lint (Join-Path $probeRoot 'probe.bicep') --no-restore --diagnostics-format sarif 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($probeOutput | Out-String) }
        $probeDiagnostics = @((($probeOutput | Out-String | ConvertFrom-Json -AsHashtable).runs)[0].results)
        $hasLeakRule = $probeDiagnostics.ruleId -contains 'no-secure-values-in-insecure-inputs'
        $hasReverseRule = $probeDiagnostics.ruleId -contains 'use-secure-value-for-secure-inputs'
        $missingRules = @('no-secure-values-in-insecure-inputs', 'use-secure-value-for-secure-inputs') |
            Where-Object { $_ -notin $probeDiagnostics.ruleId }
        if ($missingRules.Count -gt 0) {
            $missingRuleMessage = "Selected compiler ($(& $bicep --version)) did not emit [$($missingRules -join ', ')] in the isolated capability probe."
            if ($env:AVM_WEB_TEST_BICEP_PATH) {
                throw "$missingRuleMessage Explicit AVM_WEB_TEST_BICEP_PATH requires both secure-flow rules."
            }
            Write-Warning "$missingRuleMessage Unsupported secure-flow cases are not discovered; schema/static and output-security checks still run."
        }
    } finally {
        if (Test-Path -LiteralPath $probeRoot) { Remove-Item -LiteralPath $probeRoot -Recurse -Force }
    }

    $secretContracts = @(
        @{ Variant = 'appsettings'; TypeName = 'appSettingsConfigType'; Property = 'properties'; Occurrence = 0; Schema = 'properties/properties/type'; SecureType = 'secureObject'; InputPath = 'configs[2].properties.SECRET_SETTING' }
        @{ Variant = 'authsettings'; TypeName = 'authSettingsConfigType'; Property = 'clientSecret'; Occurrence = 0; Schema = 'properties/properties/properties/clientSecret/type'; SecureType = 'securestring'; InputPath = 'configs[3].properties.clientSecret' }
        @{ Variant = 'authsettings'; TypeName = 'authSettingsConfigType'; Property = 'facebookAppSecret'; Occurrence = 0; Schema = 'properties/properties/properties/facebookAppSecret/type'; SecureType = 'securestring'; InputPath = 'configs[3].properties.facebookAppSecret' }
        @{ Variant = 'authsettings'; TypeName = 'authSettingsConfigType'; Property = 'gitHubClientSecret'; Occurrence = 0; Schema = 'properties/properties/properties/gitHubClientSecret/type'; SecureType = 'securestring'; InputPath = 'configs[3].properties.gitHubClientSecret' }
        @{ Variant = 'authsettings'; TypeName = 'authSettingsConfigType'; Property = 'googleClientSecret'; Occurrence = 0; Schema = 'properties/properties/properties/googleClientSecret/type'; SecureType = 'securestring'; InputPath = 'configs[3].properties.googleClientSecret' }
        @{ Variant = 'authsettings'; TypeName = 'authSettingsConfigType'; Property = 'microsoftAccountClientSecret'; Occurrence = 0; Schema = 'properties/properties/properties/microsoftAccountClientSecret/type'; SecureType = 'securestring'; InputPath = 'configs[3].properties.microsoftAccountClientSecret' }
        @{ Variant = 'authsettings'; TypeName = 'authSettingsConfigType'; Property = 'twitterConsumerKey'; Occurrence = 0; Schema = 'properties/properties/properties/twitterConsumerKey/type'; SecureType = 'securestring'; InputPath = 'configs[3].properties.twitterConsumerKey' }
        @{ Variant = 'authsettings'; TypeName = 'authSettingsConfigType'; Property = 'twitterConsumerSecret'; Occurrence = 0; Schema = 'properties/properties/properties/twitterConsumerSecret/type'; SecureType = 'securestring'; InputPath = 'configs[3].properties.twitterConsumerSecret' }
        @{ Variant = 'authsettingsV2'; TypeName = 'authSettingsV2ConfigType'; Property = 'consumerKey'; Occurrence = 0; Schema = 'properties/properties/properties/identityProviders/properties/twitter/properties/registration/properties/consumerKey/type'; SecureType = 'securestring'; InputPath = 'configs[4].properties.identityProviders.twitter.registration.consumerKey' }
        @{ Variant = 'azurestorageaccounts'; TypeName = 'azureStorageAccountConfigType'; Property = 'accessKey'; Occurrence = 0; Schema = 'properties/properties/additionalProperties/properties/accessKey/type'; SecureType = 'securestring'; InputPath = 'configs[0].properties.alwaysOn.accessKey' }
        @{ Variant = 'backup'; TypeName = 'backupConfigType'; Property = 'connectionString'; Occurrence = 0; Schema = 'properties/properties/properties/databases/items/properties/connectionString/type'; SecureType = 'securestring'; InputPath = 'configs[5].properties.databases[0].connectionString' }
        @{ Variant = 'backup'; TypeName = 'backupConfigType'; Property = 'storageAccountUrl'; Occurrence = 0; Schema = 'properties/properties/properties/storageAccountUrl/type'; SecureType = 'securestring'; InputPath = 'configs[5].properties.storageAccountUrl' }
        @{ Variant = 'connectionstrings'; TypeName = 'connectionStringsConfigType'; Property = 'value'; Occurrence = 0; Schema = 'properties/properties/additionalProperties/properties/value/type'; SecureType = 'securestring'; InputPath = 'configs[6].properties.database.value' }
        @{ Variant = 'logs'; TypeName = 'logsConfigType'; Property = 'sasUrl'; Occurrence = 0; Schema = 'properties/properties/properties/applicationLogs/properties/azureBlobStorage/properties/sasUrl/type'; SecureType = 'securestring'; InputPath = 'configs[7].properties.applicationLogs.azureBlobStorage.sasUrl' }
        @{ Variant = 'logs'; TypeName = 'logsConfigType'; Property = 'sasUrl'; Occurrence = 1; Schema = 'properties/properties/properties/applicationLogs/properties/azureTableStorage/properties/sasUrl/type'; SecureType = 'securestring'; InputPath = 'configs[7].properties.applicationLogs.azureTableStorage.sasUrl' }
        @{ Variant = 'logs'; TypeName = 'logsConfigType'; Property = 'sasUrl'; Occurrence = 2; Schema = 'properties/properties/properties/httpLogs/properties/azureBlobStorage/properties/sasUrl/type'; SecureType = 'securestring'; InputPath = 'configs[7].properties.httpLogs.azureBlobStorage.sasUrl' }
        @{ Variant = 'metadata'; TypeName = 'metadataConfigType'; Property = 'properties'; Occurrence = 0; Schema = 'properties/properties/type'; SecureType = 'secureObject'; InputPath = 'configs[8].properties.credential' }
        @{ Variant = 'web'; TypeName = 'webConfigType'; Property = 'value'; Occurrence = 0; Schema = 'properties/properties/properties/appSettings/items/properties/value/type'; SecureType = 'securestring'; InputPath = 'configs[1].properties.appSettings[0].value' }
        @{ Variant = 'web'; TypeName = 'webConfigType'; Property = 'accessKey'; Occurrence = 0; Schema = 'properties/properties/properties/azureStorageAccounts/additionalProperties/properties/accessKey/type'; SecureType = 'securestring'; InputPath = 'configs[1].properties.azureStorageAccounts.content.accessKey' }
        @{ Variant = 'web'; TypeName = 'webConfigType'; Property = 'connectionString'; Occurrence = 0; Schema = 'properties/properties/properties/connectionStrings/items/properties/connectionString/type'; SecureType = 'securestring'; InputPath = 'configs[1].properties.connectionStrings[0].connectionString' }
        @{ Variant = 'web'; TypeName = 'webConfigType'; Property = 'value'; Occurrence = 1; Schema = 'properties/properties/properties/metadata/items/properties/value/type'; SecureType = 'securestring'; InputPath = 'configs[1].properties.metadata[0].value' }
    )
}

Describe 'Web App configuration secure boundaries' {
    BeforeAll {
        $bicep = if ($env:AVM_WEB_TEST_BICEP_PATH) { $env:AVM_WEB_TEST_BICEP_PATH } else { 'bicep' }
        $siteRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        $repoRoot = (Get-Item $siteRoot).Parent.Parent.Parent.Parent.FullName
        $fixtureRelativePath = 'tests/unit/fixtures/secure-boundaries.bicep'
        $leakRule = 'no-secure-values-in-insecure-inputs'

        function Build-Template {
            param([string] $Path)

            $outputPath = Join-Path $TestDrive "$([guid]::NewGuid()).json"
            $diagnostics = & $bicep build $Path --no-restore --outfile $outputPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable
        }

        function Get-Diagnostics {
            param([string] $Path)

            $diagnostics = & $bicep lint $Path --no-restore --diagnostics-format sarif 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            @((($diagnostics | Out-String | ConvertFrom-Json -AsHashtable).runs)[0].results)
        }

        function Copy-TestSite {
            $copyRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString())
            $null = New-Item -Path $copyRoot -ItemType Directory
            Copy-Item -LiteralPath (Join-Path $repoRoot 'bicepconfig.json') -Destination $copyRoot
            $copiedSite = Join-Path $copyRoot 'site'
            Copy-Item -LiteralPath $siteRoot -Destination $copiedSite -Recurse
            $copiedSite
        }

        function Get-VariantSchemaValue {
            param($Template, [string] $Variant, [string] $Path)

            $reference = $Template.definitions.configType.discriminator.mapping[$Variant]['$ref']
            $node = $Template.definitions[$reference.Split('/')[-1]]
            foreach ($part in $Path.Split('/')) { $node = $node[$part] }
            $node
        }

        $fixturePath = Join-Path $siteRoot $fixtureRelativePath
        $fixtureTemplate = Build-Template -Path $fixturePath
        $fixtureDiagnostics = @(Get-Diagnostics -Path $fixturePath)
        $siteDeployment = $fixtureTemplate.resources | Where-Object { $_.name -eq 'site-boundary' }
        $slotDeployment = $fixtureTemplate.resources | Where-Object { $_.name -eq 'slot-boundary' }
        $siteConfigDeployment = $fixtureTemplate.resources | Where-Object { $_.name -eq 'direct-site-config-boundary' }
        $slotConfigDeployment = $fixtureTemplate.resources | Where-Object { $_.name -eq 'direct-slot-config-boundary' }
        $parentTemplates = @(
            $siteDeployment.properties.template
            $slotDeployment.properties.template
            $siteDeployment.properties.template.resources.app_slots.properties.template
        )
        $publishedParents = @(
            Get-Content -LiteralPath (Join-Path $siteRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable
            Get-Content -LiteralPath (Join-Path $siteRoot 'slot/main.json') -Raw | ConvertFrom-Json -AsHashtable
        )
    }

    It 'Keeps both inputs secure in the published <Child> template and preserves defaults and settings shape' -ForEach @(
        @{ Child = 'config' }
        @{ Child = 'slot/config' }
    ) {
        $template = Build-Template -Path (Join-Path $siteRoot $Child 'main.bicep')
        $published = Get-Content -LiteralPath (Join-Path $siteRoot $Child 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        foreach ($parameter in @('properties', 'currentAppSettings')) {
            $template.parameters[$parameter].type | Should -BeExactly 'secureObject'
            $published.parameters[$parameter].type | Should -BeExactly 'secureObject'
            $template.parameters[$parameter].defaultValue.Count | Should -Be 0

            # Keep the ARM annotation-removal control on compilers without secure-flow rules.
            $copiedSite = Copy-TestSite
            $childPath = Join-Path $copiedSite $Child 'main.bicep'
            $source = Get-Content -LiteralPath $childPath -Raw
            $pattern = "@secure\(\)(\r?\nparam $parameter\b)"
            [regex]::Matches($source, $pattern).Count | Should -Be 1
            [regex]::Replace($source, $pattern, '$1') | Set-Content -LiteralPath $childPath
            $mutatedTemplate = Build-Template -Path $childPath
            $mutatedTemplate.parameters[$parameter].type | Should -BeExactly 'object'
        }
        $template.parameters.currentAppSettings.additionalProperties.type | Should -BeExactly 'string'
        $template.parameters.name.type | Should -BeExactly 'string'
        $template.parameters.appName.type | Should -BeExactly 'string'
        $configResource = $template.resources.Values | Where-Object { $_.type -match '/config$' }
        $configResource.properties | Should -Match "^\[union\(parameters\('currentAppSettings'\), parameters\('properties'\),"
    }

    It 'Protects configuration parameters through site, nested slot, standalone slot, and direct child calls' {
        $siteTemplate = $siteDeployment.properties.template
        $slotTemplate = $slotDeployment.properties.template
        $nestedSlotTemplate = $siteTemplate.resources.app_slots.properties.template
        $configTemplates = @(
            $siteTemplate.resources.app_config.properties.template
            $nestedSlotTemplate.resources.slot_config.properties.template
            $slotTemplate.resources.slot_config.properties.template
            $siteConfigDeployment.properties.template
            $slotConfigDeployment.properties.template
        )
        $configTemplates.Count | Should -Be 5
        foreach ($template in $configTemplates) {
            foreach ($parameter in @('properties', 'currentAppSettings')) {
                $template.parameters[$parameter].type | Should -BeExactly 'secureObject'
            }
        }
    }

    It 'Does not turn public parent config arrays or ordinary web fields into whole-secure inputs' {
        foreach ($parent in @($siteDeployment, $slotDeployment)) {
            $parent.properties.template.parameters.configs.type | Should -BeExactly 'array'
            $parent.properties.parameters.configs.value | Should -BeExactly "[variables('secretConfigs')]"
        }
        $fixtureTemplate.variables.secretConfigs[0].properties.alwaysOn.accessKey | Should -BeExactly "[parameters('storageAccessKey')]"
        $fixtureTemplate.variables.secretConfigs[1].properties.alwaysOn | Should -BeTrue
        $siteDeployment.properties.template.parameters.slots.type | Should -BeExactly 'array'
        foreach ($template in $parentTemplates) {
            Get-VariantSchemaValue $template 'web' 'properties/properties/type' | Should -BeExactly 'object'
            Get-VariantSchemaValue $template 'web' 'properties/properties/properties/alwaysOn/type' | Should -BeExactly 'bool'
            Get-VariantSchemaValue $template 'authsettings' 'properties/properties/properties/clientSecretSettingName/type' | Should -BeExactly 'string'
        }
        foreach ($parent in @('main.bicep', 'slot/main.bicep')) {
            $source = Get-Content -LiteralPath (Join-Path $siteRoot $parent) -Raw
            [regex]::Matches($source, '#disable-next-line use-secure-value-for-secure-inputs').Count | Should -Be 1
            $source | Should -Match '#disable-next-line use-secure-value-for-secure-inputs\r?\n\s+properties: config\.\?properties'
            $source | Should -Not -Match '#disable-next-line[^\r\n]*no-secure-values-in-insecure-inputs'
        }
    }

    if ($hasLeakRule) {
    It 'Has no secure-to-insecure input diagnostics across the exercised module boundaries' {
        @($fixtureDiagnostics | Where-Object { $_.ruleId -eq $leakRule }).Count | Should -Be 0
    }
    }

    It 'Keeps storage fixture output <OutputName> secure and detects removal of its annotation' -ForEach @(
        @{ OutputName = 'primaryStorageAccountKey' }
        @{ OutputName = 'secondaryStorageAccountKey' }
    ) {
        $relativePath = 'tests/e2e/webApp.azurestorageaccounts/dependencies.bicep'
        $template = Build-Template -Path (Join-Path $siteRoot $relativePath)
        $template.outputs[$OutputName].type | Should -BeExactly 'securestring'

        $copiedSite = Copy-TestSite
        $path = Join-Path $copiedSite $relativePath
        $source = Get-Content -LiteralPath $path -Raw
        $pattern = "@secure\(\)(\r?\noutput $OutputName\b)"
        [regex]::Matches($source, $pattern).Count | Should -Be 1
        [regex]::Replace($source, $pattern, '$1') | Set-Content -LiteralPath $path
        $diagnostics = @(Get-Diagnostics -Path $path)
        $leaks = @($diagnostics | Where-Object {
            $_.ruleId -eq 'outputs-should-not-contain-secrets'
        })
        $leaks.Count | Should -Be 1
        $line = $leaks[0].locations[0].physicalLocation.region.startLine
        (Get-Content -LiteralPath $path)[$line - 1] | Should -Match "^output $OutputName "
    }

    if ($hasReverseRule) {
    It 'Keeps the reverse-flow exceptions confined to the two mixed properties forwarding sites' {
        $reverseWarnings = @($fixtureDiagnostics | Where-Object { $_.ruleId -eq 'use-secure-value-for-secure-inputs' })
        $reverseWarnings.Count | Should -Be 3
        foreach ($warning in $reverseWarnings) {
            $warning.message.text | Should -Match '\.properties\.PUBLIC_SETTING'
            $warning.locations[0].physicalLocation.artifactLocation.uri | Should -Match '/secure-boundaries\.bicep$'
        }
    }
    }

    if ($hasLeakRule) {
    It 'Still rejects a secure value sent to an intentionally ordinary parent field' {
        $copiedSite = Copy-TestSite
        $path = Join-Path $copiedSite $fixtureRelativePath
        $source = Get-Content -LiteralPath $path -Raw
        $source.Replace("clientSecretSettingName: 'SECRET_SETTING'", 'clientSecretSettingName: storageAccessKey') |
            Set-Content -LiteralPath $path
        $diagnostics = @(Get-Diagnostics -Path $path)
        $leaks = @($diagnostics | Where-Object {
            $_.ruleId -eq $leakRule -and
            $_.message.text -match '\.properties\.clientSecretSettingName' -and
            $_.locations[0].physicalLocation.artifactLocation.uri.EndsWith('/secure-boundaries.bicep')
        })
        $leaks.Count | Should -BeGreaterThan 2
    }
    }

    It 'Protects <InputPath> in every public parent and published schema' -ForEach $secretContracts {
        foreach ($template in ($parentTemplates + $publishedParents)) {
            Get-VariantSchemaValue $template $Variant $Schema | Should -BeExactly $SecureType
        }
    }

    if ($hasLeakRule) {
    It 'Detects a missing parent credential annotation at <InputPath> despite the forwarding exceptions' -ForEach $secretContracts {
        $copiedSite = Copy-TestSite
        $path = Join-Path $copiedSite 'slot/main.bicep'
        $source = Get-Content -LiteralPath $path -Raw
        $typeStart = $source.IndexOf("type $TypeName = {")
        $typeStart | Should -BeGreaterThan 0
        $typeEnd = $source.IndexOf("`n@export()", $typeStart)
        $section = $source.Substring($typeStart, $typeEnd - $typeStart)
        $matches = [regex]::Matches($section, "@secure\(\)(?=\r?\n\s+$Property`:)")
        $matches.Count | Should -BeGreaterThan $Occurrence
        $source.Remove($typeStart + $matches[$Occurrence].Index, '@secure()'.Length) | Set-Content -LiteralPath $path

        $diagnostics = @(Get-Diagnostics -Path (Join-Path $copiedSite $fixtureRelativePath))
        $inputPattern = "Module parameter '(?:slots\[0\]\.)?$([regex]::Escape($InputPath))' is not secure"
        $leaks = @($diagnostics | Where-Object {
            $_.ruleId -eq $leakRule -and $_.message.text -match $inputPattern -and
            $_.locations[0].physicalLocation.artifactLocation.uri.EndsWith('/secure-boundaries.bicep')
        })
        $leaks.Count | Should -BeGreaterThan 2
    }

    It 'Shows why secure string leaves alone cannot accept a whole secure app settings dictionary' {
        $copiedSite = Copy-TestSite
        $path = Join-Path $copiedSite 'slot/main.bicep'
        $source = Get-Content -LiteralPath $path -Raw
        $typeStart = $source.IndexOf('type appSettingsConfigType = {')
        $typeEnd = $source.IndexOf("`n@export()", $typeStart)
        $section = $source.Substring($typeStart, $typeEnd - $typeStart)
        $section = $section.Replace("@secure()`n  properties:", 'properties:').
        Replace('*: string', "@secure()`n    *: string")
        $source.Remove($typeStart, $typeEnd - $typeStart).Insert($typeStart, $section) | Set-Content -LiteralPath $path

        $diagnostics = @(Get-Diagnostics -Path (Join-Path $copiedSite $fixtureRelativePath))
        $wholeDictionaryLeaks = @($diagnostics | Where-Object {
            $_.ruleId -eq $leakRule -and
            $_.message.text -match "Module parameter 'configs\[0\]\.properties' is not secure" -and
            $_.locations[0].physicalLocation.artifactLocation.uri.EndsWith('/secure-boundaries.bicep')
        })
        $wholeDictionaryLeaks.Count | Should -Be 1
    }
    }

    if ($hasLeakRule -and $hasReverseRule) {
    It 'Restores only reverse-flow diagnostics when removing the exception in <Parent>' -ForEach @(
        @{ Parent = 'main.bicep' }
        @{ Parent = 'slot/main.bicep' }
    ) {
        $copiedSite = Copy-TestSite
        $path = Join-Path $copiedSite $Parent
        (Get-Content -LiteralPath $path -Raw).Replace('#disable-next-line use-secure-value-for-secure-inputs', '') |
            Set-Content -LiteralPath $path
        $diagnostics = @(Get-Diagnostics -Path (Join-Path $copiedSite $fixtureRelativePath))
        @($diagnostics | Where-Object { $_.ruleId -eq $leakRule }).Count | Should -Be 0
        $forwardingWarnings = @($diagnostics | Where-Object {
            $_.ruleId -eq 'use-secure-value-for-secure-inputs' -and
            $_.locations[0].physicalLocation.artifactLocation.uri.EndsWith("/site/$Parent")
        })
        $forwardingWarnings.Count | Should -BeGreaterThan 0
    }
    }

    if ($hasLeakRule) {
    It 'Detects removing security from <Child> <Parameter> (negative control)' -ForEach @(
        @{ Child = 'config'; Parameter = 'properties' }
        @{ Child = 'config'; Parameter = 'currentAppSettings' }
        @{ Child = 'slot/config'; Parameter = 'properties' }
        @{ Child = 'slot/config'; Parameter = 'currentAppSettings' }
    ) {
        $copiedSite = Copy-TestSite
        $childPath = Join-Path $copiedSite $Child 'main.bicep'
        $source = Get-Content -LiteralPath $childPath -Raw
        $pattern = "@secure\(\)(\r?\nparam $Parameter\b)"
        [regex]::Matches($source, $pattern).Count | Should -Be 1
        [regex]::Replace($source, $pattern, '$1') | Set-Content -LiteralPath $childPath

        $diagnostics = @(Get-Diagnostics -Path (Join-Path $copiedSite $fixtureRelativePath))
        $directLeaks = @($diagnostics | Where-Object {
            $_.ruleId -eq $leakRule -and
            $_.message.text -match "Module parameter '$Parameter' is not secure" -and
            $_.locations[0].physicalLocation.artifactLocation.uri.EndsWith('/secure-boundaries.bicep')
        })
        $directLeaks.Count | Should -BeGreaterThan 0

        $parentSuffix = if ($Child -eq 'config') { '/site/main.bicep' } else { '/site/slot/main.bicep' }
        $parentLeaks = @($diagnostics | Where-Object {
            $_.ruleId -eq $leakRule -and
            $_.message.text -match "Module parameter '$Parameter[.']" -and
            $_.locations[0].physicalLocation.artifactLocation.uri.EndsWith($parentSuffix)
        })
        $parentLeaks.Count | Should -BeGreaterThan 0
    }
    }
}
