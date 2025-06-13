#!/bin/bash

set -e  # Exit on any error

echo "Starting HCI deployment script..."

# Check required environment variables
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$SUBSCRIPTION_ID" ] || [ -z "$CLUSTER_NAME" ] || [ -z "$DEPLOYMENT_SETTINGS" ] || [ -z "$DEPLOYMENT_SETTING_BICEP_BASE64" ] || [ -z "$DEPLOYMENT_SETTING_MAIN_BICEP_BASE64" ]; then
    echo "Error: Required environment variables are missing"
    exit 1
fi

# Set subscription context
echo "Setting subscription context to: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Create directory structure and decode base64 files
echo "Creating required directory structure and bicep files..."

# Create nested directory
mkdir -p nested
# Create deployment-setting directory
mkdir -p deployment-setting

# Decode and create deployment-setting.bicep file
echo "Creating deployment-setting.bicep file from base64 encoded content..."
echo "$DEPLOYMENT_SETTING_BICEP_BASE64" | base64 -d > nested/deployment-setting.bicep

# Decode and create deployment-setting/main.bicep file
echo "Creating deployment-setting/main.bicep file from base64 encoded content..."
echo "$DEPLOYMENT_SETTING_MAIN_BICEP_BASE64" | base64 -d > deployment-setting/main.bicep

# Verify the files were created successfully
if [ ! -f "nested/deployment-setting.bicep" ] || [ ! -s "nested/deployment-setting.bicep" ]; then
    echo "Error: Failed to create nested/deployment-setting.bicep file or file is empty"
    exit 1
fi

if [ ! -f "deployment-setting/main.bicep" ] || [ ! -s "deployment-setting/main.bicep" ]; then
    echo "Error: Failed to create deployment-setting/main.bicep file or file is empty"
    exit 1
fi

echo "✅ All bicep files created successfully"
echo "nested/deployment-setting.bicep size: $(wc -c < nested/deployment-setting.bicep) bytes"
echo "deployment-setting/main.bicep size: $(wc -c < deployment-setting/main.bicep) bytes"

# List current directory structure for debugging
echo "Current directory structure:"
find . -name "*.bicep" -type f

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

# Convert boolean values to proper JSON format
USE_SHARED_KEYVAULT_JSON=$(echo "$USE_SHARED_KEYVAULT" | tr '[:upper:]' '[:lower:]')
if [ "$USE_SHARED_KEYVAULT_JSON" = "true" ] || [ "$USE_SHARED_KEYVAULT_JSON" = "1" ]; then
    USE_SHARED_KEYVAULT_JSON="true"
else
    USE_SHARED_KEYVAULT_JSON="false"
fi

echo "Use shared key vault: $USE_SHARED_KEYVAULT_JSON"

# Create parameter file and execute single deployment
PARAM_FILE="deployment-params.json"

# Create parameters using direct az deployment command instead of parameter file to avoid JSON parsing issues
echo "Starting deployment with inline parameters..."

# TODO: check if deployment-settings exists or failed

# Execute Bicep deployment
DEPLOYMENT_NAME="hci-deployment-$(date +%s)"

echo "Starting deployment: $DEPLOYMENT_NAME"
echo "Using template: nested/deployment-setting.bicep"

# Check if nested/deployment-setting.bicep file was created successfully
if [ ! -f "nested/deployment-setting.bicep" ]; then
    echo "Error: nested/deployment-setting.bicep file was not created successfully"
    echo "Current directory contents:"
    ls -la
    exit 1
fi

echo "✅ nested/deployment-setting.bicep file found and ready for deployment"

# Execute deployment with inline parameters to avoid JSON parsing issues
az deployment group create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$DEPLOYMENT_NAME" \
    --template-file "nested/deployment-setting.bicep" \
    --parameters \
        deploymentOperations="$OPERATIONS_JSON" \
        deploymentSettings="$DEPLOYMENT_SETTINGS" \
        useSharedKeyVault="$USE_SHARED_KEYVAULT_JSON" \
        hciResourceProviderObjectId="$HCI_RESOURCE_PROVIDER_OBJECT_ID" \
        clusterName="$CLUSTER_NAME" \
        cloudId="$CLOUD_ID" \
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
rm -f "nested/deployment-setting.bicep"
rm -rf "deployment-setting"

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
