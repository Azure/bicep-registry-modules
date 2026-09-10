param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Get-CIParameterMap' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-CIParameterMap.ps1')

        function Get-AzKeyVaultSecret {
            [CmdletBinding()]
            param([string] $VaultName, [string] $Name)
            throw 'Unexpected Key Vault access.'
        }

        $templateParameters = @{
            adminMembersSecret = @{ type = 'secureString' }
            legacyOnly         = @{ type = 'secureString' }
            location           = @{ type = 'string' }
            resource_name      = @{ type = 'string' }
            count              = @{ type = 'int' }
            enabled            = @{ type = 'bool' }
            allowedIps         = @{ type = 'array' }
            options            = @{ type = 'object' }
            secureConfig       = @{ type = 'secureObject' }
        }
    }

    BeforeEach {
        Mock Get-AzKeyVaultSecret {
            if (-not $Name) {
                return @(
                    @{ Name = 'CI-adminMembersSecret' }
                    @{ Name = 'CI-LEGACYONLY' }
                    @{ Name = 'CI-unrelated' }
                    @{ Name = 'unrelated' }
                )
            }
            return @{
                SecretValue = ConvertTo-SecureString -String "vault-$Name" -AsPlainText -Force
            }
        }
    }

    It 'Matches uppercase GitHub names and returns the declared parameter spelling' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables '{"CI_ADMINMEMBERSSECRET":"admin@example.invalid","CI_LOCATION":"westus"}'

        @($result.Keys | Sort-Object) | Should -Be @('adminMembersSecret', 'location')
        $result.adminMembersSecret | Should -BeOfType [securestring]
        ConvertFrom-SecureString -SecureString $result.adminMembersSecret -AsPlainText | Should -Be 'admin@example.invalid'
        $result.location | Should -Be 'westus'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
    }

    It 'Uses readable names for camelCase parameters and double underscores for literal names' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters `
            -GitHubVariables '{"CI__RESOURCE_NAME":"example","CI_ADMIN_MEMBERS_SECRET":"readable"}'

        @($result.Keys | Sort-Object) | Should -Be @('adminMembersSecret', 'resource_name')
        $result.resource_name | Should -Be 'example'
        ConvertFrom-SecureString -SecureString $result.adminMembersSecret -AsPlainText | Should -Be 'readable'
    }

    It 'Does not remove literal underscores from double-prefix inputs or declared parameter names' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters `
            -GitHubVariables '{"CI_RESOURCE_NAME":"not-literal","CI__ADMIN_MEMBERS_SECRET":"not-camelCase"}'

        $result.Count | Should -Be 0
    }

    It 'Distinguishes camelCase and underscored parameters in the same template' {
        $result = Get-CIParameterMap -TemplateParameters @{
            adminMembersSecret   = @{ type = 'secureString' }
            admin_members_secret = @{ type = 'secureString' }
        } -GitHubSecrets '{"CI_ADMIN_MEMBERS_SECRET":"camel","CI__ADMIN_MEMBERS_SECRET":"literal"}'

        ConvertFrom-SecureString -SecureString $result.adminMembersSecret -AsPlainText | Should -Be 'camel'
        ConvertFrom-SecureString -SecureString $result.admin_members_secret -AsPlainText | Should -Be 'literal'
    }

    It 'Keeps secret precedence across different aliases' -ForEach @(
        @{ variableName = 'CI_ADMIN_MEMBERS_SECRET'; secretName = 'CI__ADMINMEMBERSSECRET' }
        @{ variableName = 'CI__ADMINMEMBERSSECRET'; secretName = 'CI_ADMIN_MEMBERS_SECRET' }
    ) {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters `
            -GitHubVariables (@{ $variableName = 'variable' } | ConvertTo-Json -Compress) `
            -GitHubSecrets (@{ $secretName = 'secret' } | ConvertTo-Json -Compress)

        ConvertFrom-SecureString -SecureString $result.adminMembersSecret -AsPlainText | Should -Be 'secret'
    }

    It 'Rejects multiple <source> aliases for the same parameter before accessing Key Vault' -ForEach @(
        @{ source = 'Variables'; names = @('CI_ADMIN_MEMBERS_SECRET', 'CI_ADMINMEMBERSSECRET') }
        @{ source = 'Secrets'; names = @('CI__ADMINMEMBERSSECRET', 'CI_ADMIN_MEMBERS_SECRET') }
    ) {
        $arguments = @{
            TemplateParameters = $templateParameters
            KeyVaultName       = 'test-vault'
            "GitHub$source"    = @{ $names[0] = 'one'; $names[1] = 'two' } | ConvertTo-Json -Compress
        }

        { Get-CIParameterMap @arguments } | Should -Throw "*Multiple GitHub $source names*map to parameter*"
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
    }

    It 'Ignores conflicting aliases that do not target the current template' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters `
            -GitHubVariables '{"CI_OTHER_INPUT":"one","CI__OTHERINPUT":"two"}'

        $result.Count | Should -Be 0
    }

    It 'Does not inject the reserved Key Vault selector into a template parameter' {
        $result = Get-CIParameterMap -TemplateParameters @{ keyVaultName = @{ type = 'string' } } `
            -GitHubVariables '{"CI_KEY_VAULT_NAME":"legacy-vault"}'

        $result.Count | Should -Be 0
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
    }

    It 'Uses an exact alias to supply keyVaultName independently of the legacy selector' {
        $result = Get-CIParameterMap -TemplateParameters @{ keyVaultName = @{ type = 'string' } } `
            -GitHubVariables '{"CI_KEY_VAULT_NAME":"legacy-vault","CI__KEYVAULTNAME":"test-vault"}'

        $result.keyVaultName | Should -Be 'test-vault'
    }

    It 'Rejects template parameter names that GitHub cannot distinguish by case' {
        $definitions = ConvertFrom-Json '{"name":{"type":"string"},"NAME":{"type":"string"}}' -AsHashtable

        { Get-CIParameterMap -TemplateParameters $definitions -GitHubVariables '{"CI_NAME":"ambiguous"}' } |
            Should -Throw '*differs from another parameter only in case*'
    }

    It 'Supports parameters whose names shadow dictionary properties' {
        $definitions = @{
            keys   = @{ type = 'secureString' }
            count  = @{ type = 'int' }
            values = @{ type = 'string' }
        }
        $result = Get-CIParameterMap -TemplateParameters $definitions -KeyVaultName 'test-vault' `
            -GitHubVariables '{"CI_KEYS":"example","CI_COUNT":"0","CI_VALUES":"example"}'

        @($result.psbase.Keys | Sort-Object) | Should -Be @('count', 'keys', 'values')
        $result['keys'] | Should -BeOfType [securestring]
        $result['count'] | Should -Be 0
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
    }

    It 'Gives a GitHub secret precedence over a variable and a Key Vault secret' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -KeyVaultName 'test-vault' `
            -GitHubVariables '{"CI_ADMINMEMBERSSECRET":"variable","CI_LOCATION":"westus"}' `
            -GitHubSecrets '{"ci_adminMembersSecret":"secret"}'

        ConvertFrom-SecureString -SecureString $result.adminMembersSecret -AsPlainText | Should -Be 'secret'
        $result.location | Should -Be 'westus'
        ConvertFrom-SecureString -SecureString $result.legacyOnly -AsPlainText | Should -Be 'vault-CI-LEGACYONLY'
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { -not $Name }
        Should -Invoke Get-AzKeyVaultSecret -Times 1 -Exactly -ParameterFilter { $Name -eq 'CI-LEGACYONLY' }
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -eq 'CI-adminMembersSecret' -or $Name -eq 'CI-unrelated' -or $Name -eq 'unrelated' }
    }

    It 'Gives a GitHub variable precedence over Key Vault' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -KeyVaultName 'test-vault' `
            -GitHubVariables '{"CI_ADMINMEMBERSSECRET":"variable"}'

        ConvertFrom-SecureString -SecureString $result.adminMembersSecret -AsPlainText | Should -Be 'variable'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -eq 'CI-adminMembersSecret' }
    }

    It 'Does not fall back when a GitHub secret is an empty string' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -KeyVaultName 'test-vault' `
            -GitHubVariables '{"CI_ADMINMEMBERSSECRET":"variable"}' -GitHubSecrets '{"CI_ADMINMEMBERSSECRET":""}'

        $result.adminMembersSecret | Should -BeOfType [securestring]
        $result.adminMembersSecret.Length | Should -Be 0
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly -ParameterFilter { $Name -eq 'CI-adminMembersSecret' }
    }

    It 'Preserves an explicitly empty variable' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables '{"CI_LOCATION":""}'

        $result.ContainsKey('location') | Should -BeTrue
        $result.location | Should -BeExactly ''
    }

    It 'Keeps legacy secure values without converting them to plaintext' {
        $vaultValue = ConvertTo-SecureString -String 'legacy-value' -AsPlainText -Force
        Mock Get-AzKeyVaultSecret { @{ SecretValue = $vaultValue } } -ParameterFilter { $Name -eq 'CI-LEGACYONLY' }

        $result = Get-CIParameterMap -TemplateParameters $templateParameters -KeyVaultName 'test-vault'

        [object]::ReferenceEquals($result.legacyOnly, $vaultValue) | Should -BeTrue
    }

    It 'Avoids Key Vault access when every parameter is supplied by GitHub' {
        $result = Get-CIParameterMap -TemplateParameters @{ location = @{ type = 'string' } } -KeyVaultName 'test-vault' `
            -GitHubVariables '{"CI_LOCATION":"westus"}'

        $result.location | Should -Be 'westus'
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
    }

    It 'Ignores unrelated credentials and unmatched names' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters `
            -GitHubVariables '{"OTHER_LOCATION":"westus","CI-LOCATION":"not-github","CI_MISSING":"unknown","CI_":"empty-suffix"}' `
            -GitHubSecrets '{"GITHUB_TOKEN":"not-a-real-token","AZURE_CREDENTIALS":"not-a-real-secret"}'

        $result.Count | Should -Be 0
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
    }

    It 'Supports absent contexts and templates without parameters' {
        $result = Get-CIParameterMap -TemplateParameters @{} -GitHubVariables '' -GitHubSecrets '' -KeyVaultName 'test-vault'

        $result.Count | Should -Be 0
        Should -Invoke Get-AzKeyVaultSecret -Times 0 -Exactly
    }

    It 'Preserves quotes, newlines, Unicode and whitespace in strings' {
        $value = "  O'Brien `"quoted`" % `${notCode}`r`n$([char]0x00e9)`n"
        $json = @{ CI_ADMINMEMBERSSECRET = $value; CI_LOCATION = $value } | ConvertTo-Json -Compress

        $result = Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables $json -GitHubSecrets $json -WarningAction SilentlyContinue

        ConvertFrom-SecureString -SecureString $result.adminMembersSecret -AsPlainText | Should -BeExactly $value
        $result.location | Should -BeExactly $value
    }

    It 'Converts JSON to the declared primitive and structured types' {
        $json = @{
            CI_COUNT        = '0'
            CI_ENABLED      = 'false'
            CI_ALLOWEDIPS   = '["one"]'
            CI_OPTIONS      = '{"nested":{"enabled":true}}'
            CI_SECURECONFIG = '{"password":"not-a-real-password"}'
        } | ConvertTo-Json -Compress

        $result = Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables $json

        $result.count | Should -Be 0
        $result.count | Should -BeOfType [long]
        $result.enabled | Should -BeOfType [bool]
        $result.enabled | Should -BeFalse
        $result.allowedIps -is [array] | Should -BeTrue
        $result.allowedIps.Count | Should -Be 1
        $result.allowedIps[0] | Should -Be 'one'
        $result.options.nested.enabled | Should -BeTrue
        $result.secureConfig.password | Should -Be 'not-a-real-password'
    }

    It 'Preserves empty arrays and objects' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables '{"CI_ALLOWEDIPS":"[]","CI_OPTIONS":"{}"}'

        $result.ContainsKey('allowedIps') | Should -BeTrue
        $result.allowedIps -is [array] | Should -BeTrue
        $result.allowedIps.Count | Should -Be 0
        $result.options.Count | Should -Be 0
    }

    It 'Resolves user-defined parameter types, including secure aliases' {
        $definitions = @{
            'private/config' = @{ type = 'secureObject' }
            alias            = @{ '$ref' = '#/definitions/private~1config' }
        }
        $result = Get-CIParameterMap -TemplateParameters @{ secureConfig = @{ '$ref' = '#/definitions/alias' } } `
            -TemplateDefinitions $definitions -GitHubSecrets '{"CI_SECURECONFIG":"{\"password\":\"example\"}"}' `
            -WarningVariable warnings

        $result.secureConfig.password | Should -Be 'example'
        $warnings.Count | Should -Be 0
    }

    It 'Rejects missing or circular user-defined types' -ForEach @(
        @{ definitions = @{} }
        @{ definitions = @{ alias = @{ '$ref' = '#/definitions/alias' } } }
    ) {
        {
            Get-CIParameterMap -TemplateParameters @{ secureConfig = @{ '$ref' = '#/definitions/alias' } } `
                -TemplateDefinitions $definitions -GitHubSecrets '{"CI_SECURECONFIG":"{}"}'
        } | Should -Throw '*unresolved or circular type reference*'
    }

    It 'Warns without logging the value when a secret targets a non-secure parameter' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -GitHubSecrets '{"CI_LOCATION":"sensitive-example"}' `
            -WarningVariable warnings -WarningAction SilentlyContinue

        $result.location | Should -Be 'sensitive-example'
        $warnings | Should -Match 'non-secure parameter \[location\]'
        $warnings | Should -Not -Match 'sensitive-example'
    }

    It 'Does not log parameter values, including secure objects, with Verbose enabled' {
        $messages = @(
            Get-CIParameterMap -TemplateParameters $templateParameters `
                -GitHubSecrets '{"CI_ADMINMEMBERSSECRET":"sensitive-example","CI_SECURECONFIG":"{\"password\":\"sensitive-example\"}"}' `
                -Verbose 3>&1 4>&1 6>&1
        )

        @($messages | Where-Object { $_ -isnot [hashtable] }).Count | Should -Be 0
    }

    It 'Rejects invalid <source> contexts without including their content' -ForEach @(
        @{ source = 'Variables'; json = '{"CI_LOCATION":"sensitive-example"' }
        @{ source = 'Secrets'; json = '{"CI_LOCATION":"sensitive-example"' }
        @{ source = 'Variables'; json = '[]' }
        @{ source = 'Secrets'; json = 'null' }
        @{ source = 'Secrets'; json = '"sensitive-example"' }
    ) {
        $arguments = @{ TemplateParameters = $templateParameters; "GitHub$source" = $json }

        { Get-CIParameterMap @arguments } | Should -Throw "*GitHub $source context must be*JSON object*"
    }

    It 'Rejects duplicate case-insensitive names' {
        {
            Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables '{"CI_LOCATION":"one","ci_location":"two"}'
        } | Should -Throw '*Multiple GitHub Variables names*'
    }

    Describe 'CI parameter name formats' {

        BeforeAll {
            . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'ConvertFrom-CIParameterName.ps1')
            . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'ConvertTo-CIParameterName.ps1')
        }

        It 'Decodes <name> using its explicit prefix' -ForEach @(
            @{ name = 'CI_ADMIN_MEMBERS_SECRET'; expected = 'ADMINMEMBERSSECRET' }
            @{ name = 'CI_ADMINMEMBERSSECRET'; expected = 'ADMINMEMBERSSECRET' }
            @{ name = 'ci_admin_members_secret'; expected = 'adminmemberssecret' }
            @{ name = 'CI_ADMIN__MEMBERS_SECRET'; expected = 'ADMINMEMBERSSECRET' }
            @{ name = 'CI__ADMIN_MEMBERS_SECRET'; expected = 'ADMIN_MEMBERS_SECRET' }
            @{ name = 'CI__ADMINMEMBERSSECRET'; expected = 'ADMINMEMBERSSECRET' }
            @{ name = 'CI___NAME'; expected = '_NAME' }
        ) {
            ConvertFrom-CIParameterName -Name $name | Should -BeExactly $expected
        }

        It 'Does not treat <name> as a parameter' -ForEach @(
            @{ name = 'CI_KEY_VAULT_NAME' }
            @{ name = 'ci_key_vault_name' }
            @{ name = 'OTHER_VALUE' }
            @{ name = 'CI-value' }
            @{ name = 'CI_' }
            @{ name = 'CI__' }
            @{ name = '' }
        ) {
            ConvertFrom-CIParameterName -Name $name | Should -BeNullOrEmpty
        }

        It 'Formats <parameterName> without losing its identity' -ForEach @(
            @{ parameterName = 'adminMembersSecret'; expected = 'CI_ADMIN_MEMBERS_SECRET' }
            @{ parameterName = 'managedHSMResourceId'; expected = 'CI_MANAGED_HSM_RESOURCE_ID' }
            @{ parameterName = 'clientID'; expected = 'CI_CLIENT_ID' }
            @{ parameterName = 'tls1Version'; expected = 'CI_TLS1_VERSION' }
            @{ parameterName = 'resource_name'; expected = 'CI__RESOURCE_NAME' }
            @{ parameterName = '_name'; expected = 'CI___NAME' }
            @{ parameterName = 'keyVaultName'; expected = 'CI__KEYVAULTNAME' }
        ) {
            $name = ConvertTo-CIParameterName -ParameterName $parameterName

            $name | Should -BeExactly $expected
            ConvertFrom-CIParameterName -Name $name | Should -Be $parameterName
        }

        It 'Keeps long camelCase names compact instead of exceeding the GitHub name limit' {
            $parameterName = 'aB' * 48
            $name = ConvertTo-CIParameterName -ParameterName $parameterName

            $name | Should -BeExactly ('CI_' + $parameterName.ToUpperInvariant())
            $name.Length | Should -BeLessOrEqual 100
            ConvertFrom-CIParameterName -Name $name | Should -Be $parameterName
        }
    }

    It 'Rejects a non-string matching context value' {
        { Get-CIParameterMap -TemplateParameters $templateParameters -GitHubSecrets '{"CI_ADMINMEMBERSSECRET":null}' } |
            Should -Throw '*must be a string*'
    }

    It 'Rejects invalid JSON types for <parameterName>' -ForEach @(
        @{ parameterName = 'count'; value = '1.5' }
        @{ parameterName = 'count'; value = 'true' }
        @{ parameterName = 'enabled'; value = '"false"' }
        @{ parameterName = 'allowedIps'; value = '"one"' }
        @{ parameterName = 'allowedIps'; value = 'null' }
        @{ parameterName = 'options'; value = '[]' }
        @{ parameterName = 'secureConfig'; value = '{"password":"sensitive-example"' }
    ) {
        $json = @{ "CI_$parameterName" = $value } | ConvertTo-Json -Compress

        { Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables $json } |
            Should -Throw "*parameter *$parameterName*JSON*"
    }

    It 'Surfaces vault failures instead of pretending no fallback values exist' {
        Mock Get-AzKeyVaultSecret { throw 'Vault access denied.' }

        { Get-CIParameterMap -TemplateParameters $templateParameters -KeyVaultName 'test-vault' } |
            Should -Throw '*Vault access denied*'
    }

    It 'Rejects a missing vault secret value' {
        Mock Get-AzKeyVaultSecret { @{ SecretValue = $null } } -ParameterFilter { $Name -eq 'CI-LEGACYONLY' }

        { Get-CIParameterMap -TemplateParameters $templateParameters -KeyVaultName 'test-vault' } |
            Should -Throw '*did not return a secure value*'
    }
}
