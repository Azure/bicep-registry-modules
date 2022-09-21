/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
@description('Deployment Location')
param location string = 'eastus'

var sharedGallery = 'ScyllaDB-f6e972a4-92ec-4c3c-8999-11b863cad0f7'
var definition = 'ScyllaDB_Enterprise'
var imageVer = 'latest'

var communityGalleryImageId = '/CommunityGalleries/${sharedGallery}/Images/${definition}/Versions/${imageVer}'

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


