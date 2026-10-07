param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    function Build-TestTemplate {
        param([string] $Path, [string] $Name)
        $compiledPath = Join-Path $TestDrive "$Name.json"
        $diagnostics = bicep build $Path --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
    }

    function Resolve-TestDefinition {
        param([hashtable] $Template, [hashtable] $Schema)
        $Schema.'$ref' | Should -Match '^#/definitions/'
        $Template.definitions[$Schema.'$ref'.Substring('#/definitions/'.Length)]
    }

    $templates = @{}
    $generated = @{}
    $children = @{}
    foreach ($entry in @(
            @{ name = 'environment'; path = 'app/managed-environment'; child = 'certificate' }
            @{ name = 'sql'; path = 'sql/server'; child = 'security-alert-policy' }
            @{ name = 'service'; path = 'api-management/service'; child = 'subscription' }
            @{ name = 'workspace'; path = 'api-management/service/workspace'; child = 'subscription' }
        )) {
        $modulePath = Join-Path $repoRootPath "avm/res/$($entry.path)"
        $templates[$entry.name] = Build-TestTemplate (Join-Path $modulePath 'main.bicep') $entry.name
        $children[$entry.name] = Build-TestTemplate (Join-Path $modulePath "$($entry.child)/main.bicep") "$($entry.name)-child"
        $generated[$entry.name] = Get-Content (Join-Path $modulePath 'main.json') -Raw | ConvertFrom-Json -AsHashtable
    }
    $caller = Build-TestTemplate (Join-Path $PSScriptRoot 'src/credentialLeaves/main.bicep') 'caller'
}

Describe 'Credential leaf schemas' {
    It 'Secures <module>.<definition>.<leaf> without changing optionality or its enclosing object' -TestCases @(
        @{ module = 'environment'; definition = 'certificateType'; leaf = 'certificateValue' }
        @{ module = 'sql'; definition = 'securityAlertPolicyType'; leaf = 'storageAccountAccessKey' }
        @{ module = 'service'; definition = 'subscriptionType'; leaf = 'primaryKey' }
        @{ module = 'service'; definition = 'subscriptionType'; leaf = 'secondaryKey' }
        @{ module = 'workspace'; definition = 'subscriptionType'; leaf = 'primaryKey' }
        @{ module = 'workspace'; definition = 'subscriptionType'; leaf = 'secondaryKey' }
    ) {
        param($module, $definition, $leaf)
        foreach ($template in @($templates[$module], $generated[$module])) {
            $type = $template.definitions[$definition]
            $type.type | Should -Be 'object'
            $type.properties.name.type | Should -Be 'string'
            $type.properties[$leaf].type | Should -Be 'secureString'
            $type.properties[$leaf].nullable | Should -BeTrue
            $type.properties[$leaf].ContainsKey('defaultValue') | Should -BeFalse
        }
        $children[$module].parameters[$leaf].type | Should -Be 'secureString'
        $children[$module].parameters[$leaf].nullable | Should -BeTrue
    }

    It 'Preserves subscription key length validation in <module>' -TestCases @(
        @{ module = 'service' }
        @{ module = 'workspace' }
    ) {
        param($module)
        foreach ($leaf in @('primaryKey', 'secondaryKey')) {
            $schema = $templates[$module].definitions.subscriptionType.properties[$leaf]
            $schema.minLength | Should -Be 1
            $schema.maxLength | Should -Be 256
            $children[$module].parameters[$leaf].minLength | Should -Be 1
            $children[$module].parameters[$leaf].maxLength | Should -Be 256
        }
    }

    It 'Retains nullable parameter references rather than securing whole objects or arrays' {
        $templates.environment.parameters.certificate.'$ref' | Should -Be '#/definitions/certificateType'
        $templates.environment.parameters.certificate.nullable | Should -BeTrue
        foreach ($entry in @(
                @{ module = 'sql'; parameter = 'securityAlertPolicies'; definition = 'securityAlertPolicyType' }
                @{ module = 'service'; parameter = 'subscriptions'; definition = 'subscriptionType' }
                @{ module = 'workspace'; parameter = 'subscriptions'; definition = 'subscriptionType' }
            )) {
            $schema = $templates[$entry.module].parameters[$entry.parameter]
            $schema.type | Should -Be 'array'
            $schema.nullable | Should -BeTrue
            $schema.items.'$ref' | Should -Be "#/definitions/$($entry.definition)"
        }
    }

    It 'Propagates the imported workspace subscription type through the service reference and nested deployment' {
        foreach ($template in @($templates.service, $generated.service)) {
            $workspaceType = Resolve-TestDefinition $template $template.parameters.workspaces.items
            $workspaceType.type | Should -Be 'object'
            $workspaceType.properties.subscriptions.type | Should -Be 'array'
            $workspaceType.properties.subscriptions.nullable | Should -BeTrue
            $subscriptionType = Resolve-TestDefinition $template $workspaceType.properties.subscriptions.items
            $subscriptionType.type | Should -Be 'object'
            foreach ($leaf in @('primaryKey', 'secondaryKey')) {
                $subscriptionType.properties[$leaf].type | Should -Be 'secureString'
                $subscriptionType.properties[$leaf].nullable | Should -BeTrue
                $subscriptionType.properties[$leaf].minLength | Should -Be 1
                $subscriptionType.properties[$leaf].maxLength | Should -Be 256
                $template.resources.service_workspaces.properties.template.definitions.subscriptionType.properties[$leaf].type |
                    Should -Be 'secureString'
                $template.resources.service_workspaces.properties.template.resources.workspace_subscriptions.properties.template.parameters[$leaf].type |
                    Should -Be 'secureString'
            }
        }
    }
}

Describe 'Credential forwarding' {
    It 'Preserves <module> child parameters and resource assignments' -TestCases @(
        @{ module = 'environment'; deployment = 'managedEnvironment_certificate'; resource = 'managedEnvironmentCertificate'; parameter = 'certificate'; leaves = @('certificateValue') }
        @{ module = 'sql'; deployment = 'server_securityAlertPolicies'; resource = 'securityAlertPolicy'; parameter = 'securityAlertPolicies'; leaves = @('storageAccountAccessKey') }
        @{ module = 'service'; deployment = 'service_subscriptions'; resource = 'subscription'; parameter = 'subscriptions'; leaves = @('primaryKey', 'secondaryKey') }
        @{ module = 'workspace'; deployment = 'workspace_subscriptions'; resource = 'subscription'; parameter = 'subscriptions'; leaves = @('primaryKey', 'secondaryKey') }
    ) {
        param($module, $deployment, $resource, $parameter, $leaves)
        $nested = $templates[$module].resources[$deployment].properties
        foreach ($leaf in $leaves) {
            $nested.template.parameters[$leaf].type | Should -Be 'secureString'
            $nested.template.parameters[$leaf].nullable | Should -BeTrue
            $sourceExpression = $module -eq 'environment' ? "parameters('$parameter')" : "coalesce(parameters('$parameter'), createArray())[copyIndex()]"
            $nested.parameters[$leaf].value | Should -Be "[tryGet($sourceExpression, '$leaf')]"
            $property = $module -eq 'environment' ? 'value' : $leaf
            $nested.template.resources[$resource].properties[$property] | Should -Be "[parameters('$leaf')]"
            $children[$module].resources[$resource].properties[$property] | Should -Be "[parameters('$leaf')]"
        }
        ($nested.template.outputs | ConvertTo-Json -Depth 100 -Compress) |
            Should -Be ($children[$module].outputs | ConvertTo-Json -Depth 100 -Compress)
    }
}

Describe 'Existing plain callers' {
    It 'Keeps caller-owned strings, objects and typed arrays plain while compiling against secure leaves' {
        $caller.parameters.existingValue.type | Should -Be 'string'
        foreach ($entry in @(
                @{ parameter = 'existingCertificate'; definition = 'existingCertificateType'; leaf = 'certificateValue' }
                @{ parameter = 'existingPolicy'; definition = 'existingPolicyType'; leaf = 'storageAccountAccessKey' }
                @{ parameter = 'existingSubscription'; definition = 'existingSubscriptionType'; leaf = 'primaryKey' }
            )) {
            $caller.parameters[$entry.parameter].'$ref' | Should -Be "#/definitions/$($entry.definition)"
            $caller.definitions[$entry.definition].type | Should -Be 'object'
            $caller.definitions[$entry.definition].properties[$entry.leaf].type | Should -Be 'string'
        }
        $caller.definitions.existingSubscriptionType.properties.secondaryKey.type | Should -Be 'string'
        foreach ($parameter in @('existingPolicies', 'existingSubscriptions', 'existingWorkspaces')) {
            $caller.parameters[$parameter].type | Should -Be 'array'
            $caller.parameters[$parameter].items.'$ref' | Should -Match '^#/definitions/existing'
        }
        $caller.variables.certificates[0] | Should -Be "[parameters('existingCertificate')]"
        $caller.variables.certificates[1].certificateValue | Should -Be "[parameters('existingValue')]"
        $caller.variables.policies | Should -Match "concat\(parameters\('existingPolicies'\)"
        $caller.variables.subscriptions | Should -Match "concat\(parameters\('existingSubscriptions'\)"
        $caller.resources.serviceParent.properties.parameters.workspaces.value | Should -Match "concat\(parameters\('existingWorkspaces'\)"
        $caller.resources.sqlParent.properties.parameters.securityAlertPolicies.value | Should -Be "[variables('policies')]"
        $caller.resources.serviceParent.properties.parameters.subscriptions.value | Should -Be "[variables('subscriptions')]"
        $caller.resources.workspaceParent.properties.parameters.subscriptions.value | Should -Be "[variables('subscriptions')]"
        $caller.resources.certificateParents.properties.parameters.certificate.value | Should -Be "[variables('certificates')[copyIndex()]]"
    }

    It 'Accepts explicit plain string parameters at each standalone child boundary' {
        foreach ($entry in @(
                @{ module = 'certificateChild'; leaves = @('certificateValue') }
                @{ module = 'policyChild'; leaves = @('storageAccountAccessKey') }
                @{ module = 'subscriptionChild'; leaves = @('primaryKey', 'secondaryKey') }
                @{ module = 'workspaceSubscriptionChild'; leaves = @('primaryKey', 'secondaryKey') }
            )) {
            foreach ($leaf in $entry.leaves) {
                $caller.resources[$entry.module].properties.parameters[$leaf].value | Should -Be "[parameters('existingValue')]"
                $caller.resources[$entry.module].properties.template.parameters[$leaf].type | Should -Be 'secureString'
            }
        }
    }

    It 'Accepts null and omitted optional credential leaves' {
        $caller.variables.certificates[2].ContainsKey('certificateValue') | Should -BeTrue
        $caller.variables.certificates[2].certificateValue | Should -BeNullOrEmpty
        $caller.variables.certificates[3].ContainsKey('certificateValue') | Should -BeFalse
        $caller.variables.policies | Should -Match "'storageAccountAccessKey', null\(\)"
        $caller.variables.policies | Should -Match "createObject\('name', 'Default'\)"
        $caller.variables.subscriptions | Should -Match "'primaryKey', null\(\), 'secondaryKey', null\(\)"
        $caller.variables.subscriptions | Should -Match "createObject\('name', 'omitted', 'displayName', 'Omitted keys'\)"
    }

    It 'Accepts null and omitted enclosing objects and arrays' {
        foreach ($entry in @(
                @{ suffix = 'Certificate'; parameter = 'certificate' }
                @{ suffix = 'Policies'; parameter = 'securityAlertPolicies' }
                @{ suffix = 'Subscriptions'; parameter = 'subscriptions' }
                @{ suffix = 'Subscriptions'; parameter = 'workspaces' }
                @{ suffix = 'WorkspaceSubscriptions'; parameter = 'subscriptions' }
            )) {
            $caller.resources["null$($entry.suffix)"].properties.parameters.ContainsKey($entry.parameter) | Should -BeTrue
            $caller.resources["null$($entry.suffix)"].properties.parameters[$entry.parameter].value | Should -BeNullOrEmpty
            $caller.resources["omitted$($entry.suffix)"].properties.parameters.ContainsKey($entry.parameter) | Should -BeFalse
        }
    }
}
