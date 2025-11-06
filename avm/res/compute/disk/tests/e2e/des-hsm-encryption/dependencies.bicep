@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param diskEncryptionSetName string

var uamiResourceID = '/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourcegroups/rsg-mhsm-temp-testing/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-avmh-msi-cdhsm'
var hsmKeyUrl = 'https://mhsm-perm-avm-core-001.managedhsm.azure.net/keys/rsa-hsm-4096-key-des/bd7b9c8cdbeb0e1ca8e39201b9e94f73'

resource diskEncryptionSet 'Microsoft.Compute/diskEncryptionSets@2024-03-02' = {
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uamiResourceID}': {}
    }
  }
  location: location
  name: diskEncryptionSetName
  properties: {
    activeKey: {
      keyUrl: hsmKeyUrl
    }
    encryptionType: 'EncryptionAtRestWithPlatformAndCustomerKeys'
  }
}

@description('The resource ID of the created Key Vault.')
output diskEncryptionSetResourceId string = diskEncryptionSet.id
