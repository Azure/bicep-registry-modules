targetScope = 'subscription'

//////////////  Parameters ////////////// 

@description('The Azure Region alias (Primary/eastus2 or Secondary/centralus)')
@allowed([
  'Primary'
  'Secondary'
])
param parLocation string 

@description('Short name of the application.')
param parApplicationShortName string = 'eventing'

@description('Name of the environment that is being deployed to.')
param parEnvironmentName string = 'dev'

@description('Required. Prefix to be used on the Event Grid Domain deployment for naming convention')
param parEventGridDomainNameSubPrefix string = 'evgds'

@description('Virtual network subscription ID')
param parEvgdSubID string  = '9af59c0f-7661-48ec-ac0d-fc61688f01ea'

@description('Virtual network resource group name')
param parEvgdRG string = 'test-appGW'

//////////////  Variables ////////////// 

var varRegionSuffix = 'itn'
var varEventStorageAccountName = 'testfabmas' //(toLower('stevntservice${parEnvironmentName}${varRegionSuffix}001'))
var varEventStorageAccountQueue = 'eventing-audit-queue'
var varEventStorageAccountContainer = 'eventing-audit-container'
var varEventGridDomainName = (toLower('evgd-${parApplicationShortName}-${parEnvironmentName}-${varRegionSuffix}'))
var varEventGridDomainSubName = (toLower('${parEventGridDomainNameSubPrefix}-${parApplicationShortName}-${parEnvironmentName}-${varRegionSuffix}'))
var varLocation = 'italynorth'

var varDeliveryWithResourceIdentity = {
  endpointType: 'StorageQueue'
  destination: {
    endpointType: 'StorageQueue'
    properties: {
      resourceId: EventingStorageAccount.id
      queueMessageTimeToLiveInSeconds: 500000
      queueName: varEventStorageAccountQueue
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

var varDeadLetterWithResourceIdentity = {
  deadLetterDestination: {
    endpointType: 'StorageBlob'
    properties: {
      resourceId: EventingStorageAccount.id
      blobContainerName: varEventStorageAccountContainer
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

var varEventSubscriptionFilter = {
  advancedFilters: null
  enableAdvancedFilteringOnArrays: false
  includedEventTypes: null
  isSubjectCaseSensitive: false
  subjectBeginsWith: ''
  subjectEndsWith: ''
}

var varRetryPolicy = {
  eventTimeToLiveInMinutes: 600
  maxDeliveryAttempts: 10
}

//////////////  Existing Resources ////////////// 

resource EventingStorageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: varEventStorageAccountName
  scope: resourceGroup(parEvgdSubID, parEvgdRG)
}

//////////////  Event Grid Domain Module ////////////// 

module eventGridDomain '../../../main.bicep'  = { 
  name: 'eventGridDomain'
  scope: resourceGroup(parEvgdSubID, parEvgdRG)
  params: {
    name: varEventGridDomainName
    location: varLocation
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: 'Enabled'
    minimumTlsVersionAllowed: '1.2'
    eventSubscriptions: [
      {
        name: varEventGridDomainSubName
        deliveryWithResourceIdentity: varDeliveryWithResourceIdentity
        deadLetterWithResourceIdentity: varDeadLetterWithResourceIdentity
        eventDeliverySchema: 'CloudEventSchemaV1_0'
        filter: varEventSubscriptionFilter
        retryPolicy: varRetryPolicy
      }
    ]
  }
}
