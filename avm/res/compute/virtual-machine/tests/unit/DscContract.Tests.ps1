Describe 'VM DSC object compatibility' {
    It 'Protects only the leaf without imposing constraints on ordinary siblings' {
        $moduleRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        $template = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable
        $parameter = $template.parameters.extensionDSCConfig
        $type = $template.definitions.extensionDSCConfigType
        $type.type | Should -BeExactly 'object'
        $parameter.defaultValue.enabled | Should -BeFalse
        @($type.properties.Keys) | Should -Be @('protectedSettings')
        $type.properties.protectedSettings.type | Should -BeExactly 'secureObject'
        $type.properties.protectedSettings.nullable | Should -BeTrue
        $type.additionalProperties | Should -Not -BeFalse
    }
}
