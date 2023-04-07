param name string
param location string
param skuName string
param skuCapacity int
param tags object = {}

resource hostingPlanName 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    reserved: true
  }
}
output id string = hostingPlanName.id
