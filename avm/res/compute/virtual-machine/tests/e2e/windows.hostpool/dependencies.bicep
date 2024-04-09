@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script used to upload data to the Storage Account.')
param getRegistrationTokenDeploymentScriptName string

@description('Required. The name of the Host pool to create.')
param hostPoolName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2023-09-05' = {
  name: hostPoolName
  location: location
  properties: {
    hostPoolType: 'Personal'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
  }
}

resource msiHPDesktopVirtualizationVirtualMachineContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${hostPool.name}-${location}-${managedIdentity.id}-HostPool-DesktopVirtualizationVirtualMachineContributor-RoleAssignment')
  scope: hostPool
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'a959dbd1-f747-45e3-8ba6-dd80f235f97c'
    ) // Desktop Virtualization Virtual Machine Contributor
    principalType: 'ServicePrincipal'
  }
}

resource getRegistrationTokenDeploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: getRegistrationTokenDeploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  dependsOn: [
    msiHPDesktopVirtualizationVirtualMachineContributorRoleAssignment
  ]
  properties: {
    azPowerShellVersion: '10.0'
    arguments: '-HostPoolName "${hostPool.name}" -HostPoolResourceGroupName "${resourceGroup().name}" -SubscriptionId "${subscription().subscriptionId}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/Get-HostPoolRegistrationKey.ps1')
    retentionInterval: 'PT1H'
  }
}

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The name of the created Host pool.')
output hostPoolName string = hostPool.name

@description('The registration token of the created Host pool.')
output registrationInfoToken string = getRegistrationTokenDeploymentScript.properties.outputs.registrationInfoToken
