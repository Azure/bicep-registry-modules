// ========== Managed Identity ========== //
@description('The name of the managed identity')
param name string

@description('The location of the managed identity')
param location string

@description('Tags to be applied to the managed identity')
param tags object

@description('Enable telemetry for the AVM deployment')
param enableTelemetry bool

module avmManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: name
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

output resourceId string = avmManagedIdentity.outputs.resourceId
output principalId string = avmManagedIdentity.outputs.principalId
