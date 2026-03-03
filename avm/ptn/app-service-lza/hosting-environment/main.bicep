targetScope = 'subscription'

metadata name = 'App Service Landing Zone Accelerator'
metadata description = 'This Azure App Service pattern module represents an Azure App Service deployment aligned with the cloud adoption framework'

// ================ //
// Parameters       //
// ================ //

import {
  diagnosticSettingFullType
  diagnosticSettingMetricsOnlyType
  diagnosticSettingLogsOnlyType
} from 'br/public:avm/utl/types/avm-common-types:0.7.0'

@maxLength(10)
@description('Optional. suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>.')
param workloadName string = 'appsvc${take( uniqueString( subscription().id), 4) }'

@description('Optional. Azure region where the resources will be deployed in.')
param location string = deployment().location

@description('Optional. The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environmentName string = 'test'

@description('Optional. Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.')
param deployAseV3 bool = false

@description('Optional. CIDR of the SPOKE vnet i.e. 192.168.0.0/24.')
param vnetSpokeAddressSpace string = '10.240.0.0/20'

@description('Optional. CIDR of the subnet that will hold the app services plan. ATTENTION: ASEv3 needs a /24 network.')
param subnetSpokeAppSvcAddressSpace string = '10.240.0.0/26'

@description('Optional. CIDR of the subnet that will hold the jumpbox.')
param subnetSpokeJumpboxAddressSpace string = '10.240.10.128/26'

@description('Optional. CIDR of the subnet that will hold the private endpoints of the supporting services.')
param subnetSpokePrivateEndpointAddressSpace string = '10.240.11.0/24'

@description('Optional. Default is empty. If given, peering between spoke and and existing hub vnet will be created.')
param vnetHubResourceId string = ''

@description('Optional. Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR.')
param firewallInternalIp string = ''

@description('Optional. The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information.')
param vmSize string = 'Standard_D2s_v4'

// See https://learn.microsoft.com/azure/app-service/overview-hosting-plans for available SKUs and tiers.
@description('Optional. The name of the SKU for the App Service Plan. Determines the tier, size, family and capacity. Defaults to P1V3 to leverage availability zones. EP* SKUs are only for Azure Functions elastic premium plans.')
@metadata({
  example: '''
  // Premium v4
  'P0v4'
  'P1v4'
  'P2v4'
  'P3v4'
  // Premium Memory Optimized v4
  'P1mv4'
  'P3mv4'
  'P4mv4'
  'P5mv4'
  // Isolated v2
  'I1v2'
  'I2v2'
  'I3v2'
  'I4v2'
  'I5v2'
  'I6v2'
  // Functions Elastic Premium
  'EP1'
  'EP2'
  'EP3'
  '''
})
param webAppPlanSku resourceInput<'Microsoft.Web/serverfarms@2025-03-01'>.sku.name = 'P1V3'

@description('Optional. Set to true if you want to deploy the App Service Plan in a zone redundant manner. Default is true.')
param zoneRedundant bool = true

@description('Optional. Kind of server OS of the App Service Plan. Default is "windows".')
@allowed(['windows', 'linux'])
param webAppBaseOs string = 'windows'

@description('Conditional. Required if jumpbox deployed. The username of the admin user of the jumpbox VM.')
param adminUsername string = 'azureuser'

@description('Conditional. Required if jumpbox deployed and not using SSH key. The password of the admin user of the jumpbox VM.')
@secure()
param adminPassword string = ''

@description('Optional. Set to true if you want to intercept all outbound traffic with azure firewall.')
param enableEgressLockdown bool = false

@description('Optional. Set to true if you want to deploy a jumpbox/devops VM.')
param deployJumpHost bool = true

@description('Optional. Type of authentication to use on the Virtual Machine. SSH key is recommended. Default is "password".')
@allowed([
  'sshPublicKey'
  'password'
])
param vmAuthenticationType string = 'password'

@description('Optional. The resource ID of the bastion host. If set, the spoke virtual network will be peered with the hub virtual network and the bastion host will be allowed to connect to the jump box. Default is empty.')
param bastionResourceId string = ''

@description('Optional. Tags to apply to all resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The resource ID of the Log Analytics workspace managed by the Platform Landing Zone. All diagnostic settings will be configured to send logs and metrics to this workspace.')
param logAnalyticsWorkspaceResourceId string

@description('Optional. Set to true if you want to auto-approve the private endpoint connection to the Azure Front Door.')
param autoApproveAfdPrivateEndpoint bool = true

@description('Optional. Default is windows. The OS of the jump box virtual machine to create.')
@allowed(['linux', 'windows', 'none'])
param vmJumpboxOSType string = 'windows'

@description('Optional. Diagnostic Settings for the App Service.')
param appserviceDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the App Service Plan.')
param servicePlanDiagnosticSettings diagnosticSettingMetricsOnlyType[] = []

@description('Optional. Diagnostic Settings for the ASE.')
param aseDiagnosticSettings diagnosticSettingLogsOnlyType[] = []

@description('Optional. Diagnostic Settings for Front Door.')
param frontDoorDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the Application Gateway.')
param appGatewayDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the KeyVault.')
param keyVaultDiagnosticSettings diagnosticSettingFullType[] = []

// ======================== //
// Networking Option        //
// ======================== //

@description('Optional. The networking option to use for ingress. Options: frontDoor (Azure Front Door with WAF), applicationGateway (Application Gateway with WAF), none.')
@allowed(['frontDoor', 'applicationGateway', 'none'])
param networkingOption string = 'frontDoor'

@description('Optional. CIDR of the subnet that will hold the Application Gateway. Required if networkingOption is "applicationGateway".')
param subnetSpokeAppGwAddressSpace string = ''

// ======================== //
// Bring-Your-Own-Service   //
// ======================== //

@description('Optional. The resource ID of an existing App Service Plan. If provided, the module will skip creating a new plan and deploy the web app on the existing one.')
param existingAppServicePlanId string = ''

// ======================== //
// Web App Kind & Container //
// ======================== //

@description('Optional. Kind of web app to deploy. Use "app" for standard web apps, "app,linux" for Linux, "app,linux,container" for Linux containers, etc.')
@allowed([
  'api'
  'app'
  'app,container,windows'
  'app,linux'
  'app,linux,container'
  'functionapp'
  'functionapp,linux'
  'functionapp,linux,container'
  'functionapp,linux,container,azurecontainerapps'
  'functionapp,workflowapp'
  'functionapp,workflowapp,linux'
  'linux,api'
])
param webAppKind string = 'app'

@description('Optional. The container image name for container-based deployments (e.g. "mcr.microsoft.com/appsvc/staticsite:latest").')
param containerImageName string = ''

@description('Optional. The container registry URL for private registries (e.g. "https://myregistry.azurecr.io").')
param containerRegistryUrl string = ''

@description('Optional. The container registry username for private registries.')
param containerRegistryUsername string = ''

@description('Optional. The container registry password for private registries.')
@secure()
param containerRegistryPassword string = ''

// ======================== //
// Custom Resource Names    //
// ======================== //

@description('Optional. Custom resource names. Any property not provided falls back to the naming-module default. Use this to comply with organization-specific naming policies without overriding the naming module entirely.')
param customResourceNames {
  @description('Optional. Custom name for the spoke resource group.')
  resourceGroupName: string?

  @description('Optional. Custom name for the App Service Environment.')
  aseName: string?

  @description('Optional. Custom name for the App Service Plan.')
  appServicePlanName: string?

  @description('Optional. Custom name for the Web App.')
  webAppName: string?

  @description('Optional. Custom name for the App Service managed identity.')
  appSvcManagedIdentityName: string?

  @description('Optional. Custom name for the Front Door profile.')
  frontDoorName: string?

  @description('Optional. Custom name for the Front Door endpoint.')
  frontDoorEndpointName: string?

  @description('Optional. Custom name for the Front Door WAF policy.')
  frontDoorWafName: string?

  @description('Optional. Custom name for the Front Door origin group.')
  frontDoorOriginGroupName: string?

  @description('Optional. Custom name for the DevOps subnet.')
  devOpsSubnetName: string?

  @description('Optional. Custom name for the jumpbox NSG.')
  jumpboxNsgName: string?

  @description('Optional. Custom name for the AFD private-endpoint auto-approver managed identity.')
  afdPeAutoApproverName: string?
}?

// ================ //
// Variables        //
// ================ //

var resourceSuffix = '${workloadName}-${environmentName}-${location}'
var resourceGroupName = customResourceNames.?resourceGroupName ?? 'rg-spoke-${resourceSuffix}'

var names = naming.outputs.names
var resourceNames = {
  aseName: customResourceNames.?aseName ?? names.appServiceEnvironment.nameUnique
  aspName: customResourceNames.?appServicePlanName ?? names.appServicePlan.name
  webApp: customResourceNames.?webAppName ?? names.appService.nameUnique
  appSvcUserAssignedManagedIdentity: customResourceNames.?appSvcManagedIdentityName ?? take('${names.managedIdentity.name}-appSvc', 128)
  frontDoorEndPoint: customResourceNames.?frontDoorEndpointName ?? 'webAppLza-${take(uniqueString(resourceGroupName), 6)}'
  frontDoorWaf: customResourceNames.?frontDoorWafName ?? names.frontDoorFirewallPolicy.name
  frontDoor: customResourceNames.?frontDoorName ?? names.frontDoor.name
  frontDoorOriginGroup: customResourceNames.?frontDoorOriginGroupName ?? '${names.frontDoor.name}-originGroup'
  snetDevOps: customResourceNames.?devOpsSubnetName ?? 'snet-devOps-${names.virtualNetwork.name}-spoke'
  jumpboxNsg: customResourceNames.?jumpboxNsgName ?? take('${names.networkSecurityGroup.name}-jumpbox', 80)
  idAfdApprovePeAutoApprover: customResourceNames.?afdPeAutoApproverName ?? take('${names.managedIdentity.name}-AfdApprovePe', 128)
}

var virtualNetworkLinks = [
  {
    name: networking.outputs.vnetSpokeName
    virtualNetworkResourceId: networking.outputs.vnetSpokeResourceId
    registrationEnabled: false
  }
]

// ================ //
// Resources        //
// ================ //

module spokeResourceGroup 'br/public:avm/res/resources/resource-group:0.4.3' = {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-deployment'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module naming './modules/naming/naming.module.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: 'NamingDeployment'
  params: {
    location: location
    suffix: [
      environmentName
    ]
    uniqueLength: 6
    uniqueSeed: spokeResourceGroup.outputs.resourceId
  }
}

// ======================== //
// Networking               //
// ======================== //

module networking './modules/networking/network.module.bicep' = {
  name: '${uniqueString(deployment().name, location)}-networking'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    naming: naming.outputs.names
    enableTelemetry: enableTelemetry
    deployAseV3: deployAseV3
    enableEgressLockdown: enableEgressLockdown
    vnetSpokeAddressSpace: vnetSpokeAddressSpace
    subnetSpokeAppSvcAddressSpace: subnetSpokeAppSvcAddressSpace
    subnetSpokePrivateEndpointAddressSpace: subnetSpokePrivateEndpointAddressSpace
    subnetSpokeAppGwAddressSpace: subnetSpokeAppGwAddressSpace
    firewallInternalIp: firewallInternalIp
    hubVnetResourceId: vnetHubResourceId
    networkingOption: networkingOption
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceResourceId
    tags: tags
  }
}

// ======================== //
// App Service              //
// ======================== //

module webApp './modules/app-service/app-service.module.bicep' = {
  name: '${uniqueString(deployment().name, location)}-webApp'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    enableTelemetry: enableTelemetry
    deployAseV3: deployAseV3
    aseName: resourceNames.aseName
    appServicePlanName: resourceNames.aspName
    webAppName: resourceNames.webApp
    managedIdentityName: resourceNames.appSvcUserAssignedManagedIdentity
    location: location
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    subnetIdForVnetInjection: networking.outputs.snetAppSvcResourceId
    tags: tags
    webAppBaseOs: webAppBaseOs
    zoneRedundant: zoneRedundant
    subnetPrivateEndpointResourceId: networking.outputs.snetPeResourceId
    virtualNetworkLinks: virtualNetworkLinks
    sku: webAppPlanSku
    kind: webAppKind
    existingAppServicePlanId: existingAppServicePlanId
    containerImageName: containerImageName
    containerRegistryUrl: containerRegistryUrl
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
    appserviceDiagnosticSettings: !empty(appserviceDiagnosticSettings)
      ? appserviceDiagnosticSettings
      : [
          {
            name: 'appservice-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
    servicePlanDiagnosticSettings: !empty(servicePlanDiagnosticSettings)
      ? servicePlanDiagnosticSettings
      : [
          {
            name: 'servicePlan-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
    aseDiagnosticSettings: !empty(aseDiagnosticSettings)
      ? aseDiagnosticSettings
      : [
          {
            name: 'ase-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
          }
        ]
  }
}

// ======================== //
// Front Door               //
// ======================== //

module afd './modules/front-door/front-door.module.bicep' = if (networkingOption == 'frontDoor') {
  name: '${uniqueString(deployment().name, location)}-afd'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    enableTelemetry: enableTelemetry
    afdName: '${resourceNames.frontDoor}${workloadName}'
    endpointName: resourceNames.frontDoorEndPoint
    originGroupName: resourceNames.frontDoorOriginGroup
    origins: [
      {
        hostname: webApp.outputs.webAppHostName
        enabledState: true
        privateLinkOrigin: {
          privateEndpointResourceId: webApp.outputs.webAppResourceId
          privateLinkResourceType: 'sites'
          privateEndpointLocation: webApp.outputs.webAppLocation
        }
      }
    ]
    skuName: 'Premium_AzureFrontDoor'
    diagnosticSettings: !empty(frontDoorDiagnosticSettings)
      ? frontDoorDiagnosticSettings
      : [
          {
            name: 'frontdoor-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                category: 'FrontdoorAccessLog'
              }
              {
                category: 'FrontdoorWebApplicationFirewallLog'
              }
            ]
          }
        ]
    tags: tags
  }
}

module autoApproveAfdPe './modules/front-door/approve-afd-pe.module.bicep' = if (autoApproveAfdPrivateEndpoint && networkingOption == 'frontDoor') {
  name: '${uniqueString(deployment().name, location)}-autoApproveAfdPe'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    enableTelemetry: enableTelemetry
    idAfdPeAutoApproverName: resourceNames.idAfdApprovePeAutoApprover
    tags: tags
  }
  dependsOn: [
    afd
  ]
}

// ======================== //
// Application Gateway      //
// ======================== //

module appGw './modules/networking/application-gateway.module.bicep' = if (networkingOption == 'applicationGateway') {
  name: '${uniqueString(deployment().name, location)}-appGw'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    appGwName: '${names.applicationGateway.name}-${workloadName}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    subnetResourceId: networking.outputs.snetAppGwResourceId
    backendHostName: webApp.outputs.webAppHostName
    diagnosticSettings: !empty(appGatewayDiagnosticSettings)
      ? appGatewayDiagnosticSettings
      : [
          {
            name: 'appgw-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
  }
}

// ======================== //
// Supporting Services      //
// ======================== //

@description('Azure Key Vault used to hold items like TLS certs and application secrets that your workload will need.')
module keyVault './modules/supporting-services/modules/key-vault.bicep' = {
  name: '${uniqueString(deployment().name, location)}-keyVault'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    keyVaultName: names.keyVault.nameUnique
    tags: tags
    enableTelemetry: enableTelemetry
    hubVNetResourceId: vnetHubResourceId
    spokeVNetResourceId: networking.outputs.vnetSpokeResourceId
    spokePrivateEndpointSubnetName: networking.outputs.snetPeName
    appServiceManagedIdentityPrincipalId: webApp.outputs.webAppSystemAssignedPrincipalId
    diagnosticSettings: !empty(keyVaultDiagnosticSettings)
      ? keyVaultDiagnosticSettings
      : [
          {
            name: 'keyvault-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
  }
}

// ======================== //
// Jumpbox VMs              //
// ======================== //

@description('An optional Linux virtual machine deployment to act as a jump box.')
module jumpboxLinuxVM './modules/compute/linux-vm.bicep' = if (deployJumpHost && vmJumpboxOSType == 'linux') {
  name: '${uniqueString(deployment().name, location)}-jumpboxLinuxVM'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    vmName: names.linuxVirtualMachine.name
    bastionResourceId: bastionResourceId
    vmAdminUsername: adminUsername
    vmAdminPassword: adminPassword
    vmSize: vmSize
    vmVnetName: networking.outputs.vnetSpokeName
    vmSubnetName: resourceNames.snetDevOps
    vmSubnetAddressPrefix: subnetSpokeJumpboxAddressSpace
    vmNetworkInterfaceName: names.networkInterface.name
    vmNetworkSecurityGroupName: names.networkSecurityGroup.name
    vmAuthenticationType: vmAuthenticationType
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
  }
}

@description('An optional Windows virtual machine deployment to act as a jump box.')
module jumpboxWindowsVM './modules/compute/windows-vm.bicep' = if (deployJumpHost && vmJumpboxOSType == 'windows') {
  name: '${uniqueString(deployment().name, location)}-jumpboxWindowsVM'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    vmName: names.windowsVirtualMachine.name
    bastionResourceId: bastionResourceId
    vmAdminUsername: adminUsername
    vmAdminPassword: adminPassword
    vmSize: vmSize
    vmVnetName: networking.outputs.vnetSpokeName
    vmSubnetName: 'snet-jumpbox'
    vmSubnetAddressPrefix: subnetSpokeJumpboxAddressSpace
    vmNetworkInterfaceName: names.networkInterface.name
    vmNetworkSecurityGroupName: resourceNames.jumpboxNsg
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
  }
}

// ======================== //
// Telemetry                //
// ======================== //

#disable-next-line no-deployments-resources use-recent-api-versions
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.appsvclza-hostingenvironment.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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
}

// ================ //
// Outputs          //
// ================ //

@description('The name of the Spoke resource group.')
output spokeResourceGroupName string = spokeResourceGroup.outputs.name

@description('The resource ID of the Spoke Virtual Network.')
output spokeVNetResourceId string = networking.outputs.vnetSpokeResourceId

@description('The name of the Spoke Virtual Network.')
output spokeVnetName string = networking.outputs.vnetSpokeName

@description('The resource ID of the key vault.')
output keyVaultResourceId string = keyVault.outputs.keyVaultResourceId

@description('The name of the Azure key vault.')
output keyVaultName string = keyVault.outputs.keyVaultName
