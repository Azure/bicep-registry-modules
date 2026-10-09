metadata name = 'Exact tokens and numbered instances'
metadata description = 'Import naming functions without deploying a module. An exact seed follows Terraform naming behavior; instance and uniqueness tokens survive truncation.'

import { getName } from '../../../main.bicep'

@description('Required. Caller-owned uniqueness seed, reused for an in-place redeployment.')
param uniqueSeed string = 'a1b2c3d4'

var storage = getName('storage_account', {
  suffix: ['workload', 'dev']
  uniqueSeed: uniqueSeed
  instance: 1
  requireValidNames: true
})

@description('The candidate name and its diagnostics. A null name must not be used for a resource.')
output storageName object = storage
