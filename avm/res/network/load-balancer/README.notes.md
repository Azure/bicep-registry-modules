
### Parameter Usage: `backendAddressPools`

The following example represents three different configurations for backendAddressPools:

- `BackendNICPool` - Network Interface deployments.
- `BackendIPPool` - Represents the assignment of IP addresses to a backend address pool.
- `BackendUnassociatedPool` - Represents a backend address pool that doesn't currently have any resources like a backend address or Network Interface assigned.

`NOTE` - Each of the backend address pools have a new parameter called `backendMembershipMode` which is used with the AVM module to assist in resolving idempotency issues.

<details>

<summary>Bicep format</summary>

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

</details>
<p>

