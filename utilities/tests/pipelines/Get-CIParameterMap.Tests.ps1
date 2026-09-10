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

    It 'Preserves underscores instead of guessing snake_case to camelCase mappings' {
        $result = Get-CIParameterMap -TemplateParameters $templateParameters -GitHubVariables '{"CI_RESOURCE_NAME":"example","CI_ADMIN_MEMBERS_SECRET":"not-matched"}'

        @($result.Keys) | Should -Be @('resource_name')
        $result.resource_name | Should -Be 'example'
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
        } | Should -Throw '*duplicate CI_ names*'
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
