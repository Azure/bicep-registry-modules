param (
  [Parameter(Mandatory = $false)]
  [array] $moduleFolderPaths,

  [Parameter(Mandatory = $false)]
  [string] $repoRootPath
)

. (Join-Path $RepoRootPath 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-IsParameterRequired.ps1')

Write-Verbose ($moduleFolderPaths | ConvertTo-Json) -Verbose

if ($moduleFolderPaths.Count -gt 1) {
  $topLevelModuleTemplatePath = $moduleFolderPaths | Sort-Object | Select-Object -First 1
}
else {
  $topLevelModuleTemplatePath = $moduleFolderPaths
}

Write-Verbose ($topLevelModuleTemplatePath | ConvertTo-Json) -Verbose

BeforeAll {
  $modulePathToTest = Join-Path $topLevelModuleTemplatePath 'main.json'
  Write-Verbose ($topLevelModuleTemplatePath | ConvertTo-Json) -Verbose
  $moduleJsonContentHashtable = Get-Content -Path $modulePathToTest | ConvertFrom-Json -AsHashtable
}

Describe 'AVM Core Team Module Specific Tests' {

  Context 'WAF - Reliability Pillar - Parameter Tests' {

    It 'VM Module Availability Zone Parameter Should Not Have A Default Value Set' {
      $isRequired = Get-IsParameterRequired -TemplateFileContent $moduleJsonContentHashtable -Parameter $moduleJsonContentHashtable.parameters.availabilityZone
      $isRequired | Should -Be $true
    }

  }

}
