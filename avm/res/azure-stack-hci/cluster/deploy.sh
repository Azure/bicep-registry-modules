#!/bin/bash

set -e  # Exit on any error

echo "Starting HCI deployment script..."

# Check required environment variables
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$SUBSCRIPTION_ID" ] || [ -z "$CLUSTER_NAME" ] || [ -z "$DEPLOYMENT_SETTINGS" ] || [ -z "$DEPLOYMENT_SETTING_BICEP_BASE64" ]; then
    echo "Error: Required environment variables are missing"
    exit 1
fi

# Set subscription context
echo "Setting subscription context to: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Decode base64 and create deployment-setting.bicep file
echo "Creating deployment-setting.bicep file from base64 encoded content..."
echo "$DEPLOYMENT_SETTING_BICEP_BASE64" | base64 -d > deployment-setting.bicep

# Verify the file was created successfully
if [ ! -f "deployment-setting.bicep" ] || [ ! -s "deployment-setting.bicep" ]; then
    echo "Error: Failed to create deployment-setting.bicep file or file is empty"
    exit 1
fi

echo "✅ deployment-setting.bicep file created successfully"
echo "File size: $(wc -c < deployment-setting.bicep) bytes"

# Parse deployment operations into JSON array format
IFS=',' read -ra OPERATIONS <<< "$DEPLOYMENT_OPERATIONS"
echo "Deployment operations: ${OPERATIONS[@]}"

# Convert operations array to JSON format
OPERATIONS_JSON="["
for i in "${!OPERATIONS[@]}"; do
    if [ $i -gt 0 ]; then
        OPERATIONS_JSON+=","
    fi
    OPERATIONS_JSON+="\"${OPERATIONS[$i]}\""
done
OPERATIONS_JSON+="]"

echo "Deployment operations JSON: $OPERATIONS_JSON"

# Create parameter file and execute single deployment
PARAM_FILE="deployment-params.json"

cat > "$PARAM_FILE" << EOF
{
  "\$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentOperations": {
      "value": $OPERATIONS_JSON
    },
    "deploymentSettings": {
      "value": $DEPLOYMENT_SETTINGS
    },
    "useSharedKeyVault": {
      "value": $USE_SHARED_KEYVAULT
    },
    "hciResourceProviderObjectId": {
      "value": "$HCI_RESOURCE_PROVIDER_OBJECT_ID"
    },
    "clusterName": {
      "value": "$CLUSTER_NAME"
    },
    "cloudId": {
      "value": "$CLOUD_ID"
    }
  }
}
EOF

echo "Created parameter file: $PARAM_FILE"
echo "Parameter file content:"
cat "$PARAM_FILE"

# Execute Bicep deployment
DEPLOYMENT_NAME="hci-deployment-$(date +%s)"

echo "Starting deployment: $DEPLOYMENT_NAME"
echo "Using template: deployment-setting.bicep"
echo "Using parameters: $PARAM_FILE"

# Check if deployment-setting.bicep file was created successfully
if [ ! -f "deployment-setting.bicep" ]; then
    echo "Error: deployment-setting.bicep file was not created successfully"
    echo "Current directory contents:"
    ls -la
    exit 1
fi

echo "✅ deployment-setting.bicep file found and ready for deployment"

# TODO: check if deployment-settings exists or failed

# Execute deployment
az deployment group create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$DEPLOYMENT_NAME" \
    --template-file "deployment-setting.bicep" \
    --parameters "@$PARAM_FILE" \
    --verbose

DEPLOYMENT_STATUS=$?

if [ $DEPLOYMENT_STATUS -eq 0 ]; then
    echo "✅ Deployment completed successfully"

    # Get deployment outputs
    echo "Deployment outputs:"
    az deployment group show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$DEPLOYMENT_NAME" \
        --query "properties.outputs" \
        --output table
else
    echo "❌ Deployment failed with status: $DEPLOYMENT_STATUS"

    # Get deployment error details
    echo "Deployment error details:"
    az deployment group show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$DEPLOYMENT_NAME" \
        --query "properties.error" \
        --output json

    exit $DEPLOYMENT_STATUS
fi

# Clean up temporary files
rm -f "$PARAM_FILE"
rm -f "deployment-setting.bicep"

echo "Completed deployment"

echo "🎉 HCI deployment completed successfully!"

# Set output for Bicep usage
cat > $AZ_SCRIPTS_OUTPUT_PATH << EOF
{
  "status": "success",
  "message": "Deployment completed successfully",
  "operations": $OPERATIONS_JSON
}
EOF
