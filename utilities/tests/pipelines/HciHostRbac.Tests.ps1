param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'HCI host RBAC prerequisites' {
    BeforeAll {
        $assetRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci'
        $fixtures = @{}
        foreach ($case in @('defaults', 'max', 'waf-aligned')) {
            $file = Join-Path $RepoRootPath 'avm' 'res' 'hybrid-container-service' 'provisioned-cluster-instance' 'tests' 'e2e' $case 'main.test.bicep'
            $compiledPath = Join-Path $TestDrive "$case.json"
            $diagnostics = bicep build $file --outfile $compiledPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
            $dependencies = $template.resources.nestedDependencies.properties.template
            $fixtures[$case] = @{
                root = $template
                dependencies = $dependencies
                hostTemplate = $dependencies.resources.hciHostDeployment.properties.template
                clusterTemplate = $template.resources.azlocal.properties.template
            }
        }

        $hostTemplate = $fixtures.defaults.hostTemplate
        $clusterTemplate = $fixtures.defaults.clusterTemplate
        $roleNames = @(
            'spConnectedMachineResourceManagerRolePermissions'
            'nodeAzureConnectedMachineResourceManagerRolePermissions'
            'nodeazureStackHCIDeviceManagementRole'
            'nodereaderRoleIDPermissions'
        )

        $hostSource = Get-Content -LiteralPath (Join-Path $assetRoot 'azureStackHCIHost' 'hciHostDeployment.bicep') -Raw
        $expression = [regex]::Match($hostSource, '(?m)^var hciNodeNames = (.+)$').Groups[1].Value.Trim()
        if ([string]::IsNullOrEmpty($expression)) { throw 'HCI node-name expression was not found.' }
        $parameterPath = Join-Path $TestDrive 'nodes.bicepparam'
        @(
            'using none'
            "param one = $($expression.Replace('hciNodeCount', '1'))"
            "param two = $($expression.Replace('hciNodeCount', '2'))"
        ) -join "`n" | Set-Content -LiteralPath $parameterPath
        $parameterOutput = Join-Path $TestDrive 'nodes.json'
        $diagnostics = bicep build-params $parameterPath --outfile $parameterOutput 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $nodeNames = (Get-Content -LiteralPath $parameterOutput -Raw | ConvertFrom-Json -AsHashtable).parameters
    }

    It 'Uses exactly the role identity and properties from the referenced cluster module: <RoleName>' -ForEach @(
        @{ RoleName = 'spConnectedMachineResourceManagerRolePermissions' }
        @{ RoleName = 'nodeAzureConnectedMachineResourceManagerRolePermissions' }
        @{ RoleName = 'nodeazureStackHCIDeviceManagementRole' }
        @{ RoleName = 'nodereaderRoleIDPermissions' }
    ) {
        $actual = $hostTemplate.resources[$RoleName]
        $expected = $clusterTemplate.resources[$RoleName]
        $actual | Should -Not -BeNullOrEmpty
        $expected | Should -Not -BeNullOrEmpty
        $actual.type | Should -Be 'Microsoft.Authorization/roleAssignments'
        $actual.apiVersion | Should -Be $expected.apiVersion
        $actual.name | Should -Be $expected.name
        $actual['scope'] | Should -Be $expected['scope']
        ($actual.properties | ConvertTo-Json -Depth 10 -Compress) |
            Should -Be ($expected.properties | ConvertTo-Json -Depth 10 -Compress)
    }

    It 'Retains the documented resource-manager, device-management and Reader role definitions' {
        foreach ($variable in @('azureConnectedMachineResourceManagerRoleID', 'azureStackHCIDeviceManagementRole', 'readerRoleID')) {
            $hostTemplate.variables[$variable] | Should -Be $clusterTemplate.variables[$variable]
        }
        $hostTemplate.variables.azureConnectedMachineResourceManagerRoleID | Should -Match 'f5819b54-e033-4d82-ac66-4fec3cbf3f4c'
        $hostTemplate.variables.azureStackHCIDeviceManagementRole | Should -Match '865ae368-6a45-4bd1-8fbf-0d5151f56fc1'
        $hostTemplate.variables.readerRoleID | Should -Match 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    }

    It 'Creates the provider grant before Arc initialization without depending on the host' {
        $hostTemplate.resources.spConnectedMachineResourceManagerRolePermissions['dependsOn'] |
            Should -BeNullOrEmpty
        $hostTemplate.resources.runCommand6.dependsOn | Should -Contain 'spConnectedMachineResourceManagerRolePermissions'
    }

    It 'Waits for Arc identities before assigning their roles, then waits for every role before edge setup' {
        foreach ($name in $roleNames | Where-Object { $_ -ne 'spConnectedMachineResourceManagerRolePermissions' }) {
            $hostTemplate.resources[$name].dependsOn | Should -Contain 'runCommand6'
            $hostTemplate.resources[$name].properties.principalId |
                Should -Be "[reference(variables('arcNodeResourceIds')[copyIndex()], '2026-07-15', 'Full').identity.principalId]"
        }
        foreach ($name in $roleNames) {
            $hostTemplate.resources.runCommand7.dependsOn | Should -Contain $name
        }
    }

    It 'Preserves the no-extra-grants default for existing callers with preconfigured RBAC' {
        $hostTemplate.parameters.hciResourceProviderObjectId.nullable | Should -BeTrue
        foreach ($name in $roleNames) {
            $hostTemplate.resources[$name].condition |
                Should -Be "[not(equals(parameters('hciResourceProviderObjectId'), null()))]"
        }
    }

    It 'Uses the same node names as the Hyper-V host and cluster inputs' {
        @($nodeNames.one.value) | Should -Be @('hcinode1')
        @($nodeNames.two.value) | Should -Be @('hcinode1', 'hcinode2')
    }

    It 'Wires the same principal through host setup and final cluster deployment for <Case>' -ForEach @(
        @{ Case = 'defaults' }
        @{ Case = 'max' }
        @{ Case = 'waf-aligned' }
    ) {
        $fixture = $fixtures[$Case]
        $fixture.root.resources.nestedDependencies.properties.parameters.hciResourceProviderObjectId.value |
            Should -Be $fixture.root.resources.azlocal.properties.parameters.hciResourceProviderObjectId.value
        $fixture.dependencies.resources.hciHostDeployment.properties.parameters.hciResourceProviderObjectId.value |
            Should -Be "[parameters('hciResourceProviderObjectId')]"
        $fixture.dependencies.resources.hciHostDeployment.properties.parameters.hciNodeCount.value |
            Should -Be "[length(variables('clusterNodeNames'))]"
        @($fixture.dependencies.variables.clusterNodeNames) | Should -Be @($nodeNames.one.value)
    }

    It 'Still compiles existing <File> callers that do not supply the optional principal' -ForEach @(
        @{ File = 'defaults-dependencies.bicep' }
        @{ File = 'waf-dependencies.bicep' }
    ) {
        $compiledPath = Join-Path $TestDrive "$File.json"
        $diagnostics = bicep build (Join-Path $assetRoot 'dependencies' $File) --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        $resources = if ($template.resources -is [System.Collections.IDictionary]) {
            @($template.resources.Values)
        } else {
            @($template.resources)
        }
        $hostModules = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and
                $_.properties.template.parameters.ContainsKey('hciResourceProviderObjectId')
        })
        $hostModules.Count | Should -Be 1
        $hostModules[0].properties.template.parameters.hciResourceProviderObjectId.nullable | Should -BeTrue
        $hostModules[0].properties.parameters.ContainsKey('hciResourceProviderObjectId') | Should -BeFalse
    }
}
