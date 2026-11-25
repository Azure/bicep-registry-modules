param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName,
    [array] $moduleFolderPaths
)

Describe 'Private analytical workspace network response shapes' {
    BeforeAll {
        $helperPath = Join-Path $repoRootPath 'avm' 'ptn' 'data' 'private-analytical-workspace' 'tests' 'common.tests.ps1'
        $tokens = $null
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($helperPath, [ref] $tokens, [ref] $parseErrors)
        if ($parseErrors) { throw 'Could not parse the network test helpers.' }
        $vnetStatements = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.PipelineAst] -and
                    $node.Extent.Text -match '^\(?\$vnet\.(AddressSpace|VirtualNetworkPeerings|IpAllocations)\b' -and
                    $node.Extent.Text -match '\|\s*Should\b'
                }, $true))
        $subnetStatements = @($ast.FindAll({
                    param($node)
                    $node -is [System.Management.Automation.Language.PipelineAst] -and
                    $node.Extent.Text -match '^\(?\$Subnet\.(NetworkSecurityGroup|PrivateEndpoints|IpConfigurations)\b' -and
                    $node.Extent.Text -match '\|\s*Should\s+-Be\b'
                }, $true))
        if ($vnetStatements.Count -ne 4 -or $subnetStatements.Count -ne 3) {
            throw 'Expected the real address-space and nullable collection assertions.'
        }
        $vnetAssertions = [scriptblock]::Create($vnetStatements.Extent.Text -join [Environment]::NewLine)
        $subnetAssertions = [scriptblock]::Create($subnetStatements.Extent.Text -join [Environment]::NewLine)
    }

    It 'Checks the real VNet assertions for <scenario>' -ForEach @(
        @{ scenario = 'null optional collections'; accepted = $true }
        @{ scenario = 'empty optional collections'; accepted = $true }
        @{ scenario = 'unexpected prefix'; accepted = $false }
        @{ scenario = 'extra prefix'; accepted = $false }
        @{ scenario = 'unexpected peering'; accepted = $false }
        @{ scenario = 'unexpected IP allocation'; accepted = $false }
    ) {
        Set-StrictMode -Version 3.0
        $AddressPrefix = '10.0.0.0/16'
        $vnet = [pscustomobject]@{
            AddressSpace = [pscustomobject]@{ AddressPrefixes = @($AddressPrefix) }
            VirtualNetworkPeerings = $null
            IpAllocations = $null
        }
        switch ($scenario) {
            'empty optional collections' { $vnet.VirtualNetworkPeerings = @(); $vnet.IpAllocations = @() }
            'unexpected prefix' { $vnet.AddressSpace.AddressPrefixes = @('10.1.0.0/16') }
            'extra prefix' { $vnet.AddressSpace.AddressPrefixes += '10.1.0.0/16' }
            'unexpected peering' { $vnet.VirtualNetworkPeerings = [pscustomobject]@{ Id = 'peering' } }
            'unexpected IP allocation' { $vnet.IpAllocations = [pscustomobject]@{ Id = 'allocation' } }
        }
        if ($accepted) {
            { . $vnetAssertions } | Should -Not -Throw
        } else {
            { . $vnetAssertions } | Should -Throw
        }
    }

    It 'Checks the real subnet counts for <scenario>' -ForEach @(
        @{ scenario = 'null'; value = $null; expected = 0; accepted = $true }
        @{ scenario = 'empty'; value = @(); expected = 0; accepted = $true }
        @{ scenario = 'scalar object'; value = [pscustomobject]@{ Id = 'resource' }; expected = 1; accepted = $true }
        @{ scenario = 'missing expected resource'; value = $null; expected = 1; accepted = $false }
        @{ scenario = 'unexpected resource'; value = [pscustomobject]@{ Id = 'resource' }; expected = 0; accepted = $false }
        @{ scenario = 'extra resource'; value = @('first', 'second'); expected = 1; accepted = $false }
    ) {
        Set-StrictMode -Version 3.0
        $Subnet = [pscustomobject]@{ NetworkSecurityGroup = $value; PrivateEndpoints = $value; IpConfigurations = $value }
        $NumberOfSecurityGroups = $NumberOfPrivateEndpoints = $NumberOfIpConfigurations = $expected
        if ($accepted) {
            { . $subnetAssertions } | Should -Not -Throw
        } else {
            { . $subnetAssertions } | Should -Throw
        }
    }
}
