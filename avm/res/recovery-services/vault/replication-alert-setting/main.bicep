metadata name = 'Recovery Services Vault Replication Alert Settings'
metadata description = 'This module deploys a Recovery Services Vault Replication Alert Settings.'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Optional. The name of the replication Alert Setting.')
param name string = 'defaultAlertSetting'

@description('Optional. Comma separated list of custom email address for sending alert emails.')
param customEmailAddresses array = []

@description('Optional. The locale for the email notification.')
param locale string = ''

@description('Optional. The value indicating whether to send email to subscription administrator.')
@allowed([
  'DoNotSend'
  'Send'
])
param sendToOwners string = 'Send'

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2023-01-01' existing = {
  name: recoveryVaultName
}

resource replicationAlertSettings 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2022-10-01' = {
  name: name
  parent: recoveryVault
  properties: {
    customEmailAddresses: !empty(customEmailAddresses) ? customEmailAddresses : null
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
