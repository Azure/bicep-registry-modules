param location string = resourceGroup().location

//RBAC RoleId vars
var contributor='b24988ac-6180-42a0-ab88-20f7382dd24c'

//Test 1. Get Nodes
var script = '''
#!/bin/bash
set -e

echo "Running az cli command"
jsonOutputString=$(az account show)

echo $jsonOutputString
echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
'''

module runCLI '../main.bicep' = {
  name: 'kubectlgetnodes'
  params: {
    managedIdentityName: 'kubectlGetNodes'
    rbacRolesNeeded:[
      contributor
    ]
    location: location
    commands: [
      'kubectl get nodes'
    ]
    scriptContent: script
  }
}
