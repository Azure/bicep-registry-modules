#!/bin/bash
set -e

REFLECT_BICEP_B64="$1"
READ_BICEP_B64="$2"
READ_JSON_B64="$3"
WRITE_BICEP_B64="$4"
WRITE_JSON_B64="$5"
SUBSCRIPTION_ID="$6"
RESOURCE_GROUP_NAME="$7"
CLUSTER_NAME="$8"

# Decode base64-encoded content to temp files
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
echo "$REFLECT_BICEP_B64" | base64 -d > "reflect.bicep"
echo "$READ_BICEP_B64" | base64 -d > "read.bicep"
echo "$READ_JSON_B64" | base64 -d > "read.json"
echo "$WRITE_BICEP_B64" | base64 -d > "write.bicep"
echo "$WRITE_JSON_B64" | base64 -d > "write.json"

# Login with managed identity and set subscription
az login --identity --allow-no-subscriptions > /dev/null
az account set --subscription "$SUBSCRIPTION_ID"

# Ensure Bicep CLI is available
az bicep upgrade

DEPLOYMENT_NAME_1="$CLUSTER_NAME-sshkey-read"

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
  az sshkey create --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP_NAME" 2>ssh.log
  az sshkey delete --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP_NAME" --yes
  PRIVATE_KEY_FILE=$(grep 'Private key is saved to' ssh.log | sed -E 's/.*"([^"]+)".*/\1/')
  PUBLIC_KEY_FILE=$(grep 'Public key is saved to' ssh.log | sed -E 's/.*"([^"]+)".*/\1/')

  PRIVATE_KEY_B64=$(cat $PRIVATE_KEY_FILE | base64 -w 0)
  PUBLIC_KEY_B64=$(cat $PUBLIC_KEY_FILE | base64 -w 0)
  sed --in-place "s/{{privateKeySecretValueBase64}}/$PRIVATE_KEY_B64/" 'write.json'
  sed --in-place "s/{{publicKeySecretValueBase64}}/$PUBLIC_KEY_B64/" 'write.json'

  DEPLOYMENT_NAME_2="$CLUSTER_NAME-sshkey-write"

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

  shred -u $PRIVATE_KEY_FILE
  shred -u $PUBLIC_KEY_FILE
  shred -u 'write.json'
fi

if [[ -z "$PUBLIC_KEY" ]]; then
  exit 2
fi

echo "{\"output\": \"$PUBLIC_KEY\"}"> $AZ_SCRIPTS_OUTPUT_PATH
