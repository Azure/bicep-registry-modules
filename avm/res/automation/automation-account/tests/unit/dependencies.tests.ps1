BeforeAll {
    $template = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..' '..' 'main.json') -Raw | ConvertFrom-Json -AsHashtable
}

Describe 'Automation Account child module dependencies' {
    It 'Creates webhooks after the runbook modules complete' {
        $template.resources.automationAccount_webhook.dependsOn | Should -Contain 'automationAccount_runbooks'
    }

    It 'Allows webhook deployment without creating runbooks' {
        $template.parameters.runbooks.defaultValue | Should -BeNullOrEmpty
        $template.resources.automationAccount_webhook.copy.count | Should -Be "[length(parameters('webhooks'))]"
    }

    It 'Preserves the caller-provided runbook name' {
        $template.resources.automationAccount_webhook.properties.parameters.runbookName.value |
            Should -Be "[parameters('webhooks')[copyIndex()].runbookName]"
    }
}
