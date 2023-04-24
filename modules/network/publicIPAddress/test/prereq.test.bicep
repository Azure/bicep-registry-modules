param resourceGroupId string
param ipPrefixes array

resource test 'Microsoft.Network/publicIPPrefixes@2022-09-01' = [for ipprefix in ipPrefixes: {
  name: '${ipprefix.name}'
  location: ipprefix.location
  properties: {
    prefixLength: 30
  }
  sku: {
    name: ipprefix.skuName
    tier: ipprefix.tier
  }
}]

///subscriptions/416e4f7f-3466-4cd0-b530-0c50960d6d2c/resourcegroups/cluster-edibanda-eastus2-sandbox-iep/providers/microsoft.network/publicipprefixes/cluster-edibanda-eastus2-sandbox-iep-prefix
output ipPrefixes array = [for ipprefix in ipPrefixes: {
  name: ipprefix.name
  id: '${resourceGroupId}/providers/microsoft.network/publicipprefixes/${ipprefix.name}'
}]
