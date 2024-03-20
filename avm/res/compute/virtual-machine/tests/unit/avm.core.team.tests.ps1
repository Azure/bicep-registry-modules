param (
  [Parameter(Mandatory = $false)]
  [array] $moduleFolderPaths = ((Get-ChildItem $repoRootPath -Recurse -Directory -Force).FullName | Where-Object {
          (Get-ChildItem $_ -File -Depth 0 -Include @('main.bicep') -Force).Count -gt 0
    }),

  [Parameter(Mandatory = $false)]
  [string] $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.FullName
)

. (Join-Path $RepoRootPath 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-IsParameterRequired.ps1')

if ($moduleFolderPaths.Count -gt 1) {
  $topLevelModuleTemplatePath = $moduleFolderPaths | Sort-Object | Select-Object -First 1
}
else {
  $topLevelModuleTemplatePath = $moduleFolderPaths
}

Write-Verbose $topLevelModuleTemplatePath -Verbose

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
