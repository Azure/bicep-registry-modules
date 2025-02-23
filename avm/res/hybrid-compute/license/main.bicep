metadata name = 'Azure Arc License'
metadata description = 'This module deploys an Azure Arc License for use with Azure Arc-enabled servers. This module should not be used for other Arc-enabled server scenarios, where the Arc License resource is created automatically by the onboarding process.'

@description('Required. The name of the Azure Arc License to be created.')
param name string

@description('Optional. The location of the Azure Arc License to be created.')
param location string = resourceGroup().location

@description('Optional. Describes the edition of the license. Default is Standard.')
@allowed([
  'Standard'
  'Datacenter'
])
param licenseDetailEdition string = 'Standard'

@description('Optional. Describes the number of processors.')
@minValue(8)
param licenseDetailProcessors int = 8

@description('Optional. Describes the license state. Default is Deactivated.')
@allowed([
  'Active'
  'Deactivated'
])
param licenseDetailState string = 'Deactivated'

@description('Optional. Describes the license target server. Default is Windows Server 2012 R2.')
@allowed([
  'Windows Server 2012 R2'
  'Windows Server 2012'
])
param licenseDetailTarget string = 'Windows Server 2012 R2'

@description('Optional. Provide the core type (vCore or pCore) needed for this ESU licens. Default is vCore.')
@allowed([
  'pCore'
  'vCore'
])
param licenseDetailType string = 'vCore'

@description('Optional. A list of volume license details.')
param licenseVolumeLicenseDetails volumeLicenseDetailType[] = []

@description('Optional. The type of the license resource. The value is ESU.')
@allowed([
  'ESU'
])
param licenseType string = 'ESU'

@description('Optional. The tenant ID of the license resource. Default is the tenant ID of the current subscription.')
param tenantId string = tenant().tenantId

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource license 'Microsoft.HybridCompute/licenses@2024-11-10-preview' = {
  name: name
  location: location
  properties: {
    licenseDetails: {
      edition: licenseDetailEdition
      processors: licenseDetailProcessors
      state: licenseDetailState
      target: licenseDetailTarget
      type: licenseDetailType
      volumeLicenseDetails: licenseVolumeLicenseDetails
    }
    licenseType: licenseType
    tenantId: tenantId
  }
  tags: tags
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.hybridcompute-license.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

@export()
@description('The type for a volume license detail.')
type volumeLicenseDetailType = {
  @description('Required. The invoice id for the volume license.')
  invoiceId: string

  @description('Required. Describes the program year the volume license is for.')
  programYear: 'Year 1' | 'Year 2' | 'Year 3'
}

@description('The name of the machine.')
output name string = license.name

@description('The resource ID of the machine.')
output resourceId string = license.id

@description('The name of the resource group the VM was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = license.location
