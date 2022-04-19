resource apiManagement 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: 'shengloltestservice'
  #disable-next-line no-hardcoded-location
  location: 'westus2'
  sku: {
    name: 'Basic'
    capacity: 0
  }
  properties: {
    publisherName: 'test'
    publisherEmail: 'shenglong.li@microsoft.com'
  }
}
