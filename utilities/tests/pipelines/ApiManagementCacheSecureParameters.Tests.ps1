param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'API Management cache connection string hardening' {
    BeforeAll {
        $modulePath = Join-Path $repoRootPath 'avm/res/api-management/service'
        $templates = @{}
        foreach ($entry in @(
                @{ name = 'parent'; path = Join-Path $modulePath 'main.bicep' }
                @{ name = 'child'; path = Join-Path $modulePath 'cache/main.bicep' }
                @{ name = 'caller'; path = Join-Path $PSScriptRoot 'src/apiManagementCache/main.bicep' }
            )) {
            $compiledPath = Join-Path $TestDrive "$($entry.name).json"
            $diagnostics = bicep build $entry.path --outfile $compiledPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $templates[$entry.name] = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
        }
        $generatedParent = Get-Content (Join-Path $modulePath 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $generatedChild = Get-Content (Join-Path $modulePath 'cache/main.json') -Raw | ConvertFrom-Json -AsHashtable
    }

    It 'Compiles the standalone child parameter as a required secureString' {
        $templates.child.parameters.connectionString.type | Should -Be 'secureString'
        $templates.child.parameters.connectionString.ContainsKey('defaultValue') | Should -BeFalse
    }

    It 'Secures only the exported cache connection string leaf, not the object or array' {
        $templates.parent.definitions.cacheType.type | Should -Be 'object'
        $templates.parent.definitions.cacheType.properties.connectionString.type | Should -Be 'secureString'
        $templates.parent.definitions.cacheType.properties.name.type | Should -Be 'string'
        $templates.parent.parameters.caches.type | Should -Be 'array'
        $templates.parent.parameters.caches.items.'$ref' | Should -Be '#/definitions/cacheType'
        $templates.parent.parameters.caches.nullable | Should -BeTrue
    }

    It 'Preserves the secure child parameter in the parent embedded template' {
        $templates.parent.resources.service_caches.properties.template.parameters.connectionString.type | Should -Be 'secureString'
        $forwardedValue = $templates.parent.resources.service_caches.properties.parameters.connectionString.value
        $forwardedValue | Should -Match "parameters\('caches'\)"
        $forwardedValue | Should -Match '\.connectionString'
    }

    It 'Passes the child connection string to the cache resource without transforming it' {
        $templates.child.resources.cache.properties.connectionString | Should -Be "[parameters('connectionString')]"
    }

    It 'Keeps generated JSON secure at all three boundaries' {
        $generatedChild.parameters.connectionString.type | Should -Be 'secureString'
        $generatedParent.definitions.cacheType.properties.connectionString.type | Should -Be 'secureString'
        $generatedParent.resources.service_caches.properties.template.parameters.connectionString.type | Should -Be 'secureString'
    }

    It 'Compiles real parent and child callers with the exported type and unchanged input forms' {
        $caller = $templates.caller
        $caller.parameters.suppliedCache.'$ref' | Should -Be '#/definitions/cacheType'
        $caller.definitions.cacheType.properties.connectionString.type | Should -Be 'secureString'
        $caller.resources.parentCaller.properties.template.definitions.cacheType.properties.connectionString.type | Should -Be 'secureString'
        $caller.resources.childCaller.properties.template.parameters.connectionString.type | Should -Be 'secureString'
    }

    It 'Accepts existing plain string, object and typed array callers without securing their whole inputs' {
        $caller = $templates.caller
        $caller.parameters.existingValue.type | Should -Be 'string'
        $caller.definitions.existingCacheType.type | Should -Be 'object'
        $caller.definitions.existingCacheType.properties.connectionString.type | Should -Be 'string'
        $caller.parameters.existingCaches.type | Should -Be 'array'
        $caller.parameters.existingCaches.items.'$ref' | Should -Be '#/definitions/existingCacheType'
    }

    It 'Keeps null and omitted cache arrays optional, without making individual connection strings optional' {
        $templates.caller.resources.nullCaches.properties.parameters.ContainsKey('caches') | Should -BeTrue
        $templates.caller.resources.nullCaches.properties.parameters.caches.value | Should -BeNullOrEmpty
        $templates.caller.resources.omittedCaches.properties.parameters.ContainsKey('caches') | Should -BeFalse
        $templates.parent.definitions.cacheType.properties.connectionString.ContainsKey('nullable') | Should -BeFalse
    }
}
