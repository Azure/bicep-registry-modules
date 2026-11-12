import { snapshotPolicyType } from '../../../main.bicep'
import { volumeType } from '../../../capacity-pool/main.bicep'

output snapshotPolicies snapshotPolicyType[] = [
  {
    name: 'single-day'
    weeklySchedule: {
      day: 'Monday'
      hour: 0
      minute: 0
      snapshotsToKeep: 1
    }
  }
  {
    name: 'multiple-days'
    weeklySchedule: {
      day: 'Monday,Tuesday'
      hour: 0
      minute: 0
      snapshotsToKeep: 2
    }
  }
  {
    name: 'all-week'
    weeklySchedule: {
      day: 'Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday'
      hour: 0
      minute: 0
      snapshotsToKeep: 7
    }
  }
]

output volumes volumeType[] = [
  {
    name: 'ldap-enabled'
    ldapEnabled: true
    availabilityZone: -1
    subnetResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/test/subnets/netapp'
    usageThreshold: 107374182400
  }
  {
    name: 'ldap-disabled'
    ldapEnabled: false
    availabilityZone: -1
    subnetResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/test/subnets/netapp'
    usageThreshold: 107374182400
  }
  {
    name: 'ldap-unspecified'
    availabilityZone: -1
    subnetResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/test/subnets/netapp'
    usageThreshold: 107374182400
  }
]
