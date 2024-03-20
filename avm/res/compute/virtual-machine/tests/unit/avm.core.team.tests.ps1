param (
  [Parameter(Mandatory)]
  [array] $ModuleFolderPaths,

  [Parameter(Mandatory)]
  [string] $RepoRootPath
)

. (Join-Path $RepoRootPath 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-IsParameterRequired.ps1')

if ($moduleFolderPaths.Count -gt 1) {
  $topLevelModuleTemplatePath = $moduleFolderPaths | Sort-Object | Select-Object -First 1
}
else {
  $topLevelModuleTemplatePath = $moduleFolderPaths
}

BeforeAll {
  $moduleJsonContentHashtable = Get-Content -Path (Join-Path $topLevelModuleTemplatePath 'main.json') | ConvertFrom-Json -AsHashtable
}

Describe 'AVM Core Team Module Specific Tests' {

  Context 'WAF - Reliability Pillar - Parameter Tests' {

    It 'VM Module Availability Zone Parameter Should Not Have A Default Value Set' {
      $isRequired = Get-IsParameterRequired -TemplateFileContent $moduleJsonContentHashtable -Parameter $moduleJsonContentHashtable.parameters.availabilityZone
      $isRequired | Should -Be $true
    }

  }

}
