# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/load-balancer/CHANGELOG.md).

## 0.6.0

### Changes

- Added functionality to support the creation of public IP addresses and public IP prefixes in load balancer `frontendIPconfigurations`. This new functionality utilizes the AVM modules for `public-ip-address` and `public-ip-prefix`
- Introduced new test cases for public IP address and public IP prefix creation in the load balancer module.

### Breaking Changes

- Changed the following parameter names to comply with AVM naming standards for resource IDs:
- publicIPAddressId changed to publicIPAddressResourceId
- subnetId changed to subnetResourceId

## 0.5.0

### Changes

- Added new parameter "backendMembershipMode" to address idempotency issues with load balancers and NICs assigned to backend address pools.

### Breaking Changes

- The new parameter "backendMembershipMode" will need to be set to avoid any issues with backend address pools and NIC deployments. Here is an example of backend address pool settings for the three backendMembership modes: "None", "NIC", and "BackendAddress"

```bicep
backendAddressPools: [
      {
        name: 'BackendNICPool'
        backendMembershipMode: 'NIC'
      }
      {
        name: 'BackendIPPool'
        backendMembershipMode: 'BackendAddress'
        loadBalancerBackendAddresses: [
          {
            name: 'addr1'
            properties: {
              virtualNetwork: {
                id: virtualNetwork.id
              }
              ipAddress: '10.0.2.52'
            }
          }
          {
            name: 'addr2'
            properties: {
              virtualNetwork: {
                id: virtualNetwork.id
              }
              ipAddress: '10.0.2.53'
            }
          }
        ]
      }
      {
        name: 'BackendUnassociatedPool'
        backendMembershipMode: 'None'
      }
    ]
```

## 0.4.3

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated Loadbalancer API versions.
- Added support for virtual networks on BackendAddressPools

### Breaking Changes

- None

## 0.4.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
