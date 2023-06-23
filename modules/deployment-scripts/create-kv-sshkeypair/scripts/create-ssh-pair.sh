#!/bin/bash
set -e

echo "Waiting on Identity RBAC replication ($initialDelay)"
sleep $initialDelay

# Generate the SSH key pair
echo "Generating SSH key pair..."
#ssh-keygen -t rsa -b 4096 -C "azure@example.com" -f id_rsa -N ""
ssh-keygen -m PEM -t rsa -b 4096 -f id_rsa -q

# Import the private key and public key as strings
privateKey=$(cat id_rsa)
publicKey=$(cat id_rsa.pub)

# Re-Login to Azure CLI using the managed identity
echo "Logging in to Azure CLI using managed identity..."
az login --identity

echo "Storing secret ${sshKeyName}private in Key Vault $keyVaultName..."
privSecret=$(az keyvault secret set --vault-name "$keyVaultName" --name "${sshKeyNamePrivate}" --value "$privateKey")

echo "Storing secret ${sshKeyName}public in Key Vault $keyVaultName..."
pubSecret=$(az keyvault secret set --vault-name "$keyVaultName" --name "${sshKeyNamePublic}" --value "$publicKey")

privateSecretId=$(echo $privSecret | jq -r ".id" | cut -d'/' -f-5) # remove the version from the url;
publicSecretId=$(echo $pubSecret | jq -r ".id" | cut -d'/' -f-5) # remove the version from the url;

jsonOutputString=$(jq -cn  --arg public $publicSecretId --arg private $privateSecretId '{secretUris: $ARGS.named}')
echo $jsonOutputString
echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH

# Cleanup
rm -f id_rsa id_rsa.pub