/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param waitSeconds int =  60

module delayDeployment '../main.bicep' = {
  name: 'delayDeployment'
  params: {
    waitSeconds: waitSeconds
    location: location
  }
}
