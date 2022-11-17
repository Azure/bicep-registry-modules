/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

module justAccount '../main.bicep' = {
  name: 'justaccount'
  params: {
    location: location
    automationAccountName: uniqueString('justaccount', resourceGroup().id, deployment().name)
    runbookName: ''
  }
}
