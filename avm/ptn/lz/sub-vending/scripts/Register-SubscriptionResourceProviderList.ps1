Param(
[string]$subscriptionId,
[string]$resourceProviders
)

$ErrorActionPreference = 'SilentlyContinue'
# Selecting the right subscription
Select-AzSubscription -SubscriptionId $subscriptionId

# Defining variables
$providers = $resourceProviders | ConvertFrom-Json -AsHashtable
$failedProviders = ''
$failedFeatures = ''
$DeploymentScriptOutputs = @{}

##############################################
## Registering resource providers and features
##############################################

if ($providers.Count -gt 0) {
  foreach ($provider in $providers.keys) {
    try {
      # Registering resource providers
      $providerStatus = (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -EQ $provider).registrationState
      # Check if the providered is registered
      if ($providerStatus -eq 'NotRegistered') {
        Write-Output "`n Registering the '$provider' provider"
        if (Register-AzResourceProvider -ProviderNamespace $provider) {
          Write-Output "`n The registration for provider'$provider' has started successfully"
        } else {
          Write-Output "`n The '$provider' provider has not been registered successfully"
          $failedProviders += ",$provider"
        }
      } elseif ($providerStatus -eq 'Registering') {
        Write-Output "`n The '$provider' provider is in registering state"
        $failedProviders += ",$provider"
      } elseif ( $null -eq $providerStatus) {
        Write-Output "`n There was a problem registering the '$provider' provider. Please make sure this provider namespace is valid"
        $failedProviders += ",$provider"
      }

      if ($failedProviders.length -gt 0) {
        $output = $failedProviders.substring(1)
      } else {
        $output = 'No failures'
      }
      $DeploymentScriptOutputs['failedProvidersRegistrations'] = $output
    } catch {
      Write-Output "`n There was a problem registering the '$provider' provider. Please make sure this provider namespace is valid"
      $failedProviders += ",$provider"
      if ($failedProviders.length -gt 0) {
        $output = $failedProviders.substring(1)
      }
      $DeploymentScriptOutputs['failedProvidersRegistrations'] = $output
    }
    # Registering resource providers features
    $features = $providers[$provider]
    if ($features.length -gt 0) {
      foreach ($feature in $features) {
        try {
          # Define variables
          $featureStatus = (Get-AzProviderFeature -ListAvailable | Where-Object FeatureName -EQ $feature).RegistrationState
          # Check if the feature is registered
          if ($featureStatus -eq 'NotRegistered' -or $featureStatus -eq 'Unregistered') {
            Write-Output "`n Registering the '$feature' feature"
            if (Register-AzProviderFeature -FeatureName $feature -ProviderNamespace $provider) {
              Write-Output "`n The The registration for feature '$feature' has started successfully"
            } else {
              Write-Output "`n The '$feature' feature has not been registered successfully"
              $failedFeatures += ",$feature"
            }
          } elseif ($null -eq $featureStatus) {
            Write-Output "`n The '$feature' feature doesn't exist."
            $failedFeatures += ",$feature"
          }
          if ($failedFeatures.length -gt 0) {
            $output = $failedFeatures.substring(1)
          } else {
            $output = 'No failures'
          }
          $DeploymentScriptOutputs['failedFeaturesRegistrations'] = $output
        } catch {
          Write-Output "`n There was a problem registering the '$feature' feature. Please make sure this feature name is valid"
          $failedFeatures += ",$feature"
          if ($failedFeatures.length -gt 0) {
            $output = $failedFeatures.substring(1)
          }
          $DeploymentScriptOutputs['failedFeaturesRegistrations'] = $output
        }
      }
    } else {
      $output = 'No failures'
      $DeploymentScriptOutputs['failedFeaturesRegistrations'] = $output
    }
  }
} else {
  Write-Output "`n No providers or features to register"
}
