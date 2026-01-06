// ========== Managed Identity ========== //
@description('Required. The name of the managed identity.')
param name string

@description('Required. The location of the managed identity.')
param location string

@description('Required. Tags to be applied to the managed identity.')
param tags object

@description('Required. Enable telemetry for the AVM deployment.')
param enableTelemetry bool

module avmManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.2' = {
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
