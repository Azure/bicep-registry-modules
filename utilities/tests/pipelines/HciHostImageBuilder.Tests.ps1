param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'HCI host image builder templates' {
    BeforeAll {
        $builderRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci'
        $templates = @{}
        foreach ($file in @('hciHostGalleryBuilder.bicep', 'hciHostGalleryBuilder.template.bicep')) {
            $compiledPath = Join-Path $TestDrive "$file.json"
            $diagnostics = bicep build (Join-Path $builderRoot $file) --no-restore --outfile $compiledPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $templates[$file] = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        }
        $builder = $templates['hciHostGalleryBuilder.bicep']
        $child = $templates['hciHostGalleryBuilder.template.bicep']
        $imageTemplate = $child.resources.imageTemplate

        $childText = Get-Content -LiteralPath (Join-Path $builderRoot 'hciHostGalleryBuilder.template.bicep') -Raw
        $match = [regex]::Match($childText, '(?ms)^var requiredReplicationRegions = (?<expression>.*?)(?=\r?\n\r?\n)')
        if (-not $match.Success) { throw 'Missing requiredReplicationRegions expression.' }
        $scenarios = @(
            @{ name = 'defaults'; location = "'southeastasia'"; buildLocation = "'southeastasia'"; regions = "['southeastasia']" }
            @{ name = 'independentBuild'; location = "'southeastasia'"; buildLocation = "'australiaeast'"; regions = "['southeastasia']" }
            @{ name = 'explicitRegions'; location = "'southeastasia'"; buildLocation = "'australiaeast'"; regions = "['eastus', 'westeurope']" }
            @{ name = 'buildOnly'; location = "'southeastasia'"; buildLocation = "'australiaeast'"; regions = "['australiaeast']" }
            @{ name = 'duplicates'; location = "'Southeast Asia'"; buildLocation = "'Australia East'"; regions = "['AUSTRALIAEAST', 'australiaeast', 'SOUTHEASTASIA']" }
        )
        $parameters = @('using none')
        $payloadMatch = [regex]::Match($childText, '(?ms)^var payloadDownload = (?<expression>.*?)(?=\r?\n\r?\n)')
        if (-not $payloadMatch.Success) { throw 'Missing payloadDownload expression.' }
        $payloadFixture = Join-Path $TestDrive 'expected.vhdx'
        [IO.File]::WriteAllText($payloadFixture, 'offline verified payload')
        $payloadHash = (Get-FileHash -LiteralPath $payloadFixture -Algorithm SHA256).Hash
        $script:encodedPayloadHash = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($payloadHash))
        $parameters += @(
            "var encodedPayloadUri = base64('https://example.test/AzLocal2601.vhdx')"
            "var encodedPayloadSha256 = base64('$payloadHash')"
            "param payloadDownload = $($payloadMatch.Groups['expression'].Value)"
        )
        foreach ($scenario in $scenarios) {
            $expression = $match.Groups['expression'].Value.
                Replace('buildLocation', $scenario.buildLocation).
                Replace('replicationRegions', $scenario.regions).
                Replace('location', $scenario.location)
            $parameters += "param $($scenario.name) = $expression"
        }
        $parameterPath = Join-Path $TestDrive 'regions.bicepparam'
        $parameterOutput = Join-Path $TestDrive 'regions.json'
        $parameters -join "`n" | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --no-restore --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $regions = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
        $script:payloadScript = $regions.payloadDownload.value -join "`n"
    }

    It 'Preserves the stable external defaults in the subscription template' {
        $builder.parameters.location.defaultValue | Should -Be 'southeastasia'
        $builder.parameters.resourceGroupName.defaultValue | Should -Be 'rg-avm-persistent-hci-image'
        $builder.parameters.galleryName.defaultValue | Should -Be 'galavmpersistenthci'
        $builder.parameters.imageDefinitionName.defaultValue | Should -Be 'hci-host-image'
        $builder.parameters.imageVersion.defaultValue | Should -Be '26.1.0'
        $builder.parameters.imageTemplateName.defaultValue | Should -Be 'hci-host-image-builder'
        $builder.parameters.imageBuilderIdentityName.defaultValue | Should -Be 'id-avm-persistent-hci-image-builder'
        $builder.parameters.buildTimeoutInMinutes.defaultValue | Should -Be 570
        $expectedPayloadDefaults = @{
            hciVhdxDownloadUri = 'https://jumpstartprodsg.blob.core.windows.net/jslocal/localbox/prod/AzLocal2601.vhdx'
            hciVhdxSha256      = '3a797826d7e7ae7abc55d1071322ddecc80575c2356fea9e74818ab9f6720a1f'
        }
        foreach ($entry in $expectedPayloadDefaults.GetEnumerator()) {
            $variable = [regex]::Match($builder.parameters[$entry.Key].defaultValue, "^\[variables\('([^']+)'\)\]$")
            $variable.Success | Should -BeTrue
            $builder.variables[$variable.Groups[1].Value] | Should -BeExactly $entry.Value
        }
    }

    It 'Requires a digest in the customizer and forwards both payload parameters' {
        foreach ($template in @($builder, $child)) {
            $template.parameters.hciVhdxSha256.minLength | Should -Be 64
            $template.parameters.hciVhdxSha256.maxLength | Should -Be 64
        }
        $child.parameters.hciVhdxSha256.ContainsKey('defaultValue') | Should -BeFalse
        $builder.resources.imageTemplate.properties.parameters.hciVhdxDownloadUri.value |
            Should -Be "[parameters('hciVhdxDownloadUri')]"
        $builder.resources.imageTemplate.properties.parameters.hciVhdxSha256.value |
            Should -Be "[parameters('hciVhdxSha256')]"
        $child.variables.encodedPayloadUri | Should -Be "[base64(parameters('hciVhdxDownloadUri'))]"
        $child.variables.encodedPayloadSha256 | Should -Be "[base64(parameters('hciVhdxSha256'))]"
        $imageTemplate.properties.customize[2].inline | Should -Be "[variables('payloadDownload')]"
    }

    It 'Defaults both entrypoints to the existing single resource region' {
        foreach ($template in @($builder, $child)) {
            $template.parameters.buildLocation.defaultValue | Should -Be "[parameters('location')]"
            $template.parameters.replicationRegions.defaultValue.Count | Should -Be 1
            $template.parameters.replicationRegions.defaultValue[0] | Should -Be "[parameters('location')]"
            $template.parameters.replicationRegions.items.type | Should -Be 'string'
            $template.parameters.replicationRegions.minLength | Should -Be 1
        }
        $regions.defaults.value.Count | Should -Be 1
        $regions.defaults.value[0] | Should -Be 'southeastasia'
    }

    It 'Keeps resource locations independent of the image template and build VM location' {
        $builder.resources.imageResourceGroup.location | Should -Be "[parameters('location')]"
        $assets = $builder.resources.imageAssets
        $assets.properties.parameters.location.value | Should -Be "[parameters('location')]"
        $assetResources = $assets.properties.template.resources
        @($assetResources.type | Sort-Object) -join ',' |
            Should -Be 'Microsoft.Compute/galleries,Microsoft.Compute/galleries/images,Microsoft.ManagedIdentity/userAssignedIdentities'
        foreach ($asset in $assetResources) {
            $asset.location | Should -Be "[parameters('location')]"
        }
        $parameters = $builder.resources.imageTemplate.properties.parameters
        $parameters.location.value | Should -Be "[parameters('location')]"
        $parameters.buildLocation.value | Should -Be "[parameters('buildLocation')]"
        $parameters.replicationRegions.value | Should -Be "[parameters('replicationRegions')]"
        $imageTemplate.location | Should -Be "[parameters('buildLocation')]"
        $imageTemplate.name | Should -Be "[parameters('imageTemplateName')]"
        $imageTemplate.properties.vmProfile.vmSize | Should -Be "[parameters('buildVmSize')]"
        $regions.independentBuild.value -join ',' | Should -Be 'southeastasia,australiaeast'
    }

    It 'Includes the image-version source and build region even with explicit distribution regions' {
        $regions.explicitRegions.value -join ',' | Should -Be 'southeastasia,australiaeast,eastus,westeurope'
        $regions.buildOnly.value -join ',' | Should -Be 'southeastasia,australiaeast'
        $regions.duplicates.value -join ',' | Should -Be 'southeastasia,australiaeast'
    }

    It 'Uses supported targetRegions with one Standard_LRS replica per required region' {
        $distributor = $imageTemplate.properties.distribute[0]
        $distributor.type | Should -Be 'SharedImage'
        $distributor.ContainsKey('replicationRegions') | Should -BeFalse
        $distributor.ContainsKey('storageAccountType') | Should -BeFalse
        $distributor.copy.Count | Should -Be 1
        $distributor.copy[0].name | Should -Be 'targetRegions'
        $distributor.copy[0].count | Should -Be "[length(variables('requiredReplicationRegions'))]"
        $distributor.copy[0].input.name | Should -Be "[variables('requiredReplicationRegions')[copyIndex('targetRegions')]]"
        $distributor.copy[0].input.replicaCount | Should -Be 1
        $distributor.copy[0].input.storageAccountType | Should -Be 'Standard_LRS'
        $distributor.excludeFromLatest | Should -BeFalse
        $distributor.galleryImageId | Should -Be "[format('{0}/versions/{1}', parameters('galleryImageDefinitionResourceId'), parameters('imageVersion'))]"
    }

    It 'Preserves the compiled output contracts without duplicating the builder' {
        @($builder.outputs.Keys | Sort-Object) -join ',' | Should -Be 'galleryResourceId,imageBuilderIdentityResourceId,imageDefinitionResourceId,imageTemplateName,imageTemplateResourceId,imageVersionResourceId,resourceGroupName'
        @($child.outputs.Keys | Sort-Object) -join ',' | Should -Be 'imageTemplateName,imageTemplateResourceId'
        $builder.resources.imageTemplate.properties.template.resources.imageTemplate | ConvertTo-Json -Depth 30 |
            Should -Be ($imageTemplate | ConvertTo-Json -Depth 30)
        $child.resources.Count | Should -Be 1
    }

    Context 'VHDX payload integrity' {
        BeforeEach {
            $script:downloadAttempts = 0
            $script:downloadPath = Join-Path $TestDrive "$([guid]::NewGuid()).vhdx"
            $script:downloadScript = [scriptblock]::Create($script:payloadScript.Replace('C:\ISOs\hci_os.vhdx', $script:downloadPath))
            Mock Invoke-WebRequest {
                $Uri | Should -BeExactly 'https://example.test/AzLocal2601.vhdx'
                $OutFile | Should -Be $script:downloadPath
                [IO.File]::WriteAllText($OutFile, 'offline verified payload')
            }
            Mock Start-Sleep {}
        }

        It 'Hashes the downloaded bytes and accepts a matching <casing> digest' -ForEach @(
            @{ casing = 'uppercase' }
            @{ casing = 'lowercase' }
        ) {
            $expected = $casing -eq 'lowercase' ? $payloadHash.ToLowerInvariant() : $payloadHash
            $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($expected))
            $downloadScript = [scriptblock]::Create($script:downloadScript.ToString().Replace($script:encodedPayloadHash, $encoded))

            . $downloadScript

            Should -Invoke Invoke-WebRequest -Times 1 -Exactly
            $actualSha256 | Should -Be $payloadHash
        }

        It 'Rejects a <case> payload without retrying a successful HTTP download' -ForEach @(
            @{ case = 'corrupt'; content = 'offline tampered payload' }
            @{ case = 'partial'; content = 'offline verified' }
            @{ case = 'empty'; content = '' }
        ) {
            $script:downloadContent = $content
            Mock Invoke-WebRequest { [IO.File]::WriteAllText($OutFile, $script:downloadContent) }

            { . $script:downloadScript } | Should -Throw '*HCI VHDX payload SHA256 mismatch*'

            Should -Invoke Invoke-WebRequest -Times 1 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Rejects a missing downloaded file before hashing' {
            Mock Invoke-WebRequest {}
            Mock Get-FileHash { throw 'Unexpected hash attempt' }

            { . $script:downloadScript } | Should -Throw '*HCI VHDX payload was not downloaded*'

            Should -Invoke Get-FileHash -Times 0 -Exactly
        }

        It 'Preserves the final download error and never accepts a partial file' {
            Mock Invoke-WebRequest {
                [IO.File]::WriteAllText($OutFile, 'partial')
                throw 'Offline download failure'
            }
            Mock Get-FileHash { throw 'Unexpected hash attempt' }

            { . $script:downloadScript } | Should -Throw '*Offline download failure*'

            Should -Invoke Invoke-WebRequest -Times 5 -Exactly
            Should -Invoke Start-Sleep -Times 4 -Exactly
            Should -Invoke Get-FileHash -Times 0 -Exactly
        }

        It 'Verifies only the completed download after transient failures' {
            Mock Invoke-WebRequest {
                $script:downloadAttempts++
                if ($script:downloadAttempts -lt 3) {
                    [IO.File]::WriteAllText($OutFile, 'partial')
                    throw 'Offline transient failure'
                }
                [IO.File]::WriteAllText($OutFile, 'offline verified payload')
            }

            . $script:downloadScript

            Should -Invoke Invoke-WebRequest -Times 3 -Exactly
            Should -Invoke Start-Sleep -Times 2 -Exactly
            $actualSha256 | Should -Be $payloadHash
        }

        It 'Rejects a <case> digest before downloading or hashing' -ForEach @(
            @{ case = 'missing'; digest = '' }
            @{ case = 'short'; digest = 'a' * 63 }
            @{ case = 'long'; digest = 'a' * 65 }
            @{ case = 'nonhexadecimal'; digest = 'g' * 64 }
            @{ case = 'trailing newline'; digest = ('a' * 64) + "`n" }
            @{ case = 'script-like'; digest = "';throw 'not data';#" }
        ) {
            $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($digest))
            $downloadScript = [scriptblock]::Create($script:downloadScript.ToString().Replace($script:encodedPayloadHash, $encoded))
            Mock Get-FileHash { throw 'Unexpected hash attempt' }

            { . $downloadScript } | Should -Throw '*A valid HCI VHDX SHA256 digest is required*'

            Should -Invoke Invoke-WebRequest -Times 0 -Exactly
            Should -Invoke Get-FileHash -Times 0 -Exactly
        }

        It 'Propagates a hashing failure rather than accepting the file' {
            Mock Get-FileHash { throw 'Offline hashing failure' }

            { . $script:downloadScript } | Should -Throw '*Offline hashing failure*'

            Should -Invoke Invoke-WebRequest -Times 1 -Exactly
            Should -Invoke Get-FileHash -Times 1 -Exactly
        }
    }
}

Describe 'HCI host image builder' {
    BeforeAll {
        $builderRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci'
        $buildScript = Join-Path $builderRoot 'Invoke-HciHostImageBuild.ps1'
        . (Join-Path $builderRoot 'HciImageOperation.ps1')

        function Get-AzContext {
            [pscustomobject] @{ Subscription = [pscustomobject] @{ Id = 'subscription-id' } }
        }

        function Set-AzContext {
            param ([string] $SubscriptionId)
        }

        function Invoke-AzRestMethod {
            param ([string] $Method, [string] $Path)
            throw 'Invoke-AzRestMethod must be mocked.'
        }

        function New-AzSubscriptionDeployment {
            param (
                [string] $Name,
                [string] $Location,
                [string] $TemplateFile,
                [hashtable] $TemplateParameterObject
            )
            throw 'New-AzSubscriptionDeployment must be mocked.'
        }

        function New-TestArmResponse {
            param ([hashtable] $Resource = @{}, [int] $StatusCode = 200)
            [pscustomobject] @{
                StatusCode = $StatusCode
                Content    = $Resource | ConvertTo-Json -Depth 10
            }
        }

        function Set-TestRegions {
            param ([string[]] $Regions)
            $script:versionResource.properties.publishingProfile.targetRegions = @(
                $Regions | ForEach-Object { @{ name = $_ } }
            )
            $script:versionResource.properties.replicationStatus.summary = @(
                $Regions | ForEach-Object { @{ region = $_; state = 'Completed'; progress = 100 } }
            )
        }

        function Assert-TestResult {
            param ([object] $Result, [string] $Status, [bool] $Started, [string] $TemplateName = 'hci-host-image-builder')
            @($Result).Count | Should -Be 1
            @($Result.PSObject.Properties.Name | Sort-Object) -join ',' |
                Should -Be 'BuildStarted,BuildStatus,ImageTemplateResourceId,ImageVersionResourceId,ResourceGroupName'
            $Result.BuildStatus | Should -Be $Status
            $Result.BuildStarted | Should -BeOfType [bool]
            $Result.BuildStarted | Should -Be $Started
            $Result.ResourceGroupName | Should -Be 'rg-avm-persistent-hci-image'
            $Result.ImageVersionResourceId | Should -Be '/subscriptions/subscription-id/resourceGroups/rg-avm-persistent-hci-image/providers/Microsoft.Compute/galleries/galavmpersistenthci/images/hci-host-image/versions/26.1.0'
            $Result.ImageTemplateResourceId | Should -Be "/subscriptions/subscription-id/resourceGroups/rg-avm-persistent-hci-image/providers/Microsoft.VirtualMachineImages/imageTemplates/$TemplateName"
        }
    }

    BeforeEach {
        $script:now = [datetimeoffset] '2026-10-08T12:00:00Z'
        $script:versionResource = @{
            location   = 'southeastasia'
            properties = @{
                provisioningState = 'Succeeded'
                publishingProfile = @{ excludeFromLatest = $false }
                replicationStatus = @{ aggregatedState = 'Completed' }
            }
        }
        Set-TestRegions @('southeastasia')
        $script:templateResource = @{
            location   = 'southeastasia'
            properties = @{
                lastRunStatus = @{
                    startTime = $script:now.ToString('o')
                    runState  = 'Succeeded'
                    message   = ''
                }
            }
        }
        Mock Set-AzContext {}
        Mock Get-Date { $script:now }
        Mock Start-Sleep { $script:now = $script:now.AddSeconds(15) }
        Mock New-AzSubscriptionDeployment {
            [pscustomobject] @{ ProvisioningState = 'Succeeded' }
        }
        Mock Invoke-HciImageOperationRequest {
            $uriValue = [uri] [pscredential]::new('operation', $Uri).GetNetworkCredential().Password
            $response = Invoke-AzRestMethod -Method $Method -Path $uriValue.PathAndQuery
            @{ StatusCode = $response.StatusCode; RetryAfterSeconds = 15 }
        }
    }

    Context 'Existing versions' {
        BeforeEach {
            Mock Invoke-AzRestMethod {
                if ($Method -ne 'GET' -or $Path -notlike '*/versions/*') {
                    throw 'An existing version must not deploy or run an image template.'
                }
                New-TestArmResponse -Resource $script:versionResource
            }
        }

        It 'Skips deployment and build when the deterministic version and replica already succeeded' {
            $result = . $buildScript -AssetBaseUri 'https://example.test/assets'

            Assert-TestResult -Result $result -Status 'Skipped' -Started $false
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
                $Method -eq 'GET' -and $Path -like '*&$expand=ReplicationStatus'
            }
        }

        It 'Skips only when every source, build, and requested region is complete, ignoring case and spaces' {
            Set-TestRegions @('Southeast Asia', 'Australia East', 'East US')

            $result = . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation AUSTRALIAEAST -ReplicationRegions @('eastus', 'East US')

            Assert-TestResult -Result $result -Status 'Skipped' -Started $false
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        }

        It 'Reports an unavailable replica without optional details under StrictMode Latest without rebuilding' {
            Set-TestRegions @('southeastasia', 'australiaeast')
            $script:versionResource.properties.replicationStatus.aggregatedState = 'InProgress'
            $script:versionResource.properties.replicationStatus.summary[1].state = 'InProgress'
            $script:versionResource.properties.replicationStatus.summary[1].progress = 50

            $failure = {
                & {
                    Set-StrictMode -Version Latest
                    . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation australiaeast -ReplicationRegions @('southeastasia', 'australiaeast')
                }
            } | Should -Throw '*already exists but is unavailable*No deployment or build was started*Wait for or repair replication before retrying*' -PassThru

            $failure.Exception | Should -Not -BeOfType [System.Management.Automation.PropertyNotFoundException]
            $failure.Exception.Message | Should -Match 'Region \[australiaeast\] replication state \[InProgress\]\.'
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'POST' }
        }

        It 'Never rebuilds an existing version with <problem>' -ForEach @(
            @{ problem = 'a missing target'; change = 'target'; expectedError = '*eastus*publishingProfile.targetRegions*' }
            @{ problem = 'a missing source replica'; change = 'source'; expectedError = '*southeastasia*replication status*' }
            @{ problem = 'a missing build replica'; change = 'build'; expectedError = '*australiaeast*replication status*' }
            @{ problem = 'missing replication status'; change = 'summary'; expectedError = '*replication status*' }
            @{ problem = 'an in-progress replica'; change = 'Replicating'; expectedError = '*eastus*Replicating*' }
            @{ problem = 'a failed replica'; change = 'Failed'; expectedError = '*eastus*Failed*capacity unavailable*' }
            @{ problem = 'an unknown replica'; change = 'Unknown'; expectedError = '*eastus*Unknown*' }
            @{ problem = 'duplicate replica entries'; change = 'duplicate'; expectedError = '*eastus*unambiguous*' }
            @{ problem = 'failed provisioning'; change = 'provisioning'; expectedError = '*Provisioning state*Failed*' }
            @{ problem = 'pending provisioning'; change = 'pending'; expectedError = '*Provisioning state*Creating*' }
            @{ problem = 'exclusion from latest'; change = 'excluded'; expectedError = '*excluded from latest*' }
        ) {
            Set-TestRegions @('southeastasia', 'australiaeast', 'eastus')
            $properties = $script:versionResource.properties
            switch ($change) {
                'target' { $properties.publishingProfile.targetRegions = $properties.publishingProfile.targetRegions[0..1] }
                'source' { $properties.replicationStatus.summary = $properties.replicationStatus.summary[1..2] }
                'build' { $properties.replicationStatus.summary = $properties.replicationStatus.summary[0, 2] }
                'summary' { $properties.Remove('replicationStatus') }
                'duplicate' { $properties.replicationStatus.summary += $properties.replicationStatus.summary[2] }
                'provisioning' { $properties.provisioningState = 'Failed' }
                'pending' { $properties.provisioningState = 'Creating' }
                'excluded' { $properties.publishingProfile.excludeFromLatest = $true }
                default {
                    $properties.replicationStatus.summary[2].state = $change
                    $properties.replicationStatus.summary[2].details = 'capacity unavailable'
                }
            }

            { . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation australiaeast -ReplicationRegions eastus } |
                Should -Throw "$expectedError*No deployment or build was started*"

            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'POST' }
        }
    }

    Context 'New and resumed builds' {
        BeforeEach {
            $script:resume = $false
            $script:templateGetCount = 0
            $script:versionGetCount = 0
            Mock Invoke-AzRestMethod {
                if ($Method -eq 'POST') {
                    return New-TestArmResponse -StatusCode 202
                }
                if ($Path -like '*/versions/*') {
                    $script:versionGetCount++
                    if ($script:versionGetCount -eq 1) { return New-TestArmResponse -StatusCode 404 }
                    return New-TestArmResponse -Resource $script:versionResource
                }
                $script:templateGetCount++
                if (-not $script:resume -and $script:templateGetCount -eq 1) {
                    return New-TestArmResponse -StatusCode 404
                }
                if (-not $script:resume -and $script:templateGetCount -eq 2) {
                    return New-TestArmResponse -Resource @{
                        location   = $script:templateResource.location
                        properties = @{ lastRunStatus = @{ startTime = $script:now.AddHours(-1).ToString('o'); runState = 'Succeeded' } }
                    }
                }
                $resource = $script:templateResource
                if ($script:templateGetCount -lt 3) {
                    $resource = @{
                        location   = $resource.location
                        properties = @{ lastRunStatus = @{ startTime = $resource.properties.lastRunStatus.startTime; runState = 'Pending' } }
                    }
                }
                New-TestArmResponse -Resource $resource
            }
        }

        It 'Deploys, starts, and verifies a newly published version with unchanged defaults' {
            $result = . $buildScript -AssetBaseUri 'https://example.test/assets'

            Assert-TestResult -Result $result -Status 'Succeeded' -Started $true
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter {
                $Location -eq 'southeastasia' -and
                $TemplateParameterObject.location -eq 'southeastasia' -and
                $TemplateParameterObject.buildLocation -eq 'southeastasia' -and
                $TemplateParameterObject.replicationRegions.Count -eq 1 -and
                $TemplateParameterObject.replicationRegions[0] -eq 'southeastasia' -and
                $TemplateParameterObject.resourceGroupName -eq 'rg-avm-persistent-hci-image' -and
                $TemplateParameterObject.galleryName -eq 'galavmpersistenthci' -and
                $TemplateParameterObject.imageDefinitionName -eq 'hci-host-image' -and
                $TemplateParameterObject.imageVersion -eq '26.1.0' -and
                $TemplateParameterObject.hciVhdxDownloadUri -ceq 'https://jumpstartprodsg.blob.core.windows.net/jslocal/localbox/prod/AzLocal2601.vhdx' -and
                $TemplateParameterObject.hciVhdxSha256 -ceq '3a797826d7e7ae7abc55d1071322ddecc80575c2356fea9e74818ab9f6720a1f' -and
                $TemplateParameterObject.buildTimeoutInMinutes -eq 570
            }
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly -ParameterFilter {
                $Path -like '*/versions/*&$expand=ReplicationStatus'
            }
        }

        It 'Threads explicit regions and a new template name without moving existing assets' {
            Set-TestRegions @('southeastasia', 'australiaeast', 'eastus')
            $script:templateResource.location = 'australiaeast'
            $result = . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation australiaeast -ReplicationRegions @('australiaeast', 'eastus') -ImageTemplateName hci-host-image-builder-australiaeast -CreateResourceGroup $false

            Assert-TestResult -Result $result -Status 'Succeeded' -Started $true -TemplateName 'hci-host-image-builder-australiaeast'
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter {
                $Location -eq 'southeastasia' -and
                $TemplateParameterObject.location -eq 'southeastasia' -and
                $TemplateParameterObject.buildLocation -eq 'australiaeast' -and
                ($TemplateParameterObject.replicationRegions -join ',') -eq 'australiaeast,eastus' -and
                $TemplateParameterObject.imageTemplateName -eq 'hci-host-image-builder-australiaeast' -and
                $TemplateParameterObject.createResourceGroup -eq $false
            }
        }

        It 'Forwards an explicitly paired payload URI and digest unchanged' {
            $digest = 'A' * 64
            $result = . $buildScript -AssetBaseUri 'https://example.test/assets' `
                -HciVhdxDownloadUri 'https://example.test/custom.vhdx' -HciVhdxSha256 $digest

            Assert-TestResult -Result $result -Status 'Succeeded' -Started $true
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter {
                $TemplateParameterObject.hciVhdxDownloadUri -ceq 'https://example.test/custom.vhdx' -and
                $TemplateParameterObject.hciVhdxSha256 -ceq ('A' * 64)
            }
        }

        It 'Derives omitted region inputs from an explicitly selected resource location' {
            Set-TestRegions @('eastus')
            $script:templateResource.location = 'eastus'
            $result = . $buildScript -AssetBaseUri 'https://example.test/assets' -Location eastus

            Assert-TestResult -Result $result -Status 'Succeeded' -Started $true
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter {
                $Location -eq 'eastus' -and
                $TemplateParameterObject.buildLocation -eq 'eastus' -and
                ($TemplateParameterObject.replicationRegions -join ',') -eq 'eastus'
            }
        }

        It 'Resumes an active image build without deploying or submitting another run' {
            $script:resume = $true
            Set-TestRegions @('southeastasia', 'australiaeast', 'eastus')
            $script:templateResource.location = 'Australia East'

            $result = . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation australiaeast -ReplicationRegions eastus

            Assert-TestResult -Result $result -Status 'Succeeded' -Started $false
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'POST' }
            Should -Invoke Invoke-AzRestMethod -Times 2 -Exactly -ParameterFilter {
                $Path -like '*/versions/*&$expand=ReplicationStatus'
            }
        }

        It 'Rejects a different existing template location before deploying or resuming a <state> run' -ForEach @(
            @{ state = 'Running' }
            @{ state = 'Succeeded' }
        ) {
            $script:templateResource.properties.lastRunStatus.runState = $state
            Mock Invoke-AzRestMethod { New-TestArmResponse -Resource $script:templateResource } -ParameterFilter {
                $Path -like '*/imageTemplates/*'
            }

            { . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation australiaeast } |
                Should -Throw '*southeastasia*australiaeast*new ImageTemplateName*'

            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'POST' }
        }

        It 'Waits for every required replica on a <mode> build' -ForEach @(
            @{ mode = 'new'; resume = $false }
            @{ mode = 'resumed'; resume = $true }
        ) {
            $script:resume = $resume
            Set-TestRegions @('southeastasia', 'australiaeast', 'eastus')
            $script:templateResource.location = 'australiaeast'
            Mock Invoke-AzRestMethod {
                $script:versionGetCount++
                if ($script:versionGetCount -eq 1) { return New-TestArmResponse -StatusCode 404 }
                $replica = $script:versionResource.properties.replicationStatus.summary[2]
                $replica.state = if ($script:versionGetCount -lt 4) { 'Replicating' } else { 'Completed' }
                New-TestArmResponse -Resource $script:versionResource
            } -ParameterFilter { $Path -like '*/versions/*' }

            $result = . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation australiaeast -ReplicationRegions eastus

            Assert-TestResult -Result $result -Status 'Succeeded' -Started (-not $resume)
            Should -Invoke Invoke-AzRestMethod -Times 4 -Exactly -ParameterFilter {
                $Path -like '*/versions/*&$expand=ReplicationStatus'
            }
            Should -Invoke Invoke-AzRestMethod -Times ([int] (-not $resume)) -Exactly -ParameterFilter { $Method -eq 'POST' }
        }

        It 'Fails without success or another build for <problem> after a <mode> run' -ForEach @(
            @{ mode = 'new'; resume = $false; problem = 'missing target'; change = 'target'; expectedError = '*eastus*publishingProfile.targetRegions*' }
            @{ mode = 'resumed'; resume = $true; problem = 'missing target'; change = 'target'; expectedError = '*eastus*publishingProfile.targetRegions*' }
            @{ mode = 'new'; resume = $false; problem = 'failed replica'; change = 'Failed'; expectedError = '*eastus*Failed*replica failure*' }
            @{ mode = 'resumed'; resume = $true; problem = 'failed replica'; change = 'Failed'; expectedError = '*eastus*Failed*replica failure*' }
            @{ mode = 'new'; resume = $false; problem = 'pending replication'; change = 'Replicating'; expectedError = '*timeout*eastus*Replicating*' }
            @{ mode = 'resumed'; resume = $true; problem = 'pending replication'; change = 'Replicating'; expectedError = '*timeout*eastus*Replicating*' }
            @{ mode = 'new'; resume = $false; problem = 'missing replica status'; change = 'summary'; expectedError = '*timeout*eastus*replication status*' }
            @{ mode = 'resumed'; resume = $true; problem = 'missing replica status'; change = 'summary'; expectedError = '*timeout*eastus*replication status*' }
            @{ mode = 'new'; resume = $false; problem = 'unpublished version'; change = 'absent'; expectedError = '*timeout*Version not found*' }
            @{ mode = 'resumed'; resume = $true; problem = 'unpublished version'; change = 'absent'; expectedError = '*timeout*Version not found*' }
        ) {
            $script:resume = $resume
            Set-TestRegions @('southeastasia', 'australiaeast', 'eastus')
            $script:templateResource.location = 'australiaeast'
            $properties = $script:versionResource.properties
            switch ($change) {
                'target' { $properties.publishingProfile.targetRegions = $properties.publishingProfile.targetRegions[0..1] }
                'summary' { $properties.replicationStatus.summary = $properties.replicationStatus.summary[0..1] }
                'absent' { Mock Invoke-AzRestMethod { New-TestArmResponse -StatusCode 404 } -ParameterFilter { $Path -like '*/versions/*' } }
                default {
                    $properties.replicationStatus.summary[2].state = $change
                    $properties.replicationStatus.summary[2].details = 'replica failure'
                }
            }

            { . $buildScript -AssetBaseUri 'https://example.test/assets' -BuildLocation australiaeast -ReplicationRegions eastus -BuildTimeoutInMinutes 1 } |
                Should -Throw $expectedError

            Should -Invoke New-AzSubscriptionDeployment -Times ([int] (-not $resume)) -Exactly
            Should -Invoke Invoke-AzRestMethod -Times ([int] (-not $resume)) -Exactly -ParameterFilter { $Method -eq 'POST' }
        }

        It 'Rejects an unsuccessful image build without exposing unfiltered provider diagnostics' {
            $script:templateResource.properties.lastRunStatus.runState = 'Failed'
            $script:templateResource.properties.lastRunStatus.message = 'PackerBuildFailed: payload download failed'

            { . $buildScript -AssetBaseUri 'https://example.test/assets' } |
                Should -Throw '*Failed*Provider details require guarded diagnostics*'
        }

        It 'Rejects a failed resource deployment before starting an image build' {
            Mock New-AzSubscriptionDeployment { [pscustomobject] @{ ProvisioningState = 'Failed' } }

            { . $buildScript -AssetBaseUri 'https://example.test/assets' } | Should -Throw '*resource deployment*Failed*'

            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'POST' }
        }

        It 'Rejects invalid <parameter> before Azure calls' -ForEach @(
            @{ parameter = 'BuildLocation'; value = '' }
            @{ parameter = 'BuildLocation'; value = ' ' }
            @{ parameter = 'ReplicationRegions'; value = @() }
            @{ parameter = 'ReplicationRegions'; value = @('eastus', '') }
            @{ parameter = 'ReplicationRegions'; value = @('eastus', ' ') }
            @{ parameter = 'HciVhdxSha256'; value = '' }
            @{ parameter = 'HciVhdxSha256'; value = 'a' * 63 }
            @{ parameter = 'HciVhdxSha256'; value = 'a' * 65 }
            @{ parameter = 'HciVhdxSha256'; value = 'g' * 64 }
            @{ parameter = 'HciVhdxSha256'; value = ('a' * 64) + "`n" }
        ) {
            $inputParameters = @{ $parameter = $value }

            { . $buildScript -AssetBaseUri 'https://example.test/assets' @inputParameters } | Should -Throw

            Should -Invoke Set-AzContext -Times 0 -Exactly
        }
    }
}
