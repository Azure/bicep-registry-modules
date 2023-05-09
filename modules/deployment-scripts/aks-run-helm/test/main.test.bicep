/*
Forcing a RBAC refresh
Azure Resource Manager sometimes caches configurations and data to improve performance.
When you assign roles or remove role assignments, it can take up to 30 minutes for changes to take effect.
If you are using ...Azure CLI, you can force a refresh of your role assignment changes by signing out and signing in.
*/

param location string = resourceGroup().location
param aksName string =  'crtest${uniqueString(newGuid())}'

// Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    location: location
    aksName: aksName
  }
}

// Test 1. Install Sample Helm Chart
module sampleHelmChart '../main.bicep' = {
  name: 'sampleHelmChart'
  params: {
    managedIdentityName: 'kubectlHelmChart'
    aksName: prereq.outputs.aksName
    location: location
    helmApps: [{helmApp: 'azure-marketplace/wordpress', helmAppName: 'my-wordpress'}]
  }
}


// Test 2. Helm
module helmContour '../main.bicep' = {
  name: 'helmContour'
  params: {
    managedIdentityName: 'helmContourIngress'
    aksName: prereq.outputs.aksName
    location: location
    helmRepo: 'bitnami'
    helmRepoURL: 'https://charts.bitnami.com/bitnami'
    helmApps: [
      {
        helmApp: 'bitnami/contour'
        helmAppName: 'contour-ingress'
        helmAppParams: '--version 7.7.1 --namespace ingress-basic --create_namespace --set envoy.kind=deployment --set contour.service.externalTrafficPolicy=cluster'
      }
    ]
  }
}

// Test 3. Mllvus
module milvus '../main.bicep' = {
  name: 'milvus'
  params: {
    managedIdentityName: 'helmMilvus'
    aksName: prereq.outputs.aksName
    location: location
    helmRepo: 'milvus'
    helmRepoURL: 'https://milvus-io.github.io/milvus-helm/'
    helmApps: [
      {
        helmApp: 'milvus/milvus'
        helmAppName: 'vector-db'
        helmAppParams: '--set service.type=LoadBalancer'
      }
    ]
  }
}
