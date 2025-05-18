metadata name = 'Dev Center Gallery'
metadata description = 'This module deploys a Dev Center Gallery.'

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcenterName string

@description('Required. The name of the gallery resource.')
@minLength(3)
@maxLength(63)
param name string

@description('Required. The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery.')
param galleryResourceId string

// To do ==> Support creating the Contributor role assignment for the Dev Center identity on the backing Azure Compute Gallery.

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' existing = {
  name: devcenterName
}

resource gallery 'Microsoft.DevCenter/devcenters/galleries@2025-02-01' = {
  name: name
  parent: devcenter
  properties: {
    galleryResourceId: galleryResourceId
  }
}

@description('The name of the resource group the Dev Center Gallery was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Dev Center Gallery.')
output name string = gallery.name

@description('The resource ID of the Dev Center Gallery.')
output resourceId string = gallery.id
