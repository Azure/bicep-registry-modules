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

// needed for the storage account itself and for using listKeys in the secrets, as the storage account is created in the nested deployment and the value needs to exist at the time of deployment
var storageAccountName = uniqueString('dep-${namePrefix}-menv-${serviceShort}storage')

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
    storageAccountName: storageAccountName
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
      triggerType: 'Event'
      eventTriggerConfig: {
        parallelism: 1
        replicaCompletionCount: 1
        scale: {
          minExecutions: 1
          maxExecutions: 1
          pollingInterval: 55
          rules: [
            {
              name: 'queue'
              type: 'azure-queue'
              metadata: {
                queueName: nestedDependencies.outputs.storageQueueName
                storageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
              }
              auth: [
                {
                  secretRef: 'connectionString'
                  triggerParameter: 'connection'
                }
              ]
            }
          ]
        }
      }
      secrets: [
        {
          name: 'connection-string'
          // needed for using listKeys in the secrets, as the storage account is created in the nested deployment and the value needs to exist at the time of deployment
          value: listKeys(
            '${resourceGroup.id}/providers/Microsoft.Storage/storageAccounts/${storageAccountName}',
            '2023-04-01'
          ).keys[0].value
        }
      ]
      containers: [
        {
          name: 'simple-hello-world-container'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: '1.25'
            memory: '1.5Gi'
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
          env: [
            {
              name: 'AZURE_STORAGE_QUEUE_NAME'
              value: nestedDependencies.outputs.storageQueueName
            }
            {
              name: 'AZURE_STORAGE_CONNECTION_STRING'
              secretRef: 'connection-string'
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
          name: 'be1bb251-6a44-49f7-8658-d836d0049fc4'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
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
