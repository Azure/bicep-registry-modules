metadata name = 'Web/Function Apps Slot Host Name Bindings'
metadata description = 'This module deploys a Site Slot Host Name Binding.'

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Conditional. The name of the site slot. Required if the template is used in a standalone deployment.')
param slotName string

@description('Required. Hostname in the hostname binding.')
param name string

@description('Optional. Kind of resource.')
param kind string?

@description('Optional. Azure resource name.')
param azureResourceName string?

@description('Optional. Azure resource type. Possible values are Website and TrafficManager.')
@allowed([
  'Website'
  'TrafficManager'
])
param azureResourceType string?

@description('Optional. Custom DNS record type. Possible values are CName and A.')
@allowed([
  'CName'
  'A'
])
param customHostNameDnsRecordType string?

@description('Optional. Fully qualified ARM domain resource URI.')
param domainId string?

@description('Optional. Hostname type. Possible values are Verified and Managed.')
@allowed([
  'Verified'
  'Managed'
])
param hostNameType string?

@description('Optional. App Service app name.')
param siteName string?

@description('Optional. SSL type. Possible values are Disabled, SniEnabled, and IpBasedEnabled.')
@allowed([
  'Disabled'
  'SniEnabled'
  'IpBasedEnabled'
])
param sslState string?

@description('Optional. SSL certificate thumbprint.')
param thumbprint string?

resource app 'Microsoft.Web/sites@2024-11-01' existing = {
  name: appName

  resource slot 'slots@2024-11-01' existing = {
    name: slotName
  }
}

resource hostNameBinding 'Microsoft.Web/sites/slots/hostNameBindings@2024-11-01' = {
  parent: app::slot
  name: name
  kind: kind
  properties: {
    azureResourceName: azureResourceName
    azureResourceType: azureResourceType
    customHostNameDnsRecordType: customHostNameDnsRecordType
    domainId: domainId
    hostNameType: hostNameType
    siteName: siteName
    sslState: sslState
    thumbprint: thumbprint
  }
}

@description('The name of the host name binding.')
output name string = hostNameBinding.name

@description('The resource ID of the host name binding.')
output resourceId string = hostNameBinding.id

@description('The name of the resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name
