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

  @description('Optional. Certificate creation properties. If specified, a certificate will be created and used for this hostname binding.')
  certificate: certificateType?
}

@export()
@description('The type of certificate properties for hostname binding.')
type certificateType = {
  @description('Optional. Certificate host names. By default, will use the hostname from the binding.')
  hostNames: array?

  @description('Optional. Key Vault resource ID.')
  keyVaultId: string?

  @description('Optional. Key Vault secret name.')
  keyVaultSecretName: string?

  @description('Optional. Server farm resource ID.')
  serverFarmResourceId: string?

  @description('Optional. CNAME of the certificate to be issued via free certificate.')
  canonicalName: string?

  @description('Optional. Certificate password.')
  @secure()
  password: string?

  @description('Optional. Certificate data in PFX format.')
  @secure()
  pfxBlob: string?

  @description('Optional. Method of domain validation for free certificate.')
  domainValidationMethod: string?
}
