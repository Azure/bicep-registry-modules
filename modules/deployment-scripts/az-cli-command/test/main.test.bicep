param location string = resourceGroup().location

//RBAC RoleId vars
var contributor='b24988ac-6180-42a0-ab88-20f7382dd24c'

//Test 1. Get Account
var script = loadTextContent('script.sh')

module runCLI '../main.bicep' = {
  name: 'getAccount'
  params: {
    managedIdentityName: 'getAccount'
    rbacRolesNeeded:[
      contributor
    ]
    location: location
    scriptContent: script
  }
}
