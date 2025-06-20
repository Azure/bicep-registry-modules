#!/bin/bash

set -e  # Exit on any error

echo "Starting HCI deployment script..."

# Check required environment variables
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$SUBSCRIPTION_ID" ] || [ -z "$CLUSTER_NAME" ] || [ -z "$CLOUD_ID" ] || [ -z "$USE_SHARED_KEYVAULT" ] || [ -z "$DEPLOYMENT_SETTINGS" ] || [ -z "$DEPLOYMENT_SETTING_BICEP_BASE64" ] || [ -z "$DEPLOYMENT_SETTING_MAIN_BICEP_BASE64" ] || [ -z "$NEED_ARB_SECRET" ]; then
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

NEED_ARB_SECRET_JSON=$(echo "$NEED_ARB_SECRET" | tr '[:upper:]' '[:lower:]')
if [ "$NEED_ARB_SECRET_JSON" = "true" ] || [ "$NEED_ARB_SECRET_JSON" = "1" ]; then
    NEED_ARB_SECRET_JSON="true"
else
    NEED_ARB_SECRET_JSON="false"
fi

echo "Use shared key vault: $NEED_ARB_SECRET_JSON"

# Debug: Check the content of DEPLOYMENT_SETTINGS
echo "Debug: DEPLOYMENT_SETTINGS type check..."
echo "First 100 chars of DEPLOYMENT_SETTINGS: ${DEPLOYMENT_SETTINGS:0:100}"

# Validate if DEPLOYMENT_SETTINGS is valid JSON
if ! echo "$DEPLOYMENT_SETTINGS" | jq empty 2>/dev/null; then
    echo "Error: DEPLOYMENT_SETTINGS is not valid JSON"
    echo "Content: $DEPLOYMENT_SETTINGS"
    exit 1
fi

# Create parameter file for deployment
PARAM_FILE="deployment-params.json"

# Create a proper parameter file with JSON object
echo "Creating parameter file..."
cat > "$PARAM_FILE" << EOF
{
  "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentOperations": {
      "value": $OPERATIONS_JSON
    },
    "deploymentSettings": {
      "value": $DEPLOYMENT_SETTINGS
    },
    "useSharedKeyVault": {
      "value": $USE_SHARED_KEYVAULT_JSON
    },
    "hciResourceProviderObjectId": {
      "value": "$HCI_RESOURCE_PROVIDER_OBJECT_ID"
    },
    "clusterName": {
      "value": "$CLUSTER_NAME"
    },
    "cloudId": {
      "value": "$CLOUD_ID"
    },
    "needArbSecret": {
      "value": $NEED_ARB_SECRET_JSON
    }
  }
}
EOF

# Validate the parameter file
echo "Validating parameter file..."
if ! jq empty "$PARAM_FILE" 2>/dev/null; then
    echo "Error: Generated parameter file is not valid JSON"
    cat "$PARAM_FILE"
    exit 1
fi

echo "✅ Parameter file created and validated successfully"

# Print parameter file content for debugging
echo "============================================"
echo "Parameter file content:"
echo "============================================"
cat "$PARAM_FILE" | jq '.'
echo "============================================"

# Check if deployment-settings resource exists
echo "Checking if deployment-settings resource already exists..."

# Construct the resource ID for deployment-settings
DEPLOYMENT_SETTINGS_RESOURCE_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.AzureStackHCI/clusters/$CLUSTER_NAME/deploymentSettings/default"

echo "Checking resource: $DEPLOYMENT_SETTINGS_RESOURCE_ID"

# Check if the deployment-settings resource exists
# Redirect both stdout and stderr to suppress all output, only check exit code
if az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" >/dev/null 2>&1; then
    echo "✅ Deployment-settings resource already exists. Skipping deployment."

    # Show existing resource details
    echo "Existing deployment-settings details:"
    az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "{name: name, provisioningState: properties.provisioningState, deploymentMode: properties.deploymentMode}" --output table 2>/dev/null || echo "Could not retrieve resource details"

    exit 0
else
    echo "📝 Deployment-settings resource does not exist. Proceeding with deployment..."
fi

# Execute Bicep deployment
DEPLOYMENT_NAME="hci-deployment-$(date +%s)"

echo "Starting deployment: $DEPLOYMENT_NAME"
echo "Using template: nested/deployment-setting.bicep"
echo "Using parameter file: $PARAM_FILE"

# Check if nested/deployment-setting.bicep file was created successfully
if [ ! -f "nested/deployment-setting.bicep" ]; then
    echo "Error: nested/deployment-setting.bicep file was not created successfully"
    echo "Current directory contents:"
    ls -la
    exit 1
fi

echo "✅ nested/deployment-setting.bicep file found and ready for deployment"

# Execute deployment with parameter file
az deployment group create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$DEPLOYMENT_NAME" \
    --template-file "nested/deployment-setting.bicep" \
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

    # Also show the deployment operations for more details
    echo "Deployment operations:"
    az deployment operation group list \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$DEPLOYMENT_NAME" \
        --query "[?properties.provisioningState=='Failed'].{operation: operationId, code: properties.statusCode, message: properties.statusMessage}" \
        --output table

    exit $DEPLOYMENT_STATUS
fi

# Clean up temporary files
rm -f "$PARAM_FILE"
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
