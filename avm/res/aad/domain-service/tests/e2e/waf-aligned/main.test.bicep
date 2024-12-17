targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-aad-domainservices-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aaddswaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    namePrefix: namePrefix
    certDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: last(split(nestedDependencies.outputs.keyVaultResourceId, '/'))
  scope: resourceGroup
}

// 'idem' as second iteration will fail, as AAD DS is not ready for a second deployment during its provisioning state even when reported as 'succeeded' by the init iteration
// as of https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr7---category-testing---idempotency-tests the idem test it is not required
module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-init'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    domainName: '${namePrefix}.onmicrosoft.com'
    additionalRecipients: ['${namePrefix}@noreply.github.com']
    diagnosticSettings: [
      {
        name: 'customSetting'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
        workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
      }
    ]
    lock: {
      kind: 'None'
      name: 'myCustomLockName'
    }
    ldaps: 'Enabled'
    externalAccess: 'Enabled'
    pfxCertificate: keyVault.getSecret(nestedDependencies.outputs.certSecretName)
    pfxCertificatePassword: keyVault.getSecret(nestedDependencies.outputs.certPWSecretName)
    replicaSets: [
      {
        location: 'NorthEurope'
        subnetId: nestedDependencies.outputs.subnetResourceId
      }
    ]
    sku: 'Standard'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

module waitForDeployment 'main.wait.bicep' = {
  dependsOn: [testDeployment]
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-waitForDeployment'
  params: {
    serviceShort: serviceShort
    resourceLocation: resourceLocation
    waitTimeInSeconds: '3000' // 50 min
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

// copy from the init test. Will be executed after a wait time
module testDeploymentIdem '../../../main.bicep' = {
  dependsOn: [waitForDeployment]
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-idem'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: resourceLocation
    domainName: '${namePrefix}.onmicrosoft.com'
    additionalRecipients: ['${namePrefix}@noreply.github.com']
    diagnosticSettings: [
      {
        name: 'customSetting'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
        workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
      }
    ]
    lock: {
      kind: 'None'
      name: 'myCustomLockName'
    }
    ldaps: 'Enabled'
    externalAccess: 'Enabled'
    pfxCertificate: keyVault.getSecret(nestedDependencies.outputs.certSecretName)
    pfxCertificatePassword: keyVault.getSecret(nestedDependencies.outputs.certPWSecretName)
    replicaSets: [
      {
        location: 'NorthEurope'
        subnetId: nestedDependencies.outputs.subnetResourceId
      }
    ]
    sku: 'Standard'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
