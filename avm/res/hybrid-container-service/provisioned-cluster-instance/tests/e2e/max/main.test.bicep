targetScope = 'subscription'

extension microsoftGraphV1

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-hybridcontainerservice.provisionedclusterinstances-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'hcpcimax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The password of the LCM deployment user and local administrator accounts.')
@secure()
param arbLocalAdminAndDeploymentUserPass string = ''

@description('Optional. An existing built-in service principal object ID for offline validation. When omitted, resolve it through Microsoft Graph.')
param builtInServicePrincipalObjectId string?

@description('Optional. The resource ID of a pre-baked Azure Compute Gallery image for the HCI host VM. Injected via CI-hciHostImageReferenceId secret.')
@secure()
#disable-next-line secure-parameter-default
param hciHostImageReferenceId string = ''

#disable-next-line no-hardcoded-location // Requires HCI service support and the configured nested-virtualization host VM size.
var enforcedLocation = 'australiaeast'

resource hciResourceProvider 'Microsoft.Graph/servicePrincipals@v1.0' existing = if (builtInServicePrincipalObjectId == null) {
  appId: '1412d89f-b8a8-4111-b4fd-e82905cbd85d'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/dependencies/dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-nestedDependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterName: '${namePrefix}${serviceShort}01'
    clusterWitnessStorageAccountName: 'dep${namePrefix}wst${serviceShort}'
    keyVaultDiagnosticStorageAccountName: 'dep${namePrefix}st${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    userAssignedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    maintenanceConfigurationAssignmentName: 'dep-${namePrefix}-mca-${serviceShort}'
    HCIHostVirtualMachineScaleSetName: 'dep-${namePrefix}-hvmss-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    networkInterfaceName: 'dep-${namePrefix}-mice-${serviceShort}'
    virtualMachineName: 'dep-${namePrefix}-vm-${serviceShort}'
    deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
    localAdminPassword: arbLocalAdminAndDeploymentUserPass
    diskNamePrefix: 'dep-${namePrefix}-dsk-${serviceShort}'
    waitDeploymentScriptPrefixName: 'dep-${namePrefix}-wds-${serviceShort}'
    hciHostImageReferenceId: hciHostImageReferenceId
    location: enforcedLocation
  }
}

module azlocal 'br/public:avm/res/azure-stack-hci/cluster:0.6.0' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustermodule-${serviceShort}'
  scope: resourceGroup
  params: {
    name: nestedDependencies.outputs.clusterName
    deploymentUser: 'deployUser'
    deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
    localAdminUser: 'Administrator'
    localAdminPassword: arbLocalAdminAndDeploymentUserPass
    hciResourceProviderObjectId: builtInServicePrincipalObjectId != null
      ? builtInServicePrincipalObjectId!
      : hciResourceProvider!.id
    deploymentSettings: {
      customLocationName: '${namePrefix}${serviceShort}-location'
      clusterNodeNames: nestedDependencies.outputs.clusterNodeNames
      clusterWitnessStorageAccountName: nestedDependencies.outputs.clusterWitnessStorageAccountName
      defaultGateway: '172.20.0.1'
      deploymentPrefix: 'a${take(uniqueString(namePrefix, serviceShort), 7)}' // ensure deployment prefix starts with a letter to match '^(?=.{1,8}$)([a-zA-Z])(\-?[a-zA-Z\d])*$'
      dnsServers: ['172.20.0.1']
      domainFqdn: 'hci.local'
      domainOUPath: nestedDependencies.outputs.domainOUPath
      startingIPAddress: '172.20.0.55'
      endingIPAddress: '172.20.0.65'
      enableStorageAutoIp: true
      keyVaultName: nestedDependencies.outputs.keyVaultName
      networkIntents: [
        {
          adapter: [
            'FABRIC'
            'FABRIC2'
          ]
          name: 'ManagementCompute'
          overrideAdapterProperty: true
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          overrideQosPolicy: false
          qosPolicyOverrides: {
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
          }
          overrideVirtualSwitchConfiguration: false
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
          trafficType: [
            'Management'
            'Compute'
          ]
        }
        {
          adapter: [
            'StorageA'
            'StorageB'
          ]
          name: 'Storage'
          overrideAdapterProperty: true
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          overrideQosPolicy: true
          qosPolicyOverrides: {
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
          }
          overrideVirtualSwitchConfiguration: false
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
          trafficType: ['Storage']
        }
      ]
      storageConnectivitySwitchless: false
      storageNetworks: [
        {
          name: 'Storage1Network'
          adapterName: 'StorageA'
          vlan: '711'
        }
        {
          name: 'Storage2Network'
          adapterName: 'StorageB'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
    }
  }
}

resource customLocation 'Microsoft.ExtendedLocation/customLocations@2021-08-31-preview' existing = {
  name: '${namePrefix}${serviceShort}-location'
  scope: resourceGroup
  dependsOn: [
    azlocal
  ]
}

module azLocalInit '../init.bicep' = {
  name: '${deployment().name}-azLocalInit'
  scope: resourceGroup
  params: {
    customLocationResourceId: customLocation.id
  }
}

module logicalNetwork 'br/public:avm/res/azure-stack-hci/logical-network:0.1.1' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-logicalNetwork-${serviceShort}'
  scope: resourceGroup
  params: {
    name: '${namePrefix}${serviceShort}logicalnetwork'
    customLocationResourceId: customLocation.id
    vmSwitchName: azlocal.outputs.vSwitchName
    ipAllocationMethod: 'Static'
    addressPrefix: '172.20.0.0/24'
    startingAddress: '172.20.0.171'
    endingAddress: '172.20.0.190'
    defaultGateway: '172.20.0.1'
    dnsServers: ['172.20.0.1']
    routeName: 'default'
    vlanId: null
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-aks-${serviceShort}'
  scope: resourceGroup
  dependsOn: [
    azLocalInit
  ]
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: enforcedLocation
    customLocationResourceId: customLocation.id
    keyVaultName: nestedDependencies.outputs.keyVaultName
    enableTelemetry: true
    kubernetesVersion: '1.29.4'
    storageProfile: {
      nfsCsiDriver: {
        enabled: true
      }
      smbCsiDriver: {
        enabled: true
      }
    }
    licenseProfile: { azureHybridBenefit: 'False' }
    cloudProviderProfile: {
      infraNetworkProfile: {
        vnetSubnetIds: [
          logicalNetwork.outputs.resourceId
        ]
      }
    }
    controlPlane: {
      count: 1
      vmSize: 'Standard_A4_v2'
      controlPlaneEndpoint: {
        hostIP: null
      }
    }
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 2
        enableAutoScaling: false
        maxCount: 5
        minCount: 1
        maxPods: 110
        nodeLabels: {}
        nodeTaints: []
        osSKU: 'CBLMariner'
        osType: 'Linux'
        vmSize: 'Standard_A4_v2'
      }
    ]
    arcAgentProfile: {
      agentAutoUpgrade: 'Enabled'
    }
    oidcIssuerProfile: { enabled: false }
    securityProfile: {
      workloadIdentity: {
        enabled: false
      }
    }
    connectClustersTags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
