param location string = resourceGroup().location
param helmChart string = '' //Fake value path for testing

//Test main for unreal-cloud-ddc
module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    location: location
    helmChart: helmChart
  }
}
