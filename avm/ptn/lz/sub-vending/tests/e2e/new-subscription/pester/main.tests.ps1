[CmdletBinding()]
param (
  [Parameter(Mandatory)]
  [string]
  $prNumber,

  [Parameter(Mandatory)]
  [string]
  $subId,

  [Parameter(Mandatory)]
  [string]
  $location,

  [Parameter(Mandatory)]
  [hashtable]
  $TestInputData
)

Describe "Bicep Landing Zone (Sub) Vending Tests" {

  BeforeAll {
    Update-AzConfig -DisplayBreakingChangeWarning $false
    Select-AzSubscription -subscriptionId $subId
  }

  Context "Subscription Tests" {
    BeforeAll {
      $sub = Get-AzSubscription -SubscriptionId $subId -ErrorAction SilentlyContinue
    }

    It "Should have a Subscription with the correct name" {
      $sub.Name | Should -Be "sub-blzv-tests-pr-$prNumber"
    }

    It "Should have a Subscription that is enabled" {
      $sub.State | Should -Be "Enabled"
    }

    It "Should have a Subscription with a tag key of 'prNumber'" {
      $sub.Tags.Keys | Should -Contain "prNumber"
    }

    It "Should have a Subscription with a tag key of 'prNumber' with a value of '$prNumber'" {
      $sub.Tags.prNumber | Should -Be $prNumber
    }

    It "Should have a Subscription that is a child of the Management Group with the ID of 'bicep-lz-vending-automation-child'" {
      $mgAssociation = Get-AzManagementGroupSubscription -SubscriptionId $subId -GroupId "bicep-lz-vending-automation-child" -ErrorAction SilentlyContinue
      $mgAssociation.Id | Should -Be "/providers/Microsoft.Management/managementGroups/bicep-lz-vending-automation-child/subscriptions/$subId"
    }

    It "Should have the 'Microsoft.HybridCompute', 'Microsoft.AVS' resource providers and the 'AzureServicesVm', 'ArcServerPrivateLinkPreview' resource providers features registered" {
      $resourceProviders = @( "Microsoft.HybridCompute", "Microsoft.AVS" )
      $resourceProvidersFeatures = @( "AzureServicesVm", "ArcServerPrivateLinkPreview" )
      ForEach ($provider in $resourceProviders) {
        $providerStatus = (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -eq $provider).registrationState
        $providerStatus | Should -BeIn @('Registered', 'Registering')
      }

      ForEach ($feature in $resourceProvidersFeatures) {
        $providerFeatureStatus = (Get-AzProviderFeature -ListAvailable | Where-Object FeatureName -eq $feature).registrationState
        $providerFeatureStatus | Should -BeIn @('Registered', 'Registering', 'Pending')
      }
    }
  }

  Context "Role-Based Access Control Assignment Tests" {
    It "Should Have a Role Assignment for an known AAD Group with the Reader role directly upon the Subscription" {
      $iterationCount = 0
      do {
        $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subId" -RoleDefinitionName "Reader" -ObjectId "7eca0dca-6701-46f1-b7b6-8b424dab50b3" -ErrorAction SilentlyContinue
        if ($null -eq $roleAssignment) {
          Write-Host "Waiting for Subscription Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
          Start-Sleep -Seconds 40
          $iterationCount++
        }
      } until (
        $roleAssignment -ne $null -or $iterationCount -ge 10
      )

      $roleAssignment.ObjectId | Should -Be "7eca0dca-6701-46f1-b7b6-8b424dab50b3"
      $roleAssignment.RoleDefinitionName | Should -Be "Reader"
      $roleAssignment.scope | Should -Be "/subscriptions/$subId"
    }

    It "Should Have a Role Assignment for an known AAD Group with the Network Contributor role directly upon the Resource Group" {
      $iterationCount = 0
      do {
        $roleAssignment = Get-AzRoleAssignment -Scope "/subscriptions/$subId/resourceGroups/rsg-$location-net-hs-pr-$prNumber" -RoleDefinitionName "Network Contributor" -ObjectId "7eca0dca-6701-46f1-b7b6-8b424dab50b3" -ErrorAction SilentlyContinue
        if ($null -eq $roleAssignment) {
          Write-Host "Waiting for Resource Group Role Assignments to be eventually consistent... Iteration: $($iterationCount)" -ForegroundColor Yellow
          Start-Sleep -Seconds 40
          $iterationCount++
        }
      } until (
        $roleAssignment -ne $null -or $iterationCount -ge 10
      )

      $roleAssignment.ObjectId | Should -Be "7eca0dca-6701-46f1-b7b6-8b424dab50b3"
      $roleAssignment.RoleDefinitionName | Should -Be "Network Contributor"
      $roleAssignment.scope | Should -Be "/subscriptions/$subId/resourceGroups/rsg-$location-net-hs-pr-$prNumber"
    }
  }
}
