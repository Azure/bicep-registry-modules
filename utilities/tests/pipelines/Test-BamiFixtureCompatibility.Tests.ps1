param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'BAMI fixture compatibility' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Test-BamiFixtureCompatibility.ps1')
        $context = @{
            TestSubscriptionIds      = '[{"name":"test","id":"10000000-0000-0000-0000-000000000001"}]'
            PersistentSubscriptionId = '20000000-0000-0000-0000-000000000001'
            TenantId                 = '30000000-0000-0000-0000-000000000001'
            ClientId                 = '40000000-0000-0000-0000-000000000001'
            ManagementGroupId        = 'bami-root'
        }
    }

    It 'allows no inherited fixture parameters' {
        { Test-BamiFixtureCompatibility @context -CIParameters @{} } | Should -Not -Throw
    }

    It 'allows references scoped to the frozen test and Persistent subscriptions' {
        $parameters = @{
            networkResourceId = '/subscriptions/10000000-0000-0000-0000-000000000001/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/test'
            fixtures          = @{
                subscriptionId = $context.PersistentSubscriptionId
                resourceIds    = @('/subscriptions/20000000-0000-0000-0000-000000000001/resourceGroups/fixtures/providers/Microsoft.Storage/storageAccounts/fixture')
            }
            tenantId          = $context.TenantId
            clientId          = $context.ClientId
            managementGroupId = $context.ManagementGroupId
            parentResourceId  = '/providers/Microsoft.Management/managementGroups/bami-root'
        }

        { Test-BamiFixtureCompatibility @context -CIParameters $parameters } | Should -Not -Throw
    }

    It 'does not classify neutral credentials, keys, certificates and built-in role IDs as tenant fixtures' {
        $parameters = @{
            password         = ConvertTo-SecureString -String 'not-a-real-password' -AsPlainText -Force
            apiKey           = '50000000-0000-0000-0000-000000000001'
            certificate      = 'not-a-real-certificate'
            roleDefinitionId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
            secureConfig     = @{ key = 'not-a-real-key'; password = '{not-json-password' }
        }

        { Test-BamiFixtureCompatibility @context -CIParameters $parameters } | Should -Not -Throw
    }

    It 'rejects a mismatched or unscoped tenant identifier in <fixtureName>' -ForEach @(
        @{ fixtureName = 'subscriptionId'; fixtureValue = '50000000-0000-0000-0000-000000000001' }
        @{ fixtureName = 'otherTenantId'; fixtureValue = '50000000-0000-0000-0000-000000000001' }
        @{ fixtureName = 'clientId'; fixtureValue = '50000000-0000-0000-0000-000000000001' }
        @{ fixtureName = 'managementGroupId'; fixtureValue = 'legacy-root' }
        @{ fixtureName = 'arbDeploymentSPObjectId'; fixtureValue = '50000000-0000-0000-0000-000000000001' }
        @{ fixtureName = 'principalIds'; fixtureValue = @('50000000-0000-0000-0000-000000000001') }
        @{ fixtureName = 'managedIdentityId'; fixtureValue = '50000000-0000-0000-0000-000000000001' }
    ) {
        { Test-BamiFixtureCompatibility @context -CIParameters @{ $fixtureName = $fixtureValue } } |
            Should -Throw '*unsupported tenant-bound identifier*'
    }

    It 'rejects legacy ARM scope references inside <representation> values without logging their contents' -ForEach @(
        @{ representation = 'string' }
        @{ representation = 'secureString' }
        @{ representation = 'object' }
        @{ representation = 'JSON string' }
    ) {
        $resourceId = '/subscriptions/50000000-0000-0000-0000-000000000001/resourceGroups/sensitive-fixture/providers/Microsoft.Network/virtualNetworks/fixture'
        $value = switch ($representation) {
            'string' { $resourceId }
            'secureString' { ConvertTo-SecureString -String $resourceId -AsPlainText -Force }
            'object' { @{ networks = @(@{ resourceId = $resourceId }) } }
            'JSON string' { ConvertTo-Json -InputObject @{ networks = @(@{ resourceId = $resourceId }) } -Depth 5 -Compress }
        }
        $failure = $null
        try {
            Test-BamiFixtureCompatibility @context -CIParameters @{ fixture = $value }
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'outside the frozen test/Persistent context'
        $failure.Exception.Message | Should -Not -Match '50000000|sensitive-fixture'
    }

    It 'rejects a mismatched management-group resource ID in an otherwise neutral parameter name' {
        $parameters = @{ parent = '/providers/Microsoft.Management/managementGroups/legacy-root' }

        { Test-BamiFixtureCompatibility @context -CIParameters $parameters } | Should -Throw '*management group outside the frozen context*'
    }

    It 'checks directory identities inside a JSON-valued secure string' {
        $parameters = @{
            fixture = ConvertTo-SecureString -String '{"principalId":"50000000-0000-0000-0000-000000000001"}' -AsPlainText -Force
        }

        { Test-BamiFixtureCompatibility @context -CIParameters $parameters } | Should -Throw '*unsupported tenant-bound identifier*'
    }

    It 'rejects foreign ARM identity-map keys in <representation> without exposing their contents' -ForEach @(
        @{ representation = 'object' }
        @{ representation = 'JSON string' }
        @{ representation = 'secureString' }
    ) {
        $resourceId = '/subscriptions/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/resourceGroups/sensitive-key/providers/Microsoft.ManagedIdentity/userAssignedIdentities/legacy'
        $deployment = @{ identity = @{ userAssignedIdentities = @{ $resourceId = @{} } } }
        $json = ConvertTo-Json -InputObject $deployment -Depth 6 -Compress
        $value = switch ($representation) {
            'object' { $deployment }
            'JSON string' { $json }
            'secureString' { ConvertTo-SecureString -String $json -AsPlainText -Force }
        }
        $failure = $null
        try {
            Test-BamiFixtureCompatibility @context -CIParameters @{ deployment = $value }
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'outside the frozen test/Persistent context'
        $failure.Exception.Message | Should -Not -Match 'aaaaaaaa|sensitive-key|userAssignedIdentities/legacy'
    }

    It 'allows frozen test, Persistent and management-group keys in <representation>' -ForEach @(
        @{ representation = 'object' }
        @{ representation = 'JSON string' }
        @{ representation = 'secureString' }
    ) {
        $deployment = @{
            identity = @{
                userAssignedIdentities = @{
                    '/subscriptions/10000000-0000-0000-0000-000000000001/resourceGroups/test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test'           = @{}
                    '/subscriptions/20000000-0000-0000-0000-000000000001/resourceGroups/fixtures/providers/Microsoft.ManagedIdentity/userAssignedIdentities/persistent' = @{}
                }
            }
            scopes   = @{ '/providers/Microsoft.Management/managementGroups/bami-root' = @{} }
        }
        $json = ConvertTo-Json -InputObject $deployment -Depth 6 -Compress
        $value = switch ($representation) {
            'object' { $deployment }
            'JSON string' { $json }
            'secureString' { ConvertTo-SecureString -String $json -AsPlainText -Force }
        }

        { Test-BamiFixtureCompatibility @context -CIParameters @{ deployment = $value } } | Should -Not -Throw
    }

    It 'checks root dictionary keys without logging a resource ID as the parameter name' {
        $resourceId = '/subscriptions/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/resourceGroups/sensitive-key'
        $failure = $null
        try {
            Test-BamiFixtureCompatibility @context -CIParameters @{ $resourceId = @{} }
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'outside the frozen test/Persistent context'
        $failure.Exception.Message | Should -Not -Match 'aaaaaaaa|sensitive-key'
    }

    It 'rejects foreign management-group dictionary keys' {
        $parameters = @{ scopes = @{ '/providers/Microsoft.Management/managementGroups/legacy-root' = @{} } }

        { Test-BamiFixtureCompatibility @context -CIParameters $parameters } | Should -Throw '*management group outside the frozen context*'
    }

    It 'does not interpret property and credential key names as identifier values' {
        $parameters = @{
            credentials = @{
                tenantId = $context.TenantId
                clientId = $context.ClientId
                password = 'not-a-real-password'
                apiKey   = '50000000-0000-0000-0000-000000000001'
            }
        }

        { Test-BamiFixtureCompatibility @context -CIParameters $parameters } | Should -Not -Throw
    }
}
