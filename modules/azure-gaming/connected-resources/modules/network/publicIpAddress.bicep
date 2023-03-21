// Copyright (c) 2022 Microsoft Corporation. All rights reserved.
// Azure Public IP Addresses

//                                                    Parameters
// ********************************************************************************************************************
param location string
param resourceGroupName string = resourceGroup().name
param name string = 'pubip${uniqueString(resourceGroup().id)}'
param publicIpAllocationMethod string = 'Static'
param publicIpDns string = 'dns-${uniqueString(resourceGroup().id, name)}'
param publicIpSku object = {
  name: 'Standard'
  tier: 'Regional'
}

@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'
// End Parameters

//                                                    Resources
// ********************************************************************************************************************
resource newPublicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' = if (newOrExisting == 'new') {
  name: name
  sku: publicIpSku
  location: location
  properties: {
    publicIPAllocationMethod: publicIpAllocationMethod
    dnsSettings: {
      domainNameLabel: toLower(publicIpDns)
    }
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' existing = if (newOrExisting != 'new') {
  name: name
  scope: resourceGroup(resourceGroupName)
}
// End Resources

//                                                    Outputs
// ********************************************************************************************************************
output name string = newOrExisting == 'new' ? newPublicIP.name : publicIP.name
output id string = newOrExisting == 'new' ? newPublicIP.id : publicIP.id
output ipAddress string = newOrExisting == 'new' ? newPublicIP.properties.ipAddress : publicIP.properties.ipAddress
// End Outputs
