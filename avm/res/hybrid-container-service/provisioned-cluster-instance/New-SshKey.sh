#!/bin/bash
set -e

# Check arguments
if [[ $# -ne 6 ]]; then
  echo "Usage: $0 <base64 of reflect.bicep> <base64 of read.bicep> <base64 of write.bicep> <base64 of parameters.json> <resource-group> <subscription-id>"
  exit 1
fi

REFELCT_B64="$1"
READ_B64="$2"
WRITE_B64="$3"
PARAMETERS_B64="$4"
RESOURCE_GROUP="$5"
SUBSCRIPTION_ID="$6"

# Decode base64-encoded content to temp files
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
echo "$REFELCT_B64" | base64 -d > "reflect.bicep"
echo "$READ_B64" | base64 -d > "read.bicep"
echo "$WRITE_B64" | base64 -d > "write.bicep"
echo "$PARAMETERS_B64" | base64 -d > "parameters.json"

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
  --parameters "parameters.json"

if [[ $? -eq 0 ]]; then
  echo "Deployment succeeded."
else
  echo "Deployment failed."
  exit 1
fi

ssh-keygen -t rsa -b 4096 -f ./key -N '""' -q
$publicKey = Get-Content -Path './key.pub' -Raw
$privateKey = Get-Content -Path './key' -Raw
