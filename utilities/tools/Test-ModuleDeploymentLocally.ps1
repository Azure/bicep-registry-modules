<#
.SYNOPSIS
Run Azure deployment validation, what-if, or deployment for a module's test files.
#>
. (Join-Path $PSScriptRoot '..' 'pipelines' 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')
. (Join-Path $PSScriptRoot '..' 'pipelines' 'sharedScripts' 'Get-LocallyReferencedFileList.ps1')
. (Join-Path $PSScriptRoot '..' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Test-TemplateDeployment.ps1')
. (Join-Path $PSScriptRoot '..' 'pipelines' 'e2eValidation' 'resourceDeployment' 'New-TemplateDeployment.ps1')
. (Join-Path $PSScriptRoot 'helper' 'Get-TemplateDeploymentWhatIf.ps1')

function Test-ModuleDeploymentLocally {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [string] $ModuleTestFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) 'tests'),

        [Parameter(Mandatory)]
        [psobject] $ValidateOrDeployParameters,

        [hashtable] $AdditionalParameters = @{},

        [hashtable] $AdditionalTokens = @{},

        [switch] $ValidationTest,

        [switch] $SkipE2eIgnoreLogic,

        [switch] $WhatIfTest,

        [switch] $DeploymentTest
    )

    if (-not ($ValidationTest -or $WhatIfTest -or $DeploymentTest)) {
        throw 'Specify -ValidationTest, -WhatIfTest, -DeploymentTest, or a combination.'
    }

    $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.FullName
    $TemplateFilePath = (Resolve-Path -Path $TemplateFilePath).Path
    $moduleRoot = Split-Path $TemplateFilePath -Parent
    if ((Get-Item -Path $ModuleTestFilePath) -is [System.IO.DirectoryInfo]) {
        $moduleTestFiles = @((Get-ChildItem -Path $ModuleTestFilePath -Filter '*main.test.bicep' -Recurse).FullName)
    } else {
        $moduleTestFiles = @((Get-Item -Path $ModuleTestFilePath).FullName)
    }
    if ($moduleTestFiles.Count -eq 0) {
        throw "No test files found at '$ModuleTestFilePath'."
    }

    $tokenConfiguration = @{
        FilePathList = @($moduleTestFiles)
        Tokens       = @{
            subscriptionId    = $ValidateOrDeployParameters.SubscriptionId
            managementGroupId = $ValidateOrDeployParameters.ManagementGroupId
        }
    }
    foreach ($testFilePath in $moduleTestFiles) {
        $tokenConfiguration.FilePathList += (Get-LocallyReferencedFileList -FilePath $testFilePath)
    }
    $tokenConfiguration.FilePathList = @($tokenConfiguration.FilePathList | Sort-Object -Culture 'en-US' -Unique)
    $tokenConfiguration.FilePathList += (Get-ChildItem -Path $moduleRoot -Recurse -File).FullName |
        Where-Object { $_ -match '.+(main.json|main.bicep)$' }
    foreach ($name in $AdditionalTokens.Keys) {
        $tokenConfiguration.Tokens[$name] = $AdditionalTokens[$name]
    }

    $functionInput = @{
        DeploymentMetadataLocation = $ValidateOrDeployParameters.Location
        ResourceGroupName          = $ValidateOrDeployParameters.ResourceGroupName
        SubscriptionId             = $ValidateOrDeployParameters.SubscriptionId
        ManagementGroupId          = $ValidateOrDeployParameters.ManagementGroupId
        AdditionalParameters       = $AdditionalParameters
        RepoRoot                   = $repoRootPath
        Verbose                    = $true
    }

    $originalFiles = @{}
    foreach ($filePath in $tokenConfiguration.FilePathList) {
        $originalFiles[$filePath] = [System.IO.File]::ReadAllBytes($filePath)
    }

    try {
        if (-not (Convert-TokensInFileList @tokenConfiguration)) {
            throw 'Test file token replacement failed.'
        }
        $selectedTestFiles = foreach ($moduleTestFile in $moduleTestFiles) {
            $ignoreFilePath = Join-Path (Split-Path $moduleTestFile) '.e2eignore'
            if ((Test-Path $ignoreFilePath) -and -not $SkipE2eIgnoreLogic) {
                Write-Verbose "The module folder [$moduleTestFile] contains an [.e2eignore] file and is skipped." -Verbose
                continue
            }
            $moduleTestFile
        }
        if ($ValidationTest) {
            foreach ($moduleTestFile in $selectedTestFiles) {
                Test-TemplateDeployment @functionInput -TemplateFilePath $moduleTestFile
            }
        }
        if ($WhatIfTest) {
            foreach ($moduleTestFile in $selectedTestFiles) {
                Get-TemplateDeploymentWhatIf @functionInput -TemplateFilePath $moduleTestFile
            }
        }
        if ($DeploymentTest) {
            foreach ($moduleTestFile in $selectedTestFiles) {
                if ($PSCmdlet.ShouldProcess($moduleTestFile, 'Deploy')) {
                    New-TemplateDeployment @functionInput -TemplateFilePath $moduleTestFile -RetryLimit 1
                }
            }
        }
    } finally {
        $restorationErrors = foreach ($filePath in $originalFiles.Keys) {
            try {
                [System.IO.File]::WriteAllBytes($filePath, $originalFiles[$filePath])
            } catch {
                "${filePath}: $($_.Exception.Message)"
            }
        }
        if ($restorationErrors) {
            throw "Test file restoration failed: $($restorationErrors -join '; ')"
        }
    }
}
