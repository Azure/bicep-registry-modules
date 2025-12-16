metadata name = 'Integration Account Agreements'
metadata description = 'This module deploys an Integration Account Agreement.'

// =============== //
//   Parameters    //
// =============== //

@description('Required. The Name of the agreement resource.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent integration account. Required if the template is used in a standalone deployment.')
param integrationAccountName string

@description('Required. The agreement type.')
param agreementType ('AS2' | 'Edifact' | 'NotSpecified' | 'X12')

@description('Required. The business identity of the guest partner.')
param guestIdentity businessIdentityType

@description('Required. The integration account partner that is set as guest partner for this agreement.')
param guestPartner string

@description('Required. The business identity of the host partner.')
param hostIdentity businessIdentityType

@description('Required. The integration account partner that is set as host partner for this agreement.')
param hostPartner string

@description('Required. The agreement content.')
param content object

@description('Optional. The agreement metadata.')
param metadata object?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Logic/integrationAccounts/agreements@2019-05-01'>.tags?

resource integrationAccount 'Microsoft.Logic/integrationAccounts@2019-05-01' existing = {
  name: integrationAccountName
}

resource agreement 'Microsoft.Logic/integrationAccounts/agreements@2019-05-01' = {
  name: name
  parent: integrationAccount
  location: location
  properties: {
    agreementType: agreementType
    content: content
    guestIdentity: guestIdentity
    guestPartner: guestPartner
    hostIdentity: hostIdentity
    hostPartner: hostPartner
    metadata: metadata
  }
  tags: tags
}

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a business identity.')
type businessIdentityType = {
  @description('Required. The business identity qualifier e.g. as2identity, ZZ, ZZZ, 31, 32.')
  qualifier: string
  @description('Required. The user defined business identity value.')
  value: string
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the integration account agreement.')
output resourceId string = agreement.id

@description('The name of the integration account agreement.')
output name string = agreement.name

@description('The resource group the integration account agreement was deployed into.')
output resourceGroupName string = resourceGroup().name
