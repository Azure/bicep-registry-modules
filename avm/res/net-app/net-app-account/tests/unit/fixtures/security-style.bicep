import { capacityPoolType } from '../../../main.bicep'
import { volumeType } from '../../../capacity-pool/main.bicep'

var testVolumes volumeType[] = [
  {
    name: 'ntfs-volume'
    securityStyle: 'ntfs'
    availabilityZone: -1
    subnetResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/test/subnets/netapp'
    usageThreshold: 107374182400
  }
  {
    name: 'unix-volume'
    securityStyle: 'unix'
    availabilityZone: -1
    subnetResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/test/subnets/netapp'
    usageThreshold: 107374182400
  }
  {
    name: 'default-volume'
    availabilityZone: -1
    subnetResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/test/providers/Microsoft.Network/virtualNetworks/test/subnets/netapp'
    usageThreshold: 107374182400
  }
]

output volumes volumeType[] = testVolumes

output capacityPools capacityPoolType[] = [
  {
    name: 'security-style-pool'
    size: 1
    volumes: testVolumes
  }
]
