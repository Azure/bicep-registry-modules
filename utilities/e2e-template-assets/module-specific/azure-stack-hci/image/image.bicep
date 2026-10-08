targetScope = 'resourceGroup'

param location string
param galleryName string
param imageDefinitionName string
param imageTemplateName string
param imageBuilderIdentityName string
param imageVersion string
param sourceImageVersion string
param payloadUri string
param tags object

var imageBuilderRoleName = 'AVM HCI Image Builder'
var payloadPath = 'C:\\ISOs\\hci_os.vhdx'
var prerequisiteScript = base64(loadTextContent('../azureStackHCIHost/scripts/hciHostStage1.ps1'))
var prerequisiteCommands = [
  '$scriptPath = \'C:\\Windows\\Temp\\hciHostStage1.ps1\''
  '[IO.File]::WriteAllText($scriptPath, [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(\'${prerequisiteScript}\')))'
  '& $scriptPath'
]
var payloadCommands = [
  '$payloadPath = \'${payloadPath}\''
  'New-Item -ItemType Directory -Path (Split-Path -Parent $payloadPath) -Force | Out-Null'
  'Invoke-WebRequest -Uri \'${payloadUri}\' -OutFile $payloadPath -UseBasicParsing'
  'if ((Get-Item -LiteralPath $payloadPath).Length -le 0) { throw \'The Azure Local payload is empty.\' }'
]

resource gallery 'Microsoft.Compute/galleries@2025-03-03' = {
  name: galleryName
  location: location
  properties: {
    description: 'Images used by Azure Verified Modules Azure Local tests.'
  }
  tags: tags
}

resource imageDefinition 'Microsoft.Compute/galleries/images@2025-03-03' = {
  parent: gallery
  name: imageDefinitionName
  location: location
  properties: {
    architecture: 'x64'
    hyperVGeneration: 'V2'
    identifier: {
      publisher: 'AzureVerifiedModules'
      offer: 'AzureLocalTestHost'
      sku: 'WindowsServer2022'
    }
    osState: 'Generalized'
    osType: 'Windows'
  }
  tags: tags
}

resource imageBuilderIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: imageBuilderIdentityName
  location: location
  tags: tags
}

resource imageBuilderRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id, 'hci-image-builder')
  properties: {
    roleName: imageBuilderRoleName
    description: 'Allows Azure VM Image Builder to publish only to the AVM HCI Compute Gallery.'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'
          'Microsoft.Compute/galleries/images/versions/write'
          'Microsoft.Compute/galleries/images/versions/delete'
          'Microsoft.Compute/galleries/images/versions/purge/action'
        ]
        notActions: []
      }
    ]
    assignableScopes: [
      resourceGroup().id
    ]
  }
}

resource imageBuilderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, imageBuilderIdentity.id, imageBuilderRole.id)
  properties: {
    principalId: imageBuilderIdentity.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: imageBuilderRole.id
  }
}

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2025-10-01' = {
  name: imageTemplateName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${imageBuilderIdentity.id}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: 540
    vmProfile: {
      vmSize: 'Standard_D8s_v5'
      osDiskSizeGB: 160
    }
    source: {
      type: 'PlatformImage'
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-g2'
      version: sourceImageVersion
    }
    customize: [
      {
        type: 'PowerShell'
        name: 'InstallHciHostPrerequisites'
        inline: prerequisiteCommands
      }
      {
        type: 'WindowsRestart'
        name: 'RestartAfterPrerequisites'
        restartCheckCommand: 'powershell -command "& {if (@(Get-WindowsFeature Hyper-V,AD-Domain-Services,DHCP | Where-Object InstallState -ne Installed).Count -gt 0) { exit 1 }}"'
        restartTimeout: '10m'
      }
      {
        type: 'PowerShell'
        name: 'DownloadAzureLocalPayload'
        inline: payloadCommands
      }
    ]
    distribute: [
      {
        type: 'SharedImage'
        galleryImageId: '${imageDefinition.id}/versions/${imageVersion}'
        runOutputName: 'hci-host-${replace(imageVersion, '.', '-')}'
        excludeFromLatest: false
        replicationRegions: [
          location
        ]
        artifactTags: union(tags, {
          'image-version': imageVersion
          payload: 'AzLocal2601'
        })
      }
    ]
  }
  dependsOn: [
    imageBuilderRoleAssignment
  ]
  tags: tags
}

output galleryId string = gallery.id
output imageDefinitionId string = imageDefinition.id
output imageTemplateId string = imageTemplate.id
output imageVersionResourceId string = '${imageDefinition.id}/versions/${imageVersion}'
