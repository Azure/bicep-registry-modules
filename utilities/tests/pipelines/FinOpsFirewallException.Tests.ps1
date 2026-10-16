BeforeAll {
    $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
    . (Join-Path $repoRootPath 'utilities' 'tests' 'helper' 'Initialize-PSRuleTest.ps1')
    Initialize-PSRuleTest -RepoRootPath $repoRootPath
    $script:option = New-PSRuleOption -Path (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'psrule' 'ps-rule.yaml')
    $script:rulePath = Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'psrule' '.ps-rule'
    $script:fixturePath = Join-Path $repoRootPath 'avm' 'ptn' 'finops-toolkit' 'finops-hub' 'tests' 'e2e' 'defaults' 'main.test.bicep'
}

Describe 'FinOps defaults storage firewall exception' {
    It 'Preserves every other required security check on the real defaults fixture' {
        $results = @(Invoke-PSRule -InputPath $script:fixturePath -Module PSRule.Rules.Azure `
                -Path $script:rulePath -Option $script:option -Baseline CB.AVM.WAF.Security `
                -Format File -ErrorAction Stop)
        $results | Should -HaveCount 5
        @($results | Where-Object Outcome -EQ 'Fail') | Should -HaveCount 0
        @($results | Where-Object { $_.RuleName -eq 'Azure.Storage.Firewall' }) | Should -HaveCount 0
        @($results | Where-Object { $_.RuleName -eq 'Azure.Storage.SecureTransfer' -and $_.Outcome -eq 'Pass' }) |
            Should -HaveCount 1
        @($results | Where-Object { $_.RuleName -eq 'Azure.Storage.MinTLS' -and $_.Outcome -eq 'Pass' }) |
            Should -HaveCount 1
        @($results | Where-Object { $_.RuleName -eq 'Azure.Storage.BlobPublicAccess' -and $_.Outcome -eq 'Pass' }) |
            Should -HaveCount 1
    }

    It 'Still fails public storage outside the FinOps defaults fixture' {
        $templatePath = Join-Path $TestDrive 'other-storage.json'
        @{
            '$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
            contentVersion = '1.0.0.0'
            resources = @(
                @{
                    type = 'Microsoft.Storage/storageAccounts'
                    apiVersion = '2023-01-01'
                    name = 'unrelatedstorage'
                    location = 'eastus'
                    kind = 'StorageV2'
                    sku = @{ name = 'Standard_LRS' }
                    properties = @{
                        supportsHttpsTrafficOnly = $true
                        minimumTlsVersion = 'TLS1_2'
                        allowBlobPublicAccess = $false
                        networkAcls = @{
                            defaultAction = 'Allow'
                            bypass = 'AzureServices'
                        }
                    }
                }
            )
        } | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $templatePath

        $expanded = @(Export-AzRuleTemplateData -TemplateFile $templatePath -PassThru -ErrorAction Stop)
        $results = @($expanded | Invoke-PSRule -Module PSRule.Rules.Azure `
                -Path $script:rulePath -Option $script:option -Name Azure.Storage.Firewall -ErrorAction Stop)
        @($results | Where-Object { $_.RuleName -eq 'Azure.Storage.Firewall' -and $_.Outcome -eq 'Fail' }) |
            Should -HaveCount 1
    }
}
