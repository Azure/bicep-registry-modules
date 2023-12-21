@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Required. The name of the Key Vault for Disk Encryption to create.')
param keyVaultDiskName string

@description('Required. The name of the Azure Machine Learning Workspace to create.')
param amlWorkspaceName string

@description('Required. The name of the Load Balancer to create.')
param loadBalancerName string

@description('Required. The name of the Network Security Group to create.')
param networkSecurityGroupName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

@description('Required. The name of the Application Insights Instanec to create.')
param applicationInsightsName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

var addressPrefix = '10.0.0.0/16'

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
        enablePurgeProtection: true // Required by batch account
        softDeleteRetentionInDays: 7
        enabledForTemplateDeployment: true
        enabledForDiskEncryption: true
        enabledForDeployment: true
        enableRbacAuthorization: true
        accessPolicies: []
    }

    resource key 'keys@2022-07-01' = {
        name: 'keyEncryptionKey'
        properties: {
            kty: 'RSA'
        }
    }
}

resource keyVaultDisk 'Microsoft.KeyVault/vaults@2022-07-01' = {
    name: keyVaultDiskName
    location: location
    properties: {
        sku: {
            family: 'A'
            name: 'standard'
        }
        tenantId: tenant().tenantId
        enablePurgeProtection: true // Required by batch account
        softDeleteRetentionInDays: 7
        enabledForTemplateDeployment: true
        enabledForDiskEncryption: true
        enabledForDeployment: true
        enableRbacAuthorization: true
        accessPolicies: []
    }

    resource key 'keys@2022-07-01' = {
        name: 'keyEncryptionKeyDisk'
        properties: {
            kty: 'RSA'
        }
    }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${keyVault::key.id}-${location}-${managedIdentity.id}-Key-Key-Vault-Crypto-User-RoleAssignment')
    scope: keyVault::key
    properties: {
        principalId: '5167ea7a-355a-466f-ae8b-8ea60f718b35' // AzureDatabricks Enterprise Application Object Id
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '12338af0-0e69-4776-bea7-57ae8d297424') // Key Vault Crypto User
        principalType: 'ServicePrincipal'
    }
}

resource amlPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${keyVault.id}-${location}-${managedIdentity.id}-Key-Vault-Contributor')
    scope: keyVault
    properties: {
        principalId: managedIdentity.properties.principalId
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
        principalType: 'ServicePrincipal'
    }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: 'Standard_ZRS'
    }
    kind: 'StorageV2'
    properties: {}
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
    name: applicationInsightsName
    location: location
    kind: 'web'
    properties: {
        Application_Type: 'web'
    }
}

resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2023-04-01' = {
    name: amlWorkspaceName
    location: location
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentity.id}': {}
        }
    }
    properties: {
        storageAccount: storageAccount.id
        keyVault: keyVault.id
        applicationInsights: applicationInsights.id
        primaryUserAssignedIdentity: managedIdentity.id
    }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' = {
    name: loadBalancerName
    location: location
    properties: {
        backendAddressPools: [
            {
                name: 'default'
            }
        ]
        frontendIPConfigurations: [
            {
                name: 'privateIPConfig1'
                properties: {
                    subnet: {
                        id: virtualNetwork.properties.subnets[0].id
                    }
                }
            }
        ]
    }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
    name: networkSecurityGroupName
    location: location
    properties: {
        securityRules: [
            {
                name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound'
                properties: {
                    description: 'Required for worker nodes communication within a cluster.'
                    protocol: '*'
                    sourcePortRange: '*'
                    destinationPortRange: '*'
                    sourceAddressPrefix: 'VirtualNetwork'
                    destinationAddressPrefix: 'VirtualNetwork'
                    access: 'Allow'
                    priority: 100
                    direction: 'Inbound'
                }
            }
            {
                name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp'
                properties: {
                    description: 'Required for workers communication with Databricks Webapp.'
                    protocol: 'Tcp'
                    sourcePortRange: '*'
                    destinationPortRange: '443'
                    sourceAddressPrefix: 'VirtualNetwork'
                    destinationAddressPrefix: 'AzureDatabricks'
                    access: 'Allow'
                    priority: 100
                    direction: 'Outbound'
                }
            }
            {
                name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql'
                properties: {
                    description: 'Required for workers communication with Azure SQL services.'
                    protocol: 'Tcp'
                    sourcePortRange: '*'
                    destinationPortRange: '3306'
                    sourceAddressPrefix: 'VirtualNetwork'
                    destinationAddressPrefix: 'Sql'
                    access: 'Allow'
                    priority: 101
                    direction: 'Outbound'
                }
            }
            {
                name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage'
                properties: {
                    description: 'Required for workers communication with Azure Storage services.'
                    protocol: 'Tcp'
                    sourcePortRange: '*'
                    destinationPortRange: '443'
                    sourceAddressPrefix: 'VirtualNetwork'
                    destinationAddressPrefix: 'Storage'
                    access: 'Allow'
                    priority: 102
                    direction: 'Outbound'
                }
            }
            {
                name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound'
                properties: {
                    description: 'Required for worker nodes communication within a cluster.'
                    protocol: '*'
                    sourcePortRange: '*'
                    destinationPortRange: '*'
                    sourceAddressPrefix: 'VirtualNetwork'
                    destinationAddressPrefix: 'VirtualNetwork'
                    access: 'Allow'
                    priority: 103
                    direction: 'Outbound'
                }
            }
            {
                name: 'Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub'
                properties: {
                    description: 'Required for worker communication with Azure Eventhub services.'
                    protocol: 'Tcp'
                    sourcePortRange: '*'
                    destinationPortRange: '9093'
                    sourceAddressPrefix: 'VirtualNetwork'
                    destinationAddressPrefix: 'EventHub'
                    access: 'Allow'
                    priority: 104
                    direction: 'Outbound'
                }
            }
        ]
    }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
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
                    addressPrefix: cidrSubnet(addressPrefix, 20, 0)
                }
            }
            {
                name: 'custom-public-subnet'
                properties: {
                    addressPrefix: cidrSubnet(addressPrefix, 20, 1)
                    networkSecurityGroup: {
                        id: networkSecurityGroup.id
                    }
                    delegations: [
                        {
                            name: 'databricksDelegation'
                            properties: {
                                serviceName: 'Microsoft.Databricks/workspaces'
                            }
                        }
                    ]
                }
            }
            {
                name: 'custom-private-subnet'
                properties: {
                    addressPrefix: cidrSubnet(addressPrefix, 20, 2)
                    networkSecurityGroup: {
                        id: networkSecurityGroup.id
                    }
                    delegations: [
                        {
                            name: 'databricksDelegation'
                            properties: {
                                serviceName: 'Microsoft.Databricks/workspaces'
                            }
                        }
                    ]
                }
            }
        ]
    }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
    name: 'privatelink.azuredatabricks.net'
    location: 'global'

    resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
        name: '${virtualNetwork.name}-vnetlink'
        location: 'global'
        properties: {
            virtualNetwork: {
                id: virtualNetwork.id
            }
            registrationEnabled: false
        }
    }
}

@description('The resource ID of the created Virtual Network Default Subnet.')
output defaultSubnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The name of the created Virtual Network Public Subnet.')
output customPublicSubnetName string = virtualNetwork.properties.subnets[1].name

@description('The name of the created Virtual Network Private Subnet.')
output customPrivateSubnetName string = virtualNetwork.properties.subnets[2].name

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The resource ID of the created Azure Machine Learning Workspace.')
output machineLearningWorkspaceResourceId string = machineLearningWorkspace.id

@description('The resource ID of the created Key Vault.')
output keyVaultResourceId string = keyVault.id

@description('The resource ID of the created Disk Key Vault.')
output keyVaultDiskResourceId string = keyVaultDisk.id

@description('The resource ID of the created Load Balancer.')
output loadBalancerResourceId string = loadBalancer.id

@description('The name of the created Load Balancer Backend Pool.')
output loadBalancerBackendPoolName string = loadBalancer.properties.backendAddressPools[0].name

@description('The name of the created Key Vault encryption key.')
output keyVaultKeyName string = keyVault::key.name

@description('The name of the created Key Vault Disk encryption key.')
output keyVaultDiskKeyName string = keyVaultDisk::key.name

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
