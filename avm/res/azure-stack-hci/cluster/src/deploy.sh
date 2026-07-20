#!/bin/bash
# ==============================================================================
# HCI Deployment Script - Full Inline Deployment
# ==============================================================================
# This script handles the complete deployment lifecycle inside the ACI container:
#   1. Idempotency check: skip if Deploy+Succeeded already exists
#   2. Cleanup of stale deploymentSettings resources (e.g., leftover Validate mode)
#   3. Decode base64-encoded Bicep files
#   4. Execute az deployment group create for Validate then Deploy
# ==============================================================================

set -e

echo "=== HCI Deployment Script - Full Inline Deployment ==="

# Validate required environment variables
if [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$SUBSCRIPTION_ID" ] || [ -z "$CLUSTER_NAME" ] || [ -z "$CLUSTER_AD_NAME" ] || [ -z "$CLOUD_ID" ] || [ -z "$USE_SHARED_KEYVAULT" ] || [ -z "$DEPLOYMENT_SETTINGS" ] || [ -z "$DEPLOYMENT_SETTING_BICEP_BASE64" ] || [ -z "$DEPLOYMENT_SETTING_MAIN_BICEP_BASE64" ] || [ -z "$NEED_ARB_SECRET" ] || [ -z "$OPERATION_TYPE" ]; then
    echo "Error: Required environment variables are missing"
    exit 1
fi

# Set subscription context
echo "Setting subscription context to: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Create directory structure and decode base64 files
echo "Creating required directory structure and bicep files..."
mkdir -p nested
mkdir -p deployment-setting

echo "Decoding deployment-setting.bicep from base64..."
echo "$DEPLOYMENT_SETTING_BICEP_BASE64" | base64 -d > nested/deployment-setting.bicep

echo "Decoding deployment-setting/main.bicep from base64..."
echo "$DEPLOYMENT_SETTING_MAIN_BICEP_BASE64" | base64 -d > deployment-setting/main.bicep

# Verify files
if [ ! -f "nested/deployment-setting.bicep" ] || [ ! -s "nested/deployment-setting.bicep" ]; then
    echo "Error: Failed to create nested/deployment-setting.bicep"
    exit 1
fi
if [ ! -f "deployment-setting/main.bicep" ] || [ ! -s "deployment-setting/main.bicep" ]; then
    echo "Error: Failed to create deployment-setting/main.bicep"
    exit 1
fi

echo "Bicep files created successfully"
echo "nested/deployment-setting.bicep size: $(wc -c < nested/deployment-setting.bicep) bytes"
echo "deployment-setting/main.bicep size: $(wc -c < deployment-setting/main.bicep) bytes"

# Parse deployment operations
IFS=',' read -ra OPERATIONS <<< "$DEPLOYMENT_OPERATIONS"
echo "Deployment operations: ${OPERATIONS[@]}"

OPERATIONS_JSON="["
for i in "${!OPERATIONS[@]}"; do
    if [ $i -gt 0 ]; then
        OPERATIONS_JSON+=","
    fi
    OPERATIONS_JSON+="\"${OPERATIONS[$i]}\""
done
OPERATIONS_JSON+="]"

# Convert boolean values
USE_SHARED_KEYVAULT_JSON=$(echo "$USE_SHARED_KEYVAULT" | tr '[:upper:]' '[:lower:]')
if [ "$USE_SHARED_KEYVAULT_JSON" = "true" ] || [ "$USE_SHARED_KEYVAULT_JSON" = "1" ]; then
    USE_SHARED_KEYVAULT_JSON="true"
else
    USE_SHARED_KEYVAULT_JSON="false"
fi

NEED_ARB_SECRET_JSON=$(echo "$NEED_ARB_SECRET" | tr '[:upper:]' '[:lower:]')
if [ "$NEED_ARB_SECRET_JSON" = "true" ] || [ "$NEED_ARB_SECRET_JSON" = "1" ]; then
    NEED_ARB_SECRET_JSON="true"
else
    NEED_ARB_SECRET_JSON="false"
fi

# Validate DEPLOYMENT_SETTINGS is valid JSON
if ! echo "$DEPLOYMENT_SETTINGS" | jq empty 2>/dev/null; then
    echo "Error: DEPLOYMENT_SETTINGS is not valid JSON"
    exit 1
fi

# Create parameter file
PARAM_FILE="deployment-params.json"
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
    "clusterName": {
      "value": "$CLUSTER_NAME"
    },
    "clusterADName": {
      "value": "$CLUSTER_AD_NAME"
    },
    "operationType": {
      "value": "$OPERATION_TYPE"
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

if ! jq empty "$PARAM_FILE" 2>/dev/null; then
    echo "Error: Generated parameter file is not valid JSON"
    cat "$PARAM_FILE"
    exit 1
fi

echo "Parameter file created and validated"

# Check if deployment-settings resource already exists
DEPLOYMENT_SETTINGS_RESOURCE_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.AzureStackHCI/clusters/$CLUSTER_NAME/deploymentSettings/default"
echo "Checking resource: $DEPLOYMENT_SETTINGS_RESOURCE_ID"

if az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" >/dev/null 2>&1; then
    PROVISIONING_STATE=$(az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "properties.provisioningState" --output tsv 2>/dev/null)
    DEPLOYMENT_MODE=$(az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "properties.deploymentMode" --output tsv 2>/dev/null)

    echo "Existing resource — Mode: $DEPLOYMENT_MODE, State: $PROVISIONING_STATE"

    if [ "$DEPLOYMENT_MODE" = "Validate" ]; then
        echo "Removing stale Validate-mode resource..."
        if az resource delete --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --only-show-errors; then
            echo "Validation resource deleted. Proceeding with deployment..."
        else
            echo "Failed to delete validation resource."
            exit 1
        fi
    elif [ "$DEPLOYMENT_MODE" = "Deploy" ] && [ "$PROVISIONING_STATE" = "Succeeded" ]; then
        echo "Deploy+Succeeded already exists. Skipping deployment."
        cat > $AZ_SCRIPTS_OUTPUT_PATH << EOF
{
  "status": "success",
  "message": "Deployment already succeeded - skipped",
  "operations": $OPERATIONS_JSON
}
EOF
        exit 0
    elif [ "$DEPLOYMENT_MODE" = "Deploy" ] && [ "$PROVISIONING_STATE" != "Succeeded" ]; then
        echo "Deploy mode in state: $PROVISIONING_STATE (not Succeeded). Failing."
        exit 1
    else
        echo "Unknown deployment mode: $DEPLOYMENT_MODE. Failing."
        exit 1
    fi
else
    echo "No existing deploymentSettings resource. Proceeding with deployment..."
fi

# Execute Bicep deployment
DEPLOYMENT_NAME="hci-deployment-$(date +%s)"
echo "Starting deployment: $DEPLOYMENT_NAME"

az deployment group create \
    --resource-group "$RESOURCE_GROUP_NAME" \
    --name "$DEPLOYMENT_NAME" \
    --template-file "nested/deployment-setting.bicep" \
    --parameters "@$PARAM_FILE" \
    --verbose

DEPLOYMENT_STATUS=$?

if [ $DEPLOYMENT_STATUS -eq 0 ]; then
    echo "Deployment completed successfully"
else
    echo "Deployment failed with status: $DEPLOYMENT_STATUS"
    az deployment group show \
        --resource-group "$RESOURCE_GROUP_NAME" \
        --name "$DEPLOYMENT_NAME" \
        --query "properties.error" \
        --output json 2>/dev/null || true
    exit $DEPLOYMENT_STATUS
fi

# Clean up temporary files
rm -f "$PARAM_FILE"
rm -rf "nested" "deployment-setting"

echo "HCI deployment completed successfully!"

# Set output for Bicep usage
cat > $AZ_SCRIPTS_OUTPUT_PATH << EOF
{
  "status": "success",
  "message": "Deployment completed successfully",
  "operations": $OPERATIONS_JSON
}
EOF
