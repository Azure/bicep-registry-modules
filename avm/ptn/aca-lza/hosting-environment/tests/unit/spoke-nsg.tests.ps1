param (
    [string] $RepoRootPath = (Resolve-Path (Join-Path $PSScriptRoot '..' '..' '..' '..' '..' '..')).Path,
    [string] $ResourcesModulePath,
    [string] $AccountsModulePath,
    [string] $EvidencePath
)

BeforeAll {
    $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
    $sourcePath = Join-Path $moduleRoot 'modules' 'spoke' 'deploy.spoke.bicep'
    $source = Get-Content -LiteralPath $sourcePath -Raw
    $baseline = Get-Content (Join-Path $PSScriptRoot 'fixtures' 'spoke-nsg.baseline.json') -Raw |
        ConvertFrom-Json -AsHashtable -Depth 100

    function Get-RequiredMatch([string] $Text, [string] $Pattern) {
        $match = [regex]::Match($Text, $Pattern)
        if (-not $match.Success) { throw "Actual spoke expression was not found: $Pattern" }
        return $match
    }

    function Get-ObjectHash($Value) {
        $json = $Value | ConvertTo-Json -Depth 100 -Compress
        [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($json))).ToLowerInvariant()
    }

    function ConvertTo-CanonicalJson($Value) {
        function Sort-Value($Item) {
            if ($Item -is [Collections.IDictionary]) {
                $sorted = [ordered]@{}
                foreach ($key in @($Item.Keys) | Sort-Object -CaseSensitive) { $sorted[$key] = Sort-Value $Item[$key] }
                return $sorted
            }
            if ($Item -is [array]) { return ,@($Item | ForEach-Object { Sort-Value $_ }) }
            return $Item
        }
        Sort-Value $Value | ConvertTo-Json -Depth 100 -Compress
    }

    function Convert-ModuleBody([string] $Body) {
        $scope = 'scope: resourceGroup(resourcesNames.resourceGroup)'
        if (-not $Body.Contains($scope)) { throw 'Unexpected NSG resource-group scope.' }
        $Body.Replace($scope, 'resourceGroupName: resourcesNames.resourceGroup').
            Replace('deployment().name', 'deploymentName').
            Replace('logAnalyticsWorkspace.outputs.resourceId', 'workspaceId')
    }

    function Convert-SubnetAssembly([string] $Text, [string] $Prefix, [string[]] $References) {
        for ($index = 0; $index -lt $References.Count; $index++) {
            $Text = $Text.Replace($References[$index], "${Prefix}NsgIds[$index]")
        }
        $Text.Replace('egressLockdownUdr.outputs.resourceId', 'routeTableId').
            Replace('defaultSubnets', "${Prefix}DefaultSubnets").
            Replace('appGwAndDefaultSubnets', "${Prefix}AppGwAndDefaultSubnets").
            Replace('spokeSubnets', "${Prefix}SpokeSubnets")
    }

    $compiledPath = Join-Path $TestDrive 'spoke.json'
    $diagnostics = bicep build $sourcePath --no-restore --outfile $compiledPath 2>&1
    if ($LASTEXITCODE -ne 0) { throw "Actual spoke compilation failed: $($diagnostics -join "`n")" }
    $compiled = Get-Content $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    $nsgCollection = @($compiled.resources | Where-Object { $_.copy.name -eq 'networkSecurityGroups' })
    if ($nsgCollection.Count -ne 1) { throw 'Expected one actual NSG module collection.' }
    $nsgCollection = $nsgCollection[0]
    $vnet = @($compiled.resources | Where-Object { $_.properties.parameters.subnets })[0]
}

Describe 'ACA spoke NSG semantic preservation' {
    It 'Retains the exact pinned child template, resource-group scope and diagnostics dependency' {
        Get-ObjectHash $nsgCollection.properties.template | Should -BeExactly $baseline.nsgTemplateSha256
        $nsgCollection.resourceGroup | Should -BeExactly $baseline.vnet.resourceGroup
        $nsgCollection.condition | Should -BeExactly "[variables('nsgConfigurations')[copyIndex()].enabled]"
        foreach ($dependency in $baseline.nsgDependsOn) {
            ConvertTo-CanonicalJson @($nsgCollection.dependsOn) | Should -BeExactly (ConvertTo-CanonicalJson @($dependency))
        }
        $nsgCollection.properties.parameters.diagnosticSettings.value[0].workspaceResourceId |
            Should -Match "reference\(.*deploy-logAnalyticsWs-"
    }

    It 'Preserves the virtual-network dependency closure and all other virtual-network inputs' {
        $names = @('nsgContainerAppsEnvironment', 'nsgAppGw', 'nsgPep', 'nsgDeploymentSubnet')
        for ($index = 0; $index -lt $names.Count; $index++) {
            $reference = "variables('nsgConfigurations')[$index].deploymentName"
            $actualDependency = @($vnet.dependsOn | Where-Object { $_.Contains($reference) })
            $expectedDependency = @($baseline.vnet.dependsOn | Where-Object { $_.Contains("deploy-$($names[$index])-") })
            $actualDependency | Should -HaveCount 1
            $expectedDependency | Should -HaveCount 1
            $expectedScope = [regex]::Replace(
                $expectedDependency[0],
                'take\(format\(''deploy-nsg[^'']+-\{0\}'', deployment\(\)\.name\), 64\)',
                '__NSG__'
            )
            $actualDependency[0].Replace($reference, '__NSG__') | Should -BeExactly $expectedScope
        }
        $remaining = @($vnet.dependsOn | Where-Object { -not $_.Contains("variables('nsgConfigurations')") } | Sort-Object)
        $before = @($baseline.vnet.dependsOn | Where-Object { $_ -notmatch 'deploy-nsg' } | Sort-Object)
        ConvertTo-CanonicalJson $remaining | Should -BeExactly (ConvertTo-CanonicalJson $before)
        Get-ObjectHash $vnet.properties.template | Should -BeExactly $baseline.vnet.templateSha256
        $vnet.name | Should -BeExactly $baseline.vnet.name
        $afterParameters = $vnet.properties.parameters.Clone()
        $beforeParameters = $baseline.vnet.parameters.Clone()
        $afterParameters.Remove('subnets')
        $beforeParameters.Remove('subnets')
        ConvertTo-CanonicalJson $afterParameters | Should -BeExactly (ConvertTo-CanonicalJson $beforeParameters)
    }

    It 'Leaves optional Linux/Windows deployments, workspace, routes and public interfaces unchanged' {
        foreach ($resource in $baseline.unchangedResources) {
            $actual = @($compiled.resources | Where-Object name -CEQ $resource.name)
            $actual | Should -HaveCount 1
            Get-ObjectHash $actual[0] | Should -BeExactly $resource.sha256
        }
        ConvertTo-CanonicalJson $compiled.parameters | Should -BeExactly (ConvertTo-CanonicalJson $baseline.parameters)
        ConvertTo-CanonicalJson $compiled.outputs | Should -BeExactly (ConvertTo-CanonicalJson $baseline.outputs)
    }

    Context 'Evaluated expressions: gateway <gateway>, jumpbox <os>' -ForEach @(
        @{ gateway = $true; os = 'none'; region = 'swedencentral'; longName = $false }
        @{ gateway = $true; os = 'linux'; region = 'francecentral'; longName = $true }
        @{ gateway = $true; os = 'windows'; region = 'norwayeast'; longName = $false }
        @{ gateway = $false; os = 'none'; region = 'swedencentral'; longName = $true }
        @{ gateway = $false; os = 'linux'; region = 'francecentral'; longName = $false }
        @{ gateway = $false; os = 'windows'; region = 'norwayeast'; longName = $true }
    ) {
        BeforeAll {
            $bindings = @{
                deploymentName = $longName ? ('synthetic-' + ('x' * 90)) : 'synthetic-parent'
                resourcesNames = @{
                    resourceGroup = 'synthetic-spoke'; containerAppsEnvironmentNsg = 'synthetic-infra'
                    applicationGatewayNsg = 'synthetic-gateway'; pepNsg = 'synthetic-pep'; acrDeploymentPoolNsg = 'synthetic-deployment'
                }
                location = $region; tags = @{ purpose = 'synthetic'; value = [string][char]0x00E9 }; enableTelemetry = $gateway
                workspaceId = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/synthetic-spoke/providers/Microsoft.OperationalInsights/workspaces/synthetic-law'
                spokeApplicationGatewaySubnetAddressPrefix = $gateway ? '10.1.3.0/24' : ''
                spokeInfraSubnetName = 'infra'; spokeInfraSubnetAddressPrefix = '10.1.0.0/23'
                deploymentSubnetName = 'deployment'; deploymentSubnetAddressPrefix = '10.1.4.0/24'
                spokePrivateEndpointsSubnetName = 'pep'; spokePrivateEndpointsSubnetAddressPrefix = '10.1.2.0/27'
                spokeApplicationGatewaySubnetName = 'gateway'; vmSubnetName = 'jumpbox'; vmJumpBoxSubnetAddressPrefix = '10.1.2.32/27'
                vmJumpboxOSType = $os; hubVNetId = $gateway ? 'synthetic-hub' : ''; networkApplianceIpAddress = $gateway ? '10.0.0.4' : ''
                routeTableId = '/synthetic/routeTables/egress'
            }
            $lines = @('using none') + @($bindings.GetEnumerator() | Sort-Object Key | ForEach-Object {
                $json = ($_.Value | ConvertTo-Json -Depth 10 -Compress).Replace('\', '\\').Replace("'", "\'")
                "var $($_.Key) = json('$json')"
            })
            $serviceTag = Get-RequiredMatch $source '(?ms)^var serviceTagLocationMap = .*?(?=^// Subnet definition)'
            $lines += $serviceTag.Value
            for ($index = 0; $index -lt $baseline.nsgDeclarations.Count; $index++) {
                $match = Get-RequiredMatch $baseline.nsgDeclarations[$index].declaration '(?ms)^module \w+ ''[^'']+'' = (?<conditional>if \((?<condition>[^\r\n]+)\) )?\{(?<body>.*?)^\}'
                $condition = $match.Groups['conditional'].Success ? $match.Groups['condition'].Value : 'true'
                $lines += "var beforeNsg$index = {`ncondition: $condition`n$(Convert-ModuleBody $match.Groups['body'].Value)`n}"
            }
            $lines += 'var beforeNsgs = [beforeNsg0, beforeNsg1, beforeNsg2, beforeNsg3]'
            $configurations = Get-RequiredMatch $source '(?ms)^var nsgConfigurations = .*?(?=^@description\(''Network security groups for the spoke subnets\.)'
            $lines += $configurations.Value.Replace('deployment().name', 'deploymentName')
            $loop = Get-RequiredMatch $source '(?ms)^module networkSecurityGroups ''[^'']+'' = \[\s+for (?<item>\w+) in nsgConfigurations: if \((?<condition>[^\r\n]+)\) \{(?<body>.*?)^  \}\r?\n\]'
            $lines += "var afterNsgs = [for $($loop.Groups['item'].Value) in nsgConfigurations: {`ncondition: $($loop.Groups['condition'].Value)`n$(Convert-ModuleBody $loop.Groups['body'].Value)`n}]"
            foreach ($prefix in @('before', 'after')) {
                $lines += "var ${prefix}NsgIds = [for nsg in ${prefix}Nsgs: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/`${nsg.resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/`${nsg.params.name}']"
            }
            $currentSubnets = Get-RequiredMatch $source '(?ms)^var defaultSubnets = .*?(?=^// -+\r?\n// RESOURCES)'
            $lines += Convert-SubnetAssembly $baseline.subnetAssembly 'before' @(
                'nsgContainerAppsEnvironment.outputs.resourceId', 'nsgAppGw.outputs.resourceId',
                'nsgPep.outputs.resourceId', 'nsgDeploymentSubnet.outputs.resourceId'
            )
            $lines += Convert-SubnetAssembly $currentSubnets.Value 'after' @(
                'networkSecurityGroups[0].outputs.resourceId', 'networkSecurityGroups[1].outputs.resourceId',
                'networkSecurityGroups[2].outputs.resourceId', 'networkSecurityGroups[3].outputs.resourceId'
            )
            $lines += @(
                'param beforeCalls = beforeNsgs', 'param afterCalls = afterNsgs'
                'param beforeSubnets = beforeSpokeSubnets', 'param afterSubnets = afterSpokeSubnets'
            )
            $parameterPath = Join-Path $TestDrive "nsg-$gateway-$os.bicepparam"
            $resultPath = Join-Path $TestDrive "nsg-$gateway-$os.json"
            [IO.File]::WriteAllText($parameterPath, ($lines -join "`n"))
            $diagnostics = bicep build-params $parameterPath --no-restore --outfile $resultPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw "Actual NSG expression evaluation failed: $($diagnostics -join "`n")" }
            $evaluated = (Get-Content $resultPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100).parameters
            $beforeCalls = $evaluated.beforeCalls.value
            $afterCalls = $evaluated.afterCalls.value
        }

        It 'Preserves all evaluated deployment names, scopes, rules, diagnostics, tags and telemetry' {
            ConvertTo-CanonicalJson $afterCalls | Should -BeExactly (ConvertTo-CanonicalJson $beforeCalls)
            foreach ($call in $afterCalls) {
                $call.name.Length | Should -BeLessOrEqual 64
                $call.params.diagnosticSettings[0].workspaceResourceId | Should -BeExactly $bindings.workspaceId
            }
            @($afterCalls | Where-Object condition) | Should -HaveCount (3 + [int]$gateway)
            @($afterCalls | Where-Object { -not $_.condition }).Count | Should -Be ([int](-not $gateway))
        }

        It 'Preserves subnet identities, NSG output bindings, routes and delegations including optional VMs' {
            ConvertTo-CanonicalJson $evaluated.afterSubnets.value |
                Should -BeExactly (ConvertTo-CanonicalJson $evaluated.beforeSubnets.value)
            @($evaluated.afterSubnets.value) | Should -HaveCount (3 + [int]$gateway + [int]($os -ne 'none'))
            @($evaluated.afterSubnets.value | Where-Object delegation -EQ 'Microsoft.Network/applicationGateways') |
                Should -HaveCount ([int]$gateway)
        }

        It 'Resolves indexed NSG dependencies to the same enabled deployment identities' {
            $beforeDependencies = @($beforeCalls | Where-Object condition | ForEach-Object { "$($_.resourceGroupName)/$($_.name)" } | Sort-Object)
            $afterDependencies = @($afterCalls | Where-Object condition | ForEach-Object { "$($_.resourceGroupName)/$($_.name)" } | Sort-Object)
            ConvertTo-CanonicalJson $afterDependencies | Should -BeExactly (ConvertTo-CanonicalJson $beforeDependencies)
            @($afterDependencies | Select-Object -Unique).Count | Should -Be $afterDependencies.Count
        }
    }
}

Describe 'ACA actual SDK deployment-request byte budgets' {
    BeforeAll {
        if (-not $ResourcesModulePath) { $ResourcesModulePath = (Get-Module -ListAvailable Az.Resources | Sort-Object Version -Descending | Select-Object -First 1).ModuleBase }
        if (-not $AccountsModulePath) { $AccountsModulePath = (Get-Module -ListAvailable Az.Accounts | Sort-Object Version -Descending | Select-Object -First 1).ModuleBase }
        if (-not $ResourcesModulePath -or -not $AccountsModulePath) { throw 'Actual Az.Resources and Az.Accounts assemblies are required; pass their isolated module paths when not installed.' }
        foreach ($assembly in @(
            (Join-Path $AccountsModulePath 'Microsoft.Rest.ClientRuntime.dll'),
            (Join-Path $AccountsModulePath 'Microsoft.Rest.ClientRuntime.Azure.dll'),
            (Join-Path $ResourcesModulePath 'Microsoft.Azure.PowerShell.Resources.Management.Sdk.dll'),
            (Join-Path $ResourcesModulePath 'Microsoft.Azure.PowerShell.Cmdlets.ResourceManager.dll')
        )) {
            $null = [Reflection.Assembly]::LoadFrom($assembly)
        }
        if (-not ('AcaNsgRequestCaptureHandler' -as [type])) {
            Add-Type -TypeDefinition @'
using System;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
public sealed class AcaNsgRequestCaptureHandler : HttpMessageHandler {
    public byte[] Body;
    public int Calls;
    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken) {
        if (request.RequestUri.Host != "offline.invalid") throw new InvalidOperationException("Unexpected request destination.");
        Body = await request.Content.ReadAsByteArrayAsync(cancellationToken);
        Calls++;
        return new HttpResponseMessage(HttpStatusCode.BadRequest) {
            Content = new StringContent("{\"error\":{\"code\":\"OfflineCaptureOnly\",\"message\":\"No network transport exists.\"}}")
        };
    }
}
'@
        }
        $requestHandler = [AcaNsgRequestCaptureHandler]::new()
        $httpClient = [Net.Http.HttpClient]::new($requestHandler)
        $resourceClient = [Microsoft.Azure.Management.Resources.ResourceManagementClient]::new(
            [Microsoft.Rest.TokenCredentials]::new('synthetic-offline-only'), $httpClient, $true
        )
        $expectedSdk = Join-Path $ResourcesModulePath 'Microsoft.Azure.PowerShell.Resources.Management.Sdk.dll'
        if ((Get-FileHash $resourceClient.GetType().Assembly.Location).Hash -ne (Get-FileHash $expectedSdk).Hash) {
            throw 'A different SDK assembly was already loaded; use an isolated validation process.'
        }
        $resourceClient.BaseUri = [uri]'https://offline.invalid/'
        $resourceClient.SubscriptionId = '00000000-0000-0000-0000-000000000000'
        $jsonExtension = [Microsoft.Azure.Commands.ResourceManager.Cmdlets.Extensions.JsonExtensions]
        $fromJson = @($jsonExtension.GetMethods() | Where-Object {
            $_.Name -eq 'FromJson' -and $_.GetParameters()[0].ParameterType -eq [string]
        })[0].MakeGenericMethod([hashtable])

        function Get-SdkRequest([string] $Template) {
            $templateObject = $fromJson.Invoke($null, [object[]]@($Template))
            $deployment = [Microsoft.Azure.Management.Resources.Models.Deployment]::new()
            $deployment.Location = 'WestEurope'
            $deployment.Properties = [Microsoft.Azure.Management.Resources.Models.DeploymentProperties]::new()
            $deployment.Properties.Mode = [Microsoft.Azure.Management.Resources.Models.DeploymentMode]::Incremental
            $deployment.Properties.Template = $jsonExtension::ToJToken($templateObject)
            $deployment.Properties.Parameters = [Collections.Generic.Dictionary[string,Microsoft.Azure.Management.Resources.Models.DeploymentParameter]]::new()
            $before = $requestHandler.Calls
            $response = $resourceClient.Deployments.BeginValidateAtSubscriptionScopeWithHttpMessagesAsync(
                'spoke-nsg-offline', $deployment, $null, [Threading.CancellationToken]::None
            ).GetAwaiter().GetResult()
            if ($requestHandler.Calls -ne $before + 1 -or $response.Body.Error.Code -ne 'OfflineCaptureOnly') {
                throw 'Actual SDK request was not captured by the injected-only handler.'
            }
            $text = [Text.Encoding]::UTF8.GetString($requestHandler.Body)
            $serialized = [Microsoft.Rest.Serialization.SafeJsonConvert]::SerializeObject($deployment, $resourceClient.SerializationSettings)
            if ($serialized -cne $text) { throw 'Captured StringContent differs from actual SDK serialization.' }
            $lf = $text.Replace("`r`n", "`n")
            @{
                native = $requestHandler.Body; lf = [Text.Encoding]::UTF8.GetBytes($lf)
                windows = [Text.Encoding]::UTF8.GetBytes($lf.Replace("`n", "`r`n"))
                nativeText = $text
            }
        }

        function Assert-RequestBudget([byte[]] $Bytes, [long] $Limit) {
            if ($Bytes.LongLength -gt $Limit) { throw "Request uses $($Bytes.LongLength) UTF-8 bytes; maximum $Limit." }
        }

        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-LocallyReferencedFileList.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')
        $effectiveRoot = Join-Path $TestDrive 'effective-ci'
        $effectiveModule = Join-Path $effectiveRoot 'avm' 'ptn' 'aca-lza' 'hosting-environment'
        $null = New-Item -ItemType Directory -Path $effectiveModule -Force
        Get-ChildItem $moduleRoot -Force | Copy-Item -Destination $effectiveModule -Recurse
        Copy-Item (Join-Path $RepoRootPath 'bicepconfig.json') $effectiveRoot
        $assetRoot = Join-Path $effectiveRoot 'utilities' 'e2e-template-assets' 'scripts'
        $null = New-Item -ItemType Directory -Path $assetRoot -Force
        foreach ($asset in @('New-SSHKey.ps1', 'Set-CertificateInKeyVault.ps1')) {
            Copy-Item (Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'scripts' $asset) $assetRoot
        }
        $requestMeasurements = [Collections.Generic.List[object]]::new()
    }

    AfterAll {
        try {
            if ($EvidencePath -and $requestMeasurements) {
                $evidence = @{
                    measurements = @($requestMeasurements.ToArray())
                    sdkVersion = $resourceClient.GetType().Assembly.FullName
                    sdkSha256 = (Get-FileHash $resourceClient.GetType().Assembly.Location).Hash.ToLowerInvariant()
                    compiler = (bicep --version)
                    boundary = 'Actual SDK in-memory StringContent capture; no network delegate. Native line endings plus LF/Windows equivalents, not hosted wire capture.'
                    nativeNewline = [Environment]::NewLine -eq "`r`n" ? 'CRLF' : 'LF'
                    parameterKeys = @()
                    tokenNamePrefix = 'gci'
                }
                if (Test-Path $EvidencePath) { throw 'SDK evidence path already exists.' }
                [IO.File]::WriteAllText($EvidencePath, ($evidence | ConvertTo-Json -Depth 12))
            }
        } finally {
            if ($resourceClient) { $resourceClient.Dispose() }
            if ($httpClient) { $httpClient.Dispose() }
            if ($requestHandler) { $requestHandler.Dispose() }
        }
    }

    Context 'Effective CI request: <fixture>' -ForEach @(
        @{ fixture = 'defaults' }, @{ fixture = 'hub-spoke' }, @{ fixture = 'waf-aligned' }
    ) {
        BeforeAll {
            $fixturePath = Join-Path $effectiveModule 'tests' 'e2e' $fixture 'main.test.bicep'
            $files = @(@($fixturePath) + @(Get-LocallyReferencedFileList -FilePath $fixturePath) | Sort-Object -Unique)
            if (-not (Convert-TokensInFileList -FilePathList $files -Tokens @{ namePrefix = 'gci' })) { throw 'Effective CI token preprocessing failed.' }
            $output = Join-Path $TestDrive "$fixture.request-template.json"
            $diagnostics = bicep build $fixturePath --no-restore --outfile $output 2>&1
            if ($LASTEXITCODE -ne 0) { throw "Actual $fixture compilation failed: $($diagnostics -join "`n")" }
            $capture = Get-SdkRequest (Get-Content $output -Raw)
            $bodyPath = $null
            if ($EvidencePath) {
                $bodyPath = Join-Path (Split-Path $EvidencePath -Parent) "$([IO.Path]::GetFileNameWithoutExtension($EvidencePath))-$fixture.request.lf.json"
                if (Test-Path $bodyPath) { throw 'SDK request evidence already exists.' }
                [IO.File]::WriteAllBytes($bodyPath, $capture.lf)
            }
            $requestMeasurements.Add(@{
                fixture = $fixture; lfBytes = $capture.lf.Length; windowsBytes = $capture.windows.Length
                nativeBytes = $capture.native.Length
                lfSha256 = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($capture.lf)).ToLowerInvariant()
                windowsSha256 = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($capture.windows)).ToLowerInvariant()
                compiledSha256 = (Get-FileHash $output).Hash.ToLowerInvariant()
                compiledBytes = (Get-Item $output).Length
                bodyPath = $bodyPath
                captureMatchedSerializer = $true
            })
        }

        It 'Fits the actual LF request budget with reserved capacity' { Assert-RequestBudget $capture.lf 4080000 }
        It 'Fits the actual Windows request budget with reserved capacity' { Assert-RequestBudget $capture.windows 4140000 }
        It 'Remains below the hard API limit on both formatting platforms' {
            Assert-RequestBudget $capture.lf 4194304
            Assert-RequestBudget $capture.windows 4194304
        }
    }

    Context 'Actual SDK boundary controls' {
        BeforeAll {
            $empty = Get-SdkRequest '{"padding":""}'
            $paddingLength = 4194304 - $empty.native.Length
            $atLimit = Get-SdkRequest ('{"padding":"' + ('x' * $paddingLength) + '"}')
            $overLimit = Get-SdkRequest ('{"padding":"' + ('x' * ($paddingLength + 1)) + '"}')
            $multibyte = Get-SdkRequest ('{"padding":"' + ('x' * ($paddingLength - 1)) + [char]0x00E9 + '"}')
        }

        It 'Accepts exact equality at the UTF-8 byte ceiling' {
            $atLimit.native.Length | Should -Be 4194304
            { Assert-RequestBudget $atLimit.native 4194304 } | Should -Not -Throw
        }
        It 'Rejects one actual serialized byte above the ceiling' {
            $overLimit.native.Length | Should -Be 4194305
            { Assert-RequestBudget $overLimit.native 4194304 } | Should -Throw '*4194305 UTF-8 bytes*'
        }
        It 'Rejects multibyte UTF-8 growth despite unchanged character count' {
            $multibyte.nativeText.Length | Should -Be $atLimit.nativeText.Length
            $multibyte.native.Length | Should -Be 4194305
            { Assert-RequestBudget $multibyte.native 4194304 } | Should -Throw '*4194305 UTF-8 bytes*'
        }
    }
}
