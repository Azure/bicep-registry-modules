param (
  [Parameter(Mandatory = $false)]
  [array] $moduleFolderPaths = ((Get-ChildItem $repoRootPath -Recurse -Directory -Force).FullName | Where-Object {
          (Get-ChildItem $_ -File -Depth 0 -Include @('main.bicep') -Force).Count -gt 0
    }),

  [Parameter(Mandatory = $false)]
  [string] $repoRootPath
)

. (Join-Path $repoRootPath 'avm' 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-IsParameterRequired.ps1')

BeforeAll {
  $moduleJsonContentHashtable = Get-Content -Path (Join-Path '..' '..' 'main.json') | ConvertFrom-Json
}

Describe 'Availability Zone Tests' {

  It 'VM Module Availability Zone Parameter Should Not Have A Default Value Set' {
    $isRequired = Get-IsParameterRequired -TemplateFileContent $moduleJsonContentHashtable -Parameter $moduleJsonContentHashtable.parameters.availabilityZone

    $isRequired | Should -Be $true
  }

}
