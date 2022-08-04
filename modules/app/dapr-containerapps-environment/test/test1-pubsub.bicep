/*
This test is a representation of the pub/sub sample from the DAPR GitHub Quickstarts repo
https://github.com/dapr/quickstarts/tree/master/pub_sub/javascript/sdk

It deploys 2 container apps, leveraging a Service Bus Topic for messages;

Publisher query: ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'pubsub-sb2-publisher-checkout' | project TimeGenerated, ContainerName_s, Stream_s, Log_s | order by TimeGenerated desc 
Subscriber query: ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'pubsub-sb2-subscriber-orders' | project TimeGenerated, ContainerName_s, Stream_s, Log_s | order by TimeGenerated desc 
*/

param location string

var nameseed = 'pubsub-sb2'

var rawKeyVaultName='kv-${nameseed}-${uniqueString(resourceGroup().id, nameseed)}'
var keyVaultName = length(rawKeyVaultName) > 24 ? substring(rawKeyVaultName, 0, 24) : rawKeyVaultName

module test1Env '../main.bicep' = {
  name: 'test1-public-vnet-servicebus'
  params: {
    location: location
    nameseed: nameseed
    applicationEntityName: 'orders'
    daprComponentName: 'orderpubsub'
    daprComponentType: 'pubsub.azure.servicebus'
  }
}

var pubSubAppEnvVars = [ {
  name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
  value: test1Env.outputs.appInsightsInstrumentationKey
}
{
  name: 'AZURE_KEY_VAULT_ENDPOINT'
  value: keyvault.properties.vaultUri
}
]

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enableRbacAuthorization: true
    enableSoftDelete: false //opt out is deprecated Feb 2025
  }
}

module keyvaultRbac 'keyvaultRbac.bicep' = {
  name: 'kv-pubsub-sb1-rbac'
  params: {
    keyVaultName: keyvault.name
    servicePrincipalId: appSubscriber.outputs.userAssignedIdPrincipalId
  }
}

module appSubscriber 'containerApp.bicep' = {
  name: 'subscriber'
  params: {
    location: location
    containerAppEnvName: test1Env.outputs.containerAppEnvironmentName
    containerAppName: '${nameseed}-subscriber-orders'
    containerImage: 'ghcr.io/gordonby/dapr-sample-pubsub-orders:0.1'
    environmentVariables: pubSubAppEnvVars
    targetPort: 5001
  }
}

module appPublisher 'containerApp.bicep' = {
  name: 'publisher'
  params: {
    location: location
    containerAppEnvName: test1Env.outputs.containerAppEnvironmentName
    containerAppName: '${nameseed}-publisher-checkout'
    containerImage: 'ghcr.io/gordonby/dapr-sample-pubsub-checkout:0.1'
    environmentVariables: pubSubAppEnvVars
    enableIngress: false
  }
}
