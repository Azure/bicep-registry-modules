metadata name = 'Synapse Workspace Integration Runtimes'
metadata description = 'This module deploys a Synapse Workspace Integration Runtime.'

@description('Conditional. The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@description('Required. The name of the Integration Runtime.')
param name string

@allowed([
  'Managed'
  'SelfHosted'
])
@description('Required. The type of Integration Runtime.')
param type string

@description('Conditional. Integration Runtime type properties. Required if type is "Managed".')
param typeProperties object = {}

resource workspace 'Microsoft.Synapse/workspaces@2021-06-01' existing = {
  name: workspaceName
}

resource integrationRuntime 'Microsoft.Synapse/workspaces/integrationRuntimes@2021-06-01' = {
  name: name
  parent: workspace
  properties: {
    #disable-next-line BCP225 // Error message that type cannot be determined at compile time is redundant as its a property (and may just be misinterpreted by Bicep)
    type: type
    ...(type == 'Managed'
      ? {
          managedVirtualNetwork: {
            referenceName: 'default'
            type: 'ManagedVirtualNetworkReference'
          }
          typeProperties: typeProperties
        }
      : {})
  }
}

@description('The name of the Resource Group the Integration Runtime was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Integration Runtime.')
output name string = integrationRuntime.name

@description('The resource ID of the Integration Runtime.')
output resourceId string = integrationRuntime.id
