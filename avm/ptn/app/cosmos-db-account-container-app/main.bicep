targetScope = 'resourceGroup'

metadata name = 'Azure Cosmos DB & Azure Container Apps - Web Application'
metadata description = 'This module deploys an n-teir web application to Azure Container Apps. The module also deploys a backing Azure Cosmos DB account with an account type switch. Options for Azure Cosmos DB include; NoSQL, Table, and MongoDB (RU). The web application uses the appropriate security best practices to connect the web application to the backing account.'

// ============== //
// Parameters     //
// ============== //

@description('Required. Alpha-numeric component to use for resource naming. The name must be between 3 and 6 characters in length. The name of resources created by this pattern are based on the Cloud Adoption Framework baseline naming convention. Resources will be named using the following pattern: <resource-type>-<name>-<location>-<instance>. For example, if the value specified for this parameter is "demoapp", a single Azure Container App environment deployed to West US 2 would be named "cae-demoapp-westus2-001". For more information, see https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming.')
@minLength(3)
@maxLength(15)
param name string

@description('Optional. The location where to deploy all resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Resource tags.')
param tags object?

@description('Optional. The settings for the Azure Cosmos DB account. If not specified, the pattern will deploy a single Azure Cosmos DB for NoSQL account with a database and container.')
param database azureCosmosDBAccountType?

@description('Optional. The settings for the Azure Container Apps and Azure Container Registry resources. If not specified, the pattern will deploy a single web application as a default.')
param web azureContainerAppsEnvType?

// ============== //
// Resources     //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.ptn.app-cosmosdbaccountcontainerapp.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
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

module userAssignedManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  params: {
    name: 'id-${name}-${location}-001'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = if ((web.?enableLogAnalytics ?? false) || (database.?enableLogAnalytics ?? false)) {
  params: {
    name: 'log-${name}-${location}-001'
    location: location
    tags: tags != null ? union(tags ?? {}, web.?tags ?? {}) : web.?tags ?? null
    enableTelemetry: enableTelemetry
  }
}

module azureContainerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.11.2' = {
  params: {
    name: 'cae-${name}-${location}-001'
    location: location
    tags: tags != null ? union(tags ?? {}, web.?tags ?? {}) : web.?tags ?? null
    enableTelemetry: enableTelemetry
    zoneRedundant: web.?zoneRedundant ?? true
    internal: web.?virtualNetworkSubnetResourceId != null
    infrastructureSubnetResourceId: web.?virtualNetworkSubnetResourceId ?? null
    publicNetworkAccess: web.?publicNetworkAccessEnabled ?? false ? 'Enabled' : 'Disabled'
    appLogsConfiguration: web.?enableLogAnalytics ?? false
      ? {
          destination: 'log-analytics'
          logAnalyticsConfiguration: {
            customerId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
            sharedKey: logAnalyticsWorkspace.outputs.primarySharedKey
          }
        }
      : null
  }
}

module azureContainerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  params: {
    name: 'cr${name}${location}001'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: web.?publicNetworkAccessEnabled ?? false ? 'Enabled' : 'Disabled'
    acrSku: 'Standard'
    roleAssignments: union(
      [
        {
          principalId: userAssignedManagedIdentity.outputs.principalId
          roleDefinitionIdOrName: '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
        }
      ],
      map(web.?additionalRoleBasedAccessControlPrincipals ?? [], (principal) => {
        principalId: principal
        roleDefinitionIdOrName: '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPush
      })
    )
  }
}

func sanitizeName(name string) string => toLower(replace(replace(name, '__', '_'), '_', '-'))

var tiersList = map(web.?tiers ?? [{ name: '' }], wt => wt.name)

module azureContainerAppsApp 'br/public:avm/res/app/container-app:0.16.0' = [
  for (tier, index) in web.?tiers ?? [{}]: {
    params: {
      name: 'ca-${name}-${location}-${format('{0:000}', index + 1)}'
      location: location
      tags: tags != null ? union(tags ?? {}, tier.?tags ?? {}) : tier.?tags ?? null
      enableTelemetry: enableTelemetry
      environmentResourceId: azureContainerAppsEnvironment.outputs.resourceId
      ingressTargetPort: tier.?port ?? 80
      ingressExternal: tier.?allowIngress ?? false
      stickySessionsAffinity: 'sticky'
      corsPolicy: {
        allowCredentials: true
        allowedOrigins: [
          '*'
        ]
      }
      managedIdentities: tier.?useManagedIdentity ?? false
        ? {
            systemAssigned: false
            userAssignedResourceIds: [
              userAssignedManagedIdentity.outputs.resourceId
            ]
          }
        : null
      registries: tier.?useManagedIdentity ?? false
        ? [
            {
              server: azureContainerRegistry.outputs.loginServer
              identity: userAssignedManagedIdentity.outputs.resourceId
            }
          ]
        : []
      secrets: union(
        tier.?useManagedIdentity ?? false
          ? [
              {
                name: 'managed-identity-client-id'
                value: userAssignedManagedIdentity.outputs.clientId
              }
            ]
          : [],
        map(tier.?environment ?? [], (env) => {
          name: sanitizeName(env.name)
          value: env.?tierEndpoint != null
            ? format(
                env.?format ?? '{0}',
                'http://${'ca-${name}-${location}-${format('{0:000}', indexOf(tiersList, env.?tierEndpoint) + 1)}'}'
              )
            : env.?knownValue != null
                ? {
                    AzureCosmosDBEndpoint: azureCosmosDBAccount.outputs.endpoint
                    ManagedIdentityClientId: userAssignedManagedIdentity.outputs.clientId
                  }[env.knownValue]
                : env.value ?? ''
        })
      )
      containers: [
        {
          name: tier.?name ?? 'container'
          image: tier.?image ?? 'nginx:latest'
          resources: {
            cpu: tier.?cpu ?? '0.5'
            memory: tier.?memory ?? '1.0Gi'
          }
          env: union(
            tier.?useManagedIdentity ?? false
              ? [
                  {
                    name: 'AZURE_CLIENT_ID'
                    secretRef: 'managed-identity-client-id'
                  }
                ]
              : [],
            map(tier.?environment ?? [], (env) => {
              name: env.name
              secretRef: sanitizeName(env.name)
            })
          )
        }
      ]
    }
  }
]

var primaryLocation = {
  failoverPriority: 0
  isZoneRedundant: database.?zoneRedundant ?? false
  locationName: location
}

var replicaLocations = [
  for (addditionalLocation, index) in database.?additionalLocations ?? []: {
    failoverPriority: index + 1
    isZoneRedundant: database.?zoneRedundant ?? false
    locationName: addditionalLocation
  }
]

module azureCosmosDBAccount 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: '${uniqueString(deployment().name, location)}-azure-cosmos-db-account'
  params: {
    name: 'cosno-${name}-${location}-001'
    location: empty(replicaLocations) ? location : null
    failoverLocations: !empty(replicaLocations) ? union([primaryLocation], replicaLocations) : null
    tags: tags != null ? union(tags ?? {}, database.?tags ?? {}) : database.?tags ?? null
    enableTelemetry: enableTelemetry
    capabilitiesToAdd: union(
      database.?serverless ?? true
        ? [
            'EnableServerless'
          ]
        : [],
      database.?type == 'Table'
        ? [
            'EnableTable'
          ]
        : []
    )
    zoneRedundant: database.?zoneRedundant ?? true
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: database.?publicNetworkAccessEnabled ?? false ? 'Enabled' : 'Disabled'
    }
    disableKeyBasedMetadataWriteAccess: true
    disableLocalAuthentication: true
    automaticFailover: true
    minimumTlsVersion: 'Tls12'
    dataPlaneRoleDefinitions: [
      {
        roleName: 'nosql-data-plane-contributor'
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
        ]
        assignments: union(
          [
            {
              principalId: userAssignedManagedIdentity.outputs.principalId
            }
          ],
          map(database.?additionalRoleBasedAccessControlPrincipals ?? [], (principal) => {
            principalId: principal
          })
        )
      }
    ]
    diagnosticSettings: database.?enableLogAnalytics ?? false
      ? [
          {
            workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
          }
        ]
      : null
    tables: database.?type == 'Table'
      ? map(
          flatten(map(
            database.?databases ?? [],
            (database, databaseIndex) =>
              map(
                database.?containers ?? [],
                (container, containerIndex) =>
                  ({
                    container: container
                    databaseIndex: databaseIndex
                    containerIndex: containerIndex
                  })
              )
          )) ?? [],
          (table) => {
            name: table.container.?name ?? 'table-${format('{0:000}', table.databaseIndex + 1)}-${format('{0:000}', table.containerIndex + 1)}'
            throughput: database.?serverless ?? true ? 400 : null
          }
        )
      : null
    sqlDatabases: (database.?type ?? 'NoSQL') == 'NoSQL'
      ? map(database.?databases ?? [], (database, databaseIndex) => {
          name: database.?name ?? 'database-${format('{0:000}', databaseIndex + 1)}'
          containers: map(database.?containers ?? [], (container, containerIndex) => {
            name: container.?name ?? 'database-${format('{0:000}', databaseIndex + 1)}-container-${format('{0:000}', containerIndex + 1)}'
            kind: length(container.?partitionKeys ?? ['']) >= 2 ? 'MultiHash' : 'Hash'
            version: length(container.?partitionKeys ?? ['']) >= 2 ? 2 : 1
            throughput: database.?serverless ?? true ? 400 : null
            paths: container.?partitionKeys ?? [
              '/id'
            ]
          })
        })
      : null
  }
}

module deploymentScript 'br/public:avm/res/resources/deployment-script:0.5.1' = if (database.?type == 'NoSQL') {
  params: {
    name: 'ds-${name}-${location}-001'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    kind: 'AzurePowerShell'
    azPowerShellVersion: '13.4'
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedManagedIdentity.outputs.resourceId
      ]
    }
    runOnce: true
    scriptContent: join(
      union(
        [
          'apt-get update'
          'apt-get install -y dotnet-sdk-8.0'
          'dotnet new tool-manifest'
          'dotnet tool install --prerelease cosmicworks'
        ],
        map(
          filter(
            flatten(map(
              database.?databases ?? [],
              (db, dbIdx) =>
                map(
                  db.?containers ?? [],
                  (container, containerIdx) =>
                    ({
                      databaseName: db.?name ?? 'database-${format('{0:000}', dbIdx + 1)}'
                      containerName: container.?name ?? 'database-${format('{0:000}', dbIdx + 1)}-container-${format('{0:000}', containerIdx + 1)}'
                      seed: container.?seed
                    })
                )
            )),
            (c, i) => c.?seed != null
          ),
          container =>
            'dotnet tool run cosmicworks generate ${replace(container.seed, 'cosmicworks-','')} --disable-formatting --hide-credentials --endpoint \${Env:ACCOUNT_ENDPOINT} --database-name ${container.databaseName} --container-name ${container.containerName}'
        )
      ),
      '\n'
    )
    environmentVariables: [
      {
        name: 'ACCOUNT_ENDPOINT'
        secureValue: azureCosmosDBAccount.outputs.endpoint
      }
    ]
    cleanupPreference: 'OnSuccess'
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Azure Cosmos DB account.')
output resourceId string = azureCosmosDBAccount.outputs.resourceId

@description('The name of the Azure Cosmos DB account.')
output name string = azureCosmosDBAccount.outputs.name

@description('The name of the Resource Group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The endpoint for the Azure Container Registry resource.')
output azureContainerRegistryEndpoint string = azureContainerRegistry.outputs.loginServer

@description('The endpoint for the Azure Cosmos DB account.')
output azureCosmosDBEndpoint string = azureCosmosDBAccount.outputs.endpoint

// ================ //
// Definitions      //
// ================ //

@export()
@description('Type that contains settings for an Azure Container Apps web application environment.')
type azureContainerAppsEnvType = {
  @description('Optional. Resource tags specific to the Azure Container Apps environment.')
  tags: object?

  @description('Optional. The settings for the tiers/apps in the environment. Defaults to a single default web application tier.')
  tiers: azureContainerAppsTierType[]?

  @description('Optional. Indicates whether the environment is zone redundant. Defaults to false. If this property is set to true, the environment must be configured with a virtual network.')
  zoneRedundant: bool?

  @description('Optional. Indicates whether the environment is configured with a paired Azure Log Analytics workspace. Defaults to false. If true, the workspace will be automatically created.')
  enableLogAnalytics: bool?

  @description('Optional. The resource ID of the virtual network subnet to use for the environment. Is not set by default. This property is required if zoneRedundant is set to true.')
  virtualNetworkSubnetResourceId: string?

  @description('Optional. Whether requests from the public network are allowed. Defaults to true.')
  publicNetworkAccessEnabled: bool?

  @description('Optional. List of additional role-based access control principals to assign the same role as the managed identity of the environment. For example, you can assign "deployer().objectId" to grant yourself RBAC permissions to the resource. Defaults to an empty array.')
  additionalRoleBasedAccessControlPrincipals: string[]?
}

@export()
@description('Type that contains settings for an Azure Container Apps web application tier/app.')
type azureContainerAppsTierType = {
  @description('Optional. Resource tags specific to the Azure Container Apps instance.')
  tags: object?

  @description('Optional. The name of the tier/app. Defaults to "container".')
  name: string?

  @description('Optional. The port to expose for ingress. Defaults to 80.')
  port: int?

  @description('Optional. The image to use for the container. Defaults to "nginx:latest".')
  image: string?

  @description('Optional. The settings for the environment variables for the container. Defaults to an empty array.')
  environment: azureContainerAppsTierEnvironmentType[]?

  @description('Optional. Whether to use a managed identity for the container. Defaults to false.')
  useManagedIdentity: bool?

  @description('Optional. The amount of CPU (in cores) to allocate to the container. Defaults to "0.5".')
  cpu: string?

  @description('Optional. The amount of memory (in Gi) to allocate to the container. Defaults to "1.0".')
  memory: string?

  @description('Optional. Whether to allow ingress to the container. Defaults to false.')
  allowIngress: bool?
}

@export()
@description('Type that contains environment variables for an Azure Container Apps web application tier/app.')
type azureContainerAppsTierEnvironmentType = {
  @description('Required. The name of the environment variable.')
  name: string

  @description('Optional. The plain-text value of the environment variable. This property is ignored if the value is not set.')
  value: string?

  @description('Optional. Sets a well-known value for the environment variable. This property takes precedence over `value`. This property is ignored if the value is not set.')
  knownValue: 'AzureCosmosDBEndpoint' | 'ManagedIdentityClientId'?

  @description('Optional. Selects a tier endpoint to use for the environment variable. This property takes precedence over `knownValue` and `value`. This property is ignored if the value is not set.')
  tierEndpoint: string?

  @description('Optional. The string format expression to use for the environment variable value. This property is ignored if the value is not set.')
  format: string?
}

@export()
@description('Type that contains settings for an Azure Cosmos DB account.')
type azureCosmosDBAccountType = {
  @description('Required. The type (API) of the account. Defaults to "NoSQL". Valid values are "NoSQL" and "Table".')
  type: 'NoSQL' | 'Table'

  @description('Optional. Resource tags specific to the Azure Cosmos DB account.')
  tags: object?

  @description('Optional. Additional locations for the account. Defaults to an empty array.')
  additionalLocations: string[]?

  @description('Optional. The settings for the databases in the accounts. Defaults to an empty array.')
  databases: azureCosmosDBDatabaseType[]?

  @description('Optional. Indicates if the account is serverless. Defaults to true.')
  serverless: bool?

  @description('Optional. Indicates whether the single-region account is zone redundant. Defaults to false. This property is ignored for multi-region accounts.')
  zoneRedundant: bool?

  @description('Optional. Whether requests from the public network are allowed. Defaults to true.')
  publicNetworkAccessEnabled: bool?

  @description('Optional. Indicates whether the account is configured with a paired Azure Log Analytics workspace. Defaults to false. If true, the account will be automatically created.')
  enableLogAnalytics: bool?

  @description('Optional. List of additional role-based access control principals to assign the same role as the managed identity of the environment. For example, you can assign "deployer().objectId" to grant yourself RBAC permissions to the resource. Defaults to an empty array.')
  additionalRoleBasedAccessControlPrincipals: string[]?
}

@export()
@description('Type that contains settings for an Azure Cosmos DB database.')
type azureCosmosDBDatabaseType = {
  @description('Optional. The name of the database.')
  name: string?

  @description('Optional. The settings for the child containers.')
  containers: azureCosmosDBContainerType[]?
}

@export()
@description('Type that contains settings for an Azure Cosmos DB container.')
type azureCosmosDBContainerType = {
  @description('Optional. The name of the container.')
  name: string?

  @description('Optional. The partition keys for the container. Defaults to `[ "/id" ]`.')
  partitionKeys: string[]?

  @description('Optional. Specifies the seed data to use for the container. Defaults to not set. The seed operation is not performed if this property is not set. Valid values are "cosmicworks-products" and "cosmicworks-employees".')
  seed: 'cosmicworks-products' | 'cosmicworks-employees'?
}
