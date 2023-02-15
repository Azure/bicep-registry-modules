@description('The Azure region where resources in the template should be deployed.')
param location string = resourceGroup().location

@description('Used in the naming of the Azure resources')
param nameseed string = 'dbox'

param devcenterName string

resource dc 'Microsoft.DevCenter/devcenters@2022-11-11-preview' existing = {
  name: devcenterName
}

resource dcGallery 'Microsoft.DevCenter/devcenters/galleries@2022-11-11-preview' = {
  name: 'ig${nameseed}'
  parent: dc
  properties: {
    galleryResourceId: imageGallery.id
  }
  dependsOn: [dcIdRbac]
}

var readerRoleId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
var contribRoleId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
resource dcIdRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(imageGallery.id, readerRoleId, dc.id)
  scope: imageGallery
  properties: {
    roleDefinitionId: readerRoleId
    principalId: dc.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

var win365principalId='7d5e1273-8ba4-4c02-bdfb-4a51732ebd11'
resource w365Rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(imageGallery.id, readerRoleId, win365principalId)
  scope: imageGallery
  properties: {
    roleDefinitionId: readerRoleId
    principalId: win365principalId
    principalType: 'ServicePrincipal'
  }
}

@description('These are marketplace images that are the base for custom images')
var imageDefinitionMap = {
  vs2022win11m365: {
    publisher: 'MicrosoftVisualStudio'
    offer: 'visualstudioplustools'
    sku: 'vs-2022-ent-general-win11-m365-gen2'
    version: 'latest'
  }
  win11 : {
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'Windows-11'
    sku: 'win11-21h2-avd'
    version: 'latest'
  }
}

@allowed(['vs2022win11m365', 'win11'])
param imagebase string = 'vs2022win11m365'

param imageDetails object = {
  name: '${imageName}_Definition'
  publisher: 'Contoso'
  offer: imagebase
  sku: '${join(imageCustomisation,'-')}_1-0-0'
}

var imageDefinitionProperties = imageDefinitionMap[imagebase]

@allowed(['vscode', 'windowsUpdate'])
param imageCustomisation array = ['vscode']

@description('Name of the custom iamge to create and distribute using Azure Image Builder.')
param imageName string = take('${nameseed}-${imagebase}', 16)
var runOutputName  = '${imageName}_CustomImage'

@description('Update/Upgrade of image templates is currently not supported - So for Idempotency reasons a GUID is being introduced into the naming')
var imageTemplateName = '${imageName}_${newguid}_Template'
var imageBuildName = '${imageName}_${newguid}_Build'

@description('A unique string generated for each deployment, to make sure the script is always run.')
param newguid string = newGuid()

resource templateIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: 'id-${nameseed}'
  location: location
}

var templateIdentityRoleDefinitionName = guid(resourceGroup().id)
resource templateIdentityRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: templateIdentityRoleDefinitionName
  properties: {
    roleName: templateIdentityRoleDefinitionName
    description: 'Used for AIB template and ARM deployment script that runs AIB build'
    type: 'customRole'
    permissions: [
      {
        actions: [
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'
          'Microsoft.Compute/galleries/images/versions/write'
          'Microsoft.Compute/images/read'
          'Microsoft.Compute/images/write'
          'Microsoft.Compute/images/delete'
          'Microsoft.Storage/storageAccounts/blobServices/containers/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/write'
          'Microsoft.ContainerInstance/containerGroups/read'
          'Microsoft.ContainerInstance/containerGroups/write'
          'Microsoft.ContainerInstance/containerGroups/start/action'
          'Microsoft.Resources/deployments/read'
          'Microsoft.Resources/deploymentScripts/read'
          'Microsoft.Resources/deploymentScripts/write'
          'Microsoft.VirtualMachineImages/imageTemplates/run/action'
        ]
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

resource templateRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, templateIdentityRoleDefinition.id, templateIdentity.id)
  properties: {
    roleDefinitionId: templateIdentityRoleDefinition.id
    principalId: templateIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource imageGallery 'Microsoft.Compute/galleries@2022-03-03' = {
  name: 'ig${nameseed}'
  location: location
  properties: {}
}

@description('Images are defined within a gallery and carry information about the image and requirements for using it internally. This includes whether the image is Windows or Linux, release notes, and minimum and maximum memory requirements.')
resource imageDefinition 'Microsoft.Compute/galleries/images@2022-03-03' = {
  parent: imageGallery
  name: imageDetails.sku //The publisher, offer, sku combination must be unique in the gallery
  location: location
  properties: {
    osType: 'Windows'
    osState: 'Generalized'
    features: [
      {
        name: 'SecurityType'
        value: 'TrustedLaunch'
      }
    ]
    identifier: {
      publisher: imageDetails.publisher
      offer: imageDetails.offer
      sku: imageDetails.sku
    }
    recommended: {
      vCPUs: {
        min: 2
        max: 16
      }
      memory: {
        min: 4
        max: 48
      }
    }
    hyperVGeneration: 'V2'
  }
}

@description('This is the resource which is used in the VM Image Builder service. Deployment will not wait for completion, check Build run state in the Azure Portal')
resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2022-02-14' = {
  name: imageTemplateName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${templateIdentity.id}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 100
    vmProfile: {
      vmSize: 'Standard_DS2_v2'
      osDiskSizeGB: 127
    }
    source: {
      type: 'PlatformImage'
      publisher: imageDefinitionProperties.publisher
      offer: imageDefinitionProperties.offer
      sku: imageDefinitionProperties.sku
      version: 'Latest'
    }
    customize: [
      // {
      //   type: 'WindowsUpdate'
      //   searchCriteria: 'IsInstalled=0'
      //   filters: [
      //     'exclude:$_.Title -like \'*Preview*\''
      //     'include:$true'
      //   ]
      //   updateLimit: 40
      // }
      {
        type: 'PowerShell'
        name: 'Install Choco and Vscode'
        inline: [
          'Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString(\'https://community.chocolatey.org/install.ps1\'))'
          'choco install -y vscode'
        ]
      }
      // {
      //   type: 'PowerShell'
      //   name: 'AzureWindowsBaseline'
      //   runElevated: true
      //   scriptUri: customizerScriptUri
      // }
    ]
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: imageDefinition.id
        runOutputName: runOutputName
        //replicationRegions: ['westus2']
        replicationRegions: array(location)
      }
    ]
  }
}

var pwshBuildCommand = 'Invoke-AzResourceAction -ResourceName "${imageTemplateName}" -ResourceGroupName "${resourceGroup().name}" -ResourceType "Microsoft.VirtualMachineImages/imageTemplates" -ApiVersion "2020-02-14" -Action Run -Force'
var AzBuildCommand = 'az resource invoke-action --action Run --name "${imageTemplateName}" --resource-group "${resourceGroup().name}" --resource-type "Microsoft.VirtualMachineImages/imageTemplates" --api-version "2020-02-14"'

@description('Running the AIB build step as part of the deployment. Opt out of this if you prefer to invoke locally.')
param doBuildInAzureDeploymentScript bool = true

@description('This resource invokes a command to start the AIB build')
resource imageTemplate_build 'Microsoft.Resources/deploymentScripts@2020-10-01' = if(doBuildInAzureDeploymentScript) {
  name: imageBuildName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${templateIdentity.id}': {}
    }
  }
  dependsOn: [
    imageTemplate
    templateRoleAssignment
  ]
  properties: {
    forceUpdateTag: newguid
    azPowerShellVersion: '6.2'
    scriptContent: pwshBuildCommand
    timeout: 'PT1H'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}

@description('To invoke the AIB build step locally, in PowerShell, use this command.')
output imageBuildPwshCommand string = pwshBuildCommand

@description('To invoke the AIB build step locally, with the Azure CLI, use this command.')
output imageBuildAzCommand string = AzBuildCommand

@description('To debug the build process, check the customization.log in the storage account in this resource group in your subscription')
output imageBuilderLogsResourceGroup string = 'IT_${imageTemplateName}'
