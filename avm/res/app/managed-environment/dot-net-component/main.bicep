metadata name = 'App ManagedEnvironments DotNetComponents'
metadata description = 'This module deploys an App Managed Environment .NET Component.'

@description('Required. Name of the .NET Component.')
param name string

@description('Conditional. The name of the parent app managed environment. Required if the template is used in a standalone deployment.')
param managedEnvironmentName string

@description('Required. Type of the .NET Component.')
param componentType string

@description('Optional. List of .NET Components configuration properties.')
param configurations dotNetComponentConfigurationPropertyType[]?

@description('Optional. List of .NET Components that are bound to the .NET component.')
param serviceBinds dotNetComponentServiceBindType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.app-managedenvironment-dotnetcomp.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource managedEnvironment 'Microsoft.App/managedEnvironments@2025-10-02-preview' existing = {
  name: managedEnvironmentName
}

resource dotNetComponent 'Microsoft.App/managedEnvironments/dotNetComponents@2025-10-02-preview' = {
  name: name
  parent: managedEnvironment
  properties: {
    componentType: componentType
    configurations: configurations
    serviceBinds: serviceBinds
  }
}

@description('The name of the .NET Component.')
output name string = dotNetComponent.name

@description('The resource ID of the .NET Component.')
output resourceId string = dotNetComponent.id

@description('The resource group the .NET Component was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a .NET Component configuration property.')
type dotNetComponentConfigurationPropertyType = {
  @description('Optional. The name of the property.')
  propertyName: string?

  @description('Optional. The value of the property.')
  value: string?
}

@export()
@description('The type for a .NET Component service bind.')
type dotNetComponentServiceBindType = {
  @description('Optional. Name of the service bind.')
  name: string?

  @description('Optional. Resource id of the target service.')
  serviceId: string?
}
