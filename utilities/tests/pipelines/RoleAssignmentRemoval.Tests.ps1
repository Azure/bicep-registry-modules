param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Role assignment cleanup without directory lookup' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Invoke-ResourceRemoval.ps1')
        function Get-AzResourceLock {
            [CmdletBinding()]
            param([string] $Scope)
            throw 'Unexpected lock lookup.'
        }
        function Get-AzRoleAssignment {
            [CmdletBinding()]
            param([string] $Scope)
            throw 'ClientAssertionCredential authentication failed.'
        }
        function Remove-AzRoleAssignment {
            [CmdletBinding()]
            param([Parameter(ValueFromPipeline)] [object] $InputObject)
            throw 'Unexpected directory-backed role removal.'
        }
        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param([string] $Method, [string] $Path)
            throw 'Unexpected REST request.'
        }
        $roleId = '/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Authorization/roleAssignments/22222222-2222-2222-2222-222222222222'
    }

    BeforeEach {
        Mock Get-AzResourceLock {}
        Mock Get-AzRoleAssignment { throw 'ClientAssertionCredential authentication failed.' }
        Mock Remove-AzRoleAssignment { throw 'The managed identity no longer exists.' }
        Mock Invoke-AzRestMethod { @{ StatusCode = 204; Content = '' } }
    }

    It 'Deletes only the supplied role assignment at <ScopeName> scope using ARM' -ForEach @(
        @{ ScopeName = 'tenant'; Scope = '' }
        @{ ScopeName = 'management group'; Scope = '/providers/Microsoft.Management/managementGroups/test-mg' }
        @{ ScopeName = 'subscription'; Scope = '/subscriptions/11111111-1111-1111-1111-111111111111' }
        @{ ScopeName = 'resource'; Scope = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test-rg/providers/Microsoft.KeyVault/vaults/test-vault' }
    ) {
        $id = "$Scope/providers/Microsoft.Authorization/roleAssignments/22222222-2222-2222-2222-222222222222"

        Invoke-ResourceRemoval -ResourceId $id -Type 'Microsoft.Authorization/roleAssignments' -Confirm:$false

        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'DELETE' -and $Path -eq "$id`?api-version=2022-04-01" -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Get-AzRoleAssignment -Times 0 -Exactly
        Should -Invoke Remove-AzRoleAssignment -Times 0 -Exactly
    }

    It 'Accepts completed or already-absent deletion with HTTP <Status>' -ForEach @(
        @{ Status = 200 }
        @{ Status = 204 }
        @{ Status = 404 }
    ) {
        Mock Invoke-AzRestMethod { @{ StatusCode = $Status; Content = '' } }

        { Invoke-ResourceRemoval -ResourceId $roleId -Type 'Microsoft.Authorization/roleAssignments' -Confirm:$false } |
            Should -Not -Throw
    }

    It 'Does not hide unsuccessful deletion HTTP <Status>' -ForEach @(
        @{ Status = 202 }
        @{ Status = 400 }
        @{ Status = 401 }
        @{ Status = 403 }
        @{ Status = 429 }
        @{ Status = 500 }
    ) {
        Mock Invoke-AzRestMethod { @{ StatusCode = $Status; Content = 'provider failure' } }

        { Invoke-ResourceRemoval -ResourceId $roleId -Type 'Microsoft.Authorization/roleAssignments' -Confirm:$false } |
            Should -Throw "*HTTP $Status*provider failure*"
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
    }

    It 'Preserves transport or authentication errors from the ARM request' {
        Mock Invoke-AzRestMethod { throw 'ARM request authentication failed.' }
        { Invoke-ResourceRemoval -ResourceId $roleId -Type 'Microsoft.Authorization/roleAssignments' -Confirm:$false } |
            Should -Throw '*ARM request authentication failed*'
    }

    It 'Makes no Azure requests for WhatIf' {
        Invoke-ResourceRemoval -ResourceId $roleId -Type 'Microsoft.Authorization/roleAssignments' -WhatIf

        Should -Invoke Get-AzResourceLock -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke Get-AzRoleAssignment -Times 0 -Exactly
        Should -Invoke Remove-AzRoleAssignment -Times 0 -Exactly
    }

    It 'Rejects a mismatched or malformed role ID before lock handling' -ForEach @(
        @{ InvalidId = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test-rg' }
        @{ InvalidId = '/providers/Microsoft.Authorization/roleAssignments/not-a-guid' }
        @{ InvalidId = '/providers/Microsoft.Authorization/roleAssignments/22222222-2222-2222-2222-222222222222?other=query' }
    ) {
        { Invoke-ResourceRemoval -ResourceId $InvalidId -Type 'Microsoft.Authorization/roleAssignments' -Confirm:$false } |
            Should -Throw '*Invalid role assignment resource ID*'
        Should -Invoke Get-AzResourceLock -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }
}
