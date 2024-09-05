metadata name = 'avm/ptn/azd/container-apps'
metadata description = 'Creates an Azure Container Registry and an Azure Container Apps environment.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. Name of the Container Apps Managed Environment.')
param containerAppsEnvironmentName string

@description('Required. Name of the Azure Container Registry.')
param containerRegistryName string

@description('Optional. Name of the Azure Container Registry Resource Group.')
param containerRegistryResourceGroupName string = ''

@description('Optional. Enable admin user that have push / pull permission to the registry.')
param acrAdminUserEnabled bool = false

@description('Required. Existing Log Analytics Workspace resource ID. Note: This value is not required as per the resource type. However, not providing it currently causes an issue that is tracked [here](https://github.com/Azure/bicep/issues/9990).')
param logAnalyticsWorkspaceResourceId string

@description('Optional. Application Insights connection string.')
@secure()
param appInsightsConnectionString string = ''

@description('Optional. Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.')
@secure()
param daprAIInstrumentationKey string = ''

@description('Optional. SKU settings. Default is "Standard".')
@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param acrSku string = 'Standard'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Zone redundancy setting.')
param zoneRedundant bool = true

@description('Conditional. CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param dockerBridgeCidr string = ''

@description('Conditional. Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param infrastructureSubnetResourceId string = ''

@description('Conditional. Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param internal bool = false

@description('Conditional. IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant.')
param platformReservedCidr string = ''

@description('Conditional. An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param platformReservedDnsIP string = ''

@description('Conditional. Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param workloadProfiles array = []

@description('Optional. Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant.')
param infrastructureResourceGroupName string = take('ME_${containerAppsEnvironmentName}', 63)

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-containerapps.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.7.0' = {
  name: take('containerAppsEnvironment-${deployment().name}-deployment', 64)
  params: {
    name: containerAppsEnvironmentName
    location: location
    tags: tags
    daprAIInstrumentationKey: daprAIInstrumentationKey
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    appInsightsConnectionString: appInsightsConnectionString
    zoneRedundant: zoneRedundant
    workloadProfiles: workloadProfiles
    infrastructureResourceGroupName: infrastructureResourceGroupName
    internal: internal
    infrastructureSubnetId: infrastructureSubnetResourceId
    dockerBridgeCidr: dockerBridgeCidr
    platformReservedCidr: platformReservedCidr
    platformReservedDnsIP: platformReservedDnsIP
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.4.0' = {
  name: take('containerRegistry-${deployment().name}-deployment', 64)
  scope: !empty(containerRegistryResourceGroupName)
    ? resourceGroup(containerRegistryResourceGroupName)
    : resourceGroup()
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: acrAdminUserEnabled
    tags: tags
    acrSku: acrSku
  }
}

@description('The name of the resource group the all resources was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The Default domain of the Managed Environment.')
output defaultDomain string = containerAppsEnvironment.outputs.defaultDomain

@description('The name of the Managed Environment.')
output environmentName string = containerAppsEnvironment.outputs.name

@description('The resource ID of the Managed Environment.')
output environmentResourceId string = containerAppsEnvironment.outputs.resourceId

@description('The reference to the Azure container registry.')
output registryLoginServer string = containerRegistry.outputs.loginServer

@description('The Name of the Azure container registry.')
output registryName string = containerRegistry.outputs.name
