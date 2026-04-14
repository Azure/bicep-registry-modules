targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sascwaf'

#disable-diagnostics no-unused-params
@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'dep-${namePrefix}-security.azureSecurityCenter-${serviceShort}-rg'
  location: resourceLocation
}
// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      location: resourceLocation
      defenderPlans: [
        {
          name: 'VirtualMachines'
          pricingTier: 'Standard'
          subPlan: 'P2'
        }
        {
          name: 'SqlServers'
          pricingTier: 'Standard'
        }
        {
          name: 'AppServices'
          pricingTier: 'Standard'
        }
        {
          name: 'StorageAccounts'
          pricingTier: 'Standard'
          subPlan: 'DefenderForStorageV2'
          extensions: [
            {
              name: 'OnUploadMalwareScanning'
              isEnabled: 'True'
              additionalExtensionProperties: {
                CapGBPerMonthPerStorageAccount: 5000
              }
            }
            {
              name: 'SensitiveDataDiscovery'
              isEnabled: 'True'
            }
          ]
        }
        {
          name: 'SqlServerVirtualMachines'
          pricingTier: 'Standard'
        }
        {
          name: 'KeyVaults'
          pricingTier: 'Standard'
        }
        {
          name: 'Arm'
          pricingTier: 'Standard'
        }
        {
          name: 'OpenSourceRelationalDatabases'
          pricingTier: 'Standard'
        }
        {
          name: 'Containers'
          pricingTier: 'Standard'
        }
        {
          name: 'CosmosDbs'
          pricingTier: 'Standard'
        }
        {
          name: 'CloudPosture'
          pricingTier: 'Standard'
          extensions: [
            {
              name: 'AgentlessVmScanning'
              isEnabled: 'True'
            }
            {
              name: 'AgentlessDiscoveryForKubernetes'
              isEnabled: 'True'
            }
            {
              name: 'SensitiveDataDiscovery'
              isEnabled: 'True'
            }
            {
              name: 'ContainerRegistriesVulnerabilityAssessments'
              isEnabled: 'True'
            }
          ]
        }
        {
          name: 'Api'
          pricingTier: 'Standard'
          subPlan: 'P1'
        }
      ]
      securityContactProperties: {
        emails: 'security@contoso.com'
        isEnabled: true
        notificationsByRole: {
          roles: [
            'Owner'
          ]
          state: 'On'
        }
        notificationsSources: [
          {
            sourceType: 'Alert'
            minimalSeverity: 'Medium'
          }
          {
            sourceType: 'AttackPath'
            minimalRiskLevel: 'High'
          }
        ]
      }
    }
  }
]
