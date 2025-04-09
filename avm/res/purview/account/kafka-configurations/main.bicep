metadata name = 'Purview Account Kafka Configuration'
metadata description = 'This module deploys a Purview Account Kafka Configuration.'

@description('Required. The name of the Purview account.')
param accountName string

@description('Required. The name of the Kafka configuration.')
param name string

@description('Optional. The Kafka configuration properties.')
param kakfaConfiguration kafkaConfigurationType

resource account 'Microsoft.Purview/accounts@2024-04-01-preview' existing = {
  name: accountName
}

resource kafkaConfiguration 'Microsoft.Purview/accounts/kafkaConfigurations@2024-04-01-preview' = {
  parent: account
  name: name
  properties: {
    consumerGroup: kakfaConfiguration.?consumerGroup
    credentials: {
      identityId: 'string'
      type: 'string'
    }
    eventHubPartitionId: kakfaConfiguration.?eventHubPartitionId
    eventHubResourceId: kakfaConfiguration.?eventHubResourceId
    eventHubType: kakfaConfiguration.?eventHubType
    eventStreamingState: kakfaConfiguration.?eventStreamingState
    eventStreamingType: kakfaConfiguration.?eventStreamingType
  }
}

@export()
@description('Optional. The type for Kafka configuration properties.')
type kafkaConfigurationType = {
  @description('Required. The consumer group for the hook event hub.')
  consumerGroup: string

  @description('Required. The credentials for the event streaming service.')
  credentials: {
    @description('Required. The identity ID of the Kafka configuration.')
    identityId: string

    @description('Required. The type of the credentials for the Kafka configuration.')
    type: string
  }

  @description('Optional. The partition ID for the notification event hub. If not set, all partitions will be used.')
  eventHubPartitionId: string?

  @description('Required. The event hub resource ID of the Kafka configuration.')
  eventHubResourceId: string

  @description('Required. The event hub type.')
  eventHubType: string

  @description('Required. The event streaming state.')
  eventStreamingState: string

  @description('Required. The event streaming type.')
  eventStreamingType: string
}?
