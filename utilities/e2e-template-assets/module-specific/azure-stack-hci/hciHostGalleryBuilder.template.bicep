@description('Required. Location for the image template.')
param location string

@description('Required. Name of the Azure VM Image Builder template.')
param imageTemplateName string

@description('Required. Resource ID of the user-assigned managed identity used by Azure VM Image Builder.')
param imageBuilderIdentityResourceId string

@description('Required. Resource ID of the target gallery image definition.')
param galleryImageDefinitionResourceId string

@description('Required. Deterministic gallery image version.')
param imageVersion string

@description('Required. Base URI containing this asset and the authoritative HCI host scripts.')
param assetBaseUri string

@description('Required. Download URL for the Azure Stack HCI VHDX payload.')
param hciVhdxDownloadUri string

@description('Required. Source marketplace image used by Azure VM Image Builder.')
param sourceImage object

@description('Required. Azure VM size used for the image build.')
param buildVmSize string

@description('Required. Maximum image build duration in minutes.')
param buildTimeoutInMinutes int

@description('Optional. Tags applied to the image template and output version.')
param tags object = {}

var stage1ScriptUri = '${assetBaseUri}/azureStackHCIHost/scripts/hciHostStage1.ps1'
var encodedPayloadUri = base64(hciVhdxDownloadUri)
var payloadDownload = [
  '$ErrorActionPreference = \'Stop\''
  '$destination = \'C:\\ISOs\\hci_os.vhdx\''
  '$payloadUri = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(\'${encodedPayloadUri}\'))'
  'New-Item -Path (Split-Path -Path $destination -Parent) -ItemType Directory -Force | Out-Null'
  '$attempt = 0'
  'do {'
  '  $attempt++'
  '  try {'
  '    Invoke-WebRequest -Uri $payloadUri -OutFile $destination -UseBasicParsing'
  '    break'
  '  } catch {'
  '    if ($attempt -ge 5) { throw }'
  '    Start-Sleep -Seconds ([math]::Pow(2, $attempt))'
  '  }'
  '} while ($true)'
  'if (-not (Test-Path -LiteralPath $destination -PathType Leaf)) { throw \'HCI VHDX payload was not downloaded.\' }'
]

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2025-10-01' = {
  name: imageTemplateName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${imageBuilderIdentityResourceId}': {}
    }
  }
  properties: {
    buildTimeoutInMinutes: buildTimeoutInMinutes
    source: {
      type: 'PlatformImage'
      publisher: sourceImage.publisher
      offer: sourceImage.offer
      sku: sourceImage.sku
      version: sourceImage.version
    }
    customize: [
      {
        type: 'PowerShell'
        name: 'InstallHciHostPrerequisites'
        runElevated: true
        runAsSystem: true
        scriptUri: stage1ScriptUri
      }
      {
        type: 'WindowsRestart'
        name: 'RestartAfterPrerequisites'
        restartCheckCommand: 'powershell -command "& {Get-WindowsFeature -Name Hyper-V | Where-Object Installed}"'
        restartTimeout: '15m'
      }
      {
        type: 'PowerShell'
        name: 'DownloadHciPayload'
        runElevated: true
        runAsSystem: true
        inline: payloadDownload
      }
    ]
    distribute: [
      {
        type: 'SharedImage'
        runOutputName: 'hci-host-image-${replace(imageVersion, '.', '-')}'
        galleryImageId: '${galleryImageDefinitionResourceId}/versions/${imageVersion}'
        excludeFromLatest: false
        replicationRegions: [
          location
        ]
        storageAccountType: 'Standard_LRS'
        artifactTags: union(tags, {
          imageVersion: imageVersion
          source: 'AVM HCI host image builder'
        })
      }
    ]
    vmProfile: {
      vmSize: buildVmSize
      osDiskSizeGB: 256
    }
    errorHandling: {
      onCustomizerError: 'cleanup'
      onValidationError: 'cleanup'
    }
  }
}

@description('The resource ID of the Azure VM Image Builder template.')
output imageTemplateResourceId string = imageTemplate.id

@description('The name of the Azure VM Image Builder template.')
output imageTemplateName string = imageTemplate.name
