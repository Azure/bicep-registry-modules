
### Parameter Usage: `localNetworkGateway2`

The local virtual network gateway object.

<details>

<summary>Parameter JSON format</summary>

```json
"localNetworkGateway2": {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
localNetworkGateway2: {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway'
}
```

</details>
<p>

### Parameter Usage: `peer`

The remote peer object used for ExpressRoute connections

<details>

<summary>Parameter JSON format</summary>

```json
"peer": {
    "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'peer': {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute'
}
```

</details>
<p>

### Parameter Usage: `customIPSecPolicy`

If ipsecEncryption parameter is empty, customIPSecPolicy will not be deployed. The parameter file should look like below.

<details>

<summary>Parameter JSON format</summary>

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 0,
        "saDataSizeKilobytes": 0,
        "ipsecEncryption": "",
        "ipsecIntegrity": "",
        "ikeEncryption": "",
        "ikeIntegrity": "",
        "dhGroup": "",
        "pfsGroup": ""
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 0
    saDataSizeKilobytes: 0
    ipsecEncryption: ''
    ipsecIntegrity: ''
    ikeEncryption: ''
    ikeIntegrity: ''
    dhGroup: ''
    pfsGroup: ''
}
```

</details>
<p>

Format of the full customIPSecPolicy parameter in parameter file.

<details>

<summary>Parameter JSON format</summary>

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 28800,
        "saDataSizeKilobytes": 102400000,
        "ipsecEncryption": "AES256",
        "ipsecIntegrity": "SHA256",
        "ikeEncryption": "AES256",
        "ikeIntegrity": "SHA256",
        "dhGroup": "DHGroup14",
        "pfsGroup": "None"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 28800
    saDataSizeKilobytes: 102400000
    ipsecEncryption: 'AES256'
    ipsecIntegrity: 'SHA256'
    ikeEncryption: 'AES256'
    ikeIntegrity: 'SHA256'
    dhGroup: 'DHGroup14'
    pfsGroup: 'None'
}
```

</details>
<p>

