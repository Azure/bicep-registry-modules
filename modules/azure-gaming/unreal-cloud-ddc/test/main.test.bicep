/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
param location string = resourceGroup().location
//@secure()
param helmChart string = '' //Fake value and see how far we get

//Test main for unreal-cloud-ddc
module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location: location
    helmChart: helmChart
  }
}
