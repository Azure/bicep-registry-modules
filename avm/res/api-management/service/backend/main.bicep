metadata name = 'API Management Service Backends'
metadata description = 'This module deploys an API Management Service Backend.'

@sys.description('Conditional. Required if the template is used in a standalone deployment. The name of the parent API Management service.')
param apiManagementServiceName string

@sys.description('Required. Backend Name.')
param name string

@sys.description('Optional. Backend Credentials Contract Properties.')
param credentials backendCredentialsType?

@sys.description('Optional. Backend Description.')
param description string?

@sys.description('Optional. Backend communication protocol. - http or soap.')
param protocol string = 'http'

@sys.description('Optional. Backend gateway Contract Properties.')
param proxy backendProxyType?

@sys.description('Optional. Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps.')
param resourceId string?

@sys.description('Optional. Backend Service Fabric Cluster Properties.')
param serviceFabricCluster backendServiceFabricClusterType?

@sys.description('Optional. Backend Title.')
param title string?

@sys.description('Optional. Backend TLS Properties.')
param tls backendTlsType = {
  validateCertificateChain: false
  validateCertificateName: false
}

@sys.description('Required. Runtime URL of the Backend.')
param url string

@sys.description('Optional. Backend Circuit Breaker Configuration.')
param circuitBreaker backendCircuitBreakerType?

@sys.description('Optional. Backend pool configuration for load balancing.')
param pool backendPoolType?

@sys.description('Optional. Type of the backend. A backend can be either Single or Pool.')
@allowed(['Single', 'Pool'])
param type string = 'Single'

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

resource backend 'Microsoft.ApiManagement/service/backends@2024-05-01' = {
  name: name
  parent: service
  properties: {
    circuitBreaker: circuitBreaker
    credentials: credentials
    description: description
    pool: pool
    properties: {
      serviceFabricCluster: serviceFabricCluster
    }
    protocol: protocol
    proxy: proxy
    resourceId: resourceId
    title: title
    tls: tls
    type: type
    url: url
  }
}

@sys.description('The resource ID of the API management service backend.')
output resourceId string = backend.id

@sys.description('The name of the API management service backend.')
output name string = backend.name

@sys.description('The resource group the API management service backend was deployed into.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

type backendCredentialsType = {
  @sys.description('Optional. Authorization header authentication.')
  authorization: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.credentials.authorization?
  @sys.description('Optional. List of Client Certificate Thumbprints. Will be ignored if certificatesIds are provided.')
  certificate: string[]?
  @sys.description('Optional. List of Client Certificate Ids.')
  certificateIds: string[]?
  // Each property within header is an array of strings in format
  // {customized property}: [
  //   'string'
  // ]
  @sys.description('Optional. Header Parameter description.')
  header: object?
  // Each property within query is an array of strings in format
  // {customized property}: [
  //   'string'
  // ]
  @sys.description('Optional. Query Parameter description.')
  query: object?
}

type backendProxyType = {
  @secure()
  @sys.description('Optional. Password to connect to the WebProxy Server.')
  password: string?
  @sys.description('Required. WebProxy Server AbsoluteUri property which includes the entire URI stored in the Uri instance, including all fragments and query strings.')
  @sys.minLength(1)
  @sys.maxLength(2000)
  url: string
  @sys.description('Optional. Username to connect to the WebProxy server.')
  username: string?
}

type backendServiceFabricClusterType = {
  @sys.description('Optional. The client certificate id for the management endpoint.')
  clientCertificateId: string?
  @sys.description('Optional. The client certificate thumbprint for the management endpoint. Will be ignored if certificatesIds are provided.')
  clientCertificatethumbprint: string?
  @sys.description('Required. The cluster management endpoint.')
  managementEndpoints: string[]
  @sys.description('Optional. Maximum number of retries while attempting resolve the partition.')
  maxPartitionResolutionRetries: int?
  @sys.description('Optional. Thumbprints of certificates cluster management service uses for tls communication.')
  serverCertificateThumbprints: string[]?
  @sys.description('Optional. Server X509 Certificate Names Collection.')
  serverX509Names: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.properties.serviceFabricCluster.serverX509Names?
}

type backendTlsType = {
  @sys.description('Optional. Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host.')
  validateCertificateChain: bool?
  @sys.description('Optional. Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host.')
  validateCertificateName: bool?
}

type backendCircuitBreakerType = {
  @sys.description('Optional. The rules for tripping the backend.')
  rules: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.circuitBreaker.rules?
}

type backendPoolType = {
  @sys.description('Optional. The list of backend entities belonging to a pool.')
  services: resourceInput<'Microsoft.ApiManagement/service/backends@2024-05-01'>.properties.pool.services?
}
