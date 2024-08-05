resource resDevCenterProjectRef 'Microsoft.DevCenter/projects@2024-02-01' existing = {
  name: 'dep-john-dcp-mdpmin'
}

resource resManagedDevOpsPools 'Microsoft.DevOpsInfrastructure/pools@2024-04-04-preview' = {
  name: 'mdpjloweu'
  location: 'westeurope'
  properties: {
    agentProfile: {
      kind: 'Stateless'
    }
    devCenterProjectResourceId: resDevCenterProjectRef.id
    fabricProfile: {
      networkProfile: null
      // osProfile: {
      //   logonType: 'Service'
      //   secretsManagementSettings: {
      //     keyExportable: false
      //     observedCertificates: []
      //   }
      // }
      osProfile: null
      storageProfile: null
      // storageProfile: {
      //   dataDisks: null
      //   osDiskStorageAccountType: null
      // }
      sku: {
        name: 'Standard_DS2_v2'
      }
      kind: 'Vmss'
      images: [
        {
          wellKnownImageName: 'windows-2022/latest'
        }
      ]
    }
    maximumConcurrency: 1
    organizationProfile: {
      kind: 'AzureDevOps'
      organizations: [
        {
          url: 'https://dev.azure.com/john-lokerse'
        }
      ]
    }
  }
}
