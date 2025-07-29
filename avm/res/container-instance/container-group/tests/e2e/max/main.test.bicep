targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerinstance.containergroups-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cicgmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

var availabilityZones = [1, 2]
var iterations = ['init', 'idem']

var testConfigurations = flatten(map(
  availabilityZones,
  zone =>
    map(iterations, iter => {
      iteration: iter
      availabilityZone: zone
    })
))

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for config in testConfigurations: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${config.iteration}-${config.availabilityZone}'
    params: {
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001-${config.availabilityZone}'
      availabilityZone: config.availabilityZone
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      logAnalytics: {
        logType: 'ContainerInstanceLogs'
        workspaceResourceId: nestedDependencies.outputs.logAnalyticsWorkspaceResourceId
      }
      containers: [
        {
          name: '${namePrefix}-az-aci-x-1-${config.availabilityZone}'
          properties: {
            command: [
              '/bin/sh'
              '-c'
              'node /usr/src/app/index.js & (sleep 10; touch /tmp/ready); wait'
            ]
            readinessProbe: {
              exec: {
                command: [
                  'cat'
                  '/tmp/ready'
                ]
              }
              initialDelaySeconds: 10
              periodSeconds: 5
              failureThreshold: 3
            }
            environmentVariables: [
              {
                name: 'CLIENT_ID'
                value: 'TestClientId'
              }
              {
                name: 'CLIENT_SECRET'
                secureValue: 'TestSecret'
              }
            ]
            image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
            ports: [
              {
                port: 80
                protocol: 'Tcp'
              }
              {
                port: 443
                protocol: 'Tcp'
              }
            ]
            resources: {
              requests: {
                cpu: 2
                memoryInGB: '2'
              }
              limits: {
                cpu: 4
                memoryInGB: '4'
              }
            }
          }
        }
        {
          name: '${namePrefix}-az-aci-x-2-${config.availabilityZone}'
          properties: {
            command: []
            environmentVariables: []
            image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
            ports: [
              {
                port: 8080
                protocol: 'Tcp'
              }
            ]
            resources: {
              requests: {
                cpu: 2
                memoryInGB: '2'
              }
            }
          }
        }
      ]
      ipAddress: {
        ports: [
          {
            protocol: 'Tcp'
            port: 80
          }
          {
            protocol: 'Tcp'
            port: 443
          }
        ]
      }
      // TODO Add volumes
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
