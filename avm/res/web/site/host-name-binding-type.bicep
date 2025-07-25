@export()
@description('The type of a host name binding.')
type hostNameBindingType = {
  @description('Required. Hostname in the hostname binding.')
  name: string

  @description('Optional. Kind of resource.')
  kind: string?

  @description('Optional. Azure resource name.')
  azureResourceName: string?

  @description('Optional. Azure resource type. Possible values are Website and TrafficManager.')
  azureResourceType: ('Website' | 'TrafficManager')?

  @description('Optional. Custom DNS record type. Possible values are CName and A.')
  customHostNameDnsRecordType: ('CName' | 'A')?

  @description('Optional. Fully qualified ARM domain resource URI.')
  domainId: string?

  @description('Optional. Hostname type. Possible values are Verified and Managed.')
  hostNameType: ('Verified' | 'Managed')?

  @description('Optional. App Service app name.')
  siteName: string?

  @description('Optional. SSL type. Possible values are Disabled, SniEnabled, and IpBasedEnabled.')
  sslState: ('Disabled' | 'SniEnabled' | 'IpBasedEnabled')?

  @description('Optional. SSL certificate thumbprint.')
  thumbprint: string?
}
