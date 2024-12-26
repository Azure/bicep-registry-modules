targetScope = 'subscription'

metadata name = 'Container Apps Landing Zone Accelerator'
metadata description = 'This Azure Container Apps pattern module represents an Azure Container Apps deployment aligned with the cloud adoption framework'
metadata owner = 'Azure/avm-ptn-acalza-hostingenvironment-module-contributors-bicep'

// ------------------
//    PARAMETERS
// ------------------
@description('Optional. The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string = 'aca-lza'

@description('Optional. The resource ID of the hub virtual network. If set, the spoke virtual network will be peered with the hub virtual network. Default is empty.')
param hubVirtualNetworkResourceId string = ''

@description('Optional. The resource ID of the bastion host. If set, the spoke virtual network will be peered with the hub virtual network and the bastion host will be allowed to connect to the jump box. Default is empty.')
param bastionResourceId string = ''

@description('Optional. If set, the spoke virtual network will be peered with the hub virtual network and egres traffic will be routed through the network appliance. Default is empty.')
param networkApplianceIpAddress string = ''

@description('Optional. Tags related to the Azure Container Apps deployment. Default is empty.')
param tags object = {}

@description('Optional. The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long. Default is "test".')
@maxLength(8)
param environment string = 'test'

@description('Optional. The location of the Azure Container Apps deployment. Default is the location of the deployment location.')
param location string = deployment().location

// Jumpbox Virtual Machine
@description('Required. The size of the virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information.')
param vmSize string

@description('Optional. The storage account type to use for the jump box. Defaults to `Standard_LRS`.')
param storageAccountType string = 'Standard_LRS'

@description('Required. The password to use for the virtual machine.')
@secure()
param vmAdminPassword string

@description('Optional. The SSH public key to use for the virtual machine. If not provided one will be generated. Default is empty.')
@secure()
param vmLinuxSshAuthorizedKey string = ''

@description('Optional. Type of authentication to use on the Virtual Machine. SSH key is recommended. Default is "password".')
@allowed([
  'sshPublicKey'
  'password'
])
param vmAuthenticationType string = 'password'

@allowed(['linux', 'windows', 'none'])
@description('Optional. The operating system type of the virtual machine. Default is "none" which results in no VM deployment. Default is "none".')
param vmJumpboxOSType string = 'none'

@description('Required. CIDR to use for the virtual machine subnet.')
param vmJumpBoxSubnetAddressPrefix string

@description('Optional. The name of the resource group to create the resources in. If set, it overrides the name generated by the template. Default is empty.')
param spokeResourceGroupName string = ''

@description('Required. CIDR of the Spoke Virtual Network.')
param spokeVNetAddressPrefixes array

@description('Required. CIDR of the Spoke Infrastructure Subnet.')
param spokeInfraSubnetAddressPrefix string

@description('Required. CIDR of the Spoke Private Endpoints Subnet.')
param spokePrivateEndpointsSubnetAddressPrefix string

@description('Required. CIDR of the Spoke Application Gateway Subnet.')
param spokeApplicationGatewaySubnetAddressPrefix string

@description('Required. Enable or disable the createion of Application Insights.')
param enableApplicationInsights bool

@description('Required. Enable or disable Dapr Application Instrumentation Key used for Dapr telemetry. If Application Insights is not enabled, this parameter is ignored.')
param enableDaprInstrumentation bool

@description('Optional. The FQDN of the Application Gateway. Required and must match if the TLS Certificate is provided. Default is empty.')
param applicationGatewayFqdn string = ''

@description('Optional. The base64 encoded certificate to use for Application Gateway certificate. When not provided a self signed one will be generated, the certificate will be added to the Key Vault and assigned to the Application Gateway listener.')
@secure()
param base64Certificate string = ''

@description('Required. The name of the certificate key to use for Application Gateway certificate.')
param applicationGatewayCertificateKeyName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Default value is true. If true, any resources that support AZ will be deployed in all three AZ. However if the selected region is not supporting AZ, this parameter needs to be set to false. Default is true.')
param deployZoneRedundantResources bool = true

// @description('Optional. If true, Azure Policies will be deployed. Default value is true.')
// param deployAzurePolicies bool = true

@description('Optional. Specify the way container apps is going to be exposed. Options are applicationGateway or frontDoor. Default is "applicationGateway".')
@allowed([
  'applicationGateway'
  'frontDoor'
])
param exposeContainerAppsWith string = 'applicationGateway'

@description('Optional. Deploy sample application to the container apps environment. Default is false.')
param deploySampleApplication bool = false

@description('Optional. DDoS protection mode. see https://learn.microsoft.com/azure/ddos-protection/ddos-protection-sku-comparison#skus. Default is "false".')
param enableDdosProtection bool = false

// ------------------
// VARIABLES
// ------------------
var namingRules = json(loadTextContent('modules/naming/naming-rules.jsonc'))
var rgSpokeName = !empty(spokeResourceGroupName)
  ? spokeResourceGroupName
  : '${namingRules.resourceTypeAbbreviations.resourceGroup}-${workloadName}-spoke-${environment}-${namingRules.regionAbbreviations[toLower(location)]}'

// ------------------
// RESOURCES
// ------------------
@description('User-configured naming rules')
module naming 'modules/naming/naming.module.bicep' = {
  scope: resourceGroup(rgSpokeName)
  name: take('sharedNamingDeployment-${deployment().name}', 64)
  params: {
    uniqueId: uniqueString(spoke.outputs.spokeResourceGroupName)
    environment: environment
    workloadName: workloadName
    location: location
  }
}

module spoke 'modules/spoke/deploy.spoke.bicep' = {
  name: take('spoke-${deployment().name}-deployment', 64)
  scope: subscription()
  params: {
    spokeResourceGroupName: rgSpokeName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    environment: environment
    //subscriptionId: subscriptionId
    workloadName: workloadName
    hubVNetId: hubVirtualNetworkResourceId
    bastionResourceId: bastionResourceId
    spokeApplicationGatewaySubnetAddressPrefix: spokeApplicationGatewaySubnetAddressPrefix
    spokeInfraSubnetAddressPrefix: spokeInfraSubnetAddressPrefix
    spokePrivateEndpointsSubnetAddressPrefix: spokePrivateEndpointsSubnetAddressPrefix
    spokeVNetAddressPrefixes: spokeVNetAddressPrefixes
    networkApplianceIpAddress: networkApplianceIpAddress
    vmSize: vmSize
    vmZone: (deployZoneRedundantResources) ? 2 : 0
    storageAccountType: storageAccountType
    vmAdminPassword: vmAdminPassword
    vmLinuxSshAuthorizedKey: vmLinuxSshAuthorizedKey
    vmJumpboxOSType: vmJumpboxOSType
    vmJumpBoxSubnetAddressPrefix: vmJumpBoxSubnetAddressPrefix
    vmAuthenticationType: vmAuthenticationType
  }
}

// Policy assignement requires a management group scope
// @description('Assign built-in and custom (container-apps related) policies to the spoke subscription.')
// module policiesDeployment 'modules/policy/policies-assignement.bicep' = if (deployAzurePolicies) {
//   name: take('policyAssignments-${deployment().name}', 64)
//   params: {
//     location: location
//     spokeResourceGroupName: spoke.outputs.spokeResourceGroupName
//     containerRegistryName: naming.outputs.resourcesNames.containerRegistry
//   }
// }

module supportingServices 'modules/supporting-services/deploy.supporting-services.bicep' = {
  name: take('supportingServices-${deployment().name}-deployment', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    spokePrivateEndpointSubnetName: spoke.outputs.spokePrivateEndpointsSubnetName
    environment: environment
    workloadName: workloadName
    spokeVNetId: spoke.outputs.spokeVNetId
    hubVNetId: hubVirtualNetworkResourceId
    logAnalyticsWorkspaceId: spoke.outputs.logAnalyticsWorkspaceId
  }
}

module containerAppsEnvironment 'modules/container-apps-environment/deploy.aca-environment.bicep' = {
  name: take('containerAppsEnvironment-${deployment().name}-deployment', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    environment: environment
    workloadName: workloadName
    hubVNetId: hubVirtualNetworkResourceId
    spokeVNetName: spoke.outputs.spokeVNetName
    spokeInfraSubnetName: spoke.outputs.spokeInfraSubnetName
    enableApplicationInsights: enableApplicationInsights
    enableDaprInstrumentation: enableDaprInstrumentation
    containerRegistryUserAssignedIdentityId: supportingServices.outputs.containerRegistryUserAssignedIdentityId
    logAnalyticsWorkspaceId: spoke.outputs.logAnalyticsWorkspaceId
  }
}

module sampleApplication 'modules/sample-application/deploy.sample-application.bicep' = if (deploySampleApplication) {
  name: take('sampleApplication-${deployment().name}-deployment', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    containerAppsEnvironmentId: containerAppsEnvironment.outputs.containerAppsEnvironmentId
    workloadProfileName: containerAppsEnvironment.outputs.workloadProfileNames[0]
    containerRegistryUserAssignedIdentityId: supportingServices.outputs.containerRegistryUserAssignedIdentityId
  }
}

module applicationGateway 'modules/application-gateway/deploy.app-gateway.bicep' = if (exposeContainerAppsWith == 'applicationGateway') {
  name: take('applicationGateway-${deployment().name}-deployment', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    environment: environment
    workloadName: workloadName
    applicationGatewayCertificateKeyName: applicationGatewayCertificateKeyName
    applicationGatewayFqdn: applicationGatewayFqdn
    applicationGatewayPrimaryBackendEndFqdn: (deploySampleApplication)
      ? sampleApplication.outputs.helloWorldAppFqdn
      : ''
    applicationGatewaySubnetId: spoke.outputs.spokeApplicationGatewaySubnetId
    base64Certificate: base64Certificate
    keyVaultId: supportingServices.outputs.keyVaultResourceId
    keyVaultSubnetResourceId: spoke.outputs.spokePrivateEndpointsSubnetResourceId
    deployZoneRedundantResources: deployZoneRedundantResources
    enableDdosProtection: enableDdosProtection
    applicationGatewayLogAnalyticsId: spoke.outputs.logAnalyticsWorkspaceId
  }
}

module frontDoor 'modules/front-door/deploy.front-door.bicep' = if (exposeContainerAppsWith == 'frontDoor') {
  name: take('frontDoor-${deployment().name}-deployment', 64)
  scope: resourceGroup(rgSpokeName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    environment: environment
    workloadName: workloadName
    containerAppsEnvironmentId: containerAppsEnvironment.outputs.containerAppsEnvironmentId
    frontDoorOriginHostName: (deploySampleApplication) ? sampleApplication.outputs.helloWorldAppFqdn : ''
    privateLinkSubnetId: spoke.outputs.spokeInfraSubnetId
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.acalza-hostingenvironment.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
output spokeResourceGroupName string = spoke.outputs.spokeResourceGroupName

@description('The  resource ID of the Spoke Virtual Network.')
output spokeVNetResourceId string = spoke.outputs.spokeVNetId

@description('The name of the Spoke Virtual Network.')
output spokeVnetName string = spoke.outputs.spokeVNetName

@description('The resource ID of the Spoke Infrastructure Subnet.')
output spokeInfraSubnetResourceId string = spoke.outputs.spokeInfraSubnetId

@description('The name of the Spoke Infrastructure Subnet.')
output spokeInfraSubnetName string = spoke.outputs.spokeInfraSubnetName

@description('The name of the Spoke Private Endpoints Subnet.')
output spokePrivateEndpointsSubnetName string = spoke.outputs.spokePrivateEndpointsSubnetName

@description('The resource ID of the Spoke Application Gateway Subnet. If "spokeApplicationGatewaySubnetAddressPrefix" is empty, the subnet will not be created and the value returned is empty.')
output spokeApplicationGatewaySubnetResourceId string = spoke.outputs.spokeApplicationGatewaySubnetId

@description('The name of the Spoke Application Gateway Subnet.  If "spokeApplicationGatewaySubnetAddressPrefix" is empty, the subnet will not be created and the value returned is empty.')
output spokeApplicationGatewaySubnetName string = spoke.outputs.spokeApplicationGatewaySubnetName

@description('The resource ID of the Log Analytics workspace created in the spoke vnet.')
output logAnalyticsWorkspaceResourceId string = spoke.outputs.logAnalyticsWorkspaceId

@description('The name of the jump box virtual machine.')
output vmJumpBoxName string = spoke.outputs.vmJumpBoxName

// Supporting Services
@description('The resource ID of the container registry.')
output containerRegistryResourceId string = supportingServices.outputs.containerRegistryId

@description('The name of the container registry.')
output containerRegistryName string = supportingServices.outputs.containerRegistryName

@description('The name of the container registry login server.')
output containerRegistryLoginServer string = supportingServices.outputs.containerRegistryLoginServer

@description('The resource ID of the user assigned managed identity for the container registry to be able to pull images from it.')
output containerRegistryUserAssignedIdentityResourceId string = supportingServices.outputs.containerRegistryUserAssignedIdentityId

@description('The resource ID of the key vault.')
output keyVaultResourceId string = supportingServices.outputs.keyVaultResourceId

@description('The name of the Azure key vault.')
output keyVaultName string = supportingServices.outputs.keyVaultName

// Application Gateway
@description('The resource ID of the Azure Application Gateway.')
output applicationGatewayResourceId string = (exposeContainerAppsWith == 'applicationGateway')
  ? applicationGateway.outputs.applicationGatewayResourceId
  : ''

@description('The FQDN of the Azure Application Gateway.')
output applicationGatewayFqdn string = (exposeContainerAppsWith == 'applicationGateway')
  ? applicationGateway.outputs.applicationGatewayFqdn
  : ''

@description('The public IP address of the Azure Application Gateway.')
output applicationGatewayPublicIp string = (exposeContainerAppsWith == 'applicationGateway')
  ? applicationGateway.outputs.applicationGatewayPublicIp
  : ''

// Container Apps Environment
@description('The resource ID of the container apps environment.')
output containerAppsEnvironmentResourceId string = containerAppsEnvironment.outputs.containerAppsEnvironmentId

@description('The name of the container apps environment.')
output containerAppsEnvironmentName string = containerAppsEnvironment.outputs.containerAppsEnvironmentName

@description('The name of application Insights instance.')
output applicationInsightsName string = (enableApplicationInsights)
  ? containerAppsEnvironment.outputs.applicationInsightsName
  : ''
