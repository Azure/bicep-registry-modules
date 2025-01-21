#Requires -Version 7

param (
    [Parameter(Mandatory = $false)]
    [array] $moduleFolderPaths = ((Get-ChildItem $repoRootPath -Recurse -Directory -Force).FullName | Where-Object {
        (Get-ChildItem $_ -File -Depth 0 -Include @('main.bicep') -Force).Count -gt 0
        }),

    [Parameter(Mandatory = $false)]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.Parent.FullName,

    [Parameter(Mandatory = $false)]
    [bool] $AllowPreviewVersionsInAPITests = $true
)

BeforeDiscovery {

    Write-Verbose ("repoRootPath: $repoRootPath") -Verbose
    Write-Verbose ("moduleFolderPaths: $($moduleFolderPaths.count)") -Verbose

    $script:RgDeploymentSchema = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
    $script:SubscriptionDeploymentSchema = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
    $script:MgDeploymentSchema = 'https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#'
    $script:TenantDeploymentSchema = 'https://schema.management.azure.com/schemas/2019-08-01/tenantDeploymentTemplate.json#'
    $script:telemetryResCsvLink = 'https://aka.ms/avm/index/bicep/res/csv'
    $script:telemetryPtnCsvLink = 'https://aka.ms/avm/index/bicep/ptn/csv'
    $script:telemetryUtlCsvLink = 'https://aka.ms/avm/index/bicep/utl/csv'
    $script:moduleFolderPaths = $moduleFolderPaths

    # Shared exception messages
    $script:bicepTemplateCompilationFailedException = "Unable to compile the main.bicep template's content. This can happen if there is an error in the template. Please check if you can run the command ``bicep build {0} --stdout | ConvertFrom-Json -AsHashtable``." # -f $templateFilePath
    $script:templateNotFoundException = 'No template file found in folder [{0}]' # -f $moduleFolderPath

    # Import any helper function used in this test script
    Import-Module (Join-Path $PSScriptRoot 'helper' 'helper.psm1') -Force

    # Building all required files for tests to optimize performance (using thread-safe multithreading) to consume later
    # Collecting paths
    $pathsToBuild = [System.Collections.ArrayList]@()
    $pathsToBuild += $moduleFolderPaths | ForEach-Object { Join-Path $_ 'main.bicep' }
    foreach ($moduleFolderPath in $moduleFolderPaths) {
        if ($testFilePaths = ((Get-ChildItem -Path $moduleFolderPath -Recurse -Filter 'main.test.bicep').FullName | Sort-Object -Culture 'en-US')) {
            $pathsToBuild += $testFilePaths
        }
    }

    # building paths
    $builtTestFileMap = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()
    $pathsToBuild | ForEach-Object -Parallel {
        $dict = $using:builtTestFileMap
        $builtTemplate = (bicep build $_ --stdout 2>$null) | Out-String
        if ([String]::IsNullOrEmpty($builtTemplate)) {
            throw "Failed to build template [$_]. Try running the command ``bicep build $_ --stdout`` locally for troubleshooting. Make sure you have the latest Bicep CLI installed."
        }
        $templateHashTable = ConvertFrom-Json $builtTemplate -AsHashtable
        $null = $dict.TryAdd($_, $templateHashTable)
    }
}
Describe 'File/folder tests' -Tag 'Modules' {

    Context 'General module folder tests' {

        BeforeDiscovery {
            $moduleFolderTestCases = [System.Collections.ArrayList] @()
            foreach ($moduleFolderPath in $moduleFolderPaths) {
                $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]') # 'avm/res|ptn|utl/<provider>/<resourceType>' would return 'avm', 'res|ptn|utl', '<provider>/<resourceType>'
                $resourceTypeIdentifier = $resourceTypeIdentifier -replace '\\', '/'
                $moduleFolderTestCases += @{
                    moduleFolderName = $resourceTypeIdentifier
                    moduleFolderPath = $moduleFolderPath
                    isTopLevelModule = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
                    moduleType       = $moduleType
                }
            }
        }

        It '[<moduleFolderName>] Module should contain a [` main.bicep `] file.' -TestCases $moduleFolderTestCases {

            param( [string] $moduleFolderPath )

            $hasBicep = Test-Path (Join-Path -Path $moduleFolderPath 'main.bicep')
            $hasBicep | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [` main.json `] file.' -TestCases $moduleFolderTestCases {

            param( [string] $moduleFolderPath )

            $hasARM = Test-Path (Join-Path -Path $moduleFolderPath 'main.json')
            $hasARM | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [` README.md `] file.' -TestCases $moduleFolderTestCases {

            param(
                [string] $moduleFolderPath
            )

            $readMeFilePath = Join-Path -Path $moduleFolderPath 'README.md'
            $pathExisting = Test-Path $readMeFilePath
            $pathExisting | Should -Be $true

            $file = Get-Item -Path $readMeFilePath
            $file.Name | Should -BeExactly 'README.md'
        }

        # only avm/res/network/virtual-network/subnet is allowed to have a version.json file (PoC for child module publishing)
        It '[<moduleFolderName>] Child module should not contain a [` version.json `] file.' -TestCases ($moduleFolderTestCases | Where-Object { (-Not $_.isTopLevelModule) -And ($_.moduleFolderName -ne 'network/virtual-network/subnet') }) {

            param (
                [string] $moduleFolderPath
            )

            $pathExisting = Test-Path (Join-Path -Path $moduleFolderPath 'version.json')
            $pathExisting | Should -Be $false
        }

        # if the child modules version has been increased, the main modules version should be increased as well
        It '[<moduleFolderName>] main module version should be increased if the child version number has been increased.' -TestCases ($moduleFolderTestCases | Where-Object { (-Not $_.isTopLevelModule) }) {

            param (
                [string] $moduleFolderPath
            )

            $subModulePathExisting = Test-Path (Join-Path -Path $moduleFolderPath 'version.json')
            if ($subModulePathExisting) {
                $childModuleVersion = Get-ModuleTargetVersion -ModuleFolderPath $moduleFolderPath
                $parentFolderPath = Split-Path -Path $moduleFolderPath -Parent
                $moduleVersion = Get-ModuleTargetVersion -ModuleFolderPath $parentFolderPath

                ($childModuleVersion.EndsWith('.0') -and -not $moduleVersion.EndsWith('.0')) | Should -Be $false
            }
        }

        It '[<moduleFolderName>] Module should contain a [` ORPHANED.md `] file only if orphaned.' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

            param(
                [string] $moduleFolderPath,
                [string] $moduleType
            )

            $templateFilePath = Join-Path -Path $moduleFolderPath 'main.bicep'

            # Use correct telemetry link based on file path
            switch ($moduleType) {
                'res' { $telemetryCsvLink = $telemetryResCsvLink; break }
                'ptn' { $telemetryCsvLink = $telemetryPtnCsvLink; break }
                'utl' { $telemetryCsvLink = $telemetryUtlCsvLink; break }
                Default {}
            }

            # Fetch CSV
            # =========
            try {
                $rawData = Invoke-WebRequest -Uri $telemetryCsvLink
            } catch {
                $errorMessage = "Failed to download telemetry CSV file from [$telemetryCsvLink] due to [{0}]." -f $_.Exception.Message
                Write-Error $errorMessage
                Set-ItResult -Skipped -Because $errorMessage
            }
            $csvData = $rawData.Content | ConvertFrom-Csv -Delimiter ','

            $moduleName = Get-BRMRepositoryName -TemplateFilePath $templateFilePath
            $relevantCSVRow = $csvData | Where-Object {
                $_.ModuleName -eq $moduleName
            }

            if (-not $relevantCSVRow) {
                $errorMessage = "Failed to identify module [$moduleName]."
                Write-Error $errorMessage
                Set-ItResult -Skipped -Because $errorMessage
            }
            $isOrphaned = [String]::IsNullOrEmpty($relevantCSVRow.PrimaryModuleOwnerGHHandle)

            $orphanedFilePath = Join-Path -Path $moduleFolderPath 'ORPHANED.md'
            if ($isOrphaned) {
                $pathExisting = Test-Path $orphanedFilePath
                $pathExisting | Should -Be $true -Because 'The module is orphaned.'
            } else {
                $pathExisting = Test-Path $orphanedFilePath
                $pathExisting | Should -Be $false -Because ('The module is not orphaned but owned by [{0}].' -f $relevantCSVRow.PrimaryModuleOwnerGHHandle)
            }
        }
    }

    Context 'Top level module folder tests' {

        BeforeDiscovery {
            $topLevelModuleTestCases = [System.Collections.ArrayList]@()
            foreach ($moduleFolderPath in $moduleFolderPaths) {
                $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]') # 'avm/res|ptn|utl/<provider>/<resourceType>' would return 'avm', 'res|ptn|utl', '<provider>/<resourceType>'
                $resourceTypeIdentifier = $resourceTypeIdentifier -replace '\\', '/'
                if (($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2) {
                    $topLevelModuleTestCases += @{
                        moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1]
                        moduleFolderPath = $moduleFolderPath
                        moduleType       = $moduleType
                    }
                }
            }
        }

        It '[<moduleFolderName>] Module should contain a [` version.json `] file.' -TestCases $topLevelModuleTestCases {

            param (
                [string] $moduleFolderPath
            )

            $pathExisting = Test-Path (Join-Path -Path $moduleFolderPath 'version.json')
            $pathExisting | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [` tests `] folder.' -TestCases $topLevelModuleTestCases {

            param(
                [string] $moduleFolderPath
            )

            $pathExisting = Test-Path (Join-Path -Path $moduleFolderPath 'tests')
            $pathExisting | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [` tests/e2e `] folder.' -TestCases $topLevelModuleTestCases {

            param(
                [string] $moduleFolderPath
            )

            $pathExisting = Test-Path (Join-Path -Path $moduleFolderPath 'tests')
            $pathExisting | Should -Be $true
        }

        It '[<moduleFolderName>] Module should contain a [` tests/e2e/*waf-aligned `] folder.' -TestCases ($topLevelModuleTestCases | Where-Object { $_.moduleType -eq 'res' }) {

            param(
                [string] $moduleFolderPath
            )

            $wafAlignedFolder = Get-ChildItem -Directory (Join-Path -Path $moduleFolderPath 'tests' 'e2e') -Filter '*waf-aligned'
            $wafAlignedFolder | Should -Not -BeNullOrEmpty
        }

        It '[<moduleFolderName>] Module should contain a [` tests/e2e/*defaults `] folder.' -TestCases ($topLevelModuleTestCases | Where-Object { $_.moduleType -eq 'res' }) {

            param(
                [string] $moduleFolderPath
            )

            # only one Domain-Services instance can be provisioned in a tenant and only one test (the waf-aligned) is possible.
            if ($moduleFolderName.Equals('res/aad/domain-service')) {
                Set-ItResult -Skipped -Because 'only one instance of the Domain-Service can be deployed at a time, and as such, also only one test can exist at a time.'
                return
            }

            $defaultsFolder = Get-ChildItem -Directory (Join-Path -Path $moduleFolderPath 'tests' 'e2e') -Filter '*defaults'
            $defaultsFolder | Should -Not -BeNullOrEmpty
        }

        It '[<moduleFolderName>] Module should contain one [` main.test.bicep `] file in each e2e test folder.' -TestCases $topLevelModuleTestCases {

            param(
                [string] $moduleFolderName,
                [string] $moduleFolderPath
            )

            $e2eTestFolderPathList = Get-ChildItem -Directory (Join-Path -Path $moduleFolderPath 'tests' 'e2e')
            foreach ($e2eTestFolderPath in $e2eTestFolderPathList) {
                $filePath = Join-Path -Path $e2eTestFolderPath 'main.test.bicep'
                $pathExisting = Test-Path $filePath
                $pathExisting | Should -Be $true -Because "path [$filePath] is expected to exist."
            }
        }
    }
}

Describe 'Pipeline tests' -Tag 'Pipeline' {

    BeforeDiscovery {
        $pipelineTestCases = [System.Collections.ArrayList] @()
        foreach ($moduleFolderPath in $moduleFolderPaths) {

            $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')[2] -replace '\\', '/' # 'avm/res|ptn|utl/<provider>/<resourceType>' would return '<provider>/<resourceType>'
            $relativeModulePath = Join-Path 'avm' ($moduleFolderPath -split '[\/|\\]avm[\/|\\]')[1]

            $isTopLevelModule = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
            if ($isTopLevelModule) {

                $workflowsFolderName = Join-Path $repoRootPath '.github' 'workflows'
                $workflowFileName = Get-PipelineFileName -ResourceIdentifier $relativeModulePath
                $workflowPath = Join-Path $workflowsFolderName $workflowFileName

                $pipelineTestCases += @{
                    relativeModulePath = $relativeModulePath
                    moduleFolderName   = $resourceTypeIdentifier
                    workflowFileName   = $workflowFileName
                    workflowPath       = $workflowPath
                }
            }
        }
    }

    It '[<moduleFolderName>] Module should have a GitHub workflow in path [.github/workflows/<workflowFileName>].' -TestCases $pipelineTestCases {

        param(
            [string] $WorkflowPath
        )

        Test-Path $WorkflowPath | Should -Be $true -Because "path [$WorkflowPath] should exist."
    }

    It '[<moduleFolderName>] GitHub workflow [<WorkflowFileName>] should have [workflowPath] environment variable with value [.github/workflows/<WorkflowFileName>].' -TestCases $pipelineTestCases {

        param(
            [string] $WorkflowPath,
            [string] $WorkflowFileName
        )

        if (-not (Test-Path $WorkflowPath)) {
            Set-ItResult -Skipped -Because "Cannot test content of file in path [$WorkflowPath] as it does not exist."
            return
        }

        $environmentVariables = Get-WorkflowEnvVariablesAsObject -WorkflowPath $WorkflowPath

        $environmentVariables.Keys | Should -Contain 'workflowPath'
        $environmentVariables['workflowPath'] | Should -Be ".github/workflows/$workflowFileName"
    }
}

Describe 'Module tests' -Tag 'Module' {

    Context 'Readme content tests' -Tag 'Readme' {

        BeforeDiscovery {
            $readmeFileTestCases = [System.Collections.ArrayList] @()

            foreach ($moduleFolderPath in $moduleFolderPaths) {

                $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')[2] -replace '\\', '/' # 'avm/res|ptn|utl/<provider>/<resourceType>' would return '<provider>/<resourceType>'
                $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'

                $readmeFileTestCases += @{
                    moduleFolderName    = $resourceTypeIdentifier
                    templateFileContent = $builtTestFileMap[$templateFilePath]
                    templateFilePath    = $templateFilePath
                    readMeFilePath      = Join-Path -Path $moduleFolderPath 'README.md'
                }
            }
        }

        BeforeAll {
            $telemetryUrl = 'https://aka.ms/avm/static/telemetry'
            try {
                $rawResponse = Invoke-WebRequest -Uri $telemetryUrl
                if (($rawResponse.Headers['Content-Type'] | Out-String) -like '*text/plain*') {
                    $telemetryFileContent = $rawResponse.Content -split '\n'
                } else {
                    Write-Warning "Failed to fetch telemetry information from [$telemetryUrl]. NOTE: You should re-run the script again at a later stage to ensure all data is collected and the readme correctly populated." # Incorrect Url (e.g., points to HTML)
                    $telemetryFileContent = $null
                }
            } catch {
                Write-Warning "Failed to fetch telemetry information from [$telemetryUrl]. NOTE: You should re-run the script again at a later stage to ensure all data is collected and the readme correctly populated." # Invalid url
                $telemetryFileContent = $null
            }

            .  (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-CrossReferencedModuleList.ps1')
            # load cross-references
            $crossReferencedModuleList = Get-CrossReferencedModuleList

        }

        It '[<moduleFolderName>] `Set-ModuleReadMe` script should not apply any updates.' -TestCases $readmeFileTestCases {

            param(
                [string] $templateFilePath,
                [hashtable] $templateFileContent,
                [string] $readMeFilePath
            )

            # Get current hash
            $fileHashBefore = (Get-FileHash $readMeFilePath).Hash

            # Load function
            . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')

            # Apply update with already compiled template content
            Set-ModuleReadMe -TemplateFilePath $templateFilePath -PreLoadedContent @{
                TemplateFileContent       = $templateFileContent
                CrossReferencedModuleList = $crossReferencedModuleList
                TelemetryFileContent      = $telemetryFileContent
            }

            # Get hash after 'update'
            $fileHashAfter = (Get-FileHash $readMeFilePath).Hash

            # Compare
            $filesAreTheSame = $fileHashBefore -eq $fileHashAfter
            if (-not $filesAreTheSame) {
                $diffResponse = git diff $readMeFilePath
                Write-Warning ($diffResponse | Out-String) -Verbose

                # Reset readme file to original state
                git checkout HEAD -- $readMeFilePath
            }

            $mdFormattedDiff = ($diffResponse -join '</br>') -replace '\|', '\|'
            $filesAreTheSame | Should -Be $true -Because ('The file hashes before and after applying the `/utilities/tools/Set-AVMModule.ps1` and more precisely the `/utilities/pipelines/sharedScripts/Set-ModuleReadMe.ps1` function should be identical and should not have diff </br><pre>{0}</pre>. Please re-run the `Set-AVMModule` function for this module.' -f $mdFormattedDiff)
        }
    }

    Context 'Compiled ARM template tests' -Tag 'ARM' {

        BeforeDiscovery {
            $armTemplateTestCases = [System.Collections.ArrayList] @()

            foreach ($moduleFolderPath in $moduleFolderPaths) {

                # Skipping folders without a [main.bicep] template
                $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
                if (-not (Test-Path $templateFilePath)) {
                    continue
                }

                $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')[2] -replace '\\', '/' # 'avm/res|ptn|utl/<provider>/<resourceType>' would return '<provider>/<resourceType>'

                $armTemplateTestCases += @{
                    moduleFolderName = $resourceTypeIdentifier
                    moduleFolderPath = $moduleFolderPath
                    templateFilePath = $templateFilePath
                }
            }
        }

        It '[<moduleFolderName>] The [main.json] ARM template should be based on the current [main.bicep] Bicep template.' -TestCases $armTemplateTestCases {

            param(
                [string] $moduleFolderName,
                [string] $moduleFolderPath,
                [string] $templateFilePath
            )

            $armTemplatePath = Join-Path $moduleFolderPath 'main.json'

            # Current json

            if (-not (Test-Path $armTemplatePath)) {
                $false | Should -Be $true -Because "[main.json] file for module [$moduleFolderName] is missing."
                return # Skipping if test was failing
            }

            $originalJson = Remove-JSONMetadata -TemplateObject (Get-Content $armTemplatePath -Raw | ConvertFrom-Json -Depth 99 -AsHashtable)
            $originalJson = ConvertTo-OrderedHashtable -JSONInputObject (ConvertTo-Json $originalJson -Depth 99)

            # Recompile json
            $null = Remove-Item -Path $armTemplatePath -Force
            bicep build $templateFilePath

            $newJson = Remove-JSONMetadata -TemplateObject (Get-Content $armTemplatePath -Raw | ConvertFrom-Json -Depth 99 -AsHashtable)
            $newJson = ConvertTo-OrderedHashtable -JSONInputObject (ConvertTo-Json $newJson -Depth 99)

            # compare
            (ConvertTo-Json $originalJson -Depth 99) | Should -Be (ConvertTo-Json $newJson -Depth 99) -Because "the [$moduleFolderName] [main.json] should be based on the latest [main.bicep] file. Please run [` bicep build >bicepFilePath< `] using the latest Bicep CLI version."

            # Reset template file to original state
            git checkout HEAD -- $armTemplatePath
        }
    }

    Context 'Template tests' -Tag 'Template' {

        BeforeDiscovery {
            $moduleFolderTestCases = [System.Collections.ArrayList] @()
            foreach ($moduleFolderPath in $moduleFolderPaths) {

                $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
                $templateFileContent = $builtTestFileMap[$templateFilePath]

                $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]') # 'avm/res|ptn|utl/<provider>/<resourceType>' would return 'avm', 'res|ptn|utl', '<provider>/<resourceType>'
                $resourceTypeIdentifier = $resourceTypeIdentifier -replace '\\', '/'

                # Test file setup
                $moduleFolderTestCases += @{
                    moduleFolderName       = $resourceTypeIdentifier
                    templateFileContent    = $templateFileContent
                    templateFilePath       = $templateFilePath
                    templateFileParameters = Resolve-ReadMeParameterList -TemplateFileContent $templateFileContent
                    readMeFilePath         = Join-Path (Split-Path $templateFilePath) 'README.md'
                    isTopLevelModule       = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
                    moduleType             = $moduleType
                }
            }
        }

        Context 'General' {

            It '[<moduleFolderName>] The template file should not be empty.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )
                $templateFileContent | Should -Not -BeNullOrEmpty
            }

            It '[<moduleFolderName>] Template schema version should be the latest.' -TestCases $moduleFolderTestCases {
                # the actual value changes depending on the scope of the template (RG, subscription, MG, tenant) !!
                # https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax
                param(
                    [hashtable] $templateFileContent
                )

                $Schemaverion = $templateFileContent.'$schema'
                $SchemaArray = @()
                if ($Schemaverion -eq $RgDeploymentSchema) {
                    $SchemaOutput = $true
                } elseIf ($Schemaverion -eq $SubscriptionDeploymentSchema) {
                    $SchemaOutput = $true
                } elseIf ($Schemaverion -eq $MgDeploymentSchema) {
                    $SchemaOutput = $true
                } elseIf ($Schemaverion -eq $TenantDeploymentSchema) {
                    $SchemaOutput = $true
                } else {
                    $SchemaOutput = $false
                }
                $SchemaArray += $SchemaOutput
                $SchemaArray | Should -Not -Contain $false
            }

            It '[<moduleFolderName>] Template schema should use HTTPS reference.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )
                $Schemaverion = $templateFileContent.'$schema'
                ($Schemaverion.Substring(0, 5) -eq 'https') | Should -Be $true
            }

            It '[<moduleFolderName>] The template file should contain required elements [schema], [contentVersion], [resources].' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )
                $templateFileContent.Keys | Should -Contain '$schema'
                $templateFileContent.Keys | Should -Contain 'contentVersion'
                $templateFileContent.Keys | Should -Contain 'resources'
            }

            It '[<moduleFolderName>] template file should have a module name specified.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )

                $templateFileContent.metadata.name | Should -Not -BeNullOrEmpty
            }

            It '[<moduleFolderName>] template file should have a module description specified.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )

                $templateFileContent.metadata.description | Should -Not -BeNullOrEmpty
            }
        }

        Context 'Parameters' {

            It '[<moduleFolderName>] The Location should be defined as a parameter, with the default value of "[resourceGroup().Location]" or "global" for ResourceGroup deployment scope.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileParameters
                )

                if ((($templateFileContent.'$schema'.Split('/')[5]).Split('.')[0]) -eq (($RgDeploymentSchema.Split('/')[5]).Split('.')[0])) {
                    if ($locationParameter = $templateFileParameters.location) {
                        $locationParameter.defaultValue | Should -BeIn @('[resourceGroup().Location]', 'global')
                    }
                }
            }

            # If any resources in the module are deployed, a telemetry deployment should be carried out as well
            It '[<moduleFolderName>] The telemetry parameter should be present & have the expected type, default value & metadata description.' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule -and $_.templateFileContent.resources.count -gt 0 }) {

                param(
                    [hashtable] $templateFileParameters
                )

                $templateFileParameters.PSBase.Keys | Should -Contain 'enableTelemetry'
                $templateFileParameters.enableTelemetry.type | Should -Be 'bool'
                $templateFileParameters.enableTelemetry.defaultValue | Should -Be 'true'
                $templateFileParameters.enableTelemetry.metadata.description | Should -Be 'Optional. Enable/Disable usage telemetry for module.'
            }

            It '[<moduleFolderName>] Parameter & UDT names should be camel-cased (no dashes or underscores and must start with lower-case letter).' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileParameters
                )

                if (-not $templateFileParameters) {
                    Set-ItResult -Skipped -Because 'the module template has no parameters.'
                    return
                }

                $incorrectParameters = @()
                foreach ($parameter in ($templateFileParameters.PSBase.Keys | Sort-Object -Culture 'en-US')) {
                    # Parameters in the object are formatted like
                    # - tags
                    # - customerManagedKey.keyVaultResourceId
                    $paramName = ($parameter -split '\.')[-1]

                    # workaround for Azure Stack HCI cluster deployment settings resource, where property names have underscores - https://github.com/Azure/Azure-Verified-Modules/issues/1029
                    if ($moduleFolderPath -match 'azure-stack-hci[/\\]cluster[/\\]deployment-settings' -and $paramName -in ('bandwidthPercentage_SMB', 'priorityValue8021Action_Cluster', 'priorityValue8021Action_SMB')) {
                        Set-ItResult -Skipped -Because 'the module path matches "azure-stack-hci/cluster/deployment-settings" and the parameter name is in list [bandwidthPercentage_SMB, priorityValue8021Action_Cluster, priorityValue8021Action_SMB], which have underscores in the API spec.'
                        return
                    }

                    if ($paramName.substring(0, 1) -cnotmatch '[a-z]' -or $paramName -match '-' -or $paramName -match '_') {
                        $incorrectParameters += @() + $parameter
                    }
                }
                $incorrectParameters | Should -BeNullOrEmpty -Because ('parameters in the template file should be camel-cased. Found incorrect items: [{0}].' -f ($incorrectParameters -join ', '))
            }

            It "[<moduleFolderName>] Each parameters' & UDT's description should start with a one word category starting with a capital letter, followed by a dot, a space and the actual description text ending with a dot." -TestCases $moduleFolderTestCases {

                param(
                    [string] $moduleFolderName,
                    [hashtable] $templateFileContent,
                    [hashtable] $templateFileParameters
                )

                if (-not $templateFileParameters) {
                    Set-ItResult -Skipped -Because 'the module template has no parameters.'
                    return
                }

                $incorrectParameters = @()
                foreach ($parameter in ($templateFileParameters.PSBase.Keys | Sort-Object -Culture 'en-US')) {
                    $data = $templateFileParameters.$parameter.metadata.description
                    if ($data -notmatch '(?s)^[A-Z][a-zA-Z]+\. .+\.$') {
                        $incorrectParameters += $parameter
                    }
                }
                $incorrectParameters | Should -BeNullOrEmpty -Because ('each parameter in the template file should have a description starting with a "Category" prefix like "Required. " and ending with a dot. Found incorrect items: [{0}].' -f ($incorrectParameters -join ', '))
            }

            # TODO: Update specs with note
            It "[<moduleFolderName>] Conditional parameters' & UDT's description should contain 'Required if' followed by the condition making the parameter required." -TestCases $moduleFolderTestCases {

                param(
                    [string] $moduleFolderName,
                    [hashtable] $templateFileContent,
                    [hashtable] $templateFileParameters
                )

                if (-not $templateFileParameters) {
                    Set-ItResult -Skipped -Because 'the module template has no parameters.'
                    return
                }

                $incorrectParameters = @()
                foreach ($parameter in ($templateFileParameters.PSBase.Keys | Sort-Object -Culture 'en-US')) {
                    $data = $templateFileParameters.$parameter.metadata.description
                    switch -regex ($data) {
                        '^Conditional. .*' {
                            if ($data -notmatch '.+\. Required if .+') {
                                $incorrectParameters += $parameter
                            }
                        }
                    }
                }
                $incorrectParameters | Should -BeNullOrEmpty -Because ('conditional parameters in the template file should lack a description that starts with "Required.". Found incorrect items: [{0}].' -f ($incorrectParameters -join ', '))
            }


            It '[<moduleFolderName>] All non-required parameters & UDTs in template file should not have description that start with "Required.".' -TestCases $moduleFolderTestCases {
                param (
                    [hashtable] $templateFileContent,
                    [hashtable] $templateFileParameters
                )

                $incorrectParameters = @()
                foreach ($parameter in ($templateFileParameters.PSBase.Keys | Sort-Object -Culture 'en-US')) {
                    $isRequired = Get-IsParameterRequired -TemplateFileContent $templateFileContent -Parameter $templateFileParameters.$parameter

                    if (-not $isRequired) {
                        $description = $templateFileParameters.$parameter.metadata.description
                        if ($description -match '^Required\.') {
                            $incorrectParameters += $parameter
                        }
                    }
                }

                $incorrectParameters | Should -BeNullOrEmpty -Because ('only required parameters in the template file should have a description that starts with "Required.". Found incorrect items: [{0}].' -f ($incorrectParameters -join ', '))
            }

            It '[<moduleFolderName>] All required parameters & UDTs in template file should have description that start with "(Required|Conditional).".' -TestCases $moduleFolderTestCases {
                param (
                    [hashtable] $templateFileContent,
                    [hashtable] $templateFileParameters
                )

                $incorrectParameters = @()
                foreach ($parameter in ($templateFileParameters.PSBase.Keys | Sort-Object -Culture 'en-US')) {
                    $isRequired = Get-IsParameterRequired -TemplateFileContent $templateFileContent -Parameter $templateFileParameters.$parameter

                    if ($isRequired) {
                        $description = $templateFileParameters.$parameter.metadata.description
                        if ($description -notmatch '^(Required|Conditional)\.') {
                            $incorrectParameters += $parameter
                        }
                    }
                }

                $incorrectParameters | Should -BeNullOrEmpty -Because ('required parameters in the template file should have a description that starts with "Required.". Found incorrect items: [{0}].' -f ($incorrectParameters -join ', '))
            }

            Context 'Schema-based User-defined-types tests' -Tag 'UDT' {

                BeforeDiscovery {
                    # Creating custom test cases for the UDT schema-based tests
                    $udtTestCases = [System.Collections.ArrayList] @() # General UDT tests (e.g. param should exist)
                    $udtSpecificTestCases = [System.Collections.ArrayList] @() # Specific UDT test cases for singular UDTs (e.g. tags)
                    foreach ($moduleFolderPath in $moduleFolderPaths) {

                        if ($moduleFolderPath -match '[\/|\\]avm[\/|\\](ptn|utl)[\/|\\]') {
                            # Skip UDT interface tests for ptn & utl modules
                            continue
                        }

                        $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]') # 'avm/res|ptn|utl/<provider>/<resourceType>' would return 'avm', 'res|ptn|utl', '<provider>/<resourceType>'
                        $resourceTypeIdentifier = $resourceTypeIdentifier -replace '\\', '/'
                        $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
                        $templateFileContent = $builtTestFileMap[$templateFilePath]

                        $udtSpecificTestCases += @{
                            moduleFolderName         = $resourceTypeIdentifier
                            templateFileContent      = $templateFileContent
                            templateFileContentBicep = Get-Content $templateFilePath
                            moduleType               = $moduleType
                        }

                        # Setting expected URL only for those that doen't have multiple different variants
                        $interfaceBase = 'https://aka.ms/avm/interfaces'
                        $udtCases = @(
                            @{
                                parameterName = 'diagnosticSettings'
                                link          = "$interfaceBase/diagnostic-settings"
                            }
                            @{
                                parameterName = 'roleAssignments'
                                link          = "$interfaceBase/role-assignments"
                            }
                            @{
                                parameterName = 'lock'
                                link          = "$interfaceBase/resource-locks"
                            }
                            @{
                                parameterName = 'managedIdentities'
                                link          = "$interfaceBase/managed-identities"
                            }
                            @{
                                parameterName = 'privateEndpoints'
                                link          = "$interfaceBase/private-endpoints"
                            }
                            @{
                                parameterName = 'customerManagedKey'
                                link          = "$interfaceBase/customer-managed-keys"
                            }
                        )

                        foreach ($udtCase in $udtCases) {
                            $udtTestCases += @{
                                moduleFolderName         = $resourceTypeIdentifier
                                templateFileContent      = $templateFileContent
                                templateFileContentBicep = Get-Content $templateFilePath
                                parameterName            = $udtCase.parameterName
                                expectedUdtUrl           = $udtCase.udtExpectedUrl ? $udtCase.udtExpectedUrl : ''
                                link                     = $udtCase.link
                            }
                        }
                    }
                }

                It '[<moduleFolderName>] If template has a parameter [<parameterName>], it should implement AVM''s corresponding user-defined type.' -TestCases $udtTestCases {

                    param(
                        [hashtable] $templateFileContent,
                        [string[]] $templateFileContentBicep,
                        [string] $parameterName,
                        [string] $link
                    )

                    if ($templateFileContent.parameters.Keys -contains $parameterName) {

                        if ($templateFileContent.parameters.$parameterName.Keys -contains 'items') {
                            # If parameter is an array, the UDT may focus on each element
                            $templateFileContent.parameters.$parameterName.items.Keys | Should -Contain '$ref' -Because "the [$parameterName] parameter should use a user-defined type. For information please review the [AVM Specs]($link)."
                        } else {
                            # If not, the parameter itself should reference a UDT
                            $templateFileContent.parameters.$parameterName.Keys | Should -Contain '$ref' -Because "the [$parameterName] parameter should use a user-defined type. For information please review the [AVM Specs]($link)."
                        }
                    } else {
                        Set-ItResult -Skipped -Because "the module template has no [$parameterName] parameter."
                    }
                }

                It '[<moduleFolderName>] If a UDT definition [managedIdentitiesType] exists and supports system-assigned-identities, the template should have an output for its principal ID.' -TestCases $udtSpecificTestCases {

                    param(
                        [hashtable] $templateFileContent
                    )

                    if ($templateFileContent.definitions.Keys -contains 'managedIdentitiesType' -and $templateFileContent.definitions.managedIdentitiesType.properties.keys -contains 'systemAssigned') {
                        $templateFileContent.outputs.Keys | Should -Contain 'systemAssignedMIPrincipalId' -Because 'The AVM specs require a this output. For information please review the [AVM Specs](https://aka.ms/avm/interfaces/managed-identities).'
                    } else {
                        Set-ItResult -Skipped -Because 'the module template has no [managedIdentitiesType] UDT definition or does not support system-assigned-identities.'
                    }
                }

                It '[<moduleFolderName>] If a parameter [tags] exists it should be nullable.' -TestCases $udtSpecificTestCases {

                    param(
                        [hashtable] $templateFileContent
                    )

                    if ($templateFileContent.parameters.Keys -contains 'tags') {
                        $templateFileContent.parameters.tags.nullable | Should -Be $true -Because 'The AVM specs require a specific format. For information please review the [AVM Specs](https://aka.ms/avm/interfaces/tags).'
                    } else {
                        Set-ItResult -Skipped -Because 'the module template has no [tags] parameter.'
                    }
                }
            }
        }

        Context 'Variables' {
            It '[<moduleFolderName>] Variable names should be camel-cased (no dashes or underscores and must start with lower-case letter).' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )

                if (-not $templateFileContent.variables) {
                    Set-ItResult -Skipped -Because 'the module template has no variables.'
                    return
                }

                $incorrectVariables = @()
                $Variables = $templateFileContent.variables.Keys

                foreach ($variable in $Variables) {
                    # ^[a-z]+[a-zA-Z0-9]+$ = starts with lower-case letter & may have uppercase letter or numbers later
                    # ^\$fxv#[0-9]+$ = starts with [$fxv#] & ends with a number. This function value is created as a variable when using a Bicep function like loadFileAsBase64() or loadFromJson()
                    if ($variable -cnotmatch '^[a-z]+[a-zA-Z0-9]+$|^\$fxv#[0-9]+$' -or $variable -match '-') {
                        $incorrectVariables += $variable
                    }
                }
                $incorrectVariables | Should -BeNullOrEmpty
            }
        }

        Context 'Resources' {
            # If any resources in the module are deployed, a telemetry deployment should be carried out as well
            It '[<moduleFolderName>] Telemetry deployment should be present in the template.' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule -and $_.templateFileContent.resources.count -gt 0 }) {

                param(
                    [hashtable] $templateFileContent
                )

                # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
                if ($templateFileContent.resources.GetType().Name -eq 'Object[]') {
                    $templateResources = $templateFileContent.resources
                } else {
                    $templateResources = $templateFileContent.resources.Keys | ForEach-Object { $templateFileContent.resources[$_] }
                }

                $telemetryDeployment = $templateResources | Where-Object { $_.condition -like '*telemetry*' -and $_.name -like '*46d3xbcp*' } # The AVM telemetry prefix
                $telemetryDeployment | Should -Not -BeNullOrEmpty -Because 'A telemetry resource with name prefix [46d3xbcp] should be present in the template'
            }

            It '[<moduleFolderName>] Telemetry deployment should have correct condition in the template.' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

                param(
                    [hashtable] $templateFileContent
                )

                # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
                if ($templateFileContent.resources.GetType().Name -eq 'Object[]') {
                    $templateResources = $templateFileContent.resources
                } else {
                    $templateResources = $templateFileContent.resources.Keys | ForEach-Object { $templateFileContent.resources[$_] }
                }

                $telemetryDeployment = $templateResources | Where-Object { $_.condition -like '*telemetry*' -and $_.name -like '*46d3xbcp*' } # The AVM telemetry prefix

                if (-not $telemetryDeployment) {
                    Set-ItResult -Skipped -Because 'telemetry was not implemented in template'
                    return
                }

                $telemetryDeployment.condition | Should -Be "[parameters('enableTelemetry')]"
            }

            It '[<moduleFolderName>] Telemetry deployment should have expected inner output for verbosity.' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

                param(
                    [hashtable] $templateFileContent
                )

                # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
                if ($templateFileContent.resources.GetType().Name -eq 'Object[]') {
                    $templateResources = $templateFileContent.resources
                } else {
                    $templateResources = $templateFileContent.resources.Keys | ForEach-Object { $templateFileContent.resources[$_] }
                }

                $telemetryDeployment = $templateResources | Where-Object { $_.condition -like '*telemetry*' -and $_.name -like '*46d3xbcp*' } # The AVM telemetry prefix

                if (-not $telemetryDeployment) {
                    Set-ItResult -Skipped -Because 'telemetry was not implemented in template'
                    return
                }

                $telemetryDeployment.properties.template.outputs.Keys | Should -Contain 'telemetry'
                $telemetryDeployment.properties.template.outputs['telemetry'].value | Should -Be 'For more information, see https://aka.ms/avm/TelemetryInfo'
            }

            It '[<moduleFolderName>] Telemetry deployment should have expected telemetry identifier.' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

                param(
                    [string] $templateFilePath,
                    [string] $moduleType,
                    [hashtable] $templateFileContent
                )

                # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
                if ($templateFileContent.resources.GetType().Name -eq 'Object[]') {
                    $templateResources = $templateFileContent.resources
                } else {
                    $templateResources = $templateFileContent.resources.Keys | ForEach-Object { $templateFileContent.resources[$_] }
                }

                $telemetryDeployment = $templateResources | Where-Object { $_.condition -like '*telemetry*' -and $_.name -like '*46d3xbcp*' } # The AVM telemetry prefix

                if (-not $telemetryDeployment) {
                    Set-ItResult -Skipped -Because 'telemetry was not implemented in template'
                    return
                }

                # Use correct telemetry link based on file path
                switch ($moduleType) {
                    'res' { $telemetryCsvLink = $telemetryResCsvLink; break }
                    'ptn' { $telemetryCsvLink = $telemetryPtnCsvLink; break }
                    'utl' { $telemetryCsvLink = $telemetryUtlCsvLink; break }
                    Default {}
                }

                # Fetch CSV
                # =========
                try {
                    $rawData = Invoke-WebRequest -Uri $telemetryCsvLink
                } catch {
                    $errorMessage = "Failed to download telemetry CSV file from [$telemetryCsvLink] due to [{0}]." -f $_.Exception.Message
                    Write-Error $errorMessage
                    Set-ItResult -Skipped -Because $errorMessage
                }
                $csvData = $rawData.Content | ConvertFrom-Csv -Delimiter ','

                # Get correct row item & expected identifier
                # ==========================================
                $moduleName = Get-BRMRepositoryName -TemplateFilePath $TemplateFilePath
                $relevantCSVRow = $csvData | Where-Object {
                    $_.ModuleName -eq $moduleName
                }

                if (-not $relevantCSVRow) {
                    $errorMessage = "Failed to identify module [$moduleName]."
                    Write-Error $errorMessage
                    Set-ItResult -Skipped -Because $errorMessage
                }
                $expectedTelemetryIdentifier = $relevantCSVRow.TelemetryIdPrefix

                # Collect resource & compare
                # ==========================

                $telemetryDeploymentName = $telemetryDeployment.name # The AVM telemetry prefix
                $telemetryDeploymentName | Should -Match "$expectedTelemetryIdentifier"
            }
        }

        Context 'Output' {

            It '[<moduleFolderName>] Output names should be camel-cased (no dashes or underscores and must start with lower-case letter).' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )
                $CamelCasingFlag = @()
                $Outputs = $templateFileContent.outputs.Keys

                foreach ($Output in $Outputs) {
                    if ($Output.substring(0, 1) -cnotmatch '[a-z]' -or $Output -match '-' -or $Output -match '_') {
                        $CamelCasingFlag += $false
                    } else {
                        $CamelCasingFlag += $true
                    }
                }
                $CamelCasingFlag | Should -Not -Contain $false
            }

            It '[<moduleFolderName>] Output names description should start with a capital letter and contain text ending with a dot.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )

                if (-not $templateFileContent.outputs) {
                    Set-ItResult -Skipped -Because 'the module template has no outputs.'
                    return
                }

                $incorrectOutputs = @()
                $templateOutputs = $templateFileContent.outputs.Keys
                foreach ($output in $templateOutputs) {
                    $data = ($templateFileContent.outputs.$output.metadata).description
                    if ($data -notmatch '(?s)^[A-Z].+\.$') {
                        $incorrectOutputs += $output
                    }
                }
                $incorrectOutputs | Should -BeNullOrEmpty
            }

            # ? remove ? or update specs
            It '[<moduleFolderName>] Location output should be returned for resources that use it.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent,
                    [string] $templateFilePath
                )

                $outputs = $templateFileContent.outputs

                $primaryResourceType = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').split('/avm/')[1]
                $primaryResourceTypeResource = $templateFileContent.resources | Where-Object { $_.type -eq $primaryResourceType }

                if ($primaryResourceTypeResource.keys -contains 'location' -and $primaryResourceTypeResource.location -ne 'global') {
                    # If the main resource has a location property, an output should be returned too
                    $outputs.keys | Should -Contain 'location'

                    # It should further reference the location property of the primary resource and not e.g. the location input parameter
                    $outputs.location.value | Should -Match $primaryResourceType
                }
            }

            # ? remove ? or update specs
            It '[<moduleFolderName>] Resource Group output should exist for resources that are deployed into a resource group scope.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent,
                    [string] $templateFilePath
                )

                if ($templateFileContent.resources.count -eq 0) {
                    Set-ItResult -Skipped -Because 'with no resources are deployed in the template, the test is not required'
                    return
                }

                $outputs = $templateFileContent.outputs.Keys
                $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $templateFilePath

                if ($deploymentScope -eq 'resourceGroup') {
                    $outputs | Should -Contain 'resourceGroupName'
                }
            }

            It '[<moduleFolderName>] Resource modules should have a name output.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent,
                    [string] $readMeFilePath
                )

                # We're fetching the primary resource type from the first line of the readme
                $readMeFileContentHeader = (Get-Content -Path $readMeFilePath)[0]
                if ($readMeFileContentHeader -match '^.*`\[(.+)\]`.*') {
                    $primaryResourceType = $matches[1]
                } else {
                    Write-Error "Cannot identity primary resource type in readme header [$readMeFileContentHeader] and cannot execute the test."
                    return
                }

                # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
                if ($templateFileContent.resources.GetType().Name -eq 'Object[]') {
                    $templateResources = $templateFileContent.resources
                } else {
                    $templateResources = $templateFileContent.resources.Keys | ForEach-Object { $templateFileContent.resources[$_] }
                }

                if ($templateResources.type -notcontains $primaryResourceType) {
                    Set-ItResult -Skipped -Because 'the module template has no primary resource to fetch a name from.'
                    return
                }

                # Otherwise test for standard outputs
                $outputs = $templateFileContent.outputs.Keys
                $outputs | Should -Contain 'name'
            }

            It '[<moduleFolderName>] Resource modules should have a Resource ID output.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent,
                    [string] $readMeFilePath
                )

                # We're fetching the primary resource type from the first line of the readme
                $readMeFileContentHeader = (Get-Content -Path $readMeFilePath)[0]
                if ($readMeFileContentHeader -match '^.*`\[(.+)\]`.*') {
                    $primaryResourceType = $matches[1]
                } else {
                    Write-Error "Cannot identity primary resource type in readme header [$readMeFileContentHeader] and cannot execute the test."
                    return
                }

                # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
                if ($templateFileContent.resources.GetType().Name -eq 'Object[]') {
                    $templateResources = $templateFileContent.resources
                } else {
                    $templateResources = $templateFileContent.resources.Keys | ForEach-Object { $templateFileContent.resources[$_] }
                }

                # check if module contains a 'primary' resource we could draw a resource ID from
                if ($templateResources.type -notcontains $primaryResourceType) {
                    Set-ItResult -Skipped -Because 'the module template has no primary resource to fetch a resource ID from.'
                    return
                }

                # Otherwise test for standard outputs
                $outputs = $templateFileContent.outputs.Keys
                $outputs | Should -Contain 'resourceId'
            }

            It '[<moduleFolderName>] Resource modules Principal ID output should exist, if supported.' -TestCases $moduleFolderTestCases {

                param(
                    [hashtable] $templateFileContent
                )

                if ($templateFileContent.parameters.Keys -notcontains 'managedIdentities') {
                    Set-ItResult -Skipped -Because 'the module template seems not to support an identity object.'
                    return
                }

                $typeRef = Split-Path $templateFileContent.parameters.managedIdentities.'$ref' -Leaf
                $typeProperties = ($templateFileContent.definitions[$typeRef]).properties
                if ($typeProperties.Keys -notcontains 'systemAssigned') {
                    Set-ItResult -Skipped -Because 'the managedIdentities input does not support system-assigned identities.'
                    return
                }

                # Otherwise test for standard outputs
                $outputs = $templateFileContent.outputs.Keys
                $outputs | Should -Contain 'systemAssignedMIPrincipalId'
            }
        }

        Context 'UDT-spcific' {

            It '[<moduleFolderName>] A UDT should not be of type array, but instead the parameter that uses it. AVM-Spec-Ref: BCPNFR18.' -TestCases $moduleFolderTestCases -Tag 'UDT' {

                param(
                    [hashtable] $templateFileContent
                )

                if (-not $templateFileContent.definitions) {
                    Set-ItResult -Skipped -Because 'the module template has no user-defined types.'
                    return
                }

                $incorrectTypes = [System.Collections.ArrayList]@()
                foreach ($type in $templateFileContent.definitions.Keys) {
                    if ($templateFileContent.definitions.$type.type -eq 'array') {
                        $incorrectTypes += $type
                    }
                }
                # To be re-enabled once more modules are prepared. The code right below can then be removed.
                # $incorrectTypes | Should -BeNullOrEmpty -Because ('no user-defined type should be declared as an array, but instead the parameter that uses the type. This makes the template and its parameters easier to understand. Found incorrect items: [{0}].' -f ($incorrectTypes -join ', '))
                if ($incorrectTypes.Count -gt 0) {
                    $warningMessage = ('No user-defined type should be declared as an array, but instead the parameter that uses the type. This makes the template and its parameters easier to understand. Found incorrect items: [{0}].' -f ($incorrectTypes -join ', '))
                    Write-Warning $warningMessage

                    Write-Output @{
                        Warning = $warningMessage
                    }
                }
            }

            It '[<moduleFolderName>] A UDT should not be nullable, but instead the parameter that uses it. AVM-Spec-Ref: BCPNFR18.' -TestCases $moduleFolderTestCases -Tag 'UDT' {

                param(
                    [hashtable] $templateFileContent
                )

                if (-not $templateFileContent.definitions) {
                    Set-ItResult -Skipped -Because 'the module template has no user-defined types.'
                    return
                }

                $incorrectTypes = [System.Collections.ArrayList]@()
                foreach ($type in $templateFileContent.definitions.Keys) {
                    if ($templateFileContent.definitions.$type.nullable -eq $true) {
                        $incorrectTypes += $type
                    }
                }

                # To be re-enabled once more modules are prepared. The code right below can then be removed.
                # $incorrectTypes | Should -BeNullOrEmpty -Because ('no user-defined type should be declared as nullable, but instead the parameter that uses the type. This makes the template and its parameters easier to understand. Found incorrect items: [{0}].' -f ($incorrectTypes -join ', '))
                if ($incorrectTypes.Count -gt 0) {
                    $warningMessage = ('No user-defined type should be declared as nullable, but instead the parameter that uses the type. This makes the template and its parameters easier to understand. Found incorrect items: [{0}].' -f ($incorrectTypes -join ', '))
                    Write-Warning $warningMessage

                    Write-Output @{
                        Warning = $warningMessage
                    }
                }
            }

            It '[<moduleFolderName>] A UDT should always be camel-cased and end with the suffix "Type". AVM-Spec-Ref: BCPNFR19.' -TestCases $moduleFolderTestCases -Tag 'UDT' {

                param(
                    [hashtable] $templateFileContent
                )

                if (-not $templateFileContent.definitions) {
                    Set-ItResult -Skipped -Because 'the module template has no user-defined types.'
                    return
                }

                $incorrectTypes = [System.Collections.ArrayList]@()
                foreach ($typeName in $templateFileContent.definitions.Keys) {
                    if ($typeName -cnotmatch '^(.+\.)?[a-z].*Type$') {
                        # Passes
                        # - testType
                        # - _1.testType
                        # NOT passes
                        # - test
                        # - _1.TestType
                        $incorrectTypes += $typeName
                    }
                }

                # To be re-enabled once more modules are prepared. The code right below can then be removed.
                # $incorrectTypes | Should -BeNullOrEmpty -Because ('every used-defined type should be camel-cased and end with the suffix "Type". Found incorrect items: [{0}].' -f ($incorrectTypes -join ', '))
                if ($incorrectTypes.Count -gt 0) {
                    $warningMessage = ('Every used-defined type should be camel-cased and end with the suffix "Type". Found incorrect items: [{0}].' -f ($incorrectTypes -join ', '))
                    Write-Warning $warningMessage

                    Write-Output @{
                        Warning = $warningMessage
                    }
                }
            }
        }
    }
}

Describe 'Governance tests' {

    BeforeDiscovery {
        $governanceTestCases = [System.Collections.ArrayList] @()
        foreach ($moduleFolderPath in $moduleFolderPaths) {

            $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]') # 'avm/res|ptn|utl/<provider>/<resourceType>' would return 'avm', 'res|ptn|utl', '<provider>/<resourceType>'
            $resourceTypeIdentifier = $resourceTypeIdentifier -replace '\\', '/'
            $relativeModulePath = Join-Path 'avm' ($moduleFolderPath -split '[\/|\\]avm[\/|\\]')[1]

            $isTopLevelModule = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
            if ($isTopLevelModule) {

                $governanceTestCases += @{
                    relativeModulePath = $relativeModulePath
                    repoRootPath       = $repoRootPath
                    moduleFolderName   = $resourceTypeIdentifier
                    moduleType         = $moduleType
                }
            }
        }
    }

    It '[<moduleFolderName>] Owning team should be specified correctly in CODEWONERS file.' -TestCases $governanceTestCases {

        param(
            [string] $relativeModulePath,
            [string] $repoRootPath
        )

        $codeownersFilePath = Join-Path $repoRootPath '.github' 'CODEOWNERS'
        $codeOwnersContent = Get-Content $codeownersFilePath

        $formattedEntry = $relativeModulePath -replace '\\', '\/'
        $moduleLine = $codeOwnersContent | Where-Object { $_ -match "^\s*\/$formattedEntry\/" }

        $expectedEntry = '/{0}/ @Azure/{1}-module-owners-bicep @Azure/avm-module-reviewers-bicep' -f ($relativeModulePath -replace '\\', '/'), ($relativeModulePath -replace '-' -replace '[\\|\/]', '-')

        # Line should exist
        $moduleLine | Should -Not -BeNullOrEmpty -Because "the module should be listed in the [CODEOWNERS](https://azure.github.io/Azure-Verified-Modules/spec/snfr20/#codeowners-file) file as [/$expectedEntry]. Please ensure there is a forward slash (/) at the beginning and end of the module path at the start of the line."

        # Line should be correct
        $moduleLine | Should -Be $expectedEntry -Because 'the module should match the expected format as documented [here](https://azure.github.io/Azure-Verified-Modules/spec/snfr20/#codeowners-file).'
    }

    It '[<moduleFolderName>] Module identifier should be listed in issue template in the correct alphabetical position.' -TestCases $governanceTestCases {

        param(
            [string] $relativeModulePath,
            [string] $repoRootPath
        )

        $issueTemplatePath = Join-Path $repoRootPath '.github' 'ISSUE_TEMPLATE' 'avm_module_issue.yml'
        $issueTemplateContent = Get-Content $issueTemplatePath

        # Identify listed modules
        $startIndex = 0
        while ($issueTemplateContent[$startIndex] -notmatch '^\s*#?\s*\-\s+\"avm\/.+\"' -and $startIndex -ne $issueTemplateContent.Length) {
            $startIndex++
        }

        $endIndex = $startIndex
        while ($issueTemplateContent[$endIndex] -match '.*- "avm\/.*' -and $endIndex -ne $issueTemplateContent.Length) {
            $endIndex++
        }
        $endIndex-- # Go one back to last module line

        $listedModules = $issueTemplateContent[$startIndex..$endIndex] | ForEach-Object { $_ -replace '.*- "(avm\/.*)".*', '$1' }

        # Should exist
        $listedModules | Should -Contain ($relativeModulePath -replace '\\', '/') -Because 'the module should be listed in the issue template in the correct alphabetical position ([ref](https://azure.github.io/Azure-Verified-Modules/spec/BCPNFR15)).'

        # Should not be commented
        $entry = $issueTemplateContent | Where-Object { $_ -match ('.*- "{0}".*' -f $relativeModulePath -replace '\\', '\/') }
        $entry.Trim() | Should -Not -Match '^\s*#.*' -Because 'the module should not be commented out in the issue template.'

        # Should be at correct location
        $incorrectLines = @()
        foreach ($finding in (Compare-Object $listedModules ($listedModules | Sort-Object -Culture 'en-US') -SyncWindow 0)) {
            if ($finding.SideIndicator -eq '<=') {
                $incorrectLines += $finding.InputObject
            }
        }
        $incorrectLines = $incorrectLines | Sort-Object -Culture 'en-US' -Unique

        $incorrectLines.Count | Should -Be 0 -Because ('the number of modules that are not in the correct alphabetical order in the issue template should be zero ([ref](https://azure.github.io/Azure-Verified-Modules/spec/BCPNFR15)).</br>However, the following incorrectly located lines were found:</br><pre>{0}</pre>' -f ($incorrectLines -join '</br>'))
    }
}

Describe 'Test file tests' -Tag 'TestTemplate' {

    Context 'General test file' {

        BeforeDiscovery {
            $deploymentTestFileTestCases = @()

            foreach ($moduleFolderPath in $moduleFolderPaths) {
                if (Test-Path (Join-Path $moduleFolderPath 'tests')) {
                    $testFilePaths = (Get-ChildItem -Path $moduleFolderPath -Recurse -Filter 'main.test.bicep').FullName | Sort-Object -Culture 'en-US'
                    foreach ($testFilePath in $testFilePaths) {
                        $testFileContent = Get-Content $testFilePath
                        $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]') # 'avm/res|ptn|utl/<provider>/<resourceType>' would return 'avm', 'res|ptn|utl', '<provider>/<resourceType>'
                        $resourceTypeIdentifier = $resourceTypeIdentifier -replace '\\', '/'

                        $deploymentTestFileTestCases += @{
                            testName                = Split-Path (Split-Path $testFilePath) -Leaf
                            testFilePath            = $testFilePath
                            testFileContent         = $testFileContent
                            compiledTestFileContent = $builtTestFileMap[$testFilePath]
                            moduleFolderName        = $resourceTypeIdentifier
                            moduleType              = $moduleType
                        }
                    }
                }
            }
        }

        It '[<moduleFolderName>] Bicep test deployment files should contain a parameter [serviceShort] for test case [<testName>]' -TestCases $deploymentTestFileTestCases {

            param(
                [object[]] $testFileContent,
                [hashtable] $compiledTestFileContent
            )

            if ($compiledTestFileContent.resources.count -eq 0) {
                Set-ItResult -Skipped -Because 'with no deployments in the test file, the test is not required.'
                return
            }

            ($testFileContent -match "^param serviceShort string = '(.*)$") | Should -Not -BeNullOrEmpty -Because 'the module test deployment file should contain a parameter [serviceShort] using the syntax [param serviceShort string = ''*''].'
        }

        It '[<moduleFolderName>] [<testName>] Bicep test deployment files in a [defaults] folder should have a parameter [serviceShort] with a value ending with [min]' -TestCases ($deploymentTestFileTestCases | Where-Object { $_.testFilePath -match '.*[\\|\/](.+\.)?defaults[\\|\/].*' }) {

            param(
                [object[]] $testFileContent
            )

            if (($testFileContent | Out-String) -match "param serviceShort string = '(.*)'") {
                $Matches[1] | Should -BeLike '*min'
            } else {
                Set-ItResult -Skipped -Because 'the module test deployment file should contain a parameter [serviceShort] using the syntax [param serviceShort string = ''*min''] but it doesn''t.'
            }
        }

        It '[<moduleFolderName>] [<testName>] Bicep test deployment files in a [max] folder should have a [serviceShort] parameter with a value ending with  [max]' -TestCases ($deploymentTestFileTestCases | Where-Object { $_.testFilePath -match '.*[\\|\/](.+\.)?max[\\|\/].*' }) {

            param(
                [object[]] $testFileContent
            )

            if (($testFileContent | Out-String) -match "param serviceShort string = '(.*)'") {
                $Matches[1] | Should -BeLike '*max'
            } else {
                Set-ItResult -Skipped -Because 'the module test deployment file should contain a parameter [serviceShort] using the syntax [param serviceShort string = ''*max''] but it doesn''t.'
            }
        }

        It '[<moduleFolderName>] [<testName>] Bicep test deployment files in a [waf-aligned] folder should have a [serviceShort] parameter with a value ending with [waf]' -TestCases ($deploymentTestFileTestCases | Where-Object { $_.testFilePath -match '.*[\\|\/](.+\.)?waf\-aligned[\\|\/].*' }) {

            param(
                [object[]] $testFileContent
            )

            if (($testFileContent | Out-String) -match "param serviceShort string = '(.*)'") {
                $Matches[1] | Should -BeLike '*waf'
            } else {
                Set-ItResult -Skipped -Because 'the module test deployment file should contain a parameter [serviceShort] using the syntax [param serviceShort string = ''*waf''] but it doesn''t.'
            }
        }

        It '[<moduleFolderName>] Bicep test deployment files should contain a metadata string [name] for test case [<testName>]' -TestCases $deploymentTestFileTestCases {

            param(
                [object[]] $testFileContent
            )
            ($testFileContent | Out-String) | Should -Match 'metadata name = .+' -Because 'Test cases should contain a metadata string [name] in the format `metadata name = ''One cake of a name''` to be more descriptive. If provided, the tooling will automatically inject it into the module''s readme.md file.'
        }

        It '[<moduleFolderName>] Bicep test deployment files should contain a metadata string [description] for test case [<testName>]' -TestCases $deploymentTestFileTestCases {

            param(
                [object[]] $testFileContent
            )
            ($testFileContent | Out-String) | Should -Match 'metadata description = .+' -Because 'Test cases should contain a metadata string [description] in the format `metadata description = ''The cake is a lie''` to be more descriptive. If provided, the tooling will automatically inject it into the module''s readme.md file.'
        }

        It "[<moduleFolderName>] Bicep test deployment files should contain a parameter [namePrefix] with value ['#_namePrefix_#'] for test case [<testName>]" -TestCases $deploymentTestFileTestCases {

            param(
                [object[]] $testFileContent,
                [hashtable] $compiledTestFileContent
            )

            if ($compiledTestFileContent.resources.count -eq 0) {
                Set-ItResult -Skipped -Because 'without deployments in the test file, the test is not required.'
                return
            }

            ($testFileContent | Out-String) | Should -Match "param namePrefix string = '#_namePrefix_#'" -Because 'The test CI needs this value to ensure that deployed resources have unique names per fork.'
        }

        It "[<moduleFolderName>] Bicep test deployment files should invoke test like [`module testDeployment '../.*main.bicep' = [ or {`] for test case [<testName>]" -TestCases $deploymentTestFileTestCases {

            param(
                [object[]] $testFileContent,
                [hashtable] $compiledTestFileContent
            )

            if ($compiledTestFileContent.resources.count -eq 0) {
                Set-ItResult -Skipped -Because 'without deployments in the test file, the test is not required.'
                return
            }

            $testIndex = ($testFileContent | Select-String ("^module testDeployment '..\/.*main.bicep' = .*[\[|\{]$") | ForEach-Object { $_.LineNumber - 1 })[0]

            $testIndex -ne -1 | Should -Be $true -Because 'the module test invocation should be in the expected format to allow identification.'
        }

        It '[<moduleFolderName>] Bicep test deployment name should contain [`-test-`] for test case [<testName>]' -TestCases $deploymentTestFileTestCases {

            param(
                [object[]] $testFileContent,
                [hashtable] $compiledTestFileContent
            )

            if ($compiledTestFileContent.resources.count -eq 0) {
                Set-ItResult -Skipped -Because 'without deployments in the test file, the test is not required.'
                return
            }

            $expectedNameFormat = ($testFileContent | Out-String) -match '\s*name:.+-test-.+\s*'

            $expectedNameFormat | Should -Be $true -Because 'the handle ''-test-'' should be part of the module test invocation''s resource name to allow identification.'
        }
    }
}

Describe 'API version tests' -Tag 'ApiCheck' {

    BeforeDiscovery {
        $testCases = @()
        $apiSpecsFileUri = 'https://azure.github.io/Azure-Verified-Modules/governance/apiSpecsList.json'

        try {
            $apiSpecs = Invoke-WebRequest -Uri $ApiSpecsFileUri
            $ApiVersions = ConvertFrom-Json $apiSpecs.Content -AsHashtable
        } catch {
            Write-Warning "Failed to download API specs file from [$ApiSpecsFileUri]. Skipping API tests"
            Set-ItResult -Skipped -Because "Failed to download API specs file from [$ApiSpecsFileUri]. Skipping API tests."
            return
        }

        foreach ($moduleFolderPath in $moduleFolderPaths) {

            $moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1]
            $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
            $templateFileContent = $builtTestFileMap[$templateFilePath]

            $nestedResources = Get-NestedResourceList -TemplateFileContent $templateFileContent | Where-Object {
                $_.type -notin @('Microsoft.Resources/deployments') -and $_
            } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object -Culture 'en-US' -Property 'Type'

            foreach ($resource in $nestedResources) {

                switch ($resource.type) {
                    { $PSItem -like '*diagnosticsettings*' } {
                        $testCases += @{
                            moduleName                     = $moduleFolderName
                            resourceType                   = 'diagnosticSettings'
                            ProviderNamespace              = 'Microsoft.Insights'
                            TargetApi                      = $resource.ApiVersion
                            AvailableApiVersions           = $ApiVersions
                            AllowPreviewVersionsInAPITests = $AllowPreviewVersionsInAPITests
                        }
                        break
                    }
                    { $PSItem -like '*locks' } {
                        $testCases += @{
                            moduleName                     = $moduleFolderName
                            resourceType                   = 'locks'
                            ProviderNamespace              = 'Microsoft.Authorization'
                            TargetApi                      = $resource.ApiVersion
                            AvailableApiVersions           = $ApiVersions
                            AllowPreviewVersionsInAPITests = $AllowPreviewVersionsInAPITests
                        }
                        break
                    }
                    { $PSItem -like '*roleAssignments' } {
                        $testCases += @{
                            moduleName                     = $moduleFolderName
                            resourceType                   = 'roleAssignments'
                            ProviderNamespace              = 'Microsoft.Authorization'
                            TargetApi                      = $resource.ApiVersion
                            AvailableApiVersions           = $ApiVersions
                            AllowPreviewVersionsInAPITests = $AllowPreviewVersionsInAPITests
                        }
                        break
                    }
                    { $PSItem -like '*privateEndpoints' -and ($PSItem -notlike '*managedPrivateEndpoints') } {
                        $testCases += @{
                            moduleName                     = $moduleFolderName
                            resourceType                   = 'privateEndpoints'
                            ProviderNamespace              = 'Microsoft.Network'
                            TargetApi                      = $resource.ApiVersion
                            AvailableApiVersions           = $ApiVersions
                            AllowPreviewVersionsInAPITests = $AllowPreviewVersionsInAPITests
                        }
                        break
                    }
                    Default {
                        $ProviderNamespace, $rest = $resource.Type.Split('/')
                        $testCases += @{
                            moduleName                     = $moduleFolderName
                            resourceType                   = $rest -join '/'
                            ProviderNamespace              = $ProviderNamespace
                            TargetApi                      = $resource.ApiVersion
                            AvailableApiVersions           = $ApiVersions
                            AllowPreviewVersionsInAPITests = $AllowPreviewVersionsInAPITests
                        }
                        break
                    }
                }
            }
        }
    }

    It 'In [<moduleName>] used resource type [<ResourceType>] should use one of the recent API version(s). Currently using [<TargetApi>].' -TestCases $TestCases {

        param(
            [string] $ResourceType,
            [string] $TargetApi,
            [string] $ProviderNamespace,
            [hashtable] $AvailableApiVersions,
            [bool] $AllowPreviewVersionsInAPITests
        )

        if ($AvailableApiVersions.Keys -notcontains $ProviderNamespace) {
            Write-Warning "[API Test] The Provider Namespace [$ProviderNamespace] is missing in your Azure API versions file. Please consider updating it and if it is still missing to open an issue in the 'AzureAPICrawler' PowerShell module's GitHub repository."
            Set-ItResult -Skipped -Because "The Azure API version file is missing the Provider Namespace [$ProviderNamespace]."
            return
        }
        if ($AvailableApiVersions.$ProviderNamespace.Keys -notcontains $ResourceType) {
            Write-Warning "[API Test] The Provider Namespace [$ProviderNamespace] is missing the Resource Type [$ResourceType] in your API versions file. Please consider updating it and if it is still missing to open an issue in the 'AzureAPICrawler' PowerShell module's GitHub repository."
            Set-ItResult -Skipped -Because "The Azure API version file is missing the Resource Type [$ResourceType] for Provider Namespace [$ProviderNamespace]."
            return
        }

        $resourceTypeApiVersions = $AvailableApiVersions.$ProviderNamespace.$ResourceType

        if (-not $resourceTypeApiVersions) {
            Write-Warning ('[API Test] We are currently unable to determine the available API versions for resource type [{0}/{1}].' -f $ProviderNamespace, $resourceType)
            continue
        }

        $approvedApiVersions = @()
        if ($AllowPreviewVersionsInAPITests) {
            # We allow the latest 5 including previews (in case somebody wants to use preview), or the latest 3 non-preview
            $approvedApiVersions += $resourceTypeApiVersions | Select-Object -Last 5
            $approvedApiVersions += $resourceTypeApiVersions | Where-Object { $_ -notlike '*-preview' } | Select-Object -Last 5
        } else {
            # We allow the latest 5 non-preview preview
            $approvedApiVersions += $resourceTypeApiVersions | Where-Object { $_ -notlike '*-preview' } | Select-Object -Last 5
        }

        $approvedApiVersions = $approvedApiVersions | Sort-Object -Culture 'en-US' -Unique -Descending

        if ($approvedApiVersions -notcontains $TargetApi) {
            # Using a warning now instead of an error, as we don't want to block PRs for this.
            $warningMessage = "The used API version [$TargetApi] is not one of the most recent 5 versions. Please consider upgrading to one of the following: {0}" -f ($approvedApiVersions -join ', ')
            Write-Warning $warningMessage

            Write-Output @{
                Warning = $warningMessage
            }
            # The original failed test was
            # $approvedApiVersions | Should -Contain $TargetApi
        } else {
            # Provide a warning if an API version is second to next to expire.
            $indexOfVersion = $approvedApiVersions.IndexOf($TargetApi)

            # Example
            # Available versions:
            #
            # 2017-08-01-beta
            # 2017-08-01        < $TargetApi (Index = 1)
            # 2017-07-14
            # 2016-05-16

            if ($indexOfVersion -gt ($approvedApiVersions.Count - 2)) {
                $newerAPIVersions = $approvedApiVersions[0..($indexOfVersion - 1)]

                $warningMessage = "The used API version [$TargetApi] for Resource Type [$ProviderNamespace/$ResourceType] will soon expire. Please consider updating it. Consider using one of the newer API versions [{0}]" -f ($newerAPIVersions -join ', ')
                Write-Warning $warningMessage

                Write-Output @{
                    Warning = $warningMessage
                }
            }
        }
    }
}
