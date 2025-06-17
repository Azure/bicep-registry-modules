#!/bin/bash
set -e

# Check arguments
if [[ $# -ne 11 ]]; then
  echo "Usage: $0 <base64 of reflect.bicep> <base64 of read.bicep> <base64 of read.json> <base64 of write.bicep> <base64 of write.json> <etc.>"
  exit 1
fi

REFELCT_BICEP_B64="$1"
READ_BICEP_B64="$2"
READ_JSON_B64="$3"
WRITE_BICEP_B64="$4"
WRITE_JSON_B64="$5"
SUBSCRIPTION_ID="$6"
RESOURCE_GROUP_NAME="$7"
CLUSTER_NAME="$8"
KEY_VAULT_NAME="$9"
PRIVATR_KEY_SECRET_NAME="$10"
PUBLIC_KEY_SECRET_NAME="$11"

# Decode base64-encoded content to temp files
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
echo "$REFELCT_BICEP_B64" | base64 -d > "reflect.bicep"
echo "$READ_BICEP_B64" | base64 -d > "read.bicep"
echo "$READ_JSON_B64" | base64 -d > "read.json"
echo "$WRITE_BICEP_B64" | base64 -d > "write.bicep"
echo "$WRITE_JSON_B64" | base64 -d > "write.json"

# Login with managed identity and set subscription
az login --identity --allow-no-subscriptions > /dev/null
az account set --subscription "$SUBSCRIPTION_ID"

# Ensure Bicep CLI is available
az bicep upgrade

# Generate a random 6-character alphanumeric suffix for deployment name
RAND_SUFFIX_1=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 6 | head -n 1)
DEPLOYMENT_NAME_1="BicepDeployment-$RAND_SUFFIX_1"

# Read
az deployment group create \
  --name "$DEPLOYMENT_NAME_1" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --template-file "read.bicep" \
  --parameters "read.json" || true

PUBLIC_KEY=$(az deployment group show \
  --name "$DEPLOYMENT_NAME_1" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --query properties.outputs.publicKeySecretValue.value \
  --only-show-errors --output tsv || true)

if [[ -z "$PUBLIC_KEY" ]]; then
  # ssh-keygen does not exists, openssl is not compatible
  az sshkey create --name "mySSHKey" --resource-group "$RESOURCE_GROUP_NAME" 2>ssh.log
  PRIVATE_KEY_FILE=$(grep 'Private key is saved to' ssh.log | sed -E 's/.*"([^"]+)".*/\1/')
  PUBLIC_KEY_FILE=$(grep 'Public key is saved to' ssh.log | sed -E 's/.*"([^"]+)".*/\1/')

  PRIVATE_KEY_B64=$(cat $PRIVATE_KEY_FILE | base64 -w 0)
  PUBLIC_KEY_B64=$(cat $PUBLIC_KEY_FILE | base64 -w 0)
  sed --in-place "s/{{privateKeySecretValueBase64}}/$PRIVATE_KEY_B64/" 'write.json'
  sed --in-place "s/{{publicKeySecretValueBase64}}/$PUBLIC_KEY_B64/" 'write.json'

  sed --in-place "s/{{keyVaultName}}/$KEY_VAULT_NAME/" 'read.json'
  sed --in-place "s/{{keyVaultName}}/$KEY_VAULT_NAME/" 'write.json'
  sed --in-place "s/{{privateKeySecretName}}/$PRIVATR_KEY_SECRET_NAME/" 'read.json'
  sed --in-place "s/{{privateKeySecretName}}/$PRIVATR_KEY_SECRET_NAME/" 'write.json'
  sed --in-place "s/{{publicKeySecretName}}/$PUBLIC_KEY_SECRET_NAME/" 'read.json'
  sed --in-place "s/{{publicKeySecretName}}/$PUBLIC_KEY_SECRET_NAME/" 'write.json'

  # Generate a random 6-character alphanumeric suffix for deployment name
  RAND_SUFFIX_2=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 6 | head -n 1)
  DEPLOYMENT_NAME_2="BicepDeployment-$RAND_SUFFIX_2"

  # write
  az deployment group create \
    --name "$DEPLOYMENT_NAME_2" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --template-file "write.bicep" \
    --parameters "write.json" || true

  PUBLIC_KEY=$(az deployment group show \
    --name "$DEPLOYMENT_NAME_2" \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --query properties.outputs.publicKeySecretValue.value \
    --only-show-errors --output tsv || true)
fi

if [[ -z "$PUBLIC_KEY" ]]; then
  exit 2
fi

echo "{\"output\": \"$PUBLIC_KEY\"}"> $AZ_SCRIPTS_OUTPUT_PATH
