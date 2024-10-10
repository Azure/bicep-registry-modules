# VPN Server Configuration `[Microsoft.Network/vpnServerConfigurations]`

This module deploys a VPN Server Configuration for a Virtual Hub P2S Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Network/vpnServerConfigurations` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/vpnServerConfigurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/vpn-server-configuration:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:<version>' = {
  name: 'vpnServerConfigurationDeployment'
  params: {
    // Required parameters
    name: 'vscminVPNConfig'
    // Non-required parameters
    aadAudience: '11111111-1234-4321-1234-111111111111'
    aadIssuer: 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
    aadTenant: 'https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111'
    location: '<location>'
    p2sConfigurationPolicyGroups: [
      {
        isDefault: 'true'
        policymembers: [
          {
            attributeType: 'AADGroupId'
            attributeValue: '11111111-1111-2222-3333-111111111111'
            name: 'UserGroup1'
          }
        ]
        priority: '0'
        userVPNPolicyGroupName: 'DefaultGroup'
      }
    ]
    vpnAuthenticationTypes: [
      'AAD'
    ]
    vpnProtocols: [
      'OpenVPN'
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "vscminVPNConfig"
    },
    // Non-required parameters
    "aadAudience": {
      "value": "11111111-1234-4321-1234-111111111111"
    },
    "aadIssuer": {
      "value": "https://sts.windows.net/11111111-1111-1111-1111-111111111111/"
    },
    "aadTenant": {
      "value": "https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111"
    },
    "location": {
      "value": "<location>"
    },
    "p2sConfigurationPolicyGroups": {
      "value": [
        {
          "isDefault": "true",
          "policymembers": [
            {
              "attributeType": "AADGroupId",
              "attributeValue": "11111111-1111-2222-3333-111111111111",
              "name": "UserGroup1"
            }
          ],
          "priority": "0",
          "userVPNPolicyGroupName": "DefaultGroup"
        }
      ]
    },
    "vpnAuthenticationTypes": {
      "value": [
        "AAD"
      ]
    },
    "vpnProtocols": {
      "value": [
        "OpenVPN"
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-server-configuration:<version>'

// Required parameters
param name = 'vscminVPNConfig'
// Non-required parameters
param aadAudience = '11111111-1234-4321-1234-111111111111'
param aadIssuer = 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
param aadTenant = 'https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111'
param location = '<location>'
p2sConfigurationPolicyGroups: [
  {
    isDefault: 'true'
    policymembers: [
      {
        attributeType: 'AADGroupId'
        attributeValue: '11111111-1111-2222-3333-111111111111'
        name: 'UserGroup1'
      }
    ]
    priority: '0'
    userVPNPolicyGroupName: 'DefaultGroup'
  }
]
param vpnAuthenticationTypes = [
  'AAD'
]
param vpnProtocols = [
  'OpenVPN'
]
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:<version>' = {
  name: 'vpnServerConfigurationDeployment'
  params: {
    // Required parameters
    name: 'vscmaxVPNConfig'
    // Non-required parameters
    aadAudience: '11111111-1234-4321-1234-111111111111'
    aadIssuer: 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
    aadTenant: 'https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111'
    location: '<location>'
    p2sConfigurationPolicyGroups: [
      {
        isDefault: 'true'
        policymembers: [
          {
            attributeType: 'AADGroupId'
            attributeValue: '11111111-1111-2222-3333-111111111111'
            name: 'UserGroup1'
          }
          {
            attributeType: 'AADGroupId'
            attributeValue: '11111111-1111-3333-4444-111111111111'
            name: 'UserGroup2'
          }
        ]
        priority: '0'
        userVPNPolicyGroupName: 'DefaultGroup'
      }
      {
        isDefault: 'false'
        policymembers: [
          {
            attributeType: 'AADGroupId'
            attributeValue: '11111111-1111-4444-5555-111111111111'
            name: 'UserGroup3'
          }
          {
            attributeType: 'AADGroupId'
            attributeValue: '11111111-1111-5555-6666-111111111111'
            name: 'UserGroup4'
          }
        ]
        priority: '1'
        userVPNPolicyGroupName: 'AdditionalGroup'
      }
    ]
    radiusClientRootCertificates: [
      {
        name: 'TestRadiusClientRevokedCert'
        thumbprint: '1f24c630cda418ef2069ffad4fdd5f463a1b59aa'
      }
    ]
    radiusServerRootCertificates: [
      {
        name: 'TestRadiusRootCert'
        publicCertData: 'MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f'
      }
    ]
    radiusServers: [
      {
        radiusServerAddress: '10.150.1.50'
        radiusServerScore: '10'
        radiusServerSecret: 'TestSecret'
      }
      {
        radiusServerAddress: '10.150.1.150'
        radiusServerScore: '20'
        radiusServerSecret: 'TestSecret2'
      }
    ]
    vpnAuthenticationTypes: [
      'AAD'
      'Certificate'
      'Radius'
    ]
    vpnClientIpsecPolicies: [
      {
        dhGroup: 'DHGroup14'
        ikeEncryption: 'AES256'
        ikeIntegrity: 'SHA256'
        ipsecEncryption: 'AES256'
        ipsecIntegrity: 'SHA256'
        pfsGroup: 'PFS14'
        saDataSizeKilobytes: 0
        saLifeTimeSeconds: 27000
      }
    ]
    vpnClientRevokedCertificates: [
      {
        name: 'TestRevokedCert'
        thumbprint: '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
      }
      {
        name: 'TestRevokedCert2'
        thumbprint: '1f24c630cda418ef2069ffad4fdd5f463a1b69bb'
      }
    ]
    vpnClientRootCertificates: [
      {
        name: 'TestRootCert'
        publicCertData: 'MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f'
      }
      {
        name: 'TestRootCert2'
        publicCertData: 'MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcMARELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f'
      }
    ]
    vpnProtocols: [
      'OpenVPN'
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "vscmaxVPNConfig"
    },
    // Non-required parameters
    "aadAudience": {
      "value": "11111111-1234-4321-1234-111111111111"
    },
    "aadIssuer": {
      "value": "https://sts.windows.net/11111111-1111-1111-1111-111111111111/"
    },
    "aadTenant": {
      "value": "https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111"
    },
    "location": {
      "value": "<location>"
    },
    "p2sConfigurationPolicyGroups": {
      "value": [
        {
          "isDefault": "true",
          "policymembers": [
            {
              "attributeType": "AADGroupId",
              "attributeValue": "11111111-1111-2222-3333-111111111111",
              "name": "UserGroup1"
            },
            {
              "attributeType": "AADGroupId",
              "attributeValue": "11111111-1111-3333-4444-111111111111",
              "name": "UserGroup2"
            }
          ],
          "priority": "0",
          "userVPNPolicyGroupName": "DefaultGroup"
        },
        {
          "isDefault": "false",
          "policymembers": [
            {
              "attributeType": "AADGroupId",
              "attributeValue": "11111111-1111-4444-5555-111111111111",
              "name": "UserGroup3"
            },
            {
              "attributeType": "AADGroupId",
              "attributeValue": "11111111-1111-5555-6666-111111111111",
              "name": "UserGroup4"
            }
          ],
          "priority": "1",
          "userVPNPolicyGroupName": "AdditionalGroup"
        }
      ]
    },
    "radiusClientRootCertificates": {
      "value": [
        {
          "name": "TestRadiusClientRevokedCert",
          "thumbprint": "1f24c630cda418ef2069ffad4fdd5f463a1b59aa"
        }
      ]
    },
    "radiusServerRootCertificates": {
      "value": [
        {
          "name": "TestRadiusRootCert",
          "publicCertData": "MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f"
        }
      ]
    },
    "radiusServers": {
      "value": [
        {
          "radiusServerAddress": "10.150.1.50",
          "radiusServerScore": "10",
          "radiusServerSecret": "TestSecret"
        },
        {
          "radiusServerAddress": "10.150.1.150",
          "radiusServerScore": "20",
          "radiusServerSecret": "TestSecret2"
        }
      ]
    },
    "vpnAuthenticationTypes": {
      "value": [
        "AAD",
        "Certificate",
        "Radius"
      ]
    },
    "vpnClientIpsecPolicies": {
      "value": [
        {
          "dhGroup": "DHGroup14",
          "ikeEncryption": "AES256",
          "ikeIntegrity": "SHA256",
          "ipsecEncryption": "AES256",
          "ipsecIntegrity": "SHA256",
          "pfsGroup": "PFS14",
          "saDataSizeKilobytes": 0,
          "saLifeTimeSeconds": 27000
        }
      ]
    },
    "vpnClientRevokedCertificates": {
      "value": [
        {
          "name": "TestRevokedCert",
          "thumbprint": "1f24c630cda418ef2069ffad4fdd5f463a1b69aa"
        },
        {
          "name": "TestRevokedCert2",
          "thumbprint": "1f24c630cda418ef2069ffad4fdd5f463a1b69bb"
        }
      ]
    },
    "vpnClientRootCertificates": {
      "value": [
        {
          "name": "TestRootCert",
          "publicCertData": "MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f"
        },
        {
          "name": "TestRootCert2",
          "publicCertData": "MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcMARELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f"
        }
      ]
    },
    "vpnProtocols": {
      "value": [
        "OpenVPN"
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-server-configuration:<version>'

// Required parameters
param name = 'vscmaxVPNConfig'
// Non-required parameters
param aadAudience = '11111111-1234-4321-1234-111111111111'
param aadIssuer = 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
param aadTenant = 'https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111'
param location = '<location>'
p2sConfigurationPolicyGroups: [
  {
    isDefault: 'true'
    policymembers: [
      {
        attributeType: 'AADGroupId'
        attributeValue: '11111111-1111-2222-3333-111111111111'
        name: 'UserGroup1'
      }
      {
        attributeType: 'AADGroupId'
        attributeValue: '11111111-1111-3333-4444-111111111111'
        name: 'UserGroup2'
      }
    ]
    priority: '0'
    userVPNPolicyGroupName: 'DefaultGroup'
  }
  {
    isDefault: 'false'
    policymembers: [
      {
        attributeType: 'AADGroupId'
        attributeValue: '11111111-1111-4444-5555-111111111111'
        name: 'UserGroup3'
      }
      {
        attributeType: 'AADGroupId'
        attributeValue: '11111111-1111-5555-6666-111111111111'
        name: 'UserGroup4'
      }
    ]
    priority: '1'
    userVPNPolicyGroupName: 'AdditionalGroup'
  }
]
param radiusClientRootCertificates = [
  {
    name: 'TestRadiusClientRevokedCert'
    thumbprint: '1f24c630cda418ef2069ffad4fdd5f463a1b59aa'
  }
]
param radiusServerRootCertificates = [
  {
    name: 'TestRadiusRootCert'
    publicCertData: 'MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f'
  }
]
param radiusServers = [
  {
    radiusServerAddress: '10.150.1.50'
    radiusServerScore: '10'
    radiusServerSecret: 'TestSecret'
  }
  {
    radiusServerAddress: '10.150.1.150'
    radiusServerScore: '20'
    radiusServerSecret: 'TestSecret2'
  }
]
param vpnAuthenticationTypes = [
  'AAD'
  'Certificate'
  'Radius'
]
param vpnClientIpsecPolicies = [
  {
    dhGroup: 'DHGroup14'
    ikeEncryption: 'AES256'
    ikeIntegrity: 'SHA256'
    ipsecEncryption: 'AES256'
    ipsecIntegrity: 'SHA256'
    pfsGroup: 'PFS14'
    saDataSizeKilobytes: 0
    saLifeTimeSeconds: 27000
  }
]
param vpnClientRevokedCertificates = [
  {
    name: 'TestRevokedCert'
    thumbprint: '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
  }
  {
    name: 'TestRevokedCert2'
    thumbprint: '1f24c630cda418ef2069ffad4fdd5f463a1b69bb'
  }
]
param vpnClientRootCertificates = [
  {
    name: 'TestRootCert'
    publicCertData: 'MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f'
  }
  {
    name: 'TestRootCert2'
    publicCertData: 'MIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcMARELBQAwTDEgMB4GA1UECxMXR4xvYmFsU2lnbiBSb390IENBIC0gUjMxEzARBgNVBAoTCkdsb8JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aEyiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bLyCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkWqQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBovHd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX4268NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o2HLO02JQZR7rkpeDMdmztcpHWD8f'
  }
]
param vpnProtocols = [
  'OpenVPN'
]
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:<version>' = {
  name: 'vpnServerConfigurationDeployment'
  params: {
    // Required parameters
    name: 'vscwafVPNConfig'
    // Non-required parameters
    aadAudience: '11111111-1234-4321-1234-111111111111'
    aadIssuer: 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
    aadTenant: 'https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111'
    location: '<location>'
    p2sConfigurationPolicyGroups: [
      {
        isDefault: 'true'
        policymembers: [
          {
            attributeType: 'AADGroupId'
            attributeValue: '11111111-1111-2222-3333-111111111111'
            name: 'UserGroup1'
          }
        ]
        priority: '0'
        userVPNPolicyGroupName: 'DefaultGroup'
      }
    ]
    vpnAuthenticationTypes: [
      'AAD'
    ]
    vpnProtocols: [
      'OpenVPN'
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "vscwafVPNConfig"
    },
    // Non-required parameters
    "aadAudience": {
      "value": "11111111-1234-4321-1234-111111111111"
    },
    "aadIssuer": {
      "value": "https://sts.windows.net/11111111-1111-1111-1111-111111111111/"
    },
    "aadTenant": {
      "value": "https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111"
    },
    "location": {
      "value": "<location>"
    },
    "p2sConfigurationPolicyGroups": {
      "value": [
        {
          "isDefault": "true",
          "policymembers": [
            {
              "attributeType": "AADGroupId",
              "attributeValue": "11111111-1111-2222-3333-111111111111",
              "name": "UserGroup1"
            }
          ],
          "priority": "0",
          "userVPNPolicyGroupName": "DefaultGroup"
        }
      ]
    },
    "vpnAuthenticationTypes": {
      "value": [
        "AAD"
      ]
    },
    "vpnProtocols": {
      "value": [
        "OpenVPN"
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-server-configuration:<version>'

// Required parameters
param name = 'vscwafVPNConfig'
// Non-required parameters
param aadAudience = '11111111-1234-4321-1234-111111111111'
param aadIssuer = 'https://sts.windows.net/11111111-1111-1111-1111-111111111111/'
param aadTenant = 'https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111'
param location = '<location>'
p2sConfigurationPolicyGroups: [
  {
    isDefault: 'true'
    policymembers: [
      {
        attributeType: 'AADGroupId'
        attributeValue: '11111111-1111-2222-3333-111111111111'
        name: 'UserGroup1'
      }
    ]
    priority: '0'
    userVPNPolicyGroupName: 'DefaultGroup'
  }
]
param vpnAuthenticationTypes = [
  'AAD'
]
param vpnProtocols = [
  'OpenVPN'
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the user VPN configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadAudience`](#parameter-aadaudience) | string | The audience for the AAD/Entra authentication. Required if configuring Entra ID authentication. |
| [`aadIssuer`](#parameter-aadissuer) | string | The issuer for the AAD/Entra authentication. Required if configuring Entra ID authentication. |
| [`aadTenant`](#parameter-aadtenant) | string | The audience for the AAD/Entra authentication. Required if configuring Entra ID authentication. |
| [`radiusServerAddress`](#parameter-radiusserveraddress) | string | The address of the RADIUS server. Required if configuring a single RADIUS. |
| [`radiusServerSecret`](#parameter-radiusserversecret) | securestring | The RADIUS server secret. Required if configuring a single RADIUS server. |
| [`vpnClientRootCertificates`](#parameter-vpnclientrootcertificates) | array | The VPN Client root certificate public keys for the configuration. Required if using certificate authentication. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location where all resources will be created. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`p2sConfigurationPolicyGroups`](#parameter-p2sconfigurationpolicygroups) | array | The P2S configuration policy groups for the configuration. |
| [`radiusClientRootCertificates`](#parameter-radiusclientrootcertificates) | array | The revoked RADIUS client certificates for the configuration. |
| [`radiusServerRootCertificates`](#parameter-radiusserverrootcertificates) | array | The root certificates of the RADIUS server. |
| [`radiusServers`](#parameter-radiusservers) | array | The list of RADIUS servers. Required if configuring multiple RADIUS servers. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vpnAuthenticationTypes`](#parameter-vpnauthenticationtypes) | array | The authentication types for the VPN configuration. |
| [`vpnClientIpsecPolicies`](#parameter-vpnclientipsecpolicies) | array | The IPsec policies for the configuration. |
| [`vpnClientRevokedCertificates`](#parameter-vpnclientrevokedcertificates) | array | The revoked VPN Client certificate thumbprints for the configuration. |
| [`vpnProtocols`](#parameter-vpnprotocols) | array | The allowed VPN protocols for the configuration. |

### Parameter: `name`

The name of the user VPN configuration.

- Required: Yes
- Type: string

### Parameter: `aadAudience`

The audience for the AAD/Entra authentication. Required if configuring Entra ID authentication.

- Required: No
- Type: string

### Parameter: `aadIssuer`

The issuer for the AAD/Entra authentication. Required if configuring Entra ID authentication.

- Required: No
- Type: string

### Parameter: `aadTenant`

The audience for the AAD/Entra authentication. Required if configuring Entra ID authentication.

- Required: No
- Type: string

### Parameter: `radiusServerAddress`

The address of the RADIUS server. Required if configuring a single RADIUS.

- Required: No
- Type: string

### Parameter: `radiusServerSecret`

The RADIUS server secret. Required if configuring a single RADIUS server.

- Required: No
- Type: securestring

### Parameter: `vpnClientRootCertificates`

The VPN Client root certificate public keys for the configuration. Required if using certificate authentication.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location where all resources will be created.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `p2sConfigurationPolicyGroups`

The P2S configuration policy groups for the configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `radiusClientRootCertificates`

The revoked RADIUS client certificates for the configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `radiusServerRootCertificates`

The root certificates of the RADIUS server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `radiusServers`

The list of RADIUS servers. Required if configuring multiple RADIUS servers.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vpnAuthenticationTypes`

The authentication types for the VPN configuration.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    'AAD'
    'Certificate'
    'Radius'
  ]
  ```

### Parameter: `vpnClientIpsecPolicies`

The IPsec policies for the configuration.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dhGroup`](#parameter-vpnclientipsecpoliciesdhgroup) | string | The Diffie-Hellman group used in IKE phase 1. Required if using IKEv2. |
| [`ikeEncryption`](#parameter-vpnclientipsecpoliciesikeencryption) | string | The encryption algorithm used in IKE phase 1. Required if using IKEv2. |
| [`ikeIntegrity`](#parameter-vpnclientipsecpoliciesikeintegrity) | string | The integrity algorithm used in IKE phase 1. Required if using IKEv2. |
| [`ipsecEncryption`](#parameter-vpnclientipsecpoliciesipsecencryption) | string | The encryption algorithm used in IKE phase 2. Required if using IKEv2. |
| [`ipsecIntegrity`](#parameter-vpnclientipsecpoliciesipsecintegrity) | string | The integrity algorithm used in IKE phase 2. Required if using IKEv2. |
| [`pfsGroup`](#parameter-vpnclientipsecpoliciespfsgroup) | string | The Perfect Forward Secrecy (PFS) group used in IKE phase 2. Required if using IKEv2. |
| [`saDataSizeKilobytes`](#parameter-vpnclientipsecpoliciessadatasizekilobytes) | int | The size of the SA data in kilobytes. Required if using IKEv2. |
| [`salfetimeSeconds`](#parameter-vpnclientipsecpoliciessalfetimeseconds) | int | The lifetime of the SA in seconds. Required if using IKEv2. |

### Parameter: `vpnClientIpsecPolicies.dhGroup`

The Diffie-Hellman group used in IKE phase 1. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `vpnClientIpsecPolicies.ikeEncryption`

The encryption algorithm used in IKE phase 1. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `vpnClientIpsecPolicies.ikeIntegrity`

The integrity algorithm used in IKE phase 1. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `vpnClientIpsecPolicies.ipsecEncryption`

The encryption algorithm used in IKE phase 2. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `vpnClientIpsecPolicies.ipsecIntegrity`

The integrity algorithm used in IKE phase 2. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `vpnClientIpsecPolicies.pfsGroup`

The Perfect Forward Secrecy (PFS) group used in IKE phase 2. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `vpnClientIpsecPolicies.saDataSizeKilobytes`

The size of the SA data in kilobytes. Required if using IKEv2.

- Required: No
- Type: int

### Parameter: `vpnClientIpsecPolicies.salfetimeSeconds`

The lifetime of the SA in seconds. Required if using IKEv2.

- Required: No
- Type: int

### Parameter: `vpnClientRevokedCertificates`

The revoked VPN Client certificate thumbprints for the configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `vpnProtocols`

The allowed VPN protocols for the configuration.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    'IkeV2'
    'OpenVPN'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the user VPN configuration. |
| `resourceGroupName` | string | The name of the resource group the user VPN configuration was deployed into. |
| `resourceId` | string | The resource ID of the user VPN configuration. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
