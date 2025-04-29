metadata name = '<Add module name>'
metadata description = '<Add description>'

@description('Required. Name of the resource to create.')
param solutionPrefix string

@description('Optional. Location for all Resources.')
param solutionLocation string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Configuration for the virtual machine.')
param virtualMachineConfiguration virtualMachineConfigurationType

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {
  app: solutionPrefix
  location: solutionLocation
}

//
// Add your parameters here
//

// ============== //
// Resources      //
// ============== //

/* #disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.[[REPLACE WITH TELEMETRY IDENTIFIER]].${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
} */

// ========== Log Analytics Workspace ========== //
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'avm.ptn.sa.macae.operational-insights-workspace'
  params: {
    name: '${solutionPrefix}laws'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 30
  }
}

// ========== Application Insights ========== //
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'avm.ptn.sa.macae.insights-component'
  params: {
    name: '${solutionPrefix}appi'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
    requestSource: 'rest'
  }
}

// ========== User assigned identity Web App ========== //
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: 'avm.ptn.sa.macae.managed-identity-assigned-identity'
  params: {
    name: '${solutionPrefix}uaidwapp'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
  }
}

// ========== Network Security Groups ========== //

module networkSecurityGroupDefault 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'avm.ptn.sa.macae.network-network-security-group-default'
  params: {
    name: '${solutionPrefix}nsgrdflt'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    securityRules: [
      // {
      //   name: 'DenySshRdpOutbound'
      //   properties: {
      //     priority: 200
      //     access: 'Deny'
      //     protocol: '*'
      //     direction: 'Outbound'
      //     sourceAddressPrefix: 'VirtualNetwork'
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: '*'
      //     destinationPortRanges: [
      //       '3389'
      //       '22'
      //     ]
      //   }
      // }
    ]
  }
}

module networkSecurityGroupContainers 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'avm.ptn.sa.macae.network-network-security-group-containers'
  params: {
    name: '${solutionPrefix}nsgrcntr'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    securityRules: [
      //CONFIGURE
    ]
  }
}

// ========== NAT Gateway ========== //
// Check if we need this
//
// module natGateway 'br/public:avm/res/network/nat-gateway:1.2.2' = {
//   name: 'avm.ptn.sa.macae.network-nat-gateway'
//   params: {
//     name: '${solutionPrefix}natg'
//     tags: tags
//     location: solutionLocation
//     enableTelemetry: enableTelemetry
//     zone: 1
//     publicIPAddressObjects: [
//       {
//         diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
//         name: '${solutionPrefix}natgip'
//         skuTier: 'Regional'
//         zones: [1, 2, 3]
//         tags: tags
//         idleTimeoutInMinutes: 30
//       }
//     ]
//   }
// }

// ========== Virtual Network ========== //

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'avm.ptn.sa.macae.network-virtual-network'
  params: {
    name: '${solutionPrefix}vnet'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: ['10.0.0.0/8']
    subnets: [
      // The default subnet **must** be the first in the subnets array
      {
        addressPrefix: '10.0.0.0/24'
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        name: 'default'
        //networkSecurityGroupResourceId: networkSecurityGroupDefault.outputs.resourceId
      }
      {
        // If you use your own VNet, you need to provide a subnet that is dedicated exclusively to the Container App environment you deploy. This subnet isn't available to other services
        // https://learn.microsoft.com/en-us/azure/container-apps/networking?tabs=workload-profiles-env%2Cazure-cli#custom-vnet-configuration
        addressPrefix: '10.0.2.0/23' //subnet of size /23 is required for container app
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        name: 'containers'
        //networkSecurityGroupResourceId: networkSecurityGroupContainers.outputs.resourceId
      }
      {
        addressPrefix: '10.0.4.0/26'
        name: 'AzureBastionSubnet'
        //networkSecurityGroupResourceId: networkSecurityGroupBastion.outputs.resourceId
      }
      {
        addressPrefix: '10.0.4.64/26'
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        name: 'virtual-machines'
        //natGatewayResourceId: natGateway.outputs.resourceId
        //networkSecurityGroupResourceId: networkSecurityGroupVirtualMachines.outputs.resourceId
      }
      {
        addressPrefix: '10.0.5.0/24'
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        name: 'application-gateway'
        //networkSecurityGroupResourceId: networkSecurityGroupApplicationGateway.outputs.resourceId
      }
    ]
  }
}

// ========== Bastion host ========== //

module bastionHost 'br/public:avm/res/network/bastion-host:0.6.1' = {
  name: 'avm.ptn.sa.macae.private-dns-zone-bastion-host'
  params: {
    name: '${solutionPrefix}bstn'
    location: solutionLocation
    skuName: 'Standard'
    enableTelemetry: enableTelemetry
    tags: tags
    virtualNetworkResourceId: virtualNetwork.outputs.resourceId
    publicIPAddressObject: {
      name: '${solutionPrefix}pbipbstn'
    }
    disableCopyPaste: false
    enableFileCopy: false
    enableIpConnect: true
    //enableKerberos: bastionConfiguration.?enableKerberos
    enableShareableLink: true
    //scaleUnits: bastionConfiguration.?scaleUnits
  }
}

// ========== Virtual machine ========== //

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.13.0' = {
  name: 'avm.ptn.sa.macae.compute-virtual-machine'
  params: {
    name: '${solutionPrefix}vmws'
    computerName: take('${solutionPrefix}vmws', 15)
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    adminUsername: virtualMachineConfiguration.adminUsername
    adminPassword: virtualMachineConfiguration.adminPassword
    nicConfigurations: [
      {
        //networkSecurityGroupResourceId: virtualMachineConfiguration.?nicConfigurationConfiguration.networkSecurityGroupResourceId
        nicSuffix: 'nic01'
        diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[3]
            diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
          }
        ]
      }
    ]
    imageReference: {
      publisher: 'microsoft-dsvm'
      offer: 'dsvm-win-2022'
      sku: 'winserver-2022'
      version: 'latest'
    }
    osDisk: {
      createOption: 'FromImage'
      managedDisk: {
        storageAccountType: 'Premium_ZRS'
      }
      diskSizeGB: 128
      caching: 'ReadWrite'
    }
    //patchMode: virtualMachineConfiguration.?patchMode
    osType: 'Windows'
    encryptionAtHost: false //The property 'securityProfile.encryptionAtHost' is not valid because the 'Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription.
    vmSize: 'Standard_D2s_v3'
    zone: 0
    extensionAadJoinConfig: {
      enabled: true
      typeHandlerVersion: '1.0'
    }
    // extensionMonitoringAgentConfig: {
    //   enabled: true
    // }
    //    maintenanceConfigurationResourceId: virtualMachineConfiguration.?maintenanceConfigurationResourceId
  }
}
// ========== DNS Zone for AI Foundry: Open AI ========== //
var openAiSubResource = 'account'
var openAiPrivateDnsZones = {
  'privatelink.cognitiveservices.azure.com': openAiSubResource
  'privatelink.openai.azure.com': openAiSubResource
  'privatelink.services.ai.azure.com': openAiSubResource
}

module privateDnsZonesAiServices 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in objectKeys(openAiPrivateDnsZones): {
    name: 'avm.ptn.sa.macae.private-dns-zone-${uniqueString(deployment().name, zone)}'
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetwork.outputs.resourceId }]
    }
  }
]

// ========== AI Foundry: Open AI ==========
var aiServicesDeploymentGptName = 'gpt-4o'
var aiServicesDeploymentGptVersion = '2024-08-06'

module aiServices 'br/public:avm/res/cognitive-services/account:0.10.2' = {
  name: 'avm.ptn.sa.macae.cognitive-services-account'
  params: {
    name: '${solutionPrefix}aisv'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    sku: 'S0'
    kind: 'OpenAI'
    disableLocalAuth: true
    customSubDomainName: '${solutionPrefix}aisv'
    apiProperties: {
      staticsEnabled: false
    }
    publicNetworkAccess: 'Enabled' //TODO: block and connect to vnet
    privateEndpoints: [
      {
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
        service: openAiSubResource
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: map(objectKeys(openAiPrivateDnsZones), zone => {
            name: replace(zone, '.', '-')
            privateDnsZoneResourceId: resourceId('Microsoft.Network/privateDnsZones', zone)
          })
        }
      }
    ]
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
      }
      {
        principalId: containerApp.outputs.systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
      }
    ]
    deployments: [
      {
        name: aiServicesDeploymentGptName
        model: {
          format: 'OpenAI'
          name: aiServicesDeploymentGptName
          version: aiServicesDeploymentGptVersion
        }
        sku: {
          name: 'GlobalStandard'
          capacity: 50
        }
      }
    ]
  }
}

// ========== DNS Zone for Cosmos DB ========== //
module privateDnsZoneCosmosDb 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: 'avm.ptn.sa.macae.network-private-dns-zone-cosmos-db'
  params: {
    name: 'privatelink.documents.azure.com'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetwork.outputs.resourceId }]
    tags: tags
  }
}

// ========== Cosmos DB ========== //
var cosmosDbName = '${solutionPrefix}csdb'
var cosmosDbDatabaseName = 'autogen'
var cosmosDbDatabaseMemoryContainerName = 'autogen'
module cosmosDb 'br/public:avm/res/document-db/database-account:0.12.0' = {
  name: 'avm.ptn.sa.macae.cosmos-db'
  params: {
    // Required parameters
    name: cosmosDbName
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: 'Disabled'
    }
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [{ privateDnsZoneResourceId: privateDnsZoneCosmosDb.outputs.resourceId }]
        }
        service: 'Sql'
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
      }
    ]
    sqlDatabases: [
      {
        name: cosmosDbDatabaseName
        containers: [
          {
            name: cosmosDbDatabaseMemoryContainerName
            paths: [
              '/session_id'
            ]
            kind: 'Hash'
            version: 2
          }
        ]
      }
    ]
    locations: [
      {
        locationName: solutionLocation
        failoverPriority: 0
      }
    ]
    capabilitiesToAdd: [
      'EnableServerless'
    ]
    sqlRoleAssignmentsPrincipalIds: [
      //userAssignedIdentity.outputs.principalId
      containerApp.outputs.?systemAssignedMIPrincipalId
    ]
    sqlRoleDefinitions: [
      {
        // Replace this with built-in role definition Cosmos DB Built-in Data Contributor: https://docs.azure.cn/en-us/cosmos-db/nosql/security/reference-data-plane-roles#cosmos-db-built-in-data-contributor
        roleType: 'CustomRole'
        roleName: 'Cosmos DB SQL Data Contributor'
        name: 'cosmos-db-sql-data-contributor'
        dataAction: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
      }
    ]
    // roleAssignments: [
    //   {
    //     principalId: userAssignedIdentity.outputs.principalId
    //     principalType: 'ServicePrincipal'
    //     roleDefinitionIdOrName: 'Contributor'
    //   }
    // ]
  }
}

// ========== Container App Environment ========== //
module containerAppEnvironment 'br/public:avm/res/app/managed-environment:0.10.2' = {
  name: 'avm.ptn.sa.macae.container-app-environment'
  params: {
    name: '${solutionPrefix}cenv'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    logsDestination: 'log-analytics'
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    appInsightsConnectionString: applicationInsights.outputs.connectionString
    publicNetworkAccess: 'Disabled'
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
    infrastructureSubnetId: virtualNetwork.outputs.subnetResourceIds[1]
    internal: true
  }
}

// TODO: This needs network access to Azure to work
// resource aspireDashboard 'Microsoft.App/managedEnvironments/dotNetComponents@2024-10-02-preview' = {
//   name: '${solutionPrefix}cenv/aspire-dashboard'
//   properties: {
//     componentType: 'AspireDashboard'
//   }
//   dependsOn: [containerAppEnvironment]
// }

// ========== DNS zone for Container App Environment ========== //
module dnsZoneContainerApp 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  name: 'avm.ptn.sa.macae.network-private-dns-zone-containers'
  params: {
    name: 'privatelink.${toLower(replace(containerAppEnvironment.outputs.location,' ',''))}.azurecontainerapps.io'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [{ virtualNetworkResourceId: virtualNetwork.outputs.resourceId }]
  }
}

// ========== Backend Container App Service ========== //
module containerApp 'br/public:avm/res/app/container-app:0.14.2' = {
  name: 'avm.ptn.sa.macae.container-app'
  params: {
    name: '${solutionPrefix}capp'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: containerAppEnvironment.outputs.resourceId
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity.outputs.resourceId] }
    ingressTargetPort: 8000
    ingressExternal: true
    activeRevisionsMode: 'Single'
    corsPolicy: {
      allowedOrigins: [
        'https://${webSiteName}.azurewebsites.net'
        'http://${webSiteName}.azurewebsites.net'
      ]
    }
    scaleSettings: {
      //TODO: Make maxReplicas and minReplicas parameterized
      maxReplicas: 1
      minReplicas: 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: '100'
            }
          }
        }
      ]
    }
    containers: [
      {
        name: 'backend'
        //TODO: Make image parameterized for the registry name and the appversion
        image: 'biabcontainerreg.azurecr.io/macaebackend:latest'
        resources: {
          //TODO: Make cpu and memory parameterized
          cpu: '2.0'
          memory: '4.0Gi'
        }
        env: [
          {
            name: 'COSMOSDB_ENDPOINT'
            value: cosmosDb.outputs.endpoint
          }
          {
            name: 'COSMOSDB_DATABASE'
            value: cosmosDbDatabaseName
          }
          {
            name: 'COSMOSDB_CONTAINER'
            value: cosmosDbDatabaseMemoryContainerName
          }
          {
            name: 'AZURE_OPENAI_ENDPOINT'
            value: aiServices.outputs.endpoint
          }
          {
            name: 'AZURE_OPENAI_DEPLOYMENT_NAME'
            value: aiServicesDeploymentGptName
          }
          {
            name: 'AZURE_OPENAI_API_VERSION'
            value: aiServicesDeploymentGptVersion
          }
          {
            name: 'FRONTEND_SITE_NAME'
            value: 'https://${webSiteName}.azurewebsites.net'
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: applicationInsights.outputs.connectionString
          }
        ]
      }
    ]
  }
}

// ========== Frontend server farm ========== //
module webServerfarm 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: 'avm.ptn.sa.macae.web-server-farm'
  params: {
    tags: tags
    location: solutionLocation
    name: '${solutionPrefix}sfrm'
    skuName: 'P1v2'
    skuCapacity: 1
    reserved: true
    kind: 'linux'
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
  }
}

// ========== Frontend web site ========== //
var webSiteName = '${solutionPrefix}wapp'
module webSite 'br/public:avm/res/web/site:0.15.1' = {
  name: 'avm.ptn.sa.macae.web-site'
  params: {
    tags: tags
    kind: 'app,linux,container'
    name: webSiteName
    location: solutionLocation
    serverFarmResourceId: webServerfarm.outputs.resourceId
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentity.outputs.resourceId] }
    appInsightResourceId: applicationInsights.outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|biabcontainerreg.azurecr.io/macaefrontend:latest'
    }
    publicNetworkAccess: 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
    privateEndpoints: [{ subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0] }]
    appSettingsKeyValuePairs: {
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
      DOCKER_REGISTRY_SERVER_URL: 'https://biabcontainerreg.azurecr.io'
      WEBSITES_PORT: '3000'
      WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
      BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
    }
  }
}

// ========== SSL Self Signed Certificate ========== //

module userAssignedIdentityApplicationGateway 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: 'avm.ptn.sa.macae.user-assigned-identity-application-gateway'
  params: {
    name: '${solutionPrefix}uaidapgw'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.6.1' = {
  name: 'avm.ptn.sa.macae.key-vault'
  params: {
    name: '${solutionPrefix}keyv'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    enablePurgeProtection: false
    enableSoftDelete: true
    enableRbacAuthorization: true
    enableVaultForDeployment: true
    enableVaultForTemplateDeployment: true
    roleAssignments: [
      {
        principalId: userAssignedIdentityApplicationGateway.outputs.principalId
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Key Vault Administrator'
      }
    ]
  }
}

var applicationGatewaySslCertificateKeyVaultSecretName = 'applicationGatewaySslCertificate'
module certificateDeploymentScript 'br/public:avm/res/resources/deployment-script:0.5.1' = {
  name: 'avm.ptn.sa.macae.resources-deployment-script'
  params: {
    name: '${solutionPrefix}scrpcert'
    location: solutionLocation
    kind: 'AzurePowerShell'
    tags: tags
    enableTelemetry: enableTelemetry
    managedIdentities: { userAssignedResourceIds: [userAssignedIdentityApplicationGateway.outputs.resourceId] }
    primaryScriptUri: 'https://raw.githubusercontent.com/Azure/bicep-registry-modules/refs/heads/main/utilities/e2e-template-assets/scripts/Set-CertificateInKeyVault.ps1'
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    arguments: '-KeyVaultName "${keyVault.outputs.name}" -CertName "${applicationGatewaySslCertificateKeyVaultSecretName}"'
  }
}

// ========== Application gateway ========== //
module publicIp 'br/public:avm/res/network/public-ip-address:0.5.1' = {
  name: 'avm.ptn.sa.macae.network-public-ip-address'
  params: {
    name: '${solutionPrefix}pbipapgw'
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    publicIPAllocationMethod: 'Static'
  }
}
var applicationGatewayName = '${solutionPrefix}apgw'
var applicationGatewayExpectedResourceId = '${resourceGroup().id}/providers/Microsoft.Network/applicationGateways/${applicationGatewayName}'

module applicationGateway 'br/public:avm/res/network/application-gateway:0.5.1' = {
  name: 'avm.ptn.sa.macae.network-application-gateway'
  params: {
    // Required parameters
    name: applicationGatewayName
    // Non-required parameters
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    managedIdentities: {
      userAssignedResourceIds: [userAssignedIdentityApplicationGateway.outputs.resourceId]
    }
    backendAddressPools: [
      {
        name: 'appServiceBackendAddressPool'
        properties: {
          backendAddresses: [
            {
              fqdn: webSite.outputs.defaultHostname
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appServiceBackendHttpsSettings'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          port: 443
          protocol: 'Https'
          requestTimeout: 30
        }
      }
    ]
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    enableHttp2: true
    frontendIPConfigurations: [
      {
        name: 'public'
        properties: {
          publicIPAddress: {
            id: publicIp.outputs.resourceId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port443'
        properties: {
          port: 443
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'subnetConfigs'
        properties: {
          subnet: {
            id: virtualNetwork.outputs.subnetResourceIds[4]
          }
        }
      }
    ]
    sslCertificates: [
      {
        name: 'ssl-certificate'
        properties: {
          keyVaultSecretId: certificateDeploymentScript.outputs.outputs.secretUrl
        }
      }
    ]
    httpListeners: [
      {
        name: 'public443'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGatewayExpectedResourceId}/frontendIPConfigurations/public'
          }
          frontendPort: {
            id: '${applicationGatewayExpectedResourceId}/frontendPorts/port443'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '${applicationGatewayExpectedResourceId}/sslCertificates/ssl-certificate'
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'public443-appServiceBackendAddressPool-appServiceBackendHttpsSettings'
        properties: {
          backendAddressPool: {
            id: '${applicationGatewayExpectedResourceId}/backendAddressPools/appServiceBackendAddressPool'
          }
          backendHttpSettings: {
            id: '${applicationGatewayExpectedResourceId}/backendHttpSettingsCollection/appServiceBackendHttpsSettings'
          }
          httpListener: {
            id: '${applicationGatewayExpectedResourceId}/httpListeners/public443'
          }
          priority: 200
          ruleType: 'Basic'
        }
      }
    ]
  }
}

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

// @description('The resource ID of the resource.')
// output resourceId string = <Resource>.id

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//

@export()
@description('The type for a virtual machine configuration.')
type virtualMachineConfigurationType = {
  @description('Required. The username for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  adminUsername: string

  @description('Required. The password for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  @secure()
  adminPassword: string
}
