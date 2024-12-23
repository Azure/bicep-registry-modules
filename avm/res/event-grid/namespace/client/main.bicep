metadata name = 'Eventgrid Namespace Clients'
metadata description = 'This module deploys an Eventgrid Namespace Client.'

@sys.description('Conditional. The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@minLength(1)
@maxLength(128)
@sys.description('Required. Name of the Client.')
param name string

@sys.description('Optional. Description of the Client resource.')
param description string?

@sys.description('Optional. The name presented by the client for authentication. The default value is the name of the resource.')
param authenticationName string?

@sys.allowed([
  'DnsMatchesAuthenticationName'
  'EmailMatchesAuthenticationName'
  'IpMatchesAuthenticationName'
  'SubjectMatchesAuthenticationName'
  'ThumbprintMatch'
  'UriMatchesAuthenticationName'
])
@sys.description('Optional. The validation scheme used to authenticate the client.')
param clientCertificateAuthenticationValidationSchema string = 'SubjectMatchesAuthenticationName'

@sys.description('Conditional. The list of thumbprints that are allowed during client authentication. Required if the clientCertificateAuthenticationValidationSchema is \'ThumbprintMatch\'.')
param clientCertificateAuthenticationAllowedThumbprints string[]?

@sys.description('Optional. Indicates if the client is enabled or not.')
param state string = 'Enabled'

@sys.description('Optional. Attributes for the client. Supported values are int, bool, string, string[].')
param attributes object?

// ============== //
// Resources      //
// ============== //

resource namespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' existing = {
  name: namespaceName
}

resource client 'Microsoft.EventGrid/namespaces/clients@2023-12-15-preview' = {
  name: name
  parent: namespace
  properties: {
    description: description
    authenticationName: !empty(authenticationName) ? authenticationName : name
    attributes: attributes
    clientCertificateAuthentication: {
      validationScheme: clientCertificateAuthenticationValidationSchema
      allowedThumbprints: clientCertificateAuthenticationValidationSchema == 'ThumbprintMatch'
        ? clientCertificateAuthenticationAllowedThumbprints
        : null
    }
    state: state
  }
}

// ============ //
// Outputs      //
// ============ //

@sys.description('The resource ID of the Client.')
output resourceId string = client.id

@sys.description('The name of the Client.')
output name string = client.name

@sys.description('The name of the resource group the Client was created in.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
