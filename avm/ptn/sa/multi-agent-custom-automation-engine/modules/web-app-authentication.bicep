resource entraIdApplication 'Microsoft.Graph/applications@v1.0' = if (entraIdApplicationConfiguration.?enabled!) {
  displayName: '${webSiteName}-app'
  uniqueName: '${webSiteName}-app-${uniqueString(resourceGroup().id, webSiteName)}'
  description: 'EntraId Application for ${webSiteName} authentication'
  passwordCredentials: [
    {
      displayName: 'Credential for website ${webSiteName}'
      endDateTime: dateTimeAdd(deploymentTime, 'P180D')
      // keyId: 'string'
      // startDateTime: 'string'
    }
  ]
}

var graphAppId = '00000003-0000-0000-c000-000000000000' //Microsoft Graph ID
// Get the Microsoft Graph service principal so that the scope names can be looked up and mapped to a permission ID
resource msGraphSP 'Microsoft.Graph/servicePrincipals@v1.0' existing = {
  appId: graphAppId
}

// ========== Entra ID Service Principal ========== //
resource entraIdServicePrincipal 'Microsoft.Graph/servicePrincipals@v1.0' = if (entraIdApplicationConfiguration.?enabled!) {
  appId: entraIdApplication.appId
}

// Grant the OAuth2.0 scopes (requested in parameters) to the basic app, for all users in the tenant
resource graphScopesAssignment 'Microsoft.Graph/oauth2PermissionGrants@v1.0' = if (entraIdApplicationConfiguration.?enabled!) {
  clientId: entraIdServicePrincipal.id
  resourceId: msGraphSP.id
  consentType: 'AllPrincipals'
  scope: 'User.Read'
}

module webSite 'br/public:avm/res/web/site:0.16.0' = if (webSiteEnabled) {
  name: take('avm.res.web.site.${webSiteName}', 64)
  params: {
    name: webSiteName
    location: webSiteConfiguration.?location ?? solutionLocation
    tags: webSiteConfiguration.?tags ?? tags
    kind: 'app,linux,container'
    serverFarmResourceId: webSiteConfiguration.?environmentResourceId ?? webServerFarm.?outputs.resourceId
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    siteConfig: {
      linuxFxVersion: 'DOCKER|${webSiteConfiguration.?containerImageRegistryDomain ?? 'biabcontainerreg.azurecr.io'}/${webSiteConfiguration.?containerImageName ?? 'macaefrontend'}:${webSiteConfiguration.?containerImageTag ?? 'fnd01'}'
    }
    publicNetworkAccess: 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
    configs: [
      {
        name: 'appsettings'
        applicationInsightResourceId: applicationInsights.outputs.resourceId
        properties: union(
          {
            SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
            DOCKER_REGISTRY_SERVER_URL: 'https://${webSiteConfiguration.?containerImageRegistryDomain ?? 'biabcontainerreg.azurecr.io'}'
            WEBSITES_PORT: '3000'
            WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
            BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
            AUTH_ENABLED: 'false'
          },
          (entraIdApplicationConfiguration.?enabled!
            ? {
                '${entraIdApplicationCredentialSecretSettingName}': entraIdApplication.passwordCredentials[0].secretText
              }
            : {})
        )
      }
      {
        name: 'authsettingsV2'
        properties: {
          platform: {
            enabled: entraIdApplicationConfiguration.?enabled!
            runtimeVersion: '~1'
          }
          login: {
            cookieExpiration: {
              convention: 'FixedTime'
              timeToExpiration: '08:00:00'
            }
            nonce: {
              nonceExpirationInterval: '00:05:00'
              validateNonce: true
            }
            preserveUrlFragmentsForLogins: false
            routes: {}
            tokenStore: {
              azureBlobStorage: {}
              enabled: true
              fileSystem: {}
              tokenRefreshExtensionHours: 72
            }
          }
          globalValidation: {
            requireAuthentication: true
            unauthenticatedClientAction: 'RedirectToLoginPage'
            redirectToProvider: 'azureactivedirectory'
          }
          httpSettings: {
            forwardProxy: {
              convention: 'NoProxy'
            }
            requireHttps: true
            routes: {
              apiPrefix: '/.auth'
            }
          }
          identityProviders: {
            azureActiveDirectory: entraIdApplicationConfiguration.?enabled!
              ? {
                  isAutoProvisioned: true
                  enabled: true
                  login: {
                    disableWWWAuthenticate: false
                  }
                  registration: {
                    clientId: entraIdApplication.appId //create application in AAD
                    clientSecretSettingName: entraIdApplicationCredentialSecretSettingName
                    openIdIssuer: 'https://sts.windows.net/${tenant().tenantId}/v2.0/'
                  }
                  validation: {
                    allowedAudiences: [
                      'api://${entraIdApplication.appId}'
                    ]
                    defaultAuthorizationPolicy: {
                      allowedPrincipals: {}
                      allowedApplications: ['86e2d249-6832-461f-8888-cfa0394a5f8c']
                    }
                    jwtClaimChecks: {}
                  }
                }
              : {}
          }
        }
      }
    ]
  }
}
