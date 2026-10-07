// Compile-only compatibility fixtures: these caller-owned types intentionally have no secure decorators.
// Production callers should secure credentials at their own deployment boundary too.
import { namedValueType as workspaceNamedValueType } from '../../../../../avm/res/api-management/service/workspace/main.bicep'

param suppliedNamedValue workspaceNamedValueType
param existingValue string
param existingCertificate existingCertificateType
param existingPolicy existingPolicyType
param existingPolicies existingPolicyType[]
param existingSubscription existingSubscriptionType
param existingSubscriptions existingSubscriptionType[]
param existingWorkspaces existingWorkspaceType[]
param existingNamedValues existingNamedValueType[]

type existingCertificateType = {
  name: string?
  certificateValue: string?
}

type existingPolicyType = {
  name: string
  storageAccountAccessKey: string?
}

type existingSubscriptionType = {
  name: string
  displayName: string
  primaryKey: string?
  secondaryKey: string?
}

type existingWorkspaceType = {
  name: string
  displayName: string
  gateway: {
    name: string
  }
  subscriptions: existingSubscriptionType[]?
  namedValues: existingNamedValueType[]?
}

type existingNamedValueType = {
  name: string
  displayName: string
  value: string?
}

var namedValues = concat(existingNamedValues, [
  suppliedNamedValue
  {
    name: 'supplied'
    displayName: 'supplied'
    value: existingValue
  }
  {
    name: 'null'
    displayName: 'null'
    value: null
  }
  {
    name: 'omitted'
    displayName: 'omitted'
  }
])

var certificates = [
  existingCertificate
  {
    certificateValue: existingValue
  }
  {
    certificateValue: null
  }
  {}
]

var policies = concat(existingPolicies, [
  existingPolicy
  {
    name: 'Default'
    storageAccountAccessKey: existingValue
  }
  {
    name: 'Default'
    storageAccountAccessKey: null
  }
  {
    name: 'Default'
  }
])

var subscriptions = concat(existingSubscriptions, [
  existingSubscription
  {
    name: 'supplied'
    displayName: 'Supplied keys'
    primaryKey: existingValue
    secondaryKey: existingValue
  }
  {
    name: 'null'
    displayName: 'Null keys'
    primaryKey: null
    secondaryKey: null
  }
  {
    name: 'omitted'
    displayName: 'Omitted keys'
  }
])

module certificateParents '../../../../../avm/res/app/managed-environment/main.bicep' = [
  for (certificate, index) in certificates: {
    name: 'certificate-parent-${index}'
    params: {
      name: 'credential-test-environment'
      certificate: certificate
    }
  }
]

module certificateChild '../../../../../avm/res/app/managed-environment/certificate/main.bicep' = {
  name: 'certificate-child'
  params: {
    name: 'supplied'
    managedEnvironmentName: 'credential-test-environment'
    certificateValue: existingValue
  }
}

module sqlParent '../../../../../avm/res/sql/server/main.bicep' = {
  name: 'sql-parent'
  params: {
    name: 'credential-test-server'
    securityAlertPolicies: policies
  }
}

module policyChild '../../../../../avm/res/sql/server/security-alert-policy/main.bicep' = {
  name: 'policy-child'
  params: {
    name: 'Default'
    serverName: 'credential-test-server'
    storageAccountAccessKey: existingValue
  }
}

module serviceParent '../../../../../avm/res/api-management/service/main.bicep' = {
  name: 'service-parent'
  params: {
    name: 'credential-test-service'
    publisherEmail: 'test@example.com'
    publisherName: 'Credential test'
    subscriptions: subscriptions
    workspaces: concat(existingWorkspaces, [
      {
        name: 'supplied'
        displayName: 'Supplied workspace'
        gateway: {
          name: 'supplied-gateway'
        }
        subscriptions: subscriptions
        namedValues: namedValues
      }
    ])
  }
}

module workspaceParent '../../../../../avm/res/api-management/service/workspace/main.bicep' = {
  name: 'workspace-parent'
  params: {
    apiManagementServiceName: 'credential-test-service'
    name: 'supplied'
    displayName: 'Supplied workspace'
    gateway: {
      name: 'supplied-gateway'
    }
    subscriptions: subscriptions
    namedValues: namedValues
  }
}

module workspaceNamedValueChild '../../../../../avm/res/api-management/service/workspace/named-value/main.bicep' = {
  name: 'workspace-named-value-child'
  params: {
    apiManagementServiceName: 'credential-test-service'
    workspaceName: 'supplied'
    name: 'supplied'
    displayName: 'supplied'
    value: existingValue
  }
}

module subscriptionChild '../../../../../avm/res/api-management/service/subscription/main.bicep' = {
  name: 'subscription-child'
  params: {
    apiManagementServiceName: 'credential-test-service'
    name: 'supplied'
    displayName: 'Supplied keys'
    primaryKey: existingValue
    secondaryKey: existingValue
  }
}

module workspaceSubscriptionChild '../../../../../avm/res/api-management/service/workspace/subscription/main.bicep' = {
  name: 'workspace-subscription-child'
  params: {
    apiManagementServiceName: 'credential-test-service'
    workspaceName: 'supplied'
    name: 'supplied'
    displayName: 'Supplied keys'
    primaryKey: existingValue
    secondaryKey: existingValue
  }
}

module nullCertificate '../../../../../avm/res/app/managed-environment/main.bicep' = {
  name: 'null-certificate'
  params: {
    name: 'credential-test-environment'
    certificate: null
  }
}

module omittedCertificate '../../../../../avm/res/app/managed-environment/main.bicep' = {
  name: 'omitted-certificate'
  params: {
    name: 'credential-test-environment'
  }
}

module nullPolicies '../../../../../avm/res/sql/server/main.bicep' = {
  name: 'null-policies'
  params: {
    name: 'credential-test-server'
    securityAlertPolicies: null
  }
}

module omittedPolicies '../../../../../avm/res/sql/server/main.bicep' = {
  name: 'omitted-policies'
  params: {
    name: 'credential-test-server'
  }
}

module nullSubscriptions '../../../../../avm/res/api-management/service/main.bicep' = {
  name: 'null-subscriptions'
  params: {
    name: 'credential-test-service'
    publisherEmail: 'test@example.com'
    publisherName: 'Credential test'
    subscriptions: null
    workspaces: null
  }
}

module omittedSubscriptions '../../../../../avm/res/api-management/service/main.bicep' = {
  name: 'omitted-subscriptions'
  params: {
    name: 'credential-test-service'
    publisherEmail: 'test@example.com'
    publisherName: 'Credential test'
  }
}

module nullWorkspaceSubscriptions '../../../../../avm/res/api-management/service/workspace/main.bicep' = {
  name: 'null-workspace-subscriptions'
  params: {
    apiManagementServiceName: 'credential-test-service'
    name: 'supplied'
    displayName: 'Supplied workspace'
    gateway: {
      name: 'supplied-gateway'
    }
    subscriptions: null
    namedValues: null
  }
}

module omittedWorkspaceSubscriptions '../../../../../avm/res/api-management/service/workspace/main.bicep' = {
  name: 'omitted-workspace-subscriptions'
  params: {
    apiManagementServiceName: 'credential-test-service'
    name: 'supplied'
    displayName: 'Supplied workspace'
    gateway: {
      name: 'supplied-gateway'
    }
  }
}
