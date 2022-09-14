/*
Forcing a RBAC refresh
Azure Resource Manager sometimes caches configurations and data to improve performance.
When you assign roles or remove role assignments, it can take up to 30 minutes for changes to take effect.
If you are using ...Azure CLI, you can force a refresh of your role assignment changes by signing out and signing in.
*/

param location string = resourceGroup().location
param aksName string =  'crtest${resourceGroup().name}'

//Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    location: location
    aksName: aksName
  }
}

//Test 1. Install Sample Helm Chart
module configurePublicIP '../main.bicep' = {
  name: 'configurePublicIP'
  params: {
    managedIdentityName: 'kubectlHelmChart'
    aksName: prereq.outputs.aksName
    location: location
    publicIP: prereq.outputs.public_ip
    publicIPResourceGroup: resourceGroup().name
  }
}
