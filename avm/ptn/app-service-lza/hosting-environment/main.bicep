targetScope = 'subscription'

metadata name = 'App Service Landing Zone Accelerator'
metadata description = 'This Azure App Service pattern module represents an Azure App Service deployment aligned with the cloud adoption framework'
// ================ //
// Parameters       //
// ================ //
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

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

@description('Optional. Defines the name, tier, size, family and capacity of the App Service Plan. EP* is only for functions.')
@allowed([
  'S1'
  'S2'
  'S3'
  'P1V3'
  'P2V3'
  'P3V3'
  'EP1'
  'EP2'
  'EP3'
  'ASE_I1V2'
  'ASE_I2V2'
  'ASE_I3V2'
])
param webAppPlanSku string = 'P1V3'

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

@description('Optional. Set to true if you want to auto-approve the private endpoint connection to the Azure Front Door.')
param autoApproveAfdPrivateEndpoint bool = true

@description('Optional. Default is windows. The OS of the jump box virtual machine to create.')
@allowed(['linux', 'windows', 'none'])
param vmJumpboxOSType string = 'windows'

@description('Optional. Diagnostic Settings for the App Service Plan.')
param appserviceDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the App Service Plan.')
param servicePlanDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the ASE.')
param aseDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for Front Door.')
param frontDoorDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the KeyVault.')
param keyVaultDiagnosticSettings diagnosticSettingFullType[] = []

var resourceSuffix = '${workloadName}-${environmentName}-${location}'
var resourceGroupName = 'rg-spoke-${resourceSuffix}'

module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
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
    uniqueSeed: resourceGroup.outputs.resourceId
  }
}

module spoke './modules/spoke/deploy.spoke.bicep' = {
  name: '${uniqueString(deployment().name, location)}-spokedeployment'
  params: {
    naming: naming.outputs.names
    workload: workloadName
    enableTelemetry: enableTelemetry
    resourceGroupName: resourceGroup.outputs.name
    location: location
    vnetSpokeAddressSpace: vnetSpokeAddressSpace
    subnetSpokeAppSvcAddressSpace: subnetSpokeAppSvcAddressSpace
    subnetSpokePrivateEndpointAddressSpace: subnetSpokePrivateEndpointAddressSpace
    subnetSpokeJumpboxAddressSpace: subnetSpokeJumpboxAddressSpace
    vnetHubResourceId: vnetHubResourceId
    firewallInternalIp: firewallInternalIp
    deployAseV3: deployAseV3
    webAppPlanSku: webAppPlanSku
    zoneRedundant: zoneRedundant
    webAppBaseOs: webAppBaseOs
    adminUsername: adminUsername
    adminPassword: adminPassword
    enableEgressLockdown: enableEgressLockdown
    autoApproveAfdPrivateEndpoint: autoApproveAfdPrivateEndpoint
    deployJumpHost: deployJumpHost
    vmJumpboxOSType: vmJumpboxOSType
    vmAdminUsername: adminUsername
    vmAdminPassword: adminPassword
    vmSize: vmSize
    bastionResourceId: bastionResourceId
    vmAuthenticationType: vmAuthenticationType
    appserviceDiagnosticSettings: appserviceDiagnosticSettings
    servicePlanDiagnosticSettings: servicePlanDiagnosticSettings
    aseDiagnosticSettings: aseDiagnosticSettings
    frontDoorDiagnosticSettings: frontDoorDiagnosticSettings
    tags: tags
  }
}

module supportingServices './modules/supporting-services/deploy.supporting-services.bicep' = {
  name: '${uniqueString(deployment().name, location)}-supportingServicesDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    enableTelemetry: enableTelemetry
    naming: naming.outputs.names
    location: location
    spokeVNetResourceId: spoke.outputs.vnetSpokeResourceId
    spokePrivateEndpointSubnetName: spoke.outputs.spokePrivateEndpointSubnetName
    appServiceManagedIdentityPrincipalId: spoke.outputs.appServiceManagedIdentityPrincipalId
    logAnalyticsWorkspaceResourceId: spoke.outputs.logAnalyticsWorkspaceResourceId
    keyVaultDiagnosticSettings: keyVaultDiagnosticSettings
    hubVNetResourceId: vnetHubResourceId
    tags: tags
  }
}

#disable-next-line no-deployments-resources
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

// ------------------
// OUTPUTS
// ------------------

// Spoke
@description('The name of the Spoke resource group.')
output spokeResourceGroupName string = resourceGroup.outputs.name

@description('The  resource ID of the Spoke Virtual Network.')
output spokeVNetResourceId string = spoke.outputs.vnetSpokeResourceId

@description('The name of the Spoke Virtual Network.')
output spokeVnetName string = spoke.outputs.vnetSpokeName

// Supporting Services

@description('The resource ID of the key vault.')
output keyVaultResourceId string = supportingServices.outputs.keyVaultResourceId

@description('The name of the Azure key vault.')
output keyVaultName string = supportingServices.outputs.keyVaultName
