param workspaceName string = 'dbrtest1'
param location string = 'uksouth'
param skuName string = 'premium'

//param authorizations array
param workspace_principalId string = '86ec5d38-9856-4ca7-98de-867fee8f4a83'
var contributorRoleDefId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'

resource workspace 'Microsoft.Databricks/workspaces@2023-02-01' = {
  name: workspaceName
  location: location
  sku: {
    name: skuName
  }
  properties: {
    //authorizations: authorizations
    managedResourceGroupId: '${subscription().id}/resourceGroups/${workspaceName}-rg'
    authorizations: [
      {
        principalId: workspace_principalId
        roleDefinitionId: contributorRoleDefId
      }
    ]
    //managedDiskIdentity: {}
    //createdBy: {}
    //uiDefinitionUri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/databricks-workspace/azuredeploy.json'
  }
}
