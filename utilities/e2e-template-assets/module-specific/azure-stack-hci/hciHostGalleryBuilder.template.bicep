@description('Required. Location of the image definition, which Azure VM Image Builder also uses for the image version.')
param location string

@description('Optional. Location for the image template and build VM. Use a new imageTemplateName when changing an existing template location.')
param buildLocation string = location

@minLength(1)
@description('Optional. Regions where the image version must be available. The image definition and build locations are always included.')
param replicationRegions string[] = [
  location
]

@description('Required. Name of the Azure VM Image Builder template.')
param imageTemplateName string

@description('Required. Resource ID of the user-assigned managed identity used by Azure VM Image Builder.')
param imageBuilderIdentityResourceId string

@description('Required. Resource ID of the target gallery image definition.')
param galleryImageDefinitionResourceId string

@description('Required. Deterministic gallery image version.')
param imageVersion string

@description('Required. Download URL for the Azure Stack HCI VHDX payload.')
param hciVhdxDownloadUri string

@minLength(64)
@maxLength(64)
@description('Required. Expected SHA256 of the downloaded VHDX.')
param hciVhdxSha256 string

@description('Required. Source marketplace image used by Azure VM Image Builder.')
param sourceImage object

@description('Required. Azure VM size used for the image build.')
param buildVmSize string

@description('Required. Maximum image build duration in minutes.')
param buildTimeoutInMinutes int

@description('Optional. Tags applied to the image template and output version.')
param tags object = {}

@description('Optional. Explicit resource group for image-build staging.')
param stagingResourceGroupResourceId string?

var requiredReplicationRegions = union(
  [
    toLower(replace(location, ' ', ''))
    toLower(replace(buildLocation, ' ', ''))
  ],
  map(replicationRegions, region => toLower(replace(region, ' ', '')))
)

// Embedded rather than downloaded, so the build doesn't need the source commit to be publicly reachable.
var encodedPrerequisiteScript = base64(loadTextContent('azureStackHCIHost/scripts/hciHostStage1.ps1'))
var prerequisiteInstall = [
  '$ErrorActionPreference = \'Stop\''
  '$scriptPath = Join-Path $env:TEMP \'hciHostStage1.ps1\''
  '[System.IO.File]::WriteAllText($scriptPath, [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(\'${encodedPrerequisiteScript}\')))'
  '& $scriptPath'
]

var encodedPayloadUri = base64(hciVhdxDownloadUri)
var encodedPayloadSha256 = base64(hciVhdxSha256)
var payloadDownload = [
  '$ErrorActionPreference = \'Stop\''
  '$ProgressPreference = \'SilentlyContinue\''
  '$destination = \'C:\\ISOs\\hci_os.vhdx\''
  '$payloadUri = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(\'${encodedPayloadUri}\'))'
  '$expectedSha256 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(\'${encodedPayloadSha256}\'))'
  'if ($expectedSha256 -notmatch \'\\A[0-9a-fA-F]{64}\\z\') { throw \'A valid HCI VHDX SHA256 digest is required.\' }'
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
  '$actualSha256 = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash'
  'if ($actualSha256 -ine $expectedSha256) { throw "HCI VHDX payload SHA256 mismatch. Expected [$expectedSha256], received [$actualSha256]." }'
]

// Sysprep can deadlock with automatic component store maintenance, so servicing must be idle before Image Builder deprovisions.
var servicingIdleWait = [
  '$ErrorActionPreference = \'Stop\''
  '$ProgressPreference = \'SilentlyContinue\''
  '$dism = Start-Process -FilePath "$env:SystemRoot\\System32\\Dism.exe" -ArgumentList \'/Online /Cleanup-Image /StartComponentCleanup /NoRestart /Quiet\' -Wait -PassThru -NoNewWindow'
  'if ($dism.ExitCode -notin 0, 3010) { Write-Warning "Component store cleanup returned exit code [$($dism.ExitCode)]." }'
  '$deadline = (Get-Date).AddMinutes(30)'
  '$idleSamples = 0'
  'while ($true) {'
  '  if (Get-Process -Name TiWorker -ErrorAction SilentlyContinue) { $idleSamples = 0 } else { $idleSamples++ }'
  '  if ($idleSamples -ge 3) { break }'
  '  if ((Get-Date) -ge $deadline) {'
  '    Write-Warning \'Windows Modules Installer is still busy; stopping it before deprovisioning.\''
  '    Stop-Service -Name TrustedInstaller -Force'
  '    break'
  '  }'
  '  Start-Sleep -Seconds 20'
  '}'
]

resource imageTemplate 'Microsoft.VirtualMachineImages/imageTemplates@2025-10-01' = {
  name: imageTemplateName
  location: buildLocation
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${imageBuilderIdentityResourceId}': {}
    }
  }
  properties: {
    stagingResourceGroup: stagingResourceGroupResourceId
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
        inline: prerequisiteInstall
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
      {
        type: 'PowerShell'
        name: 'WaitForServicingIdle'
        runElevated: true
        runAsSystem: true
        inline: servicingIdleWait
      }
    ]
    distribute: [
      {
        type: 'SharedImage'
        runOutputName: 'hci-host-image-${replace(imageVersion, '.', '-')}'
        galleryImageId: '${galleryImageDefinitionResourceId}/versions/${imageVersion}'
        excludeFromLatest: false
        targetRegions: [
          for region in requiredReplicationRegions: {
            name: region
            replicaCount: 1
            storageAccountType: 'Standard_LRS'
          }
        ]
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
