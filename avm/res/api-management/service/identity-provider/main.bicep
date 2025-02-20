metadata name = 'API Management Service Identity Providers'
metadata description = 'This module deploys an API Management Service Identity Provider.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. List of Allowed Tenants when configuring Azure Active Directory login. - string.')
param allowedTenants array = []

@description('Optional. OpenID Connect discovery endpoint hostname for AAD or AAD B2C.')
param authority string = ''

@description('Conditional. Client ID of the Application in the external Identity Provider. Required if identity provider is used.')
param clientId string = ''

@description('Optional. The client library to be used in the developer portal. Only applies to AAD and AAD B2C Identity Provider.')
@allowed([
  'ADAL'
  'MSAL-2'
])
param clientLibrary string?

@description('Conditional. Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used.')
@secure()
param clientSecret string = ''

@description('Optional. Password Reset Policy Name. Only applies to AAD B2C Identity Provider.')
#disable-next-line secure-secrets-in-params // Not a secret
param passwordResetPolicyName string = ''

@description('Optional. Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.')
param profileEditingPolicyName string = ''

@description('Optional. Signin Policy Name. Only applies to AAD B2C Identity Provider.')
param signInPolicyName string = ''

@description('Optional. The TenantId to use instead of Common when logging into Active Directory.')
param signInTenant string = ''

@description('Optional. Signup Policy Name. Only applies to AAD B2C Identity Provider.')
param signUpPolicyName string = ''

@description('Optional. Identity Provider Type identifier.')
@allowed([
  'aad'
  'aadB2C'
  'facebook'
  'google'
  'microsoft'
  'twitter'
])
param type string = 'aad'

@description('Required. Identity provider name.')
param name string

var isAadB2C = (type == 'aadB2C')

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource identityProvider 'Microsoft.ApiManagement/service/identityProviders@2022-08-01' = {
  name: name
  parent: service
  properties: {
    type: type
    signinTenant: signInTenant
    allowedTenants: allowedTenants
    authority: authority
    signupPolicyName: isAadB2C ? signUpPolicyName : null
    signinPolicyName: isAadB2C ? signInPolicyName : null
    profileEditingPolicyName: isAadB2C ? profileEditingPolicyName : null
    passwordResetPolicyName: isAadB2C ? passwordResetPolicyName : null
    clientId: clientId
    clientLibrary: clientLibrary
    clientSecret: clientSecret
  }
}

@description('The resource ID of the API management service identity provider.')
output resourceId string = identityProvider.id

@description('The name of the API management service identity provider.')
output name string = identityProvider.name

@description('The resource group the API management service identity provider was deployed into.')
output resourceGroupName string = resourceGroup().name
