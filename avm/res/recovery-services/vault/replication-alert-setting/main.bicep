metadata name = 'Recovery Services Vault Replication Alert Settings'
metadata description = 'This module deploys a Recovery Services Vault Replication Alert Settings.'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Optional. The name of the replication Alert Setting.')
param name string = 'defaultAlertSetting'

@description('Optional. The custom email address for sending emails.')
param customEmailAddresses string[]?

@description('Optional. The locale for the email notification.')
param locale string = ''

@description('Optional. The value indicating whether to send email to subscription administrator.')
@allowed([
  'DoNotSend'
  'Send'
])
param sendToOwners string = 'Send'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.recsvcs-vault-replalertsetting.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-01-01' existing = {
  name: recoveryVaultName
}

resource replicationAlertSettings 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2022-10-01' = {
  name: name
  parent: recoveryVault
  properties: {
    customEmailAddresses: customEmailAddresses
    locale: locale
    sendToOwners: sendToOwners
  }
}

@description('The name of the replication Alert Setting.')
output name string = replicationAlertSettings.name

@description('The name of the resource group the replication alert setting was created.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the replication alert setting.')
output resourceId string = replicationAlertSettings.id
