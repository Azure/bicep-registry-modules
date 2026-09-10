param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Copy-CIKeyVaultSecretsToGitHub' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'tools' 'Copy-CIKeyVaultSecretsToGitHub.ps1')

        # A local stub keeps these tests independent of Az installation and authentication.
        function Get-AzKeyVaultSecret {
            [CmdletBinding()]
            param(
                [string] $VaultName,
                [string] $Name,
                [string] $Version,
                [switch] $IncludeVersions
            )
            throw 'Get-AzKeyVaultSecret must be mocked.'
        }

        function New-TestSecretMetadata {
            param(
                [string] $Name = 'CI-clientSecret',
                [string] $Version = 'version-one',
                [DateTimeOffset] $Created = '2026-01-01T00:00:00Z',
                [bool] $Enabled = $true
            )
            [pscustomobject]@{
                Name      = $Name
                Version   = $Version
                Created   = $Created
                Enabled   = $Enabled
                Expires   = $null
                NotBefore = $null
            }
        }
    }

    BeforeEach {
        $script:sources = @(New-TestSecretMetadata)
        $script:versions = @(New-TestSecretMetadata)
        $script:secretNames = @()
        $script:variableNames = @()
        $script:lateSecretNames = @()
        $script:lateVariableNames = @()
        $script:listCounts = @{ secret = 0; variable = 0 }
        $script:payload = 'synthetic-test-value'
        $script:writes = [System.Collections.Generic.List[object]]::new()

        Mock Get-Command {
            [pscustomobject]@{ Path = 'mock-gh' }
        } -ParameterFilter { $Name -eq 'gh' -and $CommandType -eq 'Application' }

        Mock Get-AzKeyVaultSecret {
            if (-not $Name) {
                return $script:sources
            }
            if ($IncludeVersions) {
                return $script:versions
            }
            [pscustomobject]@{
                Name        = $Name
                Version     = $Version
                Enabled     = $true
                SecretValue = ConvertTo-SecureString -String $script:payload -AsPlainText -Force
            }
        }

        Mock Invoke-CIGitHubCommand {
            if ($ArgumentList[1] -eq 'list') {
                $kind = $ArgumentList[0]
                $script:listCounts[$kind]++
                $names = $kind -eq 'secret' ? $script:secretNames : $script:variableNames
                if ($script:listCounts[$kind] -gt 1) {
                    $names += $kind -eq 'secret' ? $script:lateSecretNames : $script:lateVariableNames
                }
                return ConvertTo-Json -InputObject @($names | ForEach-Object { @{ name = $_ } }) -Compress
            }
            if ($ArgumentList[1] -eq 'set') {
                $script:writes.Add([pscustomobject]@{
                        Arguments = @($ArgumentList)
                        Value     = [System.Net.NetworkCredential]::new('', $InputValue).Password
                    })
                return
            }
            throw 'Unexpected GitHub command.'
        }
    }

    AfterEach {
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter {
            $ArgumentList -contains '--body' -or $ArgumentList -contains '--env-file' -or $ArgumentList -contains 'delete'
        }
    }

    It 'Defaults to a metadata-only dry run with secret classification' {
        $result = @(Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo')

        $result.Count | Should -Be 1
        $result[0].SourceName | Should -Be 'CI-clientSecret'
        $result[0].DestinationName | Should -BeExactly 'CI_CLIENT_SECRET'
        $result[0].Kind | Should -Be 'Secret'
        $result[0].Status | Should -Be 'Planned'
        $result[0].Scope | Should -Be 'Repository'
        $result[0].Environment | Should -Be ''
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { -not $Name }
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Does not retrieve values or write with Apply and WhatIf, including overwrite previews' {
        $script:secretNames = @('CI_CLIENTSECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -WhatIf

        $result.Status | Should -Be 'SkippedShouldProcess'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Filters only the anchored CI- prefix and emits readable names' {
        $script:sources = @(
            New-TestSecretMetadata -Name 'ci-clientId'
            New-TestSecretMetadata -Name 'CI-location'
            New-TestSecretMetadata -Name 'other-CI-clientId'
            New-TestSecretMetadata -Name 'CI_clientId'
            New-TestSecretMetadata -Name 'unrelated-with-hyphens'
        )

        $result = @(Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo')

        $result.DestinationName | Should -Be @('CI_CLIENT_ID', 'CI_LOCATION')
        $result.Kind | Should -Be @('Secret', 'Secret')
    }

    It 'Imports CI-fooBar as the readable CI_FOO_BAR name by default' {
        $script:sources = @(New-TestSecretMetadata -Name 'CI-fooBar')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false

        $result.DestinationName | Should -BeExactly 'CI_FOO_BAR'
        $result.Status | Should -Be 'Copied'
        ($script:writes[0].Arguments -join '|') | Should -Be 'secret|set|CI_FOO_BAR|--repo|owner/repo'
    }

    It 'Copies only reviewed source names, ignoring unselected invalid legacy names' {
        $script:sources += @(
            New-TestSecretMetadata -Name 'CI-location'
            New-TestSecretMetadata -Name 'CI-legacy-invalid-name'
        )

        $result = @(Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName 'ci-CLIENTSECRET', 'CI-clientSecret' -Apply -Confirm:$false)

        $result.Count | Should -Be 1
        $result[0].SourceName | Should -BeExactly 'CI-clientSecret'
        $result[0].DestinationName | Should -BeExactly 'CI_CLIENT_SECRET'
        $result[0].Kind | Should -Be 'Secret'
        $result[0].Status | Should -Be 'Copied'
        $script:writes.Count | Should -Be 1
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { $Name -eq 'CI-clientSecret' -and -not $IncludeVersions }
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -and $Name -ne 'CI-clientSecret' }
    }

    It 'Keeps an explicit source allowlist metadata-only during <mode>' -ForEach @(
        @{ mode = 'dry run'; useApply = $false; useWhatIf = $false; expectedStatus = 'Planned' }
        @{ mode = 'WhatIf'; useApply = $true; useWhatIf = $true; expectedStatus = 'SkippedShouldProcess' }
    ) {
        $script:sources += New-TestSecretMetadata -Name 'CI-legacy-invalid-name'

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName 'CI-clientSecret' -Apply:$useApply -WhatIf:$useWhatIf

        $result.Status | Should -Be $expectedStatus
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Rejects an explicitly <description> source allowlist instead of copying everything' -ForEach @(
        @{ description = 'empty'; selection = @() }
        @{ description = 'null'; selection = $null }
    ) {
        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName $selection -Apply -Confirm:$false } | Should -Throw '*SecretName was explicitly empty*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly
    }

    It 'Rejects unrecognized or non-source selection <selection> before any copy' -ForEach @(
        @{ selection = 'CI-misspelled'; expectedMessage = '*does not match a source secret*' }
        @{ selection = 'CI-client*'; expectedMessage = '*does not match a source secret*' }
        @{ selection = 'CI-client_secret'; expectedMessage = '*does not match a source secret*' }
        @{ selection = 'CI_CLIENTSECRET'; expectedMessage = '*must be an exact CI- Key Vault source name*' }
        @{ selection = 'other-clientSecret'; expectedMessage = '*must be an exact CI- Key Vault source name*' }
        @{ selection = ''; expectedMessage = '*must be an exact CI- Key Vault source name*' }
    ) {
        {
            Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName @('CI-clientSecret', $selection) -Apply -Confirm:$false
        } | Should -Throw $expectedMessage

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Still validates an explicitly selected legacy name rather than rewriting its suffix' {
        $script:sources += New-TestSecretMetadata -Name 'CI-client-secret'

        {
            Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName 'CI-client-secret' -Apply -Confirm:$false
        } | Should -Throw '*Cannot map*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Allows non-sensitive variable selection only within the selected source plan' {
        $script:sources += New-TestSecretMetadata -Name 'CI-location'

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName 'ci-LOCATION' -VariableName 'ci_location' -Apply -Confirm:$false

        $result.SourceName | Should -BeExactly 'CI-location'
        $result.DestinationName | Should -BeExactly 'CI_LOCATION'
        $result.Kind | Should -Be 'Variable'
        $script:writes.Count | Should -Be 1
        ($script:writes[0].Arguments -join '|') | Should -Be 'variable|set|CI_LOCATION|--repo|owner/repo'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -eq 'CI-clientSecret' }
    }

    It 'Rejects variable selection for an excluded source instead of extending the allowlist' {
        $script:sources += New-TestSecretMetadata -Name 'CI-location'

        {
            Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -SecretName 'CI-clientSecret' -VariableName 'CI_LOCATION' -Apply -Confirm:$false
        } | Should -Throw '*does not match a planned CI_ destination name*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Inventories both destination kinds using only --json name and no stdin payload' {
        $null = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo'

        Should -Invoke Invoke-CIGitHubCommand -Times 1 -Exactly -ParameterFilter {
            ($ArgumentList -join '|') -eq 'secret|list|--repo|owner/repo|--json|name' -and $null -eq $InputValue
        }
        Should -Invoke Invoke-CIGitHubCommand -Times 1 -Exactly -ParameterFilter {
            ($ArgumentList -join '|') -eq 'variable|list|--repo|owner/repo|--json|name' -and $null -eq $InputValue
        }
    }

    It 'Copies secrets by default and opts only explicit case-insensitive names into variables' {
        $script:sources += New-TestSecretMetadata -Name 'CI-location'

        $result = @(Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName 'ci_location' -Apply -Confirm:$false)

        $result.Kind | Should -Be @('Secret', 'Variable')
        $result.Status | Should -Be @('Copied', 'Copied')
        ($script:writes[0].Arguments -join '|') | Should -Be 'secret|set|CI_CLIENT_SECRET|--repo|owner/repo'
        ($script:writes[1].Arguments -join '|') | Should -Be 'variable|set|CI_LOCATION|--repo|owner/repo'
        ($result | ConvertTo-Json) | Should -Not -Match ([regex]::Escape($script:payload))
        $result[0].PSObject.Properties.Name | Should -Be @(
            'VaultName', 'SourceName', 'DestinationName', 'Repository', 'Environment', 'Scope', 'Kind', 'Status'
        )
    }

    It 'Uses <scope> scope consistently for inventory, rechecks, and writes' -ForEach @(
        @{ scope = 'Repository'; environment = '' }
        @{ scope = 'Environment'; environment = 'CI validation' }
    ) {
        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Environment $environment -Apply -Confirm:$false

        $result.Scope | Should -Be $scope
        $result.Environment | Should -Be $environment
        $expectedSuffix = $environment ? "|--env|$environment" : ''
        ($script:writes[0].Arguments -join '|') | Should -Be "secret|set|CI_CLIENT_SECRET|--repo|owner/repo$expectedSuffix"
        Should -Invoke Invoke-CIGitHubCommand -Times 4 -Exactly -ParameterFilter {
            $ArgumentList[1] -eq 'list' -and ($ArgumentList -join '|').EndsWith("--json|name$expectedSuffix")
        }
    }

    It 'Skips existing same-kind <kind> entries without overwriting or reading a value' -ForEach @(
        @{ kind = 'Secret'; variables = @() }
        @{ kind = 'Variable'; variables = @('CI_CLIENTSECRET') }
    ) {
        if ($kind -eq 'Secret') {
            $script:secretNames = @('ci_clientsecret')
        } else {
            $script:variableNames = @('ci_clientsecret')
        }

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName $variables -Apply -Confirm:$false

        $result.Status | Should -Be 'SkippedExisting'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Requires Apply even when Overwrite was selected' {
        $script:secretNames = @('CI_CLIENTSECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Overwrite

        $result.Status | Should -Be 'PlannedOverwrite'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Reuses an existing <alias> instead of creating a conflicting name' -ForEach @(
        @{ alias = 'CI_CLIENTSECRET'; applyCopy = $false; expectedStatus = 'PlannedOverwrite' }
        @{ alias = 'CI__CLIENTSECRET'; applyCopy = $true; expectedStatus = 'Copied' }
        @{ alias = 'CI_CLIENT_SECRET'; applyCopy = $true; expectedStatus = 'Copied' }
    ) {
        $script:secretNames = @($alias)

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Overwrite -Apply:$applyCopy -Confirm:$false

        $result.DestinationName | Should -BeExactly $alias
        $result.Status | Should -Be $expectedStatus
        if ($applyCopy) {
            $script:writes[0].Arguments[2] | Should -BeExactly $alias
        } else {
            Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        }
    }

    It 'Selects CI_ over CI__ for existing <kind> aliases [reverse: <reverse>]' -ForEach @(
        @{ kind = 'Secret'; reverse = $false; variables = @() }
        @{ kind = 'Secret'; reverse = $true; variables = @() }
        @{ kind = 'Variable'; reverse = $false; variables = @('CI_CLIENT_SECRET') }
        @{ kind = 'Variable'; reverse = $true; variables = @('CI_CLIENT_SECRET') }
    ) {
        $aliases = $reverse ? @('CI__CLIENTSECRET', 'CI_CLIENT_SECRET') : @('CI_CLIENT_SECRET', 'CI__CLIENTSECRET')
        if ($kind -eq 'Secret') {
            $script:secretNames = $aliases
        } else {
            $script:variableNames = $aliases
        }

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName $variables -Apply -Confirm:$false

        $result.DestinationName | Should -BeExactly 'CI_CLIENT_SECRET'
        $result.Status | Should -Be 'SkippedExisting'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Overwrites only the preferred CI_ <kind> alias when explicitly approved' -ForEach @(
        @{ kind = 'Secret'; variables = @() }
        @{ kind = 'Variable'; variables = @('CI_CLIENT_SECRET') }
    ) {
        if ($kind -eq 'Secret') {
            $script:secretNames = @('CI__CLIENTSECRET', 'CI_CLIENT_SECRET')
        } else {
            $script:variableNames = @('CI_CLIENT_SECRET', 'CI__CLIENTSECRET')
        }

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName $variables -Apply -Overwrite -Confirm:$false

        $result.DestinationName | Should -BeExactly 'CI_CLIENT_SECRET'
        $result.Status | Should -Be 'Copied'
        $script:writes.Count | Should -Be 1
        $script:writes[0].Arguments[2] | Should -BeExactly 'CI_CLIENT_SECRET'
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter {
            $ArgumentList[1] -eq 'set' -and $ArgumentList[2] -eq 'CI__CLIENTSECRET'
        }
    }

    It 'Blocks multiple aliases within the winning prefix even with explicit overwrite' {
        $script:secretNames = @('CI_CLIENTSECRET', 'CI_CLIENT_SECRET', 'CI__CLIENTSECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedByAmbiguousAliases'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Blocks new ambiguity found after the preview' {
        $script:secretNames = @('CI_CLIENTSECRET')
        $script:lateSecretNames = @('CI_CLIENT_SECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedByAmbiguousAliases'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
    }

    It 'Keeps the approved CI_ destination when a lower-priority exact alias appears' {
        $script:secretNames = @('CI_CLIENT_SECRET')
        $script:lateSecretNames = @('CI__CLIENTSECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'Copied'
        $script:writes[0].Arguments[2] | Should -BeExactly 'CI_CLIENT_SECRET'
    }

    It 'Blocks a new higher-priority alias instead of retargeting an approved exact alias' {
        $script:secretNames = @('CI__CLIENTSECRET')
        $script:lateSecretNames = @('CI_CLIENT_SECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedChangedDestination'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Does not retarget an approved copy when a different alias appears' {
        $script:lateSecretNames = @('CI__CLIENTSECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedChangedDestination'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
    }

    It 'Does not recreate an alias removed after approval' {
        Mock Invoke-CIGitHubCommand {
            $script:listCounts.secret++
            if ($script:listCounts.secret -eq 1) {
                return '[{"name":"CI__CLIENTSECRET"}]'
            }
            return '[]'
        } -ParameterFilter { $ArgumentList[0] -eq 'secret' -and $ArgumentList[1] -eq 'list' }

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedChangedDestination'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
    }

    It 'Matches opposite-kind aliases by parameter identity rather than spelling' {
        $script:variableNames = @('CI__CLIENTSECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedByOppositeKind'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
    }

    It 'Separates camelCase and literal underscore inputs during migration' {
        $script:sources = @(
            New-TestSecretMetadata -Name 'CI-resourceName'
            New-TestSecretMetadata -Name 'CI-resource_name'
        )
        $script:secretNames = @('CI__RESOURCE_NAME')

        $result = @(Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo')

        $result.DestinationName | Should -Be @('CI_RESOURCE_NAME', 'CI__RESOURCE_NAME')
        $result.Status | Should -Be @('Planned', 'SkippedExisting')
    }

    It 'Preserves acronym boundaries and avoids the reserved vault selector' {
        $script:sources = @(
            New-TestSecretMetadata -Name 'CI-managedHSMResourceId'
            New-TestSecretMetadata -Name 'CI-keyVaultName'
        )
        $script:variableNames = @('CI_KEY_VAULT_NAME')

        $result = @(Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName 'CI__KEYVAULTNAME')

        $result.DestinationName | Should -Be @('CI_MANAGED_HSM_RESOURCE_ID', 'CI__KEYVAULTNAME')
        $result.Kind | Should -Be @('Secret', 'Variable')
        $result.Status | Should -Be @('Planned', 'Planned')
    }

    It 'Accepts an exact VariableName alias for a selected camelCase source' {
        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName 'CI__CLIENTSECRET'

        $result.Kind | Should -Be 'Variable'
        $result.DestinationName | Should -Be 'CI_CLIENT_SECRET'
    }

    It 'Deliberately overwrites same-kind <kind> entries only when requested' -ForEach @(
        @{ kind = 'Secret'; variables = @() }
        @{ kind = 'Variable'; variables = @('CI_CLIENTSECRET') }
    ) {
        if ($kind -eq 'Secret') {
            $script:secretNames = @('CI_CLIENTSECRET')
        } else {
            $script:variableNames = @('CI_CLIENTSECRET')
        }

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName $variables -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'Copied'
        $script:writes.Count | Should -Be 1
        $script:writes[0].Arguments[0] | Should -Be $kind.ToLowerInvariant()
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { $Name -and -not $IncludeVersions }
    }

    It 'Blocks opposite-kind collisions for <kind> even with Overwrite' -ForEach @(
        @{ kind = 'Secret'; variables = @() }
        @{ kind = 'Variable'; variables = @('CI_CLIENTSECRET') }
    ) {
        if ($kind -eq 'Secret') {
            $script:variableNames = @('CI_CLIENTSECRET')
        } else {
            $script:secretNames = @('CI_CLIENTSECRET')
        }

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName $variables -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedByOppositeKind'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Blocks a name already present in both kinds' {
        $script:secretNames = @('CI_CLIENTSECRET')
        $script:variableNames = @('CI_CLIENTSECRET')

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite -Confirm:$false

        $result.Status | Should -Be 'BlockedByOppositeKind'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
    }

    It 'Detects newly created <kind> collisions in the last metadata recheck' -ForEach @(
        @{ kind = 'Secret'; overwrite = $false; status = 'SkippedExisting' }
        @{ kind = 'Variable'; overwrite = $true; status = 'BlockedByOppositeKind' }
    ) {
        if ($kind -eq 'Secret') {
            $script:lateSecretNames = @('CI_CLIENTSECRET')
        } else {
            $script:lateVariableNames = @('CI_CLIENTSECRET')
        }

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Overwrite:$overwrite -Confirm:$false

        $result.Status | Should -Be $status
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Rejects unrepresentable source name <sourceName> before any write' -ForEach @(
        @{ sourceName = 'CI-client-secret' }
        @{ sourceName = 'CI-' }
        @{ sourceName = 'CI-123name' }
        @{ sourceName = ('CI-na{0}ve' -f [char]0x00ef) }
        @{ sourceName = 'CI-name.with.dot' }
        @{ sourceName = ('CI-' + ('x' * 98)) }
    ) {
        $script:sources += New-TestSecretMetadata -Name $sourceName

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false } | Should -Throw '*Cannot map*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Rejects case-insensitive source mappings that would collapse into one destination' {
        $script:sources += New-TestSecretMetadata -Name 'ci-CLIENTSECRET'

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false } | Should -Throw '*Multiple source names*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
    }

    It 'Rejects an unmatched VariableName <selection> before any copy' -ForEach @(
        @{ selection = 'CI_MISSPELLED' }
        @{ selection = 'CI-clientSecret' }
        @{ selection = '' }
        @{ selection = '  ' }
    ) {
        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName $selection -Apply -Confirm:$false } | Should -Throw '*does not match a planned*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Rejects a whitespace-only environment rather than selecting another scope' {
        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Environment '  ' } | Should -Throw '*Environment must*'
    }

    It 'Reports disabled, expired, and not-yet-valid sources without reading values' {
        $disabled = New-TestSecretMetadata -Name 'CI-disabled' -Enabled $false
        $expired = New-TestSecretMetadata -Name 'CI-expired'
        $expired.Expires = [DateTimeOffset]::UtcNow.AddDays(-1)
        $future = New-TestSecretMetadata -Name 'CI-future'
        $future.NotBefore = [DateTimeOffset]::UtcNow.AddDays(1)
        $script:sources = @($disabled, $expired, $future)

        $result = @(Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false)

        $result.Status | Should -Be @('SkippedDisabled', 'SkippedExpired', 'SkippedNotYetValid')
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Pins the version supplied by source inventory' {
        $null = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false

        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'CI-clientSecret' -and $Version -eq 'version-one' -and -not $IncludeVersions
        }
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $IncludeVersions }
    }

    It 'Pins the uniquely newest metadata-only version when the vault list has no version' {
        $script:sources[0].Version = ''
        $script:versions = @(
            New-TestSecretMetadata -Version 'newest' -Created '2026-02-01T00:00:00Z'
            New-TestSecretMetadata -Version 'oldest' -Created '2026-01-01T00:00:00Z'
        )

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false

        $result.Status | Should -Be 'Copied'
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { $IncludeVersions }
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { $Version -eq 'newest' }
    }

    It 'Does not fall back to an older enabled version when the newest version is disabled' {
        $script:sources[0].Version = ''
        $script:versions = @(
            New-TestSecretMetadata -Version 'older' -Created '2026-01-01T00:00:00Z'
            New-TestSecretMetadata -Version 'newest' -Created '2026-02-01T00:00:00Z' -Enabled $false
        )

        $result = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false

        $result.Status | Should -Be 'SkippedDisabled'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -and -not $IncludeVersions }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Fails rather than guessing when version metadata is <description>' -ForEach @(
        @{ description = 'missing'; versionCase = 'missing' }
        @{ description = 'ambiguous'; versionCase = 'ambiguous' }
        @{ description = 'incomplete'; versionCase = 'incomplete' }
    ) {
        $script:sources[0].Version = ''
        switch ($versionCase) {
            'missing' { $script:versions = @() }
            'ambiguous' { $script:versions += New-TestSecretMetadata -Version 'same-time' }
            'incomplete' { $script:versions[0].Created = $null }
        }

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false } | Should -Throw '*Cannot pin*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -and -not $IncludeVersions }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Preserves quotes, Unicode, whitespace, multiline content, and trailing newlines for <kind>' -ForEach @(
        @{ kind = 'Secret'; variables = @() }
        @{ kind = 'Variable'; variables = @('CI_CLIENTSECRET') }
    ) {
        $script:payload = "  `"quoted`" 'single' $([char]0x00e9) $([char]::ConvertFromUtf32(0x1f510))`r`nsecond line`n`n"

        $null = Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -VariableName $variables -Apply -Confirm:$false

        $script:writes[0].Value | Should -BeExactly $script:payload
        ($script:writes[0].Arguments -join '|') | Should -Not -Match ([regex]::Escape($script:payload))
    }

    It 'Stops when the GitHub CLI prerequisite is missing without touching Key Vault' {
        Mock Get-Command { throw [System.Management.Automation.CommandNotFoundException]::new('Command not found.') } -ParameterFilter { $Name -eq 'gh' -and $CommandType -eq 'Application' }

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' } | Should -Throw '*must be installed on PATH*'

        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly
    }

    It 'Stops visibly when source metadata cannot be read' {
        Mock Get-AzKeyVaultSecret { Write-Error 'Synthetic metadata failure.' -ErrorAction Stop } -ParameterFilter { -not $Name }

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false } | Should -Throw '*Cannot inventory Key Vault*'

        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly
    }

    It 'Surfaces Key Vault failures without disclosing the underlying exception value' {
        Mock Get-AzKeyVaultSecret { Write-Error "Upstream failure: $script:payload" -ErrorAction Stop } -ParameterFilter { $Name -and -not $IncludeVersions }

        $failure = $null
        try {
            Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'Cannot read the pinned version'
        $failure.Exception.ToString() | Should -Not -Match ([regex]::Escape($script:payload))
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Fails when the approved source has no accessible value' {
        Mock Get-AzKeyVaultSecret { return $null } -ParameterFilter { $Name -and -not $IncludeVersions }

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false } | Should -Throw '*no accessible, non-empty value*'

        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Rejects a value that became <state> after source inventory' -ForEach @(
        @{ state = 'disabled'; expectedMessage = '*now disabled*' }
        @{ state = 'expired'; expectedMessage = '*outside its validity period*' }
        @{ state = 'not yet valid'; expectedMessage = '*outside its validity period*' }
        @{ state = 'empty'; expectedMessage = '*no accessible, non-empty value*' }
    ) {
        Mock Get-AzKeyVaultSecret {
            [pscustomobject]@{
                Version     = $Version
                Enabled     = $state -ne 'disabled'
                Expires     = $state -eq 'expired' ? [DateTimeOffset]::UtcNow.AddDays(-1) : $null
                NotBefore   = $state -eq 'not yet valid' ? [DateTimeOffset]::UtcNow.AddDays(1) : $null
                SecretValue = $state -eq 'empty' ? [System.Security.SecureString]::new() : (ConvertTo-SecureString -String $script:payload -AsPlainText -Force)
            }
        } -ParameterFilter { $Name -and -not $IncludeVersions }

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false } | Should -Throw $expectedMessage

        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Fails if the returned value does not match the pinned version' {
        Mock Get-AzKeyVaultSecret {
            [pscustomobject]@{
                Version     = 'unexpected-version'
                Enabled     = $true
                SecretValue = ConvertTo-SecureString -String $script:payload -AsPlainText -Force
            }
        } -ParameterFilter { $Name -and -not $IncludeVersions }

        { Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false } | Should -Throw '*did not return the pinned version*'

        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }

    It 'Propagates native write failure and never reports a copied entry' {
        Mock Invoke-CIGitHubCommand { throw 'GitHub CLI exited with code [17]. Native output is suppressed to protect values.' } -ParameterFilter { $ArgumentList[1] -eq 'set' }
        $result = [System.Collections.Generic.List[object]]::new()

        {
            Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false | ForEach-Object { $result.Add($_) }
        } | Should -Throw '*code *17*'

        $result.Count | Should -Be 0
    }

    It 'Rejects malformed <kind> inventories without echoing response data or copying' -ForEach @(
        @{ kind = 'secret'; response = 'not-json' }
        @{ kind = 'variable'; response = '{"name":"CI_CLIENTSECRET"}' }
        @{ kind = 'variable'; response = '[{"value":"synthetic-test-value"}]' }
    ) {
        Mock Invoke-CIGitHubCommand { $response } -ParameterFilter { $ArgumentList[1] -eq 'list' -and $ArgumentList[0] -eq $kind }

        $failure = $null
        try {
            Copy-CIKeyVaultSecretsToGitHub -VaultName 'ci-vault' -Repository 'owner/repo' -Apply -Confirm:$false
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'Invalid'
        $failure.Exception.ToString() | Should -Not -Match ([regex]::Escape($script:payload))
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name }
        Should -Invoke Invoke-CIGitHubCommand -Times 0 -Exactly -ParameterFilter { $ArgumentList[1] -eq 'set' }
    }
}

Describe 'Invoke-CIGitHubCommand stdin transport' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'tools' 'Copy-CIKeyVaultSecretsToGitHub.ps1')
    }

    BeforeEach {
        $script:payload = "  `"quoted`" 'single' $([char]0x00e9) $([char]::ConvertFromUtf32(0x1f510))`r`nsecond line`n`n"
        $script:process = [pscustomobject]@{
            StartInfo      = $null
            StandardInput  = [System.IO.StringWriter]::new()
            StandardOutput = [System.IO.StringReader]::new('synthetic stdout')
            StandardError  = [System.IO.StringReader]::new('synthetic stderr')
            ExitCode       = 0
            HasExited      = $true
            Started        = $false
            Waited         = $false
            Disposed       = $false
            Killed         = $false
        }
        $script:process | Add-Member -MemberType ScriptMethod -Name Start -Value { $this.Started = $true; return $true }
        $script:process | Add-Member -MemberType ScriptMethod -Name WaitForExit -Value { $this.Waited = $true }
        $script:process | Add-Member -MemberType ScriptMethod -Name Kill -Value { $this.Killed = $true; $this.HasExited = $true }
        $script:process | Add-Member -MemberType ScriptMethod -Name Dispose -Value {
            $this.Disposed = $true
            $this.StandardInput.Dispose()
            $this.StandardOutput.Dispose()
            $this.StandardError.Dispose()
        }
        Mock New-Object { $script:process } -ParameterFilter { $TypeName -eq 'System.Diagnostics.Process' }
        $script:securePayload = ConvertTo-SecureString -String $script:payload -AsPlainText -Force
    }

    AfterEach {
        $script:securePayload.Dispose()
    }

    It 'Preserves trailing line endings for <kind> using quoted dotenv data on stdin' -ForEach @(
        @{ kind = 'secret' }
        @{ kind = 'variable' }
    ) {
        $arguments = @($kind, 'set', 'CI_CLIENTSECRET', '--repo', 'owner/repo', '--env', 'CI validation')

        $result = @(Invoke-CIGitHubCommand -ExecutablePath 'mock-gh' -ArgumentList $arguments -InputValue $script:securePayload)

        $result.Count | Should -Be 0
        $expectedBody = 'CI_CLIENTSECRET="  \"quoted\" ''single'' {0} {1}\r\nsecond line\n\n"' -f [char]0x00e9, [char]::ConvertFromUtf32(0x1f510)
        $script:process.StandardInput.ToString() | Should -BeExactly $expectedBody
        $script:process.StartInfo.ArgumentList | Should -Be ($arguments + @('--env-file', '-'))
        $script:process.StartInfo.StandardInputEncoding.WebName | Should -Be 'utf-8'
        $script:process.StartInfo.StandardInputEncoding.GetPreamble().Length | Should -Be 0
        $script:process.StartInfo.UseShellExecute | Should -BeFalse
        $script:process.StartInfo.RedirectStandardInput | Should -BeTrue
        $script:process.StartInfo.RedirectStandardOutput | Should -BeTrue
        $script:process.StartInfo.RedirectStandardError | Should -BeTrue
        $script:process.StartInfo.Environment['GH_HOST'] | Should -Be 'github.com'
        $script:process.StartInfo.Environment['GH_PROMPT_DISABLED'] | Should -Be '1'
        $script:process.StartInfo.Environment.ContainsKey('GH_DEBUG') | Should -BeFalse
        $script:process.Started | Should -BeTrue
        $script:process.Waited | Should -BeTrue
        $script:process.Disposed | Should -BeTrue
    }

    It 'Uses unmodified raw stdin when no trailing line ending would be trimmed' {
        $value = '  quotes" '' literal $VALUE ${VALUE} backslash\'
        $secureValue = ConvertTo-SecureString -String $value -AsPlainText -Force
        $arguments = @('secret', 'set', 'CI_CLIENTSECRET', '--repo', 'owner/repo')
        try {
            $null = Invoke-CIGitHubCommand -ExecutablePath 'mock-gh' -ArgumentList $arguments -InputValue $secureValue
        } finally {
            $secureValue.Dispose()
        }

        $script:process.StandardInput.ToString() | Should -BeExactly $value
        $script:process.StartInfo.ArgumentList | Should -Be $arguments
    }

    It 'Escapes dotenv metacharacters to prevent interpolation or additional entries' {
        $value = 'literal $TOKEN ${TOKEN} $(TOKEN) \n \" # comment' + "`n" + 'CI_UNEXPECTED=not-an-entry' + "`r`n"
        $secureValue = ConvertTo-SecureString -String $value -AsPlainText -Force
        try {
            $null = Invoke-CIGitHubCommand -ExecutablePath 'mock-gh' -ArgumentList @('variable', 'set', 'CI_CLIENTSECRET', '--repo', 'owner/repo') -InputValue $secureValue
        } finally {
            $secureValue.Dispose()
        }

        $script:process.StandardInput.ToString() | Should -BeExactly 'CI_CLIENTSECRET="literal \$TOKEN \${TOKEN} \$(TOKEN) \\n \\\" # comment\nCI_UNEXPECTED=not-an-entry\r\n"'
        $script:process.StandardInput.ToString() | Should -Not -Match '[\r\n]'
    }

    It 'Returns only name-list stdout for a metadata inventory command' {
        $script:process.StandardOutput = [System.IO.StringReader]::new('[{"name":"CI_CLIENTSECRET"}]')

        $result = Invoke-CIGitHubCommand -ExecutablePath 'mock-gh' -ArgumentList @('secret', 'list', '--repo', 'owner/repo', '--json', 'name')

        $result | Should -BeExactly '[{"name":"CI_CLIENTSECRET"}]'
        $script:process.StandardInput.ToString() | Should -Be ''
        $script:process.Disposed | Should -BeTrue
    }

    It 'Surfaces the exit code but never stdout or stderr containing the value' {
        $script:process.StandardOutput = [System.IO.StringReader]::new($script:payload)
        $script:process.StandardError = [System.IO.StringReader]::new($script:payload)
        $script:process.ExitCode = 19

        $failure = $null
        try {
            Invoke-CIGitHubCommand -ExecutablePath 'mock-gh' -ArgumentList @('variable', 'set', 'CI_CLIENTSECRET', '--repo', 'owner/repo') -InputValue $script:securePayload
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'code \[19\]'
        $failure.Exception.ToString() | Should -Not -Match ([regex]::Escape($script:payload))
        $script:process.Disposed | Should -BeTrue
    }

    It 'Sanitizes process exceptions and disposes the process' {
        $script:process | Add-Member -MemberType ScriptMethod -Name Start -Force -Value { throw $script:payload }

        $failure = $null
        try {
            Invoke-CIGitHubCommand -ExecutablePath 'mock-gh' -ArgumentList @('secret', 'set', 'CI_CLIENTSECRET') -InputValue $script:securePayload
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'GitHub CLI process failed'
        $failure.Exception.ToString() | Should -Not -Match ([regex]::Escape($script:payload))
        $script:process.Disposed | Should -BeTrue
    }

    It 'Stops and disposes its own process after a stdin failure without exposing the exception payload' {
        $inputStream = [pscustomobject]@{}
        $inputStream | Add-Member -MemberType ScriptMethod -Name Write -Value { throw $script:payload }
        $inputStream | Add-Member -MemberType ScriptMethod -Name Dispose -Value {}
        $script:process.StandardInput = $inputStream
        $script:process.HasExited = $false

        $failure = $null
        try {
            Invoke-CIGitHubCommand -ExecutablePath 'mock-gh' -ArgumentList @('secret', 'set', 'CI_CLIENTSECRET') -InputValue $script:securePayload
        } catch {
            $failure = $_
        }

        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'GitHub CLI process failed'
        $failure.Exception.ToString() | Should -Not -Match ([regex]::Escape($script:payload))
        $script:process.Killed | Should -BeTrue
        $script:process.Disposed | Should -BeTrue
    }
}
