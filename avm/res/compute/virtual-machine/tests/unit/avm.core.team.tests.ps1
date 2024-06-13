<#
.SYNOPSIS
This file contains Pester tests that the AVM Core Team has written for the module. Any additions or changes to these tests will need to be reviewed by the AVM Core Team, this is handled by CODEOWNERS.

If you wish to add your own Pester tests for you module create a new <something>.tests.ps1 file in the /tests/unit folder of your module.
#>

param (
  [Parameter(Mandatory = $false)]
  [array] $moduleFolderPaths,

  [Parameter(Mandatory = $false)]
  [string] $repoRootPath
)

BeforeAll {
  . (Join-Path $RepoRootPath 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-IsParameterRequired.ps1')

  if ($moduleFolderPaths.Count -gt 1) {
    $topLevelModuleTemplatePath = $moduleFolderPaths | Sort-Object -Culture 'en-US' | Select-Object -First 1
  } else {
    $topLevelModuleTemplatePath = $moduleFolderPaths
  }

  $moduleJsonContentHashtable = Get-Content -Path (Join-Path $topLevelModuleTemplatePath 'main.json') | ConvertFrom-Json -AsHashtable
}

Describe 'AVM Core Team Module Specific Tests' {
  Context 'WAF - Reliability Pillar - Parameter Tests' {
    It 'VM Module Availability Zone Parameter Should Not Have A Default Value Set' {
      $isRequired = Get-IsParameterRequired -TemplateFileContent $moduleJsonContentHashtable -Parameter $moduleJsonContentHashtable.parameters.zone
      $isRequired | Should -Be $true
    }
  }
}
