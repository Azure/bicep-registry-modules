module natGw 'br/public:avm/res/network/nat-gateway:1.2.1' = {
  name: 'natgw'
  params: {
    name: 'natgw'
    zone: 3
    location: 'eastus2'
    publicIPAddressObjects: [
      {
        name: ''
        location: ''
        publicIPAddressVersion: ''
        zones: [1, 2, 3]
        publicIPAllocationMethod: 'Static'
        skuName: ''
        skuTier: ''
        tags: ''
        enableTelemetry: ''
        idleTimeoutInMinutes: ''
      }
    ]
  }
}

/*
      //name: publicIPAddressObject.?name ?? '${name}-pip'
      //location: location
      lock: publicIPAddressObject.?lock ?? lock
      diagnosticSettings: publicIPAddressObject.?diagnosticSettings
      //publicIPAddressVersion: publicIPAddressObject.?publicIPAddressVersion
      //publicIPAllocationMethod: 'Static'
      publicIpPrefixResourceId: publicIPAddressObject.?publicIPPrefixResourceId
      roleAssignments: publicIPAddressObject.?roleAssignments
      //skuName: 'Standard' // Must be standard
      //skuTier: publicIPAddressObject.?skuTier
      //tags: publicIPAddressObject.?tags ?? tags
      //zones: publicIPAddressObject.?zones ?? (zone != 0 ? [zone] : null)
      //enableTelemetry: publicIPAddressObject.?enableTelemetry ?? enableTelemetry
      ddosSettings: publicIPAddressObject.?ddosSettings
      dnsSettings: publicIPAddressObject.?dnsSettings
      //idleTimeoutInMinutes: publicIPAddressObject.?idleTimeoutInMinutes
*/

module publicIP 'br/public:avm/res/network/public-ip-address:0.7.0' = {
  name: 'sad'
  params: {
    name: 'sad'
  }
}
