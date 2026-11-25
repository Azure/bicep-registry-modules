Describe 'Synapse workspace output contract' {
    BeforeAll {
        $moduleRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
        $template = Get-Content (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -Depth 100
        $source = Get-Content (Join-Path $moduleRoot 'main.bicep') -Raw
    }

    It 'exports the canonical resourceId output from the workspace' {
        ($template.outputs.PSObject.Properties.Name -ccontains 'resourceId') | Should -BeTrue
        $template.outputs.resourceId.type | Should -BeExactly 'string'
        $template.outputs.resourceId.value | Should -BeExactly "[resourceId('Microsoft.Synapse/workspaces', parameters('name'))]"
        $source | Should -MatchExactly '(?m)^output resourceId string = workspace\.id\r?$'
    }

    It 'does not declare an unsupported case-only output alias' {
        ($template.outputs.PSObject.Properties.Name -ccontains 'resourceID') | Should -BeFalse
        $source | Should -Not -MatchExactly '(?m)^output resourceID\b'
    }
}
