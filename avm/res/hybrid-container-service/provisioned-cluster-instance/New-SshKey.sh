#!/bin/bash
set -e

# Check arguments
if [[ $# -ne 7 ]]; then
  echo "Usage: $0 <base64 of reflect.bicep> <base64 of read.bicep> <base64 of read.json> <base64 of write.bicep> <base64 of write.json> <resource-group> <subscription-id>"
  exit 1
fi

REFELCT_B64="$1"
READ_B64="$2"
READ_PARA_B64="$3"
WRITE_B64="$4"
WRITE_PARA_B64="$5"
RESOURCE_GROUP="$6"
SUBSCRIPTION_ID="$7"

# Decode base64-encoded content to temp files
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
echo "$REFELCT_B64" | base64 -d > "reflect.bicep"
echo "$READ_B64" | base64 -d > "read.bicep"
echo "$READ_PARA_B64" | base64 -d > "read.json"
echo "$WRITE_B64" | base64 -d > "write.bicep"
echo "$WRITE_PARA_B64" | base64 -d > "write.json"

# Login with managed identity and set subscription
az login --identity --allow-no-subscriptions > /dev/null
az account set --subscription "$SUBSCRIPTION_ID"

# Ensure Bicep CLI is available
az bicep upgrade

# Generate a random 6-character alphanumeric suffix for deployment name
RAND_SUFFIX=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 6 | head -n 1)
DEPLOYMENT_NAME="BicepDeployment-$RAND_SUFFIX"

# Read
az deployment group create \
  --name "$DEPLOYMENT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "read.bicep" \
  --parameters "read.json" || true

PUBLIC_KEY=$(az deployment group show \
  --name "$DEPLOYMENT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query properties.outputs.publicKeySecretValue.value \
  --only-show-errors --output tsv)

if [[ -z "$PUBLIC_KEY" ]]; then
  # ssh-keygen
  ssh-keygen -t rsa -b 4096 -f ./key -N '""' -q
  PUBLIC_KEY_B64=$(cat './key.pub' | base64 -w 0)
  PRIVATE_KEY_B64=$(cat './key' | base64 -w 0)
  sed --in-place "s/{{publicKeySecretValueBase64}}/$PUBLIC_KEY_B64/" '/write.json'
  sed --in-place "s/{{privateKeySecretValueBase64}}/$PRIVATE_KEY_B64/" '/write.json'

  # Generate a random 6-character alphanumeric suffix for deployment name
  RAND_SUFFIX=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 6 | head -n 1)
  DEPLOYMENT_NAME="BicepDeployment-$RAND_SUFFIX"

  # write
  az deployment group create \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "write.bicep" \
    --parameters "write.json" || true

  PUBLIC_KEY=$(az deployment group show \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query properties.outputs.publicKeySecretValue.value \
    --only-show-errors --output tsv)
fi

if [[ -z "$PUBLIC_KEY" ]]; then
  exit 1
fi

echo "{\"output\": \"$PUBLIC_KEY\"}"> $AZ_SCRIPTS_OUTPUT_PATH
