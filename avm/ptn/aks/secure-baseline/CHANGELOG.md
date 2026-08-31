# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/aks/secure-baseline/CHANGELOG.md).

## 0.1.0

### Changes

- Initial version of the complete AKS1P compliant IPv4 cluster pattern
- Reproduces the AKS1P EV2 resource-group topology with global, subscription, optional resource-deletion identity, and cluster resource groups
- Defaults global and subscription prerequisites to `eastus2` while requiring consumers to select the AKS cluster region independently
- Requires a stable `serviceName` and derives shared resource groups as `rg-secure-baseline-<serviceName>-global` and `rg-secure-baseline-<serviceName>-sub`
- Allows consumers to override the generated globally unique Key Vault name
- Defaults Key Vault purge protection to disabled for disposable test deployments while allowing production consumers to enable it
- Deploys the cluster identities, network, controlled IPv4 egress, ingress prefix, Azure CNI Overlay cluster, and Istio add-on
- Creates a Key Vault in the prerequisite resource group or explicitly adopts an existing Key Vault by resource ID
- Creates or reuses an SSH key pair without exposing the private key outside Key Vault
- Matches the AKS1P SSH contract by using `sshkey-public` and `sshkey-private`, reusing the pair whenever the private-key secret already exists
- Checks for the private-key secret without issuing an expected failing Key Vault download command
- Generates the RSA-4096 SSH key pair with `ssh-keygen`, or with an OpenSSL and Python-standard-library fallback when the deployment image does not include `ssh-keygen`
- Cleans up successful deployment-script backing resources immediately while retaining failed executions temporarily for diagnostics
- Passes the generated SSH public key through deployment outputs so first-time deployments do not evaluate Key Vault references before the vault exists
- Optionally protects Key Vault with the AVM Network Security Perimeter resource module and deploys Azure Bastion with its required subnet and network security rules
- Uses a deployment script for the SSH key lifecycle and returns only the non-sensitive public key to the cluster deployment
- Supports Auto and Manual node provisioning
- Excludes EV2-only ACR and resource-deletion infrastructure, Gateway API preview registration, Front Door, WAF, AGC, and monitoring integrations

### Breaking Changes

- None
