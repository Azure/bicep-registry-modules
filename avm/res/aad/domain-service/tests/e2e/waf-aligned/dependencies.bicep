@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string

@description('Required. The name of the Deployment Script to create for the Certificate generation.')
param certDeploymentScriptName string

var certPWSecretName = 'pfxCertificatePassword'
var certSecretName = 'pfxBase64Certificate'
var addressPrefix = '10.0.0.0/16'
var aadsSubnetAddressPrefix = cidrSubnet(addressPrefix, 24, 1)

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    dhcpOptions: {
      // set the DNS servers to the 4th and 5th addresses in the subnet
      dnsServers: [for i in range(3, 2): cidrHost(aadsSubnetAddressPrefix, i)]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
        }
      }
      {
        name: 'aadds-subnet'
        properties: {
          addressPrefix: aadsSubnetAddressPrefix
          networkSecurityGroup: {
            id: nsgAaddSubnet.id
          }
        }
      }
    ]
  }
}

resource nsgAaddSubnet 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${virtualNetworkName}-aadds-subnet-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowSyncWithAzureAD'
        properties: {
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureActiveDirectoryDomainServices'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowPSRemoting'
        properties: {
          access: 'Allow'
          priority: 301
          direction: 'Inbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'AzureActiveDirectoryDomainServices'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '5986'
        }
      }
      {
        name: 'AllowLDAPs'
        properties: {
          access: 'Allow'
          priority: 401
          direction: 'Inbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '636'
        }
      }
    ]
  }
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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
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
    azPowerShellVersion: '11.0'
    retentionInterval: 'P1D'
    arguments: ' -KeyVaultName "${keyVault.name}" -ResourceGroupName "${resourceGroup().name}" -NamePrefix "${namePrefix}" -CertPWSecretName "${certPWSecretName}" -CertSecretName "${certSecretName}"'
    scriptContent: loadTextContent('../../../../../../../utilities/e2e-template-assets/scripts/Set-PfxCertificateInKeyVault.ps1')
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[1].id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The name of the certification password secret.')
output certPWSecretName string = certPWSecretName

@description('The name of the certification secret.')
output certSecretName string = certSecretName

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
