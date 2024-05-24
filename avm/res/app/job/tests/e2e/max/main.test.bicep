targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.job-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ajmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    location: resourceLocation
    managedEnvironmentName: 'dep-${namePrefix}-menv-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    workloadProfileName: serviceShort
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Env: 'test'
      }
      environmentResourceId: nestedDependencies.outputs.managedEnvironmentResourceId
      workloadProfileName: serviceShort
      location: resourceLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      secrets: [
        {
          name: 'customtest'
          value: guid(deployment().name)
        }
      ]
      triggerType: 'Schedule'
      scheduleTriggerConfig: {
        cronExpression: '0 0 * * *'
        parallelism: 1
        replicaCompletionCount: 1
      }
      containers: [
        {
          name: 'simple-hello-world-container'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

          resources: {
            // workaround as 'float' values are not supported in Bicep, yet the resource providers expects them. Related issue: https://github.com/Azure/bicep/issues/1386
            cpu: '0.25'
            memory: '0.5Gi'
          }
          probes: [
            {
              type: 'Liveness'
              httpGet: {
                path: '/health'
                port: 8080
                httpHeaders: [
                  {
                    name: 'Custom-Header'
                    value: 'Awesome'
                  }
                ]
              }
              initialDelaySeconds: 3
              periodSeconds: 3
            }
          ]
          volumeMounts: [
            {
              volumeName: '${namePrefix}${serviceShort}emptydir'
              mountPath: '/mnt/data'
            }
          ]
        }
        {
          name: 'second-simple-container'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          env: [
            {
              name: 'SOME_ENV_VAR'
              value: 'some-value'
            }
          ]
          args: [
            'arg1'
            'arg2'
          ]
          command: [
            '/bin/bash'
            '-c'
            'echo hello'
            'sleep 100000'
          ]
        }
      ]
      volumes: [
        {
          storageType: 'EmptyDir'
          name: '${namePrefix}${serviceShort}emptydir'
        }
      ]
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
    }
  }
]
