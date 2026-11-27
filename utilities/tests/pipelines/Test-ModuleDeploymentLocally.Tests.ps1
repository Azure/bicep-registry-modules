param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Local deployment validation' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'tools' 'Test-ModuleDeploymentLocally.ps1')
    }

    BeforeEach {
        $script:moduleRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString())
        $testRoot = Join-Path $moduleRoot 'tests' 'e2e' 'defaults'
        $null = New-Item -ItemType Directory -Path $testRoot -Force
        $script:templatePath = Join-Path $moduleRoot 'main.bicep'
        $script:testPath = Join-Path $testRoot 'main.test.bicep'
        Set-Content -LiteralPath $templatePath -Value ''
        Set-Content -LiteralPath $testPath -Value ''
        $script:templatePath = (Get-Item -LiteralPath $templatePath).FullName
        $script:testPath = (Get-Item -LiteralPath $testPath).FullName
        $script:inputObject = @{
            TemplateFilePath           = $templatePath
            ValidateOrDeployParameters = @{
                Location          = 'westus'
                ResourceGroupName = 'example'
                SubscriptionId    = 'subscription'
                ManagementGroupId = 'management-group'
            }
        }
        Mock Get-LocallyReferencedFileList { @() }
        $script:tokenCalls = @()
        Mock Convert-TokensInFileList {
            $script:tokenCalls += [pscustomobject]@{
                Files = @($FilePathList)
                Tokens = $Tokens.Clone()
            }
            $true
        }
        Mock Test-TemplateDeployment {}
        Mock Get-TemplateDeploymentWhatIf {}
        Mock New-TemplateDeployment {}
    }

    It 'validates and runs what-if with the requested tokens and parameters' {
        Test-ModuleDeploymentLocally @inputObject -ValidationTest -WhatIfTest `
            -AdditionalTokens @{ example = 'value' } -AdditionalParameters @{ name = 'example' }

        $script:tokenCalls[0].Tokens.example | Should -Be 'value'
        @($script:tokenCalls[0].Files | Where-Object { $_ -eq $testPath }).Count | Should -Be 1
        Should -Invoke Test-TemplateDeployment -Times 1 -Exactly -ParameterFilter {
            $TemplateFilePath -eq $testPath -and $AdditionalParameters.name -eq 'example'
        }
        Should -Invoke Get-TemplateDeploymentWhatIf -Times 1 -Exactly
        Should -Invoke Convert-TokensInFileList -Times 1 -Exactly
    }

    It 'validates all test files before running what-if and deployment' {
        $secondRoot = Join-Path $moduleRoot 'tests' 'e2e' 'second'
        $null = New-Item -ItemType Directory -Path $secondRoot -Force
        Set-Content -LiteralPath (Join-Path $secondRoot 'main.test.bicep') -Value ''
        $script:operations = @()
        Mock Test-TemplateDeployment { $script:operations += 'validate' }
        Mock Get-TemplateDeploymentWhatIf { $script:operations += 'what-if' }
        Mock New-TemplateDeployment { $script:operations += 'deploy' }

        Test-ModuleDeploymentLocally @inputObject -ValidationTest -WhatIfTest -DeploymentTest
        $script:operations -join ',' | Should -Be 'validate,validate,what-if,what-if,deploy,deploy'
        Should -Invoke New-TemplateDeployment -Times 2 -Exactly -ParameterFilter { $RetryLimit -eq 1 }
    }

    It 'honors ignored tests unless explicitly overridden, including deployments' {
        Set-Content -LiteralPath (Join-Path (Split-Path $testPath) '.e2eignore') -Value ''

        Test-ModuleDeploymentLocally @inputObject -ValidationTest -DeploymentTest
        Should -Invoke Test-TemplateDeployment -Times 0 -Exactly
        Should -Invoke New-TemplateDeployment -Times 0 -Exactly

        Test-ModuleDeploymentLocally @inputObject -ValidationTest -DeploymentTest -SkipE2eIgnoreLogic
        Should -Invoke Test-TemplateDeployment -Times 1 -Exactly
        Should -Invoke New-TemplateDeployment -Times 1 -Exactly -ParameterFilter { $SubscriptionId -eq 'subscription' }
    }

    It 'restores exact file content when validation fails' {
        [System.IO.File]::WriteAllText($testPath, '#_subscriptionId_# and subscription')
        Mock Convert-TokensInFileList {
            [System.IO.File]::WriteAllText($testPath, 'subscription and subscription')
            $true
        }
        Mock Test-TemplateDeployment { throw 'Validation failed.' }

        { Test-ModuleDeploymentLocally @inputObject -ValidationTest } | Should -Throw '*Validation failed*'
        [System.IO.File]::ReadAllText($testPath) | Should -BeExactly '#_subscriptionId_# and subscription'
    }

    It 'reports token replacement failure and restores partially changed files' {
        [System.IO.File]::WriteAllText($testPath, '#_subscriptionId_#')
        Mock Convert-TokensInFileList {
            [System.IO.File]::WriteAllText($testPath, 'subscription')
            $false
        }

        { Test-ModuleDeploymentLocally @inputObject -ValidationTest } | Should -Throw '*token replacement failed*'
        Should -Invoke Test-TemplateDeployment -Times 0 -Exactly
        [System.IO.File]::ReadAllText($testPath) | Should -BeExactly '#_subscriptionId_#'
    }

    It 'restores partially changed files if token replacement throws' {
        [System.IO.File]::WriteAllText($testPath, '#_subscriptionId_#')
        Mock Convert-TokensInFileList {
            [System.IO.File]::WriteAllText($testPath, 'subscription')
            throw 'Conversion failed.'
        }

        { Test-ModuleDeploymentLocally @inputObject -ValidationTest } | Should -Throw '*Conversion failed*'
        [System.IO.File]::ReadAllText($testPath) | Should -BeExactly '#_subscriptionId_#'
    }

    It 'accepts a relative test file path and restores it' {
        [System.IO.File]::WriteAllText($testPath, '#_subscriptionId_#')
        Mock Convert-TokensInFileList {
            [System.IO.File]::WriteAllText($testPath, 'subscription')
            $true
        }
        Push-Location $moduleRoot
        try {
            Test-ModuleDeploymentLocally @inputObject -ModuleTestFilePath 'tests\e2e\defaults\main.test.bicep' -ValidationTest
        } finally {
            Pop-Location
        }
        [System.IO.File]::ReadAllText($testPath) | Should -BeExactly '#_subscriptionId_#'
    }
}
