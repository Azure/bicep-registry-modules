targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.containerApps-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'acamax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. Container app stored secret to pass into environment variables. The value is a GUID.')
@secure()
param myCustomContainerAppSecret string = newGuid()

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    location: resourceLocation
    managedEnvironmentName: 'dep-${namePrefix}-menv-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    keyVaultSecretName: 'dep-${namePrefix}-kv-secret-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
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
      roleAssignments: [
        {
          name: 'e9bac1ee-aebe-4513-9337-49e87a7be05e'
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
      environmentResourceId: nestedDependencies.outputs.managedEnvironmentResourceId
      location: resourceLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      secrets: {
        secureList: [
          {
            name: 'containerappstoredsecret'
            value: myCustomContainerAppSecret
          }
          {
            name: 'keyvaultstoredsecret'
            keyVaultUrl: nestedDependencies.outputs.keyVaultSecretURI
            identity: nestedDependencies.outputs.managedIdentityResourceId
          }
        ]
      }
      containers: [
        {
          name: 'simple-hello-world-container'
          image: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            // workaround as 'float' values are not supported in Bicep, yet the resource providers expects them. Related issue: https://github.com/Azure/bicep/issues/1386
            cpu: json('0.25')
            memory: '0.5Gi'
          }
          env: [
            {
              name: 'ContainerAppStoredSecretName'
              secretRef: 'containerappstoredsecret'
            }
            {
              name: 'ContainerAppKeyVaultStoredSecretName'
              secretRef: 'keyvaultstoredsecret'
            }
          ]
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
        }
      ]
    }
    dependsOn: [
      nestedDependencies
    ]
  }
]
