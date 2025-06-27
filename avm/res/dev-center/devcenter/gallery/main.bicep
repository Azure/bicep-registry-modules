metadata name = 'Dev Center Gallery'
metadata description = 'This module deploys a Dev Center Gallery.'

// ================ //
// Parameters       //
// ================ //

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcenterName string

@description('Required. It must be between 3 and 63 characters, can only include alphanumeric characters, underscores and periods, and can not start or end with "." or "_".')
@minLength(3)
@maxLength(63)
param name string

@description('Required. The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery.')
param galleryResourceId string

@description('Optional. The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically. Note that the identity performing the deployment must have permissions to perform role assignments on the resource group of the gallery to assign the role, otherwise the deployment will fail.')
param devCenterIdentityPrincipalId string?

// ============== //
// Resources      //
// ============== //

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' existing = {
  name: devcenterName
}

module computeGallery_roleAssignment 'modules/computeGallery_roleAssignment.bicep' = if (devCenterIdentityPrincipalId != '') {
  name: '${deployment().name}-Contributor-RoleAssignment'
  scope: resourceGroup(split(galleryResourceId, '/')[4])
  params: {
    devCenterIdentityPrincipalId: devCenterIdentityPrincipalId!
    galleryResourceId: galleryResourceId
  }
}

resource gallery 'Microsoft.DevCenter/devcenters/galleries@2025-02-01' = {
  name: name
  parent: devcenter
  properties: {
    galleryResourceId: galleryResourceId
  }
  dependsOn: [
    computeGallery_roleAssignment
  ]
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the Dev Center Gallery was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Dev Center Gallery.')
output name string = gallery.name

@description('The resource ID of the Dev Center Gallery.')
output resourceId string = gallery.id
