#!/bin/bash
# ==============================================================================
# HCI Deployment Script - Idempotency & Cleanup
# ==============================================================================
# This script handles:
#   1. Cleanup of stale deploymentSettings resources (e.g., leftover Validate mode)
#   2. Idempotency check: skip if Deploy+Succeeded already exists
#
# The actual deploymentSettings resource creation is handled by a native Bicep
# module call in main.bicep, bypassing ACI container memory limits.
# ==============================================================================

set -e

echo "=== HCI Deployment Script - Idempotency & Cleanup ==="

# Validate required environment variables
if [ -z "$SUBSCRIPTION_ID" ] || [ -z "$RESOURCE_GROUP_NAME" ] || [ -z "$CLUSTER_NAME" ]; then
    echo "Error: Required environment variables are missing (SUBSCRIPTION_ID, RESOURCE_GROUP_NAME, CLUSTER_NAME)"
    exit 1
fi

# Set subscription context
echo "Setting subscription to: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Construct the resource ID for deploymentSettings
DEPLOYMENT_SETTINGS_RESOURCE_ID="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.AzureStackHCI/clusters/$CLUSTER_NAME/deploymentSettings/default"
echo "Checking resource: $DEPLOYMENT_SETTINGS_RESOURCE_ID"

# Check if the deploymentSettings resource already exists
if az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" >/dev/null 2>&1; then
    PROVISIONING_STATE=$(az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "properties.provisioningState" --output tsv 2>/dev/null)
    DEPLOYMENT_MODE=$(az resource show --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --query "properties.deploymentMode" --output tsv 2>/dev/null)

    echo "Existing resource — Mode: $DEPLOYMENT_MODE, State: $PROVISIONING_STATE"

    if [ "$DEPLOYMENT_MODE" = "Validate" ]; then
        echo "Removing stale Validate-mode resource..."
        if az resource delete --ids "$DEPLOYMENT_SETTINGS_RESOURCE_ID" --only-show-errors; then
            echo "Validation resource deleted. Bicep module will recreate."
        else
            echo "Failed to delete validation resource."
            exit 1
        fi
    elif [ "$DEPLOYMENT_MODE" = "Deploy" ] && [ "$PROVISIONING_STATE" = "Succeeded" ]; then
        echo "Deploy+Succeeded — Bicep module will handle idempotent re-apply."
    elif [ "$DEPLOYMENT_MODE" = "Deploy" ] && [ "$PROVISIONING_STATE" != "Succeeded" ]; then
        echo "Deploy mode in state: $PROVISIONING_STATE (not Succeeded). Failing."
        exit 1
    else
        echo "Unknown deployment mode: $DEPLOYMENT_MODE. Failing."
        exit 1
    fi
else
    echo "No existing deploymentSettings resource. Bicep module will create."
fi

echo "=== Script completed — cleanup done ==="

# Set output for Bicep deployment script resource
cat > $AZ_SCRIPTS_OUTPUT_PATH << EOF
{
  "status": "success",
  "message": "Idempotency check and cleanup completed"
}
EOF
