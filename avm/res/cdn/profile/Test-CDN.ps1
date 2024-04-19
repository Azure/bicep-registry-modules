# #########[ Function Test-ModulesLocally.ps1 ]#############
# . 'C:\dev\ip\bicep-registry-modules\AlexanderSehr-fork\avm\utilities\tools\Test-ModuleLocally.ps1'
$repo = 'bicep-registry-modules'
# $repo = 'fork-hundredacres'
# $repo = 'Upstream-Azure'
# $repo = 'fork-rahalan'
# $root = "C:\dev\ip\bicep-registry-modules\$repo\avm"
# . (Join-Path $root 'utilities\tools\Test-ModuleLocally.ps1')

$root = "C:\Users\gbeaud\GitHub\$repo\avm"

# . '/mnt/c/dev/ip/bicep-registry-modules/AlexanderSehr-fork/avm/utilities/tools/Test-ModuleLocally.ps1'

$res = Measure-Command {
  $TestModuleLocallyInput = @{
    # TemplateFilePath           = '/mnt/c/dev/ip/bicep-registry-modules/alexanderSehr-fork/avm/res/operational-insights/workspace/main.bicep'
    TemplateFilePath           = "$root\res\cdn\profile\main.bicep"
    ModuleTestFilePath         = "$root\res\cdn\profile\tests\e2e\afd\main.test.bicep"
    PesterTest                 = $false
    # WhatIfTest                 = $false
    ValidationTest             = $false
    DeploymentTest             = $true
    ValidateOrDeployParameters = @{
      Location          = 'swedencentral'
      # SubscriptionId    = 'cfa4dc0b-3d25-4e58-a70a-7085359080c5' # AVM
      SubscriptionId    = '274a659d-2e0c-45ca-82c3-19ab49531c30' # CARML
      # SubscriptionId    = 'b765c5e5-ae60-4724-9b59-36fbcf56795b' # Pvt
      ManagementGroupId = 'alz-sandbox'
      RemoveDeployment  = $false
    }
    # Token need to be unique
    AdditionalTokens           = @{
      namePrefix = 'gbd'
    }
    AdditionalParameters       = @{
      resourceLocation = 'swedencentral'
    }
  }
  Test-ModuleLocally @TestModuleLocallyInput
}
Write-Host ('Runtime: [{0}] seconds' -f $res.TotalSeconds) -ForegroundColor 'Cyan'
