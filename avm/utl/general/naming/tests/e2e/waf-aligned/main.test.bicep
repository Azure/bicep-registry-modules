metadata name = 'Caller-owned deployment identity'
metadata description = 'Reuse identity and scope for in-place retries. Change freshAttempt deliberately for a separate deployment. No state or randomness is created by this utility.'

import { getName } from '../../../main.bicep'

@description('Required. Stable caller-owned identity for this logical deployment.')
param namingIdentity string = 'local-development-001'

@description('Required. Caller-owned scope that separates otherwise identical deployments.')
param namingScope string = 'subscription-001'

@description('Optional. Change deliberately to produce a fresh name; reuse during in-place retries.')
param freshAttempt string = ''

var storage = getName('storage_account', {
  suffix: ['workload', 'dev']
  uniqueIdentity: namingIdentity
  uniqueScope: namingScope
  uniqueAttempt: freshAttempt
  uniqueLength: 13
  requireValidNames: true
})

@description('The candidate name and its diagnostics. Name availability in Azure is not checked.')
output storageName object = storage
