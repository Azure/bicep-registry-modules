#Requires -Version 7

param (
  [Parameter(Mandatory = $false)]
  [array] $moduleFolderPaths = ((Get-ChildItem $repoRootPath -Recurse -Directory -Force).FullName | Where-Object {
            (Get-ChildItem $_ -File -Depth 0 -Include @('main.bicep') -Force).Count -gt 0
    }),

  [Parameter(Mandatory = $false)]
  [string] $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.FullName,

  [Parameter(Mandatory = $false)]
  [bool] $AllowPreviewVersionsInAPITests = $true
)

Write-Verbose ("repoRootPath: $repoRootPath") -Verbose
Write-Verbose ("moduleFolderPaths: $($moduleFolderPaths.count)") -Verbose

$script:RgDeploymentSchema = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
$script:SubscriptionDeploymentSchema = 'https://schema.management.azure.com/schemas/2018-05-01/SubscriptionDeploymentSchemaTemplate.json#'
$script:MgDeploymentSchema = 'https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#'
$script:TenantDeploymentSchema = 'https://schema.management.azure.com/schemas/2019-08-01/TenantDeploymentSchemaTemplate.json#'
$script:moduleFolderPaths = $moduleFolderPaths

# For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
$script:convertedTemplates = @{}

# Shared exception messages
$script:bicepTemplateCompilationFailedException = "Unable to compile the main.bicep template's content. This can happen if there is an error in the template. Please check if you can run the command ``bicep build {0} --stdout | ConvertFrom-Json -AsHashtable``." # -f $templateFilePath
$script:templateNotFoundException = 'No template file found in folder [{0}]' # -f $moduleFolderPath

# Import any helper function used in this test script
Import-Module (Join-Path $PSScriptRoot 'helper' 'helper.psm1') -Force

Describe 'File/folder tests' -Tag 'Modules' {

  Context 'General module folder tests' {

    $moduleFolderTestCases = [System.Collections.ArrayList] @()
    foreach ($moduleFolderPath in $moduleFolderPaths) {
      $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>
      $moduleFolderTestCases += @{
        moduleFolderName = $resourceTypeIdentifier
        moduleFolderPath = $moduleFolderPath
        isTopLevelModule = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
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
  }

  Context 'Top level module folder tests' {

    $topLevelModuleTestCases = [System.Collections.ArrayList]@()
    foreach ($moduleFolderPath in $moduleFolderPaths) {
      $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>
      if (($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2) {
        $topLevelModuleTestCases += @{
          moduleFolderName = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1]
          moduleFolderPath = $moduleFolderPath
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

    It '[<moduleFolderName>] Module should contain a [` tests/e2e/*waf-aligned `] folder.' -TestCases $topLevelModuleTestCases {

      param(
        [string] $moduleFolderPath
      )

      $wafAlignedFolder = Get-ChildItem -Directory (Join-Path -Path $moduleFolderPath 'tests' 'e2e') -Filter '*waf-aligned'
      $wafAlignedFolder | Should -Not -BeNullOrEmpty
    }

    It '[<moduleFolderName>] Module should contain a [` tests/e2e/*defaults `] folder.' -TestCases $topLevelModuleTestCases {

      param(
        [string] $moduleFolderPath
      )

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
        $pathExisting = Test-Path (Join-Path -Path $e2eTestFolderPath 'main.test.bicep')
        $pathExisting | Should -Be $true
      }
    }
  }
}

Describe 'Pipeline tests' -Tag 'Pipeline' {

  $moduleFolderTestCases = [System.Collections.ArrayList] @()
  foreach ($moduleFolderPath in $moduleFolderPaths) {

    $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>
    $relativeModulePath = Join-Path 'avm' ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}')[1]

    $moduleFolderTestCases += @{
      moduleFolderName   = $resourceTypeIdentifier
      relativeModulePath = $relativeModulePath
      isTopLevelModule   = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
    }
  }

  It '[<moduleFolderName>] Module should have a GitHub workflow.' -TestCases ($moduleFolderTestCases | Where-Object { $_.isTopLevelModule }) {

    param(
      [string] $relativeModulePath
    )

    $workflowsFolderName = Join-Path $repoRootPath '.github' 'workflows'
    $workflowFileName = Get-PipelineFileName -ResourceIdentifier $relativeModulePath
    $workflowPath = Join-Path $workflowsFolderName $workflowFileName
    Test-Path $workflowPath | Should -Be $true -Because "path [$workflowPath] should exist."
  }
}

Describe 'Module tests' -Tag 'Module' {

  Context 'Readme content tests' -Tag 'Readme' {

    $readmeFileTestCases = [System.Collections.ArrayList] @()

    foreach ($moduleFolderPath in $moduleFolderPaths) {

      # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
      $moduleFolderPathKey = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1].Trim('/').Replace('/', '-')
      if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
        if (Test-Path (Join-Path $moduleFolderPath 'main.bicep')) {
          $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
          $templateContent = bicep build $templateFilePath --stdout | ConvertFrom-Json -AsHashtable

          if (-not $templateContent) {
            throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
          }
        } else {
          throw ($templateNotFoundException -f $moduleFolderPath)
        }
        $convertedTemplates[$moduleFolderPathKey] = @{
          templateFilePath = $templateFilePath
          templateContent  = $templateContent
        }
      } else {
        $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
        $templateFilePath = $convertedTemplates[$moduleFolderPathKey].templateFilePath
      }

      $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>

      $readmeFileTestCases += @{
        moduleFolderName = $resourceTypeIdentifier
        templateContent  = $templateContent
        templateFilePath = $templateFilePath
        readMeFilePath   = Join-Path -Path $moduleFolderPath 'README.md'
      }
    }

    It '[<moduleFolderName>] `Set-ModuleReadMe` script should not apply any updates.' -TestCases $readmeFileTestCases {

      param(
        [string] $moduleFolderName,
        [string] $templateFilePath,
        [hashtable] $templateContent,
        [string] $readMeFilePath
      )

      # Get current hash
      $fileHashBefore = (Get-FileHash $readMeFilePath).Hash

      # Load function
      . (Join-Path $repoRootPath 'avm' 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')

      # Apply update with already compiled template content
      Set-ModuleReadMe -TemplateFilePath $templateFilePath -TemplateFileContent $templateContent

      # Get hash after 'update'
      $fileHashAfter = (Get-FileHash $readMeFilePath).Hash

      # Compare
      $filesAreTheSame = $fileHashBefore -eq $fileHashAfter
      if (-not $filesAreTheSame) {
        $diffReponse = git diff $readMeFilePath
        Write-Warning ($diffReponse | Out-String) -Verbose

        # Reset readme file to original state
        git checkout HEAD -- $readMeFilePath
      }

      $mdFormattedDiff = ($diffReponse -join '</br>') -replace '\|', '\|'
      $filesAreTheSame | Should -Be $true -Because ('The file hashes before and after applying the `Set-ModuleReadMe` function should be identical and should not have diff </br><pre>{0}</pre>. Please re-run the script for this module''s template.' -f $mdFormattedDiff)
    }
  }

  Context 'Compiled ARM template tests' -Tag 'ARM' {

    $armTemplateTestCases = [System.Collections.ArrayList] @()

    foreach ($moduleFolderPath in $moduleFolderPaths) {

      # Skipping folders without a [main.bicep] template
      $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
      if (-not (Test-Path $templateFilePath)) {
        continue
      }

      $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>

      $armTemplateTestCases += @{
        moduleFolderName = $resourceTypeIdentifier
        moduleFolderPath = $moduleFolderPath
        templateFilePath = $templateFilePath
      }
    }

    It '[<moduleFolderName>] Compiled ARM template should be latest.' -TestCases $armTemplateTestCases {

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

  Context 'General template tests' -Tag 'Template' {

    $deploymentFolderTestCases = [System.Collections.ArrayList] @()
    foreach ($moduleFolderPath in $moduleFolderPaths) {

      # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
      $moduleFolderPathKey = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1].Trim('/').Replace('/', '-')
      if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
        if (Test-Path (Join-Path $moduleFolderPath 'main.bicep')) {
          $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
          $templateContent = bicep build $templateFilePath --stdout | ConvertFrom-Json -AsHashtable

          if (-not $templateContent) {
            throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
          }
        } else {
          throw ($templateNotFoundException -f $moduleFolderPath)
        }
        $convertedTemplates[$moduleFolderPathKey] = @{
          templateFilePath = $templateFilePath
          templateContent  = $templateContent
        }
      } else {
        $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
        $templateFilePath = $convertedTemplates[$moduleFolderPathKey].templateFilePath
      }

      # Parameter file test cases
      $testFileTestCases = @()
      $templateFile_Parameters = $templateContent.parameters
      $TemplateFile_AllParameterNames = $templateFile_Parameters.Keys | Sort-Object
      $TemplateFile_RequiredParametersNames = ($templateFile_Parameters.Keys | Where-Object { Get-IsParameterRequired -TemplateFileContent $templateContent -Parameter $templateFile_Parameters[$_] }) | Sort-Object

      if (Test-Path (Join-Path $moduleFolderPath 'tests')) {

        # Can be removed after full migration to bicep test files
        $moduleTestFilePaths = Get-ModuleTestFileList -ModulePath $moduleFolderPath | ForEach-Object { Join-Path $moduleFolderPath $_ }

        foreach ($moduleTestFilePath in $moduleTestFilePaths) {
          $deploymentFileContent = bicep build $moduleTestFilePath --stdout | ConvertFrom-Json -AsHashtable
          $deploymentTestFile_AllParameterNames = $deploymentFileContent.resources[-1].properties.parameters.Keys | Sort-Object # The last resource should be the test

          $testFileTestCases += @{
            testFile_Path                        = $moduleTestFilePath
            testFile_Name                        = Split-Path $moduleTestFilePath -Leaf
            testFile_AllParameterNames           = $deploymentTestFile_AllParameterNames
            templateFile_AllParameterNames       = $TemplateFile_AllParameterNames
            templateFile_RequiredParametersNames = $TemplateFile_RequiredParametersNames
          }
        }
      }

      $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>

      # Test file setup
      $deploymentFolderTestCases += @{
        moduleFolderName  = $resourceTypeIdentifier
        templateContent   = $templateContent
        templateFilePath  = $templateFilePath
        testFileTestCases = $testFileTestCases
        readMeFilePath    = Join-Path (Split-Path $templateFilePath) 'README.md'
        isTopLevelModule  = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
      }
    }

    It '[<moduleFolderName>] The template file should not be empty.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )
      $templateContent | Should -Not -BeNullOrEmpty
    }

    It '[<moduleFolderName>] Template schema version should be the latest.' -TestCases $deploymentFolderTestCases {
      # the actual value changes depending on the scope of the template (RG, subscription, MG, tenant) !!
      # https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax
      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      $Schemaverion = $templateContent.'$schema'
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

    It '[<moduleFolderName>] Template schema should use HTTPS reference.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )
      $Schemaverion = $templateContent.'$schema'
            ($Schemaverion.Substring(0, 5) -eq 'https') | Should -Be $true
    }

    It '[<moduleFolderName>] The template file should contain required elements [schema], [contentVersion], [resources].' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )
      $templateContent.Keys | Should -Contain '$schema'
      $templateContent.Keys | Should -Contain 'contentVersion'
      $templateContent.Keys | Should -Contain 'resources'
    }

    # TODO : Add for other extension resources too?
    It '[<moduleFolderName>] If delete lock is implemented, the template should have a lock parameter that''s a user defined type with an empty default value.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      if ($lock = $templateContent.parameters.lock) {

        $lock.Keys | Should -Contain '$ref' # Should be a user defined type

        $type = $templateContent.definitions[(Split-Path ($lock.'$ref') -Leaf)]

        $type.nullable | Should -Be $true
      }
    }

    It '[<moduleFolderName>] Parameter names should be camel-cased (no dashes or underscores and must start with lower-case letter).' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      if (-not $templateContent.parameters) {
        Set-ItResult -Skipped -Because 'the module template has no parameters.'
        return
      }

      $CamelCasingFlag = @()
      $Parameter = $templateContent.parameters.Keys
      foreach ($Param in $Parameter) {
        if ($Param.substring(0, 1) -cnotmatch '[a-z]' -or $Param -match '-' -or $Param -match '_') {
          $CamelCasingFlag += $false
        } else {
          $CamelCasingFlag += $true
        }
      }
      $CamelCasingFlag | Should -Not -Contain $false
    }

    It '[<moduleFolderName>] Variable names should be camel-cased (no dashes or underscores and must start with lower-case letter).' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      if (-not $templateContent.variables) {
        Set-ItResult -Skipped -Because 'the module template has no variables.'
        return
      }

      $CamelCasingFlag = @()
      $Variable = $templateContent.variables.Keys

      foreach ($Variab in $Variable) {
        if ($Variab.substring(0, 1) -cnotmatch '[a-z]' -or $Variab -match '-') {
          $CamelCasingFlag += $false
        } else {
          $CamelCasingFlag += $true
        }
      }
      $CamelCasingFlag | Should -Not -Contain $false
    }

    It '[<moduleFolderName>] Output names should be camel-cased (no dashes or underscores and must start with lower-case letter).' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )
      $CamelCasingFlag = @()
      $Outputs = $templateContent.outputs.Keys

      foreach ($Output in $Outputs) {
        if ($Output.substring(0, 1) -cnotmatch '[a-z]' -or $Output -match '-' -or $Output -match '_') {
          $CamelCasingFlag += $false
        } else {
          $CamelCasingFlag += $true
        }
      }
      $CamelCasingFlag | Should -Not -Contain $false
    }

    It '[<moduleFolderName>] Telemetry deployment should be present in the template.' -TestCases ($deploymentFolderTestCases | Where-Object { $_.isTopLevelModule }) {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
      if ($templateContent.resources.GetType().Name -eq 'Object[]') {
        $templateResources = $templateContent.resources
      } else {
        $templateResources = $templateContent.resources.Keys | ForEach-Object { $templateContent.resources[$_] }
      }

      $telemetryDeployment = $templateResources | Where-Object { $_.name -like "*'46d3xbcp.*" } # The AVM telemetry prefix
      $telemetryDeployment | Should -Not -BeNullOrEmpty -Because 'The telemetry resource with name prefix [46d3xbcp] should be present in the tempalte'
    }

    It '[<moduleFolderName>] Telemetry deployment should have correct condition in the template.' -TestCases ($deploymentFolderTestCases | Where-Object { $_.isTopLevelModule }) {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
      if ($templateContent.resources.GetType().Name -eq 'Object[]') {
        $templateResources = $templateContent.resources
      } else {
        $templateResources = $templateContent.resources.Keys | ForEach-Object { $templateContent.resources[$_] }
      }

      $telemetryDeployment = $templateResources | Where-Object { $_.name -like "*'46d3xbcp.*" } # The AVM telemetry prefix

      if (-not $telemetryDeployment) {
        Set-ItResult -Skipped -Because 'Skipping this test as telemetry was not implemented in template'
        return
      }

      $telemetryDeployment.condition | Should -Be "[parameters('enableTelemetry')]"
    }

    It '[<moduleFolderName>] Telemetry deployment should have expected inner output for verbosity.' -TestCases ($deploymentFolderTestCases | Where-Object { $_.isTopLevelModule }) {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      # With the introduction of user defined types, the way resources are configured in the schema slightly changed. We have to account for that.
      if ($templateContent.resources.GetType().Name -eq 'Object[]') {
        $templateResources = $templateContent.resources
      } else {
        $templateResources = $templateContent.resources.Keys | ForEach-Object { $templateContent.resources[$_] }
      }

      $telemetryDeployment = $templateResources | Where-Object { $_.name -like "*'46d3xbcp.*" } # The AVM telemetry prefix

      if (-not $telemetryDeployment) {
        Set-ItResult -Skipped -Because 'Skipping this test as telemetry was not implemented in template'
        return
      }

      $telemetryDeployment.properties.template.outputs.Keys | Should -Contain 'telemetry'
      $telemetryDeployment.properties.template.outputs['telemetry'].value | Should -Be 'For more information, see https://aka.ms/avm/TelemetryInfo'
    }

    It '[<moduleFolderName>] The Location should be defined as a parameter, with the default value of [resourceGroup().Location] or global for ResourceGroup deployment scope.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )
      $LocationFlag = $true
      $Schemaverion = $templateContent.'$schema'
      if ((($Schemaverion.Split('/')[5]).Split('.')[0]) -eq (($RgDeploymentSchema.Split('/')[5]).Split('.')[0])) {
        $Locationparamoutputvalue = $templateContent.parameters.location.defaultValue
        $Locationparamoutput = $templateContent.parameters.Keys
        if ($Locationparamoutput -contains 'Location') {
          if ($Locationparamoutputvalue -eq '[resourceGroup().Location]' -or $Locationparamoutputvalue -eq 'global') {
            $LocationFlag = $true
          } else {

            $LocationFlag = $false
          }
          $LocationFlag | Should -Contain $true
        }
      }
    }

    # ? remove ? or update specs
    It '[<moduleFolderName>] Location output should be returned for resources that use it.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent,
        [string] $templateFilePath
      )

      $outputs = $templateContent.outputs

      $primaryResourceType = (Split-Path $TemplateFilePath -Parent).Replace('\', '/').split('/avm/')[1]
      $primaryResourceTypeResource = $templateContent.resources | Where-Object { $_.type -eq $primaryResourceType }

      if ($primaryResourceTypeResource.keys -contains 'location' -and $primaryResourceTypeResource.location -ne 'global') {
        # If the main resource has a location property, an output should be returned too
        $outputs.keys | Should -Contain 'location'

        # It should further reference the location property of the primary resource and not e.g. the location input parameter
        $outputs.location.value | Should -Match $primaryResourceType
      }
    }

    # ? remove ? or update specs
    It '[<moduleFolderName>] Resource Group output should exist for resources that are deployed into a resource group scope.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent,
        [string] $templateFilePath
      )

      $outputs = $templateContent.outputs.Keys
      $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $templateFilePath

      if ($deploymentScope -eq 'resourceGroup') {
        $outputs | Should -Contain 'resourceGroupName'
      }
    }

    It '[<moduleFolderName>] Resource modules should have a name output.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent,
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
      if ($templateContent.resources.GetType().Name -eq 'Object[]') {
        $templateResources = $templateContent.resources
      } else {
        $templateResources = $templateContent.resources.Keys | ForEach-Object { $templateContent.resources[$_] }
      }

      if ($templateResources.type -notcontains $primaryResourceType) {
        Set-ItResult -Skipped -Because 'the module template has no primary resource to fetch a name from.'
        return
      }

      # Otherwise test for standard outputs
      $outputs = $templateContent.outputs.Keys
      $outputs | Should -Contain 'name'
    }

    It '[<moduleFolderName>] Resource modules should have a Resource ID output.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent,
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
      if ($templateContent.resources.GetType().Name -eq 'Object[]') {
        $templateResources = $templateContent.resources
      } else {
        $templateResources = $templateContent.resources.Keys | ForEach-Object { $templateContent.resources[$_] }
      }

      # check if module contains a 'primary' resource we could draw a resource ID from
      if ($templateResources.type -notcontains $primaryResourceType) {
        Set-ItResult -Skipped -Because 'the module template has no primary resource to fetch a resource ID from.'
        return
      }

      # Otherwise test for standard outputs
      $outputs = $templateContent.outputs.Keys
      $outputs | Should -Contain 'resourceId'
    }

    It '[<moduleFolderName>] Resource modules Principal ID output should exist, if supported.' -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent,
        [string] $templateFilePath
      )

      if ($templateContent.parameters.Keys -notcontains 'managedIdentities') {
        Set-ItResult -Skipped -Because 'the module template seems not to support an identity object.'
        return
      }

      $typeRef = Split-Path $templateContent.parameters.managedIdentities.'$ref' -Leaf
      $typeProperties = ($templateContent.definitions[$typeRef]).properties
      if ($typeProperties.Keys -notcontains 'systemAssigned') {
        Set-ItResult -Skipped -Because 'the managedIdentities input does not support system-assigned identities.'
        return
      }

      # Otherwise test for standard outputs
      $outputs = $templateContent.outputs.Keys
      $outputs | Should -Contain 'systemAssignedMIPrincipalId'
    }

    It "[<moduleFolderName>] Each parameters' description should start with a one word category starting with a capital letter, followed by a dot, a space and the actual description text ending with a dot." -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      if (-not $templateContent.parameters) {
        Set-ItResult -Skipped -Because 'the module template has no parameters.'
        return
      }

      $incorrectParameters = @()
      $templateParameters = $templateContent.parameters.Keys
      foreach ($parameter in $templateParameters) {
        $data = ($templateContent.parameters.$parameter.metadata).description
        if ($data -notmatch '(?s)^[A-Z][a-zA-Z]+\. .+\.$') {
          $incorrectParameters += $parameter
        }
      }
      $incorrectParameters | Should -BeNullOrEmpty
    }

    # TODO: Update specs with note
    It "[<moduleFolderName>] Conditional parameters' description should contain 'Required if' followed by the condition making the parameter required." -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      if (-not $templateContent.parameters) {
        Set-ItResult -Skipped -Because 'the module template has no parameters.'
        return
      }

      $incorrectParameters = @()
      $templateParameters = $templateContent.parameters.Keys
      foreach ($parameter in $templateParameters) {
        $data = ($templateContent.parameters.$parameter.metadata).description
        switch -regex ($data) {
          '^Conditional. .*' {
            if ($data -notmatch '.*\. Required if .*') {
              $incorrectParameters += $parameter
            }
          }
        }
      }
      $incorrectParameters | Should -BeNullOrEmpty
    }

    It "[<moduleFolderName>] outputs' description should start with a capital letter and contain text ending with a dot." -TestCases $deploymentFolderTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateContent
      )

      if (-not $templateContent.outputs) {
        Set-ItResult -Skipped -Because 'the module template has no outputs.'
        return
      }

      $incorrectOutputs = @()
      $templateOutputs = $templateContent.outputs.Keys
      foreach ($output in $templateOutputs) {
        $data = ($templateContent.outputs.$output.metadata).description
        if ($data -notmatch '(?s)^[A-Z].+\.$') {
          $incorrectOutputs += $output
        }
      }
      $incorrectOutputs | Should -BeNullOrEmpty
    }

    It '[<moduleFolderName>] All non-required parameters in template file should not have description that start with "Required.".' -TestCases $deploymentFolderTestCases {
      param (
        [hashtable[]] $testFileTestCases,
        [hashtable] $templateContent
      )

      foreach ($parameterFileTestCase in $testFileTestCases) {
        $templateFile_RequiredParametersNames = $parameterFileTestCase.templateFile_RequiredParametersNames
        $templateFile_AllParameterNames = $parameterFileTestCase.templateFile_AllParameterNames
        $nonRequiredParameterNames = $templateFile_AllParameterNames | Where-Object { $_ -notin $templateFile_RequiredParametersNames }

        $incorrectParameters = $nonRequiredParameterNames | Where-Object { ($templateContent.parameters[$_].defaultValue) -and ($templateContent.parameters[$_].metadata.description -like 'Required. *') }
        $incorrectParameters.Count | Should -Be 0 -Because ('all non-required parameters in the template file should not have a description that starts with "Required.". Found incorrect items: [{0}].' -f ($incorrectParameters -join ', '))
      }
    }
  }

  Context 'Metadata content tests' -Tag 'Metadata' {

    ####################
    ##   Test Cases   ##
    ####################
    $metadataFileTestCases = [System.Collections.ArrayList] @()

    foreach ($moduleFolderPath in $moduleFolderPaths) {

      $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>

      # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
      $moduleFolderPathKey = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1].Trim('/').Replace('/', '-')
      if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
        if (Test-Path (Join-Path $moduleFolderPath 'main.bicep')) {
          $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
          $templateContent = bicep build $templateFilePath --stdout | ConvertFrom-Json -AsHashtable

          if (-not $templateContent) {
            throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
          }
        } else {
          throw ($templateNotFoundException -f $moduleFolderPath)
        }
        $convertedTemplates[$moduleFolderPathKey] = @{
          templateContent = $templateContent
        }
      } else {
        $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
      }

      $metadataFileTestCases += @{
        moduleFolderName    = $resourceTypeIdentifier
        templateFileContent = $templateContent
      }
    }

    ###############
    ##   Tests   ##
    ###############
    It '[<moduleFolderName>] template file should have a module name specified.' -TestCases $metadataFileTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateFileContent
      )

      $templateFileContent.metadata.name | Should -Not -BeNullOrEmpty
    }

    It '[<moduleFolderName>] template file should have a module description specified.' -TestCases $metadataFileTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateFileContent
      )

      $templateFileContent.metadata.description | Should -Not -BeNullOrEmpty
    }

    It '[<moduleFolderName>] template file should have a module owner specified.' -TestCases $metadataFileTestCases {

      param(
        [string] $moduleFolderName,
        [hashtable] $templateFileContent
      )

      $templateFileContent.metadata.owner | Should -Not -BeNullOrEmpty
    }
  }

  Context 'User-defined-types tests' -Tag 'UDT' {

    $udtTestCases = [System.Collections.ArrayList] @()
    foreach ($moduleFolderPath in $moduleFolderPaths) {

      $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>

      # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
      $moduleFolderPathKey = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1].Trim('/').Replace('/', '-')
      if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
        if (Test-Path (Join-Path $moduleFolderPath 'main.bicep')) {
          $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
          $templateContent = bicep build $templateFilePath --stdout | ConvertFrom-Json -AsHashtable

          if (-not $templateContent) {
            throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
          }
        } else {
          throw ($templateNotFoundException -f $moduleFolderPath)
        }
        $convertedTemplates[$moduleFolderPathKey] = @{
          templateContent = $templateContent
        }
      } else {
        $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
      }

      # Setting expected URL only for those that doen't have multiple different variants
      $avmInterfaceSpecsBase = 'https://raw.githubusercontent.com/Azure/Azure-Verified-Modules/main/docs/static/includes/interfaces'
      $udtCases = @(
        @{
          parameterName = 'diagnosticSettings'
          udtName       = 'diagnosticSettingType'
        }
        @{
          parameterName  = 'roleAssignments'
          udtName        = 'roleAssignmentType'
          udtExpectedUrl = "$avmInterfaceSpecsBase/int.rbac.udt.schema.bicep"
        }
        @{
          parameterName  = 'lock'
          udtName        = 'lockType'
          udtExpectedUrl = "$avmInterfaceSpecsBase/int.locks.udt.schema.bicep"
        }
        @{
          parameterName = 'managedIdentities'
          udtName       = 'managedIdentitiesType'
        }
        @{
          parameterName = 'privateEndpoints'
          udtName       = 'privateEndpointType'
        }
        @{
          parameterName = 'customerManagedKey'
          udtName       = 'customerManagedKeyType'
        }
      )

      foreach ($udtCase in $udtCases) {
        $udtTestCases += @{
          moduleFolderName         = $resourceTypeIdentifier
          templateFileContent      = $templateContent
          templateFileContentBicep = Get-Content $templateFilePath
          parameterName            = $udtCase.parameterName
          udtName                  = $udtCase.udtName
          expectedUdtUrl           = $udtCase.udtExpectedUrl ? $udtCase.udtExpectedUrl : ''
        }
      }
    }


    It "[<moduleFolderName>] If template has [<parameterName>] parameter, it should implement the expected user-defined type [<udtName>]" -TestCases $udtTestCases {

      param(
        [hashtable] $templateFileContent,
        [string[]] $templateFileContentBicep,
        [string] $parameterName,
        [string] $udtName,
        [string] $expectedUdtUrl
      )

      if ($templateFileContent.parameters.Keys -contains $parameterName) {
        $templateFileContent.parameters.$parameterName.Keys | Should -Contain '$ref' -Because "the [$parameterName] parameter should use a user-defined type."
        $templateFileContent.parameters.$parameterName.'$ref' | Should -Be "#/definitions/$udtName" -Because "the [$parameterName] parameter should use a user-defined type [$udtName]."

        if (-not [String]::IsNullOrEmpty($expectedUdtUrl)) {
          $implementedSchemaStartIndex = $templateFileContentBicep.IndexOf("type $udtName = {")
          $implementedSchemaEndIndex = $implementedSchemaStartIndex + 1
          while ($templateFileContentBicep[$implementedSchemaEndIndex] -notmatch '^\}.*' -and $implementedSchemaEndIndex -lt $templateFileContentBicep.Length) {
            $implementedSchemaEndIndex++
          }
          if ($implementedSchemaEndIndex -eq $templateFileContentBicep.Length) {
            throw "Failed to identify [$udtName] user-defined type in template."
          }
          $implementedSchema = $templateFileContentBicep[$implementedSchemaStartIndex..$implementedSchemaEndIndex]

          $expectedSchemaFull = (Invoke-WebRequest -Uri $expectedUdtUrl).Content -split "\n"
          $expectedSchemaStartIndex = $expectedSchemaFull.IndexOf("type $udtName = {")
          $expectedSchemaEndIndex = $expectedSchemaStartIndex + 1
          while ($expectedSchemaFull[$expectedSchemaEndIndex] -notmatch '^\}.*' -and $expectedSchemaEndIndex -lt $expectedSchemaFull.Length) {
            $expectedSchemaEndIndex++
          }
          if ($expectedSchemaEndIndex -eq $expectedSchemaFull.Length) {
            throw "Failed to identify [$udtName] user-defined type in expected schema at URL [$expectedUdtUrl]."
          }
          $expectedSchema = $expectedSchemaFull[$expectedSchemaStartIndex..$expectedSchemaEndIndex]

          $formattedDiff = @()
          foreach ($finding in (Compare-Object $implementedSchema $expectedSchema)) {
            if ($finding.SideIndicator -eq '=>') {
              $formattedDiff += ('+ {0}' -f $finding.InputObject)
            } elseif ($finding.SideIndicator -eq '<=') {
              $formattedDiff += ('- {0}' -f $finding.InputObject)
            }
          }
          if ($formattedDiff.Count -gt 0) {
            Write-Warning ($formattedDiff | Out-String) -Verbose
            $mdFormattedDiff = ($formattedDiff -join '</br>') -replace '\|', '\|'
          }

        ($implementedSchema | Out-String) | Should -Be ($expectedSchema | Out-String) -Because ('The implemented user-defined type should be the same as the expected user-defined type of url [{0}] and should not have diff </br><pre>{1}</pre>.' -f $expectedUdtUrl, $mdFormattedDiff)
        }
      } else {
        Set-ItResult -Skipped -Because "the module template has no [$parameterName] parameter."
      }
    }


    # TODO Add test for tags
    # TODO add tests for msi principal id output
  }
}

Describe 'Test file tests' -Tag 'TestTemplate' {

  Context 'General test file' {

    $deploymentTestFileTestCases = @()

    foreach ($moduleFolderPath in $moduleFolderPaths) {
      if (Test-Path (Join-Path $moduleFolderPath 'tests')) {
        $testFilePaths = Get-ModuleTestFileList -ModulePath $moduleFolderPath | ForEach-Object { Join-Path $moduleFolderPath $_ }
        foreach ($testFilePath in $testFilePaths) {
          $testFileContent = Get-Content $testFilePath
          $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>

          $deploymentTestFileTestCases += @{
            testFilePath     = $testFilePath
            testFileContent  = $testFileContent
            moduleFolderName = $resourceTypeIdentifier
          }
        }
      }
    }

    It "[<moduleFolderName>] Bicep test deployment files should contain serviceShort parameter" -TestCases $deploymentTestFileTestCases {

      param(
        [object[]] $testFileContent
      )
      Write-Error 'Not implemented'

    }

    It "[<moduleFolderName>] Bicep test deployment files in a [default] folder should contain a service short with ending [min]" -TestCases $deploymentTestFileTestCases {

      param(
        [string] $testFilePath,
        [object[]] $testFileContent
      )
      #TODO: must consider that the folder name is more than just 'default'
      Write-Error 'Not implemented'

    }

    It "[<moduleFolderName>] Bicep test deployment files in a [max] folder should contain a service short with ending [max]" -TestCases $deploymentTestFileTestCases {

      param(
        [string] $testFilePath,
        [object[]] $testFileContent
      )
      #TODO: must consider that the folder name is more than just 'max'
      Write-Error 'Not implemented'

    }

    It "[<moduleFolderName>] Bicep test deployment files in a [waf-aligned] folder should contain a service short with ending [waf]" -TestCases $deploymentTestFileTestCases {

      param(
        [string] $testFilePath,
        [object[]] $testFileContent
      )
      #TODO: must consider that the folder name is more than just 'waf'
      Write-Error 'Not implemented'

    }

    It "[<moduleFolderName>] Bicep test deployment files should contain a test name" -TestCases $deploymentTestFileTestCases {

      param(
        [object[]] $testFileContent
      )
      Write-Error 'Not implemented'

    }

    It "[<moduleFolderName>] Bicep test deployment files should contain a test description" -TestCases $deploymentTestFileTestCases {

      param(
        [object[]] $testFileContent
      )
      Write-Error 'Not implemented'

    }

    It "[<moduleFolderName>] Bicep test deployment files should contain namePrefix parameter with value ['#_namePrefix_#']" -TestCases $deploymentTestFileTestCases {

      param(
        [object[]] $testFileContent
      )
      Write-Error 'Not implemented'
    }

    It "[<moduleFolderName>] Bicep test deployment files should invoke test like [`module testDeployment '../.*main.bicep' = {`]" -TestCases $deploymentTestFileTestCases {

      param(
        [object[]] $testFileContent
      )

      $testIndex = ($testFileContent | Select-String ("^module testDeployment '..\/.*main.bicep' = (\[for .+: )?{$") | ForEach-Object { $_.LineNumber - 1 })[0]

      $testIndex -ne -1 | Should -Be $true -Because 'the module test invocation should be in the expected format to allow identification.'
    }

    It '[<moduleFolderName>] Bicep test deployment name should contain [`-test-`].' -TestCases $deploymentTestFileTestCases {

      param(
        [object[]] $testFileContent
      )

      $expectedNameFormat = ($testFileContent | Out-String) -match '\s*name:.+-test-.+\s*'

      $expectedNameFormat | Should -Be $true -Because 'the handle ''-test-'' should be part of the module test invocation''s resource name to allow identification.'
    }

    It '[<moduleFolderName>] Bicep test deployment should have parameter [`serviceShort`].' -TestCases $deploymentTestFileTestCases {

      param(
        [object[]] $testFileContent
      )

      $hasExpectedParam = ($testFileContent | Out-String) -match '\s*param\s+serviceShort\s+string\s*'

      $hasExpectedParam | Should -Be $true
    }
  }
}

Describe 'API version tests' -Tag 'ApiCheck' {

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

    # For runtime purposes, we cache the compiled template in a hashtable that uses a formatted relative module path as a key
    $moduleFolderPathKey = $moduleFolderPath.Replace('\', '/').Split('/avm/')[1].Trim('/').Replace('/', '-')
    if (-not ($convertedTemplates.Keys -contains $moduleFolderPathKey)) {
      if (Test-Path (Join-Path $moduleFolderPath 'main.bicep')) {
        $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
        $templateContent = bicep build $templateFilePath --stdout | ConvertFrom-Json -AsHashtable

        if (-not $templateContent) {
          throw ($bicepTemplateCompilationFailedException -f $templateFilePath)
        }
      } else {
        throw ($templateNotFoundException -f $moduleFolderPath)
      }
      $convertedTemplates[$moduleFolderPathKey] = @{
        templateFilePath = $templateFilePath
        templateContent  = $templateContent
      }
    } else {
      $templateContent = $convertedTemplates[$moduleFolderPathKey].templateContent
      $templateFilePath = $convertedTemplates[$moduleFolderPathKey].templateFilePath
    }

    $nestedResources = Get-NestedResourceList -TemplateFileContent $templateContent | Where-Object {
      $_.type -notin @('Microsoft.Resources/deployments') -and $_
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type

    foreach ($resource in $nestedResources) {

      switch ($resource.type) {
        { $PSItem -like '*diagnosticsettings*' } {
          $testCases += @{
            moduleName                     = $moduleFolderName
            resourceType                   = 'diagnosticsettings'
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
            resourceType                   = 'roleassignments'
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

  It 'In [<moduleName>] used resource type [<ResourceType>] should use one of the recent API version(s). Currently using [<TargetApi>].' -TestCases $TestCases {

    param(
      [string] $moduleName,
      [string] $ResourceType,
      [string] $TargetApi,
      [string] $ProviderNamespace,
      [PSCustomObject] $AvailableApiVersions,
      [bool] $AllowPreviewVersionsInAPITests
    )

    if (-not (($AvailableApiVersions | Get-Member -Type NoteProperty).Name -contains $ProviderNamespace)) {
      Write-Warning "[API Test] The Provider Namespace [$ProviderNamespace] is missing in your Azure API versions file. Please consider updating it and if it is still missing to open an issue in the 'AzureAPICrawler' PowerShell module's GitHub repository."
      Set-ItResult -Skipped -Because "The Azure API version file is missing the Provider Namespace [$ProviderNamespace]."
      return
    }
    if (-not (($AvailableApiVersions.$ProviderNamespace | Get-Member -Type NoteProperty).Name -contains $ResourceType)) {
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

    $approvedApiVersions = $approvedApiVersions | Sort-Object -Unique -Descending

    if ( $approvedApiVersions -notcontains $TargetApi) {
      # Using a warning now instead of an error, as we don't want to block PRs for this.
      Write-Warning ("The used API version [$TargetApi] is not one of the most recent 5 versions. Please consider upgrading to one of the following: {0}" -f $approvedApiVersions -join ', ')

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
        Write-Warning ("The used API version [$TargetApi] for Resource Type [$ProviderNamespace/$ResourceType] will soon expire. Please consider updating it. Consider using one of the newer API versions [{0}]" -f ($newerAPIVersions -join ', '))
      }
    }
  }
}
