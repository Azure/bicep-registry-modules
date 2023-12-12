/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
@description('Deployment Location')
param location string = 'eastus'

var communityGalleryImageId = '/CommunityGalleries/scylladb-7e8d8a04-23db-487d-87ec-0e175c0615bb/Images/scylla-enterprise-2023.1'

var customData = loadFileAsBase64('imageConfig.json')

module test1 '../main.bicep' = {
  name: 'Test1'
  params: {
    location: location
    administratorLogin: uniqueString(resourceGroup().name)
    passwordAdministratorLogin: guid(resourceGroup().name)
    vmssName: uniqueString(resourceGroup().name)
    communityGalleryImageId: communityGalleryImageId
    customData: customData
    imageLocation: 'gallery'
  }
}
