// Application-specific resource provisioning module

@minLength(3)
@maxLength(12)
@description('The name of the environment/application. This will be used to create the resource group and other resources.')
param name string

@minLength(3)
param location string = resourceGroup().location

module containerapp 'br/public:avm/res/app/container-app:0.13.0' = {
  name: 'containerapp-deployment'
  params: {
    name: name
    location: location
    environmentResourceId: ''
    containers: [
      {
        name: 'containerapp'
        image: 'mcr.microsoft.com/azuresdk/containerapps/quickstart:latest'
        resources: {
          cpu: '0.5'
          memory: '1.0'
        }
      }
    ]
  }
}
