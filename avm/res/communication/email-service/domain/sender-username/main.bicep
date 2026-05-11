metadata name = 'Sender Usernames'
metadata description = 'This module deploys an Sender'

@description('Conditional. The name of the parent email service. Required if the template is used in a standalone deployment.')
param emailServiceName string

@description('Conditional. The name of the parent domain. Required if the template is used in a standalone deployment.')
param domainName string

@description('Required. Name of the sender username resource to create.')
param name string

@description('Required. A sender username to be used when sending emails.')
param username string

@description('Optional. The display name for the senderUsername.')
param displayName string = username

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.comm-emailservice-domsndrusrname.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource emailService 'Microsoft.Communication/emailServices@2025-09-01' existing = {
  name: emailServiceName

  resource domain 'domains@2025-09-01' existing = {
    name: domainName
  }
}

resource senderUsername 'Microsoft.Communication/emailServices/domains/senderUsernames@2025-09-01' = {
  name: name
  parent: emailService::domain
  properties: {
    username: username
    displayName: displayName
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the sender username.')
output resourceId string = senderUsername.id

@description('The name of the sender username.')
output name string = senderUsername.name

@description('The name of the resource group the sender username was created in.')
output resourceGroupName string = resourceGroup().name
