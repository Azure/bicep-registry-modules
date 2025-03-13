param authenticationType string
param endpointUri string?
param entityPath string?
@secure()
param primaryConnectionString string?

@secure()
param secondaryConnectionString string?

output authenticationTypeOutput string = authenticationType
output endpointUriOutput string? = endpointUri
output entityPathOutput string? = entityPath
output primaryConnectionStringOutput string? = primaryConnectionString
output secondaryConnectionStringOutput string? = secondaryConnectionString
