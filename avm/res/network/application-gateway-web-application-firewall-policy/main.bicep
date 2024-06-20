metadata name = 'Application Gateway Web Application Firewall (WAF) Policies'
metadata description = 'This module deploys an Application Gateway Web Application Firewall (WAF) Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Application Gateway WAF policy.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Describes the managedRules structure.')
param managedRules object

@description('Optional. The custom rules inside the policy.')
param customRules array?

@description('Optional. The PolicySettings for policy.')
param policySettings object?

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-appgwwebappfirewallpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource applicationGatewayWAFPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2022-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    managedRules: managedRules ?? {}
    customRules: customRules
    policySettings: policySettings
  }
}

@description('The name of the application gateway WAF policy.')
output name string = applicationGatewayWAFPolicy.name

@description('The resource ID of the application gateway WAF policy.')
output resourceId string = applicationGatewayWAFPolicy.id

@description('The resource group the application gateway WAF policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = applicationGatewayWAFPolicy.location
