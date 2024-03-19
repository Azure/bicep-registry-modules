param (
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
