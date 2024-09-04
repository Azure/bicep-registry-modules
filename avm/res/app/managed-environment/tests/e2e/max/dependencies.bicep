@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Application Insights Component to create.')
param appInsightsComponentName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Deployment Script to create for the Certificate generation.')
param certDeploymentScriptName string

@secure()
@description('Required. The name for the SSL certificate.')
param certname string

var certPWSecretName = 'pfxCertificatePassword'
var certSecretName = 'pfxBase64Certificate'

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

var addressPrefix = '10.0.0.0/16'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

resource appInsightsComponent 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsComponentName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 23, 0)
          delegations: [
            {
              name: 'Microsoft.App.environments'
              properties: {
                serviceName: 'Microsoft.App/environments'
              }
            }
          ]
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enablePurgeProtection: null
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enabledForDeployment: true
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${managedIdentity.name}-KeyVault-Admin-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '00482a5a-887f-4fb3-b363-3b7fe8e74483'
    ) // Key Vault Administrator
    principalType: 'ServicePrincipal'
  }
}

resource certDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: certDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    arguments: '-KeyVaultName "${keyVault.name}" -CertName "${certname}" -CertSubjectName "CN=*.contoso.com"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Set-CertificateInKeyVault.ps1')
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'FileStorage'
  properties: {
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork.name, 'defaultSubnet')
        }
      ]
    }
  }

  resource fileService 'fileServices@2023-01-01' = {
    name: 'default'

    resource smbfileshare 'shares@2023-01-01' = {
      name: 'smbfileshare'
      properties: {
        enabledProtocols: 'SMB'
        shareQuota: 100
      }
    }

    resource azureFileNFS 'shares@2023-01-01' = {
      name: 'nfsfileshare'
      properties: {
        enabledProtocols: 'NFS'
        shareQuota: 100
      }
    }
  }
}

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The URI of the created Key Vault.')
output keyVaultUri string = keyVault.properties.vaultUri

@description('The URL of the created certificate.')
output certificateSecretUrl string = certDeploymentScript.properties.outputs.secretUrl

@description('The name of the certification password secret.')
output certPWSecretName string = certPWSecretName

@description('The name of the certification secret.')
output certSecretName string = certSecretName

@description('The Connection String of the created Application Insights Component.')
output appInsightsConnectionString string = appInsightsComponent.properties.ConnectionString

@description('The name of the created Storage Account.')
output storageAccountName string = storageAccount.name
