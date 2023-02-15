param nameseed string = 'dbox'
param definitionName string = '${nameseed}-${image}-${storage}'
param location string = resourceGroup().location
param devcenterName string

param galleryName string = 'Default'

@allowed(['win11', 'vs2022win11m365'])
param image string = 'win11'

var sku = skuMap.vm8core32memory
var skuMap = {
  vm8core32memory: 'general_a_8c32gb_v1'
}

@allowed(['ssd_256gb', 'ssd_512gb', 'ssd_1024gb'])
param storage string = 'ssd_256gb'

var defaultImageMap = {
  win11: 'microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-os'
  vs2022win11m365: 'microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
}

resource dc 'Microsoft.DevCenter/devcenters@2022-11-11-preview' existing = {
  name: devcenterName
}

resource gallery 'Microsoft.DevCenter/devcenters/galleries@2022-11-11-preview' existing = {
  name: galleryName
  parent: dc
}

resource galleryimage 'Microsoft.DevCenter/devcenters/galleries/images@2022-11-11-preview' existing = {
  name: defaultImageMap['${image}']
  parent: gallery
}
output imageGalleryId string = galleryimage.id

resource devboxdef 'Microsoft.DevCenter/devcenters/devboxdefinitions@2022-11-11-preview' = {
  name: definitionName
  parent: dc
  location: location
  properties: {
    sku: {
      name: sku
    }
    imageReference: {
      id: galleryimage.id //the resource-id of a Microsoft.DevCenter Gallery Image
    }
    osStorageType: storage
    hibernateSupport: 'Disabled'
  }
}
output definitionName string = devboxdef.name
