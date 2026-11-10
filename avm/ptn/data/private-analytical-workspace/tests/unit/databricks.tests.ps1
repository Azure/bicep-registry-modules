param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName,
    [array] $moduleFolderPaths
)

Describe 'Private analytical workspace Databricks verification' {
    BeforeAll {
        $modulePath = Join-Path $repoRootPath 'avm' 'ptn' 'data' 'private-analytical-workspace'
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            (Join-Path $modulePath 'tests' 'common.tests.ps1'), [ref] $tokens, [ref] $parseErrors)
        if ($parseErrors) { throw 'Could not parse the real Databricks test helper.' }
        $helper = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
                    $node.Name -eq 'Test-VerifyDatabricks'
                }, $true))
        if ($helper.Count -ne 1) { throw 'Expected exactly one Databricks verification helper.' }
        $assertions = @{}
        foreach ($propertyName in @('ManagedDiskKeySource', 'ManagedServiceKeySource', 'EnableNoPublicIP', 'PublicIPNameType', 'PublicIPNameValue')) {
            $pipelines = @($helper[0].Body.FindAll({
                        param($node)
                        $node -is [System.Management.Automation.Language.PipelineAst] -and
                        $node.Extent.Text -match ('^\$adb\.' + $propertyName + '\s+\|')
                    }, $true))
            if ($pipelines.Count -ne 1) { throw "Expected one real assertion for $propertyName." }
            $assertions[$propertyName] = [scriptblock]::Create($pipelines[0].Extent.Text)
        }
        $publicIpAssertions = [scriptblock]::Create(
            ((@('EnableNoPublicIP', 'PublicIPNameType', 'PublicIPNameValue') | ForEach-Object {
                        $assertions[$_].ToString()
                    }) -join [Environment]::NewLine))
        $privateEndpointStatements = @($helper[0].Body.EndBlock.Statements | Where-Object {
                $_.Extent.Text -match '\$adb\.PrivateEndpointConnection\b'
            })
        if (-not $privateEndpointStatements.Count) { throw 'Expected the real private endpoint assertions.' }
        $privateEndpointAssertions = [scriptblock]::Create(
            ($privateEndpointStatements.Extent.Text -join [Environment]::NewLine))
        $configuredProperties = @(
            'CustomPrivateSubnetNameType', 'CustomPrivateSubnetNameValue',
            'CustomPublicSubnetNameType', 'CustomPublicSubnetNameValue',
            'CustomVirtualNetworkIdType', 'CustomVirtualNetworkIdValue',
            'EnableNoPublicIP', 'EnableNoPublicIPType',
            'PrepareEncryption', 'PrepareEncryptionType',
            'RequireInfrastructureEncryption', 'RequireInfrastructureEncryptionType',
            'VnetAddressPrefixType', 'VnetAddressPrefixValue'
        )
        $configuredStatements = @($helper[0].Body.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.PipelineAst] -and
                    $node.Extent.Text -match ('^\$adb\.(' + ($configuredProperties -join '|') + ')\s+\|')
                }, $true))
        if ($configuredStatements.Count -lt 7) { throw 'Expected all configured Databricks value assertions.' }
        $configuredAssertions = [scriptblock]::Create($configuredStatements.Extent.Text -join [Environment]::NewLine)
        $compiledPath = Join-Path $TestDrive 'private-analytical-workspace.json'
        $diagnostics = bicep build (Join-Path $modulePath 'main.bicep') --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        $resources = if ($template.resources -is [System.Collections.IDictionary]) {
            $template.resources.Values
        } else {
            $template.resources
        }
        $workspaces = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and $_.name -match '-workspace-'
            })
        if ($workspaces.Count -ne 1) { throw 'Expected exactly one compiled Databricks module.' }
        $workspaceParameters = $workspaces[0].properties.parameters
    }

    It 'Keeps encryption preparation enabled without configuring customer-managed encryption entities' {
        $workspaceParameters.prepareEncryption.value | Should -BeTrue
        @($workspaceParameters.Keys | Where-Object { $_ -match '^(customerManagedKey|encryption)' }).Count |
            Should -Be 0
    }

    It 'Checks the real configured values for <scenario> without optional type metadata' -ForEach @(
        @{ scenario = 'value-only response'; propertyName = ''; invalidValue = $null; accepted = $true }
        @{ scenario = 'wrong private subnet'; propertyName = 'CustomPrivateSubnetNameValue'; invalidValue = 'other'; accepted = $false }
        @{ scenario = 'wrong public subnet'; propertyName = 'CustomPublicSubnetNameValue'; invalidValue = 'other'; accepted = $false }
        @{ scenario = 'wrong VNet'; propertyName = 'CustomVirtualNetworkIdValue'; invalidValue = 'other'; accepted = $false }
        @{ scenario = 'public IP enabled'; propertyName = 'EnableNoPublicIP'; invalidValue = $false; accepted = $false }
        @{ scenario = 'encryption preparation disabled'; propertyName = 'PrepareEncryption'; invalidValue = $false; accepted = $false }
        @{ scenario = 'unexpected infrastructure encryption'; propertyName = 'RequireInfrastructureEncryption'; invalidValue = $true; accepted = $false }
        @{ scenario = 'wrong address prefix'; propertyName = 'VnetAddressPrefixValue'; invalidValue = '10.140'; accepted = $false }
    ) {
        Set-StrictMode -Version 3.0
        $PrivateSubnetName = 'private-subnet'
        $PublicSubnetName = 'public-subnet'
        $VirtualNetworkResourceId = 'virtual-network-id'
        $adb = [pscustomobject]@{
            CustomPrivateSubnetNameValue = $PrivateSubnetName
            CustomPublicSubnetNameValue = $PublicSubnetName
            CustomVirtualNetworkIdValue = $VirtualNetworkResourceId
            EnableNoPublicIP = $true
            PrepareEncryption = $true
            RequireInfrastructureEncryption = $false
            VnetAddressPrefixValue = '10.139'
        }
        if ($propertyName) { $adb.$propertyName = $invalidValue }
        if ($accepted) {
            { . $configuredAssertions } | Should -Not -Throw
        } else {
            { . $configuredAssertions } | Should -Throw
        }
    }

    It 'Leaves managed-VNet public-IP naming unset for the VNet-injected no-public-IP workspace' {
        $workspaceParameters.disablePublicIp.value | Should -BeTrue
        $workspaceParameters.customVirtualNetworkResourceId.value | Should -Not -BeNullOrEmpty
        $workspaceParameters.ContainsKey('publicIpName') | Should -BeFalse
        $workspaces[0].properties.template.parameters.publicIpName.defaultValue | Should -Be ''
    }

    It 'Checks the actual public-IP assertions for <scenario>' -ForEach @(
        @{ scenario = 'unset managed-VNet public-IP name'; disabled = $true; type = $null; name = $null; accepted = $true }
        @{ scenario = 'empty managed-VNet public-IP name'; disabled = $true; type = ''; name = ''; accepted = $true }
        @{ scenario = 'legacy managed-VNet public-IP name'; disabled = $true; type = 'String'; name = 'nat-gw-public-ip'; accepted = $false }
        @{ scenario = 'unexpected public-IP parameter type'; disabled = $true; type = 'String'; name = $null; accepted = $false }
        @{ scenario = 'unexpected public-IP parameter name'; disabled = $true; type = $null; name = 'unexpected-public-ip'; accepted = $false }
        @{ scenario = 'public IP enabled'; disabled = $false; type = $null; name = $null; accepted = $false }
    ) {
        $adb = [pscustomobject]@{ EnableNoPublicIP = $disabled; PublicIPNameType = $type; PublicIPNameValue = $name }
        if ($accepted) {
            { . $publicIpAssertions } | Should -Not -Throw
        } else {
            { . $publicIpAssertions } | Should -Throw
        }
    }

    It 'Allows exactly the service-required control-plane ports without broadening the rule scope' {
        $rules = @($template.variables.nsgRulesDbw | Where-Object {
                $_.name -eq 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-webapp'
            })
        $rules.Count | Should -Be 1
        $rule = $rules[0].properties
        $rule.destinationPortRanges.Count | Should -Be 3
        $rule.destinationPortRanges -join ',' | Should -Be '443,3306,8443-8451'
        $rule.destinationPortRange | Should -BeNullOrEmpty
        $rule.direction | Should -Be 'Outbound'
        $rule.access | Should -Be 'Allow'
        $rule.protocol | Should -Be 'Tcp'
        $rule.sourceAddressPrefix | Should -Be 'VirtualNetwork'
        $rule.sourcePortRange | Should -Be '*'
        $rule.destinationAddressPrefix | Should -Be 'AzureDatabricks'
        $rule.priority | Should -Be 100
        $workspaceParameters.disablePublicIp.value | Should -BeTrue
    }

    It 'Passes the required rules to the actual <groupName> security group' -ForEach @(
        @{ groupName = 'frontend'; nameVariable = 'nsgNameDbwFrontend' }
        @{ groupName = 'backend'; nameVariable = 'nsgNameDbwBackend' }
    ) {
        $groups = @($resources | Where-Object {
                $_.type -eq 'Microsoft.Resources/deployments' -and
                $_.properties.parameters.name.value -eq "[variables('$nameVariable')]"
            })
        $groups.Count | Should -Be 1
        $groups[0].properties.parameters.securityRules.value | Should -Be "[variables('nsgRulesDbw')]"
    }

    It 'Checks the actual <propertyName> assertion against <state> encryption configuration' -ForEach @(
        @{ propertyName = 'ManagedDiskKeySource'; state = 'unconfigured'; keySource = $null; accepted = $true }
        @{ propertyName = 'ManagedDiskKeySource'; state = 'customer-managed'; keySource = 'Microsoft.Keyvault'; accepted = $false }
        @{ propertyName = 'ManagedDiskKeySource'; state = 'unexpected'; keySource = 'Microsoft.Storage'; accepted = $false }
        @{ propertyName = 'ManagedServiceKeySource'; state = 'unconfigured'; keySource = $null; accepted = $true }
        @{ propertyName = 'ManagedServiceKeySource'; state = 'customer-managed'; keySource = 'Microsoft.Keyvault'; accepted = $false }
        @{ propertyName = 'ManagedServiceKeySource'; state = 'unexpected'; keySource = 'Microsoft.Storage'; accepted = $false }
    ) {
        $adb = [pscustomobject]@{ ManagedDiskKeySource = $keySource; ManagedServiceKeySource = $keySource }
        if ($accepted) {
            { . ($assertions[$propertyName]) } | Should -Not -Throw
        } else {
            { . ($assertions[$propertyName]) } | Should -Throw
        }
    }

    It 'Checks the actual private endpoint assertions for <scenario>' -ForEach @(
        @{ scenario = 'original service order'; accepted = $true }
        @{ scenario = 'reversed service order'; accepted = $true }
        @{ scenario = 'missing UI connection'; accepted = $false }
        @{ scenario = 'duplicate UI connection'; accepted = $false }
        @{ scenario = 'extra connection'; accepted = $false }
        @{ scenario = 'multiple UI group IDs'; accepted = $false }
        @{ scenario = 'unexpected group ID'; accepted = $false }
        @{ scenario = 'unapproved UI connection'; accepted = $false }
        @{ scenario = 'unapproved authentication connection'; accepted = $false }
        @{ scenario = 'failed UI provisioning'; accepted = $false }
        @{ scenario = 'failed authentication provisioning'; accepted = $false }
    ) {
        $ui = [pscustomobject]@{
            GroupId = @('databricks_ui_api')
            PrivateLinkServiceConnectionStateStatus = 'Approved'
            ProvisioningState = 'Succeeded'
        }
        $authentication = [pscustomobject]@{
            GroupId = @('browser_authentication')
            PrivateLinkServiceConnectionStateStatus = 'Approved'
            ProvisioningState = 'Succeeded'
        }
        $connections = @($ui, $authentication)
        switch ($scenario) {
            'reversed service order' { $connections = @($authentication, $ui) }
            'missing UI connection' { $connections = @($authentication) }
            'duplicate UI connection' { $connections = @($ui, $ui) }
            'extra connection' { $connections = @($ui, $authentication, $authentication) }
            'multiple UI group IDs' { $ui.GroupId = @('databricks_ui_api', 'browser_authentication') }
            'unexpected group ID' { $authentication.GroupId = @('unexpected') }
            'unapproved UI connection' { $ui.PrivateLinkServiceConnectionStateStatus = 'Pending' }
            'unapproved authentication connection' { $authentication.PrivateLinkServiceConnectionStateStatus = 'Rejected' }
            'failed UI provisioning' { $ui.ProvisioningState = 'Failed' }
            'failed authentication provisioning' { $authentication.ProvisioningState = 'Failed' }
        }
        $adb = [pscustomobject]@{ PrivateEndpointConnection = $connections }
        if ($accepted) {
            { . $privateEndpointAssertions } | Should -Not -Throw
        } else {
            { . $privateEndpointAssertions } | Should -Throw
        }
    }
}
